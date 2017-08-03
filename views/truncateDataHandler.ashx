<%@ WebHandler Language="C#" Class="truncateDataHandler" %>

using System;
using System.Web;

public class truncateDataHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        string table = context.Request.Params["table"];
        string groupid = context.Request.Params["groupid"];

        SQLHelper sqlHelper = CommWebUtil.GetSQLHelper(context);
        if (sqlHelper != null)
        {
            string sql = "delete from {0} where group_id={1}";
            sql = string.Format(sql, table, groupid);
            if (sqlHelper.ExecuteNotQuery(sql) > 0)
            {
                context.Response.Write("success");
            }
            else
            {
                context.Response.Write("failure");
            }
        }
        else
        {
            context.Response.Write("failure");
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