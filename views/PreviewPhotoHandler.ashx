<%@ WebHandler Language="C#" Class="PreviewPhotoHandler" %>

using System;
using System.Web;
    using LiuShengFeng.Core;

public class PreviewPhotoHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "image/jpeg";
        string bianhao = context.Request.Params["bianhao"] ?? string.Empty;
        string groupId = context.Request.Params["groupid"] ?? string.Empty; 
        string photo = "/images/user.ico";
        SQLHelper sqlHelper = CommWebUtil.GetSQLHelper(context);
        if (sqlHelper != null)
        {
            string sql = "select photo from persons where bianhao=@bianhao and group_Id=@groupId";
            System.Collections.Generic.Dictionary<string, object> parameters = new System.Collections.Generic.Dictionary<string, object>();
            parameters.Add("@bianhao", bianhao);
            parameters.Add("@groupId", groupId);
            System.Data.DataTable dt = sqlHelper.ExecuteQuery(sql, parameters);
            if (dt != null && dt.Rows.Count > 0)
                photo = dt.Rows[0][0] + "";

        }
        if (System.IO.File.Exists(photo))
            context.Response.WriteFile(photo);
        else
            context.Response.WriteFile("/images/user.ico");
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}