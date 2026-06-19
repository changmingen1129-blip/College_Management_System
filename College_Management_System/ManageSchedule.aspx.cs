using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.UI.WebControls;

namespace College_Management_System
{
    public partial class ManageSchedule : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminEmail"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCourses();
                LoadLecturers();

                LoadFilterCourses();
                LoadFilterLecturers();

                LoadScheduleList();
                LoadScheduleJson();
            }
        }

        private void LoadCourses()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT CourseID, CourseCode + ' - ' + CourseName AS CourseDisplay
                    FROM Course
                    ORDER BY CourseName";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();

                    ddlCourse.DataSource = cmd.ExecuteReader();
                    ddlCourse.DataTextField = "CourseDisplay";
                    ddlCourse.DataValueField = "CourseID";
                    ddlCourse.DataBind();

                    ddlCourse.Items.Insert(0, new ListItem("-- Select Course --", "0"));
                }
            }
        }

        private void LoadLecturers()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT LecturerID, LecturerName
                    FROM Lecturer
                    ORDER BY LecturerName";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();

                    ddlLecturer.DataSource = cmd.ExecuteReader();
                    ddlLecturer.DataTextField = "LecturerName";
                    ddlLecturer.DataValueField = "LecturerID";
                    ddlLecturer.DataBind();

                    ddlLecturer.Items.Insert(0, new ListItem("-- Select Lecturer --", "0"));
                }
            }
        }

        private void LoadFilterCourses()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT CourseID, CourseCode + ' - ' + CourseName AS CourseDisplay
                    FROM Course
                    ORDER BY CourseName";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();

                    ddlFilterCourse.DataSource = cmd.ExecuteReader();
                    ddlFilterCourse.DataTextField = "CourseDisplay";
                    ddlFilterCourse.DataValueField = "CourseID";
                    ddlFilterCourse.DataBind();

                    ddlFilterCourse.Items.Insert(0, new ListItem("All Courses", "0"));
                }
            }
        }

        private void LoadFilterLecturers()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT LecturerID, LecturerName
                    FROM Lecturer
                    ORDER BY LecturerName";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();

                    ddlFilterLecturer.DataSource = cmd.ExecuteReader();
                    ddlFilterLecturer.DataTextField = "LecturerName";
                    ddlFilterLecturer.DataValueField = "LecturerID";
                    ddlFilterLecturer.DataBind();

                    ddlFilterLecturer.Items.Insert(0, new ListItem("All Lecturers", "0"));
                }
            }
        }

        protected void btnSaveSchedule_Click(object sender, EventArgs e)
        {
            if (ddlCourse.SelectedValue == "0" ||
                ddlDay.SelectedValue == "0" ||
                txtStartTime.Text.Trim() == "" ||
                txtEndTime.Text.Trim() == "" ||
                txtRoom.Text.Trim() == "")
            {
                ShowMessage("Please fill in course, day, start time, end time, and room.", "danger");
                return;
            }

            TimeSpan startTime;
            TimeSpan endTime;

            if (!TimeSpan.TryParse(txtStartTime.Text.Trim(), out startTime) ||
                !TimeSpan.TryParse(txtEndTime.Text.Trim(), out endTime))
            {
                ShowMessage("Invalid time format.", "danger");
                return;
            }

            if (startTime >= endTime)
            {
                ShowMessage("Start time must be earlier than end time.", "danger");
                return;
            }

            int scheduleID = Convert.ToInt32(hfScheduleID.Value);
            int courseID = Convert.ToInt32(ddlCourse.SelectedValue);
            int lecturerID = ddlLecturer.SelectedValue == "0" ? 0 : Convert.ToInt32(ddlLecturer.SelectedValue);
            string dayOfWeek = ddlDay.SelectedValue;
            string room = txtRoom.Text.Trim();

            if (HasRoomClash(scheduleID, dayOfWeek, startTime, endTime, room))
            {
                ShowMessage("This room is already booked during the selected day and time.", "danger");
                return;
            }

            if (lecturerID != 0 && HasLecturerClash(scheduleID, dayOfWeek, startTime, endTime, lecturerID))
            {
                ShowMessage("This lecturer already has another class during the selected day and time.", "danger");
                return;
            }

            if (scheduleID == 0)
            {
                InsertSchedule(courseID, lecturerID, dayOfWeek, startTime, endTime, room);
                ShowMessage("Schedule added successfully.", "success");
            }
            else
            {
                UpdateSchedule(scheduleID, courseID, lecturerID, dayOfWeek, startTime, endTime, room);
                ShowMessage("Schedule updated successfully.", "success");
            }

            ClearForm();

            LoadScheduleListWithFilter();
            LoadScheduleJson();
        }

        private void InsertSchedule(int courseID, int lecturerID, string dayOfWeek, TimeSpan startTime, TimeSpan endTime, string room)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    INSERT INTO Schedule (CourseID, LecturerID, DayOfWeek, StartTime, EndTime, Room)
                    VALUES (@CourseID, @LecturerID, @DayOfWeek, @StartTime, @EndTime, @Room)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CourseID", courseID);

                    if (lecturerID == 0)
                    {
                        cmd.Parameters.AddWithValue("@LecturerID", DBNull.Value);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@LecturerID", lecturerID);
                    }

                    cmd.Parameters.AddWithValue("@DayOfWeek", dayOfWeek);
                    cmd.Parameters.AddWithValue("@StartTime", startTime);
                    cmd.Parameters.AddWithValue("@EndTime", endTime);
                    cmd.Parameters.AddWithValue("@Room", room);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdateSchedule(int scheduleID, int courseID, int lecturerID, string dayOfWeek, TimeSpan startTime, TimeSpan endTime, string room)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    UPDATE Schedule
                    SET CourseID = @CourseID,
                        LecturerID = @LecturerID,
                        DayOfWeek = @DayOfWeek,
                        StartTime = @StartTime,
                        EndTime = @EndTime,
                        Room = @Room
                    WHERE ScheduleID = @ScheduleID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CourseID", courseID);

                    if (lecturerID == 0)
                    {
                        cmd.Parameters.AddWithValue("@LecturerID", DBNull.Value);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@LecturerID", lecturerID);
                    }

                    cmd.Parameters.AddWithValue("@DayOfWeek", dayOfWeek);
                    cmd.Parameters.AddWithValue("@StartTime", startTime);
                    cmd.Parameters.AddWithValue("@EndTime", endTime);
                    cmd.Parameters.AddWithValue("@Room", room);
                    cmd.Parameters.AddWithValue("@ScheduleID", scheduleID);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private bool HasRoomClash(int currentScheduleID, string dayOfWeek, TimeSpan startTime, TimeSpan endTime, string room)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT COUNT(*)
                    FROM Schedule
                    WHERE ScheduleID <> @ScheduleID
                    AND DayOfWeek = @DayOfWeek
                    AND Room = @Room
                    AND StartTime < @EndTime
                    AND EndTime > @StartTime";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ScheduleID", currentScheduleID);
                    cmd.Parameters.AddWithValue("@DayOfWeek", dayOfWeek);
                    cmd.Parameters.AddWithValue("@Room", room);
                    cmd.Parameters.AddWithValue("@StartTime", startTime);
                    cmd.Parameters.AddWithValue("@EndTime", endTime);

                    con.Open();

                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    return count > 0;
                }
            }
        }

        private bool HasLecturerClash(int currentScheduleID, string dayOfWeek, TimeSpan startTime, TimeSpan endTime, int lecturerID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT COUNT(*)
                    FROM Schedule
                    WHERE ScheduleID <> @ScheduleID
                    AND DayOfWeek = @DayOfWeek
                    AND LecturerID = @LecturerID
                    AND StartTime < @EndTime
                    AND EndTime > @StartTime";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ScheduleID", currentScheduleID);
                    cmd.Parameters.AddWithValue("@DayOfWeek", dayOfWeek);
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);
                    cmd.Parameters.AddWithValue("@StartTime", startTime);
                    cmd.Parameters.AddWithValue("@EndTime", endTime);

                    con.Open();

                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    return count > 0;
                }
            }
        }

        private void LoadScheduleList()
        {
            LoadScheduleListByValues(0, 0, "0", "");
        }

        private void LoadScheduleListWithFilter()
        {
            int courseID = Convert.ToInt32(ddlFilterCourse.SelectedValue);
            int lecturerID = Convert.ToInt32(ddlFilterLecturer.SelectedValue);
            string dayOfWeek = ddlFilterDay.SelectedValue;
            string roomKeyword = txtFilterRoom.Text.Trim();

            LoadScheduleListByValues(courseID, lecturerID, dayOfWeek, roomKeyword);
        }

        private void LoadScheduleListByValues(int courseID, int lecturerID, string dayOfWeek, string roomKeyword)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        s.ScheduleID,
                        c.CourseCode,
                        c.CourseName,
                        ISNULL(l.LecturerName, 'Not assigned') AS LecturerName,
                        s.DayOfWeek,
                        CONVERT(VARCHAR(5), s.StartTime, 108) AS StartTime,
                        CONVERT(VARCHAR(5), s.EndTime, 108) AS EndTime,
                        s.Room
                    FROM Schedule s
                    INNER JOIN Course c
                        ON s.CourseID = c.CourseID
                    LEFT JOIN Lecturer l
                        ON s.LecturerID = l.LecturerID
                    WHERE
                        (@CourseID = 0 OR s.CourseID = @CourseID)
                        AND (@LecturerID = 0 OR s.LecturerID = @LecturerID)
                        AND (@DayOfWeek = '0' OR s.DayOfWeek = @DayOfWeek)
                        AND (@RoomKeyword = '' OR s.Room LIKE '%' + @RoomKeyword + '%')
                    ORDER BY 
                        CASE s.DayOfWeek
                            WHEN 'Monday' THEN 1
                            WHEN 'Tuesday' THEN 2
                            WHEN 'Wednesday' THEN 3
                            WHEN 'Thursday' THEN 4
                            WHEN 'Friday' THEN 5
                            WHEN 'Saturday' THEN 6
                            WHEN 'Sunday' THEN 7
                            ELSE 8
                        END,
                        s.StartTime";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CourseID", courseID);
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);
                    cmd.Parameters.AddWithValue("@DayOfWeek", dayOfWeek);
                    cmd.Parameters.AddWithValue("@RoomKeyword", roomKeyword);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvSchedule.DataSource = dt;
                        gvSchedule.DataBind();
                    }
                }
            }
        }

        private void LoadScheduleJson()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        s.ScheduleID,
                        c.CourseCode,
                        c.CourseName,
                        ISNULL(l.LecturerName, 'Not assigned') AS LecturerName,
                        s.DayOfWeek,
                        CONVERT(VARCHAR(5), s.StartTime, 108) AS StartTime,
                        CONVERT(VARCHAR(5), s.EndTime, 108) AS EndTime,
                        s.Room
                    FROM Schedule s
                    INNER JOIN Course c
                        ON s.CourseID = c.CourseID
                    LEFT JOIN Lecturer l
                        ON s.LecturerID = l.LecturerID
                    ORDER BY 
                        CASE s.DayOfWeek
                            WHEN 'Monday' THEN 1
                            WHEN 'Tuesday' THEN 2
                            WHEN 'Wednesday' THEN 3
                            WHEN 'Thursday' THEN 4
                            WHEN 'Friday' THEN 5
                            WHEN 'Saturday' THEN 6
                            WHEN 'Sunday' THEN 7
                            ELSE 8
                        END,
                        s.StartTime";

                using (SqlDataAdapter da = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    List<Dictionary<string, object>> scheduleItems = new List<Dictionary<string, object>>();

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

                        scheduleItems.Add(item);
                    }

                    JavaScriptSerializer serializer = new JavaScriptSerializer();
                    hfScheduleJson.Value = serializer.Serialize(scheduleItems);
                }
            }
        }

        protected void btnFilterSchedule_Click(object sender, EventArgs e)
        {
            LoadScheduleListWithFilter();
        }

        protected void btnShowAllSchedule_Click(object sender, EventArgs e)
        {
            ddlFilterCourse.SelectedIndex = 0;
            ddlFilterLecturer.SelectedIndex = 0;
            ddlFilterDay.SelectedIndex = 0;
            txtFilterRoom.Text = "";

            LoadScheduleList();
        }

        protected void gvSchedule_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int scheduleID = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "DeleteSchedule")
            {
                DeleteSchedule(scheduleID);
                ShowMessage("Schedule deleted successfully.", "success");

                LoadScheduleListWithFilter();
                LoadScheduleJson();
            }
            else if (e.CommandName == "EditSchedule")
            {
                LoadScheduleForEdit(scheduleID);
            }
        }

        private void LoadScheduleForEdit(int scheduleID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT ScheduleID, CourseID, LecturerID, DayOfWeek,
                           CONVERT(VARCHAR(5), StartTime, 108) AS StartTime,
                           CONVERT(VARCHAR(5), EndTime, 108) AS EndTime,
                           Room
                    FROM Schedule
                    WHERE ScheduleID = @ScheduleID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ScheduleID", scheduleID);

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            hfScheduleID.Value = reader["ScheduleID"].ToString();

                            if (ddlCourse.Items.FindByValue(reader["CourseID"].ToString()) != null)
                            {
                                ddlCourse.SelectedValue = reader["CourseID"].ToString();
                            }

                            if (reader["LecturerID"] != DBNull.Value &&
                                ddlLecturer.Items.FindByValue(reader["LecturerID"].ToString()) != null)
                            {
                                ddlLecturer.SelectedValue = reader["LecturerID"].ToString();
                            }
                            else
                            {
                                ddlLecturer.SelectedValue = "0";
                            }

                            ddlDay.SelectedValue = reader["DayOfWeek"].ToString();
                            txtStartTime.Text = reader["StartTime"].ToString();
                            txtEndTime.Text = reader["EndTime"].ToString();
                            txtRoom.Text = reader["Room"].ToString();

                            btnSaveSchedule.Text = "Update Schedule";
                        }
                    }
                }
            }
        }

        private void DeleteSchedule(int scheduleID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM Schedule WHERE ScheduleID = @ScheduleID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ScheduleID", scheduleID);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            hfScheduleID.Value = "0";
            ddlCourse.SelectedIndex = 0;
            ddlLecturer.SelectedIndex = 0;
            ddlDay.SelectedIndex = 0;
            txtStartTime.Text = "";
            txtEndTime.Text = "";
            txtRoom.Text = "";
            btnSaveSchedule.Text = "Save Schedule";
        }

        private void ShowMessage(string message, string type)
        {
            if (type == "success")
            {
                lblMsg.CssClass = "text-success fw-bold";
            }
            else
            {
                lblMsg.CssClass = "text-danger fw-bold";
            }

            lblMsg.Text = message;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("Login.aspx");
        }
    }
}