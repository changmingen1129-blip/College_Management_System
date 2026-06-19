<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/AdminMaster.Master"
    CodeBehind="ManageSchedule.aspx.cs"
    Inherits="College_Management_System.ManageSchedule" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .page-header {
            position: relative;
            overflow: hidden;
            background: linear-gradient(135deg, #020617, #0f172a 45%, #0f766e);
            border-radius: 30px;
            padding: 34px 36px;
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.22);
            border: 1px solid rgba(255, 255, 255, 0.12);
            margin-bottom: 30px;
            color: white;
        }

        .page-header::before {
            content: "";
            position: absolute;
            width: 260px;
            height: 260px;
            border-radius: 50%;
            background: rgba(56, 189, 248, 0.22);
            top: -120px;
            right: -70px;
            filter: blur(6px);
        }

        .page-header::after {
            content: "";
            position: absolute;
            width: 180px;
            height: 180px;
            border-radius: 50%;
            background: rgba(34, 197, 94, 0.18);
            bottom: -90px;
            left: 120px;
            filter: blur(4px);
        }

        .page-header-content {
            position: relative;
            z-index: 2;
        }

        .page-title {
            font-weight: 900;
            color: #ffffff;
            margin-bottom: 10px;
            letter-spacing: -0.5px;
        }

        .page-subtitle {
            color: #cbd5e1;
            margin-bottom: 0;
            max-width: 760px;
            font-size: 15px;
            line-height: 1.6;
        }

        .header-chip-row {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 20px;
        }

        .header-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 14px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.18);
            color: #f8fafc;
            font-size: 13px;
            font-weight: 700;
            backdrop-filter: blur(8px);
        }

        .section-card {
            background: rgba(255, 255, 255, 0.94);
            border-radius: 28px;
            padding: 30px;
            box-shadow: 0 16px 40px rgba(15, 23, 42, 0.09);
            border: 1px solid #e5e7eb;
            margin-bottom: 30px;
            backdrop-filter: blur(14px);
        }

        .section-card:hover {
            box-shadow: 0 20px 48px rgba(15, 23, 42, 0.12);
        }

        .section-title {
            font-weight: 900;
            color: #0f172a;
            margin-bottom: 6px;
            letter-spacing: -0.3px;
        }

        .card-title-wrap {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .card-title-icon {
            width: 48px;
            height: 48px;
            border-radius: 17px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #2563eb, #0f766e);
            color: white;
            font-size: 20px;
            box-shadow: 0 10px 22px rgba(37, 99, 235, 0.24);
            flex-shrink: 0;
        }

        .form-label {
            font-weight: 800;
            color: #334155;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .form-control {
            border-radius: 16px;
            padding: 13px 15px;
            border: 1px solid #cbd5e1;
            box-shadow: none;
            background: #ffffff;
            font-weight: 600;
            color: #0f172a;
        }

        .form-control:focus {
            border-color: #0f766e;
            box-shadow: 0 0 0 4px rgba(15, 118, 110, 0.14);
        }

        .btn {
            border-radius: 15px;
            padding: 11px 20px;
            font-weight: 800;
            transition: 0.22s ease;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .btn-primary {
            border: none;
            background: linear-gradient(135deg, #2563eb, #0f766e);
            box-shadow: 0 10px 22px rgba(37, 99, 235, 0.22);
        }

        .btn-success {
            border: none;
            background: linear-gradient(135deg, #16a34a, #0f766e);
            box-shadow: 0 10px 22px rgba(22, 163, 74, 0.2);
        }

        .btn-dark {
            border: none;
            background: linear-gradient(135deg, #0f172a, #334155);
        }

        .btn-outline-secondary,
        .btn-outline-dark {
            border: 1px solid #cbd5e1;
            background: white;
            color: #334155;
        }

        .message-label {
            font-weight: 800;
        }

        .schedule-badge {
            display: inline-flex;
            align-items: center;
            padding: 8px 14px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 900;
            background: #e0f2fe;
            color: #0369a1;
            border: 1px solid #bae6fd;
        }

        .day-badge {
            display: inline-flex;
            align-items: center;
            padding: 8px 14px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 900;
            background: #dcfce7;
            color: #15803d;
            border: 1px solid #bbf7d0;
        }

        .note-box {
            background: linear-gradient(135deg, #eff6ff, #ecfeff);
            border: 1px solid #bfdbfe;
            border-left: 6px solid #2563eb;
            border-radius: 18px;
            padding: 16px 18px;
            margin-bottom: 24px;
            color: #334155;
            font-size: 14px;
            font-weight: 700;
        }

        .filter-box {
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            border: 1px solid #e2e8f0;
            border-radius: 22px;
            padding: 22px;
            margin-bottom: 24px;
        }

        .table {
            margin-bottom: 0;
            border-radius: 18px;
            overflow: hidden;
            border: 1px solid #e2e8f0;
        }

        .table thead th {
            background: linear-gradient(135deg, #0f172a, #1e293b);
            color: white;
            font-weight: 900;
            padding: 15px;
            vertical-align: middle;
            border: none;
            font-size: 14px;
        }

        .table tbody td {
            padding: 15px;
            color: #334155;
            vertical-align: middle;
            font-weight: 600;
            border-color: #e2e8f0;
        }

        .table-hover tbody tr:hover td {
            background: #f8fafc;
        }

        .preview-settings-box {
            background: linear-gradient(135deg, #f8fafc, #ecfeff);
            border: 1px solid #dbeafe;
            border-radius: 22px;
            padding: 22px;
            margin-bottom: 24px;
        }

        .day-selector-group {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 8px;
        }

        .day-option {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 15px;
            border: 1px solid #cbd5e1;
            border-radius: 999px;
            background: #ffffff;
            cursor: pointer;
            font-size: 14px;
            user-select: none;
            font-weight: 800;
            color: #334155;
            transition: 0.2s ease;
        }

        .day-option:hover {
            background: #eff6ff;
            border-color: #93c5fd;
            transform: translateY(-2px);
        }

        .day-option input {
            margin: 0;
            accent-color: #0f766e;
        }

        /* PREMIUM GENERATED TIMETABLE DESIGN */
        .timetable-wrapper {
            background: linear-gradient(135deg, #eef2ff, #ecfeff);
            border: 1px solid #cbd5e1;
            border-radius: 28px;
            padding: 26px;
            overflow: auto;
            box-shadow: inset 0 0 0 1px rgba(15, 23, 42, 0.04);
        }

        .tt-export-card {
            background: #ffffff;
            border-radius: 28px;
            padding: 26px;
            min-width: 1180px;
            border: 1px solid #dbeafe;
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.12);
        }

        .tt-export-header {
            text-align: left;
            margin-bottom: 24px;
            padding: 26px 30px;
            border-radius: 24px;
            background: linear-gradient(135deg, #020617, #0f172a 45%, #0f766e);
            color: white;
            position: relative;
            overflow: hidden;
        }

        .tt-export-header::after {
            content: "";
            position: absolute;
            width: 220px;
            height: 220px;
            border-radius: 50%;
            background: rgba(56, 189, 248, 0.22);
            top: -100px;
            right: -60px;
        }

        .tt-export-header h3 {
            margin: 0 0 8px 0;
            font-size: 34px;
            font-weight: 900;
            color: white;
            letter-spacing: -0.5px;
            position: relative;
            z-index: 2;
        }

        .tt-export-header p {
            margin: 0;
            color: #dbeafe;
            font-weight: 700;
            position: relative;
            z-index: 2;
        }

        .tt-header-row {
            display: flex;
            align-items: stretch;
        }

        .tt-time-header {
            width: 120px;
            min-width: 120px;
            border-right: 2px solid #cbd5e1;
            border-bottom: 3px solid #0f172a;
            background: #f8fafc;
            border-top-left-radius: 18px;
        }

        .tt-day-headers {
            display: flex;
            border-bottom: 3px solid #0f172a;
            flex: 1;
        }

        .tt-day-header {
            text-align: center;
            font-weight: 900;
            color: #0f172a;
            padding: 16px 8px;
            border-right: 1px solid #cbd5e1;
            background: linear-gradient(180deg, #f8fafc, #eef2ff);
            font-size: 16px;
            letter-spacing: 0.2px;
        }

        .tt-day-header:last-child {
            border-right: none;
            border-top-right-radius: 18px;
        }

        .tt-body {
            display: flex;
            position: relative;
        }

        .tt-time-column {
            width: 120px;
            min-width: 120px;
            position: relative;
            background: #f8fafc;
            border-right: 2px solid #cbd5e1;
        }

        .tt-time-label {
            position: absolute;
            left: 8px;
            right: 8px;
            padding: 6px 8px;
            text-align: center;
            transform: translateY(-16px);
            font-size: 14px;
            color: #0f172a;
            font-weight: 900;
            background: #ffffff;
            border: 1px solid #cbd5e1;
            border-radius: 999px;
            box-shadow: 0 4px 10px rgba(15, 23, 42, 0.08);
        }

        .tt-grid-area {
            position: relative;
            background: #ffffff;
            flex: 1;
        }

        .tt-vertical-line {
            position: absolute;
            top: 0;
            bottom: 0;
            border-right: 1px solid #dbeafe;
        }

        .tt-horizontal-line {
            position: absolute;
            left: 0;
            right: 0;
            border-top: 1px dashed #cbd5e1;
        }

        .tt-horizontal-line.major {
            border-top: 2px solid #94a3b8;
        }

        .tt-class-block {
            position: absolute;
            border-radius: 20px;
            padding: 12px 14px;
            overflow: hidden;
            box-shadow: 0 12px 24px rgba(15, 23, 42, 0.18);
            border: 1px solid rgba(15, 23, 42, 0.14);
            color: #0f172a;
        }

        .tt-class-block::before {
            content: "";
            position: absolute;
            left: 0;
            top: 0;
            width: 7px;
            height: 100%;
            background: rgba(15, 23, 42, 0.35);
        }

        .tt-class-code {
            font-size: 15px;
            font-weight: 900;
            margin-bottom: 5px;
            padding-left: 6px;
        }

        .tt-class-name {
            font-size: 13px;
            font-weight: 900;
            line-height: 1.3;
            margin-bottom: 7px;
            padding-left: 6px;
        }

        .tt-class-info {
            font-size: 12px;
            line-height: 1.35;
            font-weight: 800;
            padding-left: 6px;
        }

        .tt-export-footer {
            margin-top: 20px;
            padding: 14px;
            border-radius: 16px;
            background: #f8fafc;
            text-align: center;
            font-size: 13px;
            color: #64748b;
            font-weight: 800;
            border: 1px solid #e2e8f0;
        }

        .empty-preview {
            padding: 60px 20px;
            text-align: center;
            color: #64748b;
            font-size: 16px;
            font-weight: 800;
            background: #ffffff;
            border-radius: 22px;
            border: 2px dashed #cbd5e1;
        }

        .preview-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        body.capture-mode .hide-in-export {
            display: none !important;
        }

        body.dark-mode .page-header {
            background: linear-gradient(135deg, #020617, #0f172a, #134e4a);
            border-color: #334155;
        }

        body.dark-mode .section-card {
            background: #1e293b;
            border-color: #334155;
            color: #e2e8f0;
        }

        body.dark-mode .page-title,
        body.dark-mode .section-title {
            color: #f8fafc;
        }

        body.dark-mode .page-subtitle,
        body.dark-mode .text-muted {
            color: #94a3b8 !important;
        }

        body.dark-mode .form-label {
            color: #cbd5e1;
        }

        body.dark-mode .form-control {
            background: #0f172a;
            border-color: #334155;
            color: #f8fafc;
        }

        body.dark-mode .form-control::placeholder {
            color: #64748b;
        }

        body.dark-mode .note-box,
        body.dark-mode .filter-box,
        body.dark-mode .preview-settings-box {
            background: #0f172a;
            color: #cbd5e1;
            border-color: #334155;
        }

        body.dark-mode .note-box {
            border-left-color: #38bdf8;
        }

        body.dark-mode .day-option {
            background: #1e293b;
            border-color: #475569;
            color: #e2e8f0;
        }

        body.dark-mode .table thead th {
            background: #020617;
            color: #f8fafc;
        }

        body.dark-mode .table tbody td {
            background: #1e293b;
            color: #e2e8f0;
            border-color: #334155;
        }

        body.dark-mode .table-hover tbody tr:hover td {
            background: #263449;
        }

        body.dark-mode .timetable-wrapper {
            background: #0f172a;
            border-color: #334155;
        }

        @media (max-width: 768px) {
            .page-header {
                padding: 28px 24px;
            }

            .section-card {
                padding: 24px;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- PAGE HEADER -->
    <div class="page-header">
        <div class="page-header-content">
            <h2 class="page-title">
                <i class="fa-solid fa-calendar-days me-2"></i>
                Manage Class Schedule
            </h2>

            <p class="page-subtitle">
                Create, filter, and preview class schedules with clash prevention for rooms, lecturers, days, and overlapping time.
            </p>

            <div class="header-chip-row">
                <span class="header-chip">
                    <i class="fa-solid fa-shield-halved"></i>
                    Clash Prevention
                </span>

                <span class="header-chip">
                    <i class="fa-solid fa-table-cells-large"></i>
                    Visual Timetable
                </span>

                <span class="header-chip">
                    <i class="fa-solid fa-download"></i>
                    Download Image
                </span>

                <span class="header-chip">
                    <i class="fa-solid fa-filter"></i>
                    Smart Filter
                </span>
            </div>
        </div>
    </div>

    <!-- FORM CARD -->
    <div class="section-card">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div class="card-title-wrap">
                <div class="card-title-icon">
                    <i class="fa-solid fa-plus"></i>
                </div>

                <div>
                    <h4 class="section-title">Add New Schedule</h4>
                    <p class="text-muted mb-0">
                        The timetable will be shown automatically to students based on their enrolled courses.
                    </p>
                </div>
            </div>
        </div>

        <div class="note-box">
            <i class="fa-solid fa-circle-info me-2"></i>
            The system will prevent room clashes and lecturer clashes for the same day and overlapping time.
        </div>

        <asp:HiddenField ID="hfScheduleID" runat="server" Value="0" />
        <asp:HiddenField ID="hfScheduleJson" runat="server" />

        <div class="row">

            <div class="col-md-6 mb-3">
                <label class="form-label">Select Course</label>
                <asp:DropDownList ID="ddlCourse" runat="server"
                    CssClass="form-control"></asp:DropDownList>
            </div>

            <div class="col-md-6 mb-3">
                <label class="form-label">Select Lecturer</label>
                <asp:DropDownList ID="ddlLecturer" runat="server"
                    CssClass="form-control"></asp:DropDownList>
            </div>

            <div class="col-md-4 mb-3">
                <label class="form-label">Day</label>
                <asp:DropDownList ID="ddlDay" runat="server"
                    CssClass="form-control">
                    <asp:ListItem Value="0">-- Select Day --</asp:ListItem>
                    <asp:ListItem>Monday</asp:ListItem>
                    <asp:ListItem>Tuesday</asp:ListItem>
                    <asp:ListItem>Wednesday</asp:ListItem>
                    <asp:ListItem>Thursday</asp:ListItem>
                    <asp:ListItem>Friday</asp:ListItem>
                    <asp:ListItem>Saturday</asp:ListItem>
                    <asp:ListItem>Sunday</asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="col-md-4 mb-3">
                <label class="form-label">Start Time</label>
                <asp:TextBox ID="txtStartTime" runat="server"
                    CssClass="form-control"
                    TextMode="Time"></asp:TextBox>
            </div>

            <div class="col-md-4 mb-3">
                <label class="form-label">End Time</label>
                <asp:TextBox ID="txtEndTime" runat="server"
                    CssClass="form-control"
                    TextMode="Time"></asp:TextBox>
            </div>

            <div class="col-md-6 mb-3">
                <label class="form-label">Room / Lab</label>
                <asp:TextBox ID="txtRoom" runat="server"
                    CssClass="form-control"
                    Placeholder="Example: Lab 1, Room A203"></asp:TextBox>
            </div>

        </div>

        <div class="d-flex align-items-center gap-3 flex-wrap">
            <asp:Button ID="btnSaveSchedule" runat="server"
                Text="Save Schedule"
                CssClass="btn btn-primary"
                OnClick="btnSaveSchedule_Click" />

            <asp:Button ID="btnClear" runat="server"
                Text="Clear"
                CssClass="btn btn-outline-secondary"
                OnClick="btnClear_Click" />

            <asp:Label ID="lblMsg" runat="server" CssClass="message-label"></asp:Label>
        </div>

    </div>

    <!-- SCHEDULE LIST -->
    <div class="section-card">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div class="card-title-wrap">
                <div class="card-title-icon">
                    <i class="fa-solid fa-list-check"></i>
                </div>

                <div>
                    <h4 class="section-title mb-1">Schedule List</h4>
                    <p class="text-muted mb-0">
                        View, filter, edit, or delete existing class schedules.
                    </p>
                </div>
            </div>

            <a href="Dashboard.aspx" class="btn btn-outline-secondary">
                Back to Dashboard
            </a>
        </div>

        <!-- FILTER SECTION -->
        <div class="filter-box">
            <h5 class="section-title mb-3">
                <i class="fa-solid fa-filter me-2"></i>
                Filter Schedule
            </h5>

            <div class="row">
                <div class="col-md-3 mb-3">
                    <label class="form-label">Filter Course</label>
                    <asp:DropDownList ID="ddlFilterCourse" runat="server"
                        CssClass="form-control"></asp:DropDownList>
                </div>

                <div class="col-md-3 mb-3">
                    <label class="form-label">Filter Lecturer</label>
                    <asp:DropDownList ID="ddlFilterLecturer" runat="server"
                        CssClass="form-control"></asp:DropDownList>
                </div>

                <div class="col-md-3 mb-3">
                    <label class="form-label">Filter Day</label>
                    <asp:DropDownList ID="ddlFilterDay" runat="server"
                        CssClass="form-control">
                        <asp:ListItem Value="0">All Days</asp:ListItem>
                        <asp:ListItem>Monday</asp:ListItem>
                        <asp:ListItem>Tuesday</asp:ListItem>
                        <asp:ListItem>Wednesday</asp:ListItem>
                        <asp:ListItem>Thursday</asp:ListItem>
                        <asp:ListItem>Friday</asp:ListItem>
                        <asp:ListItem>Saturday</asp:ListItem>
                        <asp:ListItem>Sunday</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="col-md-3 mb-3">
                    <label class="form-label">Search Room</label>
                    <asp:TextBox ID="txtFilterRoom" runat="server"
                        CssClass="form-control"
                        Placeholder="Example: Lab 1"></asp:TextBox>
                </div>
            </div>

            <div class="d-flex gap-2 flex-wrap">
                <asp:Button ID="btnFilterSchedule" runat="server"
                    Text="Apply Filter"
                    CssClass="btn btn-dark"
                    OnClick="btnFilterSchedule_Click" />

                <asp:Button ID="btnShowAllSchedule" runat="server"
                    Text="Show All"
                    CssClass="btn btn-outline-dark"
                    OnClick="btnShowAllSchedule_Click" />
            </div>
        </div>

        <asp:GridView ID="gvSchedule" runat="server"
            CssClass="table table-bordered table-hover align-middle"
            AutoGenerateColumns="False"
            GridLines="None"
            DataKeyNames="ScheduleID"
            EmptyDataText="No schedule records found."
            OnRowCommand="gvSchedule_RowCommand">

            <Columns>
                <asp:BoundField DataField="CourseCode" HeaderText="Course Code" />
                <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                <asp:BoundField DataField="LecturerName" HeaderText="Lecturer" />

                <asp:TemplateField HeaderText="Day">
                    <ItemTemplate>
                        <span class="day-badge">
                            <%# Eval("DayOfWeek") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Time">
                    <ItemTemplate>
                        <span class="schedule-badge">
                            <%# Eval("StartTime") %> - <%# Eval("EndTime") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="Room" HeaderText="Room" />

                <asp:TemplateField HeaderText="Action">
                    <HeaderStyle CssClass="hide-in-export" />
                    <ItemStyle CssClass="hide-in-export" />

                    <ItemTemplate>
                        <asp:Button ID="btnEdit" runat="server"
                            Text="Edit"
                            CssClass="btn btn-sm btn-warning me-1"
                            CommandName="EditSchedule"
                            CommandArgument='<%# Eval("ScheduleID") %>' />

                        <asp:Button ID="btnDelete" runat="server"
                            Text="Delete"
                            CssClass="btn btn-sm btn-danger"
                            CommandName="DeleteSchedule"
                            CommandArgument='<%# Eval("ScheduleID") %>'
                            OnClientClick="return confirm('Are you sure you want to delete this schedule?');" />
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

        </asp:GridView>

    </div>

    <!-- VISUAL TIMETABLE PREVIEW -->
    <div class="section-card">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div class="card-title-wrap">
                <div class="card-title-icon">
                    <i class="fa-solid fa-table-cells-large"></i>
                </div>

                <div>
                    <h4 class="section-title mb-1">Visual Timetable Preview</h4>
                    <p class="text-muted mb-0">
                        Generate a clear and professional timetable image based on schedule day and time arrangement.
                    </p>
                </div>
            </div>
        </div>

        <div class="preview-settings-box">
            <div class="row">
                <div class="col-md-3 mb-3">
                    <label class="form-label">Preview Start Time</label>
                    <input type="time" id="previewStartTime" class="form-control" value="08:00" />
                </div>

                <div class="col-md-3 mb-3">
                    <label class="form-label">Preview End Time</label>
                    <input type="time" id="previewEndTime" class="form-control" value="18:00" />
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label">Show Days</label>

                    <div class="day-selector-group">
                        <label class="day-option"><input type="checkbox" class="preview-day" value="Monday" checked /> Monday</label>
                        <label class="day-option"><input type="checkbox" class="preview-day" value="Tuesday" checked /> Tuesday</label>
                        <label class="day-option"><input type="checkbox" class="preview-day" value="Wednesday" checked /> Wednesday</label>
                        <label class="day-option"><input type="checkbox" class="preview-day" value="Thursday" checked /> Thursday</label>
                        <label class="day-option"><input type="checkbox" class="preview-day" value="Friday" checked /> Friday</label>
                        <label class="day-option"><input type="checkbox" class="preview-day" value="Saturday" /> Saturday</label>
                        <label class="day-option"><input type="checkbox" class="preview-day" value="Sunday" /> Sunday</label>
                    </div>
                </div>
            </div>

            <div class="preview-actions">
                <button type="button" id="btnGeneratePreview" class="btn btn-primary">
                    Generate Preview
                </button>

                <button type="button" id="btnDownloadTimetable" class="btn btn-success">
                    Download Timetable Image
                </button>
            </div>
        </div>

        <div class="timetable-wrapper">
            <div id="timetableCaptureArea">
                <div class="empty-preview">
                    Click <strong>Generate Preview</strong> to show the visual timetable.
                </div>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js"></script>

    <script>
        const fullDayOrder = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

        const blockColors = [
            "#fed7aa",
            "#bae6fd",
            "#bbf7d0",
            "#ddd6fe",
            "#fecdd3",
            "#fde68a",
            "#a5f3fc",
            "#fbcfe8"
        ];

        function loadScheduleData() {
            const hiddenField = document.getElementById("<%= hfScheduleJson.ClientID %>");
            if (!hiddenField || !hiddenField.value) return [];

            try {
                return JSON.parse(hiddenField.value);
            } catch (e) {
                return [];
            }
        }

        function getSelectedDays() {
            return Array.from(document.querySelectorAll(".preview-day:checked")).map(cb => cb.value);
        }

        function timeToMinutes(timeString) {
            if (!timeString) return 0;

            const parts = timeString.split(":");
            const hour = parseInt(parts[0], 10);
            const minute = parseInt(parts[1], 10);

            return (hour * 60) + minute;
        }

        function formatMinutesToLabel(totalMinutes) {
            let hours = Math.floor(totalMinutes / 60);
            let minutes = totalMinutes % 60;
            let suffix = hours >= 12 ? "PM" : "AM";

            if (hours === 0) hours = 12;
            else if (hours > 12) hours = hours - 12;

            const minuteText = minutes.toString().padStart(2, "0");
            return hours + ":" + minuteText + suffix;
        }

        function escapeHtml(text) {
            if (text === null || text === undefined) return "";

            return text.toString()
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#039;");
        }

        function getColorForCourse(courseCode) {
            let sum = 0;

            for (let i = 0; i < courseCode.length; i++) {
                sum += courseCode.charCodeAt(i);
            }

            return blockColors[sum % blockColors.length];
        }

        function createClusters(events) {
            if (events.length === 0) return [];

            const sorted = [...events].sort((a, b) => a.startMinutes - b.startMinutes);
            const clusters = [];
            let currentCluster = [];
            let clusterEnd = -1;

            sorted.forEach(ev => {
                if (currentCluster.length === 0) {
                    currentCluster.push(ev);
                    clusterEnd = ev.endMinutes;
                } else if (ev.startMinutes < clusterEnd) {
                    currentCluster.push(ev);

                    if (ev.endMinutes > clusterEnd) {
                        clusterEnd = ev.endMinutes;
                    }
                } else {
                    clusters.push(currentCluster);
                    currentCluster = [ev];
                    clusterEnd = ev.endMinutes;
                }
            });

            if (currentCluster.length > 0) {
                clusters.push(currentCluster);
            }

            return clusters;
        }

        function assignColumnsToCluster(cluster) {
            const sorted = [...cluster].sort((a, b) => a.startMinutes - b.startMinutes);
            const active = [];
            let maxColumns = 0;

            sorted.forEach(ev => {
                for (let i = active.length - 1; i >= 0; i--) {
                    if (active[i].endMinutes <= ev.startMinutes) {
                        active.splice(i, 1);
                    }
                }

                const usedCols = active.map(x => x.columnIndex);
                let assignedCol = 0;

                while (usedCols.includes(assignedCol)) {
                    assignedCol++;
                }

                ev.columnIndex = assignedCol;
                active.push(ev);

                if (assignedCol + 1 > maxColumns) {
                    maxColumns = assignedCol + 1;
                }
            });

            sorted.forEach(ev => {
                ev.totalColumnsInCluster = maxColumns;
            });
        }

        function renderTimetable() {
            const schedules = loadScheduleData();
            const selectedDays = getSelectedDays();
            const previewStartTime = document.getElementById("previewStartTime").value || "08:00";
            const previewEndTime = document.getElementById("previewEndTime").value || "18:00";

            const startMinutes = timeToMinutes(previewStartTime);
            const endMinutes = timeToMinutes(previewEndTime);

            const captureArea = document.getElementById("timetableCaptureArea");
            captureArea.innerHTML = "";

            if (selectedDays.length === 0) {
                captureArea.innerHTML = '<div class="empty-preview">Please select at least one day.</div>';
                return;
            }

            if (startMinutes >= endMinutes) {
                captureArea.innerHTML = '<div class="empty-preview">Preview end time must be later than preview start time.</div>';
                return;
            }

            const slotInterval = 30;
            const rowHeight = 58;
            const dayColumnWidth = 230;
            const totalSlots = Math.ceil((endMinutes - startMinutes) / slotInterval);
            const gridHeight = totalSlots * rowHeight;
            const totalGridWidth = selectedDays.length * dayColumnWidth;

            const exportCard = document.createElement("div");
            exportCard.className = "tt-export-card";

            const now = new Date();

            exportCard.innerHTML = `
                <div class="tt-export-header">
                    <h3>College Class Timetable</h3>
                    <p>Generated from Student Management System</p>
                    <p>${now.toLocaleString()}</p>
                </div>
            `;

            const headerRow = document.createElement("div");
            headerRow.className = "tt-header-row";

            const timeHeader = document.createElement("div");
            timeHeader.className = "tt-time-header";
            headerRow.appendChild(timeHeader);

            const dayHeaders = document.createElement("div");
            dayHeaders.className = "tt-day-headers";
            dayHeaders.style.width = totalGridWidth + "px";

            selectedDays.forEach(day => {
                const dayHeader = document.createElement("div");
                dayHeader.className = "tt-day-header";
                dayHeader.style.width = dayColumnWidth + "px";
                dayHeader.textContent = day;
                dayHeaders.appendChild(dayHeader);
            });

            headerRow.appendChild(dayHeaders);
            exportCard.appendChild(headerRow);

            const body = document.createElement("div");
            body.className = "tt-body";

            const timeColumn = document.createElement("div");
            timeColumn.className = "tt-time-column";
            timeColumn.style.height = gridHeight + "px";

            for (let m = startMinutes; m <= endMinutes; m += slotInterval) {
                const label = document.createElement("div");
                label.className = "tt-time-label";
                label.style.top = (((m - startMinutes) / slotInterval) * rowHeight) + "px";
                label.textContent = formatMinutesToLabel(m);
                timeColumn.appendChild(label);
            }

            body.appendChild(timeColumn);

            const gridArea = document.createElement("div");
            gridArea.className = "tt-grid-area";
            gridArea.style.width = totalGridWidth + "px";
            gridArea.style.height = gridHeight + "px";

            for (let i = 0; i <= selectedDays.length; i++) {
                const vLine = document.createElement("div");
                vLine.className = "tt-vertical-line";
                vLine.style.left = (i * dayColumnWidth) + "px";
                gridArea.appendChild(vLine);
            }

            for (let i = 0; i <= totalSlots; i++) {
                const hLine = document.createElement("div");
                hLine.className = "tt-horizontal-line";
                hLine.style.top = (i * rowHeight) + "px";

                if (i % 2 === 0) {
                    hLine.classList.add("major");
                }

                gridArea.appendChild(hLine);
            }

            const filteredSchedules = schedules
                .map(item => {
                    return {
                        ScheduleID: item.ScheduleID,
                        CourseCode: item.CourseCode,
                        CourseName: item.CourseName,
                        LecturerName: item.LecturerName,
                        DayOfWeek: item.DayOfWeek,
                        StartTime: item.StartTime,
                        EndTime: item.EndTime,
                        Room: item.Room,
                        startMinutes: timeToMinutes(item.StartTime),
                        endMinutes: timeToMinutes(item.EndTime)
                    };
                })
                .filter(item =>
                    selectedDays.includes(item.DayOfWeek) &&
                    item.endMinutes > startMinutes &&
                    item.startMinutes < endMinutes
                );

            selectedDays.forEach((day, dayIndex) => {
                const daySchedules = filteredSchedules.filter(x => x.DayOfWeek === day);
                const clusters = createClusters(daySchedules);

                clusters.forEach(cluster => {
                    assignColumnsToCluster(cluster);

                    cluster.forEach(item => {
                        const visibleStart = Math.max(item.startMinutes, startMinutes);
                        const visibleEnd = Math.min(item.endMinutes, endMinutes);

                        const blockTop = ((visibleStart - startMinutes) / slotInterval) * rowHeight + 4;
                        const blockHeight = Math.max((((visibleEnd - visibleStart) / slotInterval) * rowHeight) - 8, 46);

                        const colCount = item.totalColumnsInCluster || 1;
                        const singleWidth = dayColumnWidth / colCount;
                        const blockLeft = (dayIndex * dayColumnWidth) + (item.columnIndex * singleWidth) + 6;
                        const blockWidth = singleWidth - 12;

                        const block = document.createElement("div");
                        block.className = "tt-class-block";
                        block.style.top = blockTop + "px";
                        block.style.left = blockLeft + "px";
                        block.style.width = blockWidth + "px";
                        block.style.height = blockHeight + "px";
                        block.style.background = getColorForCourse(item.CourseCode);

                        block.innerHTML = `
                            <div class="tt-class-code">📘 ${escapeHtml(item.CourseCode)}</div>
                            <div class="tt-class-name">${escapeHtml(item.CourseName)}</div>
                            <div class="tt-class-info">👨‍🏫 ${escapeHtml(item.LecturerName)}</div>
                            <div class="tt-class-info">🕒 ${escapeHtml(item.StartTime)} - ${escapeHtml(item.EndTime)}</div>
                            <div class="tt-class-info">📍 ${escapeHtml(item.Room)}</div>
                        `;

                        gridArea.appendChild(block);
                    });
                });
            });

            body.appendChild(gridArea);
            exportCard.appendChild(body);

            const footer = document.createElement("div");
            footer.className = "tt-export-footer";
            footer.textContent = "This timetable is generated automatically based on saved schedule records.";
            exportCard.appendChild(footer);

            captureArea.appendChild(exportCard);
        }

        const generatePreviewButton = document.getElementById("btnGeneratePreview");

        if (generatePreviewButton) {
            generatePreviewButton.addEventListener("click", function () {
                renderTimetable();
            });
        }

        const downloadTimetableButton = document.getElementById("btnDownloadTimetable");

        if (downloadTimetableButton) {
            downloadTimetableButton.addEventListener("click", function () {
                const captureArea = document.getElementById("timetableCaptureArea");

                if (!captureArea || captureArea.innerText.indexOf("Click Generate Preview") !== -1) {
                    alert("Please generate the timetable preview first.");
                    return;
                }

                document.body.classList.add("capture-mode");

                html2canvas(captureArea, {
                    backgroundColor: "#ffffff",
                    scale: 2,
                    useCORS: true
                }).then(function (canvas) {
                    const link = document.createElement("a");
                    link.download = "Visual_Timetable.png";
                    link.href = canvas.toDataURL("image/png");
                    link.click();

                    document.body.classList.remove("capture-mode");
                }).catch(function () {
                    document.body.classList.remove("capture-mode");
                    alert("Failed to download timetable image.");
                });
            });
        }

        window.addEventListener("load", function () {
            renderTimetable();
        });
    </script>

</asp:Content>