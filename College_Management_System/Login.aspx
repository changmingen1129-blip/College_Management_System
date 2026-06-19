<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="College_Management_System.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Login</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body {
            background: linear-gradient(135deg, #1e3a8a, #0f172a);
            font-family: "Segoe UI", Arial, sans-serif;
            min-height: 100vh;
        }

        .login-wrapper {
            min-height: 100vh;
        }

        .login-card {
            border: none;
            border-radius: 22px;
            overflow: hidden;
            box-shadow: 0 20px 45px rgba(0, 0, 0, 0.25);
        }

        .login-left {
            background: linear-gradient(135deg, #2563eb, #1e40af);
            color: white;
            padding: 45px;
        }

        .login-left h2 {
            font-weight: 700;
        }

        .login-left p {
            opacity: 0.9;
            line-height: 1.7;
        }

        .login-right {
            background-color: white;
            padding: 45px;
        }

        .login-title {
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

        .btn-login {
            border-radius: 10px;
            padding: 11px;
            font-weight: 600;
        }

        .system-badge {
            background-color: rgba(255, 255, 255, 0.18);
            padding: 8px 14px;
            border-radius: 20px;
            display: inline-block;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .small-note {
            font-size: 13px;
            color: #6b7280;
        }

        .forgot-link {
            font-size: 14px;
            color: #2563eb;
            font-weight: 500;
        }

        .forgot-link:hover {
            text-decoration: underline !important;
        }

        .portal-links {
            display: flex;
            justify-content: center;
            gap: 14px;
            flex-wrap: wrap;
            margin-top: 8px;
        }

        .student-link {
            font-size: 14px;
            color: #0f766e;
            font-weight: 600;
        }

        .student-link:hover {
            text-decoration: underline !important;
        }

        .lecturer-link {
            font-size: 14px;
            color: #7c3aed;
            font-weight: 600;
        }

        .lecturer-link:hover {
            text-decoration: underline !important;
        }

        .link-separator {
            color: #cbd5e1;
            font-size: 14px;
        }
    </style>
</head>

<body>

<form id="form1" runat="server">

    <div class="container login-wrapper d-flex justify-content-center align-items-center">

        <div class="row w-100 justify-content-center">

            <div class="col-lg-9 col-xl-8">

                <div class="card login-card">

                    <div class="row g-0">

                        <!-- LEFT SECTION -->
                        <div class="col-md-6 login-left d-flex flex-column justify-content-center">

                            <div class="system-badge">
                                Admin Portal
                            </div>

                            <h2>Student Management System</h2>

                            <p class="mt-3">
                                Manage programmes, courses, lecturers, student enrolments, course assignments, and class schedules in one secure admin dashboard.
                            </p>

                            <hr class="border-light opacity-50" />

                            <p class="mb-0">
                                Please sign in using your administrator account to continue.
                            </p>

                        </div>

                        <!-- RIGHT SECTION -->
                        <div class="col-md-6 login-right">

                            <h3 class="login-title mb-2">Welcome Back</h3>
                            <p class="text-muted mb-4">Login to access your admin dashboard.</p>

                            <div class="mb-3">
                                <label class="form-label">Email Address</label>
                                <asp:TextBox ID="txtEmail" runat="server"
                                    CssClass="form-control"
                                    Placeholder="Enter admin email"></asp:TextBox>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Password</label>
                                <asp:TextBox ID="txtPassword" runat="server"
                                    TextMode="Password"
                                    CssClass="form-control"
                                    Placeholder="Enter password"></asp:TextBox>
                            </div>

                            <asp:Button ID="btnLogin" runat="server"
                                Text="Login"
                                CssClass="btn btn-primary w-100 btn-login"
                                OnClick="btnLogin_Click" />

                            <!-- FORGOT PASSWORD LINK -->
                            <div class="text-end mt-2">
                                <a href="ForgotPassword.aspx" class="text-decoration-none forgot-link">
                                    Forgot password?
                                </a>
                            </div>

                            <asp:Label ID="lblMessage" runat="server"
                                CssClass="text-danger mt-3 d-block"></asp:Label>

                            <p class="small-note mt-4 mb-2 text-center">
                                Authorized admin access only.
                            </p>

                            <!-- OTHER PORTAL LOGIN LINKS -->
                            <div class="portal-links">
                                <a href="StudentLogin.aspx" class="text-decoration-none student-link">
                                    Student Login
                                </a>

                                <span class="link-separator">|</span>

                                <a href="LecturerLogin.aspx" class="text-decoration-none lecturer-link">
                                    Lecturer Login
                                </a>
                            </div>

                        </div>

                    </div>

                </div>

            </div>

        </div>

    </div>

</form>

</body>
</html>