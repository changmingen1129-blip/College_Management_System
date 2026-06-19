using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace College_Management_System
{
    public partial class AdminFees : System.Web.UI.Page
    {
        private readonly string connectionString =
        ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;


    protected void Page_Load(
        object sender,
        EventArgs e)
        {
            if (Session["AdminEmail"] == null)
            {
                Response.Redirect(
                    ResolveUrl("~/Login.aspx"),
                    false
                );

                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                try
                {
                    LoadProgrammes();
                    LoadCourses(0);
                    LoadCourseFeeGrid();

                    LoadStudents();

                    LoadFeeRecords(
                        0,
                        "All",
                        ""
                    );

                    UpdateSummary();
                    ClearCourseFeeForm();
                    ClearForm();
                }
                catch (Exception ex)
                {
                    ShowMessage(
                        "Unable to load fee management. "
                        + ex.Message,
                        "error"
                    );
                }
            }
        }

        private void LoadProgrammes()
        {
            ddlFeeProgramme.Items.Clear();

            ddlFeeProgramme.Items.Add(
                new ListItem(
                    "-- Select Programme --",
                    "0"
                )
            );

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    ProgrammeID,
                    ProgrammeName,
                    ProgrammeCode
                FROM dbo.Programme
                ORDER BY
                    ProgrammeName,
                    ProgrammeCode";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string programmeID =
                                reader["ProgrammeID"].ToString();

                            string displayText =
                                reader["ProgrammeCode"].ToString()
                                + " - "
                                + reader["ProgrammeName"].ToString();

                            ddlFeeProgramme.Items.Add(
                                new ListItem(
                                    displayText,
                                    programmeID
                                )
                            );
                        }
                    }
                }
            }
        }

        private void LoadCourses(
            int programmeID)
        {
            ddlFeeCourse.Items.Clear();

            ddlFeeCourse.Items.Add(
                new ListItem(
                    "-- Select Course / Subject --",
                    "0"
                )
            );

            if (programmeID <= 0)
            {
                return;
            }

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    CourseID,
                    CourseCode,
                    CourseName,
                    CourseFee
                FROM dbo.Course
                WHERE ProgrammeID = @ProgrammeID
                ORDER BY
                    CourseCode,
                    CourseName";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@ProgrammeID",
                        SqlDbType.Int
                    ).Value = programmeID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string courseID =
                                reader["CourseID"].ToString();

                            decimal courseFee =
                                reader["CourseFee"] == DBNull.Value
                                ? 0
                                : Convert.ToDecimal(
                                    reader["CourseFee"]
                                );

                            string displayText =
                                reader["CourseCode"].ToString()
                                + " - "
                                + reader["CourseName"].ToString()
                                + " (RM "
                                + courseFee.ToString("N2")
                                + ")";

                            ddlFeeCourse.Items.Add(
                                new ListItem(
                                    displayText,
                                    courseID
                                )
                            );
                        }
                    }
                }
            }
        }

        protected void ddlFeeProgramme_SelectedIndexChanged(
            object sender,
            EventArgs e)
        {
            HideCourseFeeMessage();

            int programmeID;

            if (!int.TryParse(
                ddlFeeProgramme.SelectedValue,
                out programmeID))
            {
                programmeID = 0;
            }

            try
            {
                LoadCourses(programmeID);

                txtCourseFee.Text =
                    "";
            }
            catch (Exception ex)
            {
                ShowCourseFeeMessage(
                    "Unable to load courses. "
                    + ex.Message,
                    "error"
                );
            }
        }

        protected void ddlFeeCourse_SelectedIndexChanged(
            object sender,
            EventArgs e)
        {
            HideCourseFeeMessage();

            int courseID;

            if (!int.TryParse(
                ddlFeeCourse.SelectedValue,
                out courseID)
                || courseID <= 0)
            {
                txtCourseFee.Text =
                    "";

                return;
            }

            try
            {
                LoadSelectedCoursePrice(
                    courseID
                );
            }
            catch (Exception ex)
            {
                ShowCourseFeeMessage(
                    "Unable to load the selected course price. "
                    + ex.Message,
                    "error"
                );
            }
        }

        private void LoadSelectedCoursePrice(
            int courseID)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    CourseFee
                FROM dbo.Course
                WHERE CourseID = @CourseID";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@CourseID",
                        SqlDbType.Int
                    ).Value = courseID;

                    con.Open();

                    object result =
                        cmd.ExecuteScalar();

                    decimal courseFee =
                        result == null
                        || result == DBNull.Value
                        ? 0
                        : Convert.ToDecimal(result);

                    txtCourseFee.Text =
                        courseFee.ToString("0.00");
                }
            }
        }

        protected void btnSaveCourseFee_Click(
            object sender,
            EventArgs e)
        {
            HideCourseFeeMessage();

            if (!Page.IsValid)
            {
                ShowCourseFeeMessage(
                    "Please select a course and enter its price.",
                    "warning"
                );

                return;
            }

            int courseID;
            decimal courseFee;

            if (!int.TryParse(
                ddlFeeCourse.SelectedValue,
                out courseID)
                || courseID <= 0)
            {
                ShowCourseFeeMessage(
                    "Please select a course.",
                    "warning"
                );

                return;
            }

            if (!decimal.TryParse(
                txtCourseFee.Text,
                out courseFee)
                || courseFee <= 0)
            {
                ShowCourseFeeMessage(
                    "Course fee must be greater than zero.",
                    "warning"
                );

                return;
            }

            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    string query = @"
                    UPDATE dbo.Course
                    SET CourseFee = @CourseFee
                    WHERE CourseID = @CourseID";

                    using (SqlCommand cmd =
                        new SqlCommand(query, con))
                    {
                        SqlParameter feeParameter =
                            cmd.Parameters.Add(
                                "@CourseFee",
                                SqlDbType.Decimal
                            );

                        feeParameter.Precision = 10;
                        feeParameter.Scale = 2;
                        feeParameter.Value = courseFee;

                        cmd.Parameters.Add(
                            "@CourseID",
                            SqlDbType.Int
                        ).Value = courseID;

                        con.Open();

                        int affectedRows =
                            cmd.ExecuteNonQuery();

                        if (affectedRows > 0)
                        {
                            int programmeID = 0;

                            int.TryParse(
                                ddlFeeProgramme.SelectedValue,
                                out programmeID
                            );

                            LoadCourses(programmeID);

                            if (
                                ddlFeeCourse.Items.FindByValue(
                                    courseID.ToString()
                                ) != null
                            )
                            {
                                ddlFeeCourse.SelectedValue =
                                    courseID.ToString();
                            }

                            txtCourseFee.Text =
                                courseFee.ToString("0.00");

                            LoadCourseFeeGrid();

                            ShowCourseFeeMessage(
                                "Course price saved successfully.",
                                "success"
                            );
                        }
                        else
                        {
                            ShowCourseFeeMessage(
                                "The selected course could not be found.",
                                "warning"
                            );
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowCourseFeeMessage(
                    "Unable to save the course price. "
                    + ex.Message,
                    "error"
                );
            }
        }

        protected void btnClearCourseFee_Click(
            object sender,
            EventArgs e)
        {
            HideCourseFeeMessage();
            ClearCourseFeeForm();
        }

        private void ClearCourseFeeForm()
        {
            if (
                ddlFeeProgramme.Items.FindByValue(
                    "0"
                ) != null
            )
            {
                ddlFeeProgramme.SelectedValue =
                    "0";
            }

            LoadCourses(0);

            txtCourseFee.Text =
                "";
        }

        private void LoadCourseFeeGrid()
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
                    c.CourseFee,
                    c.ProgrammeID,
                    p.ProgrammeName,
                    p.ProgrammeCode
                FROM dbo.Course c

                INNER JOIN dbo.Programme p
                    ON c.ProgrammeID = p.ProgrammeID

                ORDER BY
                    p.ProgrammeName,
                    c.CourseCode,
                    c.CourseName";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(table);
                    }
                }
            }

            gvCourseFees.DataSource =
                table;

            gvCourseFees.DataBind();
        }

        protected void gvCourseFees_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            HideCourseFeeMessage();

            if (
                e.CommandName !=
                "SelectCourseFee"
            )
            {
                return;
            }

            int courseID;

            if (!int.TryParse(
                e.CommandArgument.ToString(),
                out courseID)
                || courseID <= 0)
            {
                ShowCourseFeeMessage(
                    "Invalid course selected.",
                    "error"
                );

                return;
            }

            try
            {
                LoadCourseForPriceEditing(
                    courseID
                );
            }
            catch (Exception ex)
            {
                ShowCourseFeeMessage(
                    "Unable to load the selected course. "
                    + ex.Message,
                    "error"
                );
            }
        }

        private void LoadCourseForPriceEditing(
            int courseID)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    CourseID,
                    ProgrammeID,
                    CourseFee
                FROM dbo.Course
                WHERE CourseID = @CourseID";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@CourseID",
                        SqlDbType.Int
                    ).Value = courseID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            ShowCourseFeeMessage(
                                "The selected course could not be found.",
                                "warning"
                            );

                            return;
                        }

                        string programmeID =
                            reader["ProgrammeID"].ToString();

                        decimal courseFee =
                            reader["CourseFee"] == DBNull.Value
                            ? 0
                            : Convert.ToDecimal(
                                reader["CourseFee"]
                            );

                        if (
                            ddlFeeProgramme.Items.FindByValue(
                                programmeID
                            ) != null
                        )
                        {
                            ddlFeeProgramme.SelectedValue =
                                programmeID;
                        }

                        LoadCourses(
                            Convert.ToInt32(
                                programmeID
                            )
                        );

                        if (
                            ddlFeeCourse.Items.FindByValue(
                                courseID.ToString()
                            ) != null
                        )
                        {
                            ddlFeeCourse.SelectedValue =
                                courseID.ToString();
                        }

                        txtCourseFee.Text =
                            courseFee.ToString("0.00");

                        ShowCourseFeeMessage(
                            "Course selected. Enter the price and click Save Course Fee.",
                            "success"
                        );
                    }
                }
            }
        }

        private void LoadStudents()
        {
            ddlStudent.Items.Clear();
            ddlFilterStudent.Items.Clear();

            ddlStudent.Items.Add(
                new ListItem(
                    "-- Select Student --",
                    "0"
                )
            );

            ddlFilterStudent.Items.Add(
                new ListItem(
                    "All Students",
                    "0"
                )
            );

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    StudentID,
                    StudentName,
                    Email
                FROM dbo.Student
                ORDER BY
                    StudentName,
                    StudentID";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string studentID =
                                reader["StudentID"].ToString();

                            string displayText =
                                reader["StudentName"].ToString()
                                + " - ID "
                                + studentID;

                            ddlStudent.Items.Add(
                                new ListItem(
                                    displayText,
                                    studentID
                                )
                            );

                            ddlFilterStudent.Items.Add(
                                new ListItem(
                                    displayText,
                                    studentID
                                )
                            );
                        }
                    }
                }
            }
        }

        protected void btnSave_Click(
            object sender,
            EventArgs e)
        {
            HideMessage();

            if (!Page.IsValid)
            {
                ShowMessage(
                    "Please complete all required fee fields.",
                    "warning"
                );

                return;
            }

            int studentID;

            if (!int.TryParse(
                ddlStudent.SelectedValue,
                out studentID)
                || studentID <= 0)
            {
                ShowMessage(
                    "Please select a student.",
                    "warning"
                );

                return;
            }

            decimal totalAmount;
            decimal paidAmount;
            DateTime dueDate;

            if (!decimal.TryParse(
                txtTotalAmount.Text,
                out totalAmount)
                || totalAmount <= 0)
            {
                ShowMessage(
                    "Total amount must be greater than zero.",
                    "warning"
                );

                return;
            }

            if (!decimal.TryParse(
                txtPaidAmount.Text,
                out paidAmount)
                || paidAmount < 0)
            {
                ShowMessage(
                    "Paid amount cannot be negative.",
                    "warning"
                );

                return;
            }

            if (paidAmount > totalAmount)
            {
                ShowMessage(
                    "Paid amount cannot be greater than the total amount.",
                    "warning"
                );

                return;
            }

            if (!DateTime.TryParse(
                txtDueDate.Text,
                out dueDate))
            {
                ShowMessage(
                    "Please enter a valid due date.",
                    "warning"
                );

                return;
            }

            string feeType =
                ddlFeeType.SelectedValue;

            string description =
                txtDescription.Text.Trim();

            string paymentStatus =
                CalculatePaymentStatus(
                    totalAmount,
                    paidAmount,
                    dueDate
                );

            int feeID;

            if (!int.TryParse(
                hfFeeID.Value,
                out feeID))
            {
                feeID = 0;
            }

            try
            {
                if (feeID > 0)
                {
                    UpdateFee(
                        feeID,
                        studentID,
                        feeType,
                        description,
                        totalAmount,
                        paidAmount,
                        dueDate,
                        paymentStatus
                    );
                }
                else
                {
                    InsertFee(
                        studentID,
                        feeType,
                        description,
                        totalAmount,
                        paidAmount,
                        dueDate,
                        paymentStatus
                    );
                }
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to save the fee record. "
                    + ex.Message,
                    "error"
                );
            }
        }

        private void InsertFee(
            int studentID,
            string feeType,
            string description,
            decimal totalAmount,
            decimal paidAmount,
            DateTime dueDate,
            string paymentStatus)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
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
                VALUES
                (
                    @StudentID,
                    NULL,
                    @FeeType,
                    @Description,
                    @TotalAmount,
                    @PaidAmount,
                    @DueDate,
                    @PaymentStatus,
                    GETDATE()
                )";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    AddFeeParameters(
                        cmd,
                        studentID,
                        feeType,
                        description,
                        totalAmount,
                        paidAmount,
                        dueDate,
                        paymentStatus
                    );

                    con.Open();

                    int affectedRows =
                        cmd.ExecuteNonQuery();

                    if (affectedRows > 0)
                    {
                        RefreshPageData();
                        ClearForm();

                        ShowMessage(
                            "Additional student fee created successfully.",
                            "success"
                        );
                    }
                    else
                    {
                        ShowMessage(
                            "Unable to create the fee record.",
                            "error"
                        );
                    }
                }
            }
        }

        private void UpdateFee(
            int feeID,
            int studentID,
            string feeType,
            string description,
            decimal totalAmount,
            decimal paidAmount,
            DateTime dueDate,
            string paymentStatus)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                UPDATE dbo.StudentFee
                SET
                    StudentID = @StudentID,
                    FeeType = @FeeType,
                    Description = @Description,
                    TotalAmount = @TotalAmount,
                    PaidAmount = @PaidAmount,
                    DueDate = @DueDate,
                    PaymentStatus = @PaymentStatus
                WHERE FeeID = @FeeID";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    AddFeeParameters(
                        cmd,
                        studentID,
                        feeType,
                        description,
                        totalAmount,
                        paidAmount,
                        dueDate,
                        paymentStatus
                    );

                    cmd.Parameters.Add(
                        "@FeeID",
                        SqlDbType.Int
                    ).Value = feeID;

                    con.Open();

                    int affectedRows =
                        cmd.ExecuteNonQuery();

                    if (affectedRows > 0)
                    {
                        RefreshPageData();
                        ClearForm();

                        ShowMessage(
                            "Student fee record updated successfully.",
                            "success"
                        );
                    }
                    else
                    {
                        ShowMessage(
                            "Fee record could not be found.",
                            "warning"
                        );
                    }
                }
            }
        }

        private void AddFeeParameters(
            SqlCommand cmd,
            int studentID,
            string feeType,
            string description,
            decimal totalAmount,
            decimal paidAmount,
            DateTime dueDate,
            string paymentStatus)
        {
            cmd.Parameters.Add(
                "@StudentID",
                SqlDbType.Int
            ).Value = studentID;

            cmd.Parameters.Add(
                "@FeeType",
                SqlDbType.VarChar,
                100
            ).Value = feeType;

            cmd.Parameters.Add(
                "@Description",
                SqlDbType.VarChar,
                500
            ).Value =
                string.IsNullOrWhiteSpace(
                    description
                )
                ? (object)DBNull.Value
                : description;

            SqlParameter totalParameter =
                cmd.Parameters.Add(
                    "@TotalAmount",
                    SqlDbType.Decimal
                );

            totalParameter.Precision = 10;
            totalParameter.Scale = 2;
            totalParameter.Value = totalAmount;

            SqlParameter paidParameter =
                cmd.Parameters.Add(
                    "@PaidAmount",
                    SqlDbType.Decimal
                );

            paidParameter.Precision = 10;
            paidParameter.Scale = 2;
            paidParameter.Value = paidAmount;

            cmd.Parameters.Add(
                "@DueDate",
                SqlDbType.Date
            ).Value = dueDate.Date;

            cmd.Parameters.Add(
                "@PaymentStatus",
                SqlDbType.VarChar,
                30
            ).Value = paymentStatus;
        }

        protected void btnClear_Click(
            object sender,
            EventArgs e)
        {
            HideMessage();
            ClearForm();
        }

        private void ClearForm()
        {
            hfFeeID.Value =
                "0";

            if (
                ddlStudent.Items.FindByValue(
                    "0"
                ) != null
            )
            {
                ddlStudent.SelectedValue =
                    "0";
            }

            if (
                ddlFeeType.Items.FindByValue(
                    "Registration Fee"
                ) != null
            )
            {
                ddlFeeType.SelectedValue =
                    "Registration Fee";
            }

            txtDescription.Text =
                "";

            txtTotalAmount.Text =
                "";

            txtPaidAmount.Text =
                "0.00";

            txtDueDate.Text =
                "";

            btnSave.Text =
                "Save Additional Fee";
        }

        protected void btnFilter_Click(
            object sender,
            EventArgs e)
        {
            HideMessage();

            int studentID = 0;

            int.TryParse(
                ddlFilterStudent.SelectedValue,
                out studentID
            );

            try
            {
                LoadFeeRecords(
                    studentID,
                    ddlFilterStatus.SelectedValue,
                    txtSearch.Text.Trim()
                );
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to apply the fee filter. "
                    + ex.Message,
                    "error"
                );
            }
        }

        protected void btnResetFilter_Click(
            object sender,
            EventArgs e)
        {
            HideMessage();

            ddlFilterStudent.SelectedValue =
                "0";

            ddlFilterStatus.SelectedValue =
                "All";

            txtSearch.Text =
                "";

            try
            {
                LoadFeeRecords(
                    0,
                    "All",
                    ""
                );
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to reset the fee filter. "
                    + ex.Message,
                    "error"
                );
            }
        }

        private void LoadFeeRecords(
            int studentID,
            string paymentStatus,
            string searchText)
        {
            DataTable table =
                new DataTable();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    f.FeeID,
                    f.StudentID,
                    f.CourseID,
                    s.StudentName,
                    s.Email,
                    f.FeeType,
                    f.Description,
                    f.TotalAmount,
                    f.PaidAmount,
                    c.CourseCode,
                    c.CourseName,

                    CASE
                        WHEN f.TotalAmount - f.PaidAmount < 0
                        THEN 0
                        ELSE f.TotalAmount - f.PaidAmount
                    END AS OutstandingAmount,

                    f.DueDate,
                    f.CreatedAt,

                    CASE
                        WHEN f.PaidAmount >= f.TotalAmount
                        THEN 'Paid'

                        WHEN f.DueDate <
                             CAST(GETDATE() AS DATE)
                             AND f.PaidAmount < f.TotalAmount
                        THEN 'Overdue'

                        WHEN f.PaidAmount > 0
                             AND f.PaidAmount < f.TotalAmount
                        THEN 'Partially Paid'

                        ELSE 'Unpaid'
                    END AS DisplayStatus

                FROM dbo.StudentFee f

                INNER JOIN dbo.Student s
                    ON f.StudentID = s.StudentID

                LEFT JOIN dbo.Course c
                    ON f.CourseID = c.CourseID

                WHERE
                (
                    @StudentID = 0
                    OR f.StudentID = @StudentID
                )

                AND
                (
                    @PaymentStatus = 'All'

                    OR
                    CASE
                        WHEN f.PaidAmount >= f.TotalAmount
                        THEN 'Paid'

                        WHEN f.DueDate <
                             CAST(GETDATE() AS DATE)
                             AND f.PaidAmount < f.TotalAmount
                        THEN 'Overdue'

                        WHEN f.PaidAmount > 0
                             AND f.PaidAmount < f.TotalAmount
                        THEN 'Partially Paid'

                        ELSE 'Unpaid'
                    END = @PaymentStatus
                )

                AND
                (
                    @SearchText = ''

                    OR s.StudentName LIKE
                       '%' + @SearchText + '%'

                    OR s.Email LIKE
                       '%' + @SearchText + '%'

                    OR f.FeeType LIKE
                       '%' + @SearchText + '%'

                    OR f.Description LIKE
                       '%' + @SearchText + '%'

                    OR c.CourseCode LIKE
                       '%' + @SearchText + '%'

                    OR c.CourseName LIKE
                       '%' + @SearchText + '%'

                    OR CONVERT(
                        VARCHAR(20),
                        f.StudentID
                    ) LIKE
                       '%' + @SearchText + '%'
                )

                ORDER BY
                    CASE
                        WHEN f.PaidAmount >= f.TotalAmount
                        THEN 3

                        WHEN f.DueDate <
                             CAST(GETDATE() AS DATE)
                             AND f.PaidAmount < f.TotalAmount
                        THEN 0

                        WHEN f.PaidAmount > 0
                             AND f.PaidAmount < f.TotalAmount
                        THEN 1

                        ELSE 2
                    END,

                    f.DueDate ASC,
                    f.FeeID DESC";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@StudentID",
                        SqlDbType.Int
                    ).Value = studentID;

                    cmd.Parameters.Add(
                        "@PaymentStatus",
                        SqlDbType.VarChar,
                        30
                    ).Value = paymentStatus;

                    cmd.Parameters.Add(
                        "@SearchText",
                        SqlDbType.VarChar,
                        150
                    ).Value = searchText;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(table);
                    }
                }
            }

            gvFees.DataSource =
                table;

            gvFees.DataBind();
        }

        private void UpdateSummary()
        {
            decimal totalFees = 0;
            decimal totalPaid = 0;
            decimal outstanding = 0;

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    ISNULL(
                        SUM(TotalAmount),
                        0
                    ) AS TotalFees,

                    ISNULL(
                        SUM(PaidAmount),
                        0
                    ) AS TotalPaid,

                    ISNULL(
                        SUM(
                            CASE
                                WHEN TotalAmount - PaidAmount < 0
                                THEN 0
                                ELSE TotalAmount - PaidAmount
                            END
                        ),
                        0
                    ) AS OutstandingAmount

                FROM dbo.StudentFee";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            totalFees =
                                Convert.ToDecimal(
                                    reader["TotalFees"]
                                );

                            totalPaid =
                                Convert.ToDecimal(
                                    reader["TotalPaid"]
                                );

                            outstanding =
                                Convert.ToDecimal(
                                    reader["OutstandingAmount"]
                                );
                        }
                    }
                }
            }

            lblTotalFees.Text =
                totalFees.ToString("N2");

            lblTotalPaid.Text =
                totalPaid.ToString("N2");

            lblOutstanding.Text =
                outstanding.ToString("N2");
        }

        protected void gvFees_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            HideMessage();

            int feeID;

            if (!int.TryParse(
                e.CommandArgument.ToString(),
                out feeID))
            {
                ShowMessage(
                    "Invalid fee record selected.",
                    "error"
                );

                return;
            }

            if (e.CommandName == "EditFee")
            {
                LoadFeeForEditing(
                    feeID
                );
            }
            else if (
                e.CommandName == "DeleteFee"
            )
            {
                DeleteFee(
                    feeID
                );
            }
        }

        private void LoadFeeForEditing(
            int feeID)
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    string query = @"
                    SELECT
                        FeeID,
                        StudentID,
                        CourseID,
                        FeeType,
                        Description,
                        TotalAmount,
                        PaidAmount,
                        DueDate
                    FROM dbo.StudentFee
                    WHERE FeeID = @FeeID";

                    using (SqlCommand cmd =
                        new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add(
                            "@FeeID",
                            SqlDbType.Int
                        ).Value = feeID;

                        con.Open();

                        using (SqlDataReader reader =
                            cmd.ExecuteReader())
                        {
                            if (!reader.Read())
                            {
                                ShowMessage(
                                    "Fee record could not be found.",
                                    "warning"
                                );

                                return;
                            }

                            hfFeeID.Value =
                                reader["FeeID"].ToString();

                            string studentID =
                                reader["StudentID"].ToString();

                            if (
                                ddlStudent.Items.FindByValue(
                                    studentID
                                ) != null
                            )
                            {
                                ddlStudent.SelectedValue =
                                    studentID;
                            }

                            string feeType =
                                reader["FeeType"].ToString();

                            if (
                                ddlFeeType.Items.FindByValue(
                                    feeType
                                ) == null
                            )
                            {
                                ddlFeeType.Items.Add(
                                    new ListItem(
                                        feeType,
                                        feeType
                                    )
                                );
                            }

                            ddlFeeType.SelectedValue =
                                feeType;

                            txtDescription.Text =
                                reader["Description"] ==
                                DBNull.Value
                                ? ""
                                : reader["Description"].ToString();

                            txtTotalAmount.Text =
                                Convert.ToDecimal(
                                    reader["TotalAmount"]
                                ).ToString("0.00");

                            txtPaidAmount.Text =
                                Convert.ToDecimal(
                                    reader["PaidAmount"]
                                ).ToString("0.00");

                            txtDueDate.Text =
                                Convert.ToDateTime(
                                    reader["DueDate"]
                                ).ToString("yyyy-MM-dd");

                            btnSave.Text =
                                "Update Fee";

                            if (
                                reader["CourseID"] !=
                                DBNull.Value
                            )
                            {
                                ShowMessage(
                                    "Course fee loaded. You may update the payment amount and due date.",
                                    "success"
                                );
                            }
                            else
                            {
                                ShowMessage(
                                    "Additional fee loaded. Update the details and click Update Fee.",
                                    "success"
                                );
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to load the fee record. "
                    + ex.Message,
                    "error"
                );
            }
        }

        private void DeleteFee(
            int feeID)
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    string query = @"
                    DELETE FROM dbo.StudentFee
                    WHERE FeeID = @FeeID";

                    using (SqlCommand cmd =
                        new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add(
                            "@FeeID",
                            SqlDbType.Int
                        ).Value = feeID;

                        con.Open();

                        int affectedRows =
                            cmd.ExecuteNonQuery();

                        if (affectedRows > 0)
                        {
                            if (
                                hfFeeID.Value ==
                                feeID.ToString()
                            )
                            {
                                ClearForm();
                            }

                            RefreshPageData();

                            ShowMessage(
                                "Fee record deleted successfully.",
                                "success"
                            );
                        }
                        else
                        {
                            ShowMessage(
                                "Fee record could not be found.",
                                "warning"
                            );
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to delete the fee record. "
                    + ex.Message,
                    "error"
                );
            }
        }

        private string CalculatePaymentStatus(
            decimal totalAmount,
            decimal paidAmount,
            DateTime dueDate)
        {
            if (paidAmount >= totalAmount)
            {
                return "Paid";
            }

            if (
                dueDate.Date < DateTime.Today
                && paidAmount < totalAmount
            )
            {
                return "Overdue";
            }

            if (
                paidAmount > 0
                && paidAmount < totalAmount
            )
            {
                return "Partially Paid";
            }

            return "Unpaid";
        }

        private void RefreshPageData()
        {
            LoadFeeRecords(
                0,
                "All",
                ""
            );

            ddlFilterStudent.SelectedValue =
                "0";

            ddlFilterStatus.SelectedValue =
                "All";

            txtSearch.Text =
                "";

            UpdateSummary();
        }

        private void ShowCourseFeeMessage(
            string message,
            string type)
        {
            lblCourseFeeMessage.Visible =
                true;

            lblCourseFeeMessage.Text =
                message;

            if (type == "success")
            {
                lblCourseFeeMessage.CssClass =
                    "message-label alert alert-success";
            }
            else if (type == "warning")
            {
                lblCourseFeeMessage.CssClass =
                    "message-label alert alert-warning";
            }
            else
            {
                lblCourseFeeMessage.CssClass =
                    "message-label alert alert-danger";
            }
        }

        private void HideCourseFeeMessage()
        {
            lblCourseFeeMessage.Visible =
                false;

            lblCourseFeeMessage.Text =
                "";
        }

        private void ShowMessage(
            string message,
            string type)
        {
            lblMessage.Visible =
                true;

            lblMessage.Text =
                message;

            if (type == "success")
            {
                lblMessage.CssClass =
                    "message-label alert alert-success";
            }
            else if (type == "warning")
            {
                lblMessage.CssClass =
                    "message-label alert alert-warning";
            }
            else
            {
                lblMessage.CssClass =
                    "message-label alert alert-danger";
            }
        }

        private void HideMessage()
        {
            lblMessage.Visible =
                false;

            lblMessage.Text =
                "";
        }
    }


}
