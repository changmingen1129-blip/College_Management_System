<%@ Page Language="C#" AutoEventWireup="true"
MasterPageFile="~/LecturerMaster.Master"
CodeBehind="LecturerProgress.aspx.cs"
Inherits="College_Management_System.LecturerProgress" %>

<asp:Content ID="HeadContent"
ContentPlaceHolderID="HeadContent"
runat="server">


<style>
    .progress-header {
        background: linear-gradient(135deg, #0f172a, #7c3aed);
        color: white;
        border-radius: 24px;
        padding: 30px;
        margin-bottom: 28px;
        box-shadow: 0 12px 30px rgba(15, 23, 42, 0.15);
    }

    .progress-header h2 {
        margin-bottom: 7px;
        font-weight: 800;
    }

    .progress-header p {
        margin-bottom: 0;
        color: #ede9fe;
    }

    .progress-icon {
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

    .icon-total {
        background: #dbeafe;
        color: #2563eb;
    }

    .icon-good {
        background: #dcfce7;
        color: #16a34a;
    }

    .icon-warning {
        background: #fef3c7;
        color: #d97706;
    }

    .icon-risk {
        background: #fee2e2;
        color: #dc2626;
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
        border-color: #7c3aed;
        box-shadow: 0 0 0 0.2rem rgba(124, 58, 237, 0.14);
    }

    .btn-filter {
        padding: 11px 20px;
        border: none;
        border-radius: 13px;
        background: linear-gradient(135deg, #7c3aed, #8b5cf6);
        color: white;
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

    .student-id-badge {
        display: inline-block;
        padding: 7px 12px;
        border-radius: 999px;
        background: #dbeafe;
        color: #1d4ed8;
        font-size: 13px;
        font-weight: 800;
    }

    .course-code-badge {
        display: inline-block;
        padding: 7px 12px;
        border-radius: 999px;
        background: #ede9fe;
        color: #6d28d9;
        font-size: 13px;
        font-weight: 800;
    }

    .percentage-badge {
        display: inline-block;
        min-width: 72px;
        padding: 7px 12px;
        border-radius: 999px;
        background: #f1f5f9;
        color: #334155;
        font-size: 13px;
        font-weight: 800;
        text-align: center;
    }

    .risk-badge {
        display: inline-block;
        min-width: 105px;
        padding: 7px 12px;
        border-radius: 999px;
        font-size: 13px;
        font-weight: 800;
        text-align: center;
    }

    .risk-good {
        background: #dcfce7;
        color: #15803d;
    }

    .risk-warning {
        background: #fef3c7;
        color: #b45309;
    }

    .risk-high {
        background: #fee2e2;
        color: #b91c1c;
    }

    .warning-text {
        max-width: 280px;
        white-space: normal;
        line-height: 1.5;
    }

    .information-box {
        margin-top: 22px;
        padding: 15px 18px;
        border-left: 4px solid #7c3aed;
        border-radius: 12px;
        background: #f5f3ff;
        color: #475569;
        font-size: 14px;
        font-weight: 600;
    }

    .message-label {
        display: block;
        margin-top: 15px;
        padding: 11px 14px;
        border-radius: 12px;
        font-weight: 650;
    }
</style>


</asp:Content>

<asp:Content ID="MainContent"
ContentPlaceHolderID="MainContent"
runat="server">


<div class="progress-header">

    <div class="row align-items-center">

        <div class="col-md-9">

            <h2>Student Academic Progress</h2>

            <p>
                Monitor student attendance, assessment performance and academic risk.
            </p>

        </div>

        <div class="col-md-3 d-flex justify-content-md-end">

            <div class="progress-icon">
                <i class="fa-solid fa-chart-line"></i>
            </div>

        </div>

    </div>

</div>

<div class="row g-4">

    <div class="col-md-6 col-xl-3">

        <div class="summary-card">

            <div class="summary-icon icon-total">
                <i class="fa-solid fa-users"></i>
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

            <div class="summary-icon icon-good">
                <i class="fa-solid fa-circle-check"></i>
            </div>

            <h3>
                <asp:Label ID="lblGoodStanding"
                    runat="server"
                    Text="0">
                </asp:Label>
            </h3>

            <p>Good Standing</p>

        </div>

    </div>

    <div class="col-md-6 col-xl-3">

        <div class="summary-card">

            <div class="summary-icon icon-warning">
                <i class="fa-solid fa-triangle-exclamation"></i>
            </div>

            <h3>
                <asp:Label ID="lblWarningStudents"
                    runat="server"
                    Text="0">
                </asp:Label>
            </h3>

            <p>Warning</p>

        </div>

    </div>

    <div class="col-md-6 col-xl-3">

        <div class="summary-card">

            <div class="summary-icon icon-risk">
                <i class="fa-solid fa-circle-exclamation"></i>
            </div>

            <h3>
                <asp:Label ID="lblHighRiskStudents"
                    runat="server"
                    Text="0">
                </asp:Label>
            </h3>

            <p>High Risk</p>

        </div>

    </div>

</div>

<div class="content-card">

    <h4 class="card-title-custom">Filter Progress Records</h4>

    <p class="card-subtitle-custom">
        Select one of your assigned courses to view student progress.
    </p>

    <div class="row g-3 align-items-end">

        <div class="col-md-8">

            <label class="form-label">Assigned Course</label>

            <asp:DropDownList ID="ddlCourse"
                runat="server"
                CssClass="form-select"
                AutoPostBack="false">
            </asp:DropDownList>

        </div>

        <div class="col-md-4">

            <asp:Button ID="btnLoadProgress"
                runat="server"
                Text="Load Progress"
                CssClass="btn btn-filter w-100"
                CausesValidation="false"
                OnClick="btnLoadProgress_Click" />

        </div>

    </div>

    <asp:Label ID="lblMessage"
        runat="server"
        Visible="false">
    </asp:Label>

</div>

<div class="content-card">

    <h4 class="card-title-custom">Student Progress Report</h4>

    <p class="card-subtitle-custom">
        Students are classified using attendance and assessment performance.
    </p>

    <div class="table-responsive">

        <asp:GridView ID="gvProgress"
            runat="server"
            AutoGenerateColumns="False"
            GridLines="None"
            CssClass="table table-hover"
            EmptyDataText="No student progress records are available.">

            <Columns>

                <asp:TemplateField HeaderText="Student ID">

                    <ItemTemplate>

                        <span class="student-id-badge">
                            <%# Eval("StudentID") %>
                        </span>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:BoundField DataField="StudentName"
                    HeaderText="Student Name" />

                <asp:TemplateField HeaderText="Course">

                    <ItemTemplate>

                        <span class="course-code-badge">
                            <%# Eval("CourseCode") %>
                        </span>

                        <div class="mt-2 fw-semibold">
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

                <asp:TemplateField HeaderText="Warning Reason">

                    <ItemTemplate>

                        <div class="warning-text">
                            <%# Eval("WarningReason") %>
                        </div>

                    </ItemTemplate>

                </asp:TemplateField>

            </Columns>

        </asp:GridView>

    </div>

    <div class="information-box">
        Risk rules: attendance below 80 percent creates an attendance warning,
        average performance below 50 percent creates a performance warning,
        and students who meet both conditions are classified as High Risk.
    </div>

</div>


</asp:Content>
