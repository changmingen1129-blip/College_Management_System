<%@ Page Language="C#" AutoEventWireup="true"
MasterPageFile="~/AdminMaster.Master"
CodeBehind="AdminFees.aspx.cs"
Inherits="College_Management_System.AdminFees" %>

<asp:Content ID="HeadContent"
ContentPlaceHolderID="HeadContent"
runat="server">


<style>
    .fees-header {
        background: linear-gradient(135deg, #0f172a, #059669);
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

    .content-card {
        background: white;
        border-radius: 22px;
        padding: 26px;
        margin-top: 26px;
        margin-bottom: 28px;
        box-shadow: 0 8px 25px rgba(15, 23, 42, 0.08);
    }

    .course-fee-card {
        border-top: 5px solid #2563eb;
    }

    .manual-fee-card {
        border-top: 5px solid #059669;
    }

    .card-title-custom {
        margin-bottom: 5px;
        color: #0f172a;
        font-weight: 800;
    }

    .card-subtitle-custom {
        margin-bottom: 22px;
        color: #64748b;
    }

    .section-badge {
        display: inline-flex;
        align-items: center;
        gap: 7px;
        padding: 7px 12px;
        border-radius: 999px;
        margin-bottom: 14px;
        background: #dbeafe;
        color: #1d4ed8;
        font-size: 13px;
        font-weight: 800;
    }

    .manual-badge {
        background: #dcfce7;
        color: #15803d;
    }

    .form-label {
        color: #334155;
        font-weight: 700;
        margin-bottom: 8px;
    }

    .form-control,
    .form-select {
        padding: 11px 13px;
        border-radius: 13px;
        border: 1px solid #cbd5e1;
    }

    .form-control:focus,
    .form-select:focus {
        border-color: #059669;
        box-shadow: 0 0 0 0.2rem rgba(5, 150, 105, 0.14);
    }

    .btn-save {
        border: none;
        border-radius: 13px;
        padding: 11px 20px;
        background: linear-gradient(135deg, #059669, #10b981);
        color: white;
        font-weight: 700;
    }

    .btn-course-fee {
        border: none;
        border-radius: 13px;
        padding: 11px 20px;
        background: linear-gradient(135deg, #2563eb, #3b82f6);
        color: white;
        font-weight: 700;
    }

    .btn-clear {
        border: none;
        border-radius: 13px;
        padding: 11px 20px;
        background: #e2e8f0;
        color: #334155;
        font-weight: 700;
    }

    .btn-filter {
        border: none;
        border-radius: 13px;
        padding: 11px 20px;
        background: #2563eb;
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

    .table-responsive {
        overflow-x: auto;
        border-radius: 16px;
    }

    .table {
        margin-bottom: 0;
    }

    .table thead th {
        padding: 14px;
        border-bottom: none;
        background: #f1f5f9;
        color: #334155;
        font-weight: 750;
        white-space: nowrap;
    }

    .table tbody td {
        padding: 13px;
        color: #475569;
        vertical-align: middle;
    }

    .status-badge {
        display: inline-block;
        min-width: 105px;
        padding: 7px 12px;
        border-radius: 999px;
        font-size: 13px;
        font-weight: 800;
        text-align: center;
    }

    .status-paid {
        background: #dcfce7;
        color: #15803d;
    }

    .status-partial {
        background: #fef3c7;
        color: #b45309;
    }

    .status-unpaid {
        background: #dbeafe;
        color: #1d4ed8;
    }

    .status-overdue {
        background: #fee2e2;
        color: #b91c1c;
    }

    .price-badge {
        display: inline-block;
        padding: 7px 12px;
        border-radius: 999px;
        background: #dcfce7;
        color: #15803d;
        font-weight: 800;
        white-space: nowrap;
    }

    .not-set-badge {
        display: inline-block;
        padding: 7px 12px;
        border-radius: 999px;
        background: #fee2e2;
        color: #b91c1c;
        font-weight: 800;
        white-space: nowrap;
    }

    .action-button {
        border: none;
        border-radius: 10px;
        padding: 7px 12px;
        margin-right: 6px;
        margin-bottom: 5px;
        font-size: 13px;
        font-weight: 700;
    }

    .btn-edit {
        background: #dbeafe;
        color: #1d4ed8;
    }

    .btn-delete {
        background: #fee2e2;
        color: #b91c1c;
    }

    .message-label {
        display: block;
        margin-top: 15px;
        padding: 11px 14px;
        border-radius: 12px;
        font-weight: 650;
    }

    .fee-description {
        max-width: 260px;
        white-space: normal;
        line-height: 1.5;
    }

    .course-information {
        line-height: 1.5;
    }

    .course-information .course-code {
        color: #1d4ed8;
        font-weight: 800;
    }

    .course-information .course-name {
        color: #334155;
        font-weight: 650;
    }

    .course-information .programme-name {
        color: #64748b;
        font-size: 13px;
    }

    .information-box {
        padding: 14px 16px;
        border-radius: 14px;
        background: #eff6ff;
        color: #1e40af;
        margin-bottom: 20px;
        line-height: 1.6;
        font-weight: 600;
    }
</style>


</asp:Content>

<asp:Content ID="MainContent"
ContentPlaceHolderID="MainContent"
runat="server">


<div class="fees-header">

    <div class="row align-items-center">

        <div class="col-md-9">

            <h2>Student Fee Management</h2>

            <p>
                Set course prices and manage student payments, outstanding balances and due dates.
            </p>

        </div>

        <div class="col-md-3 d-flex justify-content-md-end">

            <div class="header-icon">
                <i class="fa-solid fa-money-check-dollar"></i>
            </div>

        </div>

    </div>

</div>

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

                    <p>Total Student Fees</p>

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

<div class="content-card course-fee-card">

    <div class="section-badge">

        <i class="fa-solid fa-book-open"></i>

        Course Pricing

    </div>

    <h4 class="card-title-custom">
        Course Fee Setup
    </h4>

    <p class="card-subtitle-custom">
        Select a programme and course, then set the price students will be charged after enrolment approval.
    </p>

    <div class="information-box">

        <i class="fa-solid fa-circle-info me-2"></i>

        The course price is controlled by the administrator. Students can view the price but cannot edit it.
        When an enrolment is approved, this price will be used to generate the student fee automatically.

    </div>

    <div class="row g-3 align-items-end">

        <div class="col-md-4">

            <label class="form-label">
                Programme
            </label>

            <asp:DropDownList ID="ddlFeeProgramme"
                runat="server"
                CssClass="form-select"
                AutoPostBack="true"
                OnSelectedIndexChanged="ddlFeeProgramme_SelectedIndexChanged">
            </asp:DropDownList>

        </div>

        <div class="col-md-5">

            <label class="form-label">
                Course / Subject
            </label>

            <asp:DropDownList ID="ddlFeeCourse"
                runat="server"
                CssClass="form-select"
                AutoPostBack="true"
                OnSelectedIndexChanged="ddlFeeCourse_SelectedIndexChanged">
            </asp:DropDownList>

            <asp:RequiredFieldValidator ID="rfvFeeCourse"
                runat="server"
                ControlToValidate="ddlFeeCourse"
                InitialValue="0"
                ValidationGroup="CourseFeeValidation"
                ErrorMessage="Please select a course."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RequiredFieldValidator>

        </div>

        <div class="col-md-3">

            <label class="form-label">
                Course Fee
            </label>

            <asp:TextBox ID="txtCourseFee"
                runat="server"
                CssClass="form-control"
                TextMode="Number"
                step="0.01"
                min="0"
                placeholder="0.00">
            </asp:TextBox>

            <asp:RequiredFieldValidator ID="rfvCourseFee"
                runat="server"
                ControlToValidate="txtCourseFee"
                ValidationGroup="CourseFeeValidation"
                ErrorMessage="Course fee is required."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RequiredFieldValidator>

        </div>

        <div class="col-12">

            <asp:Button ID="btnSaveCourseFee"
                runat="server"
                Text="Save Course Fee"
                CssClass="btn btn-course-fee"
                ValidationGroup="CourseFeeValidation"
                OnClick="btnSaveCourseFee_Click" />

            <asp:Button ID="btnClearCourseFee"
                runat="server"
                Text="Clear Selection"
                CssClass="btn btn-clear ms-2"
                CausesValidation="false"
                OnClick="btnClearCourseFee_Click" />

        </div>

    </div>

    <asp:Label ID="lblCourseFeeMessage"
        runat="server"
        Visible="false">
    </asp:Label>

    <hr class="my-4" />

    <h5 class="fw-bold text-dark mb-3">
        Current Course Prices
    </h5>

    <div class="table-responsive">

        <asp:GridView ID="gvCourseFees"
            runat="server"
            AutoGenerateColumns="False"
            GridLines="None"
            CssClass="table table-hover"
            DataKeyNames="CourseID"
            EmptyDataText="No courses were found."
            OnRowCommand="gvCourseFees_RowCommand">

            <Columns>

                <asp:BoundField DataField="CourseID"
                    HeaderText="ID" />

                <asp:TemplateField HeaderText="Programme">

                    <ItemTemplate>

                        <div class="fw-semibold text-dark">
                            <%# Eval("ProgrammeName") %>
                        </div>

                        <div class="small text-muted">
                            <%# Eval("ProgrammeCode") %>
                        </div>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:TemplateField HeaderText="Course / Subject">

                    <ItemTemplate>

                        <div class="course-information">

                            <div class="course-code">
                                <%# Eval("CourseCode") %>
                            </div>

                            <div class="course-name">
                                <%# Eval("CourseName") %>
                            </div>

                        </div>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:BoundField DataField="CreditHours"
                    HeaderText="Credit Hours" />

                <asp:TemplateField HeaderText="Course Fee">

                    <ItemTemplate>

                        <span class='<%#
                            Convert.ToDecimal(Eval("CourseFee")) > 0
                                ? "price-badge"
                                : "not-set-badge"
                        %>'>

                            <%#
                                Convert.ToDecimal(Eval("CourseFee")) > 0
                                    ? "RM " + Convert.ToDecimal(Eval("CourseFee")).ToString("N2")
                                    : "Not Set"
                            %>

                        </span>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:TemplateField HeaderText="Action">

                    <ItemTemplate>

                        <asp:Button ID="btnSetCourseFee"
                            runat="server"
                            Text="Set Price"
                            CssClass="action-button btn-edit"
                            CommandName="SelectCourseFee"
                            CommandArgument='<%# Eval("CourseID") %>'
                            CausesValidation="false" />

                    </ItemTemplate>

                </asp:TemplateField>

            </Columns>

        </asp:GridView>

    </div>

</div>

<div class="content-card manual-fee-card">

    <div class="section-badge manual-badge">

        <i class="fa-solid fa-plus"></i>

        Additional Student Fee

    </div>

    <h4 class="card-title-custom">
        Create Manual Student Fee
    </h4>

    <p class="card-subtitle-custom">
        Use this form for registration, examination, library, activity or other additional fees.
    </p>

    <asp:HiddenField ID="hfFeeID"
        runat="server"
        Value="0" />

    <div class="row g-3">

        <div class="col-md-6">

            <label class="form-label">
                Student
            </label>

            <asp:DropDownList ID="ddlStudent"
                runat="server"
                CssClass="form-select">
            </asp:DropDownList>

            <asp:RequiredFieldValidator ID="rfvStudent"
                runat="server"
                ControlToValidate="ddlStudent"
                InitialValue="0"
                ValidationGroup="SaveFee"
                ErrorMessage="Please select a student."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RequiredFieldValidator>

        </div>

        <div class="col-md-6">

            <label class="form-label">
                Fee Type
            </label>

            <asp:DropDownList ID="ddlFeeType"
                runat="server"
                CssClass="form-select">

                <asp:ListItem Text="Registration Fee"
                    Value="Registration Fee">
                </asp:ListItem>

                <asp:ListItem Text="Examination Fee"
                    Value="Examination Fee">
                </asp:ListItem>

                <asp:ListItem Text="Library Fee"
                    Value="Library Fee">
                </asp:ListItem>

                <asp:ListItem Text="Activity Fee"
                    Value="Activity Fee">
                </asp:ListItem>

                <asp:ListItem Text="Other Fee"
                    Value="Other Fee">
                </asp:ListItem>

            </asp:DropDownList>

        </div>

        <div class="col-12">

            <label class="form-label">
                Description
            </label>

            <asp:TextBox ID="txtDescription"
                runat="server"
                CssClass="form-control"
                TextMode="MultiLine"
                Rows="4"
                MaxLength="500"
                placeholder="Enter additional fee description">
            </asp:TextBox>

        </div>

        <div class="col-md-4">

            <label class="form-label">
                Total Amount
            </label>

            <asp:TextBox ID="txtTotalAmount"
                runat="server"
                CssClass="form-control"
                TextMode="Number"
                step="0.01"
                min="0"
                placeholder="0.00">
            </asp:TextBox>

            <asp:RequiredFieldValidator ID="rfvTotalAmount"
                runat="server"
                ControlToValidate="txtTotalAmount"
                ValidationGroup="SaveFee"
                ErrorMessage="Total amount is required."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RequiredFieldValidator>

        </div>

        <div class="col-md-4">

            <label class="form-label">
                Paid Amount
            </label>

            <asp:TextBox ID="txtPaidAmount"
                runat="server"
                CssClass="form-control"
                TextMode="Number"
                step="0.01"
                min="0"
                Text="0.00"
                placeholder="0.00">
            </asp:TextBox>

            <asp:RequiredFieldValidator ID="rfvPaidAmount"
                runat="server"
                ControlToValidate="txtPaidAmount"
                ValidationGroup="SaveFee"
                ErrorMessage="Paid amount is required."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RequiredFieldValidator>

        </div>

        <div class="col-md-4">

            <label class="form-label">
                Due Date
            </label>

            <asp:TextBox ID="txtDueDate"
                runat="server"
                CssClass="form-control"
                TextMode="Date">
            </asp:TextBox>

            <asp:RequiredFieldValidator ID="rfvDueDate"
                runat="server"
                ControlToValidate="txtDueDate"
                ValidationGroup="SaveFee"
                ErrorMessage="Due date is required."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RequiredFieldValidator>

        </div>

        <div class="col-12">

            <asp:Button ID="btnSave"
                runat="server"
                Text="Save Additional Fee"
                CssClass="btn btn-save"
                ValidationGroup="SaveFee"
                OnClick="btnSave_Click" />

            <asp:Button ID="btnClear"
                runat="server"
                Text="Clear Form"
                CssClass="btn btn-clear ms-2"
                CausesValidation="false"
                OnClick="btnClear_Click" />

        </div>

    </div>

    <asp:Label ID="lblMessage"
        runat="server"
        Visible="false">
    </asp:Label>

</div>

<div class="content-card">

    <h4 class="card-title-custom">
        Student Fee Records
    </h4>

    <p class="card-subtitle-custom">
        Review automatically generated course fees and manually created additional fees.
    </p>

    <div class="row g-3 align-items-end mb-4">

        <div class="col-md-4">

            <label class="form-label">
                Student
            </label>

            <asp:DropDownList ID="ddlFilterStudent"
                runat="server"
                CssClass="form-select">
            </asp:DropDownList>

        </div>

        <div class="col-md-3">

            <label class="form-label">
                Payment Status
            </label>

            <asp:DropDownList ID="ddlFilterStatus"
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

        <div class="col-md-3">

            <label class="form-label">
                Search
            </label>

            <asp:TextBox ID="txtSearch"
                runat="server"
                CssClass="form-control"
                placeholder="Student, fee or course">
            </asp:TextBox>

        </div>

        <div class="col-md-2">

            <asp:Button ID="btnFilter"
                runat="server"
                Text="Apply"
                CssClass="btn btn-filter w-100"
                CausesValidation="false"
                OnClick="btnFilter_Click" />

        </div>

        <div class="col-12">

            <asp:Button ID="btnResetFilter"
                runat="server"
                Text="Reset Filter"
                CssClass="btn btn-reset"
                CausesValidation="false"
                OnClick="btnResetFilter_Click" />

        </div>

    </div>

    <div class="table-responsive">

        <asp:GridView ID="gvFees"
            runat="server"
            AutoGenerateColumns="False"
            GridLines="None"
            CssClass="table table-hover"
            DataKeyNames="FeeID"
            EmptyDataText="No student fee records found."
            OnRowCommand="gvFees_RowCommand">

            <Columns>

                <asp:BoundField DataField="FeeID"
                    HeaderText="ID" />

                <asp:TemplateField HeaderText="Student">

                    <ItemTemplate>

                        <div class="fw-bold text-dark">
                            <%# Eval("StudentName") %>
                        </div>

                        <div class="small text-muted">
                            ID: <%# Eval("StudentID") %>
                        </div>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:TemplateField HeaderText="Course">

                    <ItemTemplate>

                        <div class="course-information">

                            <div class="course-code">
                                <%#
                                    Eval("CourseID") == DBNull.Value
                                        ? "Additional Fee"
                                        : Eval("CourseCode")
                                %>
                            </div>

                            <div class="course-name">
                                <%#
                                    Eval("CourseID") == DBNull.Value
                                        ? "Not linked to a course"
                                        : Eval("CourseName")
                                %>
                            </div>

                        </div>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:TemplateField HeaderText="Fee">

                    <ItemTemplate>

                        <div class="fw-semibold">
                            <%# Eval("FeeType") %>
                        </div>

                        <div class="fee-description mt-1">
                            <%# Eval("Description") %>
                        </div>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:BoundField DataField="TotalAmount"
                    HeaderText="Total"
                    DataFormatString="RM {0:N2}" />

                <asp:BoundField DataField="PaidAmount"
                    HeaderText="Paid"
                    DataFormatString="RM {0:N2}" />

                <asp:BoundField DataField="OutstandingAmount"
                    HeaderText="Outstanding"
                    DataFormatString="RM {0:N2}" />

                <asp:BoundField DataField="DueDate"
                    HeaderText="Due Date"
                    DataFormatString="{0:dd MMM yyyy}" />

                <asp:TemplateField HeaderText="Status">

                    <ItemTemplate>

                        <span class='<%#
                            Eval("DisplayStatus").ToString() == "Paid"
                                ? "status-badge status-paid"
                            : Eval("DisplayStatus").ToString() == "Partially Paid"
                                ? "status-badge status-partial"
                            : Eval("DisplayStatus").ToString() == "Overdue"
                                ? "status-badge status-overdue"
                                : "status-badge status-unpaid"
                        %>'>

                            <%# Eval("DisplayStatus") %>

                        </span>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:TemplateField HeaderText="Actions">

                    <ItemTemplate>

                        <asp:Button ID="btnEdit"
                            runat="server"
                            Text="Edit Payment"
                            CssClass="action-button btn-edit"
                            CommandName="EditFee"
                            CommandArgument='<%# Eval("FeeID") %>'
                            CausesValidation="false" />

                        <asp:Button ID="btnDelete"
                            runat="server"
                            Text="Delete"
                            CssClass="action-button btn-delete"
                            CommandName="DeleteFee"
                            CommandArgument='<%# Eval("FeeID") %>'
                            CausesValidation="false"
                            OnClientClick="return confirm('Are you sure you want to delete this fee record?');" />

                    </ItemTemplate>

                </asp:TemplateField>

            </Columns>

        </asp:GridView>

    </div>

</div>


</asp:Content>
