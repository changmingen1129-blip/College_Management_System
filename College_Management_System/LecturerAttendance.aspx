<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/LecturerMaster.Master"
    CodeBehind="LecturerAttendance.aspx.cs"
    Inherits="College_Management_System.LecturerAttendance" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .top-header {
            position: relative;
            overflow: hidden;
            background: linear-gradient(135deg, #020617, #0f172a 45%, #0f766e);
            border-radius: 28px;
            padding: 30px;
            color: white;
            box-shadow: 0 16px 40px rgba(15, 23, 42, 0.18);
            margin-bottom: 28px;
        }

        .top-header h2 {
            font-weight: 900;
            margin-bottom: 8px;
        }

        .top-header p {
            color: #cbd5e1;
            margin-bottom: 0;
        }

        .section-card {
            background: white;
            border-radius: 26px;
            padding: 28px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
            border: 1px solid #eef2f7;
            margin-bottom: 28px;
        }

        .section-title {
            font-weight: 850;
            color: #0f172a;
            margin-bottom: 6px;
        }

        .form-label {
            font-weight: 750;
            color: #334155;
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
            font-weight: 750;
        }

        .note-box {
            background: #eff6ff;
            border-left: 5px solid #2563eb;
            border-radius: 14px;
            padding: 14px 16px;
            color: #475569;
            font-weight: 600;
            margin-bottom: 20px;
        }

        .summary-card {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            padding: 18px;
            height: 100%;
        }

        .summary-card h3 {
            font-weight: 900;
            color: #0f172a;
            margin-bottom: 2px;
        }

        .summary-card p {
            margin-bottom: 0;
            color: #64748b;
            font-weight: 600;
        }

        .table {
            margin-bottom: 0;
            border-radius: 16px;
            overflow: hidden;
        }

        .table thead th {
            background: #0f172a;
            color: white;
            font-weight: 800;
            padding: 14px;
            vertical-align: middle;
        }

        .table tbody td {
            padding: 14px;
            color: #334155;
            vertical-align: middle;
        }

        .status-select {
            min-width: 140px;
        }

        .message-label {
            font-weight: 800;
        }

        @media (max-width: 900px) {
            .top-header {
                padding: 24px;
            }

            .section-card {
                padding: 22px;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="top-header">
        <h2>
            <i class="fa-solid fa-clipboard-check me-2"></i>
            Daily Attendance
        </h2>

        <p>
            Select your assigned course, choose a date, load students, and mark their attendance.
        </p>
    </div>

    <!-- Filter / Load Section -->
    <div class="section-card">

        <h4 class="section-title">Mark Attendance</h4>

        <p class="text-muted mb-4">
            Attendance can be saved or updated for the selected course and date.
        </p>

        <div class="note-box">
            <i class="fa-solid fa-circle-info me-2"></i>
            If attendance already exists for the same student, course, and date, the system will update the old record.
        </div>

        <div class="row">

            <div class="col-md-6 mb-3">
                <label class="form-label">Select Course</label>

                <asp:DropDownList ID="ddlCourse" runat="server"
                    CssClass="form-control">
                </asp:DropDownList>
            </div>

            <div class="col-md-3 mb-3">
                <label class="form-label">Attendance Date</label>

                <asp:TextBox ID="txtAttendanceDate" runat="server"
                    CssClass="form-control"
                    TextMode="Date"></asp:TextBox>
            </div>

            <div class="col-md-3 mb-3 d-flex align-items-end">
                <asp:Button ID="btnLoadStudents" runat="server"
                    Text="Load Students"
                    CssClass="btn btn-primary w-100"
                    OnClick="btnLoadStudents_Click" />
            </div>

        </div>

        <asp:Label ID="lblMsg" runat="server" CssClass="message-label"></asp:Label>

    </div>

    <!-- Students Attendance Section -->
    <div class="section-card">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h4 class="section-title mb-1">Student Attendance List</h4>

                <p class="text-muted mb-0">
                    Mark each student as Present, Absent, Late, or Excused.
                </p>
            </div>

            <asp:Button ID="btnSaveAttendance" runat="server"
                Text="Save Attendance"
                CssClass="btn btn-success"
                OnClick="btnSaveAttendance_Click" />
        </div>

        <asp:GridView ID="gvStudents" runat="server"
            CssClass="table table-bordered table-hover align-middle"
            AutoGenerateColumns="False"
            GridLines="None"
            DataKeyNames="StudentID"
            EmptyDataText="Please select a course and load students.">

            <Columns>
                <asp:BoundField DataField="StudentID" HeaderText="ID" />
                <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                <asp:BoundField DataField="Email" HeaderText="Email" />

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <asp:DropDownList ID="ddlStatus" runat="server"
                            CssClass="form-control status-select">
                            <asp:ListItem>Present</asp:ListItem>
                            <asp:ListItem>Absent</asp:ListItem>
                            <asp:ListItem>Late</asp:ListItem>
                            <asp:ListItem>Excused</asp:ListItem>
                        </asp:DropDownList>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Remarks">
                    <ItemTemplate>
                        <asp:TextBox ID="txtRemarks" runat="server"
                            CssClass="form-control"
                            Placeholder="Optional remarks"></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>

        </asp:GridView>

    </div>

    <!-- Attendance Summary -->
    <div class="section-card">

        <h4 class="section-title">Attendance Summary</h4>

        <p class="text-muted mb-4">
            Summary for the selected course and date.
        </p>

        <div class="row g-3">

            <div class="col-md-3">
                <div class="summary-card">
                    <h3>
                        <asp:Label ID="lblTotal" runat="server" Text="0"></asp:Label>
                    </h3>
                    <p>Total Students</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="summary-card">
                    <h3>
                        <asp:Label ID="lblPresent" runat="server" Text="0"></asp:Label>
                    </h3>
                    <p>Present</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="summary-card">
                    <h3>
                        <asp:Label ID="lblAbsent" runat="server" Text="0"></asp:Label>
                    </h3>
                    <p>Absent</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="summary-card">
                    <h3>
                        <asp:Label ID="lblLate" runat="server" Text="0"></asp:Label>
                    </h3>
                    <p>Late / Excused</p>
                </div>
            </div>

        </div>

    </div>

    <!-- Lecturer Attendance Report -->
    <div class="section-card">

        <h4 class="section-title">My Attendance Report</h4>

        <p class="text-muted mb-4">
            View attendance records saved by you.
        </p>

        <asp:GridView ID="gvReport" runat="server"
            CssClass="table table-bordered table-hover align-middle"
            AutoGenerateColumns="False"
            GridLines="None"
            EmptyDataText="No attendance records found.">

            <Columns>
                <asp:BoundField DataField="AttendanceDate" HeaderText="Date" DataFormatString="{0:dd MMM yyyy}" />
                <asp:BoundField DataField="CourseCode" HeaderText="Course Code" />
                <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
                <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
            </Columns>

        </asp:GridView>

    </div>

</asp:Content>