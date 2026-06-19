using System;

namespace College_Management_System
{
    public partial class AdminMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminEmail"] == null)
            {
                Response.Redirect(
                ResolveUrl("~/Login.aspx"),
                false
                );


            Context.ApplicationInstance.CompleteRequest();
                return;
            }
        }

        protected void btnMasterLogout_Click(
            object sender,
            EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect(
                ResolveUrl("~/Login.aspx"),
                false
            );

            Context.ApplicationInstance.CompleteRequest();
        }
    }


}
