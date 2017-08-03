<%@ WebHandler Language="C#" Class="LoadGroupsHandler2" %>

using System;
using System.Web;
using System.Web.SessionState;
public class LoadGroupsHandler2 : IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        SQLHelper sqlHeler = CommWebUtil.GetSQLHelper(context);
        try
        {
            String sql = @" SELECT [group_id] as value
                                ,[group_name] as text
                            FROM [t_group]";
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