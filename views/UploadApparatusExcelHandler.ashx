<%@ WebHandler Language="C#" Class="UploadApparatusExcelHandler" %>

using System;
using System.Web;
    using LiuShengFeng.Core;
public class UploadApparatusExcelHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        handleUpload(context);

        context.Response.Write(string.Empty);
    }

    private void handleUpload(HttpContext context)
    {
        if (context == null)
            return;
        string groupId = context.Request.Params["groupid"] ?? string.Empty;

        ExcelTemplete templ = new ApparatusExcelTemplete();
        System.Collections.Generic.List<ExcelTemplete> templetes = new System.Collections.Generic.List<ExcelTemplete>() { templ };
        ExcelReader reader = new ExcelReader();
        HttpPostedFile f = context.Request.Files[0];
        System.Data.DataSet ds = reader.Extract(f.InputStream, templetes);
        GenericHelper.AppendColumn(ds, "group_id", groupId);

        
        if (ds != null && ds.Tables.Contains(templ.TableName))
        {
            SQLHelper sqlHelper = CommWebUtil.GetSQLHelper(context);
            System.Data.SqlClient.SqlTransaction trans = sqlHelper.BeginTransaction();
            System.Data.DataTable dt = ds.Tables[templ.TableName];
            sqlHelper.Save(dt, trans);
            sqlHelper.Commit(trans);
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