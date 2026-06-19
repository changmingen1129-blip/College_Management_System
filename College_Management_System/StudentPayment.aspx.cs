using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class StudentPayment : System.Web.UI.Page
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
                int feeID;

                if (!TryGetFeeID(
                    out feeID))
                {
                    ShowMessage(
                        "No valid fee record was selected.",
                        "error"
                    );

                    pnlPayment.Visible =
                        false;

                    return;
                }

                try
                {
                    LoadFeeDetails(
                        studentID,
                        feeID
                    );
                }
                catch (Exception ex)
                {
                    ShowMessage(
                        "Unable to load the selected fee. "
                        + ex.Message,
                        "error"
                    );

                    pnlPayment.Visible =
                        false;
                }
            }
        }

        private void LoadFeeDetails(
            int studentID,
            int feeID)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    f.FeeID,
                    f.StudentID,
                    f.CourseID,
                    f.FeeType,
                    f.Description,
                    f.TotalAmount,
                    f.PaidAmount,
                    f.DueDate,
                    f.PaymentStatus,
                    c.CourseCode,
                    c.CourseName

                FROM dbo.StudentFee f

                LEFT JOIN dbo.Course c
                    ON f.CourseID =
                       c.CourseID

                WHERE f.FeeID =
                      @FeeID

                  AND f.StudentID =
                      @StudentID";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@FeeID",
                        SqlDbType.Int
                    ).Value = feeID;

                    cmd.Parameters.Add(
                        "@StudentID",
                        SqlDbType.Int
                    ).Value = studentID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            ShowMessage(
                                "The selected fee record could not be found or does not belong to your account.",
                                "error"
                            );

                            pnlPayment.Visible =
                                false;

                            return;
                        }

                        decimal totalAmount =
                            Convert.ToDecimal(
                                reader["TotalAmount"]
                            );

                        decimal paidAmount =
                            Convert.ToDecimal(
                                reader["PaidAmount"]
                            );

                        decimal outstandingAmount =
                            totalAmount - paidAmount;

                        if (outstandingAmount < 0)
                        {
                            outstandingAmount = 0;
                        }

                        hfFeeID.Value =
                            reader["FeeID"].ToString();

                        hfOutstandingAmount.Value =
                            outstandingAmount.ToString(
                                "0.00"
                            );

                        lblFeeType.Text =
                            reader["FeeType"].ToString();

                        lblDescription.Text =
                            reader["Description"] ==
                            DBNull.Value
                            || string.IsNullOrWhiteSpace(
                                reader["Description"]
                                    .ToString()
                            )
                                ? "No description provided."
                                : reader["Description"]
                                    .ToString();

                        lblTotalAmount.Text =
                            totalAmount.ToString("N2");

                        lblPaidAmount.Text =
                            paidAmount.ToString("N2");

                        lblOutstandingAmount.Text =
                            outstandingAmount.ToString(
                                "N2"
                            );

                        if (
                            reader["CourseID"] !=
                            DBNull.Value
                        )
                        {
                            pnlCourseInformation.Visible =
                                true;

                            lblCourseCode.Text =
                                reader["CourseCode"] ==
                                DBNull.Value
                                    ? ""
                                    : reader["CourseCode"]
                                        .ToString();

                            lblCourseName.Text =
                                reader["CourseName"] ==
                                DBNull.Value
                                    ? ""
                                    : reader["CourseName"]
                                        .ToString();
                        }
                        else
                        {
                            pnlCourseInformation.Visible =
                                false;
                        }

                        if (outstandingAmount <= 0)
                        {
                            ShowMessage(
                                "This fee has already been fully paid.",
                                "success"
                            );

                            txtPaymentAmount.Text =
                                "";

                            txtPaymentAmount.Enabled =
                                false;

                            ddlPaymentMethod.Enabled =
                                false;

                            txtAccountName.Enabled =
                                false;

                            chkConfirm.Enabled =
                                false;

                            btnConfirmPayment.Enabled =
                                false;
                        }
                        else
                        {
                            txtPaymentAmount.Text =
                                outstandingAmount.ToString(
                                    "0.00"
                                );

                            txtPaymentAmount.Enabled =
                                true;

                            ddlPaymentMethod.Enabled =
                                true;

                            txtAccountName.Enabled =
                                true;

                            chkConfirm.Enabled =
                                true;

                            btnConfirmPayment.Enabled =
                                true;
                        }
                    }
                }
            }
        }

        protected void btnConfirmPayment_Click(
            object sender,
            EventArgs e)
        {
            HideMessage();

            Page.Validate(
                "PaymentValidation"
            );

            if (!Page.IsValid)
            {
                ShowMessage(
                    "Please complete all required payment information.",
                    "warning"
                );

                return;
            }

            int studentID;

            if (!TryGetStudentID(
                out studentID))
            {
                return;
            }

            int feeID;

            if (!int.TryParse(
                hfFeeID.Value,
                out feeID)
                || feeID <= 0)
            {
                ShowMessage(
                    "Invalid fee record selected.",
                    "error"
                );

                return;
            }

            decimal paymentAmount;

            if (!decimal.TryParse(
                txtPaymentAmount.Text,
                out paymentAmount)
                || paymentAmount <= 0)
            {
                ShowMessage(
                    "Payment amount must be greater than zero.",
                    "warning"
                );

                return;
            }

            string paymentMethod =
                ddlPaymentMethod.SelectedValue;

            string accountName =
                txtAccountName.Text.Trim();

            if (
                string.IsNullOrWhiteSpace(
                    accountName
                )
            )
            {
                ShowMessage(
                    "Please enter the account holder name.",
                    "warning"
                );

                return;
            }

            try
            {
                ProcessPayment(
                    studentID,
                    feeID,
                    paymentAmount,
                    paymentMethod
                );
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to process the payment. "
                    + ex.Message,
                    "error"
                );
            }
        }

        private void ProcessPayment(
            int studentID,
            int feeID,
            decimal paymentAmount,
            string paymentMethod)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                con.Open();

                SqlTransaction transaction =
                    con.BeginTransaction();

                try
                {
                    decimal totalAmount;
                    decimal currentPaidAmount;

                    string feeQuery = @"
                    SELECT
                        TotalAmount,
                        PaidAmount

                    FROM dbo.StudentFee
                    WITH
                    (
                        UPDLOCK,
                        ROWLOCK
                    )

                    WHERE FeeID =
                          @FeeID

                      AND StudentID =
                          @StudentID";

                    using (SqlCommand feeCmd =
                        new SqlCommand(
                            feeQuery,
                            con,
                            transaction
                        ))
                    {
                        feeCmd.Parameters.Add(
                            "@FeeID",
                            SqlDbType.Int
                        ).Value = feeID;

                        feeCmd.Parameters.Add(
                            "@StudentID",
                            SqlDbType.Int
                        ).Value = studentID;

                        using (SqlDataReader reader =
                            feeCmd.ExecuteReader())
                        {
                            if (!reader.Read())
                            {
                                throw new Exception(
                                    "The selected fee record could not be found."
                                );
                            }

                            totalAmount =
                                Convert.ToDecimal(
                                    reader["TotalAmount"]
                                );

                            currentPaidAmount =
                                Convert.ToDecimal(
                                    reader["PaidAmount"]
                                );
                        }
                    }

                    decimal outstandingAmount =
                        totalAmount -
                        currentPaidAmount;

                    if (outstandingAmount <= 0)
                    {
                        throw new Exception(
                            "This fee has already been fully paid."
                        );
                    }

                    if (
                        paymentAmount >
                        outstandingAmount
                    )
                    {
                        throw new Exception(
                            "Payment amount cannot be greater than the outstanding balance of RM "
                            + outstandingAmount.ToString(
                                "N2"
                            )
                            + "."
                        );
                    }

                    decimal newPaidAmount =
                        currentPaidAmount +
                        paymentAmount;

                    string newPaymentStatus =
                        newPaidAmount >= totalAmount
                            ? "Paid"
                            : "Partially Paid";

                    string referenceNumber =
                        GenerateReferenceNumber();

                    string insertPaymentQuery = @"
                    INSERT INTO dbo.FeePayment
                    (
                        FeeID,
                        StudentID,
                        PaymentAmount,
                        PaymentMethod,
                        ReferenceNumber,
                        PaymentDate,
                        PaymentStatus
                    )
                    VALUES
                    (
                        @FeeID,
                        @StudentID,
                        @PaymentAmount,
                        @PaymentMethod,
                        @ReferenceNumber,
                        GETDATE(),
                        'Successful'
                    )";

                    using (SqlCommand paymentCmd =
                        new SqlCommand(
                            insertPaymentQuery,
                            con,
                            transaction
                        ))
                    {
                        paymentCmd.Parameters.Add(
                            "@FeeID",
                            SqlDbType.Int
                        ).Value = feeID;

                        paymentCmd.Parameters.Add(
                            "@StudentID",
                            SqlDbType.Int
                        ).Value = studentID;

                        SqlParameter amountParameter =
                            paymentCmd.Parameters.Add(
                                "@PaymentAmount",
                                SqlDbType.Decimal
                            );

                        amountParameter.Precision =
                            10;

                        amountParameter.Scale =
                            2;

                        amountParameter.Value =
                            paymentAmount;

                        paymentCmd.Parameters.Add(
                            "@PaymentMethod",
                            SqlDbType.VarChar,
                            50
                        ).Value = paymentMethod;

                        paymentCmd.Parameters.Add(
                            "@ReferenceNumber",
                            SqlDbType.VarChar,
                            100
                        ).Value =
                            referenceNumber;

                        paymentCmd.ExecuteNonQuery();
                    }

                    string updateFeeQuery = @"
                    UPDATE dbo.StudentFee
                    SET
                        PaidAmount =
                            @NewPaidAmount,

                        PaymentStatus =
                            @PaymentStatus

                    WHERE FeeID =
                          @FeeID

                      AND StudentID =
                          @StudentID";

                    using (SqlCommand updateCmd =
                        new SqlCommand(
                            updateFeeQuery,
                            con,
                            transaction
                        ))
                    {
                        SqlParameter paidParameter =
                            updateCmd.Parameters.Add(
                                "@NewPaidAmount",
                                SqlDbType.Decimal
                            );

                        paidParameter.Precision =
                            10;

                        paidParameter.Scale =
                            2;

                        paidParameter.Value =
                            newPaidAmount;

                        updateCmd.Parameters.Add(
                            "@PaymentStatus",
                            SqlDbType.VarChar,
                            30
                        ).Value =
                            newPaymentStatus;

                        updateCmd.Parameters.Add(
                            "@FeeID",
                            SqlDbType.Int
                        ).Value = feeID;

                        updateCmd.Parameters.Add(
                            "@StudentID",
                            SqlDbType.Int
                        ).Value = studentID;

                        int affectedRows =
                            updateCmd.ExecuteNonQuery();

                        if (affectedRows <= 0)
                        {
                            throw new Exception(
                                "The fee payment could not be updated."
                            );
                        }
                    }

                    transaction.Commit();

                    lblPaymentReference.Text =
                        referenceNumber;

                    pnlPayment.Visible =
                        false;

                    pnlSuccess.Visible =
                        true;
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

                    throw;
                }
            }
        }

        protected void cvConfirm_ServerValidate(
            object source,
            System.Web.UI.WebControls
                .ServerValidateEventArgs args)
        {
            args.IsValid =
                chkConfirm.Checked;
        }

        protected void btnCancel_Click(
            object sender,
            EventArgs e)
        {
            Response.Redirect(
                ResolveUrl(
                    "~/StudentFees.aspx"
                ),
                false
            );

            Context.ApplicationInstance
                .CompleteRequest();
        }

        protected void btnBackToFees_Click(
            object sender,
            EventArgs e)
        {
            Response.Redirect(
                ResolveUrl(
                    "~/StudentFees.aspx"
                ),
                false
            );

            Context.ApplicationInstance
                .CompleteRequest();
        }

        private bool TryGetFeeID(
            out int feeID)
        {
            feeID = 0;

            string feeValue =
                Request.QueryString["FeeID"];

            if (
                string.IsNullOrWhiteSpace(
                    feeValue
                )
            )
            {
                return false;
            }

            return int.TryParse(
                feeValue,
                out feeID
            )
            && feeID > 0;
        }

        private bool TryGetStudentID(
            out int studentID)
        {
            studentID = 0;

            if (
                Session["StudentID"] ==
                null
            )
            {
                RedirectToLogin();
                return false;
            }

            if (!int.TryParse(
                Session["StudentID"]
                    .ToString(),
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

        private string GenerateReferenceNumber()
        {
            return
                "PAY-"
                + DateTime.Now.ToString(
                    "yyyyMMddHHmmss"
                )
                + "-"
                + Guid.NewGuid()
                    .ToString("N")
                    .Substring(0, 6)
                    .ToUpper();
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
