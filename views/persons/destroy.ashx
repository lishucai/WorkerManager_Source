<%@ WebHandler Language="C#" Class="destroy" %>

using System;
using System.Web;
    using LiuShengFeng.Core;
public class destroy : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
       context.Response.ContentType = "text/plain";
        SQLHelper sqlHelper = CommWebUtil.GetSQLHelper(context);
        System.Data.DataTable dt = CommWebUtil.ExtractData(context, "persons", sqlHelper);
        bool isSuccess = false;
        if (dt != null && dt.Rows.Count > 0)
        {
            if (sqlHelper != null)
            {
                System.Collections.Generic.Dictionary<string,object> conditions = new System.Collections.Generic.Dictionary<string,object>();
                conditions.Add("bianhao", context.Request.Params["models[0][bianhao]"]);
                conditions.Add("group_id", context.Request.Params["models[0][group_id]"]);
                
                if (sqlHelper.Delete("persons", conditions ) > 0)
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