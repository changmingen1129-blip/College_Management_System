<%@ Page Language="C#" AutoEventWireup="true"
MasterPageFile="~/StudentMaster.Master"
CodeBehind="StudentResult.aspx.cs"
Inherits="College_Management_System.StudentResult" %>

<asp:Content ID="HeadContent"
ContentPlaceHolderID="HeadContent"
runat="server">


<style>
    .result-header {
        background: linear-gradient(135deg, #0f172a, #0f766e);
        color: white;
        border-radius: 24px;
        padding: 30px;
        margin-bottom: 28px;
        box-shadow: 0 12px 30px rgba(15, 23, 42, 0.15);
    }

    .result-header h2 {
        margin-bottom: 7px;
        font-weight: 800;
    }

    .result-header p {
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

    .print-button {
        margin-top: 18px;
        padding: 11px 20px;
        border: none;
        border-radius: 13px;
        background: white;
        color: #0f766e;
        font-weight: 800;
        transition: 0.25s;
    }

    .print-button:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 18px rgba(0, 0, 0, 0.15);
    }

    .student-info-card {
        background: white;
        border-radius: 22px;
        padding: 26px;
        margin-bottom: 28px;
        box-shadow: 0 8px 25px rgba(15, 23, 42, 0.08);
    }

    .student-info-title {
        margin-bottom: 20px;
        color: #0f172a;
        font-weight: 800;
    }

    .info-item {
        padding: 15px;
        border-radius: 14px;
        background: #f8fafc;
        height: 100%;
    }

    .info-label {
        margin-bottom: 5px;
        color: #64748b;
        font-size: 13px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .info-value {
        margin-bottom: 0;
        color: #0f172a;
        font-size: 16px;
        font-weight: 750;
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

    .icon-course {
        background: #dbeafe;
        color: #2563eb;
    }

    .icon-gpa {
        background: #ccfbf1;
        color: #0f766e;
    }

    .icon-cgpa {
        background: #ede9fe;
        color: #7c3aed;
    }

    .icon-status {
        background: #dcfce7;
        color: #16a34a;
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

    .course-code-badge {
        display: inline-block;
        padding: 7px 12px;
        border-radius: 999px;
        background: #dbeafe;
        color: #1d4ed8;
        font-size: 13px;
        font-weight: 800;
    }

    .assessment-badge {
        display: inline-block;
        padding: 7px 12px;
        border-radius: 999px;
        background: #ede9fe;
        color: #6d28d9;
        font-size: 13px;
        font-weight: 800;
    }

    .grade-badge {
        display: inline-block;
        min-width: 48px;
        padding: 7px 12px;
        border-radius: 999px;
        font-weight: 800;
        text-align: center;
    }

    .grade-a {
        background: #dcfce7;
        color: #15803d;
    }

    .grade-b {
        background: #dbeafe;
        color: #1d4ed8;
    }

    .grade-c {
        background: #fef3c7;
        color: #b45309;
    }

    .grade-d {
        background: #ffedd5;
        color: #c2410c;
    }

    .grade-f {
        background: #fee2e2;
        color: #b91c1c;
    }

    .status-badge {
        display: inline-block;
        min-width: 78px;
        padding: 7px 12px;
        border-radius: 999px;
        font-size: 13px;
        font-weight: 800;
        text-align: center;
    }

    .status-pass {
        background: #dcfce7;
        color: #15803d;
    }

    .status-fail {
        background: #fee2e2;
        color: #b91c1c;
    }

    .empty-result {
        padding: 35px;
        border: 2px dashed #cbd5e1;
        border-radius: 18px;
        background: #f8fafc;
        color: #64748b;
        text-align: center;
    }

    .empty-result i {
        display: block;
        margin-bottom: 14px;
        color: #94a3b8;
        font-size: 38px;
    }

    .result-note {
        margin-top: 24px;
        padding: 15px 18px;
        border-left: 4px solid #0f766e;
        border-radius: 12px;
        background: #f0fdfa;
        color: #475569;
        font-size: 14px;
        font-weight: 600;
    }

    @media print {
        body {
            background: white !important;
        }

        .student-sidebar,
        .print-button,
        .no-print {
            display: none !important;
        }

        .student-main {
            width: 100% !important;
            margin-left: 0 !important;
            padding: 0 !important;
        }

        .result-header,
        .student-info-card,
        .summary-card,
        .content-card {
            box-shadow: none !important;
            break-inside: avoid;
        }

        .result-header {
            background: #0f766e !important;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }

        .table thead th {
            background: #e2e8f0 !important;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }

        .grade-badge,
        .status-badge,
        .course-code-badge,
        .assessment-badge {
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }
    }

    @media (max-width: 768px) {
        .result-header {
            padding: 24px;
        }

        .header-icon {
            margin-top: 20px;
        }
    }
</style>


</asp:Content>

<asp:Content ID="MainContent"
ContentPlaceHolderID="MainContent"
runat="server">


<!-- HEADER -->
<div class="result-header">
    <div class="row align-items-center">

        <div class="col-md-9">
            <h2>Academic Result and Performance</h2>

            <p>
                View your assessment marks, course grades, GPA and CGPA.
            </p>

            <asp:Button ID="btnPrintResult"
                runat="server"
                Text="Print / Save Result as PDF"
                CssClass="print-button"
                CausesValidation="false"
                UseSubmitBehavior="false"
                OnClientClick="window.print(); return false;" />
        </div>

        <div class="col-md-3 d-flex justify-content-md-end">
            <div class="header-icon">
                <i class="fa-solid fa-graduation-cap"></i>
            </div>
        </div>

    </div>
</div>

<!-- STUDENT INFORMATION -->
<div class="student-info-card">

    <h4 class="student-info-title">Student Information</h4>

    <div class="row g-3">

        <div class="col-md-6 col-lg-3">
            <div class="info-item">
                <div class="info-label">Student Name</div>

                <p class="info-value">
                    <asp:Label ID="lblStudentName"
                        runat="server"
                        Text="-">
                    </asp:Label>
                </p>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="info-item">
                <div class="info-label">Student ID</div>

                <p class="info-value">
                    <asp:Label ID="lblStudentID"
                        runat="server"
                        Text="-">
                    </asp:Label>
                </p>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="info-item">
                <div class="info-label">Email</div>

                <p class="info-value">
                    <asp:Label ID="lblEmail"
                        runat="server"
                        Text="-">
                    </asp:Label>
                </p>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="info-item">
                <div class="info-label">Programme</div>

                <p class="info-value">
                    <asp:Label ID="lblProgramme"
                        runat="server"
                        Text="-">
                    </asp:Label>
                </p>
            </div>
        </div>

    </div>
</div>

<!-- SUMMARY -->
<div class="row g-4">

    <div class="col-md-6 col-xl-3">
        <div class="summary-card">

            <div class="summary-icon icon-course">
                <i class="fa-solid fa-book-open"></i>
            </div>

            <h3>
                <asp:Label ID="lblTotalCourses"
                    runat="server"
                    Text="0">
                </asp:Label>
            </h3>

            <p>Courses with Results</p>

        </div>
    </div>

    <div class="col-md-6 col-xl-3">
        <div class="summary-card">

            <div class="summary-icon icon-gpa">
                <i class="fa-solid fa-chart-column"></i>
            </div>

            <h3>
                <asp:Label ID="lblGPA"
                    runat="server"
                    Text="0.00">
                </asp:Label>
            </h3>

            <p>Current GPA</p>

        </div>
    </div>

    <div class="col-md-6 col-xl-3">
        <div class="summary-card">

            <div class="summary-icon icon-cgpa">
                <i class="fa-solid fa-award"></i>
            </div>

            <h3>
                <asp:Label ID="lblCGPA"
                    runat="server"
                    Text="0.00">
                </asp:Label>
            </h3>

            <p>Cumulative CGPA</p>

        </div>
    </div>

    <div class="col-md-6 col-xl-3">
        <div class="summary-card">

            <div class="summary-icon icon-status">
                <i class="fa-solid fa-circle-check"></i>
            </div>

            <h3>
                <asp:Label ID="lblOverallStatus"
                    runat="server"
                    Text="No Result">
                </asp:Label>
            </h3>

            <p>Overall Status</p>

        </div>
    </div>

</div>

<!-- COURSE RESULTS -->
<div class="content-card">

    <h4 class="card-title-custom">Course Result Summary</h4>

    <p class="card-subtitle-custom">
        Final course percentages are calculated using assessment weightages.
    </p>

    <div class="table-responsive">

        <asp:GridView ID="gvCourseResults"
            runat="server"
            AutoGenerateColumns="False"
            GridLines="None"
            CssClass="table table-hover"
            EmptyDataText="No published course results are available.">

            <Columns>

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

                <asp:BoundField DataField="CreditHours"
                    HeaderText="Credit Hours" />

                <asp:BoundField DataField="FinalPercentage"
                    HeaderText="Final Result"
                    DataFormatString="{0:0.00}%" />

                <asp:TemplateField HeaderText="Grade">
                    <ItemTemplate>
                        <span class='grade-badge <%# GetGradeClass(Eval("Grade").ToString()) %>'>
                            <%# Eval("Grade") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="GradePoint"
                    HeaderText="Grade Point"
                    DataFormatString="{0:0.00}" />

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='status-badge <%# GetStatusClass(Eval("ResultStatus").ToString()) %>'>
                            <%# Eval("ResultStatus") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

        </asp:GridView>

    </div>

</div>

<!-- ASSESSMENT BREAKDOWN -->
<div class="content-card">

    <h4 class="card-title-custom">Assessment Breakdown</h4>

    <p class="card-subtitle-custom">
        Detailed marks for assignments, quizzes, tests and examinations.
    </p>

    <div class="table-responsive">

        <asp:GridView ID="gvAssessmentDetails"
            runat="server"
            AutoGenerateColumns="False"
            GridLines="None"
            CssClass="table table-hover"
            EmptyDataText="No assessment marks are available.">

            <Columns>

                <asp:TemplateField HeaderText="Course">
                    <ItemTemplate>
                        <span class="course-code-badge">
                            <%# Eval("CourseCode") %>
                        </span>

                        <div class="mt-2">
                            <%# Eval("CourseName") %>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Assessment">
                    <ItemTemplate>
                        <span class="assessment-badge">
                            <%# Eval("AssessmentName") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="MarkObtained"
                    HeaderText="Mark"
                    DataFormatString="{0:0.##}" />

                <asp:BoundField DataField="MaxMark"
                    HeaderText="Maximum"
                    DataFormatString="{0:0.##}" />

                <asp:BoundField DataField="AssessmentPercentage"
                    HeaderText="Percentage"
                    DataFormatString="{0:0.00}%" />

                <asp:BoundField DataField="Weightage"
                    HeaderText="Weightage"
                    DataFormatString="{0:0.##}%" />

                <asp:BoundField DataField="WeightedScore"
                    HeaderText="Weighted Score"
                    DataFormatString="{0:0.00}" />

                <asp:BoundField DataField="Remarks"
                    HeaderText="Lecturer Remarks" />

            </Columns>

        </asp:GridView>

    </div>

    <div class="result-note">
        GPA is calculated using grade points multiplied by course credit
        hours. As the current system does not yet separate results by
        semester, GPA and CGPA use all available course results.
    </div>

</div>


</asp:Content>
