<%@ WebHandler Language="C#" Class="LogoutHandler" %>

using System;
using System.Web;

using System.Web.SessionState;
public class LogoutHandler : IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        context.Session.Remove(Resources.LOGIN_USER_INFO);
        context.Response.Redirect(CommWebUtil.AppendQueryString("/Default.aspx", context));
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}