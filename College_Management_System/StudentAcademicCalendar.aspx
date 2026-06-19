<%@ Page Language="C#" AutoEventWireup="true"
MasterPageFile="~/StudentMaster.Master"
CodeBehind="StudentAcademicCalendar.aspx.cs"
Inherits="College_Management_System.StudentAcademicCalendar" %>

<asp:Content ID="HeadContent"
ContentPlaceHolderID="HeadContent"
runat="server">


<style>
    .calendar-header {
        background: linear-gradient(135deg, #1e3a8a, #2563eb);
        color: white;
        border-radius: 24px;
        padding: 30px;
        margin-bottom: 28px;
        box-shadow: 0 12px 30px rgba(37, 99, 235, 0.18);
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

    .summary-card {
        background: white;
        border-radius: 20px;
        padding: 22px;
        margin-bottom: 24px;
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

    .icon-upcoming {
        background: #dcfce7;
        color: #15803d;
    }

    .icon-exam {
        background: #fee2e2;
        color: #b91c1c;
    }

    .filter-card {
        background: white;
        border-radius: 20px;
        padding: 22px;
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

    .btn-filter {
        border: none;
        border-radius: 13px;
        padding: 11px 20px;
        background: linear-gradient(135deg, #2563eb, #3b82f6);
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

    .event-card {
        background: white;
        border-radius: 22px;
        padding: 24px;
        margin-bottom: 20px;
        box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
        border-left: 6px solid #2563eb;
    }

    .event-title {
        color: #0f172a;
        font-size: 21px;
        font-weight: 800;
        margin-bottom: 8px;
    }

    .event-description {
        color: #475569;
        line-height: 1.7;
        white-space: pre-line;
        margin-bottom: 18px;
    }

    .event-meta {
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

    .badge-type {
        background: #dbeafe;
        color: #1d4ed8;
    }

    .badge-date {
        background: #dcfce7;
        color: #15803d;
    }

    .badge-location {
        background: #f1f5f9;
        color: #475569;
    }

    .badge-audience {
        background: #ede9fe;
        color: #6d28d9;
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
</style>


</asp:Content>

<asp:Content ID="MainContent"
ContentPlaceHolderID="MainContent"
runat="server">


<div class="calendar-header">

    <div class="row align-items-center">

        <div class="col-md-9">

            <h2>Academic Calendar</h2>

            <p>
                View semester dates, examinations, holidays, activities and important academic deadlines.
            </p>

        </div>

        <div class="col-md-3 d-flex justify-content-md-end">

            <div class="header-icon">
                <i class="fa-solid fa-calendar-check"></i>
            </div>

        </div>

    </div>

</div>

<asp:Label ID="lblMessage"
    runat="server"
    Visible="false">
</asp:Label>

<div class="row g-4 mb-4">

    <div class="col-md-4">

        <div class="summary-card">

            <div class="d-flex align-items-center justify-content-between">

                <div>

                    <h3>
                        <asp:Label ID="lblTotalEvents"
                            runat="server"
                            Text="0">
                        </asp:Label>
                    </h3>

                    <p>Total Events</p>

                </div>

                <div class="summary-icon icon-total">
                    <i class="fa-solid fa-calendar-days"></i>
                </div>

            </div>

        </div>

    </div>

    <div class="col-md-4">

        <div class="summary-card">

            <div class="d-flex align-items-center justify-content-between">

                <div>

                    <h3>
                        <asp:Label ID="lblUpcomingEvents"
                            runat="server"
                            Text="0">
                        </asp:Label>
                    </h3>

                    <p>Upcoming Events</p>

                </div>

                <div class="summary-icon icon-upcoming">
                    <i class="fa-solid fa-clock"></i>
                </div>

            </div>

        </div>

    </div>

    <div class="col-md-4">

        <div class="summary-card">

            <div class="d-flex align-items-center justify-content-between">

                <div>

                    <h3>
                        <asp:Label ID="lblExamEvents"
                            runat="server"
                            Text="0">
                        </asp:Label>
                    </h3>

                    <p>Examination Events</p>

                </div>

                <div class="summary-icon icon-exam">
                    <i class="fa-solid fa-file-pen"></i>
                </div>

            </div>

        </div>

    </div>

</div>

<div class="filter-card">

    <div class="row g-3 align-items-end">

        <div class="col-md-4">

            <label class="form-label">
                Event Type
            </label>

            <asp:DropDownList ID="ddlEventType"
                runat="server"
                CssClass="form-select">

                <asp:ListItem Text="All Event Types"
                    Value="All">
                </asp:ListItem>

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

        <div class="col-md-5">

            <label class="form-label">
                Search
            </label>

            <asp:TextBox ID="txtSearch"
                runat="server"
                CssClass="form-control"
                placeholder="Search title, description or location">
            </asp:TextBox>

        </div>

        <div class="col-md-3">

            <asp:Button ID="btnFilter"
                runat="server"
                Text="Apply Filter"
                CssClass="btn btn-filter w-100"
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

<asp:Panel ID="pnlEvents"
    runat="server">

    <asp:Repeater ID="rptEvents"
        runat="server">

        <ItemTemplate>

            <div class="event-card">

                <div class="event-title">
                    <%# Eval("EventTitle") %>
                </div>

                <div class="event-description">
                    <%# Eval("EventDescription") %>
                </div>

                <div class="event-meta">

                    <span class="meta-badge badge-type">

                        <i class="fa-solid fa-tag"></i>

                        <%# Eval("EventType") %>

                    </span>

                    <span class="meta-badge badge-date">

                        <i class="fa-solid fa-calendar-day"></i>

                        <%# Eval("StartDate", "{0:dd MMM yyyy}") %>
                        -
                        <%# Eval("EndDate", "{0:dd MMM yyyy}") %>

                    </span>

                    <asp:PlaceHolder ID="phLocation"
                        runat="server"
                        Visible='<%# Eval("Location") != DBNull.Value && !string.IsNullOrWhiteSpace(Eval("Location").ToString()) %>'>

                        <span class="meta-badge badge-location">

                            <i class="fa-solid fa-location-dot"></i>

                            <%# Eval("Location") %>

                        </span>

                    </asp:PlaceHolder>

                    <span class="meta-badge badge-audience">

                        <i class="fa-solid fa-users"></i>

                        <%#
                            Eval("Audience").ToString() == "Students"
                                ? "Students"
                                : "All Users"
                        %>

                    </span>

                </div>

            </div>

        </ItemTemplate>

    </asp:Repeater>

</asp:Panel>

<asp:Panel ID="pnlEmpty"
    runat="server"
    Visible="false">

    <div class="empty-state">

        <i class="fa-regular fa-calendar-xmark"></i>

        <h4>No Academic Events Found</h4>

        <p>
            There are currently no active academic events matching your filter.
        </p>

    </div>

</asp:Panel>


</asp:Content>
