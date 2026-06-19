using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace College_Management_System
{
    public partial class LecturerMarks : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["LecturerID"] == null)
            {
                Response.Redirect("LecturerLogin.aspx");
                return;
            }

            int lecturerID;

            if (!int.TryParse(Session["LecturerID"].ToString(), out lecturerID))
            {
                Session.Clear();
                Session.Abandon();

                Response.Redirect("LecturerLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAssignedCourses();
                LoadAssessments();
                LoadMarksReport();
                ResetSummary();
            }
        }

        private int GetLecturerID()
        {
            return Convert.ToInt32(Session["LecturerID"]);
        }

        // =========================================================
        // LOAD ASSIGNED COURSES
        // =========================================================
        private void LoadAssignedCourses()
        {
            int lecturerID = GetLecturerID();
            DataTable courseTable = new DataTable();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT DISTINCT
                        c.CourseID,
                        c.CourseCode + ' - ' + c.CourseName AS CourseDisplay
                    FROM LecturerCourse lc
                    INNER JOIN Course c
                        ON lc.CourseID = c.CourseID
                    WHERE lc.LecturerID = @LecturerID
                    ORDER BY CourseDisplay";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(courseTable);
                    }
                }
            }

            ddlCreateCourse.DataSource = courseTable;
            ddlCreateCourse.DataTextField = "CourseDisplay";
            ddlCreateCourse.DataValueField = "CourseID";
            ddlCreateCourse.DataBind();

            ddlCreateCourse.Items.Insert(
                0,
                new ListItem("-- Select Course --", "0")
            );

            ddlCourse.DataSource = courseTable;
            ddlCourse.DataTextField = "CourseDisplay";
            ddlCourse.DataValueField = "CourseID";
            ddlCourse.DataBind();

            ddlCourse.Items.Insert(
                0,
                new ListItem("-- Select Course --", "0")
            );
        }

        // =========================================================
        // LOAD ASSESSMENTS
        // =========================================================
        private void LoadAssessments()
        {
            ddlAssessment.Items.Clear();

            ddlAssessment.Items.Add(
                new ListItem("-- Select Assessment --", "0")
            );

            if (ddlCourse.SelectedValue == "0")
            {
                return;
            }

            int courseID;
            int lecturerID = GetLecturerID();

            if (!int.TryParse(ddlCourse.SelectedValue, out courseID))
            {
                return;
            }

            DataTable assessmentTable = new DataTable();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT
                        AssessmentID,
                        AssessmentName
                        + ' | Max: '
                        + CONVERT(VARCHAR(20), MaxMark)
                        + ' | Weight: '
                        + CONVERT(VARCHAR(20), Weightage)
                        + '%' AS AssessmentDisplay
                    FROM Assessment
                    WHERE CourseID = @CourseID
                      AND LecturerID = @LecturerID
                    ORDER BY CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@CourseID",
                        SqlDbType.Int
                    ).Value = courseID;

                    cmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(assessmentTable);
                    }
                }
            }

            ddlAssessment.DataSource = assessmentTable;
            ddlAssessment.DataTextField = "AssessmentDisplay";
            ddlAssessment.DataValueField = "AssessmentID";
            ddlAssessment.DataBind();

            ddlAssessment.Items.Insert(
                0,
                new ListItem("-- Select Assessment --", "0")
            );
        }

        // =========================================================
        // CREATE ASSESSMENT
        // =========================================================
        protected void btnCreateAssessment_Click(
            object sender,
            EventArgs e)
        {
            HideMessages();

            if (!Page.IsValid)
            {
                return;
            }

            int courseID;
            decimal maxMark;
            decimal weightage;

            if (!int.TryParse(
                    ddlCreateCourse.SelectedValue,
                    out courseID) ||
                courseID == 0)
            {
                ShowCreateMessage(
                    "Please select a valid course.",
                    false
                );
                return;
            }

            string assessmentName = txtAssessmentName.Text.Trim();

            if (string.IsNullOrWhiteSpace(assessmentName))
            {
                ShowCreateMessage(
                    "Assessment name is required.",
                    false
                );
                return;
            }

            if (assessmentName.Length > 100)
            {
                ShowCreateMessage(
                    "Assessment name cannot exceed 100 characters.",
                    false
                );
                return;
            }

            if (!decimal.TryParse(
                    txtMaxMark.Text.Trim(),
                    out maxMark) ||
                maxMark <= 0 ||
                maxMark > 999.99m)
            {
                ShowCreateMessage(
                    "Maximum mark must be between 0.01 and 999.99.",
                    false
                );
                return;
            }

            if (!decimal.TryParse(
                    txtWeightage.Text.Trim(),
                    out weightage) ||
                weightage <= 0 ||
                weightage > 100)
            {
                ShowCreateMessage(
                    "Weightage must be between 0.01 and 100.",
                    false
                );
                return;
            }

            int lecturerID = GetLecturerID();

            if (!LecturerOwnsCourse(lecturerID, courseID))
            {
                ShowCreateMessage(
                    "You are not assigned to this course.",
                    false
                );
                return;
            }

            if (AssessmentAlreadyExists(
                    courseID,
                    lecturerID,
                    assessmentName))
            {
                ShowCreateMessage(
                    "An assessment with this name already exists for the selected course.",
                    false
                );
                return;
            }

            decimal currentWeightage =
                GetCourseTotalWeightage(lecturerID, courseID);

            if (currentWeightage + weightage > 100)
            {
                ShowCreateMessage(
                    "The assessment cannot be created because the total course weightage would exceed 100%. Current total: "
                    + currentWeightage.ToString("0.##")
                    + "%.",
                    false
                );
                return;
            }

            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO Assessment
                        (
                            CourseID,
                            LecturerID,
                            AssessmentName,
                            MaxMark,
                            Weightage,
                            CreatedAt
                        )
                        VALUES
                        (
                            @CourseID,
                            @LecturerID,
                            @AssessmentName,
                            @MaxMark,
                            @Weightage,
                            GETDATE()
                        )";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add(
                            "@CourseID",
                            SqlDbType.Int
                        ).Value = courseID;

                        cmd.Parameters.Add(
                            "@LecturerID",
                            SqlDbType.Int
                        ).Value = lecturerID;

                        cmd.Parameters.Add(
                            "@AssessmentName",
                            SqlDbType.VarChar,
                            100
                        ).Value = assessmentName;

                        SqlParameter maxMarkParameter =
                            cmd.Parameters.Add(
                                "@MaxMark",
                                SqlDbType.Decimal
                            );

                        maxMarkParameter.Precision = 5;
                        maxMarkParameter.Scale = 2;
                        maxMarkParameter.Value = maxMark;

                        SqlParameter weightageParameter =
                            cmd.Parameters.Add(
                                "@Weightage",
                                SqlDbType.Decimal
                            );

                        weightageParameter.Precision = 5;
                        weightageParameter.Scale = 2;
                        weightageParameter.Value = weightage;

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowCreateMessage(
                    "Assessment created successfully.",
                    true
                );

                txtAssessmentName.Text = "";
                txtMaxMark.Text = "";
                txtWeightage.Text = "";

                ddlCourse.SelectedValue = courseID.ToString();

                LoadAssessments();
                LoadMarksReport();
            }
            catch (Exception ex)
            {
                ShowCreateMessage(
                    "Assessment could not be created. " + ex.Message,
                    false
                );
            }
        }

        // =========================================================
        // COURSE DROPDOWN CHANGED
        // =========================================================
        protected void ddlCourse_SelectedIndexChanged(
            object sender,
            EventArgs e)
        {
            HideMessages();

            LoadAssessments();

            gvStudents.DataSource = null;
            gvStudents.DataBind();

            btnSaveMarks.Visible = false;

            ResetSummary();
        }

        // =========================================================
        // LOAD STUDENTS BUTTON
        // =========================================================
        protected void btnLoadStudents_Click(
            object sender,
            EventArgs e)
        {
            HideMessages();

            int courseID;
            int assessmentID;

            if (!int.TryParse(
                    ddlCourse.SelectedValue,
                    out courseID) ||
                courseID == 0)
            {
                ShowMarksMessage(
                    "Please select a course.",
                    false
                );
                return;
            }

            if (!int.TryParse(
                    ddlAssessment.SelectedValue,
                    out assessmentID) ||
                assessmentID == 0)
            {
                ShowMarksMessage(
                    "Please select an assessment.",
                    false
                );
                return;
            }

            if (!AssessmentBelongsToLecturer(
                    assessmentID,
                    courseID,
                    GetLecturerID()))
            {
                ShowMarksMessage(
                    "The selected assessment is invalid.",
                    false
                );
                return;
            }

            LoadStudents(courseID, assessmentID);
            LoadAssessmentSummary(assessmentID);
        }

        // =========================================================
        // LOAD ENROLLED STUDENTS
        // =========================================================
        private void LoadStudents(
            int courseID,
            int assessmentID)
        {
            DataTable studentTable = new DataTable();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT DISTINCT
                        s.StudentID,
                        s.StudentName,
                        s.Email,
                        CASE
                            WHEN sm.MarkID IS NULL THEN ''
                            ELSE CONVERT(VARCHAR(30), sm.MarkObtained)
                        END AS MarkObtained,
                        ISNULL(sm.Remarks, '') AS Remarks
                    FROM Enrolment e
                    INNER JOIN Student s
                        ON e.StudentID = s.StudentID
                    LEFT JOIN StudentMark sm
                        ON sm.StudentID = s.StudentID
                       AND sm.AssessmentID = @AssessmentID
                    WHERE e.CourseID = @CourseID
                      AND ISNULL(e.Status, '') IN
                          ('Enrolled', 'Approved', 'Active')
                    ORDER BY s.StudentName";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@CourseID",
                        SqlDbType.Int
                    ).Value = courseID;

                    cmd.Parameters.Add(
                        "@AssessmentID",
                        SqlDbType.Int
                    ).Value = assessmentID;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(studentTable);
                    }
                }
            }

            gvStudents.DataSource = studentTable;
            gvStudents.DataBind();

            btnSaveMarks.Visible = studentTable.Rows.Count > 0;

            if (studentTable.Rows.Count == 0)
            {
                ShowMarksMessage(
                    "No active enrolled students were found for this course.",
                    false
                );
            }
        }

        // =========================================================
        // SAVE OR UPDATE MARKS
        // =========================================================
        protected void btnSaveMarks_Click(
            object sender,
            EventArgs e)
        {
            HideMessages();

            int courseID;
            int assessmentID;

            if (!int.TryParse(
                    ddlCourse.SelectedValue,
                    out courseID) ||
                courseID == 0)
            {
                ShowMarksMessage(
                    "Please select a course.",
                    false
                );
                return;
            }

            if (!int.TryParse(
                    ddlAssessment.SelectedValue,
                    out assessmentID) ||
                assessmentID == 0)
            {
                ShowMarksMessage(
                    "Please select an assessment.",
                    false
                );
                return;
            }

            decimal maxMark = GetAssessmentMaxMark(
                assessmentID,
                courseID,
                GetLecturerID()
            );

            if (maxMark <= 0)
            {
                ShowMarksMessage(
                    "Unable to find the selected assessment.",
                    false
                );
                return;
            }

            int savedCount = 0;
            int skippedCount = 0;

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                con.Open();

                using (SqlTransaction transaction =
                    con.BeginTransaction())
                {
                    try
                    {
                        foreach (GridViewRow row in gvStudents.Rows)
                        {
                            int studentID = Convert.ToInt32(
                                gvStudents.DataKeys[
                                    row.RowIndex
                                ].Value
                            );

                            TextBox txtStudentMark =
                                row.FindControl("txtStudentMark")
                                as TextBox;

                            TextBox txtRemarks =
                                row.FindControl("txtRemarks")
                                as TextBox;

                            if (txtStudentMark == null ||
                                string.IsNullOrWhiteSpace(
                                    txtStudentMark.Text))
                            {
                                skippedCount++;
                                continue;
                            }

                            decimal markObtained;

                            if (!decimal.TryParse(
                                    txtStudentMark.Text.Trim(),
                                    out markObtained))
                            {
                                transaction.Rollback();

                                ShowMarksMessage(
                                    "One or more marks are invalid. Enter numbers only.",
                                    false
                                );
                                return;
                            }

                            if (markObtained < 0 ||
                                markObtained > maxMark)
                            {
                                transaction.Rollback();

                                ShowMarksMessage(
                                    "Every mark must be between 0 and "
                                    + maxMark.ToString("0.##")
                                    + ".",
                                    false
                                );
                                return;
                            }

                            string remarks =
                                txtRemarks == null
                                    ? ""
                                    : txtRemarks.Text.Trim();

                            SaveOrUpdateStudentMark(
                                con,
                                transaction,
                                assessmentID,
                                studentID,
                                markObtained,
                                remarks
                            );

                            savedCount++;
                        }

                        transaction.Commit();
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();

                        ShowMarksMessage(
                            "Marks could not be saved. " + ex.Message,
                            false
                        );
                        return;
                    }
                }
            }

            ShowMarksMessage(
                savedCount
                + " mark record(s) saved successfully. "
                + skippedCount
                + " blank record(s) were skipped.",
                true
            );

            LoadStudents(courseID, assessmentID);
            LoadAssessmentSummary(assessmentID);
            LoadMarksReport();
        }

        // =========================================================
        // INSERT OR UPDATE ONE STUDENT MARK
        // =========================================================
        private void SaveOrUpdateStudentMark(
            SqlConnection con,
            SqlTransaction transaction,
            int assessmentID,
            int studentID,
            decimal markObtained,
            string remarks)
        {
            string query = @"
                IF EXISTS
                (
                    SELECT 1
                    FROM StudentMark
                    WHERE AssessmentID = @AssessmentID
                      AND StudentID = @StudentID
                )
                BEGIN
                    UPDATE StudentMark
                    SET
                        MarkObtained = @MarkObtained,
                        Remarks = @Remarks
                    WHERE AssessmentID = @AssessmentID
                      AND StudentID = @StudentID
                END
                ELSE
                BEGIN
                    INSERT INTO StudentMark
                    (
                        AssessmentID,
                        StudentID,
                        MarkObtained,
                        Remarks,
                        CreatedAt
                    )
                    VALUES
                    (
                        @AssessmentID,
                        @StudentID,
                        @MarkObtained,
                        @Remarks,
                        GETDATE()
                    )
                END";

            using (SqlCommand cmd =
                new SqlCommand(query, con, transaction))
            {
                cmd.Parameters.Add(
                    "@AssessmentID",
                    SqlDbType.Int
                ).Value = assessmentID;

                cmd.Parameters.Add(
                    "@StudentID",
                    SqlDbType.Int
                ).Value = studentID;

                SqlParameter markParameter =
                    cmd.Parameters.Add(
                        "@MarkObtained",
                        SqlDbType.Decimal
                    );

                markParameter.Precision = 5;
                markParameter.Scale = 2;
                markParameter.Value = markObtained;

                cmd.Parameters.Add(
                    "@Remarks",
                    SqlDbType.VarChar,
                    255
                ).Value =
                    string.IsNullOrWhiteSpace(remarks)
                        ? (object)DBNull.Value
                        : remarks;

                cmd.ExecuteNonQuery();
            }
        }

        // =========================================================
        // ASSESSMENT PERFORMANCE SUMMARY
        // =========================================================
        private void LoadAssessmentSummary(int assessmentID)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT
                        COUNT(*) AS TotalStudents,
                        ISNULL(AVG(MarkObtained), 0) AS AverageMark,
                        ISNULL(MAX(MarkObtained), 0) AS HighestMark,
                        ISNULL(MIN(MarkObtained), 0) AS LowestMark
                    FROM StudentMark
                    WHERE AssessmentID = @AssessmentID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@AssessmentID",
                        SqlDbType.Int
                    ).Value = assessmentID;

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblTotalStudents.Text =
                                Convert.ToInt32(
                                    reader["TotalStudents"]
                                ).ToString();

                            lblAverageMark.Text =
                                Convert.ToDecimal(
                                    reader["AverageMark"]
                                ).ToString("0.00");

                            lblHighestMark.Text =
                                Convert.ToDecimal(
                                    reader["HighestMark"]
                                ).ToString("0.00");

                            lblLowestMark.Text =
                                Convert.ToDecimal(
                                    reader["LowestMark"]
                                ).ToString("0.00");
                        }
                    }
                }
            }
        }

        // =========================================================
        // LOAD ALL SAVED MARKS
        // =========================================================
        private void LoadMarksReport()
        {
            int lecturerID = GetLecturerID();
            DataTable marksTable = new DataTable();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT
                        c.CourseCode,
                        c.CourseName,
                        a.AssessmentName,
                        s.StudentName,
                        sm.MarkObtained,
                        a.MaxMark,

                        CAST
                        (
                            CASE
                                WHEN a.MaxMark = 0 THEN 0
                                ELSE
                                    (sm.MarkObtained / a.MaxMark) * 100
                            END
                            AS DECIMAL(6,2)
                        ) AS Percentage,

                        a.Weightage,

                        CASE
                            WHEN
                                (sm.MarkObtained /
                                NULLIF(a.MaxMark, 0)) * 100 >= 80
                                THEN 'A'

                            WHEN
                                (sm.MarkObtained /
                                NULLIF(a.MaxMark, 0)) * 100 >= 70
                                THEN 'B'

                            WHEN
                                (sm.MarkObtained /
                                NULLIF(a.MaxMark, 0)) * 100 >= 60
                                THEN 'C'

                            WHEN
                                (sm.MarkObtained /
                                NULLIF(a.MaxMark, 0)) * 100 >= 50
                                THEN 'D'

                            ELSE 'F'
                        END AS Grade,

                        ISNULL(sm.Remarks, '-') AS Remarks

                    FROM StudentMark sm

                    INNER JOIN Assessment a
                        ON sm.AssessmentID = a.AssessmentID

                    INNER JOIN Course c
                        ON a.CourseID = c.CourseID

                    INNER JOIN Student s
                        ON sm.StudentID = s.StudentID

                    WHERE a.LecturerID = @LecturerID

                    ORDER BY
                        c.CourseCode,
                        a.AssessmentName,
                        s.StudentName";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(marksTable);
                    }
                }
            }

            gvMarksReport.DataSource = marksTable;
            gvMarksReport.DataBind();
        }

        // =========================================================
        // VALIDATION METHODS
        // =========================================================
        private bool LecturerOwnsCourse(
            int lecturerID,
            int courseID)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT COUNT(*)
                    FROM LecturerCourse
                    WHERE LecturerID = @LecturerID
                      AND CourseID = @CourseID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

                    cmd.Parameters.Add(
                        "@CourseID",
                        SqlDbType.Int
                    ).Value = courseID;

                    con.Open();

                    return Convert.ToInt32(
                        cmd.ExecuteScalar()
                    ) > 0;
                }
            }
        }

        private bool AssessmentBelongsToLecturer(
            int assessmentID,
            int courseID,
            int lecturerID)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT COUNT(*)
                    FROM Assessment
                    WHERE AssessmentID = @AssessmentID
                      AND CourseID = @CourseID
                      AND LecturerID = @LecturerID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@AssessmentID",
                        SqlDbType.Int
                    ).Value = assessmentID;

                    cmd.Parameters.Add(
                        "@CourseID",
                        SqlDbType.Int
                    ).Value = courseID;

                    cmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

                    con.Open();

                    return Convert.ToInt32(
                        cmd.ExecuteScalar()
                    ) > 0;
                }
            }
        }

        private bool AssessmentAlreadyExists(
            int courseID,
            int lecturerID,
            string assessmentName)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT COUNT(*)
                    FROM Assessment
                    WHERE CourseID = @CourseID
                      AND LecturerID = @LecturerID
                      AND AssessmentName = @AssessmentName";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@CourseID",
                        SqlDbType.Int
                    ).Value = courseID;

                    cmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

                    cmd.Parameters.Add(
                        "@AssessmentName",
                        SqlDbType.VarChar,
                        100
                    ).Value = assessmentName;

                    con.Open();

                    return Convert.ToInt32(
                        cmd.ExecuteScalar()
                    ) > 0;
                }
            }
        }

        private decimal GetAssessmentMaxMark(
            int assessmentID,
            int courseID,
            int lecturerID)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT MaxMark
                    FROM Assessment
                    WHERE AssessmentID = @AssessmentID
                      AND CourseID = @CourseID
                      AND LecturerID = @LecturerID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@AssessmentID",
                        SqlDbType.Int
                    ).Value = assessmentID;

                    cmd.Parameters.Add(
                        "@CourseID",
                        SqlDbType.Int
                    ).Value = courseID;

                    cmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

                    con.Open();

                    object result = cmd.ExecuteScalar();

                    if (result == null ||
                        result == DBNull.Value)
                    {
                        return 0;
                    }

                    return Convert.ToDecimal(result);
                }
            }
        }

        private decimal GetCourseTotalWeightage(
            int lecturerID,
            int courseID)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT ISNULL(SUM(Weightage), 0)
                    FROM Assessment
                    WHERE LecturerID = @LecturerID
                      AND CourseID = @CourseID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

                    cmd.Parameters.Add(
                        "@CourseID",
                        SqlDbType.Int
                    ).Value = courseID;

                    con.Open();

                    return Convert.ToDecimal(
                        cmd.ExecuteScalar()
                    );
                }
            }
        }

        // =========================================================
        // DISPLAY HELPERS
        // =========================================================
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

        private void ResetSummary()
        {
            lblTotalStudents.Text = "0";
            lblAverageMark.Text = "0.00";
            lblHighestMark.Text = "0.00";
            lblLowestMark.Text = "0.00";
        }

        private void HideMessages()
        {
            lblCreateMessage.Visible = false;
            lblMarksMessage.Visible = false;
        }

        private void ShowCreateMessage(
            string message,
            bool success)
        {
            lblCreateMessage.Visible = true;
            lblCreateMessage.Text = message;

            lblCreateMessage.CssClass =
                success
                    ? "message-label alert alert-success"
                    : "message-label alert alert-danger";
        }

        private void ShowMarksMessage(
            string message,
            bool success)
        {
            lblMarksMessage.Visible = true;
            lblMarksMessage.Text = message;

            lblMarksMessage.CssClass =
                success
                    ? "message-label alert alert-success"
                    : "message-label alert alert-danger";
        }
    }
}
