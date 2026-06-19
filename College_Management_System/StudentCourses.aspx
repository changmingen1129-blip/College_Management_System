<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/StudentMaster.Master"
    CodeBehind="StudentCourses.aspx.cs"
    Inherits="College_Management_System.StudentCourses" %>

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

        .page-title {
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 5px;
        }

        .page-subtitle {
            color: #64748b;
            margin-bottom: 0;
        }

        .student-avatar {
            width: 58px;
            height: 58px;
            background: linear-gradient(135deg, #0f766e, #14b8a6);
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
            height: 100%;
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

        .icon-credit {
            background: #ccfbf1;
            color: #0f766e;
        }

        .icon-active {
            background: #dcfce7;
            color: #16a34a;
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

        .note-box {
            background: #f8fafc;
            border-left: 4px solid #0f766e;
            border-radius: 10px;
            padding: 12px 15px;
            margin-bottom: 20px;
            color: #475569;
            font-size: 14px;
            font-weight: 600;
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

        .course-code-badge {
            display: inline-block;
            padding: 7px 13px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 800;
            background: #dbeafe;
            color: #1d4ed8;
        }

        .programme-badge {
            display: inline-block;
            padding: 7px 13px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            background: #ccfbf1;
            color: #0f766e;
        }

        .status-badge {
            display: inline-block;
            padding: 7px 13px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            background: #dcfce7;
            color: #15803d;
        }

        @media (max-width: 900px) {
            .topbar {
                flex-direction: column;
                align-items: flex-start;
                gap: 18px;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Topbar -->
    <div class="topbar">
        <div>
            <h2 class="page-title">My Courses</h2>
            <p class="page-subtitle">
                View your enrolled courses, lecturers, programme, and enrolment status.
            </p>
        </div>

        <div class="student-avatar">
            <asp:Label ID="lblInitial" runat="server" Text="S"></asp:Label>
        </div>
    </div>

    <!-- Summary Cards -->
    <div class="row g-4">

        <div class="col-md-6 col-lg-4">
            <div class="stat-card">
                <div class="stat-icon icon-course">
                    <i class="fa-solid fa-book-open"></i>
                </div>

                <h3>
                    <asp:Label ID="lblTotalCourses" runat="server" Text="0"></asp:Label>
                </h3>

                <p>Total Enrolled Courses</p>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="stat-card">
                <div class="stat-icon icon-credit">
                    <i class="fa-solid fa-layer-group"></i>
                </div>

                <h3>
                    <asp:Label ID="lblTotalCredits" runat="server" Text="0"></asp:Label>
                </h3>

                <p>Total Credit Hours</p>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="stat-card">
                <div class="stat-icon icon-active">
                    <i class="fa-solid fa-circle-check"></i>
                </div>

                <h3>
                    <asp:Label ID="lblActiveCourses" runat="server" Text="0"></asp:Label>
                </h3>

                <p>Active Enrolments</p>
            </div>
        </div>

    </div>

    <!-- Course Table -->
    <div class="section-card">
        <h4 class="section-title">Enrolled Course List</h4>

        <div class="note-box">
            This page shows courses that you have enrolled in through the student enrolment module.
        </div>

        <asp:GridView ID="gvCourses" runat="server"
            CssClass="table table-hover"
            AutoGenerateColumns="False"
            GridLines="None"
            EmptyDataText="No enrolled courses found.">

            <Columns>
                <asp:TemplateField HeaderText="Course Code">
                    <ItemTemplate>
                        <span class="course-code-badge">
                            <%# Eval("CourseCode") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="CourseName" HeaderText="Course Name" />

                <asp:BoundField DataField="CreditHours" HeaderText="Credit Hours" />

                <asp:TemplateField HeaderText="Programme">
                    <ItemTemplate>
                        <span class="programme-badge">
                            <%# Eval("ProgrammeCode") %>
                        </span>

                        <span class="ms-2">
                            <%# Eval("ProgrammeName") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="LecturerName" HeaderText="Lecturer" />

                <asp:BoundField DataField="EnrolDate" HeaderText="Enrol Date" DataFormatString="{0:dd MMM yyyy}" />

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class="status-badge">
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>

        </asp:GridView>
    </div>

</asp:Content>