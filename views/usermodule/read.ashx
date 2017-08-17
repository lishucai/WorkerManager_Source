<%@ WebHandler Language="C#" Class="read" %>

using System;
using System.Web;
using LiuShengFeng.Core;
public class read : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        SQLHelper sqlHeler = CommWebUtil.GetSQLHelper(context);
        try
        {
            String sql = @"  select user_id, user_name, login_name, login_password, '' role_name
                          from t_user u";
            System.Data.DataTable dt = sqlHeler.ExecuteQuery(sql);
            string jsonData = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            context.Response.Write(jsonData);
        }
        catch (Exception)
        {
            context.Response.StatusCode = 200;
            context.Response.Write(@"{ ""myerrors"": [""获取数据失败！""] }");
            throw;
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}