using System;
using System.Web;
using System.Web.Routing;

namespace College_Management_System
{
    public class Global : HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            RouteConfig.RegisterRoutes(RouteTable.Routes);
        }
    }
}