<%@ WebHandler Language="C#" Class="create" %>

using System;
using System.Web;

public class create : IHttpHandler
{


    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        SQLHelper sqlHelper = CommWebUtil.GetSQLHelper(context);
        System.Data.DataTable dt =CommWebUtil. ExtractData(context,"persons", sqlHelper);
        bool isSuccess = false;
        if (dt != null && dt.Rows.Count > 0)
        {
            if (sqlHelper != null)
            {
                PeronsDAO dao = new PeronsDAO(sqlHelper);
                System.Data.SqlClient.SqlTransaction trans = sqlHelper.BeginTransaction();
                string groupid = context.Request.Params["groupid"];
                int nextNo = dao.generatNextNo(groupid, sqlHelper, trans);
                string prefix = dao.encodingBianhao(groupid, sqlHelper);
                string bianhao = string.Format("{0}{1:000}", prefix, nextNo);
                dt.Rows[0]["bianhao"] = bianhao;
                dt.Rows[0]["group_id"] = groupid;
                dt.TableName = "persons";
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

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}