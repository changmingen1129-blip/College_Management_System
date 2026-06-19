<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/AdminMaster.Master"
    CodeBehind="RegisterLecturer.aspx.cs"
    Inherits="College_Management_System.RegisterLecturer" %>

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
            <i class="fa-solid fa-chalkboard-user me-2"></i>
            Register Lecturer
        </h2>

        <p class="page-subtitle">
            Add lecturer details into the system and manage lecturer login accounts.
        </p>
    </div>

    <!-- REGISTER LECTURER FORM CARD -->
    <div class="section-card">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h4 class="section-title">Add New Lecturer</h4>
                <p class="text-muted mb-0">
                    New lecturer accounts will be created with a default password.
                </p>
            </div>
        </div>

        <div class="note-box">
            <i class="fa-solid fa-circle-info me-2"></i>
            Default lecturer login password is <strong>123456</strong>. The lecturer can use this password to log in to the Lecturer Portal later.
        </div>

        <div class="row">

            <div class="col-md-4 mb-3">
                <label class="form-label">Lecturer Name</label>
                <asp:TextBox ID="txtName" runat="server"
                    CssClass="form-control"
                    Placeholder="Example: Mr Tan"></asp:TextBox>
            </div>

            <div class="col-md-4 mb-3">
                <label class="form-label">Email</label>
                <asp:TextBox ID="txtEmail" runat="server"
                    CssClass="form-control"
                    Placeholder="Example: lecturer@gmail.com"></asp:TextBox>
            </div>

            <div class="col-md-4 mb-3">
                <label class="form-label">Phone</label>
                <asp:TextBox ID="txtPhone" runat="server"
                    CssClass="form-control"
                    Placeholder="Example: 0123456789"></asp:TextBox>
            </div>

        </div>

        <div class="d-flex align-items-center gap-3 flex-wrap">
            <asp:Button ID="btnSave" runat="server"
                Text="Register Lecturer"
                CssClass="btn btn-primary"
                OnClick="btnSave_Click" />

            <asp:Label ID="lblMsg" runat="server" CssClass="message-label"></asp:Label>
        </div>

    </div>

    <!-- LECTURER LIST CARD -->
    <div class="section-card">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h4 class="section-title mb-1">Lecturer List</h4>
                <p class="text-muted mb-0">
                    View, update, or delete lecturers registered in the system.
                </p>
            </div>

            <a href="Dashboard.aspx" class="btn btn-outline-secondary">
                Back to Dashboard
            </a>
        </div>

        <asp:GridView ID="gvLecturer" runat="server"
            CssClass="table table-bordered table-hover align-middle"
            AutoGenerateColumns="False"
            GridLines="None"
            DataKeyNames="LecturerID"
            EmptyDataText="No lecturer records found."
            OnRowEditing="gvLecturer_RowEditing"
            OnRowUpdating="gvLecturer_RowUpdating"
            OnRowCancelingEdit="gvLecturer_RowCancelingEdit"
            OnRowDeleting="gvLecturer_RowDeleting">

            <Columns>

                <asp:BoundField DataField="LecturerID" HeaderText="ID" ReadOnly="True" />

                <asp:BoundField DataField="LecturerName" HeaderText="Lecturer Name" />

                <asp:BoundField DataField="Email" HeaderText="Email" />

                <asp:BoundField DataField="Phone" HeaderText="Phone" />

                <asp:TemplateField HeaderText="Password">
                    <ItemTemplate>
                        <span class="password-badge">
                            <%# Eval("Password") %>
                        </span>
                    </ItemTemplate>

                    <EditItemTemplate>
                        <asp:TextBox ID="txtEditPassword" runat="server"
                            Text='<%# Bind("Password") %>'
                            CssClass="form-control"></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Action">

                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server"
                            CommandName="Edit"
                            Text="Edit"
                            CssClass="btn btn-warning btn-sm me-2" />

                        <asp:LinkButton ID="btnDelete" runat="server"
                            CommandName="Delete"
                            Text="Delete"
                            CssClass="btn btn-danger btn-sm"
                            OnClientClick="return confirm('Are you sure you want to delete this lecturer?');" />
                    </ItemTemplate>

                    <EditItemTemplate>
                        <asp:LinkButton ID="btnUpdate" runat="server"
                            CommandName="Update"
                            Text="Update"
                            CssClass="btn btn-success btn-sm me-2" />

                        <asp:LinkButton ID="btnCancel" runat="server"
                            CommandName="Cancel"
                            Text="Cancel"
                            CssClass="btn btn-secondary btn-sm" />
                    </EditItemTemplate>

                </asp:TemplateField>

            </Columns>

        </asp:GridView>

    </div>

</asp:Content>