<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/AdminMaster.Master"
    CodeBehind="ManageStudent.aspx.cs"
    Inherits="College_Management_System.ManageStudent" %>

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

        .note-box {
            background: #eff6ff;
            border-left: 5px solid #2563eb;
            border-radius: 14px;
            padding: 14px 16px;
            margin-bottom: 22px;
            color: #475569;
            font-size: 14px;
            font-weight: 600;
        }

        .student-badge {
            display: inline-block;
            padding: 7px 14px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 800;
            background: #dcfce7;
            color: #15803d;
        }

        .password-badge {
            display: inline-block;
            padding: 7px 14px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 800;
            background: #e0f2fe;
            color: #0369a1;
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

        body.dark-mode .note-box {
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
            <i class="fa-solid fa-users me-2"></i>
            Manage Students
        </h2>

        <p class="page-subtitle">
            Add, update, search, reset password, and manage student accounts.
        </p>
    </div>

    <!-- STUDENT FORM -->
    <div class="section-card">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h4 class="section-title">Student Account Form</h4>
                <p class="text-muted mb-0">
                    Use this form to add a new student or update existing student details.
                </p>
            </div>
        </div>

        <div class="note-box">
            <i class="fa-solid fa-circle-info me-2"></i>
            Default password can be set as <strong>123456</strong>. Students can change their password later from the student profile page.
        </div>

        <asp:HiddenField ID="hfStudentID" runat="server" Value="0" />

        <div class="row">

            <div class="col-md-6 mb-3">
                <label class="form-label">Student Name</label>
                <asp:TextBox ID="txtStudentName" runat="server"
                    CssClass="form-control"
                    Placeholder="Example: Ahmad Bin Ali"></asp:TextBox>
            </div>

            <div class="col-md-6 mb-3">
                <label class="form-label">Email</label>
                <asp:TextBox ID="txtEmail" runat="server"
                    CssClass="form-control"
                    Placeholder="Example: student@gmail.com"></asp:TextBox>
            </div>

            <div class="col-md-6 mb-3">
                <label class="form-label">Password</label>
                <asp:TextBox ID="txtPassword" runat="server"
                    CssClass="form-control"
                    Placeholder="Example: 123456"></asp:TextBox>
            </div>

            <div class="col-md-6 mb-3">
                <label class="form-label">Programme</label>
                <asp:DropDownList ID="ddlProgramme" runat="server"
                    CssClass="form-control">
                </asp:DropDownList>
            </div>

        </div>

        <div class="d-flex align-items-center gap-3 flex-wrap">
            <asp:Button ID="btnSave" runat="server"
                Text="Save Student"
                CssClass="btn btn-primary"
                OnClick="btnSave_Click" />

            <asp:Button ID="btnClear" runat="server"
                Text="Clear"
                CssClass="btn btn-outline-secondary"
                OnClick="btnClear_Click" />

            <asp:Label ID="lblMsg" runat="server" CssClass="message-label"></asp:Label>
        </div>

    </div>

    <!-- STUDENT LIST -->
    <div class="section-card">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h4 class="section-title mb-1">Student List</h4>
                <p class="text-muted mb-0">
                    View and manage all registered students.
                </p>
            </div>

            <a href="Dashboard.aspx" class="btn btn-outline-secondary">
                Back to Dashboard
            </a>
        </div>

        <!-- SEARCH -->
        <div class="row mb-3">
            <div class="col-md-8 mb-2">
                <asp:TextBox ID="txtSearch" runat="server"
                    CssClass="form-control"
                    Placeholder="Search by student name or email..."></asp:TextBox>
            </div>

            <div class="col-md-4 d-flex gap-2 mb-2">
                <asp:Button ID="btnSearch" runat="server"
                    Text="Search"
                    CssClass="btn btn-dark"
                    OnClick="btnSearch_Click" />

                <asp:Button ID="btnShowAll" runat="server"
                    Text="Show All"
                    CssClass="btn btn-outline-dark"
                    OnClick="btnShowAll_Click" />
            </div>
        </div>

        <asp:GridView ID="gvStudents" runat="server"
            CssClass="table table-bordered table-hover align-middle"
            AutoGenerateColumns="False"
            GridLines="None"
            DataKeyNames="StudentID"
            EmptyDataText="No students found."
            OnRowCommand="gvStudents_RowCommand">

            <Columns>
                <asp:BoundField DataField="StudentID" HeaderText="ID" />
                <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                <asp:BoundField DataField="Email" HeaderText="Email" />
                <asp:BoundField DataField="ProgrammeName" HeaderText="Programme" />
                <asp:BoundField DataField="ProgrammeCode" HeaderText="Code" />

                <asp:TemplateField HeaderText="Password">
                    <ItemTemplate>
                        <span class="password-badge">
                            <%# Eval("Password") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class="student-badge">
                            Active
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:Button ID="btnEdit" runat="server"
                            Text="Edit"
                            CssClass="btn btn-sm btn-warning me-1"
                            CommandName="EditStudent"
                            CommandArgument='<%# Eval("StudentID") %>' />

                        <asp:Button ID="btnReset" runat="server"
                            Text="Reset Password"
                            CssClass="btn btn-sm btn-info me-1"
                            CommandName="ResetPassword"
                            CommandArgument='<%# Eval("StudentID") %>'
                            OnClientClick="return confirm('Reset this student password to 123456?');" />

                        <asp:Button ID="btnDelete" runat="server"
                            Text="Delete"
                            CssClass="btn btn-sm btn-danger"
                            CommandName="DeleteStudent"
                            CommandArgument='<%# Eval("StudentID") %>'
                            OnClientClick="return confirm('Are you sure you want to delete this student?');" />
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

        </asp:GridView>

    </div>

</asp:Content>