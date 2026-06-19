<%@ Page Language="C#" AutoEventWireup="true"
MasterPageFile="~/StudentMaster.Master"
CodeBehind="StudentProfile.aspx.cs"
Inherits="College_Management_System.StudentProfile" %>

<asp:Content ID="HeadContent"
ContentPlaceHolderID="HeadContent"
runat="server">


<style>
    .profile-header {
        background: linear-gradient(135deg, #0f172a, #0f766e);
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
        border-color: #0f766e;
        box-shadow: 0 0 0 0.2rem rgba(15, 118, 110, 0.14);
    }

    .btn-save {
        padding: 11px 20px;
        border: none;
        border-radius: 13px;
        background: linear-gradient(135deg, #0f766e, #14b8a6);
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
</style>


</asp:Content>

<asp:Content ID="MainContent"
ContentPlaceHolderID="MainContent"
runat="server">


<div class="profile-header">
    <div class="row align-items-center">

        <div class="col-md-9">
            <h2>Student Profile</h2>
            <p>
                View your academic information and manage your account details.
            </p>
        </div>

        <div class="col-md-3 d-flex justify-content-md-end">
            <div class="profile-icon">
                <i class="fa-solid fa-user-graduate"></i>
            </div>
        </div>

    </div>
</div>

<div class="content-card">

    <h4 class="card-title-custom">Academic Information</h4>

    <p class="card-subtitle-custom">
        Your student and programme information.
    </p>

    <div class="row g-3">

        <div class="col-md-6">
            <div class="info-box">
                <div class="info-label">Student ID</div>

                <p class="info-value">
                    <asp:Label ID="lblStudentID"
                        runat="server"
                        Text="-">
                    </asp:Label>
                </p>
            </div>
        </div>

        <div class="col-md-6">
            <div class="info-box">
                <div class="info-label">Student Name</div>

                <p class="info-value">
                    <asp:Label ID="lblStudentName"
                        runat="server"
                        Text="-">
                    </asp:Label>
                </p>
            </div>
        </div>

        <div class="col-md-6">
            <div class="info-box">
                <div class="info-label">Programme</div>

                <p class="info-value">
                    <asp:Label ID="lblProgramme"
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

    </div>

</div>

<div class="content-card">

    <h4 class="card-title-custom">Update Email</h4>

    <p class="card-subtitle-custom">
        Enter a new email address and save your changes.
    </p>

    <div class="row g-3">

        <div class="col-md-8">
            <label class="form-label">New Email Address</label>

            <asp:TextBox ID="txtEmail"
                runat="server"
                CssClass="form-control"
                TextMode="Email"
                MaxLength="150"
                placeholder="Enter new email">
            </asp:TextBox>

            <asp:RequiredFieldValidator ID="rfvEmail"
                runat="server"
                ControlToValidate="txtEmail"
                ValidationGroup="UpdateEmail"
                ErrorMessage="Email address is required."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RequiredFieldValidator>

            <asp:RegularExpressionValidator ID="revEmail"
                runat="server"
                ControlToValidate="txtEmail"
                ValidationGroup="UpdateEmail"
                ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                ErrorMessage="Please enter a valid email address."
                ForeColor="#dc2626"
                Display="Dynamic">
            </asp:RegularExpressionValidator>
        </div>

        <div class="col-md-4 d-flex align-items-end">
            <asp:Button ID="btnUpdateEmail"
                runat="server"
                Text="Update Email"
                CssClass="btn btn-save w-100"
                ValidationGroup="UpdateEmail"
                OnClick="btnUpdateEmail_Click" />
        </div>

    </div>

    <asp:Label ID="lblEmailMessage"
        runat="server"
        Visible="false">
    </asp:Label>

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
