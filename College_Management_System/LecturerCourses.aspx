<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/LecturerMaster.Master"
    CodeBehind="LecturerCourses.aspx.cs"
    Inherits="College_Management_System.LecturerCourses" %>

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

        .summary-card {
            border: none;
            border-radius: 22px;
            padding: 24px;
            background: white;
            box-shadow: 0 8px 25px rgba(15, 23, 42, 0.07);
            height: 100%;
        }

        .summary-icon {
            width: 56px;
            height: 56px;
            border-radius: 18px;
            background: #dbeafe;
            color: #2563eb;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            margin-bottom: 16px;
        }

        .summary-card h3 {
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 4px;
        }

        .summary-card p {
            color: #64748b;
            margin-bottom: 0;
            font-weight: 500;
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
            background: #dcfce7;
            color: #15803d;
        }

        .note-box {
            background: #f8fafc;
            border-left: 4px solid #0f766e;
            border-radius: 10px;
            padding: 12px 15px;
            margin-bottom: 20px;
            color: #475569;
            font-size: 14px;
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
            <h2 class="page-title">My Assigned Courses</h2>
            <p class="page-subtitle">
                View all courses assigned to you by the administrator.
            </p>
        </div>

        <div class="lecturer-avatar">
            <asp:Label ID="lblInitial" runat="server" Text="L"></asp:Label>
        </div>
    </div>

    <!-- Summary -->
    <div class="row g-4">
        <div class="col-md-6 col-lg-4">
            <div class="summary-card">
                <div class="summary-icon">
                    <i class="fa-solid fa-book"></i>
                </div>

                <h3>
                    <asp:Label ID="lblTotalCourses" runat="server" Text="0"></asp:Label>
                </h3>

                <p>Total Assigned Courses</p>
            </div>
        </div>
    </div>

    <!-- Courses Table -->
    <div class="section-card">
        <h4 class="section-title">Course List</h4>

        <div class="note-box">
            These courses are assigned by admin from the <strong>Assign Courses</strong> module.
        </div>

        <asp:GridView ID="gvCourses" runat="server"
            CssClass="table table-hover"
            AutoGenerateColumns="False"
            GridLines="None"
            EmptyDataText="No assigned courses found.">

            <Columns>
                <asp:TemplateField HeaderText="Course Code">
                    <ItemTemplate>
                        <span class="course-code-badge">
                            <%# Eval("CourseCode") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="CourseName" HeaderText="Course Name" />

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

                <asp:BoundField DataField="CreditHours" HeaderText="Credit Hours" />

                <asp:BoundField DataField="TotalStudents" HeaderText="Students Enrolled" />
            </Columns>

        </asp:GridView>
    </div>

</asp:Content>