using System;
using System.Web;
using System.Web.SessionState;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.IO;
public class PageFilter : IHttpModule
{
    public String ModuleName
    {
        get { return "PageFilter"; }
    }

    public void Dispose()
    {

    }

    //在 Init 方法中注册HttpApplication 
    // 通过委托方式注册事件
    public void Init(HttpApplication application)
    {
        application.AcquireRequestState += new EventHandler(Application_AcquireRequestState);
    }
    private void Application_AcquireRequestState(Object source, EventArgs e)
    {
        HttpApplication application = (HttpApplication)source;
        HttpContext context = application.Context;

        HttpSessionState session = context.Session;
        HttpResponse response = context.Response;
        Dictionary<string, object> loginUser = context.Session[Resources.LOGIN_USER_INFO] as Dictionary<string, object>;
        string targetUrl = "/views/login.aspx";

        if (loginUser != null)
        {
            string role = loginUser["role_id"] as string;

            switch (role)
            {
                case "0": //管理员
                    targetUrl = "UserManager.aspx";
                    break;
                case "1"://普通用户
                case "2"://高级用户
                    targetUrl = "Default.aspx";
                    break;
                default:
                    break;
            }
        }
        if (context.Request.Path != targetUrl)
            response.Redirect(targetUrl);
    }
}