<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/AdminMaster.Master"
    CodeBehind="AssignCourse.aspx.cs"
    Inherits="College_Management_System.AssignCourse" %>

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

        .message-label {
            font-weight: 700;
        }

        .assignment-note {
            background: #ecfdf5;
            border-left: 5px solid #16a34a;
            border-radius: 14px;
            padding: 14px 16px;
            margin-bottom: 22px;
            color: #166534;
            font-size: 14px;
            font-weight: 600;
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

        body.dark-mode .assignment-note {
            background: #0f172a;
            color: #bbf7d0;
            border-left-color: #22c55e;
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
            <i class="fa-solid fa-link me-2"></i>
            Assign Course to Lecturer
        </h2>

        <p class="page-subtitle">
            Assign registered lecturers to available courses and view all teaching assignments.
        </p>
    </div>

    <!-- ASSIGN COURSE FORM CARD -->
    <div class="section-card">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h4 class="section-title">New Course Assignment</h4>
                <p class="text-muted mb-0">
                    Select one lecturer and one course to create a teaching assignment.
                </p>
            </div>
        </div>

        <div class="assignment-note">
            <i class="fa-solid fa-circle-info me-2"></i>
            After assigning a course, the lecturer can view the course from the Lecturer Portal.
        </div>

        <div class="row">

            <div class="col-md-6 mb-3">
                <label class="form-label">Select Lecturer</label>
                <asp:DropDownList ID="ddlLecturer" runat="server"
                    CssClass="form-control">
                </asp:DropDownList>
            </div>

            <div class="col-md-6 mb-3">
                <label class="form-label">Select Course</label>
                <asp:DropDownList ID="ddlCourse" runat="server"
                    CssClass="form-control">
                </asp:DropDownList>
            </div>

        </div>

        <div class="d-flex align-items-center gap-3 flex-wrap">
            <asp:Button ID="btnAssign" runat="server"
                Text="Assign Course"
                CssClass="btn btn-success"
                OnClick="btnAssign_Click" />

            <asp:Label ID="lblMsg" runat="server" CssClass="message-label"></asp:Label>
        </div>

    </div>

    <!-- ASSIGNED COURSE LIST CARD -->
    <div class="section-card">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h4 class="section-title mb-1">Assigned Course List</h4>
                <p class="text-muted mb-0">
                    View lecturers and their assigned courses.
                </p>
            </div>

            <a href="Dashboard.aspx" class="btn btn-outline-secondary">
                Back to Dashboard
            </a>
        </div>

        <asp:GridView ID="gvAssign" runat="server"
            CssClass="table table-bordered table-striped table-hover align-middle"
            AutoGenerateColumns="true">
        </asp:GridView>

    </div>

</asp:Content>