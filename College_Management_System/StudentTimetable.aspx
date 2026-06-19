<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/StudentMaster.Master"
    CodeBehind="StudentTimetable.aspx.cs"
    Inherits="College_Management_System.StudentTimetable" %>

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
        }

        .settings-box {
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
            padding: 8px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 999px;
            background: #ffffff;
            cursor: pointer;
            font-size: 14px;
            user-select: none;
            font-weight: 600;
            transition: 0.2s ease;
        }

        .day-option:hover {
            background: #ecfeff;
            border-color: #5eead4;
        }

        .day-option input {
            margin: 0;
            accent-color: #0f766e;
        }

        .timetable-wrapper {
            background: linear-gradient(135deg, #ecfeff, #f0fdfa);
            border: 1px solid #cbd5e1;
            border-radius: 28px;
            padding: 26px;
            overflow: auto;
        }

        .tt-export-card {
            background: #ffffff;
            border-radius: 28px;
            padding: 26px;
            min-width: 1180px;
            border: 1px solid #ccfbf1;
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.12);
        }

        .tt-export-header {
            text-align: left;
            margin-bottom: 24px;
            padding: 26px 30px;
            border-radius: 24px;
            background: linear-gradient(135deg, #0f766e, #0f172a);
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
            background: rgba(45, 212, 191, 0.22);
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
            color: #ccfbf1;
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
            background: linear-gradient(180deg, #f8fafc, #ecfeff);
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

    <asp:HiddenField ID="hfStudentName" runat="server" />
    <asp:HiddenField ID="hfScheduleJson" runat="server" />

    <!-- Topbar -->
    <div class="topbar">
        <div>
            <h2 class="page-title">My Timetable</h2>
            <p class="page-subtitle">
                Your personal class timetable is generated based on your enrolled courses.
            </p>
        </div>

        <div class="student-avatar">
            <asp:Label ID="lblInitial" runat="server" Text="S"></asp:Label>
        </div>
    </div>

    <!-- Timetable Section -->
    <div class="section-card">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h4 class="section-title mb-1">Visual Timetable</h4>
                <p class="text-muted mb-0">
                    Generate and download your schedule as an image.
                </p>
            </div>
        </div>

        <div class="settings-box">
            <div class="row">
                <div class="col-md-3 mb-3">
                    <label class="form-label">Start Time</label>
                    <input type="time" id="previewStartTime" class="form-control" value="08:00" />
                </div>

                <div class="col-md-3 mb-3">
                    <label class="form-label">End Time</label>
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

            <div class="d-flex flex-wrap gap-2">
                <button type="button" id="btnGeneratePreview" class="btn btn-primary">
                    Generate Timetable
                </button>

                <button type="button" id="btnDownloadTimetable" class="btn btn-success">
                    Download Timetable Image
                </button>
            </div>
        </div>

        <div class="timetable-wrapper">
            <div id="timetableCaptureArea">
                <div class="empty-preview">
                    Click <strong>Generate Timetable</strong> to show your timetable.
                </div>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js"></script>

    <script>
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

        function getStudentName() {
            const hiddenField = document.getElementById("<%= hfStudentName.ClientID %>");
            if (!hiddenField || !hiddenField.value) return "Student";
            return hiddenField.value;
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
                captureArea.innerHTML = '<div class="empty-preview">End time must be later than start time.</div>';
                return;
            }

            if (schedules.length === 0) {
                captureArea.innerHTML = '<div class="empty-preview">No timetable found. Please enrol in courses that already have schedules.</div>';
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
            const studentName = getStudentName();

            exportCard.innerHTML = `
                <div class="tt-export-header">
                    <h3>${escapeHtml(studentName)}'s Timetable</h3>
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
            footer.textContent = "This timetable is generated automatically based on your enrolled courses.";
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

                if (!captureArea || captureArea.innerText.indexOf("Click Generate Timetable") !== -1) {
                    alert("Please generate the timetable first.");
                    return;
                }

                html2canvas(captureArea, {
                    backgroundColor: "#ffffff",
                    scale: 2,
                    useCORS: true
                }).then(function (canvas) {
                    const studentName = getStudentName().replace(/\s+/g, "_");
                    const link = document.createElement("a");
                    link.download = studentName + "_Timetable.png";
                    link.href = canvas.toDataURL("image/png");
                    link.click();
                }).catch(function () {
                    alert("Failed to download timetable image.");
                });
            });
        }

        window.addEventListener("load", function () {
            renderTimetable();
        });
    </script>

</asp:Content>