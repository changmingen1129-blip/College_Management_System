<%@ Page Language="C#" AutoEventWireup="true"
MasterPageFile="~/AdminMaster.Master"
CodeBehind="AdminAcademicCalendar.aspx.cs"
Inherits="College_Management_System.AdminAcademicCalendar" %>

<asp:Content ID="HeadContent"
ContentPlaceHolderID="HeadContent"
runat="server">


<style>
    .calendar-header {
        background: linear-gradient(135deg, #0f172a, #2563eb);
        color: white;
        border-radius: 24px;
        padding: 30px;
        margin-bottom: 28px;
        box-shadow: 0 12px 30px rgba(15, 23, 42, 0.16);
    }

    .calendar-header h2 {
        margin-bottom: 7px;
        font-weight: 800;
    }

    .calendar-header p {
        margin-bottom: 0;
        color: #dbeafe;
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

    .content-card {
        background: white;
        border-radius: 22px;
        padding: 26px;
        margin-bottom: 28px;
        box-shadow: 0 8px 25px rgba(15, 23, 42, 0.08);
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
        border-color: #2563eb;
        box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.14);
    }

    .btn-save {
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

    .type-badge,
    .audience-badge,
    .status-badge {
        display: inline-block;
        padding: 7px 12px;
        border-radius: 999px;
        font-size: 13px;
        font-weight: 800;
        text-align: center;
    }

    .type-semester {
        background: #dbeafe;
        color: #1d4ed8;
    }

    .type-registration {
        background: #ede9fe;
        color: #6d28d9;
    }

    .type-examination {
        background: #fee2e2;
        color: #b91c1c;
    }

    .type-holiday {
        background: #dcfce7;
        color: #15803d;
    }

    .type-activity {
        background: #fef3c7;
        color: #b45309;
    }

    .type-deadline {
        background: #ffedd5;
        color: #c2410c;
    }

    .audience-badge {
        background: #f1f5f9;
        color: #475569;
    }

    .status-active {
        background: #dcfce7;
        color: #15803d;
    }

    .status-inactive {
        background: #fee2e2;
        color: #b91c1c;
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

    .btn-toggle {
        background: #fef3c7;
        color: #b45309;
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

    .event-description {
        max-width: 320px;
        white-space: normal;
        line-height: 1.5;
    }
</style>


</asp:Content>

<asp:Content ID="MainContent"
ContentPlaceHolderID="MainContent"
runat="server">


<div class="calendar-header">

    <div class="row align-items-center">

        <div class="col-md-9">

            <h2>Academic Calendar Management</h2>

            <p>
                Create and manage semester dates, examinations, holidays, activities and academic deadlines.
            </p>

        </div>

        <div class="col-md-3 d-flex justify-content-md-end">

            <div class="header-icon">
                <i class="fa-solid fa-calendar-days"></i>
            </div>

        </div>

    </div>

</div>

<div class="content-card">

    <h4 class="card-title-custom">
        Create Academic Event
    </h4>

    <p class="card-subtitle-custom">
        Enter the event details and choose the intended audience.
    </p>

    <asp:HiddenField ID="hfEventID"
        runat="server"
        Value="0" />

    <div class="row g-3">

        <div class="col-md-8">

            <label class="form-label">
                Event Title
            </label>

            <asp:TextBox ID="txtEventTitle"
                runat="server"
                CssClass="form-control"
                MaxLength="150"
                placeholder="Enter event title">
            </asp:TextBox>

            <asp:RequiredFieldValidator ID="rfvEventTitle"
                runat="server"
                ControlToValidate="txtEventTitle"
                ValidationGroup="SaveEvent"
                ErrorMessage="Event title is required."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RequiredFieldValidator>

        </div>

        <div class="col-md-4">

            <label class="form-label">
                Event Type
            </label>

            <asp:DropDownList ID="ddlEventType"
                runat="server"
                CssClass="form-select">

                <asp:ListItem Text="Semester"
                    Value="Semester">
                </asp:ListItem>

                <asp:ListItem Text="Registration"
                    Value="Registration">
                </asp:ListItem>

                <asp:ListItem Text="Examination"
                    Value="Examination">
                </asp:ListItem>

                <asp:ListItem Text="Holiday"
                    Value="Holiday">
                </asp:ListItem>

                <asp:ListItem Text="Activity"
                    Value="Activity">
                </asp:ListItem>

                <asp:ListItem Text="Deadline"
                    Value="Deadline">
                </asp:ListItem>

            </asp:DropDownList>

        </div>

        <div class="col-12">

            <label class="form-label">
                Event Description
            </label>

            <asp:TextBox ID="txtEventDescription"
                runat="server"
                CssClass="form-control"
                TextMode="MultiLine"
                Rows="5"
                MaxLength="1000"
                placeholder="Enter event description">
            </asp:TextBox>

        </div>

        <div class="col-md-3">

            <label class="form-label">
                Start Date
            </label>

            <asp:TextBox ID="txtStartDate"
                runat="server"
                CssClass="form-control"
                TextMode="Date">
            </asp:TextBox>

            <asp:RequiredFieldValidator ID="rfvStartDate"
                runat="server"
                ControlToValidate="txtStartDate"
                ValidationGroup="SaveEvent"
                ErrorMessage="Start date is required."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RequiredFieldValidator>

        </div>

        <div class="col-md-3">

            <label class="form-label">
                End Date
            </label>

            <asp:TextBox ID="txtEndDate"
                runat="server"
                CssClass="form-control"
                TextMode="Date">
            </asp:TextBox>

            <asp:RequiredFieldValidator ID="rfvEndDate"
                runat="server"
                ControlToValidate="txtEndDate"
                ValidationGroup="SaveEvent"
                ErrorMessage="End date is required."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RequiredFieldValidator>

        </div>

        <div class="col-md-3">

            <label class="form-label">
                Audience
            </label>

            <asp:DropDownList ID="ddlAudience"
                runat="server"
                CssClass="form-select">

                <asp:ListItem Text="All Users"
                    Value="All">
                </asp:ListItem>

                <asp:ListItem Text="Students Only"
                    Value="Students">
                </asp:ListItem>

                <asp:ListItem Text="Lecturers Only"
                    Value="Lecturers">
                </asp:ListItem>

            </asp:DropDownList>

        </div>

        <div class="col-md-3">

            <label class="form-label">
                Status
            </label>

            <asp:DropDownList ID="ddlStatus"
                runat="server"
                CssClass="form-select">

                <asp:ListItem Text="Active"
                    Value="1">
                </asp:ListItem>

                <asp:ListItem Text="Inactive"
                    Value="0">
                </asp:ListItem>

            </asp:DropDownList>

        </div>

        <div class="col-12">

            <label class="form-label">
                Location
            </label>

            <asp:TextBox ID="txtLocation"
                runat="server"
                CssClass="form-control"
                MaxLength="150"
                placeholder="Enter event location or leave blank">
            </asp:TextBox>

        </div>

        <div class="col-12">

            <asp:Button ID="btnSave"
                runat="server"
                Text="Save Event"
                CssClass="btn btn-save"
                ValidationGroup="SaveEvent"
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
        Academic Events
    </h4>

    <p class="card-subtitle-custom">
        Review, edit, activate, deactivate or delete academic calendar events.
    </p>

    <div class="table-responsive">

        <asp:GridView ID="gvEvents"
            runat="server"
            AutoGenerateColumns="False"
            GridLines="None"
            CssClass="table table-hover"
            EmptyDataText="No academic calendar events found."
            DataKeyNames="EventID"
            OnRowCommand="gvEvents_RowCommand">

            <Columns>

                <asp:BoundField DataField="EventID"
                    HeaderText="ID" />

                <asp:TemplateField HeaderText="Event">

                    <ItemTemplate>

                        <div class="fw-bold text-dark">
                            <%# Eval("EventTitle") %>
                        </div>

                        <div class="event-description mt-2">
                            <%# Eval("EventDescription") %>
                        </div>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:TemplateField HeaderText="Type">

                    <ItemTemplate>

                        <span class='<%#
                            Eval("EventType").ToString() == "Registration"
                                ? "type-badge type-registration"
                            : Eval("EventType").ToString() == "Examination"
                                ? "type-badge type-examination"
                            : Eval("EventType").ToString() == "Holiday"
                                ? "type-badge type-holiday"
                            : Eval("EventType").ToString() == "Activity"
                                ? "type-badge type-activity"
                            : Eval("EventType").ToString() == "Deadline"
                                ? "type-badge type-deadline"
                                : "type-badge type-semester"
                        %>'>

                            <%# Eval("EventType") %>

                        </span>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:BoundField DataField="StartDate"
                    HeaderText="Start Date"
                    DataFormatString="{0:dd MMM yyyy}" />

                <asp:BoundField DataField="EndDate"
                    HeaderText="End Date"
                    DataFormatString="{0:dd MMM yyyy}" />

                <asp:TemplateField HeaderText="Audience">

                    <ItemTemplate>

                        <span class="audience-badge">

                            <%#
                                Eval("Audience").ToString() == "Students"
                                    ? "Students"
                                : Eval("Audience").ToString() == "Lecturers"
                                    ? "Lecturers"
                                    : "All Users"
                            %>

                        </span>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:BoundField DataField="Location"
                    HeaderText="Location"
                    NullDisplayText="Not Specified" />

                <asp:TemplateField HeaderText="Status">

                    <ItemTemplate>

                        <span class='<%#
                            Convert.ToBoolean(Eval("IsActive"))
                                ? "status-badge status-active"
                                : "status-badge status-inactive"
                        %>'>

                            <%#
                                Convert.ToBoolean(Eval("IsActive"))
                                    ? "Active"
                                    : "Inactive"
                            %>

                        </span>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:TemplateField HeaderText="Actions">

                    <ItemTemplate>

                        <asp:Button ID="btnEdit"
                            runat="server"
                            Text="Edit"
                            CssClass="action-button btn-edit"
                            CommandName="EditEvent"
                            CommandArgument='<%# Eval("EventID") %>'
                            CausesValidation="false" />

                        <asp:Button ID="btnToggle"
                            runat="server"
                            Text='<%#
                                Convert.ToBoolean(Eval("IsActive"))
                                    ? "Deactivate"
                                    : "Activate"
                            %>'
                            CssClass="action-button btn-toggle"
                            CommandName="ToggleStatus"
                            CommandArgument='<%# Eval("EventID") %>'
                            CausesValidation="false" />

                        <asp:Button ID="btnDelete"
                            runat="server"
                            Text="Delete"
                            CssClass="action-button btn-delete"
                            CommandName="DeleteEvent"
                            CommandArgument='<%# Eval("EventID") %>'
                            CausesValidation="false"
                            OnClientClick="return confirm('Are you sure you want to delete this academic event?');" />

                    </ItemTemplate>

                </asp:TemplateField>

            </Columns>

        </asp:GridView>

    </div>

</div>


</asp:Content>
