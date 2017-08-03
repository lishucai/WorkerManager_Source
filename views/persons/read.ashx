<%@ WebHandler Language="C#" Class="read" %>

using System;
using System.Web;
using System.Web.SessionState;
public class read : IHttpHandler,IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        SQLHelper sqlHeler = CommWebUtil.GetSQLHelper(context);
        try
        {
            SystemUserInfo loginUser =context.Session[Resources.LOGIN_USER_INFO] as SystemUserInfo;
            string groupId =  context.Request.Params["groupid"] ?? string.Empty;
         // string whereClause = " where  bianhao is not null  ";
           string whereClause = " where 1=1   ";
            if (!string.IsNullOrEmpty(groupId))
                whereClause += " and group_id = '" + groupId + "'";
            //else
            //    whereClause += " and group_id is null";

            string orderClause = " order by bianhao ";

            String sql = string.Format(@"SELECT *  FROM [{0}]" + whereClause + orderClause, context.Request.Params["t"]);
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