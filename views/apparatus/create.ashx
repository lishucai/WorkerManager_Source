<%@ WebHandler Language="C#" Class="create" %>

using System;
using System.Web;
    using LiuShengFeng.Core;

public class create : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
         context.Response.ContentType = "text/plain";
        SQLHelper sqlHelper = CommWebUtil.GetSQLHelper(context);
        System.Data.DataTable dt =CommWebUtil. ExtractData(context,"apparatus", sqlHelper);
        bool isSuccess = false;
        if (dt != null && dt.Rows.Count > 0)
        {
            if (sqlHelper != null)
            {
                ApparatusDAO dao = new ApparatusDAO();
                System.Data.SqlClient.SqlTransaction trans = sqlHelper.BeginTransaction();
                string groupid = context.Request.Params["groupid"];
                int nextNo = dao.generatNextNo(groupid, sqlHelper, trans);
                dt.Rows[0]["bianhao"] = nextNo;
                dt.Rows[0]["group_id"] = groupid;
                dt.TableName = "apparatus";
                if (sqlHelper.Save(dt, trans) > 0)
                {
                    isSuccess = true;
                }
                sqlHelper.Commit(trans);
            }
        }
        if (isSuccess)
        {
            string jsonData = Newtonsoft.Json.JsonConvert.SerializeObject(GenericHelper.Parse(dt));
            context.Response.Write(jsonData);
        }
        else
        {
            context.Response.Write("");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}