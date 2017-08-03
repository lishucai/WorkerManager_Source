<%@ WebHandler Language="C#" Class="update" %>

using System;
using System.Web;

public class update : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        SQLHelper sqlHelper = CommWebUtil.GetSQLHelper(context);
        System.Data.DataTable dt = CommWebUtil.ExtractData(context, "apparatus", sqlHelper);
        bool isSuccess = false;
        if (dt != null && dt.Rows.Count > 0)
        {
            if (sqlHelper != null)
            {
                System.Collections.Generic.List<string> conditions = new System.Collections.Generic.List<string>();
                conditions.Add("bianhao");
                conditions.Add("group_id");
                
                if (sqlHelper.Update(dt, conditions) > 0)
                {
                    isSuccess = true;
                }
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