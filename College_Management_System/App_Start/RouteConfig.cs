using System.Web.Routing;
using Microsoft.AspNet.FriendlyUrls;

namespace College_Management_System
{
    public static class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            var settings = new FriendlyUrlSettings();

            // Stop ASP.NET from changing Login.aspx to /Login
            settings.AutoRedirectMode = RedirectMode.Off;

            routes.EnableFriendlyUrls(settings);
        }
    }
}