<%@ WebHandler Language="C#" Class="ExportQTCodesHandler" %>

using System;
using System.Web;
using System.Data;
public class ExportQTCodesHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {

        SQLHelper sqlHeler = CommWebUtil.GetSQLHelper(context);
        string table = context.Request.Params["t"];

        string groupId = context.Request.Params["groupId"];
        System.Collections.Generic.Dictionary<string, object> parameters = new System.Collections.Generic.Dictionary<string, object>();

        string whereClause = " where bianhao is not null ";
        string selected = context.Request.Params["selected"];
        if (!string.IsNullOrEmpty(selected))
        {
            string[] selectedBianhao = selected.Split(',');
            whereClause += " and  bianhao in (''";
            foreach (var b in selectedBianhao)
            {
                whereClause += ",'" + b + "'";
            }
            whereClause += " )";
        }
        if (!string.IsNullOrEmpty(groupId))
        {
            whereClause += " and group_id=@group_id";
            parameters.Add("group_id", groupId);
        }
        else
            whereClause += " and group_id is null";

        DataTable dt = sqlHeler.ExecuteQuery(string.Format("select bianhao,name,group_id from {0} " + whereClause, table), parameters);
        if (dt != null && dt.Rows.Count > 0)
        {
            context.Response.ContentType = "application/octet-stream";
            string UploadFilesPath = System.Configuration.ConfigurationManager.AppSettings["UploadFilesPath"];
            string zipFilePath = System.IO.Path.Combine(UploadFilesPath, "temp.zip");

            using (System.IO.FileStream files = new System.IO.FileStream(zipFilePath, System.IO.FileMode.Create))
            using (System.IO.Compression.ZipArchive zipArchive = new System.IO.Compression.ZipArchive(files, System.IO.Compression.ZipArchiveMode.Create))
            {
                const int ROW = 5;
                const int COLUMN = 4;
                const int ImageCountPerPage = ROW * COLUMN; //每页二维码图片数

                System.Collections.Generic.List<System.Drawing.Image> images = new System.Collections.Generic.List<System.Drawing.Image>();
                int bigImgNum = 0;
                foreach (DataRow dr in dt.Rows)
                {
                    if (dr["bianhao"] == DBNull.Value)
                        continue;
                    string bianhao = dr["bianhao"] + "";
                    string gid = dr["group_id"] + "";
                    string name = dr["name"] == DBNull.Value ? string.Empty : (string)dr["name"];
                    string qrcode = string.Format("http://{0}/views/info.aspx?t={1}&bianhao={2}&groupid={3}", context.Request.Url.Authority, table, System.Web.HttpUtility.UrlEncode(bianhao, System.Text.Encoding.UTF8), gid);
                    System.Drawing.Image img = QTCodeImportor.CreateQTCode(qrcode, new string[] {bianhao, name });

                    img = QTCodeImportor.CombinImage(img, context.Server.MapPath("~/images/logo中交.jpg"));

                    img = Graphics2DUtil.AppendBorder(20, img);

                    images.Add(img);

                    if (images.Count < ImageCountPerPage)
                    {
                        continue;
                    }
                    System.Drawing.Image bigImage = Graphics2DUtil.CreateBigImage(images, COLUMN);
                    images.Clear();
                    bigImgNum++;
                    string entryName = bigImgNum + ".jpg";
                    zipImage(bigImage, entryName, zipArchive);
                }
                if (images.Count > 0)
                {
                    System.Drawing.Image bigImage = Graphics2DUtil.CreateBigImage(images, COLUMN);
                    images.Clear();
                    bigImgNum++;
                    string entryName = bigImgNum + ".jpg";
                    zipImage(bigImage, entryName, zipArchive);
                }
            }


            System.IO.FileStream fs = new System.IO.FileStream(zipFilePath, System.IO.FileMode.Open);

            byte[] buffer = new byte[fs.Length];
            fs.Read(buffer, 0, buffer.Length);
            fs.Close();
            string fileName = string.Format("A{0}_{1} _二维码.zip", groupId, table == "persons" ? "人员" : "机械");
            context.Response.ContentType = "application/x-msdownload";
            context.Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(fileName, System.Text.Encoding.UTF8));
            context.Response.BinaryWrite(buffer);
            context.Response.Flush();
            context.Response.End();
        }
        else
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write("null");
        }
    }

    private void zipImage(System.Drawing.Image bigImage, string entryName, System.IO.Compression.ZipArchive zipArchive)
    {
        System.IO.MemoryStream ms = new System.IO.MemoryStream();
        bigImage.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg);
        ms.Position = 0;

        System.IO.Compression.ZipArchiveEntry readMeEntry = zipArchive.CreateEntry(entryName);

        using (System.IO.Stream stream = readMeEntry.Open())
        {
            byte[] bytes = ms.GetBuffer();
            stream.Write(bytes, 0, bytes.Length);
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