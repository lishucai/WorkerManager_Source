<%@ WebHandler Language="C#" Class="NewGroupsHandler" %>

using System;
using System.Web;
    using LiuShengFeng.Core;
public class NewGroupsHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        SQLHelper sqlHelper = CommWebUtil.GetSQLHelper(context);
        string sql = "insert into t_group(parentid) values(@parentid)";
        System.Collections.Generic.Dictionary<string, object> paramets = new System.Collections.Generic.Dictionary<string, object>();
        SystemUserInfo loginUser = context.Session[Resources.LOGIN_USER_INFO] as SystemUserInfo;
        string parentid = loginUser.Groups[0].Id;
        paramets.Add("parentid", parentid);
        System.Data.SqlClient.SqlTransaction trans = sqlHelper.BeginTransaction();
        sqlHelper.ExecuteNotQuery(sql, trans, paramets);
        sql = "select max(group_id) as group_id  from t_group";

        System.Data.DataTable dt = sqlHelper.ExecuteQuery(sql, trans);
        if (dt != null && dt.Rows.Count > 0)
        {
            string group_id = dt.Rows[0]["group_id"] + "";
            string tree_id = loginUser.Groups[0].Treeid +  group_id +"|"  ;

            sql = "update t_group set tree_id=@tree_id where group_id=@group_id";
            paramets.Clear();
            paramets.Add("tree_id", tree_id);
            paramets.Add("group_id", group_id);
            sqlHelper.ExecuteNotQuery(sql, trans, paramets);

            sqlHelper.Commit(trans);
            string jsonData = Newtonsoft.Json.JsonConvert.SerializeObject(new { group_id = group_id, parentid = parentid });
            context.Response.Write(jsonData);
        }
        else
        {
            sqlHelper.Rollback(trans);
            string error_response = Newtonsoft.Json.JsonConvert.SerializeObject(new { error = "添加失败！" });
            context.Response.StatusCode = 200;
            context.Response.Write(error_response);
        }


    }

    /// <summary>
    /// 判断班组名称是否重复
    /// </summary>
    /// <param name="name"></param>
    /// <param name="sqlHelper"></param>
    /// <returns></returns>
    private bool isDuplicatedName(string name, SQLHelper sqlHelper)
    {
        if (string.IsNullOrEmpty(name))
            return false;
        if (sqlHelper == null)
            throw new ArgumentNullException();
        string sql = "select 1 from t_group where group_name=@group_name";
        System.Collections.Generic.Dictionary<string, object> parameters = new System.Collections.Generic.Dictionary<string, object>();
        parameters.Add("group_name", name);
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