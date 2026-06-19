<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/LecturerMaster.Master"
    CodeBehind="LecturerStudents.aspx.cs"
    Inherits="College_Management_System.LecturerStudents" %>

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
            background: #dcfce7;
            color: #16a34a;
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
        }

        .filter-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 18px;
            margin-bottom: 20px;
        }

        .form-label {
            font-weight: 700;
            color: #334155;
            margin-bottom: 8px;
        }

        .form-control {
            border-radius: 14px;
            padding: 12px 14px;
            border: 1px solid #cbd5e1;
            box-shadow: none;
        }

        .form-control:focus {
            border-color: #0f766e;
            box-shadow: 0 0 0 4px rgba(15, 118, 110, 0.14);
        }

        .btn {
            border-radius: 13px;
            padding: 10px 18px;
            font-weight: 700;
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

        .status-badge {
            display: inline-block;
            padding: 7px 13px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            background: #dcfce7;
            color: #15803d;
        }

        .programme-badge {
            display: inline-block;
            padding: 7px 13px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            background: #ede9fe;
            color: #6d28d9;
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
            <h2 class="page-title">My Students</h2>
            <p class="page-subtitle">
                View students enrolled in your assigned courses.
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
                    <i class="fa-solid fa-users"></i>
                </div>

                <h3>
                    <asp:Label ID="lblTotalStudents" runat="server" Text="0"></asp:Label>
                </h3>

                <p>Total Students Across Assigned Courses</p>
            </div>
        </div>
    </div>

    <!-- Student Table -->
    <div class="section-card">
        <h4 class="section-title">Student List</h4>

        <div class="note-box">
            This page only shows students from courses assigned to your lecturer account.
        </div>

        <div class="filter-box">
            <h5 class="mb-3">Search Students</h5>

            <div class="row">
                <div class="col-md-8 mb-3">
                    <label class="form-label">Search by student name, email, course code, or course name</label>

                    <asp:TextBox ID="txtSearch" runat="server"
                        CssClass="form-control"
                        Placeholder="Example: Damion, gmail, ICT1105, AI"></asp:TextBox>
                </div>

                <div class="col-md-4 mb-3 d-flex align-items-end gap-2">
                    <asp:Button ID="btnSearch" runat="server"
                        Text="Search"
                        CssClass="btn btn-dark"
                        OnClick="btnSearch_Click" />

                    <asp:Button ID="btnShowAll" runat="server"
                        Text="Show All"
                        CssClass="btn btn-outline-dark"
                        OnClick="btnShowAll_Click" />
                </div>
            </div>
        </div>

        <asp:GridView ID="gvStudents" runat="server"
            CssClass="table table-hover"
            AutoGenerateColumns="False"
            GridLines="None"
            EmptyDataText="No students found for your assigned courses.">

            <Columns>
                <asp:TemplateField HeaderText="Course Code">
                    <ItemTemplate>
                        <span class="course-code-badge">
                            <%# Eval("CourseCode") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="CourseName" HeaderText="Course Name" />

                <asp:BoundField DataField="StudentName" HeaderText="Student Name" />

                <asp:BoundField DataField="Email" HeaderText="Student Email" />

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