<%@ Page Language="C#" AutoEventWireup="true"
MasterPageFile="~/LecturerMaster.Master"
CodeBehind="LecturerProfile.aspx.cs"
Inherits="College_Management_System.LecturerProfile" %>

<asp:Content ID="HeadContent"
ContentPlaceHolderID="HeadContent"
runat="server">


<style>
    .profile-header {
        background: linear-gradient(135deg, #0f172a, #1d4ed8);
        color: white;
        border-radius: 24px;
        padding: 30px;
        margin-bottom: 28px;
        box-shadow: 0 12px 30px rgba(15, 23, 42, 0.15);
    }

    .profile-header h2 {
        margin-bottom: 7px;
        font-weight: 800;
    }

    .profile-header p {
        margin-bottom: 0;
        color: #dbeafe;
    }

    .profile-icon {
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

    .info-box {
        padding: 16px;
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
    }

    .info-value {
        margin-bottom: 0;
        color: #0f172a;
        font-size: 16px;
        font-weight: 750;
    }

    .form-label {
        margin-bottom: 8px;
        color: #334155;
        font-weight: 700;
    }

    .form-control {
        padding: 11px 13px;
        border: 1px solid #cbd5e1;
        border-radius: 13px;
    }

    .form-control:focus {
        border-color: #2563eb;
        box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.14);
    }

    .btn-save {
        padding: 11px 20px;
        border: none;
        border-radius: 13px;
        background: linear-gradient(135deg, #1d4ed8, #3b82f6);
        color: white;
        font-weight: 700;
    }

    .btn-password {
        padding: 11px 20px;
        border: none;
        border-radius: 13px;
        background: #1e293b;
        color: white;
        font-weight: 700;
    }

    .message-label {
        display: block;
        margin-top: 15px;
        padding: 11px 14px;
        border-radius: 12px;
        font-weight: 650;
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
</style>


</asp:Content>

<asp:Content ID="MainContent"
ContentPlaceHolderID="MainContent"
runat="server">


<div class="profile-header">
    <div class="row align-items-center">

        <div class="col-md-9">
            <h2>Lecturer Profile</h2>

            <p>
                View your profile, update contact details and manage your password.
            </p>
        </div>

        <div class="col-md-3 d-flex justify-content-md-end">
            <div class="profile-icon">
                <i class="fa-solid fa-chalkboard-user"></i>
            </div>
        </div>

    </div>
</div>

<div class="content-card">

    <h4 class="card-title-custom">Lecturer Information</h4>

    <p class="card-subtitle-custom">
        Your personal and staff information.
    </p>

    <div class="row g-3">

        <div class="col-md-6">
            <div class="info-box">
                <div class="info-label">Lecturer ID</div>

                <p class="info-value">
                    <asp:Label ID="lblLecturerID"
                        runat="server"
                        Text="-">
                    </asp:Label>
                </p>
            </div>
        </div>

        <div class="col-md-6">
            <div class="info-box">
                <div class="info-label">Lecturer Name</div>

                <p class="info-value">
                    <asp:Label ID="lblLecturerName"
                        runat="server"
                        Text="-">
                    </asp:Label>
                </p>
            </div>
        </div>

        <div class="col-md-6">
            <div class="info-box">
                <div class="info-label">Current Email</div>

                <p class="info-value">
                    <asp:Label ID="lblCurrentEmail"
                        runat="server"
                        Text="-">
                    </asp:Label>
                </p>
            </div>
        </div>

        <div class="col-md-6">
            <div class="info-box">
                <div class="info-label">Current Phone</div>

                <p class="info-value">
                    <asp:Label ID="lblCurrentPhone"
                        runat="server"
                        Text="-">
                    </asp:Label>
                </p>
            </div>
        </div>

    </div>

</div>

<div class="content-card">

    <h4 class="card-title-custom">Update Contact Information</h4>

    <p class="card-subtitle-custom">
        Update your email address and phone number.
    </p>

    <div class="row g-3">

        <div class="col-md-6">
            <label class="form-label">Email Address</label>

            <asp:TextBox ID="txtEmail"
                runat="server"
                CssClass="form-control"
                TextMode="Email"
                MaxLength="150"
                placeholder="Enter email address">
            </asp:TextBox>

            <asp:RequiredFieldValidator ID="rfvEmail"
                runat="server"
                ControlToValidate="txtEmail"
                ValidationGroup="UpdateProfile"
                ErrorMessage="Email address is required."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RequiredFieldValidator>

            <asp:RegularExpressionValidator ID="revEmail"
                runat="server"
                ControlToValidate="txtEmail"
                ValidationGroup="UpdateProfile"
                ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                ErrorMessage="Please enter a valid email address."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RegularExpressionValidator>
        </div>

        <div class="col-md-6">
            <label class="form-label">Phone Number</label>

            <asp:TextBox ID="txtPhone"
                runat="server"
                CssClass="form-control"
                MaxLength="30"
                placeholder="Enter phone number">
            </asp:TextBox>
        </div>

        <div class="col-12">
            <asp:Button ID="btnUpdateProfile"
                runat="server"
                Text="Update Contact Information"
                CssClass="btn btn-save"
                ValidationGroup="UpdateProfile"
                OnClick="btnUpdateProfile_Click" />
        </div>

    </div>

    <asp:Label ID="lblProfileMessage"
        runat="server"
        Visible="false">
    </asp:Label>

</div>

<div class="content-card">

    <h4 class="card-title-custom">Assigned Courses</h4>

    <p class="card-subtitle-custom">
        Courses currently assigned to your lecturer account.
    </p>

    <div class="table-responsive">

        <asp:GridView ID="gvAssignedCourses"
            runat="server"
            AutoGenerateColumns="False"
            GridLines="None"
            CssClass="table table-hover"
            EmptyDataText="No courses are currently assigned.">

            <Columns>

                <asp:TemplateField HeaderText="Course Code">
                    <ItemTemplate>
                        <span class="course-code-badge">
                            <%# Eval("CourseCode") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="CourseName"
                    HeaderText="Course Name" />

                <asp:BoundField DataField="CreditHours"
                    HeaderText="Credit Hours" />

                <asp:BoundField DataField="ProgrammeName"
                    HeaderText="Programme" />

            </Columns>

        </asp:GridView>

    </div>

</div>

<div class="content-card">

    <h4 class="card-title-custom">Change Password</h4>

    <p class="card-subtitle-custom">
        Enter your current password before setting a new password.
    </p>

    <div class="row g-3">

        <div class="col-md-4">
            <label class="form-label">Current Password</label>

            <asp:TextBox ID="txtCurrentPassword"
                runat="server"
                CssClass="form-control"
                TextMode="Password"
                placeholder="Current password">
            </asp:TextBox>
        </div>

        <div class="col-md-4">
            <label class="form-label">New Password</label>

            <asp:TextBox ID="txtNewPassword"
                runat="server"
                CssClass="form-control"
                TextMode="Password"
                placeholder="New password">
            </asp:TextBox>
        </div>

        <div class="col-md-4">
            <label class="form-label">Confirm New Password</label>

            <asp:TextBox ID="txtConfirmPassword"
                runat="server"
                CssClass="form-control"
                TextMode="Password"
                placeholder="Confirm password">
            </asp:TextBox>
        </div>

        <div class="col-12">
            <asp:Button ID="btnChangePassword"
                runat="server"
                Text="Change Password"
                CssClass="btn btn-password"
                CausesValidation="false"
                OnClick="btnChangePassword_Click" />
        </div>

    </div>

    <asp:Label ID="lblPasswordMessage"
        runat="server"
        Visible="false">
    </asp:Label>

</div>


</asp:Content>
