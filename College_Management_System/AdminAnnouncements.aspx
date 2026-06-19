<%@ Page Language="C#" AutoEventWireup="true"
MasterPageFile="~/AdminMaster.Master"
CodeBehind="AdminAnnouncements.aspx.cs"
Inherits="College_Management_System.AdminAnnouncements" %>

<asp:Content ID="HeadContent"
ContentPlaceHolderID="HeadContent"
runat="server">


<style>
    .announcement-header {
        background: linear-gradient(135deg, #0f172a, #7c3aed);
        color: white;
        border-radius: 24px;
        padding: 30px;
        margin-bottom: 28px;
        box-shadow: 0 12px 30px rgba(15, 23, 42, 0.15);
    }

    .announcement-header h2 {
        margin-bottom: 7px;
        font-weight: 800;
    }

    .announcement-header p {
        margin-bottom: 0;
        color: #ede9fe;
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
        border-color: #7c3aed;
        box-shadow: 0 0 0 0.2rem rgba(124, 58, 237, 0.14);
    }

    .btn-publish {
        padding: 11px 20px;
        border: none;
        border-radius: 13px;
        background: linear-gradient(135deg, #7c3aed, #8b5cf6);
        color: white;
        font-weight: 700;
    }

    .btn-clear {
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

    .audience-badge {
        display: inline-block;
        min-width: 85px;
        padding: 7px 12px;
        border-radius: 999px;
        font-size: 13px;
        font-weight: 800;
        text-align: center;
    }

    .audience-all {
        background: #dbeafe;
        color: #1d4ed8;
    }

    .audience-students {
        background: #dcfce7;
        color: #15803d;
    }

    .audience-lecturers {
        background: #fef3c7;
        color: #b45309;
    }

    .audience-course {
        background: #ede9fe;
        color: #6d28d9;
    }

    .status-badge {
        display: inline-block;
        min-width: 82px;
        padding: 7px 12px;
        border-radius: 999px;
        font-size: 13px;
        font-weight: 800;
        text-align: center;
    }

    .status-active {
        background: #dcfce7;
        color: #15803d;
    }

    .status-inactive {
        background: #fee2e2;
        color: #b91c1c;
    }

    .action-button {
        border: none;
        border-radius: 10px;
        padding: 7px 12px;
        margin-right: 6px;
        font-size: 13px;
        font-weight: 700;
    }

    .btn-toggle {
        background: #dbeafe;
        color: #1d4ed8;
    }

    .btn-delete {
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

    .announcement-message {
        max-width: 360px;
        white-space: normal;
        line-height: 1.5;
    }
</style>


</asp:Content>

<asp:Content ID="MainContent"
ContentPlaceHolderID="MainContent"
runat="server">


<div class="announcement-header">

    <div class="row align-items-center">

        <div class="col-md-9">

            <h2>Announcements Management</h2>

            <p>
                Publish announcements for all users, students, lecturers or specific courses.
            </p>

        </div>

        <div class="col-md-3 d-flex justify-content-md-end">

            <div class="header-icon">
                <i class="fa-solid fa-bullhorn"></i>
            </div>

        </div>

    </div>

</div>

<div class="content-card">

    <h4 class="card-title-custom">Create Announcement</h4>

    <p class="card-subtitle-custom">
        Enter the announcement details and choose the intended audience.
    </p>

    <div class="row g-3">

        <div class="col-md-8">

            <label class="form-label">Announcement Title</label>

            <asp:TextBox ID="txtTitle"
                runat="server"
                CssClass="form-control"
                MaxLength="150"
                placeholder="Enter announcement title">
            </asp:TextBox>

            <asp:RequiredFieldValidator ID="rfvTitle"
                runat="server"
                ControlToValidate="txtTitle"
                ValidationGroup="PublishAnnouncement"
                ErrorMessage="Announcement title is required."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RequiredFieldValidator>

        </div>

        <div class="col-md-4">

            <label class="form-label">Audience</label>

            <asp:DropDownList ID="ddlAudience"
                runat="server"
                CssClass="form-select"
                AutoPostBack="true"
                OnSelectedIndexChanged="ddlAudience_SelectedIndexChanged">

                <asp:ListItem Text="All Users" Value="All"></asp:ListItem>
                <asp:ListItem Text="Students Only" Value="Students"></asp:ListItem>
                <asp:ListItem Text="Lecturers Only" Value="Lecturers"></asp:ListItem>
                <asp:ListItem Text="Specific Course" Value="Course"></asp:ListItem>

            </asp:DropDownList>

        </div>

        <div class="col-12">

            <label class="form-label">Announcement Message</label>

            <asp:TextBox ID="txtMessage"
                runat="server"
                CssClass="form-control"
                TextMode="MultiLine"
                Rows="6"
                MaxLength="1000"
                placeholder="Enter announcement message">
            </asp:TextBox>

            <asp:RequiredFieldValidator ID="rfvMessage"
                runat="server"
                ControlToValidate="txtMessage"
                ValidationGroup="PublishAnnouncement"
                ErrorMessage="Announcement message is required."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RequiredFieldValidator>

        </div>

        <div class="col-md-6">

            <asp:Panel ID="pnlCourse"
                runat="server"
                Visible="false">

                <label class="form-label">Select Course</label>

                <asp:DropDownList ID="ddlCourse"
                    runat="server"
                    CssClass="form-select">
                </asp:DropDownList>

            </asp:Panel>

        </div>

        <div class="col-md-3">

            <label class="form-label">Expiry Date</label>

            <asp:TextBox ID="txtExpiryDate"
                runat="server"
                CssClass="form-control"
                TextMode="Date">
            </asp:TextBox>

        </div>

        <div class="col-md-3">

            <label class="form-label">Status</label>

            <asp:DropDownList ID="ddlStatus"
                runat="server"
                CssClass="form-select">

                <asp:ListItem Text="Active" Value="1"></asp:ListItem>
                <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>

            </asp:DropDownList>

        </div>

        <div class="col-12">

            <asp:Button ID="btnPublish"
                runat="server"
                Text="Publish Announcement"
                CssClass="btn btn-publish"
                ValidationGroup="PublishAnnouncement"
                OnClick="btnPublish_Click" />

            <asp:Button ID="btnClear"
                runat="server"
                Text="Clear Form"
                CssClass="btn btn-clear ms-2"
                CausesValidation="false"
                OnClick="btnClear_Click" />

        </div>

    </div>

    <asp:Label ID="lblMessage"
        runat="server"
        Visible="false">
    </asp:Label>

</div>

<div class="content-card">

    <h4 class="card-title-custom">Published Announcements</h4>

    <p class="card-subtitle-custom">
        Review, activate, deactivate or delete existing announcements.
    </p>

    <div class="table-responsive">

        <asp:GridView ID="gvAnnouncements"
            runat="server"
            AutoGenerateColumns="False"
            GridLines="None"
            CssClass="table table-hover"
            EmptyDataText="No announcements have been published."
            OnRowCommand="gvAnnouncements_RowCommand"
            DataKeyNames="AnnouncementID">

            <Columns>

                <asp:BoundField DataField="AnnouncementID"
                    HeaderText="ID" />

                <asp:TemplateField HeaderText="Announcement">

                    <ItemTemplate>

                        <div class="fw-bold text-dark">
                            <%# Eval("Title") %>
                        </div>

                        <div class="announcement-message mt-2">
                            <%# Eval("Message") %>
                        </div>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:TemplateField HeaderText="Audience">

                    <ItemTemplate>

                        <span class='<%# GetAudienceClass(Eval("Audience").ToString()) %>'>
                            <%# GetAudienceText(Eval("Audience").ToString()) %>
                        </span>

                        <div class="mt-2">
                            <%# Eval("CourseDisplay") %>
                        </div>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:BoundField DataField="CreatedByRole"
                    HeaderText="Created By" />

                <asp:BoundField DataField="CreatedAt"
                    HeaderText="Created Date"
                    DataFormatString="{0:dd MMM yyyy HH:mm}" />

                <asp:BoundField DataField="ExpiryDate"
                    HeaderText="Expiry Date"
                    DataFormatString="{0:dd MMM yyyy}"
                    NullDisplayText="No Expiry" />

                <asp:TemplateField HeaderText="Status">

                    <ItemTemplate>

                        <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "status-badge status-active" : "status-badge status-inactive" %>'>
                            <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                        </span>

                    </ItemTemplate>

                </asp:TemplateField>

                <asp:TemplateField HeaderText="Actions">

                    <ItemTemplate>

                        <asp:Button ID="btnToggle"
                            runat="server"
                            Text='<%# Convert.ToBoolean(Eval("IsActive")) ? "Deactivate" : "Activate" %>'
                            CssClass="action-button btn-toggle"
                            CommandName="ToggleStatus"
                            CommandArgument='<%# Eval("AnnouncementID") %>'
                            CausesValidation="false" />

                        <asp:Button ID="btnDelete"
                            runat="server"
                            Text="Delete"
                            CssClass="action-button btn-delete"
                            CommandName="DeleteAnnouncement"
                            CommandArgument='<%# Eval("AnnouncementID") %>'
                            CausesValidation="false"
                            OnClientClick="return confirm('Are you sure you want to delete this announcement?');" />

                    </ItemTemplate>

                </asp:TemplateField>

            </Columns>

        </asp:GridView>

    </div>

</div>


</asp:Content>
