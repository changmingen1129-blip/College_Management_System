<%@ Page Language="C#" AutoEventWireup="true"
MasterPageFile="~/StudentMaster.Master"
CodeBehind="StudentPayment.aspx.cs"
Inherits="College_Management_System.StudentPayment" %>

<asp:Content ID="HeadContent"
ContentPlaceHolderID="HeadContent"
runat="server">


<style>
    .payment-header {
        background: linear-gradient(135deg, #1e3a8a, #059669);
        color: white;
        border-radius: 24px;
        padding: 30px;
        margin-bottom: 28px;
        box-shadow: 0 12px 30px rgba(15, 23, 42, 0.16);
    }

    .payment-header h2 {
        margin-bottom: 7px;
        font-weight: 800;
    }

    .payment-header p {
        margin-bottom: 0;
        color: #d1fae5;
    }

    .header-icon {
        width: 72px;
        height: 72px;
        border-radius: 22px;
        background: rgba(255, 255, 255, 0.16);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 30px;
    }

    .payment-layout {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 24px;
    }

    .content-card {
        background: white;
        border-radius: 22px;
        padding: 26px;
        box-shadow: 0 8px 25px rgba(15, 23, 42, 0.08);
    }

    .card-title-custom {
        color: #0f172a;
        font-weight: 800;
        margin-bottom: 5px;
    }

    .card-subtitle-custom {
        color: #64748b;
        margin-bottom: 22px;
    }

    .fee-summary-box {
        background: linear-gradient(135deg, #eff6ff, #f0fdfa);
        border: 1px solid #bfdbfe;
        border-radius: 18px;
        padding: 20px;
        margin-bottom: 20px;
    }

    .fee-type {
        color: #0f172a;
        font-size: 21px;
        font-weight: 800;
        margin-bottom: 5px;
    }

    .course-code {
        color: #1d4ed8;
        font-size: 14px;
        font-weight: 800;
    }

    .course-name {
        color: #475569;
        font-weight: 650;
        margin-top: 2px;
    }

    .fee-description {
        color: #64748b;
        line-height: 1.6;
        margin-top: 12px;
    }

    .amount-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 12px;
        margin-top: 18px;
    }

    .amount-box {
        background: white;
        border-radius: 14px;
        padding: 14px;
        border: 1px solid #e2e8f0;
    }

    .amount-label {
        color: #64748b;
        font-size: 12px;
        font-weight: 700;
        margin-bottom: 4px;
    }

    .amount-value {
        color: #0f172a;
        font-size: 17px;
        font-weight: 800;
    }

    .paid-value {
        color: #15803d;
    }

    .outstanding-value {
        color: #b91c1c;
    }

    .form-label {
        color: #334155;
        font-weight: 700;
        margin-bottom: 8px;
    }

    .form-control,
    .form-select {
        border-radius: 13px;
        padding: 11px 13px;
        border: 1px solid #cbd5e1;
    }

    .form-control:focus,
    .form-select:focus {
        border-color: #059669;
        box-shadow: 0 0 0 0.2rem rgba(5, 150, 105, 0.14);
    }

    .btn-pay {
        border: none;
        border-radius: 13px;
        padding: 12px 22px;
        background: linear-gradient(135deg, #059669, #10b981);
        color: white;
        font-weight: 800;
    }

    .btn-cancel {
        border: none;
        border-radius: 13px;
        padding: 12px 22px;
        background: #e2e8f0;
        color: #334155;
        font-weight: 800;
    }

    .payment-info {
        background: #f8fafc;
        border-radius: 16px;
        padding: 17px;
        color: #475569;
        line-height: 1.7;
        margin-bottom: 20px;
    }

    .payment-info i {
        color: #2563eb;
        margin-right: 6px;
    }

    .message-label {
        display: block;
        padding: 12px 14px;
        border-radius: 12px;
        margin-bottom: 20px;
        font-weight: 650;
    }

    .success-card {
        background: white;
        border-radius: 22px;
        padding: 40px 25px;
        text-align: center;
        box-shadow: 0 8px 25px rgba(15, 23, 42, 0.08);
    }

    .success-icon {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        background: #dcfce7;
        color: #15803d;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 18px;
        font-size: 34px;
    }

    .success-card h3 {
        color: #0f172a;
        font-weight: 800;
        margin-bottom: 8px;
    }

    .success-card p {
        color: #64748b;
    }

    .reference-box {
        background: #f8fafc;
        border-radius: 14px;
        padding: 15px;
        margin: 20px auto;
        max-width: 420px;
    }

    .reference-label {
        color: #64748b;
        font-size: 12px;
        font-weight: 700;
    }

    .reference-value {
        color: #0f172a;
        font-size: 18px;
        font-weight: 800;
        margin-top: 3px;
    }

    @media (max-width: 900px) {
        .payment-layout {
            grid-template-columns: 1fr;
        }

        .amount-grid {
            grid-template-columns: 1fr;
        }
    }
</style>


</asp:Content>

<asp:Content ID="MainContent"
ContentPlaceHolderID="MainContent"
runat="server">


<div class="payment-header">

    <div class="row align-items-center">

        <div class="col-md-9">

            <h2>Make Payment</h2>

            <p>
                Pay your outstanding course or additional fee securely through the student portal.
            </p>

        </div>

        <div class="col-md-3 d-flex justify-content-md-end">

            <div class="header-icon">
                <i class="fa-solid fa-credit-card"></i>
            </div>

        </div>

    </div>

</div>

<asp:Label ID="lblMessage"
    runat="server"
    Visible="false">
</asp:Label>

<asp:Panel ID="pnlPayment"
    runat="server">

    <div class="payment-layout">

        <div class="content-card">

            <h4 class="card-title-custom">
                Fee Details
            </h4>

            <p class="card-subtitle-custom">
                Review the selected fee before making a payment.
            </p>

            <div class="fee-summary-box">

                <div class="fee-type">

                    <asp:Label ID="lblFeeType"
                        runat="server"
                        Text="-">
                    </asp:Label>

                </div>

                <asp:Panel ID="pnlCourseInformation"
                    runat="server"
                    Visible="false">

                    <div class="course-code">

                        <asp:Label ID="lblCourseCode"
                            runat="server">
                        </asp:Label>

                    </div>

                    <div class="course-name">

                        <asp:Label ID="lblCourseName"
                            runat="server">
                        </asp:Label>

                    </div>

                </asp:Panel>

                <div class="fee-description">

                    <asp:Label ID="lblDescription"
                        runat="server"
                        Text="No description provided.">
                    </asp:Label>

                </div>

                <div class="amount-grid">

                    <div class="amount-box">

                        <div class="amount-label">
                            Total Fee
                        </div>

                        <div class="amount-value">

                            RM
                            <asp:Label ID="lblTotalAmount"
                                runat="server"
                                Text="0.00">
                            </asp:Label>

                        </div>

                    </div>

                    <div class="amount-box">

                        <div class="amount-label">
                            Already Paid
                        </div>

                        <div class="amount-value paid-value">

                            RM
                            <asp:Label ID="lblPaidAmount"
                                runat="server"
                                Text="0.00">
                            </asp:Label>

                        </div>

                    </div>

                    <div class="amount-box">

                        <div class="amount-label">
                            Outstanding
                        </div>

                        <div class="amount-value outstanding-value">

                            RM
                            <asp:Label ID="lblOutstandingAmount"
                                runat="server"
                                Text="0.00">
                            </asp:Label>

                        </div>

                    </div>

                </div>

            </div>

            <div class="payment-info">

                <i class="fa-solid fa-circle-info"></i>

                This is a simulated payment feature for the college management system.
                No real bank transaction will be processed.

            </div>

        </div>

        <div class="content-card">

            <h4 class="card-title-custom">
                Payment Information
            </h4>

            <p class="card-subtitle-custom">
                Enter the amount and choose a payment method.
            </p>

            <asp:HiddenField ID="hfFeeID"
                runat="server"
                Value="0" />

            <asp:HiddenField ID="hfOutstandingAmount"
                runat="server"
                Value="0" />

            <div class="row g-3">

                <div class="col-12">

                    <label class="form-label">
                        Payment Amount
                    </label>

                    <asp:TextBox ID="txtPaymentAmount"
                        runat="server"
                        CssClass="form-control"
                        TextMode="Number"
                        step="0.01"
                        min="0.01"
                        placeholder="Enter payment amount">
                    </asp:TextBox>

                    <asp:RequiredFieldValidator ID="rfvPaymentAmount"
                        runat="server"
                        ControlToValidate="txtPaymentAmount"
                        ValidationGroup="PaymentValidation"
                        ErrorMessage="Payment amount is required."
                        ForeColor="#dc2626"
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>

                </div>

                <div class="col-12">

                    <label class="form-label">
                        Payment Method
                    </label>

                    <asp:DropDownList ID="ddlPaymentMethod"
                        runat="server"
                        CssClass="form-select">

                        <asp:ListItem Text="Online Banking"
                            Value="Online Banking">
                        </asp:ListItem>

                        <asp:ListItem Text="Credit / Debit Card"
                            Value="Card">
                        </asp:ListItem>

                        <asp:ListItem Text="FPX"
                            Value="FPX">
                        </asp:ListItem>

                        <asp:ListItem Text="E-Wallet"
                            Value="E-Wallet">
                        </asp:ListItem>

                    </asp:DropDownList>

                </div>

                <div class="col-12">

                    <label class="form-label">
                        Account Holder Name
                    </label>

                    <asp:TextBox ID="txtAccountName"
                        runat="server"
                        CssClass="form-control"
                        MaxLength="100"
                        placeholder="Enter account holder name">
                    </asp:TextBox>

                    <asp:RequiredFieldValidator ID="rfvAccountName"
                        runat="server"
                        ControlToValidate="txtAccountName"
                        ValidationGroup="PaymentValidation"
                        ErrorMessage="Account holder name is required."
                        ForeColor="#dc2626"
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>

                </div>

                <div class="col-12">

                    <asp:CheckBox ID="chkConfirm"
                        runat="server"
                        Text=" I confirm that the payment information is correct." />

                    <br />

                    <asp:CustomValidator ID="cvConfirm"
                        runat="server"
                        ValidationGroup="PaymentValidation"
                        ErrorMessage="Please confirm the payment information."
                        ForeColor="#dc2626"
                        Display="Dynamic"
                        OnServerValidate="cvConfirm_ServerValidate">
                    </asp:CustomValidator>

                </div>

                <div class="col-12">

                    <asp:Button ID="btnConfirmPayment"
                        runat="server"
                        Text="Confirm Payment"
                        CssClass="btn btn-pay"
                        ValidationGroup="PaymentValidation"
                        OnClick="btnConfirmPayment_Click" />

                    <asp:Button ID="btnCancel"
                        runat="server"
                        Text="Cancel"
                        CssClass="btn btn-cancel ms-2"
                        CausesValidation="false"
                        OnClick="btnCancel_Click" />

                </div>

            </div>

        </div>

    </div>

</asp:Panel>

<asp:Panel ID="pnlSuccess"
    runat="server"
    Visible="false">

    <div class="success-card">

        <div class="success-icon">
            <i class="fa-solid fa-check"></i>
        </div>

        <h3>Payment Successful</h3>

        <p>
            Your payment has been recorded successfully.
        </p>

        <div class="reference-box">

            <div class="reference-label">
                Payment Reference
            </div>

            <div class="reference-value">

                <asp:Label ID="lblPaymentReference"
                    runat="server">
                </asp:Label>

            </div>

        </div>

        <asp:Button ID="btnBackToFees"
            runat="server"
            Text="Back to My Fees"
            CssClass="btn btn-pay"
            CausesValidation="false"
            OnClick="btnBackToFees_Click" />

    </div>

</asp:Panel>


</asp:Content>
