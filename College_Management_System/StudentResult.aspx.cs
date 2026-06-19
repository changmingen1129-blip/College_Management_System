using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class StudentResult : System.Web.UI.Page
    {
        private readonly string connectionString =
        ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["StudentID"] == null)
            {
                Response.Redirect("StudentLogin.aspx");
                return;
            }

            int studentID;

            if (!int.TryParse(Session["StudentID"].ToString(), out studentID))
            {
                Session.Clear();
                Session.Abandon();

                Response.Redirect("StudentLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStudentInformation(studentID);
                LoadStudentResults(studentID);
            }
        }

        private void LoadStudentInformation(int studentID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    s.StudentID,
                    s.StudentName,
                    s.Email,
                    p.ProgrammeCode,
                    p.ProgrammeName
                FROM Student s
                INNER JOIN Programme p
                    ON s.ProgrammeID = p.ProgrammeID
                WHERE s.StudentID = @StudentID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@StudentID",
                        SqlDbType.Int
                    ).Value = studentID;

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblStudentID.Text =
                                reader["StudentID"].ToString();

                            lblStudentName.Text =
                                reader["StudentName"].ToString();

                            lblEmail.Text =
                                reader["Email"].ToString();

                            lblProgramme.Text =
                                reader["ProgrammeCode"].ToString()
                                + " - "
                                + reader["ProgrammeName"].ToString();
                        }
                        else
                        {
                            lblStudentID.Text = "-";
                            lblStudentName.Text = "-";
                            lblEmail.Text = "-";
                            lblProgramme.Text = "-";
                        }
                    }
                }
            }
        }

        private void LoadStudentResults(int studentID)
        {
            DataTable assessmentTable =
                GetAssessmentDetails(studentID);

            gvAssessmentDetails.DataSource = assessmentTable;
            gvAssessmentDetails.DataBind();

            DataTable courseResultTable =
                CreateCourseResultTable(assessmentTable);

            gvCourseResults.DataSource = courseResultTable;
            gvCourseResults.DataBind();

            CalculateOverallSummary(courseResultTable);
        }

        private DataTable GetAssessmentDetails(int studentID)
        {
            DataTable table = new DataTable();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    c.CourseID,
                    c.CourseCode,
                    c.CourseName,
                    c.CreditHours,
                    a.AssessmentID,
                    a.AssessmentName,
                    sm.MarkObtained,
                    a.MaxMark,
                    a.Weightage,

                    CAST
                    (
                        CASE
                            WHEN a.MaxMark = 0 THEN 0
                            ELSE
                                (sm.MarkObtained / a.MaxMark) * 100
                        END
                        AS DECIMAL(6,2)
                    ) AS AssessmentPercentage,

                    CAST
                    (
                        CASE
                            WHEN a.MaxMark = 0 THEN 0
                            ELSE
                                (sm.MarkObtained / a.MaxMark)
                                * a.Weightage
                        END
                        AS DECIMAL(6,2)
                    ) AS WeightedScore,

                    ISNULL(sm.Remarks, '-') AS Remarks

                FROM StudentMark sm

                INNER JOIN Assessment a
                    ON sm.AssessmentID = a.AssessmentID

                INNER JOIN Course c
                    ON a.CourseID = c.CourseID

                INNER JOIN Enrolment e
                    ON e.CourseID = c.CourseID
                   AND e.StudentID = sm.StudentID

                WHERE sm.StudentID = @StudentID
                  AND ISNULL(e.Status, '') IN
                      ('Enrolled', 'Approved', 'Active')

                ORDER BY
                    c.CourseCode,
                    a.AssessmentName";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@StudentID",
                        SqlDbType.Int
                    ).Value = studentID;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(table);
                    }
                }
            }

            return table;
        }

        private DataTable CreateCourseResultTable(
            DataTable assessmentTable)
        {
            DataTable resultTable = new DataTable();

            resultTable.Columns.Add(
                "CourseID",
                typeof(int)
            );

            resultTable.Columns.Add(
                "CourseCode",
                typeof(string)
            );

            resultTable.Columns.Add(
                "CourseName",
                typeof(string)
            );

            resultTable.Columns.Add(
                "CreditHours",
                typeof(int)
            );

            resultTable.Columns.Add(
                "FinalPercentage",
                typeof(decimal)
            );

            resultTable.Columns.Add(
                "Grade",
                typeof(string)
            );

            resultTable.Columns.Add(
                "GradePoint",
                typeof(decimal)
            );

            resultTable.Columns.Add(
                "ResultStatus",
                typeof(string)
            );

            Dictionary<int, CourseCalculation> courseCalculations =
                new Dictionary<int, CourseCalculation>();

            foreach (DataRow row in assessmentTable.Rows)
            {
                int courseID =
                    Convert.ToInt32(row["CourseID"]);

                if (!courseCalculations.ContainsKey(courseID))
                {
                    CourseCalculation calculation =
                        new CourseCalculation();

                    calculation.CourseID = courseID;

                    calculation.CourseCode =
                        row["CourseCode"].ToString();

                    calculation.CourseName =
                        row["CourseName"].ToString();

                    calculation.CreditHours =
                        Convert.ToInt32(row["CreditHours"]);

                    calculation.FinalPercentage = 0;

                    courseCalculations.Add(
                        courseID,
                        calculation
                    );
                }

                decimal weightedScore =
                    Convert.ToDecimal(
                        row["WeightedScore"]
                    );

                courseCalculations[courseID]
                    .FinalPercentage += weightedScore;
            }

            foreach (
                KeyValuePair<int, CourseCalculation> item
                in courseCalculations)
            {
                CourseCalculation course = item.Value;

                decimal finalPercentage =
                    Math.Round(
                        course.FinalPercentage,
                        2
                    );

                string grade =
                    GetGrade(finalPercentage);

                decimal gradePoint =
                    GetGradePoint(finalPercentage);

                string resultStatus =
                    finalPercentage >= 50
                        ? "Pass"
                        : "Fail";

                DataRow resultRow =
                    resultTable.NewRow();

                resultRow["CourseID"] =
                    course.CourseID;

                resultRow["CourseCode"] =
                    course.CourseCode;

                resultRow["CourseName"] =
                    course.CourseName;

                resultRow["CreditHours"] =
                    course.CreditHours;

                resultRow["FinalPercentage"] =
                    finalPercentage;

                resultRow["Grade"] =
                    grade;

                resultRow["GradePoint"] =
                    gradePoint;

                resultRow["ResultStatus"] =
                    resultStatus;

                resultTable.Rows.Add(resultRow);
            }

            return resultTable;
        }

        private void CalculateOverallSummary(
            DataTable courseResultTable)
        {
            int totalCourses =
                courseResultTable.Rows.Count;

            lblTotalCourses.Text =
                totalCourses.ToString();

            if (totalCourses == 0)
            {
                lblGPA.Text = "0.00";
                lblCGPA.Text = "0.00";
                lblOverallStatus.Text = "No Result";
                return;
            }

            decimal totalGradePoints = 0;
            int totalCreditHours = 0;
            int failedCourses = 0;

            foreach (DataRow row in courseResultTable.Rows)
            {
                int creditHours =
                    Convert.ToInt32(
                        row["CreditHours"]
                    );

                decimal gradePoint =
                    Convert.ToDecimal(
                        row["GradePoint"]
                    );

                totalGradePoints +=
                    gradePoint * creditHours;

                totalCreditHours += creditHours;

                if (row["ResultStatus"].ToString() == "Fail")
                {
                    failedCourses++;
                }
            }

            decimal gpa = 0;

            if (totalCreditHours > 0)
            {
                gpa =
                    totalGradePoints
                    / totalCreditHours;
            }

            gpa = Math.Round(gpa, 2);

            lblGPA.Text =
                gpa.ToString("0.00");

            lblCGPA.Text =
                gpa.ToString("0.00");

            if (failedCourses == 0)
            {
                lblOverallStatus.Text = "Good Standing";
            }
            else
            {
                lblOverallStatus.Text =
                    failedCourses
                    + " Course(s) Failed";
            }
        }

        private string GetGrade(decimal percentage)
        {
            if (percentage >= 80)
            {
                return "A";
            }

            if (percentage >= 70)
            {
                return "B";
            }

            if (percentage >= 60)
            {
                return "C";
            }

            if (percentage >= 50)
            {
                return "D";
            }

            return "F";
        }

        private decimal GetGradePoint(decimal percentage)
        {
            if (percentage >= 80)
            {
                return 4.00m;
            }

            if (percentage >= 70)
            {
                return 3.00m;
            }

            if (percentage >= 60)
            {
                return 2.00m;
            }

            if (percentage >= 50)
            {
                return 1.00m;
            }

            return 0.00m;
        }

        public string GetGradeClass(string grade)
        {
            switch (grade)
            {
                case "A":
                    return "grade-a";

                case "B":
                    return "grade-b";

                case "C":
                    return "grade-c";

                case "D":
                    return "grade-d";

                default:
                    return "grade-f";
            }
        }

        public string GetStatusClass(string status)
        {
            if (status == "Pass")
            {
                return "status-pass";
            }

            return "status-fail";
        }

        private class CourseCalculation
        {
            public int CourseID { get; set; }

            public string CourseCode { get; set; }

            public string CourseName { get; set; }

            public int CreditHours { get; set; }

            public decimal FinalPercentage { get; set; }
        }
    }


}
