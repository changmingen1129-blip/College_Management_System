<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="College_Management_System.ForgotPassword" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Forgot Password</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body {
            background: linear-gradient(135deg, #1e3a8a, #0f172a);
            font-family: "Segoe UI", Arial, sans-serif;
            min-height: 100vh;
        }

        .reset-wrapper {
            min-height: 100vh;
        }

        .reset-card {
            border: none;
            border-radius: 22px;
            box-shadow: 0 20px 45px rgba(0, 0, 0, 0.25);
        }

        .reset-title {
            font-weight: 700;
            color: #1f2937;
        }

        .form-label {
            font-weight: 600;
            color: #374151;
        }

        .form-control {
            border-radius: 10px;
            padding: 11px 14px;
        }

        .btn-reset {
            border-radius: 10px;
            padding: 11px;
            font-weight: 600;
        }
    </style>
</head>

<body>

<form id="form1" runat="server">

    <div class="container reset-wrapper d-flex justify-content-center align-items-center">

        <div class="col-md-5">

            <div class="card reset-card p-4">

                <h3 class="reset-title mb-2 text-center">Reset Password</h3>

                <p class="text-muted text-center mb-4">
                    Enter your registered admin email and create a new password.
                </p>

                <div class="mb-3">
                    <label class="form-label">Admin Email</label>
                    <asp:TextBox ID="txtEmail" runat="server"
                        CssClass="form-control"
                        Placeholder="Enter admin email"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <label class="form-label">New Password</label>
                    <asp:TextBox ID="txtNewPassword" runat="server"
                        TextMode="Password"
                        CssClass="form-control"
                        Placeholder="Enter new password"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <label class="form-label">Confirm New Password</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server"
                        TextMode="Password"
                        CssClass="form-control"
                        Placeholder="Confirm new password"></asp:TextBox>
                </div>

                <asp:Button ID="btnReset" runat="server"
                    Text="Reset Password"
                    CssClass="btn btn-primary w-100 btn-reset"
                    OnClick="btnReset_Click" />

                <asp:Label ID="lblMessage" runat="server"
                    CssClass="mt-3 d-block text-center"></asp:Label>

                <div class="text-center mt-3">
                    <a href="Login.aspx" class="text-decoration-none">
                        Back to Login
                    </a>
                </div>

            </div>

        </div>

    </div>

</form>

</body>
</html>