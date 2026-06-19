using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace College_Management_System
{
    public partial class Programme : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminEmail"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProgramme();
            }
        }

        private void LoadProgramme()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT ProgrammeID, ProgrammeName, ProgrammeCode FROM Programme";

                using (SqlDataAdapter da = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvProgramme.DataSource = dt;
                    gvProgramme.DataBind();
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (txtName.Text == "" || txtCode.Text == "")
            {
                lblMsg.CssClass = "text-danger";
                lblMsg.Text = "Please fill in all fields.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    INSERT INTO Programme (ProgrammeName, ProgrammeCode)
                    VALUES (@ProgrammeName, @ProgrammeCode)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ProgrammeName", txtName.Text);
                    cmd.Parameters.AddWithValue("@ProgrammeCode", txtCode.Text);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            lblMsg.CssClass = "text-success";
            lblMsg.Text = "Programme saved successfully.";

            txtName.Text = "";
            txtCode.Text = "";

            LoadProgramme();
        }

        protected void gvProgramme_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvProgramme.EditIndex = e.NewEditIndex;
            LoadProgramme();
        }

        protected void gvProgramme_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvProgramme.EditIndex = -1;
            LoadProgramme();
        }

        protected void gvProgramme_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int programmeID = Convert.ToInt32(gvProgramme.DataKeys[e.RowIndex].Value);

            GridViewRow row = gvProgramme.Rows[e.RowIndex];

            string programmeName = ((TextBox)row.Cells[1].Controls[0]).Text;
            string programmeCode = ((TextBox)row.Cells[2].Controls[0]).Text;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    UPDATE Programme
                    SET ProgrammeName = @ProgrammeName,
                        ProgrammeCode = @ProgrammeCode
                    WHERE ProgrammeID = @ProgrammeID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ProgrammeName", programmeName);
                    cmd.Parameters.AddWithValue("@ProgrammeCode", programmeCode);
                    cmd.Parameters.AddWithValue("@ProgrammeID", programmeID);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            gvProgramme.EditIndex = -1;
            LoadProgramme();

            lblMsg.CssClass = "text-success";
            lblMsg.Text = "Programme updated successfully.";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("Login.aspx");
        }
    }
}