<%@ Page Language="C#" AutoEventWireup="true"
MasterPageFile="~/StudentMaster.Master"
CodeBehind="StudentEnrolment.aspx.cs"
Inherits="College_Management_System.StudentEnrolment" %>

<asp:Content ID="HeadContent"
ContentPlaceHolderID="HeadContent"
runat="server">


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
        margin-bottom: 5px;
    }

    .section-subtitle {
        color: #64748b;
        margin-bottom: 20px;
    }

    .alert-message {
        display: block;
        border-radius: 14px;
        padding: 12px 16px;
        margin-bottom: 18px;
        font-weight: 600;
    }

    .table-responsive {
        overflow-x: auto;
        border-radius: 16px;
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
        white-space: nowrap;
    }

    .table tbody td {
        padding: 14px;
        color: #334155;
        vertical-align: middle;
    }

    .course-code {
        display: inline-block;
        padding: 7px 13px;
        border-radius: 999px;
        font-size: 13px;
        font-weight: 800;
        background: #ccfbf1;
        color: #0f766e;
    }

    .status-badge {
        display: inline-block;
        min-width: 90px;
        padding: 7px 13px;
        border-radius: 999px;
        font-size: 13px;
        font-weight: 800;
        text-align: center;
    }

    .status-enrolled {
        background: #dcfce7;
        color: #15803d;
    }

    .status-dropped {
        background: #fee2e2;
        color: #b91c1c;
    }

    .status-available {
        background: #e0f2fe;
        color: #0369a1;
    }

    .btn-enrol {
        background: #0f766e;
        color: white;
        border: none;
        border-radius: 999px;
        padding: 8px 18px;
        font-weight: 700;
        transition: 0.25s;
    }

    .btn-enrol:hover {
        background: #115e59;
        color: white;
        transform: translateY(-2px);
    }

    .btn-drop {
        background: #dc2626;
        color: white;
        border: none;
        border-radius: 999px;
        padding: 8px 18px;
        font-weight: 700;
        transition: 0.25s;
    }

    .btn-drop:hover {
        background: #b91c1c;
        color: white;
        transform: translateY(-2px);
    }

    .action-buttons {
        display: flex;
        align-items: center;
        gap: 8px;
        flex-wrap: wrap;
    }

    .information-box {
        margin-top: 22px;
        padding: 15px 18px;
        border-left: 4px solid #0f766e;
        border-radius: 12px;
        background: #f0fdfa;
        color: #475569;
        font-size: 14px;
        font-weight: 600;
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

<asp:Content ID="MainContent"
ContentPlaceHolderID="MainContent"
runat="server">


<div class="topbar">

    <div>
        <h2 class="page-title">Course Enrolment</h2>

        <p class="page-subtitle">
            View available courses, enrol into subjects or drop an enrolled course.
        </p>
    </div>

    <div class="student-avatar">
        <asp:Label ID="lblInitial"
            runat="server"
            Text="S">
        </asp:Label>
    </div>

</div>

<div class="section-card">

    <h4 class="section-title">Available Courses</h4>

    <p class="section-subtitle">
        Manage your course enrolment from the list below.
    </p>

    <asp:Label ID="lblMsg"
        runat="server"
        Visible="false">
    </asp:Label>

    <div class="table-responsive">

        <asp:GridView ID="gvCourses"
            runat="server"
            CssClass="table table-hover"
            AutoGenerateColumns="False"
            GridLines="None"
            EmptyDataText="No courses found."
            OnRowCommand="gvCourses_RowCommand"
            DataKeyNames="CourseID">

            <Columns>

                <asp:BoundField DataField="CourseID"
                    HeaderText="ID" />

                <asp:TemplateField HeaderText="Course Code">
                    <ItemTemplate>

                        <span class="course-code">
                            <%# Eval("CourseCode") %>
                        </span>

                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="CourseName"
                    HeaderText="Course Name" />

                <asp:BoundField DataField="CreditHours"
                    HeaderText="Credit Hours" />

                <asp:BoundField DataField="ProgrammeName"
                    HeaderText="Programme" />

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>

                        <span class='<%# GetStatusClass(Eval("EnrolmentStatus").ToString()) %>'>
                            <%# GetStatusText(Eval("EnrolmentStatus").ToString()) %>
                        </span>

                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>

                        <div class="action-buttons">

                            <asp:Button ID="btnEnrol"
                                runat="server"
                                Text="Enrol Now"
                                CssClass="btn-enrol"
                                CommandName="EnrolCourse"
                                CommandArgument='<%# Eval("CourseID") %>'
                                Visible='<%# Convert.ToInt32(Eval("IsEnrolled")) == 0 %>'
                                CausesValidation="false" />

                            <asp:Button ID="btnDrop"
                                runat="server"
                                Text="Drop Course"
                                CssClass="btn-drop"
                                CommandName="DropCourse"
                                CommandArgument='<%# Eval("CourseID") %>'
                                Visible='<%# Convert.ToInt32(Eval("IsEnrolled")) == 1 %>'
                                CausesValidation="false"
                                OnClientClick="return confirm('Are you sure you want to drop this course?');" />

                        </div>

                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

        </asp:GridView>

    </div>

    <div class="information-box">
        Dropping a course changes its enrolment status to Dropped.
        The record is not permanently deleted, so the system can retain
        accurate enrolment history for reporting and auditing.
    </div>

</div>


</asp:Content>
