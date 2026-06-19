<%@ Page Language="C#" AutoEventWireup="true"
MasterPageFile="~/StudentMaster.Master"
CodeBehind="StudentFees.aspx.cs"
Inherits="College_Management_System.StudentFees" %>

<asp:Content ID="HeadContent"
ContentPlaceHolderID="HeadContent"
runat="server">


<style>
    .fees-header {
        background: linear-gradient(135deg, #1e3a8a, #059669);
        color: white;
        border-radius: 24px;
        padding: 30px;
        margin-bottom: 28px;
        box-shadow: 0 12px 30px rgba(15, 23, 42, 0.16);
    }

    .fees-header h2 {
        margin-bottom: 7px;
        font-weight: 800;
    }

    .fees-header p {
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

    .summary-card {
        background: white;
        border-radius: 20px;
        padding: 22px;
        box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
        height: 100%;
    }

    .summary-card h3 {
        margin: 0;
        color: #0f172a;
        font-weight: 800;
    }

    .summary-card p {
        margin: 5px 0 0;
        color: #64748b;
    }

    .summary-icon {
        width: 52px;
        height: 52px;
        border-radius: 16px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 21px;
    }

    .icon-total {
        background: #dbeafe;
        color: #1d4ed8;
    }

    .icon-paid {
        background: #dcfce7;
        color: #15803d;
    }

    .icon-outstanding {
        background: #fee2e2;
        color: #b91c1c;
    }

    .filter-card {
        background: white;
        border-radius: 20px;
        padding: 22px;
        margin-top: 26px;
        margin-bottom: 26px;
        box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
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

    .btn-filter {
        border: none;
        border-radius: 13px;
        padding: 11px 20px;
        background: linear-gradient(135deg, #059669, #10b981);
        color: white;
        font-weight: 700;
    }

    .btn-reset {
        border: none;
        border-radius: 13px;
        padding: 11px 20px;
        background: #e2e8f0;
        color: #334155;
        font-weight: 700;
    }

    .fee-card {
        background: white;
        border-radius: 22px;
        padding: 24px;
        margin-bottom: 20px;
        box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
        border-left: 6px solid #2563eb;
    }

    .fee-card.paid {
        border-left-color: #16a34a;
    }

    .fee-card.partial {
        border-left-color: #d97706;
    }

    .fee-card.overdue {
        border-left-color: #dc2626;
    }

    .fee-card-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 15px;
        margin-bottom: 16px;
    }

    .fee-title {
        color: #0f172a;
        font-size: 21px;
        font-weight: 800;
        margin-bottom: 5px;
    }

    .fee-record-id {
        color: #94a3b8;
        font-size: 12px;
        font-weight: 700;
    }

    .fee-source-badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 7px 12px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 800;
        white-space: nowrap;
    }

    .course-fee-badge {
        background: #dbeafe;
        color: #1d4ed8;
    }

    .additional-fee-badge {
        background: #ede9fe;
        color: #6d28d9;
    }

    .course-box {
        background: linear-gradient(135deg, #eff6ff, #f0fdfa);
        border: 1px solid #bfdbfe;
        border-radius: 16px;
        padding: 16px;
        margin-bottom: 16px;
    }

    .course-box-label {
        color: #64748b;
        font-size: 12px;
        font-weight: 800;
        letter-spacing: 0.5px;
        text-transform: uppercase;
        margin-bottom: 6px;
    }

    .course-code {
        color: #1d4ed8;
        font-size: 14px;
        font-weight: 800;
        margin-bottom: 2px;
    }

    .course-name {
        color: #0f172a;
        font-size: 17px;
        font-weight: 750;
    }

    .fee-description {
        color: #475569;
        line-height: 1.7;
        white-space: pre-line;
        margin-bottom: 18px;
    }

    .fee-amounts {
        display: grid;
        grid-template-columns: repeat(3, minmax(150px, 1fr));
        gap: 14px;
        margin-bottom: 18px;
    }

    .amount-box {
        background: #f8fafc;
        border-radius: 14px;
        padding: 15px;
        border: 1px solid #e2e8f0;
    }

    .amount-label {
        color: #64748b;
        font-size: 13px;
        font-weight: 700;
        margin-bottom: 4px;
    }

    .amount-value {
        color: #0f172a;
        font-size: 18px;
        font-weight: 800;
    }

    .paid-value {
        color: #15803d;
    }

    .outstanding-value {
        color: #b91c1c;
    }

    .fee-meta {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        align-items: center;
    }

    .meta-badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 7px 12px;
        border-radius: 999px;
        font-size: 13px;
        font-weight: 700;
    }

    .badge-date {
        background: #dbeafe;
        color: #1d4ed8;
    }

    .badge-created {
        background: #f1f5f9;
        color: #475569;
    }

    .badge-paid {
        background: #dcfce7;
        color: #15803d;
    }

    .badge-partial {
        background: #fef3c7;
        color: #b45309;
    }

    .badge-unpaid {
        background: #e0e7ff;
        color: #4338ca;
    }

    .badge-overdue {
        background: #fee2e2;
        color: #b91c1c;
    }

    .payment-note {
        margin-top: 18px;
        padding: 13px 15px;
        border-radius: 13px;
        background: #f8fafc;
        color: #64748b;
        font-size: 13px;
        line-height: 1.6;
    }

    .payment-action {
        margin-top: 18px;
        display: flex;
        justify-content: flex-end;
        align-items: center;
        gap: 10px;
    }

    .btn-pay-now {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        border: none;
        border-radius: 13px;
        padding: 12px 22px;
        background: linear-gradient(135deg, #059669, #10b981);
        color: white;
        text-decoration: none;
        font-weight: 800;
        transition: 0.2s;
    }

    .btn-pay-now:hover {
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 7px 18px rgba(5, 150, 105, 0.25);
    }

    .fully-paid-label {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        border-radius: 13px;
        padding: 12px 22px;
        background: #dcfce7;
        color: #15803d;
        font-weight: 800;
    }

    .empty-state {
        background: white;
        border-radius: 22px;
        padding: 50px 20px;
        text-align: center;
        box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
    }

    .empty-state i {
        font-size: 45px;
        color: #94a3b8;
        margin-bottom: 15px;
    }

    .empty-state h4 {
        color: #334155;
        font-weight: 800;
    }

    .empty-state p {
        color: #64748b;
        margin-bottom: 0;
    }

    .message-label {
        display: block;
        padding: 12px 14px;
        border-radius: 12px;
        margin-bottom: 20px;
        font-weight: 650;
    }

    @media (max-width: 768px) {
        .fee-amounts {
            grid-template-columns: 1fr;
        }

        .fee-card-header {
            flex-direction: column;
        }

        .payment-action {
            justify-content: stretch;
        }

        .btn-pay-now,
        .fully-paid-label {
            width: 100%;
        }
    }
</style>


</asp:Content>

<asp:Content ID="MainContent"
ContentPlaceHolderID="MainContent"
runat="server">


<div class="fees-header">

    <div class="row align-items-center">

        <div class="col-md-9">

            <h2>My Fees</h2>

            <p>
                View your course fees, additional charges, payments, outstanding balances and due dates.
            </p>

        </div>

        <div class="col-md-3 d-flex justify-content-md-end">

            <div class="header-icon">
                <i class="fa-solid fa-wallet"></i>
            </div>

        </div>

    </div>

</div>

<asp:Label ID="lblMessage"
    runat="server"
    Visible="false">
</asp:Label>

<div class="row g-4">

    <div class="col-md-4">

        <div class="summary-card">

            <div class="d-flex justify-content-between align-items-center">

                <div>

                    <h3>
                        RM
                        <asp:Label ID="lblTotalFees"
                            runat="server"
                            Text="0.00">
                        </asp:Label>
                    </h3>

                    <p>Total Fees</p>

                </div>

                <div class="summary-icon icon-total">
                    <i class="fa-solid fa-file-invoice-dollar"></i>
                </div>

            </div>

        </div>

    </div>

    <div class="col-md-4">

        <div class="summary-card">

            <div class="d-flex justify-content-between align-items-center">

                <div>

                    <h3>
                        RM
                        <asp:Label ID="lblTotalPaid"
                            runat="server"
                            Text="0.00">
                        </asp:Label>
                    </h3>

                    <p>Total Paid</p>

                </div>

                <div class="summary-icon icon-paid">
                    <i class="fa-solid fa-circle-check"></i>
                </div>

            </div>

        </div>

    </div>

    <div class="col-md-4">

        <div class="summary-card">

            <div class="d-flex justify-content-between align-items-center">

                <div>

                    <h3>
                        RM
                        <asp:Label ID="lblOutstanding"
                            runat="server"
                            Text="0.00">
                        </asp:Label>
                    </h3>

                    <p>Outstanding Balance</p>

                </div>

                <div class="summary-icon icon-outstanding">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>

            </div>

        </div>

    </div>

</div>

<div class="filter-card">

    <div class="row g-3 align-items-end">

        <div class="col-md-4">

            <label class="form-label">
                Payment Status
            </label>

            <asp:DropDownList ID="ddlStatus"
                runat="server"
                CssClass="form-select">

                <asp:ListItem Text="All Statuses"
                    Value="All">
                </asp:ListItem>

                <asp:ListItem Text="Unpaid"
                    Value="Unpaid">
                </asp:ListItem>

                <asp:ListItem Text="Partially Paid"
                    Value="Partially Paid">
                </asp:ListItem>

                <asp:ListItem Text="Paid"
                    Value="Paid">
                </asp:ListItem>

                <asp:ListItem Text="Overdue"
                    Value="Overdue">
                </asp:ListItem>

            </asp:DropDownList>

        </div>

        <div class="col-md-5">

            <label class="form-label">
                Search
            </label>

            <asp:TextBox ID="txtSearch"
                runat="server"
                CssClass="form-control"
                placeholder="Search course, fee type or description">
            </asp:TextBox>

        </div>

        <div class="col-md-3">

            <asp:Button ID="btnFilter"
                runat="server"
                Text="Apply Filter"
                CssClass="btn btn-filter w-100"
                CausesValidation="false"
                OnClick="btnFilter_Click" />

        </div>

        <div class="col-12">

            <asp:Button ID="btnReset"
                runat="server"
                Text="Reset Filter"
                CssClass="btn btn-reset"
                CausesValidation="false"
                OnClick="btnReset_Click" />

        </div>

    </div>

</div>

<asp:Panel ID="pnlFees"
    runat="server">

    <asp:Repeater ID="rptFees"
        runat="server">

        <ItemTemplate>

            <div class='<%#
                Eval("DisplayStatus").ToString() == "Paid"
                    ? "fee-card paid"
                : Eval("DisplayStatus").ToString() == "Partially Paid"
                    ? "fee-card partial"
                : Eval("DisplayStatus").ToString() == "Overdue"
                    ? "fee-card overdue"
                    : "fee-card"
            %>'>

                <div class="fee-card-header">

                    <div>

                        <div class="fee-title">
                            <%# Eval("FeeType") %>
                        </div>

                        <div class="fee-record-id">
                            Fee Record #<%# Eval("FeeID") %>
                        </div>

                    </div>

                    <span class='<%#
                        Eval("CourseID") == DBNull.Value
                            ? "fee-source-badge additional-fee-badge"
                            : "fee-source-badge course-fee-badge"
                    %>'>

                        <i class='<%#
                            Eval("CourseID") == DBNull.Value
                                ? "fa-solid fa-receipt"
                                : "fa-solid fa-book-open"
                        %>'></i>

                        <%#
                            Eval("CourseID") == DBNull.Value
                                ? "Additional Fee"
                                : "Course Fee"
                        %>

                    </span>

                </div>

                <asp:PlaceHolder ID="phCourse"
                    runat="server"
                    Visible='<%# Eval("CourseID") != DBNull.Value %>'>

                    <div class="course-box">

                        <div class="course-box-label">
                            Enrolled Course / Subject
                        </div>

                        <div class="course-code">
                            <%# Eval("CourseCode") %>
                        </div>

                        <div class="course-name">
                            <%# Eval("CourseName") %>
                        </div>

                    </div>

                </asp:PlaceHolder>

                <div class="fee-description">

                    <%#
                        Eval("Description") == DBNull.Value
                        || string.IsNullOrWhiteSpace(
                            Eval("Description").ToString()
                        )
                            ? (
                                Eval("CourseID") == DBNull.Value
                                    ? "No description provided for this additional fee."
                                    : "Course fee generated from your approved enrolment."
                              )
                            : Eval("Description")
                    %>

                </div>

                <div class="fee-amounts">

                    <div class="amount-box">

                        <div class="amount-label">
                            Total Amount
                        </div>

                        <div class="amount-value">
                            RM <%# Eval("TotalAmount", "{0:N2}") %>
                        </div>

                    </div>

                    <div class="amount-box">

                        <div class="amount-label">
                            Paid Amount
                        </div>

                        <div class="amount-value paid-value">
                            RM <%# Eval("PaidAmount", "{0:N2}") %>
                        </div>

                    </div>

                    <div class="amount-box">

                        <div class="amount-label">
                            Outstanding
                        </div>

                        <div class="amount-value outstanding-value">
                            RM <%# Eval("OutstandingAmount", "{0:N2}") %>
                        </div>

                    </div>

                </div>

                <div class="fee-meta">

                    <span class="meta-badge badge-date">

                        <i class="fa-solid fa-calendar-day"></i>

                        Due <%# Eval("DueDate", "{0:dd MMM yyyy}") %>

                    </span>

                    <span class='<%#
                        Eval("DisplayStatus").ToString() == "Paid"
                            ? "meta-badge badge-paid"
                        : Eval("DisplayStatus").ToString() == "Partially Paid"
                            ? "meta-badge badge-partial"
                        : Eval("DisplayStatus").ToString() == "Overdue"
                            ? "meta-badge badge-overdue"
                            : "meta-badge badge-unpaid"
                    %>'>

                        <i class='<%#
                            Eval("DisplayStatus").ToString() == "Paid"
                                ? "fa-solid fa-circle-check"
                            : Eval("DisplayStatus").ToString() == "Overdue"
                                ? "fa-solid fa-triangle-exclamation"
                                : Eval("DisplayStatus").ToString() == "Partially Paid"
                                    ? "fa-solid fa-hourglass-half"
                                    : "fa-solid fa-clock"
                        %>'></i>

                        <%# Eval("DisplayStatus") %>

                    </span>

                    <span class="meta-badge badge-created">

                        <i class="fa-solid fa-calendar-plus"></i>

                        Created
                        <%# Eval("CreatedAt", "{0:dd MMM yyyy}") %>

                    </span>

                </div>

                <div class="payment-note">

                    <i class="fa-solid fa-circle-info me-1"></i>

                    This is a simulated payment system.
                    Click Pay Now to make a full or partial payment.

                </div>

                <div class="payment-action">

                    <asp:HyperLink ID="lnkPayNow"
                        runat="server"
                        CssClass="btn-pay-now"
                        Visible='<%#
                            Eval("DisplayStatus").ToString() != "Paid"
                            && Convert.ToDecimal(
                                Eval("OutstandingAmount")
                            ) > 0
                        %>'
                        NavigateUrl='<%#
                            ResolveUrl(
                                "~/StudentPayment.aspx?FeeID="
                                + Eval("FeeID")
                            )
                        %>'>

                        <i class="fa-solid fa-credit-card"></i>

                        Pay Now

                    </asp:HyperLink>

                    <asp:Label ID="lblFullyPaid"
                        runat="server"
                        CssClass="fully-paid-label"
                        Visible='<%#
                            Eval("DisplayStatus").ToString() == "Paid"
                            || Convert.ToDecimal(
                                Eval("OutstandingAmount")
                            ) <= 0
                        %>'>

                        <i class="fa-solid fa-circle-check"></i>

                        Fully Paid

                    </asp:Label>

                </div>

            </div>

        </ItemTemplate>

    </asp:Repeater>

</asp:Panel>

<asp:Panel ID="pnlEmpty"
    runat="server"
    Visible="false">

    <div class="empty-state">

        <i class="fa-solid fa-receipt"></i>

        <h4>No Fee Records Found</h4>

        <p>
            You currently have no fee records matching the selected filter.
        </p>

    </div>

</asp:Panel>


</asp:Content>
