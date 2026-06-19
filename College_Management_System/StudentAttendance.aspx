<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/StudentMaster.Master"
    CodeBehind="StudentAttendance.aspx.cs"
    Inherits="College_Management_System.StudentAttendance" %>

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

        .icon-total {
            background: #dbeafe;
            color: #2563eb;
        }

        .icon-present {
            background: #dcfce7;
            color: #16a34a;
        }

        .icon-absent {
            background: #fee2e2;
            color: #dc2626;
        }

        .icon-percent {
            background: #ccfbf1;
            color: #0f766e;
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

        .status-badge {
            display: inline-block;
            padding: 7px 13px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 800;
        }

        .status-present {
            background: #dcfce7;
            color: #15803d;
        }

        .status-absent {
            background: #fee2e2;
            color: #b91c1c;
        }

        .status-late {
            background: #fef3c7;
            color: #b45309;
        }

        .status-excused {
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

    <div class="topbar">
        <div>
            <h2 class="page-title">My Attendance</h2>
            <p class="page-subtitle">
                View your attendance records and attendance percentage.
            </p>
        </div>

        <div class="student-avatar">
            <asp:Label ID="lblInitial" runat="server" Text="S"></asp:Label>
        </div>
    </div>

    <div class="row g-4">

        <div class="col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon icon-total">
                    <i class="fa-solid fa-list-check"></i>
                </div>
                <h3>
                    <asp:Label ID="lblTotal" runat="server" Text="0"></asp:Label>
                </h3>
                <p>Total Records</p>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon icon-present">
                    <i class="fa-solid fa-circle-check"></i>
                </div>
                <h3>
                    <asp:Label ID="lblPresent" runat="server" Text="0"></asp:Label>
                </h3>
                <p>Present</p>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon icon-absent">
                    <i class="fa-solid fa-circle-xmark"></i>
                </div>
                <h3>
                    <asp:Label ID="lblAbsent" runat="server" Text="0"></asp:Label>
                </h3>
                <p>Absent</p>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon icon-percent">
                    <i class="fa-solid fa-percent"></i>
                </div>
                <h3>
                    <asp:Label ID="lblPercentage" runat="server" Text="0%"></asp:Label>
                </h3>
                <p>Attendance Rate</p>
            </div>
        </div>

    </div>

    <div class="section-card">
        <h4 class="section-title">Attendance Records</h4>

        <asp:GridView ID="gvAttendance" runat="server"
            CssClass="table table-hover"
            AutoGenerateColumns="False"
            GridLines="None"
            EmptyDataText="No attendance records found yet.">

            <Columns>
                <asp:BoundField DataField="AttendanceDate" HeaderText="Date" DataFormatString="{0:dd MMM yyyy}" />
                <asp:BoundField DataField="CourseCode" HeaderText="Course Code" />
                <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                <asp:BoundField DataField="LecturerName" HeaderText="Lecturer" />

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='status-badge <%# GetStatusClass(Eval("Status").ToString()) %>'>
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
            </Columns>

        </asp:GridView>
    </div>

</asp:Content>