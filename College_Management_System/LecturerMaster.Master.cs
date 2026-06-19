using System;

namespace College_Management_System
{
    public partial class LecturerMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["LecturerID"] == null)
            {
                Response.Redirect("LecturerLogin.aspx");
                return;
            }
        }

        protected void btnMasterLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("LecturerLogin.aspx");
        }
    }
}