<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentRegister.aspx.cs" Inherits="College_Management_System.StudentRegister" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Student Register</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="SiteStyle.css" rel="stylesheet" />
</head>

<body>

<form id="form1" runat="server">

<div class="container d-flex justify-content-center align-items-center" style="min-height:100vh;">

    <div class="card shadow p-4" style="width: 520px; border-radius: 18px;">

        <h3 class="text-center mb-3">Student Registration</h3>
        <p class="text-muted text-center mb-4">Create your student account to enrol courses.</p>

        <div class="mb-3">
            <label class="form-label">Student Name</label>
            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" Placeholder="Enter your full name"></asp:TextBox>
        </div>

        <div class="mb-3">
            <label class="form-label">Email</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" Placeholder="Enter your email"></asp:TextBox>
        </div>

        <div class="mb-3">
            <label class="form-label">Password</label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" Placeholder="Enter password"></asp:TextBox>
        </div>

        <div class="mb-3">
            <label class="form-label">Confirm Password</label>
            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" Placeholder="Confirm password"></asp:TextBox>
        </div>

        <div class="mb-3">
            <label class="form-label">Programme</label>
            <asp:DropDownList ID="ddlProgramme" runat="server" CssClass="form-control"></asp:DropDownList>
        </div>

        <asp:Button ID="btnRegister" runat="server"
            Text="Register"
            CssClass="btn btn-primary w-100"
            OnClick="btnRegister_Click" />

        <asp:Label ID="lblMsg" runat="server" CssClass="mt-3 d-block text-center"></asp:Label>

        <div class="text-center mt-3">
            <a href="StudentLogin.aspx" class="text-decoration-none">Already have an account? Login</a>
        </div>

        <div class="text-center mt-2">
            <a href="Login.aspx" class="text-decoration-none">Admin Login</a>
        </div>

    </div>

</div>

</form>

</body>
</html>