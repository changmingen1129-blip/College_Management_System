<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/AdminMaster.Master"
    CodeBehind="Course.aspx.cs"
    Inherits="College_Management_System.Course" %>

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
            margin-bottom: 22px;
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
            <i class="fa-solid fa-book-open me-2"></i>
            Manage Courses
        </h2>

        <p class="page-subtitle">
            Create, update, and manage courses under each programme.
        </p>
    </div>

    <!-- COURSE FORM CARD -->
    <div class="section-card">

        <h4 class="section-title">Add New Course</h4>

        <div class="row">

            <div class="col-md-6 mb-3">
                <label class="form-label">Course Name</label>
                <asp:TextBox ID="txtName" runat="server"
                    CssClass="form-control"
                    Placeholder="Example: Web Development"></asp:TextBox>
            </div>

            <div class="col-md-6 mb-3">
                <label class="form-label">Course Code</label>
                <asp:TextBox ID="txtCode" runat="server"
                    CssClass="form-control"
                    Placeholder="Example: WEB101"></asp:TextBox>
            </div>

            <div class="col-md-6 mb-3">
                <label class="form-label">Credit Hours</label>
                <asp:TextBox ID="txtCredit" runat="server"
                    CssClass="form-control"
                    Placeholder="Example: 3"></asp:TextBox>
            </div>

            <div class="col-md-6 mb-3">
                <label class="form-label">Select Programme</label>
                <asp:DropDownList ID="ddlProgramme" runat="server"
                    CssClass="form-control"></asp:DropDownList>
            </div>

        </div>

        <asp:Button ID="btnSave" runat="server"
            Text="Save Course"
            CssClass="btn btn-primary"
            OnClick="btnSave_Click" />

        <asp:Label ID="lblMsg" runat="server" CssClass="ms-3 message-label"></asp:Label>

    </div>

    <!-- COURSE LIST CARD -->
    <div class="section-card">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h4 class="section-title mb-1">Course List</h4>
                <p class="text-muted mb-0">
                    All courses registered in the system.
                </p>
            </div>
        </div>

        <asp:GridView ID="gvCourse" runat="server"
            CssClass="table table-bordered table-hover align-middle"
            AutoGenerateColumns="False"
            DataKeyNames="CourseID"
            OnRowEditing="gvCourse_RowEditing"
            OnRowUpdating="gvCourse_RowUpdating"
            OnRowCancelingEdit="gvCourse_RowCancelingEdit">

            <Columns>

                <asp:BoundField DataField="CourseID" HeaderText="ID" ReadOnly="True" />

                <asp:BoundField DataField="CourseName" HeaderText="Course Name" />

                <asp:BoundField DataField="CourseCode" HeaderText="Course Code" />

                <asp:BoundField DataField="CreditHours" HeaderText="Credit Hours" />

                <asp:BoundField DataField="ProgrammeName" HeaderText="Programme" ReadOnly="True" />

                <asp:TemplateField HeaderText="Action">

                    <ItemTemplate>
                        <asp:LinkButton runat="server"
                            CommandName="Edit"
                            Text="Edit"
                            CssClass="btn btn-warning btn-sm me-2" />
                    </ItemTemplate>

                    <EditItemTemplate>
                        <asp:LinkButton runat="server"
                            CommandName="Update"
                            Text="Update"
                            CssClass="btn btn-success btn-sm me-2" />

                        <asp:LinkButton runat="server"
                            CommandName="Cancel"
                            Text="Cancel"
                            CssClass="btn btn-secondary btn-sm" />
                    </EditItemTemplate>

                </asp:TemplateField>

            </Columns>

        </asp:GridView>

    </div>

</asp:Content>