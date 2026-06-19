<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/AdminMaster.Master"
    CodeBehind="Enrolment.aspx.cs"
    Inherits="College_Management_System.Enrolment" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .page-header {
            background: white;
            border-radius: 26px;
            padding: 28px 32px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
            border: 1px solid #eef2f7;
            margin-bottom: 30px;
        }

        .page-title {
            font-weight: 850;
            color: #0f172a;
            margin-bottom: 8px;
        }

        .page-subtitle {
            color: #64748b;
            margin-bottom: 0;
        }

        .section-card {
            background: white;
            border-radius: 26px;
            padding: 28px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
            border: 1px solid #eef2f7;
            margin-bottom: 30px;
        }

        .section-title {
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 6px;
        }

        .form-label {
            font-weight: 700;
            color: #334155;
            margin-bottom: 8px;
        }

        .form-control {
            border-radius: 14px;
            padding: 12px 14px;
            border: 1px solid #cbd5e1;
            box-shadow: none;
        }

        .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.12);
        }

        .btn {
            border-radius: 13px;
            padding: 10px 18px;
            font-weight: 700;
        }

        .default-password-note {
            background: #eff6ff;
            border-left: 5px solid #2563eb;
            border-radius: 14px;
            padding: 14px 16px;
            margin-bottom: 22px;
            color: #475569;
            font-size: 14px;
            font-weight: 600;
        }

        .status-badge {
            display: inline-block;
            padding: 7px 14px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 800;
            background: #dcfce7;
            color: #15803d;
        }

        .table {
            margin-bottom: 0;
            border-radius: 16px;
            overflow: hidden;
        }

        .table thead th {
            background: #0f172a;
            color: white;
            font-weight: 800;
            padding: 14px;
            vertical-align: middle;
        }

        .table tbody td {
            padding: 14px;
            color: #334155;
            vertical-align: middle;
        }

        .table-hover tbody tr:hover {
            background: #f8fafc;
        }

        .message-label {
            font-weight: 700;
        }

        body.dark-mode .page-header,
        body.dark-mode .section-card {
            background: #1e293b;
            border-color: #334155;
            color: #e2e8f0;
        }

        body.dark-mode .page-title,
        body.dark-mode .section-title {
            color: #f8fafc;
        }

        body.dark-mode .page-subtitle,
        body.dark-mode .text-muted {
            color: #94a3b8 !important;
        }

        body.dark-mode .form-label {
            color: #cbd5e1;
        }

        body.dark-mode .form-control {
            background: #0f172a;
            border-color: #334155;
            color: #f8fafc;
        }

        body.dark-mode .form-control::placeholder {
            color: #64748b;
        }

        body.dark-mode .default-password-note {
            background: #0f172a;
            color: #cbd5e1;
            border-left-color: #38bdf8;
        }

        body.dark-mode .table thead th {
            background: #020617;
            color: #f8fafc;
        }

        body.dark-mode .table tbody td {
            background: #1e293b;
            color: #e2e8f0;
            border-color: #334155;
        }

        body.dark-mode .table-hover tbody tr:hover td {
            background: #263449;
        }
    </style>

</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- PAGE HEADER -->
    <div class="page-header">
        <h2 class="page-title">
            <i class="fa-solid fa-user-plus me-2"></i>
            Student Enrolment
        </h2>

        <p class="page-subtitle">
            Register students into a programme and enrol them into a selected course.
        </p>
    </div>

    <!-- ENROLMENT FORM CARD -->
    <div class="section-card">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h4 class="section-title">Enrol New Student</h4>
                <p class="text-muted mb-0">
                    Enter student details, choose a programme, and select one course.
                </p>
            </div>
        </div>

        <div class="default-password-note">
            <i class="fa-solid fa-circle-info me-2"></i>
            New student accounts will use the default password:
            <strong>123456</strong>. Students can change it later from their profile page.
        </div>

        <div class="row">

            <!-- STUDENT NAME -->
            <div class="col-md-6 mb-3">
                <label class="form-label">Student Name</label>
                <asp:TextBox ID="txtName" runat="server"
                    CssClass="form-control"
                    Placeholder="Example: Ahmad Bin Ali"></asp:TextBox>
            </div>

            <!-- EMAIL -->
            <div class="col-md-6 mb-3">
                <label class="form-label">Email</label>
                <asp:TextBox ID="txtEmail" runat="server"
                    CssClass="form-control"
                    Placeholder="Example: student@gmail.com"></asp:TextBox>
            </div>

            <!-- PROGRAMME -->
            <div class="col-md-6 mb-3">
                <label class="form-label">Select Programme</label>

                <asp:DropDownList ID="ddlProgramme" runat="server"
                    CssClass="form-control"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="ddlProgramme_SelectedIndexChanged">
                </asp:DropDownList>
            </div>

            <!-- COURSE -->
            <div class="col-md-6 mb-3">
                <label class="form-label">Select Course</label>

                <asp:DropDownList ID="ddlCourse" runat="server"
                    CssClass="form-control">
                </asp:DropDownList>
            </div>

        </div>

        <div class="d-flex align-items-center gap-3 flex-wrap">
            <asp:Button ID="btnEnroll" runat="server"
                Text="Enrol Student"
                CssClass="btn btn-primary"
                OnClick="btnEnroll_Click" />

            <asp:Label ID="lblMsg" runat="server" CssClass="message-label"></asp:Label>
        </div>

    </div>

    <!-- ENROLMENT LIST CARD -->
    <div class="section-card">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h4 class="section-title mb-1">Enrolment List</h4>
                <p class="text-muted mb-0">
                    View all students and the courses they have enrolled in.
                </p>
            </div>

            <a href="Dashboard.aspx" class="btn btn-outline-secondary">
                Back to Dashboard
            </a>
        </div>

        <asp:GridView ID="gvEnrolment" runat="server"
            CssClass="table table-bordered table-hover align-middle"
            AutoGenerateColumns="False"
            GridLines="None"
            EmptyDataText="No enrolment records found.">

            <Columns>
                <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                <asp:BoundField DataField="Email" HeaderText="Email" />
                <asp:BoundField DataField="ProgrammeName" HeaderText="Programme" />
                <asp:BoundField DataField="CourseCode" HeaderText="Course Code" />
                <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                <asp:BoundField DataField="EnrolDate" HeaderText="Enrol Date" DataFormatString="{0:dd MMM yyyy}" />

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class="status-badge">
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>

        </asp:GridView>

    </div>

</asp:Content>