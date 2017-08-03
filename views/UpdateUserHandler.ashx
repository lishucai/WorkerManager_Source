<%@ WebHandler Language="C#" Class="UpdateUserHandler" %>

using System;
using System.Web;

public class UpdateUserHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        string newPasword = context.Request.Params["new_password"];
        if (!string.IsNullOrEmpty(newPasword))
        {
            SystemUserInfo loginUser = context.Session[Resources.LOGIN_USER_INFO] as SystemUserInfo;
            if (loginUser != null)
            {
                loginUser.LoginPassword = GenericHelper.GetStrMd5( newPasword);
                SystemUserDAO dao = new SystemUserDAO();
                SQLHelper sqlHelper = CommWebUtil.GetSQLHelper(context);
                dao.UpdateUser(loginUser, sqlHelper);
            }
        }

        context.Response.Write("Hello World");
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}