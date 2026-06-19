<%@ Page Language="C#" AutoEventWireup="true"
MasterPageFile="~/StudentMaster.Master"
CodeBehind="StudentAnnouncements.aspx.cs"
Inherits="College_Management_System.StudentAnnouncements" %>

<asp:Content ID="HeadContent"
ContentPlaceHolderID="HeadContent"
runat="server">


<style>
    .announcement-header {
        background: linear-gradient(135deg, #1e3a8a, #2563eb);
        color: white;
        border-radius: 24px;
        padding: 30px;
        margin-bottom: 28px;
        box-shadow: 0 12px 30px rgba(37, 99, 235, 0.18);
    }

    .announcement-header h2 {
        margin-bottom: 7px;
        font-weight: 800;
    }

    .announcement-header p {
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

    .summary-row {
        margin-bottom: 26px;
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

    .icon-general {
        background: #ede9fe;
        color: #6d28d9;
    }

    .icon-course {
        background: #dcfce7;
        color: #15803d;
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

    .announcement-card {
        background: white;
        border-radius: 22px;
        padding: 24px;
        margin-bottom: 20px;
        box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
        border-left: 6px solid #2563eb;
    }

    .announcement-card.student-announcement {
        border-left-color: #7c3aed;
    }

    .announcement-card.course-announcement {
        border-left-color: #16a34a;
    }

    .announcement-title {
        color: #0f172a;
        font-size: 21px;
        font-weight: 800;
        margin-bottom: 8px;
    }

    .announcement-message {
        color: #475569;
        line-height: 1.7;
        white-space: pre-line;
        margin-bottom: 18px;
    }

    .announcement-meta {
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

    .badge-general {
        background: #dbeafe;
        color: #1d4ed8;
    }

    .badge-student {
        background: #ede9fe;
        color: #6d28d9;
    }

    .badge-course {
        background: #dcfce7;
        color: #15803d;
    }

    .badge-date {
        background: #f1f5f9;
        color: #475569;
    }

    .badge-expiry {
        background: #fef3c7;
        color: #b45309;
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


<div class="announcement-header">

    <div class="row align-items-center">

        <div class="col-md-9">

            <h2>Announcements</h2>

            <p>
                View general notices, student updates and announcements for your enrolled courses.
            </p>

        </div>

        <div class="col-md-3 d-flex justify-content-md-end">

            <div class="header-icon">
                <i class="fa-solid fa-bullhorn"></i>
            </div>

        </div>

    </div>

</div>

<asp:Label ID="lblMessage"
    runat="server"
    Visible="false">
</asp:Label>

<div class="row g-4 summary-row">

    <div class="col-md-4">

        <div class="summary-card">

            <div class="d-flex align-items-center justify-content-between">

                <div>

                    <h3>
                        <asp:Label ID="lblTotalAnnouncements"
                            runat="server"
                            Text="0">
                        </asp:Label>
                    </h3>

                    <p>Total Announcements</p>

                </div>

                <div class="summary-icon icon-total">
                    <i class="fa-solid fa-bullhorn"></i>
                </div>

            </div>

        </div>

    </div>

    <div class="col-md-4">

        <div class="summary-card">

            <div class="d-flex align-items-center justify-content-between">

                <div>

                    <h3>
                        <asp:Label ID="lblGeneralAnnouncements"
                            runat="server"
                            Text="0">
                        </asp:Label>
                    </h3>

                    <p>General Notices</p>

                </div>

                <div class="summary-icon icon-general">
                    <i class="fa-solid fa-building-columns"></i>
                </div>

            </div>

        </div>

    </div>

    <div class="col-md-4">

        <div class="summary-card">

            <div class="d-flex align-items-center justify-content-between">

                <div>

                    <h3>
                        <asp:Label ID="lblCourseAnnouncements"
                            runat="server"
                            Text="0">
                        </asp:Label>
                    </h3>

                    <p>Course Announcements</p>

                </div>

                <div class="summary-icon icon-course">
                    <i class="fa-solid fa-book-open"></i>
                </div>

            </div>

        </div>

    </div>

</div>

<div class="filter-card">

    <div class="row g-3 align-items-end">

        <div class="col-md-5">

            <label class="form-label">
                Announcement Type
            </label>

            <asp:DropDownList ID="ddlType"
                runat="server"
                CssClass="form-select">

                <asp:ListItem Text="All Announcements"
                    Value="All">
                </asp:ListItem>

                <asp:ListItem Text="General Announcements"
                    Value="General">
                </asp:ListItem>

                <asp:ListItem Text="Course Announcements"
                    Value="Course">
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
                placeholder="Search by title, message or course">
            </asp:TextBox>

        </div>

        <div class="col-md-2">

            <asp:Button ID="btnFilter"
                runat="server"
                Text="Apply"
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

<asp:Panel ID="pnlAnnouncements"
    runat="server">

    <asp:Repeater ID="rptAnnouncements"
        runat="server">

        <ItemTemplate>

            <div class='<%#
                Eval("Audience").ToString().Equals(
                    "Course",
                    StringComparison.OrdinalIgnoreCase
                )
                    ? "announcement-card course-announcement"
                : Eval("Audience").ToString().Equals(
                    "Students",
                    StringComparison.OrdinalIgnoreCase
                )
                    ? "announcement-card student-announcement"
                    : "announcement-card"
            %>'>

                <div class="announcement-title">
                    <%# Eval("Title") %>
                </div>

                <div class="announcement-message">
                    <%# Eval("Message") %>
                </div>

                <div class="announcement-meta">

                    <span class='<%#
                        Eval("Audience").ToString().Equals(
                            "Course",
                            StringComparison.OrdinalIgnoreCase
                        )
                            ? "meta-badge badge-course"
                        : Eval("Audience").ToString().Equals(
                            "Students",
                            StringComparison.OrdinalIgnoreCase
                        )
                            ? "meta-badge badge-student"
                            : "meta-badge badge-general"
                    %>'>

                        <i class='<%#
                            Eval("Audience").ToString().Equals(
                                "Course",
                                StringComparison.OrdinalIgnoreCase
                            )
                                ? "fa-solid fa-book-open"
                            : Eval("Audience").ToString().Equals(
                                "Students",
                                StringComparison.OrdinalIgnoreCase
                            )
                                ? "fa-solid fa-user-graduate"
                                : "fa-solid fa-users"
                        %>'></i>

                        <%#
                            Eval("Audience").ToString().Equals(
                                "Course",
                                StringComparison.OrdinalIgnoreCase
                            )
                                ? "Course Announcement"
                            : Eval("Audience").ToString().Equals(
                                "Students",
                                StringComparison.OrdinalIgnoreCase
                            )
                                ? "Students"
                                : "All Students"
                        %>

                    </span>

                    <asp:PlaceHolder ID="phCourse"
                        runat="server"
                        Visible='<%#
                            Eval("CourseID") != DBNull.Value
                        %>'>

                        <span class="meta-badge badge-course">

                            <i class="fa-solid fa-book"></i>

                            <%# Eval("CourseDisplay") %>

                        </span>

                    </asp:PlaceHolder>

                    <span class="meta-badge badge-date">

                        <i class="fa-solid fa-calendar-day"></i>

                        <%# Eval(
                            "CreatedAt",
                            "{0:dd MMM yyyy HH:mm}"
                        ) %>

                    </span>

                    <asp:PlaceHolder ID="phExpiry"
                        runat="server"
                        Visible='<%#
                            Eval("ExpiryDate") != DBNull.Value
                        %>'>

                        <span class="meta-badge badge-expiry">

                            <i class="fa-solid fa-hourglass-end"></i>

                            Expires
                            <%# Eval(
                                "ExpiryDate",
                                "{0:dd MMM yyyy}"
                            ) %>

                        </span>

                    </asp:PlaceHolder>

                </div>

            </div>

        </ItemTemplate>

    </asp:Repeater>

</asp:Panel>

<asp:Panel ID="pnlEmpty"
    runat="server"
    Visible="false">

    <div class="empty-state">

        <i class="fa-regular fa-bell-slash"></i>

        <h4>No Announcements Found</h4>

        <p>
            There are currently no active announcements matching your filter.
        </p>

    </div>

</asp:Panel>


</asp:Content>
