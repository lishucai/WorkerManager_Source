<%@ WebHandler Language="C#" Class="viewQTCodeHandler" %>

using System;
using System.Web;

public class viewQTCodeHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        string bianhao = context.Request.Params["bianhao"] + "";
        string gid = context.Request.Params["groupid"] + "";
        string qrcode = string.Format("http://{0}/views/info.aspx?t={1}&bianhao={2}&groupid={3}", context.Request.Url.Authority, "persons", System.Web.HttpUtility.UrlEncode(bianhao), gid);
        System.Drawing.Image img = QTCodeImportor.CreateQTCode(qrcode, new string[] { bianhao });
        img = QTCodeImportor.CombinImage(img, context.Server.MapPath("~/images/logo中交1.jpg"));
        img = Graphics2DUtil.AppendBorder(20, img);

        System.Drawing.Bitmap b = new System.Drawing.Bitmap(img);

        context.Response.ContentType = "application/x-msdownload";
        string fileName = bianhao + ".jpg";
        context.Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(fileName, System.Text.Encoding.UTF8));
        b.Save(context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
        context.Response.Flush();
        context.Response.End();
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}