<%@ WebHandler Language="C#" Class="destroy" %>

using System;
using System.Web;

public class destroy : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string group_id = context.Request.Params["group_id"];
        SQLHelper sqlHelper = CommWebUtil.GetSQLHelper(context);

        if (NotEmpty(group_id, sqlHelper))
        {
            string error_response = Newtonsoft.Json.JsonConvert.SerializeObject(new { error = "班组下面有人员或机械台账数据，不能删除！" });
            context.Response.StatusCode = 200;
            context.Response.Write(error_response);
        }
        else
        {
            string sql = "delete from t_group where group_id = @group_id";
            System.Collections.Generic.Dictionary<string, object> paramets = new System.Collections.Generic.Dictionary<string, object>();
            paramets.Add("group_id", group_id);
            sqlHelper.ExecuteNotQuery(sql, paramets);
            string success = Newtonsoft.Json.JsonConvert.SerializeObject(new { group_id = group_id });
            context.Response.Write(success);
        }

    }

    /// <summary>
    /// 判断指定班组下是否有数据
    /// </summary>
    /// <param name="groupid"></param>
    /// <returns></returns>
    private bool NotEmpty(string groupid, SQLHelper sqlHelper)
    {
        if (string.IsNullOrEmpty(groupid))
            return false;
        if (sqlHelper == null)
            throw new ArgumentNullException();

        string sql = "select top 1 '1'  from persons where group_id=@group_id";
        System.Collections.Generic.Dictionary<string, object> parameters = new System.Collections.Generic.Dictionary<string, object>();
        parameters.Add("group_id", groupid);
        System.Data.DataTable dt = sqlHelper.ExecuteQuery(sql, parameters);
        if (dt != null && dt.Rows.Count > 0)
            return true;
        sql = "select top 1 '1'  from apparatus where group_id=@group_id";
        dt = sqlHelper.ExecuteQuery(sql, parameters);
        if (dt != null && dt.Rows.Count > 0)
            return true;
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