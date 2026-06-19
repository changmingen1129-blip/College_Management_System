<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LecturerLogin.aspx.cs" Inherits="College_Management_System.LecturerLogin" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Lecturer Login</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body {
            margin: 0;
            min-height: 100vh;
            font-family: "Segoe UI", Arial, sans-serif;
            background: linear-gradient(135deg, #1e293b, #0f766e);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-wrapper {
            width: 980px;
            min-height: 560px;
            background: white;
            border-radius: 28px;
            overflow: hidden;
            box-shadow: 0 25px 60px rgba(15, 23, 42, 0.35);
            display: grid;
            grid-template-columns: 1fr 1fr;
        }

        .left-panel {
            background: linear-gradient(160deg, #0f766e, #0f172a);
            color: white;
            padding: 60px 50px;
            position: relative;
            overflow: hidden;
        }

        .left-panel::before {
            content: "";
            position: absolute;
            width: 240px;
            height: 240px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.12);
            top: -70px;
            right: -70px;
        }

        .left-panel::after {
            content: "";
            position: absolute;
            width: 180px;
            height: 180px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.10);
            bottom: -60px;
            left: -40px;
        }

        .portal-badge {
            display: inline-block;
            background: rgba(255, 255, 255, 0.16);
            padding: 8px 18px;
            border-radius: 999px;
            font-weight: 700;
            margin-bottom: 28px;
            position: relative;
            z-index: 2;
        }

        .left-panel h1 {
            font-weight: 800;
            font-size: 38px;
            line-height: 1.2;
            margin-bottom: 22px;
            position: relative;
            z-index: 2;
        }

        .left-panel p {
            color: #dbeafe;
            font-size: 16px;
            line-height: 1.7;
            position: relative;
            z-index: 2;
        }

        .feature-list {
            margin-top: 45px;
            position: relative;
            z-index: 2;
        }

        .feature-item {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 18px;
            font-weight: 600;
        }

        .feature-icon {
            width: 36px;
            height: 36px;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.16);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .right-panel {
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .right-panel h2 {
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 8px;
        }

        .subtitle {
            color: #64748b;
            margin-bottom: 32px;
        }

        .form-label {
            font-weight: 700;
            color: #334155;
        }

        .form-control {
            border-radius: 13px;
            padding: 13px 15px;
            border: 1px solid #cbd5e1;
        }

        .form-control:focus {
            border-color: #0f766e;
            box-shadow: 0 0 0 0.2rem rgba(15, 118, 110, 0.18);
        }

        .login-btn {
            width: 100%;
            border-radius: 14px;
            padding: 13px;
            font-weight: 800;
            background: #0f766e;
            border: none;
        }

        .login-btn:hover {
            background: #115e59;
        }

        .link-row {
            text-align: center;
            margin-top: 24px;
            color: #64748b;
        }

        .link-row a {
            text-decoration: none;
            font-weight: 700;
            color: #0f766e;
            margin: 0 8px;
        }

        .small-note {
            margin-top: 28px;
            text-align: center;
            color: #94a3b8;
            font-size: 13px;
        }

        @media (max-width: 900px) {
            .login-wrapper {
                width: 92%;
                grid-template-columns: 1fr;
            }

            .left-panel {
                display: none;
            }
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">

        <div class="login-wrapper">

            <!-- LEFT PANEL -->
            <div class="left-panel">
                <div class="portal-badge">Lecturer Portal</div>

                <h1>College Management System</h1>

                <p>
                    Access your lecturer portal to view assigned courses, class schedules,
                    student lists, and teaching information.
                </p>

                <div class="feature-list">
                    <div class="feature-item">
                        <div class="feature-icon">📚</div>
                        <span>View assigned courses</span>
                    </div>

                    <div class="feature-item">
                        <div class="feature-icon">🗓️</div>
                        <span>Check teaching timetable</span>
                    </div>

                    <div class="feature-item">
                        <div class="feature-icon">👥</div>
                        <span>View enrolled students</span>
                    </div>
                </div>
            </div>

            <!-- RIGHT PANEL -->
            <div class="right-panel">
                <h2>Lecturer Login</h2>
                <p class="subtitle">Login to access your lecturer dashboard.</p>

                <div class="mb-3">
                    <label class="form-label">Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server"
                        CssClass="form-control"
                        Placeholder="Enter lecturer email"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server"
                        CssClass="form-control"
                        TextMode="Password"
                        Placeholder="Enter password"></asp:TextBox>
                </div>

                <asp:Button ID="btnLogin" runat="server"
                    Text="Login"
                    CssClass="btn btn-primary login-btn"
                    OnClick="btnLogin_Click" />

                <asp:Label ID="lblMsg" runat="server"></asp:Label>

                <div class="link-row">
                    <a href="Login.aspx">Admin Login</a>
                    |
                    <a href="StudentLogin.aspx">Student Login</a>
                </div>

                <div class="small-note">
                    Default lecturer password is 123456.
                </div>
            </div>

        </div>

    </form>
</body>
</html>