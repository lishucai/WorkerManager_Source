using LiuShengFeng.Core;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

public partial class ui_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string loginUrl = CommWebUtil.AppendQueryString("/Default.aspx", Request);
        string infoUrl = CommWebUtil.AppendQueryString("info.aspx", Request);
        string targetUrl = string.Empty;

        SystemUserInfo loginUser = Session[Resources.LOGIN_USER_INFO] as SystemUserInfo;

        //判断是否为游客
        if (loginUser == null && Request.Params["is_guest_login"] != null)
        {
            targetUrl = infoUrl;
        }
        else if (loginUser != null)
        {
            int roleLevel = 0;
            roleLevel = loginUser.Roles.Max<SystemRole>(x => int.Parse(x.RoleLevel));
            switch (roleLevel)
            {
                case 1:
                case 2:
                    targetUrl = infoUrl;
                    break;
                case 3:
                    targetUrl = string.Empty;
                    break;
                default:
                    targetUrl = loginUrl;
                    break;
            }
        }
        else
        {
            targetUrl = loginUrl;
        }
        if (!string.IsNullOrEmpty(targetUrl))
            Response.Redirect(targetUrl);
        else if (loginUser != null)
        {
            //由于班组管理中可能会改变班组数据，须实时获取班组信息
            SQLHelper sqlHelper = CommWebUtil.GetSQLHelper(this.Context);
            UpdateUserGroup(loginUser, sqlHelper);
            loginUserName.InnerHtml = loginUser.Name;
            logout.HRef = CommWebUtil.AppendQueryString("LogoutHandler.ashx", Request);
            currentUerGroups.Value = Newtonsoft.Json.JsonConvert.SerializeObject(loginUser.Groups);

            UserName.Value = loginUser.Name;
        }
    }

    private void UpdateUserGroup(SystemUserInfo user, SQLHelper sqlHelper)
    {        
        if (user == null)
            return;
        user.Groups = new List<UserGroup>();
        if (sqlHelper == null)
            throw new ArgumentNullException();
        Dictionary<string, object> parameters = new Dictionary<string, object>();
        /*
         获取用户所在部门及其所有下级部门，并在部门前面加上上一级部门名称
         */
        string sql = @"select cg.group_id,'[' + pg.group_name+']' + cg.group_name group_name,cg.group_desc,cg.parentId,cg.tree_id from 
                        (
	                        (
		                        (
			                        t_user u inner join t_user_group ug on u.user_id=ug.user_id
		                        ) inner join t_group g on g.group_id=ug.group_id
	                        ) left join t_group cg on cg.tree_id like g.tree_id + '%'
                        ) left join t_group pg on cg.parentId=pg.group_id 
                        where u.user_id=@user_id
                        order by cg.tree_id
                       ";
        parameters.Clear();
        parameters.Add("user_id", user.Id);

        System.Data.DataTable dt = sqlHelper.ExecuteQuery(sql, parameters);
        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                UserGroup group = new UserGroup();
                group.Id = dr["group_id"] == DBNull.Value ? "" : dr["group_id"] + "";
                group.GroupName = dr["group_name"] == DBNull.Value ? "" : dr["group_name"] + "";
                group.Desc = dr["group_desc"] == DBNull.Value ? "" : dr["group_desc"] + "";
                group.Parentid = dr["parentid"] == DBNull.Value ? "" : dr["parentid"] + "";
                group.Treeid = dr["tree_id"] == DBNull.Value ? "" : dr["tree_id"] + "";
                user.Groups.Add(group);
            }
        }
    }

}