<%@ WebHandler Language="C#" Class="GetTokenHandler" %>

using System;
using System.Web;

public class GetTokenHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string response = CommWebUtil.SendHttpRequest("https://developer.api.autodesk.com/authentication/v1/authenticate");
        context.Response.Write(response);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}