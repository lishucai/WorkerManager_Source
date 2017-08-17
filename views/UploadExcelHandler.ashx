<%@ WebHandler Language="C#" Class="UploadExcelHandler" %>

using System;
using System.Web;
using System.Collections.Generic;
using System.Data;
    using LiuShengFeng.Core;
public class UploadExcelHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
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
        List<ExcelTemplete> templetes = new List<ExcelTemplete>() { new PersonsExcelTemplete(), new ApparatusExcelTemplete() };
        ExcelReader reader = new ExcelReader();
        HttpPostedFile f = context.Request.Files[0];
        DataSet ds = reader.Extract(f.InputStream, templetes);
        SystemUserInfo loginUser = context.Session[Resources.LOGIN_USER_INFO] as SystemUserInfo;
        string groupId =  context.Request.Params["groupid"] ?? string.Empty; 
        GenericHelper.AppendColumn(ds, "group_id", groupId);
        SQLHelper sqlHelper = CommWebUtil.GetSQLHelper(context);
        Dictionary<string, object> dict = new Dictionary<string, object>();
        dict.Add("group_id", groupId);
        foreach (DataTable dt in ds.Tables)
            sqlHelper.Delete(dt.TableName, dict);
        sqlHelper.Save(ds);

    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}