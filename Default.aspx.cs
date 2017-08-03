using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string infoUrl = CommWebUtil.AppendQueryString("views/info.aspx", Request);
        string adminUrl = CommWebUtil.AppendQueryString("views/admin.aspx", Request);
        string targetUrl = string.Empty;

        Dictionary<string, object> loginUser = Session[Resources.LOGIN_USER_INFO] as Dictionary<string, object>;

        if (loginUser != null)
        {
            int roleLevel = 0;
            int.TryParse(loginUser["role_level"] + "", out roleLevel);
            switch (roleLevel)
            {
                case 1:
                case 2:
                    targetUrl = infoUrl;
                    break;
                case 3:
                    targetUrl = adminUrl;
                    break;
                default:
                    targetUrl = string.Empty;
                    break;
            }
        }
        if (!string.IsNullOrEmpty(targetUrl))
            Response.Redirect(targetUrl);
        else
        {
            guestLogin.HRef = CommWebUtil.AppendQueryString("views/info.aspx?is_guest_login=true", Request);
            form1.Action = CommWebUtil.AppendQueryString("LoginCheckHandler.ashx", Request);
        }
    }
}