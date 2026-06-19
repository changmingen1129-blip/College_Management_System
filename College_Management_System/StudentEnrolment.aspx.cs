using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace College_Management_System
{
    public partial class StudentEnrolment : System.Web.UI.Page
    {
        private readonly string connectionString =
        ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;


    protected void Page_Load(
        object sender,
        EventArgs e)
        {
            int studentID;

            if (!TryGetStudentID(
                out studentID))
            {
                return;
            }

            if (!IsPostBack)
            {
                try
                {
                    LoadStudentInitial();
                    LoadCourses(studentID);
                }
                catch (Exception ex)
                {
                    ShowMessage(
                        "Unable to load courses. "
                        + ex.Message,
                        "error"
                    );
                }
            }
        }

        private void LoadStudentInitial()
        {
            if (
                Session["StudentName"] != null
                && !string.IsNullOrWhiteSpace(
                    Session["StudentName"].ToString()
                )
            )
            {
                string studentName =
                    Session["StudentName"]
                        .ToString()
                        .Trim();

                lblInitial.Text =
                    studentName
                        .Substring(0, 1)
                        .ToUpper();
            }
            else
            {
                lblInitial.Text =
                    "S";
            }
        }

        private void LoadCourses(
            int studentID)
        {
            DataTable table =
                new DataTable();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    c.CourseID,
                    c.CourseCode,
                    c.CourseName,
                    c.CreditHours,
                    ISNULL(c.CourseFee, 0)
                        AS CourseFee,

                    ISNULL(
                        p.ProgrammeName,
                        'No Programme'
                    ) AS ProgrammeName,

                    CASE
                        WHEN ISNULL(
                            latestEnrolment.Status,
                            ''
                        ) IN
                        (
                            'Enrolled',
                            'Approved',
                            'Active'
                        )
                        AND ISNULL(
                            latestFee.DisplayStatus,
                            ''
                        ) = 'Paid'
                        THEN 'Paid'

                        ELSE ISNULL(
                            latestEnrolment.Status,
                            'Available'
                        )
                    END AS EnrolmentStatus,

                    CASE
                        WHEN ISNULL(
                            latestEnrolment.Status,
                            ''
                        ) IN
                        (
                            'Enrolled',
                            'Approved',
                            'Active'
                        )
                        THEN 1
                        ELSE 0
                    END AS IsEnrolled,

                    ISNULL(
                        latestFee.DisplayStatus,
                        'No Fee'
                    ) AS FeeStatus,

                    ISNULL(
                        latestFee.TotalAmount,
                        0
                    ) AS FeeAmount,

                    ISNULL(
                        latestFee.PaidAmount,
                        0
                    ) AS PaidAmount,

                    ISNULL(
                        latestFee.OutstandingAmount,
                        0
                    ) AS OutstandingAmount

                FROM dbo.Course c

                LEFT JOIN dbo.Programme p
                    ON c.ProgrammeID =
                       p.ProgrammeID

                OUTER APPLY
                (
                    SELECT TOP 1
                        e.EnrolmentID,
                        e.Status,
                        e.EnrolDate

                    FROM dbo.Enrolment e

                    WHERE e.CourseID =
                          c.CourseID

                      AND e.StudentID =
                          @StudentID

                    ORDER BY
                        e.EnrolmentID DESC
                ) AS latestEnrolment

                OUTER APPLY
                (
                    SELECT TOP 1
                        sf.FeeID,
                        sf.TotalAmount,
                        sf.PaidAmount,

                        CASE
                            WHEN sf.TotalAmount -
                                 sf.PaidAmount < 0
                            THEN 0
                            ELSE sf.TotalAmount -
                                 sf.PaidAmount
                        END AS OutstandingAmount,

                        CASE
                            WHEN sf.PaidAmount >=
                                 sf.TotalAmount
                            THEN 'Paid'

                            WHEN sf.DueDate <
                                 CAST(GETDATE() AS DATE)
                                 AND sf.PaidAmount <
                                     sf.TotalAmount
                            THEN 'Overdue'

                            WHEN sf.PaidAmount > 0
                                 AND sf.PaidAmount <
                                     sf.TotalAmount
                            THEN 'Partially Paid'

                            ELSE 'Unpaid'
                        END AS DisplayStatus

                    FROM dbo.StudentFee sf

                    WHERE sf.StudentID =
                          @StudentID

                      AND sf.CourseID =
                          c.CourseID

                    ORDER BY
                        sf.FeeID DESC
                ) AS latestFee

                ORDER BY
                    c.CourseCode,
                    c.CourseName";

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

            gvCourses.DataSource =
                table;

            gvCourses.DataBind();
        }

        protected void gvCourses_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            int studentID;

            if (!TryGetStudentID(
                out studentID))
            {
                return;
            }

            int courseID;

            if (!int.TryParse(
                e.CommandArgument.ToString(),
                out courseID)
                || courseID <= 0)
            {
                ShowMessage(
                    "Invalid course selected.",
                    "error"
                );

                return;
            }

            if (
                e.CommandName ==
                "EnrolCourse"
            )
            {
                EnrolCourse(
                    studentID,
                    courseID
                );
            }
            else if (
                e.CommandName ==
                "DropCourse"
            )
            {
                DropCourse(
                    studentID,
                    courseID
                );
            }

            try
            {
                LoadCourses(studentID);
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "The action was completed, but the course list could not be refreshed. "
                    + ex.Message,
                    "warning"
                );
            }
        }

        private void EnrolCourse(
            int studentID,
            int courseID)
        {
            if (
                IsCurrentlyEnrolled(
                    studentID,
                    courseID
                )
            )
            {
                EnsureCourseFeeExists(
                    studentID,
                    courseID
                );

                ShowMessage(
                    "You are already enrolled in this course.",
                    "warning"
                );

                return;
            }

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                con.Open();

                SqlTransaction transaction =
                    con.BeginTransaction();

                try
                {
                    int latestEnrolmentID =
                        GetLatestEnrolmentID(
                            con,
                            transaction,
                            studentID,
                            courseID
                        );

                    if (latestEnrolmentID > 0)
                    {
                        string updateQuery = @"
                        UPDATE dbo.Enrolment
                        SET
                            Status = 'Enrolled',
                            EnrolDate = GETDATE()
                        WHERE EnrolmentID =
                              @EnrolmentID";

                        using (SqlCommand updateCmd =
                            new SqlCommand(
                                updateQuery,
                                con,
                                transaction
                            ))
                        {
                            updateCmd.Parameters.Add(
                                "@EnrolmentID",
                                SqlDbType.Int
                            ).Value =
                                latestEnrolmentID;

                            updateCmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        string insertQuery = @"
                        INSERT INTO dbo.Enrolment
                        (
                            StudentID,
                            CourseID,
                            EnrolDate,
                            Status
                        )
                        VALUES
                        (
                            @StudentID,
                            @CourseID,
                            GETDATE(),
                            'Enrolled'
                        )";

                        using (SqlCommand insertCmd =
                            new SqlCommand(
                                insertQuery,
                                con,
                                transaction
                            ))
                        {
                            insertCmd.Parameters.Add(
                                "@StudentID",
                                SqlDbType.Int
                            ).Value =
                                studentID;

                            insertCmd.Parameters.Add(
                                "@CourseID",
                                SqlDbType.Int
                            ).Value =
                                courseID;

                            insertCmd.ExecuteNonQuery();
                        }
                    }

                    decimal courseFee =
                        GetCourseFee(
                            con,
                            transaction,
                            courseID
                        );

                    bool feeCreated = false;

                    if (courseFee > 0)
                    {
                        feeCreated =
                            CreateCourseFeeIfNeeded(
                                con,
                                transaction,
                                studentID,
                                courseID,
                                courseFee
                            );
                    }

                    transaction.Commit();

                    if (courseFee <= 0)
                    {
                        ShowMessage(
                            "Course enrolled successfully, but the administrator has not set a price for this course yet.",
                            "warning"
                        );
                    }
                    else if (feeCreated)
                    {
                        ShowMessage(
                            "Course enrolled successfully. A course fee of RM "
                            + courseFee.ToString("N2")
                            + " was added to My Fees.",
                            "success"
                        );
                    }
                    else
                    {
                        ShowMessage(
                            "Course enrolled successfully. The existing course fee record was kept.",
                            "success"
                        );
                    }
                }
                catch (Exception ex)
                {
                    try
                    {
                        transaction.Rollback();
                    }
                    catch
                    {
                    }

                    ShowMessage(
                        "Unable to enrol in the course. "
                        + ex.Message,
                        "error"
                    );
                }
            }
        }

        private decimal GetCourseFee(
            SqlConnection con,
            SqlTransaction transaction,
            int courseID)
        {
            string query = @"
            SELECT
                ISNULL(CourseFee, 0)
            FROM dbo.Course
            WHERE CourseID =
                  @CourseID";

            using (SqlCommand cmd =
                new SqlCommand(
                    query,
                    con,
                    transaction
                ))
            {
                cmd.Parameters.Add(
                    "@CourseID",
                    SqlDbType.Int
                ).Value = courseID;

                object result =
                    cmd.ExecuteScalar();

                if (
                    result == null
                    || result == DBNull.Value
                )
                {
                    return 0;
                }

                return Convert.ToDecimal(
                    result
                );
            }
        }

        private bool CreateCourseFeeIfNeeded(
            SqlConnection con,
            SqlTransaction transaction,
            int studentID,
            int courseID,
            decimal courseFee)
        {
            string query = @"
            INSERT INTO dbo.StudentFee
            (
                StudentID,
                CourseID,
                FeeType,
                Description,
                TotalAmount,
                PaidAmount,
                DueDate,
                PaymentStatus,
                CreatedAt
            )

            SELECT
                @StudentID,
                c.CourseID,
                'Course Fee',
                c.CourseCode
                    + ' - '
                    + c.CourseName,
                @CourseFee,
                0,
                DATEADD(
                    DAY,
                    30,
                    CAST(GETDATE() AS DATE)
                ),
                'Unpaid',
                GETDATE()

            FROM dbo.Course c

            WHERE c.CourseID =
                  @CourseID

              AND NOT EXISTS
              (
                  SELECT 1
                  FROM dbo.StudentFee sf

                  WHERE sf.StudentID =
                        @StudentID

                    AND sf.CourseID =
                        @CourseID
              )";

            using (SqlCommand cmd =
                new SqlCommand(
                    query,
                    con,
                    transaction
                ))
            {
                cmd.Parameters.Add(
                    "@StudentID",
                    SqlDbType.Int
                ).Value = studentID;

                cmd.Parameters.Add(
                    "@CourseID",
                    SqlDbType.Int
                ).Value = courseID;

                SqlParameter feeParameter =
                    cmd.Parameters.Add(
                        "@CourseFee",
                        SqlDbType.Decimal
                    );

                feeParameter.Precision = 10;
                feeParameter.Scale = 2;
                feeParameter.Value =
                    courseFee;

                int affectedRows =
                    cmd.ExecuteNonQuery();

                return affectedRows > 0;
            }
        }

        private void EnsureCourseFeeExists(
            int studentID,
            int courseID)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                con.Open();

                SqlTransaction transaction =
                    con.BeginTransaction();

                try
                {
                    decimal courseFee =
                        GetCourseFee(
                            con,
                            transaction,
                            courseID
                        );

                    if (courseFee > 0)
                    {
                        CreateCourseFeeIfNeeded(
                            con,
                            transaction,
                            studentID,
                            courseID,
                            courseFee
                        );
                    }

                    transaction.Commit();
                }
                catch
                {
                    try
                    {
                        transaction.Rollback();
                    }
                    catch
                    {
                    }
                }
            }
        }

        private void DropCourse(
            int studentID,
            int courseID)
        {
            if (
                !IsCurrentlyEnrolled(
                    studentID,
                    courseID
                )
            )
            {
                ShowMessage(
                    "This course is not currently enrolled.",
                    "warning"
                );

                return;
            }

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                UPDATE dbo.Enrolment
                SET Status = 'Dropped'
                WHERE StudentID =
                      @StudentID

                  AND CourseID =
                      @CourseID

                  AND ISNULL(
                      Status,
                      ''
                  ) IN
                  (
                      'Enrolled',
                      'Approved',
                      'Active'
                  )";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@StudentID",
                        SqlDbType.Int
                    ).Value = studentID;

                    cmd.Parameters.Add(
                        "@CourseID",
                        SqlDbType.Int
                    ).Value = courseID;

                    con.Open();

                    int affectedRows =
                        cmd.ExecuteNonQuery();

                    if (affectedRows > 0)
                    {
                        ShowMessage(
                            "Course dropped successfully. Existing fee records were not deleted automatically.",
                            "success"
                        );
                    }
                    else
                    {
                        ShowMessage(
                            "Unable to drop the selected course.",
                            "error"
                        );
                    }
                }
            }
        }

        private bool IsCurrentlyEnrolled(
            int studentID,
            int courseID)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT COUNT(*)

                FROM dbo.Enrolment

                WHERE StudentID =
                      @StudentID

                  AND CourseID =
                      @CourseID

                  AND ISNULL(
                      Status,
                      ''
                  ) IN
                  (
                      'Enrolled',
                      'Approved',
                      'Active'
                  )";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@StudentID",
                        SqlDbType.Int
                    ).Value = studentID;

                    cmd.Parameters.Add(
                        "@CourseID",
                        SqlDbType.Int
                    ).Value = courseID;

                    con.Open();

                    int count =
                        Convert.ToInt32(
                            cmd.ExecuteScalar()
                        );

                    return count > 0;
                }
            }
        }

        private int GetLatestEnrolmentID(
            SqlConnection con,
            SqlTransaction transaction,
            int studentID,
            int courseID)
        {
            string query = @"
            SELECT TOP 1
                EnrolmentID

            FROM dbo.Enrolment

            WHERE StudentID =
                  @StudentID

              AND CourseID =
                  @CourseID

            ORDER BY
                EnrolmentID DESC";

            using (SqlCommand cmd =
                new SqlCommand(
                    query,
                    con,
                    transaction
                ))
            {
                cmd.Parameters.Add(
                    "@StudentID",
                    SqlDbType.Int
                ).Value = studentID;

                cmd.Parameters.Add(
                    "@CourseID",
                    SqlDbType.Int
                ).Value = courseID;

                object result =
                    cmd.ExecuteScalar();

                if (
                    result == null
                    || result == DBNull.Value
                )
                {
                    return 0;
                }

                return Convert.ToInt32(
                    result
                );
            }
        }

        private bool TryGetStudentID(
            out int studentID)
        {
            studentID = 0;

            if (Session["StudentID"] == null)
            {
                RedirectToLogin();
                return false;
            }

            if (!int.TryParse(
                Session["StudentID"].ToString(),
                out studentID)
                || studentID <= 0)
            {
                Session.Clear();
                Session.Abandon();

                RedirectToLogin();
                return false;
            }

            return true;
        }

        private void RedirectToLogin()
        {
            Response.Redirect(
                ResolveUrl(
                    "~/StudentLogin.aspx"
                ),
                false
            );

            Context.ApplicationInstance
                .CompleteRequest();
        }

        public string GetStatusClass(
            string status)
        {
            if (
                string.Equals(
                    status,
                    "Paid",
                    StringComparison.OrdinalIgnoreCase
                )
            )
            {
                return
                    "status-badge status-enrolled";
            }

            if (
                string.Equals(
                    status,
                    "Enrolled",
                    StringComparison.OrdinalIgnoreCase
                )
                || string.Equals(
                    status,
                    "Approved",
                    StringComparison.OrdinalIgnoreCase
                )
                || string.Equals(
                    status,
                    "Active",
                    StringComparison.OrdinalIgnoreCase
                )
            )
            {
                return
                    "status-badge status-enrolled";
            }

            if (
                string.Equals(
                    status,
                    "Dropped",
                    StringComparison.OrdinalIgnoreCase
                )
            )
            {
                return
                    "status-badge status-dropped";
            }

            return
                "status-badge status-available";
        }

        public string GetStatusText(
            string status)
        {
            if (
                string.Equals(
                    status,
                    "Paid",
                    StringComparison.OrdinalIgnoreCase
                )
            )
            {
                return
                    "Enrolled • Paid";
            }

            if (
                string.Equals(
                    status,
                    "Enrolled",
                    StringComparison.OrdinalIgnoreCase
                )
                || string.Equals(
                    status,
                    "Approved",
                    StringComparison.OrdinalIgnoreCase
                )
                || string.Equals(
                    status,
                    "Active",
                    StringComparison.OrdinalIgnoreCase
                )
            )
            {
                return
                    "Enrolled";
            }

            if (
                string.Equals(
                    status,
                    "Dropped",
                    StringComparison.OrdinalIgnoreCase
                )
            )
            {
                return
                    "Dropped";
            }

            return
                "Available";
        }

        private void ShowMessage(
            string message,
            string type)
        {
            lblMsg.Visible =
                true;

            lblMsg.Text =
                message;

            if (type == "success")
            {
                lblMsg.CssClass =
                    "alert alert-success alert-message d-block";
            }
            else if (type == "warning")
            {
                lblMsg.CssClass =
                    "alert alert-warning alert-message d-block";
            }
            else
            {
                lblMsg.CssClass =
                    "alert alert-danger alert-message d-block";
            }
        }
    }


}
