using System;

namespace College_Management_System
{
    public partial class StudentMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(
        object sender,
        EventArgs e)
        {
            if (Session["StudentID"] == null)
            {
                RedirectToStudentLogin();
                return;
            }


        int studentID;

            if (!int.TryParse(
                Session["StudentID"].ToString(),
                out studentID)
                || studentID <= 0)
            {
                Session.Clear();
                Session.Abandon();

                RedirectToStudentLogin();
                return;
            }

            if (!IsPostBack)
            {
                LoadStudentInformation();
            }
        }

        private void LoadStudentInformation()
        {
            string studentName =
                "Student";

            if (
                Session["StudentName"] != null
                && !string.IsNullOrWhiteSpace(
                    Session["StudentName"].ToString()
                )
            )
            {
                studentName =
                    Session["StudentName"]
                        .ToString()
                        .Trim();
            }

            lblMasterStudentName.Text =
                Server.HtmlEncode(
                    studentName
                );

            if (
                !string.IsNullOrWhiteSpace(
                    studentName
                )
            )
            {
                lblMasterStudentInitial.Text =
                    Server.HtmlEncode(
                        studentName
                            .Substring(0, 1)
                            .ToUpper()
                    );
            }
            else
            {
                lblMasterStudentInitial.Text =
                    "S";
            }
        }

        protected void btnMasterLogout_Click(
            object sender,
            EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect(
                ResolveUrl(
                    "~/StudentLogin.aspx"
                ),
                false
            );

            Context.ApplicationInstance
                .CompleteRequest();
        }

        private void RedirectToStudentLogin()
        {
            Response.Redirect(
                ResolveUrl(
                    "~/StudentLogin.aspx"
                ),
                false
            );

            Context.ApplicationInstance
                .CompleteRequest();
        }
    }


}
