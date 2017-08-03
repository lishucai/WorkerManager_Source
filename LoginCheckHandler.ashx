<%@ WebHandler Language="C#" Class="LoginCheckHandler" %>

using System;
using System.Web;
using System.Collections.Generic;
using System.Data;
using System.Web.SessionState;
public class LoginCheckHandler : IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        string loginUserName = context.Request.Params["loginUserName"];
        string loginPassword = context.Request.Params["loginPassword"];

        if ("bimoun#666".Equals(loginPassword) && "bimoun".Equals(loginUserName))//临时用户
        {
            context.Session.Add(Resources.LOGIN_USER_INFO, new SystemUserInfo() { Name="bimoun"});
            context.Response.Redirect("/views/lrms/home.aspx");
        }

        else
        {
            bool Authenticated = false;
            SQLHelper sqlHelper = CommWebUtil.GetSQLHelper(context);
            if (sqlHelper != null)
            {
                string sql = @"select u.user_id, user_name 
            from t_user u 
            where u.user_name=@login_name and u.login_password=@login_password
                            ";
                Dictionary<string, object> parameters = new Dictionary<string, object>();
                parameters.Add("login_password", GenericHelper.GetStrMd5(loginPassword));
                parameters.Add("login_name", loginUserName);
                DataTable dt = sqlHelper.ExecuteQuery(sql, parameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    SystemUserInfo userInfo = new SystemUserInfo();
                    userInfo.Name = dt.Rows[0]["user_name"] == DBNull.Value ? "" : dt.Rows[0]["user_name"] + "";
                    userInfo.Id = dt.Rows[0]["user_id"] == DBNull.Value ? "" : dt.Rows[0]["user_id"] + "";


                    sql = @"select a.role_id, role_name, role_level 
                        from t_role a inner join t_user_role b
                        on a.role_id = b.role_id
                        where b.user_id=@userId ";
                    parameters.Clear();
                    parameters.Add("userId", userInfo.Id);

                    dt = sqlHelper.ExecuteQuery(sql, parameters);
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        foreach (DataRow dr in dt.Rows)
                        {
                            SystemRole role = new SystemRole();
                            role.Id = dr["role_id"] == DBNull.Value ? "" : dr["role_id"] + "";
                            role.RoleName = dr["role_name"] == DBNull.Value ? "" : dr["role_name"] + "";
                            role.RoleLevel = dr["role_level"] == DBNull.Value ? "" : dr["role_level"] + "";
                            userInfo.Roles.Add(role);
                        }
                    }
                    context.Session.Add(Resources.LOGIN_USER_INFO, userInfo);
                    Authenticated = true;
                }
                else
                {
                    Authenticated = false;
                }
            }
            else
            {
                Authenticated = false;
            }

            if (Authenticated)
                context.Response.Redirect(CommWebUtil.AppendQueryString("views/admin.aspx", context.Request));
            else
                context.Response.Redirect(CommWebUtil.AppendQueryString("Default.aspx", context.Request));
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