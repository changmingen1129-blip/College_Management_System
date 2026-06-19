<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/AdminMaster.Master"
    CodeBehind="Dashboard.aspx.cs"
    Inherits="College_Management_System.Dashboard" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .top-header {
            background: white;
            border-radius: 26px;
            padding: 26px 30px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
            border: 1px solid #eef2f7;
        }

        .page-title {
            font-weight: 850;
            color: #0f172a;
            margin-bottom: 6px;
        }

        .page-subtitle {
            color: #64748b;
            margin-bottom: 0;
        }

        .admin-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #dcfce7;
            color: #15803d;
            padding: 10px 16px;
            border-radius: 999px;
            font-weight: 800;
            font-size: 14px;
        }

        .stat-card {
            background: white;
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
            height: 100%;
            border: 1px solid #eef2f7;
            transition: 0.22s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 14px 34px rgba(15, 23, 42, 0.12);
        }

        .stat-icon {
            width: 58px;
            height: 58px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            margin-bottom: 18px;
        }

        .icon-programme {
            background: #dbeafe;
            color: #2563eb;
        }

        .icon-course {
            background: #dcfce7;
            color: #16a34a;
        }

        .icon-student {
            background: #fef3c7;
            color: #d97706;
        }

        .icon-lecturer {
            background: #cffafe;
            color: #0891b2;
        }

        .stat-card h3 {
            font-weight: 850;
            color: #0f172a;
            margin-bottom: 4px;
            font-size: 34px;
        }

        .stat-card p {
            color: #64748b;
            margin-bottom: 0;
            font-weight: 600;
        }

        .section-card {
            background: white;
            border-radius: 26px;
            padding: 28px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
            margin-top: 30px;
            border: 1px solid #eef2f7;
        }

        .section-title {
            font-weight: 850;
            color: #0f172a;
            margin-bottom: 6px;
        }

        .module-card {
            height: 100%;
            border: 1px solid #e5e7eb;
            border-radius: 22px;
            padding: 26px;
            background: #ffffff;
            text-align: center;
            transition: 0.22s ease;
        }

        .module-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 14px 30px rgba(15, 23, 42, 0.10);
            border-color: #cbd5e1;
        }

        .module-icon {
            width: 64px;
            height: 64px;
            border-radius: 20px;
            margin: 0 auto 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
        }

        .module-card h5 {
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 10px;
        }

        .module-card p {
            color: #64748b;
            min-height: 48px;
        }

        .module-card .btn {
            border-radius: 13px;
            padding: 10px 16px;
            font-weight: 750;
            width: 100%;
        }

        .table {
            margin-bottom: 0;
        }

        .table thead th {
            background: #f8fafc;
            color: #475569;
            font-weight: 800;
            border-bottom: none;
            padding: 14px;
        }

        .table tbody td {
            padding: 14px;
            color: #334155;
            vertical-align: middle;
        }

        .quick-status-box {
            background: linear-gradient(135deg, #111827, #0f766e);
            color: white;
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.18);
        }

        .quick-status-box h5 {
            font-weight: 850;
            margin-bottom: 8px;
        }

        .quick-status-box p {
            color: #dbeafe;
            margin-bottom: 0;
        }

        body.dark-mode .top-header,
        body.dark-mode .stat-card,
        body.dark-mode .section-card,
        body.dark-mode .module-card {
            background: #1e293b;
            border-color: #334155;
            color: #e2e8f0;
        }

        body.dark-mode .page-title,
        body.dark-mode .section-title,
        body.dark-mode .stat-card h3,
        body.dark-mode .module-card h5 {
            color: #f8fafc;
        }

        body.dark-mode .page-subtitle,
        body.dark-mode .stat-card p,
        body.dark-mode .module-card p,
        body.dark-mode .text-muted {
            color: #94a3b8 !important;
        }

        body.dark-mode .table thead th {
            background: #0f172a;
            color: #cbd5e1;
        }

        body.dark-mode .table tbody td {
            color: #e2e8f0;
            background: #1e293b;
        }

        @media (max-width: 992px) {
            .top-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 18px;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- TOP HEADER -->
    <div class="top-header">
        <div>
            <h2 class="page-title">Welcome Admin 🎓</h2>
            <p class="page-subtitle">
                Manage programmes, courses, students, lecturers, course assignments, and class schedules from one dashboard.
            </p>
        </div>

        <div class="admin-pill">
            <i class="fa-solid fa-circle-check"></i>
            System Active
        </div>
    </div>

    <!-- STATISTIC CARDS -->
    <div class="row g-4">

        <div class="col-md-6 col-xl-3">
            <div class="stat-card">
                <div class="stat-icon icon-programme">
                    <i class="fa-solid fa-layer-group"></i>
                </div>

                <h3>
                    <asp:Label ID="lblProgrammeCount" runat="server" Text="0"></asp:Label>
                </h3>

                <p>Total Programmes</p>
            </div>
        </div>

        <div class="col-md-6 col-xl-3">
            <div class="stat-card">
                <div class="stat-icon icon-course">
                    <i class="fa-solid fa-book-open"></i>
                </div>

                <h3>
                    <asp:Label ID="lblCourseCount" runat="server" Text="0"></asp:Label>
                </h3>

                <p>Total Courses</p>
            </div>
        </div>

        <div class="col-md-6 col-xl-3">
            <div class="stat-card">
                <div class="stat-icon icon-student">
                    <i class="fa-solid fa-users"></i>
                </div>

                <h3>
                    <asp:Label ID="lblStudentCount" runat="server" Text="0"></asp:Label>
                </h3>

                <p>Registered Students</p>
            </div>
        </div>

        <div class="col-md-6 col-xl-3">
            <div class="stat-card">
                <div class="stat-icon icon-lecturer">
                    <i class="fa-solid fa-chalkboard-user"></i>
                </div>

                <h3>
                    <asp:Label ID="lblLecturerCount" runat="server" Text="0"></asp:Label>
                </h3>

                <p>Registered Lecturers</p>
            </div>
        </div>

    </div>

    <!-- QUICK STATUS -->
    <div class="section-card">
        <div class="quick-status-box">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h5>Academic Management System</h5>
                    <p>
                        Your system now supports admin, student, and lecturer portals with scheduling and timetable features.
                    </p>
                </div>

                <div class="fs-1">
                    <i class="fa-solid fa-school"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- MODULE MENU -->
    <div class="section-card">

        <h4 class="section-title">System Modules</h4>
        <p class="text-muted mb-4">Choose a module to manage the system.</p>

        <div class="row g-4">

            <div class="col-md-6 col-xl-4">
                <div class="module-card">
                    <div class="module-icon icon-programme">
                        <i class="fa-solid fa-layer-group"></i>
                    </div>

                    <h5>Manage Programme</h5>
                    <p>Add and update academic programmes.</p>
                    <a href="Programme.aspx" class="btn btn-primary">Open Module</a>
                </div>
            </div>

            <div class="col-md-6 col-xl-4">
                <div class="module-card">
                    <div class="module-icon icon-course">
                        <i class="fa-solid fa-book-open"></i>
                    </div>

                    <h5>Manage Courses</h5>
                    <p>Create courses and link them to programmes.</p>
                    <a href="Course.aspx" class="btn btn-success">Open Module</a>
                </div>
            </div>

            <div class="col-md-6 col-xl-4">
                <div class="module-card">
                    <div class="module-icon icon-student">
                        <i class="fa-solid fa-user-plus"></i>
                    </div>

                    <h5>Enrol Student</h5>
                    <p>Register students into selected courses.</p>
                    <a href="Enrolment.aspx" class="btn btn-warning">Open Module</a>
                </div>
            </div>

            <div class="col-md-6 col-xl-4">
                <div class="module-card">
                    <div class="module-icon icon-student">
                        <i class="fa-solid fa-users"></i>
                    </div>

                    <h5>Manage Students</h5>
                    <p>View, edit, search, reset password, and manage student accounts.</p>
                    <a href="ManageStudent.aspx" class="btn btn-danger">Open Module</a>
                </div>
            </div>

            <div class="col-md-6 col-xl-4">
                <div class="module-card">
                    <div class="module-icon icon-lecturer">
                        <i class="fa-solid fa-chalkboard-user"></i>
                    </div>

                    <h5>Register Lecturer</h5>
                    <p>Add lecturer details and create lecturer login accounts.</p>
                    <a href="RegisterLecturer.aspx" class="btn btn-dark">Open Module</a>
                </div>
            </div>

            <div class="col-md-6 col-xl-4">
                <div class="module-card">
                    <div class="module-icon icon-course">
                        <i class="fa-solid fa-link"></i>
                    </div>

                    <h5>Assign Courses</h5>
                    <p>Assign lecturers to available courses.</p>
                    <a href="AssignCourse.aspx" class="btn btn-info">Open Module</a>
                </div>
            </div>

            <div class="col-md-6 col-xl-4">
                <div class="module-card">
                    <div class="module-icon icon-programme">
                        <i class="fa-solid fa-calendar-days"></i>
                    </div>

                    <h5>Manage Schedule</h5>
                    <p>Create class timetable by course, lecturer, day, time, and room.</p>
                    <a href="ManageSchedule.aspx" class="btn btn-secondary">Open Module</a>
                </div>
            </div>

            <div class="col-md-6 col-xl-4">
                <div class="module-card">
                    <div class="module-icon icon-course">
                        <i class="fa-solid fa-clipboard-check"></i>
                    </div>

                    <h5>Attendance Report</h5>
                    <p>View student and lecturer attendance records later.</p>
                    <a href="AttendanceReport.aspx" class="btn btn-outline-primary">Open Module</a>
                </div>
            </div>

            <div class="col-md-6 col-xl-4">
                <div class="module-card">
                    <div class="module-icon icon-student">
                        <i class="fa-solid fa-chart-line"></i>
                    </div>

                    <h5>Result Report</h5>
                    <p>View student grades, marks, and academic result reports later.</p>
                    <a href="ResultReport.aspx" class="btn btn-outline-success">Open Module</a>
                </div>
            </div>

        </div>

    </div>

    <!-- RECENT ENROLMENTS -->
    <div class="section-card">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h4 class="section-title mb-1">Recent Enrolments</h4>
                <p class="text-muted mb-0">Latest students enrolled into courses.</p>
            </div>

            <a href="Enrolment.aspx" class="btn btn-outline-primary">
                View All
            </a>
        </div>

        <asp:GridView ID="gvRecentEnrolments" runat="server"
            CssClass="table table-hover"
            AutoGenerateColumns="False"
            GridLines="None"
            EmptyDataText="No recent enrolments found.">

            <Columns>
                <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                <asp:BoundField DataField="EnrolDate" HeaderText="Enrol Date" DataFormatString="{0:dd MMM yyyy}" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
            </Columns>

        </asp:GridView>

    </div>

</asp:Content>