<%@ WebHandler Language="C#" Class="uploadPhotoHandler" %>

using System;
using System.Web;
using System.Collections.Generic;
using System.IO.Compression;
using System.Web.SessionState;

public class uploadPhotoHandler : IHttpHandler, IRequiresSessionState
{

    //private string groupId = null;

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string bianhao = context.Request.Params["bianhao"];
        string groupId = context.Request.Params["groupid"];
        SystemUserInfo loginUser = context.Session[Resources.LOGIN_USER_INFO] as SystemUserInfo;
        //if (loginUser != null && loginUser.Groups != null && loginUser.Groups.Count > 0)
        //    groupId = loginUser.Groups[0].Id;

        if (context.Request.Files != null && context.Request.Files.Count > 0)
        {
            HttpPostedFile f = context.Request.Files[0];
            string UploadFilesPath = System.Configuration.ConfigurationManager.AppSettings["UploadFilesPath"];
            if (!string.IsNullOrEmpty(UploadFilesPath))
            {
                if (!string.IsNullOrEmpty(groupId))
                {
                    UploadFilesPath = System.IO.Path.Combine(UploadFilesPath, groupId);//各标段文件保存到以标段id命名的子目录下
                }
                if (!System.IO.Directory.Exists(UploadFilesPath))
                {
                    System.IO.Directory.CreateDirectory(UploadFilesPath);

                }
                SQLHelper sqlHeler = CommWebUtil.GetSQLHelper(context);
                if (bianhao == "-1")
                {
                    handleWinZiprFileUpload(context.Request.Files,groupId, UploadFilesPath, sqlHeler);
                    context.Response.Write(string.Empty);
                }
                else
                {

                    handleSingleFileUpload(f, UploadFilesPath,groupId, bianhao, sqlHeler);
                    Newtonsoft.Json.Linq.JObject jo = new Newtonsoft.Json.Linq.JObject();
                    jo["bianhao"] = bianhao;
                    jo["groupid"] = groupId;
                    string result = jo.ToString();

                    context.Response.Write(result);
                    context.Response.Write(string.Empty);
                }
            }
            else
            {
                context.Response.Write("failured");
            }
        }
    }

    private void handleWinZiprFileUpload(HttpFileCollection files,string  groupId, string fileSaveDir, SQLHelper sqlHelper)
    {
        if (files != null || files.Count > 0)
        {
            for (int i = 0; i < files.Count; i++)
            {
                HttpPostedFile f = files[i];
                string fileName = System.IO.Path.GetFileName(f.FileName);
                string fullPath = System.IO.Path.Combine(fileSaveDir, fileName);
                f.SaveAs(fullPath);

                string entryExtensionName = fileName.Substring(fileName.LastIndexOf('.'));
                string name = fileName.Substring(0, fileName.LastIndexOf(entryExtensionName));

                SavePhoto(name,groupId, fullPath, sqlHelper);
            }
        }
    }

    private void handleSingleFileUpload(HttpPostedFile f, string fileSaveDir, string groupId, string bianhao, SQLHelper sqlHelper)
    {
        string extensionName = new System.IO.FileInfo(f.FileName).Extension;
        string photoFilePath = System.IO.Path.Combine(fileSaveDir, bianhao + extensionName);
        f.SaveAs(photoFilePath);

        SavePhoto(bianhao,groupId, photoFilePath, sqlHelper);
    }


    private int SavePhoto(string bianhaoOrname,string groupId, string filefullName, SQLHelper sqlHelper)
    {
        string sql = "update persons set photo=@photo where ( bianhao=@bianhao or name=@name ) and  group_id=@groupId";
        Dictionary<string, object> parameters = new Dictionary<string, object>();
        parameters.Add("@photo", filefullName);
        parameters.Add("@bianhao", bianhaoOrname);
        parameters.Add("@name", bianhaoOrname);
        parameters.Add("@groupId", groupId);
        int result = 0;
        if (sqlHelper != null)
        {
            result = sqlHelper.ExecuteNotQuery(sql, parameters);
        }
        return result;
    }


    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}