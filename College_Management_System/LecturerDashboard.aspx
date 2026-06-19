<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/LecturerMaster.Master"
    CodeBehind="LecturerDashboard.aspx.cs"
    Inherits="College_Management_System.LecturerDashboard" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .topbar {
            background: white;
            border-radius: 22px;
            padding: 22px 26px;
            box-shadow: 0 8px 25px rgba(15, 23, 42, 0.07);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
        }

        .welcome-title {
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 5px;
        }

        .welcome-subtitle {
            color: #64748b;
            margin-bottom: 0;
        }

        .lecturer-avatar {
            width: 58px;
            height: 58px;
            background: linear-gradient(135deg, #1e293b, #0f766e);
            border-radius: 18px;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 24px;
            font-weight: 700;
        }

        .stat-card {
            border: none;
            border-radius: 22px;
            padding: 24px;
            background: white;
            box-shadow: 0 8px 25px rgba(15, 23, 42, 0.07);
            transition: 0.25s;
            height: 100%;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.12);
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

        .icon-course {
            background: #dbeafe;
            color: #2563eb;
        }

        .icon-student {
            background: #dcfce7;
            color: #16a34a;
        }

        .icon-class {
            background: #fef3c7;
            color: #d97706;
        }

        .icon-schedule {
            background: #ede9fe;
            color: #7c3aed;
        }

        .stat-card h3 {
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 4px;
        }

        .stat-card p {
            color: #64748b;
            margin-bottom: 0;
            font-weight: 500;
        }

        .section-card {
            background: white;
            border-radius: 22px;
            padding: 26px;
            box-shadow: 0 8px 25px rgba(15, 23, 42, 0.07);
            margin-top: 28px;
        }

        .section-title {
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 18px;
        }

        .table {
            margin-bottom: 0;
        }

        .table thead th {
            background: #f8fafc;
            color: #475569;
            font-weight: 700;
            border-bottom: none;
            padding: 14px;
        }

        .table tbody td {
            padding: 14px;
            color: #334155;
            vertical-align: middle;
        }

        .badge-day {
            display: inline-block;
            padding: 7px 13px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            background: #dcfce7;
            color: #15803d;
        }

        .quick-card-link {
            text-decoration: none;
        }

        .quick-action-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 22px;
            margin-top: 28px;
        }

        .quick-action-card {
            background: linear-gradient(135deg, #1e293b, #0f766e);
            color: white;
            border-radius: 22px;
            padding: 24px;
            box-shadow: 0 8px 25px rgba(15, 23, 42, 0.12);
            transition: 0.25s;
        }

        .quick-action-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.18);
        }

        .quick-action-card h4 {
            font-weight: 800;
            margin-bottom: 6px;
        }

        .quick-action-card p {
            color: #dbeafe;
            margin-bottom: 0;
        }

        .quick-action-icon {
            width: 56px;
            height: 56px;
            background: rgba(255, 255, 255, 0.16);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
        }

        .attendance-action-card {
            background: linear-gradient(135deg, #0f172a, #2563eb);
        }

        @media (max-width: 900px) {
            .topbar {
                flex-direction: column;
                align-items: flex-start;
                gap: 18px;
            }

            .quick-action-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Topbar -->
    <div class="topbar">
        <div>
            <h2 class="welcome-title">
                Welcome back, <asp:Label ID="lblLecturerName" runat="server" Text="Lecturer"></asp:Label>
            </h2>
            <p class="welcome-subtitle">Here is your teaching overview and schedule summary.</p>
        </div>

        <div class="lecturer-avatar">
            <asp:Label ID="lblInitial" runat="server" Text="L"></asp:Label>
        </div>
    </div>

    <!-- Statistic Cards -->
    <div class="row g-4">
        <div class="col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon icon-course">
                    <i class="fa-solid fa-book"></i>
                </div>

                <h3>
                    <asp:Label ID="lblAssignedCourses" runat="server" Text="0"></asp:Label>
                </h3>

                <p>Assigned Courses</p>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon icon-student">
                    <i class="fa-solid fa-users"></i>
                </div>

                <h3>
                    <asp:Label ID="lblTotalStudents" runat="server" Text="0"></asp:Label>
                </h3>

                <p>Total Students</p>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon icon-class">
                    <i class="fa-solid fa-calendar-check"></i>
                </div>

                <h3>
                    <asp:Label ID="lblTodayClasses" runat="server" Text="0"></asp:Label>
                </h3>

                <p>Today Classes</p>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon icon-schedule">
                    <i class="fa-solid fa-clock"></i>
                </div>

                <h3>
                    <asp:Label ID="lblWeeklySchedule" runat="server" Text="0"></asp:Label>
                </h3>

                <p>Weekly Schedule</p>
            </div>
        </div>
    </div>

    <!-- Quick Action Cards -->
    <div class="quick-action-grid">

        <a href="LecturerTimetable.aspx" class="quick-card-link">
            <div class="quick-action-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h4>View My Timetable</h4>
                        <p>Check your teaching schedule and download it as an image.</p>
                    </div>

                    <div class="quick-action-icon">
                        <i class="fa-solid fa-calendar-days"></i>
                    </div>
                </div>
            </div>
        </a>

        <a href="LecturerAttendance.aspx" class="quick-card-link">
            <div class="quick-action-card attendance-action-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h4>Mark Attendance</h4>
                        <p>Choose course, select date, and mark daily student attendance.</p>
                    </div>

                    <div class="quick-action-icon">
                        <i class="fa-solid fa-clipboard-check"></i>
                    </div>
                </div>
            </div>
        </a>

    </div>

    <!-- Today Classes -->
    <div class="section-card">
        <h4 class="section-title">Today’s Classes</h4>

        <asp:GridView ID="gvTodayClasses" runat="server"
            CssClass="table table-hover"
            AutoGenerateColumns="False"
            GridLines="None"
            EmptyDataText="No classes scheduled for today.">

            <Columns>
                <asp:BoundField DataField="CourseCode" HeaderText="Course Code" />
                <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                <asp:BoundField DataField="StartTime" HeaderText="Start Time" />
                <asp:BoundField DataField="EndTime" HeaderText="End Time" />
                <asp:BoundField DataField="Room" HeaderText="Room" />
            </Columns>

        </asp:GridView>
    </div>

    <!-- Upcoming Schedule -->
    <div class="section-card">
        <h4 class="section-title">Upcoming Schedule</h4>

        <asp:GridView ID="gvUpcomingSchedule" runat="server"
            CssClass="table table-hover"
            AutoGenerateColumns="False"
            GridLines="None"
            EmptyDataText="No schedule records found.">

            <Columns>
                <asp:BoundField DataField="CourseCode" HeaderText="Course Code" />
                <asp:BoundField DataField="CourseName" HeaderText="Course Name" />

                <asp:TemplateField HeaderText="Day">
                    <ItemTemplate>
                        <span class="badge-day">
                            <%# Eval("DayOfWeek") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="StartTime" HeaderText="Start Time" />
                <asp:BoundField DataField="EndTime" HeaderText="End Time" />
                <asp:BoundField DataField="Room" HeaderText="Room" />
            </Columns>

        </asp:GridView>
    </div>

</asp:Content>