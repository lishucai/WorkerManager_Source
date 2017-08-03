using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class views_lrms_arcgis_map_viewer : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        SystemUserInfo loginUser = Session[Resources.LOGIN_USER_INFO] as SystemUserInfo;
        if (loginUser == null)
            Response.Redirect("/Default.aspx");
    }
}