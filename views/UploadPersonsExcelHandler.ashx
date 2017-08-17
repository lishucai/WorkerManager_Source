<%@ WebHandler Language="C#" Class="UploadPersonsExcelHandler" %>

using System;
using System.Web;
using System.Collections.Generic;
using System.Data;
    using LiuShengFeng.Core;
public class UploadPersonsExcelHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
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

        ExcelTemplete templ = new PersonsExcelTemplete();
        List<ExcelTemplete> templetes = new List<ExcelTemplete>() { templ };
        ExcelReader reader = new ExcelReader();
        HttpPostedFile f = context.Request.Files[0];
        DataSet ds = reader.Extract(f.InputStream, templetes);
        GenericHelper.AppendColumn(ds, "group_id", groupId);

        //修改编号列数据
        if (ds != null && ds.Tables.Contains(templ.TableName))
        {
            SQLHelper sqlHelper = CommWebUtil.GetSQLHelper(context);
            System.Data.SqlClient.SqlTransaction trans = sqlHelper.BeginTransaction();
            DataTable dt = ds.Tables[templ.TableName];
            if (dt.Columns.Contains("bianhao"))
            {
                    PeronsDAO dao = new PeronsDAO(sqlHelper);

                int nextNo = dao. generatNextNo(groupId, sqlHelper, trans);
                string prefix =dao. encodingBianhao(groupId, sqlHelper);
                foreach (DataRow dr in dt.Rows)
                {
                    string bianhao = string.Format("{0}{1:000}", prefix, nextNo);
                    dr["bianhao"] = bianhao;
                    nextNo++;
                }
            }
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