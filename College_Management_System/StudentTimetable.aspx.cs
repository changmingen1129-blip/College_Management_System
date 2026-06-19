using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;

namespace College_Management_System
{
    public partial class StudentTimetable : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["StudentID"] == null)
            {
                Response.Redirect("StudentLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStudentInfo();
                LoadStudentTimetableJson();
            }
        }

        private void LoadStudentInfo()
        {
            int studentId = Convert.ToInt32(Session["StudentID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT StudentName, Email
                    FROM Student
                    WHERE StudentID = @StudentID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string studentName = reader["StudentName"].ToString();

                            hfStudentName.Value = studentName;
                            Session["StudentName"] = studentName;
                            Session["StudentEmail"] = reader["Email"].ToString();

                            if (!string.IsNullOrWhiteSpace(studentName))
                            {
                                lblInitial.Text = studentName.Substring(0, 1).ToUpper();
                            }
                            else
                            {
                                lblInitial.Text = "S";
                            }
                        }
                    }
                }
            }
        }

        private void LoadStudentTimetableJson()
        {
            int studentId = Convert.ToInt32(Session["StudentID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        sch.ScheduleID,
                        c.CourseCode,
                        c.CourseName,
                        ISNULL(l.LecturerName, 'Not assigned') AS LecturerName,
                        sch.DayOfWeek,
                        CONVERT(VARCHAR(5), sch.StartTime, 108) AS StartTime,
                        CONVERT(VARCHAR(5), sch.EndTime, 108) AS EndTime,
                        sch.Room
                    FROM Schedule sch
                    INNER JOIN Course c
                        ON sch.CourseID = c.CourseID
                    INNER JOIN Enrolment e
                        ON c.CourseID = e.CourseID
                    LEFT JOIN Lecturer l
                        ON sch.LecturerID = l.LecturerID
                    WHERE e.StudentID = @StudentID
                    ORDER BY
                        CASE sch.DayOfWeek
                            WHEN 'Monday' THEN 1
                            WHEN 'Tuesday' THEN 2
                            WHEN 'Wednesday' THEN 3
                            WHEN 'Thursday' THEN 4
                            WHEN 'Friday' THEN 5
                            WHEN 'Saturday' THEN 6
                            WHEN 'Sunday' THEN 7
                            ELSE 8
                        END,
                        sch.StartTime";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        List<Dictionary<string, object>> timetableItems = new List<Dictionary<string, object>>();

                        foreach (DataRow row in dt.Rows)
                        {
                            Dictionary<string, object> item = new Dictionary<string, object>();

                            item["ScheduleID"] = row["ScheduleID"].ToString();
                            item["CourseCode"] = row["CourseCode"].ToString();
                            item["CourseName"] = row["CourseName"].ToString();
                            item["LecturerName"] = row["LecturerName"].ToString();
                            item["DayOfWeek"] = row["DayOfWeek"].ToString();
                            item["StartTime"] = row["StartTime"].ToString();
                            item["EndTime"] = row["EndTime"].ToString();
                            item["Room"] = row["Room"].ToString();

                            timetableItems.Add(item);
                        }

                        JavaScriptSerializer serializer = new JavaScriptSerializer();
                        hfScheduleJson.Value = serializer.Serialize(timetableItems);
                    }
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("StudentLogin.aspx");
        }
    }
}