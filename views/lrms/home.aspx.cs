using LiuShengFeng.Core;
using System;
public partial class views_lrms_home : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        SystemUserInfo loginUser = Session[Resources.LOGIN_USER_INFO] as SystemUserInfo;
        if (loginUser == null)
            Response.Redirect("/Default.aspx");
        else
        {
            LoadModelList();
        }
    }

    //加载模型列表
    private void LoadModelList()
    {
        SQLHelper sqlHelper = CommWebUtil.GetSQLHelper(this.Context);
        if (sqlHelper == null)
            return;
        string sql = @"SELECT  [model_id]
                      ,[model_name]
                      ,[model_desc]
                      ,[urn]
                      ,[target_name]
                  FROM[t_models]";
        System.Data.DataTable dt = sqlHelper.ExecuteQuery(sql);
        if(dt != null)
        {
            foreach(System.Data.DataRow dr in dt.Rows)
            {
                string urn = dr["urn"] + "";
                string modelName = dr["model_name"] + "";
                string link = "<li><a href='#'  onclick=\"return ViewProcess('/views/3dModels/viewer.aspx?urn={0}')\">{1}</a></li>";
                link = string.Format(link, urn, modelName);
                ul_models_mng.InnerHtml += link;
            }
        }
    }
}