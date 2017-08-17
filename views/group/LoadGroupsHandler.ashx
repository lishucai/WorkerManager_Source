<%@ WebHandler Language="C#" Class="LoadGroupsHandler" %>

using System;
using System.Web;
using System.Web.SessionState;
    using LiuShengFeng.Core;
public class LoadGroupsHandler : IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        SQLHelper sqlHeler = CommWebUtil.GetSQLHelper(context);
        try
        {
            SystemUserInfo loginUser = context.Session[Resources.LOGIN_USER_INFO] as SystemUserInfo;


            String sql = @" SELECT ROW_NUMBER() OVER (ORDER BY group_id) AS No,[group_id]
                          ,[group_name]
                          ,[group_desc]
                          ,[parentid]
                            ,[group_id] as value
                          ,[group_name] as text
                        FROM [t_group]";
            string whereClause = "where 1 = 2 ";
            if (loginUser != null)
            {
                //获取当前用户所在部门及子部门的数据 
                if (loginUser.Groups != null && loginUser.Groups.Count > 0)
                {
                    UserGroup g = loginUser.Groups[0];
                    if (g != null)
                    {

                        whereClause += " or tree_id like  '" + g.Treeid + "%'";

                    }
                }
            }

            sql += whereClause;
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