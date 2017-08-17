using LiuShengFeng.Core;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        SystemUserInfo loginUser = Session[Resources.LOGIN_USER_INFO] as SystemUserInfo;
        logout.HRef = CommWebUtil.AppendQueryString("LogoutHandler.ashx", Request);
        Dictionary<string, string>[] data = GetRequestData();
        //判断是否为游客
        if (loginUser == null /*&& Request.Params["is_guest_login"] != null*/)
        {
            DoPhoto(data);
            DoGuestRequest(data);
            logout.InnerHtml = "使用账号登录";
        }
        else if (loginUser != null)
        {
            logout.InnerHtml = "退出";
            int roleLevel = 0;
            roleLevel = loginUser.Roles.Max<SystemRole>(x => int.Parse(x.RoleLevel));
            switch (roleLevel)
            {
                case 1:
                case 2:
                    DoPhoto(data);
                    DoGuestRequest(data);
                    DoUserRequest(data);
                    break;
                case 3:
                    DoAdministratorRequest();
                    break;
                default:
                    DoNoKnownRequest();
                    break;
            }
        }
        else
        {
            DoNoKnownRequest();
        }

    }// end Page_Load

    private Dictionary<string, string>[] GetRequestData()
    {
        string table = Request.Params["t"];
        string bianhao = Request.Params["bianhao"];
        string groupid = Request.Params["groupid"];
        if (string.IsNullOrEmpty(table) || string.IsNullOrEmpty(bianhao) || string.IsNullOrEmpty(groupid))
        {
            string error = "<p style='color:red'>你提供的查询参数不完整，无法获得所需信息！</p>";
            errorbar.InnerHtml += error;
            return null;
        }
        string sql = "select * from {0} where bianhao=@bianhao and group_id=@groupId";
        sql = string.Format(sql, table);
        Dictionary<string, object> parameters = new Dictionary<string, object>();
        parameters.Add("bianhao", bianhao);
        parameters.Add("groupId", groupid);
        SQLHelper sqlHelper = CommWebUtil.GetSQLHelper(Context);
        if (sqlHelper != null)
        {
            DataTable dt = sqlHelper.ExecuteQuery(sql, parameters);
            if (dt != null && dt.Rows.Count > 0)
            {

                if (table == "persons")
                {
                    Dictionary<string, string>[] data = new Dictionary<string, string>[2];
                    data[0] = new Dictionary<string, string>();
                    data[0].Add("PHOTO", dt.Rows[0]["photo"] + "");
                    data[0].Add("编号", dt.Rows[0]["bianhao"] + "");
                    data[0].Add("姓名", dt.Rows[0]["name"] + "");
                    data[0].Add("单位", dt.Rows[0]["danwei"] + "");
                    data[0].Add("部门/标段", dt.Rows[0]["bumen"] + "");
                    data[0].Add("职位/工种", dt.Rows[0]["zhiwei"] + "");
                    data[0].Add("联系方式", dt.Rows[0]["lianxifangsi"] + "");
                    data[0].Add("group_id", dt.Rows[0]["group_id"] + "");

                    data[1] = new Dictionary<string, string>();
                    data[1].Add("身份证号码", dt.Rows[0]["shengfengzheng"] + "");
                    data[1].Add("家庭住址", dt.Rows[0]["homeaddress"] + "");
                    data[1].Add("籍贯", dt.Rows[0]["jiguan"] + "");
                    data[1].Add("亲属联系方式", dt.Rows[0]["qslianxifanshi"] + "");
                    data[1].Add("年龄", dt.Rows[0]["age"] + "");
                    data[1].Add("文化程度", dt.Rows[0]["wenhua"] + "");
                    data[1].Add("教育经历", dt.Rows[0]["jiaoyu"] + "");
                    data[1].Add("技能掌握", dt.Rows[0]["jineng"] + "");
                    data[1].Add("证书情况", dt.Rows[0]["zhengshu"] + "");
                    data[1].Add("工作经历", dt.Rows[0]["work"] + "");
                    data[1].Add("培训经历", dt.Rows[0]["learn"] + "");
                    data[1].Add("进行任务", dt.Rows[0]["task"] + "");
                    data[1].Add("工时记录", dt.Rows[0]["worktime"] + "");
                    data[1].Add("工资记录", dt.Rows[0]["solary"] + "");
                    data[1].Add("交底记录", dt.Rows[0]["jiaodi"] + "");
                    data[1].Add("安全教育记录", dt.Rows[0]["safe"] + "");
                    return data;
                }
                else if (table == "apparatus")
                {
                    Dictionary<string, string>[] data = new Dictionary<string, string>[1];
                    data[0] = new Dictionary<string, string>();
                    data[0].Add("序号", dt.Rows[0]["no"] + "");
                    data[0].Add("机种", dt.Rows[0]["jizhong"] + "");
                    data[0].Add("编号", dt.Rows[0]["bianhao"] + "");
                    data[0].Add("部门/班组", dt.Rows[0]["bumeng"] + "");
                    data[0].Add("责任人", dt.Rows[0]["zherenren"] + "");
                    data[0].Add("操作人", dt.Rows[0]["caozuoren"] + "");
                    data[0].Add("作业情况", dt.Rows[0]["zuoye"] + "");
                    data[0].Add("检修信息", dt.Rows[0]["jianxiu"] + "");
                    data[0].Add("group_id", dt.Rows[0]["group_id"] + "");
                    return data;
                }
                else
                {
                    return null;
                }
            }
            else
            {
                return null;
            }
        }
        else
        {
            throw new Exception("应用程序发生错误！");
        }
    }

    private string DataToHTML(Dictionary<string, string> data)
    {
        StringBuilder htmlContent = new StringBuilder();
        if (data != null)
        {
            for (int j = 0; j < data.Keys.Count; j++)
            {
                string itemName = data.Keys.ElementAt<string>(j);
                if (itemName == "PHOTO")
                    continue;
                string itemValue = data[itemName];
                htmlContent.Append("<br/><label style='display:inline-block; width:200px; font-weight:bold;text-align:right'>" + itemName + "</label>:&nbsp;&nbsp;" + itemValue);
            }
        }
        return htmlContent.ToString();
    }
    //private void AppendMessage(string title, Dictionary<string, string> data)
    //{
    //    if (data != null)
    //    {
    //        Dictionary<string, string> subData = data;
    //        if (subData.ContainsKey("PHOTO"))
    //        {
    //            string photo = subData["PHOTO"];
    //            imgPhoto.ImageUrl = "/views/PreviewPhotoHandler.ashx?bianhao=" + subData["编号"];
    //        }



    //        StringBuilder info = new StringBuilder();

    //        if (subData != null)
    //        {
    //            for (int j = 0; j < subData.Keys.Count; j++)
    //            {
    //                string itemName = subData.Keys.ElementAt<string>(j);
    //                if (itemName == "PHOTO")
    //                    continue;
    //                string itemValue = subData[itemName];
    //                info.Append("<br/><label style='display:inline-block; width:100px; font-weight:bold;text-align:right'>" + itemName + "</label>:&nbsp;&nbsp;" + itemValue);
    //            }
    //        }


    //        content.InnerHtml += info.ToString();
    //    }
    //}

    private void DoPhoto(Dictionary<string, string>[] data)
    {
        if (data != null)
        {
            foreach (var d in data)
            {
                if (d != null &&  d.ContainsKey("PHOTO"))
                {
                    string photo = d["PHOTO"];
                    imgPhoto.ImageUrl = "/views/PreviewPhotoHandler.ashx?bianhao=" + d["编号"] + "&groupid=" + d["group_id"];
                    return;
                }
            }
        }
    }

    private void DoGuestRequest(Dictionary<string, string>[] data)
    {
        if (data != null && data.Length > 0)
        {
            string info = DataToHTML(data[0]);
            if (!string.IsNullOrEmpty(info))
                basicInfoContent.InnerHtml = info;
        }
    }

    private void DoNoKnownRequest()
    {
        Response.Redirect(CommWebUtil.AppendQueryString("/Default.aspx", Request));
    }

    private void DoAdministratorRequest()
    {
        Response.Redirect(CommWebUtil.AppendQueryString("admin.aspx", Request));
    }

    private void DoUserRequest(Dictionary<string, string>[] data)
    {
        DoGuestRequest(data);
        if (data != null && data.Length > 1)
        {
            string info = DataToHTML(data[1]);
            if (!string.IsNullOrEmpty(info))
                seniorInfoContent.InnerHtml = info;
        }
    }
}