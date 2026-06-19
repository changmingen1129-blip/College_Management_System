<%@ Page Language="C#" AutoEventWireup="true"
MasterPageFile="~/LecturerMaster.Master"
CodeBehind="LecturerMarks.aspx.cs"
Inherits="College_Management_System.LecturerMarks" %>

<asp:Content ID="HeadContent"
ContentPlaceHolderID="HeadContent"
runat="server">


<style>
    .marks-header {
        background: linear-gradient(135deg, #1e293b, #0f766e);
        color: white;
        border-radius: 24px;
        padding: 30px;
        margin-bottom: 28px;
        box-shadow: 0 12px 30px rgba(15, 23, 42, 0.15);
    }

    .marks-header h2 {
        margin-bottom: 7px;
        font-weight: 800;
    }

    .marks-header p {
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
        margin-bottom: 8px;
        color: #334155;
        font-weight: 700;
    }

    .form-control,
    .form-select {
        padding: 11px 13px;
        border: 1px solid #cbd5e1;
        border-radius: 13px;
    }

    .form-control:focus,
    .form-select:focus {
        border-color: #0f766e;
        box-shadow: 0 0 0 0.2rem rgba(15, 118, 110, 0.14);
    }

    .btn-primary-custom {
        padding: 11px 20px;
        border: none;
        border-radius: 13px;
        background: linear-gradient(135deg, #0f766e, #14b8a6);
        color: white;
        font-weight: 700;
        transition: 0.25s;
    }

    .btn-primary-custom:hover {
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 8px 18px rgba(15, 118, 110, 0.25);
    }

    .btn-dark-custom {
        padding: 11px 20px;
        border: none;
        border-radius: 13px;
        background: #1e293b;
        color: white;
        font-weight: 700;
    }

    .btn-dark-custom:hover {
        background: #0f172a;
        color: white;
    }

    .message-label {
        display: block;
        margin-top: 15px;
        padding: 11px 14px;
        border-radius: 12px;
        font-weight: 650;
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

    .icon-average {
        background: #ccfbf1;
        color: #0f766e;
    }

    .icon-highest {
        background: #dcfce7;
        color: #16a34a;
    }

    .icon-lowest {
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

    .student-name {
        color: #0f172a;
        font-weight: 700;
    }

    .course-badge,
    .assessment-badge,
    .grade-badge {
        display: inline-block;
        padding: 7px 12px;
        border-radius: 999px;
        font-size: 13px;
        font-weight: 800;
    }

    .course-badge {
        background: #dbeafe;
        color: #1d4ed8;
    }

    .assessment-badge {
        background: #ede9fe;
        color: #6d28d9;
    }

    .grade-badge {
        min-width: 44px;
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

    .mark-input {
        width: 110px;
        padding: 8px 10px;
        border: 1px solid #cbd5e1;
        border-radius: 10px;
    }

    .remarks-input {
        min-width: 190px;
        padding: 8px 10px;
        border: 1px solid #cbd5e1;
        border-radius: 10px;
    }

    .section-divider {
        height: 1px;
        margin: 22px 0;
        background: #e2e8f0;
    }

    @media (max-width: 768px) {
        .marks-header {
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


<div class="marks-header">
    <div class="row align-items-center">

        <div class="col-md-9">
            <h2>Assessment and Marks Management</h2>

            <p>
                Create assessments, enter student marks, update results
                and monitor academic performance.
            </p>
        </div>

        <div class="col-md-3 d-flex justify-content-md-end">
            <div class="header-icon">
                <i class="fa-solid fa-file-pen"></i>
            </div>
        </div>

    </div>
</div>

<!-- CREATE ASSESSMENT -->
<div class="content-card">

    <h4 class="card-title-custom">Create New Assessment</h4>

    <p class="card-subtitle-custom">
        Select an assigned course and create an assessment before
        entering student marks.
    </p>

    <div class="row g-3">

        <div class="col-md-6">
            <label class="form-label">Assigned Course</label>

            <asp:DropDownList ID="ddlCreateCourse"
                runat="server"
                CssClass="form-select">
            </asp:DropDownList>

            <asp:RequiredFieldValidator ID="rfvCreateCourse"
                runat="server"
                ControlToValidate="ddlCreateCourse"
                InitialValue="0"
                ValidationGroup="CreateAssessment"
                ErrorMessage="Please select a course."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RequiredFieldValidator>
        </div>

        <div class="col-md-6">
            <label class="form-label">Assessment Name</label>

            <asp:TextBox ID="txtAssessmentName"
                runat="server"
                CssClass="form-control"
                MaxLength="100"
                placeholder="Example: Assignment 1">
            </asp:TextBox>

            <asp:RequiredFieldValidator ID="rfvAssessmentName"
                runat="server"
                ControlToValidate="txtAssessmentName"
                ValidationGroup="CreateAssessment"
                ErrorMessage="Assessment name is required."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RequiredFieldValidator>
        </div>

        <div class="col-md-6">
            <label class="form-label">Maximum Mark</label>

            <asp:TextBox ID="txtMaxMark"
                runat="server"
                CssClass="form-control"
                TextMode="Number"
                step="0.01"
                min="0.01"
                max="999.99"
                placeholder="Example: 100">
            </asp:TextBox>

            <asp:RequiredFieldValidator ID="rfvMaxMark"
                runat="server"
                ControlToValidate="txtMaxMark"
                ValidationGroup="CreateAssessment"
                ErrorMessage="Maximum mark is required."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RequiredFieldValidator>
        </div>

        <div class="col-md-6">
            <label class="form-label">Weightage (%)</label>

            <asp:TextBox ID="txtWeightage"
                runat="server"
                CssClass="form-control"
                TextMode="Number"
                step="0.01"
                min="0.01"
                max="100"
                placeholder="Example: 30">
            </asp:TextBox>

            <asp:RequiredFieldValidator ID="rfvWeightage"
                runat="server"
                ControlToValidate="txtWeightage"
                ValidationGroup="CreateAssessment"
                ErrorMessage="Weightage is required."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RequiredFieldValidator>
        </div>

        <div class="col-12">
            <asp:Button ID="btnCreateAssessment"
                runat="server"
                Text="Create Assessment"
                CssClass="btn btn-primary-custom"
                ValidationGroup="CreateAssessment"
                OnClick="btnCreateAssessment_Click" />
        </div>

    </div>

    <asp:Label ID="lblCreateMessage"
        runat="server"
        Visible="false">
    </asp:Label>

</div>

<!-- ENTER MARKS -->
<div class="content-card">

    <h4 class="card-title-custom">Enter Student Marks</h4>

    <p class="card-subtitle-custom">
        Select a course and assessment, then load the enrolled students.
    </p>

    <div class="row g-3 align-items-end">

        <div class="col-md-5">
            <label class="form-label">Course</label>

            <asp:DropDownList ID="ddlCourse"
                runat="server"
                CssClass="form-select"
                AutoPostBack="true"
                OnSelectedIndexChanged="ddlCourse_SelectedIndexChanged">
            </asp:DropDownList>
        </div>

        <div class="col-md-5">
            <label class="form-label">Assessment</label>

            <asp:DropDownList ID="ddlAssessment"
                runat="server"
                CssClass="form-select">
            </asp:DropDownList>
        </div>

        <div class="col-md-2">
            <asp:Button ID="btnLoadStudents"
                runat="server"
                Text="Load Students"
                CssClass="btn btn-dark-custom w-100"
                CausesValidation="false"
                OnClick="btnLoadStudents_Click" />
        </div>

    </div>

    <asp:Label ID="lblMarksMessage"
        runat="server"
        Visible="false">
    </asp:Label>

    <div class="section-divider"></div>

    <div class="table-responsive">

        <asp:GridView ID="gvStudents"
            runat="server"
            AutoGenerateColumns="False"
            GridLines="None"
            CssClass="table table-hover"
            DataKeyNames="StudentID"
            EmptyDataText="Select a course and assessment to load students.">

            <Columns>

                <asp:TemplateField HeaderText="Student">
                    <ItemTemplate>
                        <div class="student-name">
                            <%# Eval("StudentName") %>
                        </div>

                        <small class="text-muted">
                            <%# Eval("Email") %>
                        </small>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="StudentID"
                    HeaderText="Student ID" />

                <asp:TemplateField HeaderText="Mark Obtained">
                    <ItemTemplate>
                        <asp:TextBox ID="txtStudentMark"
                            runat="server"
                            CssClass="mark-input"
                            Text='<%# Eval("MarkObtained") %>'
                            TextMode="Number"
                            step="0.01"
                            min="0">
                        </asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Remarks">
                    <ItemTemplate>
                        <asp:TextBox ID="txtRemarks"
                            runat="server"
                            CssClass="remarks-input"
                            Text='<%# Eval("Remarks") %>'
                            MaxLength="255"
                            placeholder="Optional remarks">
                        </asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

        </asp:GridView>

    </div>

    <div class="mt-4">
        <asp:Button ID="btnSaveMarks"
            runat="server"
            Text="Save or Update Marks"
            CssClass="btn btn-primary-custom"
            Visible="false"
            CausesValidation="false"
            OnClick="btnSaveMarks_Click" />
    </div>

</div>

<!-- SUMMARY -->
<div class="row g-4 mb-4">

    <div class="col-md-6 col-xl-3">
        <div class="summary-card">

            <div class="summary-icon icon-student">
                <i class="fa-solid fa-users"></i>
            </div>

            <h3>
                <asp:Label ID="lblTotalStudents"
                    runat="server"
                    Text="0">
                </asp:Label>
            </h3>

            <p>Students Graded</p>

        </div>
    </div>

    <div class="col-md-6 col-xl-3">
        <div class="summary-card">

            <div class="summary-icon icon-average">
                <i class="fa-solid fa-chart-column"></i>
            </div>

            <h3>
                <asp:Label ID="lblAverageMark"
                    runat="server"
                    Text="0.00">
                </asp:Label>
            </h3>

            <p>Average Mark</p>

        </div>
    </div>

    <div class="col-md-6 col-xl-3">
        <div class="summary-card">

            <div class="summary-icon icon-highest">
                <i class="fa-solid fa-arrow-trend-up"></i>
            </div>

            <h3>
                <asp:Label ID="lblHighestMark"
                    runat="server"
                    Text="0.00">
                </asp:Label>
            </h3>

            <p>Highest Mark</p>

        </div>
    </div>

    <div class="col-md-6 col-xl-3">
        <div class="summary-card">

            <div class="summary-icon icon-lowest">
                <i class="fa-solid fa-arrow-trend-down"></i>
            </div>

            <h3>
                <asp:Label ID="lblLowestMark"
                    runat="server"
                    Text="0.00">
                </asp:Label>
            </h3>

            <p>Lowest Mark</p>

        </div>
    </div>

</div>

<!-- MARKS REPORT -->
<div class="content-card">

    <h4 class="card-title-custom">Saved Marks Report</h4>

    <p class="card-subtitle-custom">
        Review all marks entered for your assigned courses.
    </p>

    <div class="table-responsive">

        <asp:GridView ID="gvMarksReport"
            runat="server"
            AutoGenerateColumns="False"
            GridLines="None"
            CssClass="table table-hover"
            EmptyDataText="No marks have been recorded yet.">

            <Columns>

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

                <asp:TemplateField HeaderText="Assessment">
                    <ItemTemplate>
                        <span class="assessment-badge">
                            <%# Eval("AssessmentName") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="StudentName"
                    HeaderText="Student" />

                <asp:BoundField DataField="MarkObtained"
                    HeaderText="Mark"
                    DataFormatString="{0:0.##}" />

                <asp:BoundField DataField="MaxMark"
                    HeaderText="Maximum"
                    DataFormatString="{0:0.##}" />

                <asp:BoundField DataField="Percentage"
                    HeaderText="Percentage"
                    DataFormatString="{0:0.00}%" />

                <asp:TemplateField HeaderText="Grade">
                    <ItemTemplate>
                        <span class='grade-badge <%# GetGradeClass(Eval("Grade").ToString()) %>'>
                            <%# Eval("Grade") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="Weightage"
                    HeaderText="Weightage"
                    DataFormatString="{0:0.##}%" />

                <asp:BoundField DataField="Remarks"
                    HeaderText="Remarks" />

            </Columns>

        </asp:GridView>

    </div>

</div>


</asp:Content>
