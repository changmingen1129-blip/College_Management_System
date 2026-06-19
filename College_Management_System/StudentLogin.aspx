<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentLogin.aspx.cs" Inherits="College_Management_System.StudentLogin" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Student Login</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body {
            min-height: 100vh;
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background: linear-gradient(135deg, #0f766e, #0f172a);
        }

        .login-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 30px;
        }

        .login-container {
            width: 100%;
            max-width: 980px;
            background: #ffffff;
            border-radius: 26px;
            overflow: hidden;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.28);
        }

        .left-panel {
            background: linear-gradient(135deg, #0f766e, #115e59);
            color: #ffffff;
            padding: 55px 45px;
            min-height: 520px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .left-panel::before {
            content: "";
            position: absolute;
            width: 260px;
            height: 260px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.12);
            top: -80px;
            right: -80px;
        }

        .left-panel::after {
            content: "";
            position: absolute;
            width: 160px;
            height: 160px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.10);
            bottom: -50px;
            left: -40px;
        }

        .brand-badge {
            display: inline-block;
            width: fit-content;
            background: rgba(255, 255, 255, 0.18);
            padding: 8px 16px;
            border-radius: 30px;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 22px;
            position: relative;
            z-index: 1;
        }

        .left-panel h1 {
            font-weight: 750;
            font-size: 36px;
            line-height: 1.2;
            margin-bottom: 18px;
            position: relative;
            z-index: 1;
        }

        .left-panel p {
            font-size: 16px;
            line-height: 1.8;
            opacity: 0.92;
            position: relative;
            z-index: 1;
        }

        .feature-list {
            margin-top: 28px;
            position: relative;
            z-index: 1;
        }

        .feature-item {
            display: flex;
            align-items: center;
            margin-bottom: 14px;
            font-size: 15px;
        }

        .feature-icon {
            width: 32px;
            height: 32px;
            background: rgba(255, 255, 255, 0.18);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
        }

        .right-panel {
            padding: 55px 45px;
            min-height: 520px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-title {
            font-weight: 750;
            color: #111827;
            margin-bottom: 8px;
        }

        .login-subtitle {
            color: #6b7280;
            margin-bottom: 30px;
        }

        .form-label {
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }

        .form-control {
            border-radius: 12px;
            padding: 12px 15px;
            border: 1px solid #d1d5db;
            font-size: 15px;
        }

        .form-control:focus {
            border-color: #0f766e;
            box-shadow: 0 0 0 0.2rem rgba(15, 118, 110, 0.18);
        }

        .btn-login {
            border-radius: 12px;
            padding: 12px;
            font-weight: 700;
            background-color: #0f766e;
            border: none;
            transition: 0.2s ease;
        }

        .btn-login:hover {
            background-color: #115e59;
            transform: translateY(-1px);
        }

        .link-area a {
            font-size: 14px;
            font-weight: 600;
            color: #0f766e;
        }

        .link-area a:hover {
            text-decoration: underline !important;
        }

        .portal-links {
            display: flex;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 8px;
        }

        .admin-link {
            color: #2563eb !important;
        }

        .lecturer-link {
            color: #7c3aed !important;
        }

        .link-separator {
            color: #cbd5e1;
            font-size: 14px;
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 24px 0 18px;
            color: #9ca3af;
            font-size: 13px;
        }

        .divider::before,
        .divider::after {
            content: "";
            flex: 1;
            height: 1px;
            background: #e5e7eb;
        }

        .divider span {
            padding: 0 12px;
        }

        .system-footer {
            font-size: 13px;
            color: #9ca3af;
            text-align: center;
            margin-top: 24px;
        }

        @media (max-width: 768px) {
            .left-panel {
                min-height: auto;
                padding: 35px 30px;
            }

            .right-panel {
                min-height: auto;
                padding: 35px 30px;
            }

            .left-panel h1 {
                font-size: 30px;
            }
        }
    </style>
</head>

<body>

<form id="form1" runat="server">

    <div class="login-wrapper">

        <div class="login-container">

            <div class="row g-0">

                <!-- LEFT PANEL -->
                <div class="col-md-6 left-panel">

                    <div class="brand-badge">
                        Student Portal
                    </div>

                    <h1>Student Management System</h1>

                    <p>
                        Access your student portal to enrol in courses, view your enrolled subjects,
                        check your timetable, and manage your academic information easily.
                    </p>

                    <div class="feature-list">

                        <div class="feature-item">
                            <div class="feature-icon">📚</div>
                            <span>Enrol courses online</span>
                        </div>

                        <div class="feature-item">
                            <div class="feature-icon">🎓</div>
                            <span>View your programme details</span>
                        </div>

                        <div class="feature-item">
                            <div class="feature-icon">🗓️</div>
                            <span>Check your personal timetable</span>
                        </div>

                        <div class="feature-item">
                            <div class="feature-icon">✅</div>
                            <span>Track enrolled subjects</span>
                        </div>

                    </div>

                </div>

                <!-- RIGHT PANEL -->
                <div class="col-md-6 right-panel">

                    <h2 class="login-title">Student Login</h2>

                    <p class="login-subtitle">
                        Login to enrol courses, view enrolled subjects, and check your timetable.
                    </p>

                    <div class="mb-3">
                        <label class="form-label">Email Address</label>
                        <asp:TextBox ID="txtEmail" runat="server"
                            CssClass="form-control"
                            Placeholder="Enter your student email"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <asp:TextBox ID="txtPassword" runat="server"
                            TextMode="Password"
                            CssClass="form-control"
                            Placeholder="Enter your password"></asp:TextBox>
                    </div>

                    <asp:Button ID="btnLogin" runat="server"
                        Text="Login"
                        CssClass="btn btn-success w-100 btn-login"
                        OnClick="btnLogin_Click" />

                    <asp:Label ID="lblMsg" runat="server"
                        CssClass="mt-3 d-block text-center"></asp:Label>

                    <div class="divider">
                        <span>or</span>
                    </div>

                    <div class="text-center link-area">
                        <a href="StudentRegister.aspx" class="text-decoration-none">
                            Don't have an account? Register
                        </a>
                    </div>

                    <div class="portal-links link-area">
                        <a href="Login.aspx" class="text-decoration-none admin-link">
                            Admin Login
                        </a>

                        <span class="link-separator">|</span>

                        <a href="LecturerLogin.aspx" class="text-decoration-none lecturer-link">
                            Lecturer Login
                        </a>
                    </div>

                    <div class="system-footer">
                        Secure student access only.
                    </div>

                </div>

            </div>

        </div>

    </div>

</form>

</body>
</html>