<%@ WebHandler Language="C#" Class="update" %>

using System;
using System.Web;

public class update : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        string group_name = context.Request.Params["group_name"] ?? string.Empty;
        string group_desc = context.Request.Params["group_desc"] ?? string.Empty;
        string group_id = context.Request.Params["group_id"];
        string parentid = context.Request.Params["parentid"];

        SQLHelper sqlHelper = CommWebUtil.GetSQLHelper(context);
        if (isDuplicatedName(group_name, parentid, group_id, sqlHelper))
        {
            string error_response = Newtonsoft.Json.JsonConvert.SerializeObject(new { error = "该班组名称已经存在！" });
            context.Response.StatusCode = 200;
            context.Response.Write(error_response);
        }
        else
        {
            string sql = "update t_group set group_name=@group_name, group_desc=@group_desc   where group_id=@group_id";
            System.Collections.Generic.Dictionary<string, object> paramets = new System.Collections.Generic.Dictionary<string, object>();
            paramets.Add("group_name", group_name);
            paramets.Add("group_desc", group_desc);
            paramets.Add("group_id", group_id);
            SystemUserInfo loginUser = context.Session[Resources.LOGIN_USER_INFO] as SystemUserInfo;

            sqlHelper.ExecuteNotQuery(sql, paramets);

            string jsonData = Newtonsoft.Json.JsonConvert.SerializeObject(new { group_id = group_id, group_name = group_name, group_desc = group_desc, parentid = parentid });
            context.Response.Write(jsonData);
        }
    }

    /// <summary>
    /// 判断班组名称是否重复
    /// </summary>
    /// <param name="name"></param>
    /// <param name="sqlHelper"></param>
    /// <returns></returns>
    private bool isDuplicatedName(string name, string parentid, string group_id, SQLHelper sqlHelper)
    {
        if (string.IsNullOrEmpty(name))
            return false;
        if (sqlHelper == null)
            throw new ArgumentNullException();
        string sql = "select 1 from t_group where group_name=@group_name and group_id!=@group_id and parentid=@parentid ";
        System.Collections.Generic.Dictionary<string, object> parameters = new System.Collections.Generic.Dictionary<string, object>();
        parameters.Add("group_name", name);
        parameters.Add("parentid", parentid);
        parameters.Add("group_id", group_id);
        System.Data.DataTable dt = sqlHelper.ExecuteQuery(sql, parameters);
        if (dt != null && dt.Rows.Count > 0)
            return true;
        else
            return false;
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}