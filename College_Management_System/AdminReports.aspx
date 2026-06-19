<%@ Page Language="C#" AutoEventWireup="true"
MasterPageFile="~/AdminMaster.Master"
CodeBehind="AdminReports.aspx.cs"
Inherits="College_Management_System.AdminReports" %>

<asp:Content ID="HeadContent"
ContentPlaceHolderID="HeadContent"
runat="server">


<style>
    .report-header {
        background: linear-gradient(135deg, #0f172a, #2563eb);
        color: white;
        border-radius: 24px;
        padding: 30px;
        margin-bottom: 28px;
        box-shadow: 0 12px 30px rgba(15, 23, 42, 0.15);
    }

    .report-header h2 {
        margin-bottom: 7px;
        font-weight: 800;
    }

    .report-header p {
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

    .btn-print {
        margin-top: 18px;
        padding: 11px 20px;
        border: none;
        border-radius: 13px;
        background: white;
        color: #1d4ed8;
        font-weight: 800;
        transition: 0.25s;
    }

    .btn-print:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 18px rgba(0, 0, 0, 0.15);
    }

    .summary-card {
        height: 100%;
        padding: 22px;
        border-radius: 20px;
        background: white;
        box-shadow: 0 8px 24px rgba(15, 23, 42, 0.07);
    }

    .summary-icon {
        width: 52px;
        height: 52px;
        margin-bottom: 15px;
        border-radius: 16px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 22px;
    }

    .icon-student {
        background: #dbeafe;
        color: #2563eb;
    }

    .icon-lecturer {
        background: #dcfce7;
        color: #16a34a;
    }

    .icon-programme {
        background: #ede9fe;
        color: #7c3aed;
    }

    .icon-course {
        background: #fef3c7;
        color: #d97706;
    }

    .summary-card h3 {
        margin-bottom: 4px;
        color: #0f172a;
        font-weight: 800;
    }

    .summary-card p {
        margin-bottom: 0;
        color: #64748b;
        font-weight: 600;
    }

    .content-card {
        background: white;
        border-radius: 22px;
        padding: 26px;
        margin-top: 28px;
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
        margin-bottom: 8px;
        color: #334155;
        font-weight: 700;
    }

    .form-select {
        padding: 11px 13px;
        border: 1px solid #cbd5e1;
        border-radius: 13px;
    }

    .form-select:focus {
        border-color: #2563eb;
        box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.14);
    }

    .btn-load {
        padding: 11px 20px;
        border: none;
        border-radius: 13px;
        background: linear-gradient(135deg, #1d4ed8, #3b82f6);
        color: white;
        font-weight: 700;
    }

    .btn-reset {
        padding: 11px 20px;
        border: none;
        border-radius: 13px;
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

    .programme-badge {
        display: inline-block;
        padding: 7px 12px;
        border-radius: 999px;
        background: #ede9fe;
        color: #6d28d9;
        font-size: 13px;
        font-weight: 800;
    }

    .course-badge {
        display: inline-block;
        padding: 7px 12px;
        border-radius: 999px;
        background: #dbeafe;
        color: #1d4ed8;
        font-size: 13px;
        font-weight: 800;
    }

    .percentage-badge {
        display: inline-block;
        min-width: 75px;
        padding: 7px 12px;
        border-radius: 999px;
        background: #f1f5f9;
        color: #334155;
        font-size: 13px;
        font-weight: 800;
        text-align: center;
    }

    .status-badge {
        display: inline-block;
        min-width: 95px;
        padding: 7px 12px;
        border-radius: 999px;
        font-size: 13px;
        font-weight: 800;
        text-align: center;
    }

    .status-good {
        background: #dcfce7;
        color: #15803d;
    }

    .status-warning {
        background: #fef3c7;
        color: #b45309;
    }

    .status-risk {
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

    .report-note {
        margin-top: 22px;
        padding: 15px 18px;
        border-left: 4px solid #2563eb;
        border-radius: 12px;
        background: #eff6ff;
        color: #475569;
        font-size: 14px;
        font-weight: 600;
    }

    @media print {
        body {
            background: white !important;
        }

        .admin-sidebar,
        .btn-print,
        .filter-section,
        .no-print {
            display: none !important;
        }

        .admin-main {
            width: 100% !important;
            margin-left: 0 !important;
            padding: 0 !important;
        }

        .report-header,
        .summary-card,
        .content-card {
            box-shadow: none !important;
            break-inside: avoid;
        }

        .report-header {
            background: #1d4ed8 !important;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }

        .table thead th {
            background: #e2e8f0 !important;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }

        .programme-badge,
        .course-badge,
        .percentage-badge,
        .status-badge {
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }
    }
</style>


</asp:Content>

<asp:Content ID="MainContent"
ContentPlaceHolderID="MainContent"
runat="server">


<div class="report-header">

    <div class="row align-items-center">

        <div class="col-md-9">

            <h2>Institutional Reports and Analytics</h2>

            <p>
                Review enrolment, attendance, academic performance and student risk reports.
            </p>

            <asp:Button ID="btnPrintReport"
                runat="server"
                Text="Print / Save Report as PDF"
                CssClass="btn-print"
                CausesValidation="false"
                UseSubmitBehavior="false"
                OnClientClick="window.print(); return false;" />

        </div>

        <div class="col-md-3 d-flex justify-content-md-end">

            <div class="header-icon">
                <i class="fa-solid fa-chart-pie"></i>
            </div>

        </div>

    </div>

</div>

<div class="row g-4">

    <div class="col-md-6 col-xl-3">

        <div class="summary-card">

            <div class="summary-icon icon-student">
                <i class="fa-solid fa-user-graduate"></i>
            </div>

            <h3>
                <asp:Label ID="lblTotalStudents"
                    runat="server"
                    Text="0">
                </asp:Label>
            </h3>

            <p>Total Students</p>

        </div>

    </div>

    <div class="col-md-6 col-xl-3">

        <div class="summary-card">

            <div class="summary-icon icon-lecturer">
                <i class="fa-solid fa-chalkboard-user"></i>
            </div>

            <h3>
                <asp:Label ID="lblTotalLecturers"
                    runat="server"
                    Text="0">
                </asp:Label>
            </h3>

            <p>Total Lecturers</p>

        </div>

    </div>

    <div class="col-md-6 col-xl-3">

        <div class="summary-card">

            <div class="summary-icon icon-programme">
                <i class="fa-solid fa-layer-group"></i>
            </div>

            <h3>
                <asp:Label ID="lblTotalProgrammes"
                    runat="server"
                    Text="0">
                </asp:Label>
            </h3>

            <p>Total Programmes</p>

        </div>

    </div>

    <div class="col-md-6 col-xl-3">

        <div class="summary-card">

            <div class="summary-icon icon-course">
                <i class="fa-solid fa-book"></i>
            </div>

            <h3>
                <asp:Label ID="lblTotalCourses"
                    runat="server"
                    Text="0">
                </asp:Label>
            </h3>

            <p>Total Courses</p>

        </div>

    </div>

</div>

<div class="content-card filter-section">

    <h4 class="card-title-custom">Report Filters</h4>

    <p class="card-subtitle-custom">
        Filter the reports by programme and course.
    </p>

    <div class="row g-3 align-items-end">

        <div class="col-md-4">

            <label class="form-label">Programme</label>

            <asp:DropDownList ID="ddlProgramme"
                runat="server"
                CssClass="form-select"
                AutoPostBack="true"
                OnSelectedIndexChanged="ddlProgramme_SelectedIndexChanged">
            </asp:DropDownList>

        </div>

        <div class="col-md-4">

            <label class="form-label">Course</label>

            <asp:DropDownList ID="ddlCourse"
                runat="server"
                CssClass="form-select">
            </asp:DropDownList>

        </div>

        <div class="col-md-2">

            <asp:Button ID="btnLoadReports"
                runat="server"
                Text="Load Reports"
                CssClass="btn btn-load w-100"
                CausesValidation="false"
                OnClick="btnLoadReports_Click" />

        </div>

        <div class="col-md-2">

            <asp:Button ID="btnResetFilters"
                runat="server"
                Text="Reset"
                CssClass="btn btn-reset w-100"
                CausesValidation="false"
                OnClick="btnResetFilters_Click" />

        </div>

    </div>

    <asp:Label ID="lblMessage"
        runat="server"
        Visible="false">
    </asp:Label>

</div>

<div class="content-card">

    <h4 class="card-title-custom">Enrolment by Programme</h4>

    <p class="card-subtitle-custom">
        Number of students and active enrolments for each programme.
    </p>

    <div class="table-responsive">

        <asp:GridView ID="gvEnrolmentReport"
            runat="server"
            AutoGenerateColumns="False"
            GridLines="None"
            CssClass="table table-hover"
            EmptyDataText="No enrolment records are available.">

            <Columns>

                <asp:TemplateField HeaderText="Programme">

                    <ItemTemplate>

                        <span class="programme-badge">
                            <%# Eval("ProgrammeCode") %>
                        </span>

                        <div class="mt-2 fw-semibold">
                            <%# Eval("ProgrammeName") %>
                        </div>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:BoundField DataField="TotalStudents"
                    HeaderText="Students" />

                <asp:BoundField DataField="ActiveEnrolments"
                    HeaderText="Active Enrolments" />

                <asp:BoundField DataField="DroppedEnrolments"
                    HeaderText="Dropped Enrolments" />

            </Columns>

        </asp:GridView>

    </div>

</div>

<div class="content-card">

    <h4 class="card-title-custom">Course Attendance Summary</h4>

    <p class="card-subtitle-custom">
        Attendance performance for each course.
    </p>

    <div class="table-responsive">

        <asp:GridView ID="gvAttendanceReport"
            runat="server"
            AutoGenerateColumns="False"
            GridLines="None"
            CssClass="table table-hover"
            EmptyDataText="No attendance records are available.">

            <Columns>

                <asp:TemplateField HeaderText="Course">

                    <ItemTemplate>

                        <span class="course-badge">
                            <%# Eval("CourseCode") %>
                        </span>

                        <div class="mt-2 fw-semibold">
                            <%# Eval("CourseName") %>
                        </div>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:BoundField DataField="TotalAttendanceRecords"
                    HeaderText="Attendance Records" />

                <asp:BoundField DataField="PresentRecords"
                    HeaderText="Present / Late" />

                <asp:BoundField DataField="AbsentRecords"
                    HeaderText="Absent" />

                <asp:TemplateField HeaderText="Attendance Rate">

                    <ItemTemplate>

                        <span class="percentage-badge">
                            <%# Eval("AttendancePercentage", "{0:0.00}%") %>
                        </span>

                    </ItemTemplate>

                </asp:TemplateField>

            </Columns>

        </asp:GridView>

    </div>

</div>

<div class="content-card">

    <h4 class="card-title-custom">Course Performance Summary</h4>

    <p class="card-subtitle-custom">
        Average marks and student performance for each course.
    </p>

    <div class="table-responsive">

        <asp:GridView ID="gvPerformanceReport"
            runat="server"
            AutoGenerateColumns="False"
            GridLines="None"
            CssClass="table table-hover"
            EmptyDataText="No academic performance records are available.">

            <Columns>

                <asp:TemplateField HeaderText="Course">

                    <ItemTemplate>

                        <span class="course-badge">
                            <%# Eval("CourseCode") %>
                        </span>

                        <div class="mt-2 fw-semibold">
                            <%# Eval("CourseName") %>
                        </div>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:BoundField DataField="StudentsWithMarks"
                    HeaderText="Students with Marks" />

                <asp:TemplateField HeaderText="Average Mark">

                    <ItemTemplate>

                        <span class="percentage-badge">
                            <%# Eval("AverageMarkPercentage", "{0:0.00}%") %>
                        </span>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:BoundField DataField="PassedStudents"
                    HeaderText="Passed" />

                <asp:BoundField DataField="FailedStudents"
                    HeaderText="Failed" />

            </Columns>

        </asp:GridView>

    </div>

</div>

<div class="content-card">

    <h4 class="card-title-custom">At-Risk Students</h4>

    <p class="card-subtitle-custom">
        Students with low attendance, low academic performance, or both.
    </p>

    <div class="table-responsive">

        <asp:GridView ID="gvRiskReport"
            runat="server"
            AutoGenerateColumns="False"
            GridLines="None"
            CssClass="table table-hover"
            EmptyDataText="No at-risk students were found.">

            <Columns>

                <asp:BoundField DataField="StudentID"
                    HeaderText="Student ID" />

                <asp:BoundField DataField="StudentName"
                    HeaderText="Student Name" />

                <asp:TemplateField HeaderText="Course">

                    <ItemTemplate>

                        <span class="course-badge">
                            <%# Eval("CourseCode") %>
                        </span>

                        <div class="mt-2">
                            <%# Eval("CourseName") %>
                        </div>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:TemplateField HeaderText="Attendance">

                    <ItemTemplate>

                        <span class="percentage-badge">
                            <%# Eval("AttendancePercentage", "{0:0.00}%") %>
                        </span>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:TemplateField HeaderText="Average Mark">

                    <ItemTemplate>

                        <span class="percentage-badge">
                            <%# Eval("AverageMarkPercentage", "{0:0.00}%") %>
                        </span>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:TemplateField HeaderText="Risk Level">

                    <ItemTemplate>

                        <span class='<%# GetRiskClass(Eval("RiskLevel").ToString()) %>'>
                            <%# Eval("RiskLevel") %>
                        </span>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:BoundField DataField="RiskReason"
                    HeaderText="Reason" />

            </Columns>

        </asp:GridView>

    </div>

    <div class="report-note">
        A student is classified as at risk when attendance is below
        80 percent, average academic performance is below 50 percent,
        or both conditions are present.
    </div>

</div>


</asp:Content>
