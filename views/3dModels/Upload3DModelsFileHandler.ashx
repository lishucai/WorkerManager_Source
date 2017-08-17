<%@ WebHandler Language="C#" Class="Upload3DModelsFileHandler" %>

using System;
using System.Web;
using LiuShengFeng.Core;

/// <summary>
/// 处理上传3D模型到服务器的请求
/// </summary>
public class Upload3DModelsFileHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string error = "error"; //上传失败的返回结果
        string success = "上传成功";//上传成功的返回结果
        System.Collections.Generic.List<string> fileTypes = new System.Collections.Generic.List<string>()
        {
            ".nwc",
            ".nwd",
            ".rvt",
            ".dgn",
            ".ifc"
        };//上传文件类型

        if (context.Request.Files.Count == 0)
        {
            context.Response.Write("没有要上传的文件");
        }
        else
        {
            HttpPostedFile file = context.Request.Files[0];
            string extension = System.IO.Path.GetExtension(file.FileName);
            if (!fileTypes.Contains(extension))//判断上传的文件类型是否正确
            {
                context.Response.Write("文件类型不正确");
            }
            else
            {
                string curlCommand = context.Server.MapPath("~/extern_app/curl.exe");
                string srcModelFilePath = SaveTempleteFile(file);//保存上传的模型文件
                string accessToken = GetAutodeskAccesssToken(curlCommand);//获取访问令牌
                string targetName = context.Request.Params["target_name"];//上传到服务器目标文件名
                string urn = UploadModelToAutodesk(accessToken, srcModelFilePath, targetName, curlCommand);//上传文件到autodesk服务器
                string base64Urn = Base64Encode(urn);//对urn进行base64编码
                TranslateFile(accessToken, base64Urn, curlCommand);//转换文件格式

                string modelId = context.Request.Params["model_id"];
                string modelName = context.Request.Params["modelName"];
                SaveModels(modelId, modelName, base64Urn, targetName, CommWebUtil.GetSQLHelper(context));//保存上传的模型信息到数据库
                context.Response.Write(success);
            }
        }
    }
    /// <summary>
    /// 保存上传的模型信息到数据库
    /// </summary>
    /// <param name="modelId"></param>
    /// <param name="base64urn"></param>
    /// <param name="sqlHelper"></param>
    /// <returns></returns>
    private int SaveModels(string modelId, string modelName, string urn, string targetName, SQLHelper sqlHelper)
    {
        if (string.IsNullOrEmpty(urn) || sqlHelper == null)
        {
            throw new ArgumentNullException();
        }
        if (string.IsNullOrEmpty(modelId))
            modelId = System.Guid.NewGuid().ToString();
        string sql = "select 1 from t_models where model_id=@model_id";
        System.Collections.Generic.Dictionary<string, object> parameters = new System.Collections.Generic.Dictionary<string, object>();
        parameters.Add("@model_id", modelId);
        parameters.Add("@model_name", modelName);
        parameters.Add("@urn", urn);
        parameters.Add("@targetName", targetName);
        System.Data.DataTable dt = sqlHelper.ExecuteQuery(sql, parameters);
        if (dt != null && dt.Rows.Count > 0)
        {
            //如果有记录，则只更新urn
            sql = "update t_models set urn=@urn, model_name=@model_name, target_name=@targetName where model_id=@model_id";
            int result = sqlHelper.ExecuteNotQuery(sql, parameters);
            return result;
        }
        else
        {
            sql = "insert into t_models(model_id, model_name, urn,target_name) values(@model_id, @model_name,@urn,@targetName)";

            int result = sqlHelper.ExecuteNotQuery(sql, parameters);
            return result;
        }
    }
    /// <summary>
    /// 转换文件格式
    /// </summary>
    /// <param name="accessToken"></param>
    /// <param name="base64urn"></param>
    /// <returns>curl命令返回的结果</returns>
    private string TranslateFile(string accessToken, string base64urn, string curlCommand)
    {
        //调用外部程序导cmd命令行
        System.Diagnostics.Process p = new System.Diagnostics.Process();
        p.StartInfo.FileName = curlCommand;
        p.StartInfo.UseShellExecute = false;
        p.StartInfo.RedirectStandardInput = true;
        p.StartInfo.RedirectStandardOutput = true;
        p.StartInfo.CreateNoWindow = false;
        string token = accessToken;
        string cmdArgs = "-H \"Authorization: Bearer {0}\" -H \"Content-Type: application/json\" -v \"https://developer.api.autodesk.com/modelderivative/v2/designdata/job\" -d \"{{\\\"input\\\":{{\\\"urn\\\":\\\"{1}\\\"}},\\\"output\\\":{{\\\"formats\\\":[{{\\\"type\\\":\\\"svf\\\",\\\"views\\\":[\\\"2d\\\",\\\"3d\\\"]}}]}}}}\"";
        cmdArgs = string.Format(cmdArgs, token, base64urn);
        p.StartInfo.Arguments = cmdArgs;
        p.Start();
        p.StandardInput.WriteLine("exit"); //需要有这句，不然程序会挂机
        string output = p.StandardOutput.ReadToEnd(); //这句可以用来获取执行命令的输出结果
        return output;
    }

    /// <summary>
    /// base64编码
    /// </summary>
    /// <param name="str"></param>
    /// <returns></returns>
    private string Base64Encode(string str)
    {
        byte[] bytes = System.Text.Encoding.Default.GetBytes(str);
        string encode = Convert.ToBase64String(bytes);
        return encode;
    }
    /// <summary>
    /// 上传模型文件到autodesk服务器
    /// </summary>
    /// <param name="accessToken"></param>
    /// <param name="srcFilePath"></param>
    /// <param name="targetFileName"></param>
    /// <param name="curlCommand"></param>
    /// <returns>返回上传文件的urn</returns>
    private string UploadModelToAutodesk(string accessToken, string srcFilePath, string targetFileName, string curlCommand)
    {
        //调用外部程序导cmd命令行
        System.Diagnostics.Process p = new System.Diagnostics.Process();
        p.StartInfo.FileName = curlCommand;
        p.StartInfo.UseShellExecute = false;
        p.StartInfo.RedirectStandardInput = true;
        p.StartInfo.RedirectStandardOutput = true;
        p.StartInfo.CreateNoWindow = false;
        string cmdArgs = "-v \"https://developer.api.autodesk.com/oss/v2/buckets/chinaiss_bucket/objects/{0}\" -H \"Authorization: Bearer {1}\" -H \"Content-Type: application/octet-stream\" -T \"{2}\"";
        cmdArgs = string.Format(cmdArgs, targetFileName, accessToken, srcFilePath);
        p.StartInfo.Arguments = cmdArgs;
        p.Start();
        p.StandardInput.WriteLine("exit"); //需要有这句，不然程序会挂机
        string output = p.StandardOutput.ReadToEnd(); //这句可以用来获取执行命令的输出结果
                                                      //提取objectid作为urn
        Newtonsoft.Json.Linq.JObject o = (Newtonsoft.Json.Linq.JObject)Newtonsoft.Json.JsonConvert.DeserializeObject(output);
        object v = o.GetValue("objectId");
        return v + "";
    }

    /// <summary>
    /// 获取autodesk服务的访问令牌
    /// </summary>
    /// <returns>访问令牌</returns>
    private string GetAutodeskAccesssToken(string curlCommand)
    {
        //调用外部程序导cmd命令行
        System.Diagnostics.Process p = new System.Diagnostics.Process();
        p.StartInfo.FileName = curlCommand;
        p.StartInfo.UseShellExecute = false;
        p.StartInfo.RedirectStandardInput = true;
        p.StartInfo.RedirectStandardOutput = true;
        p.StartInfo.CreateNoWindow = false;
        string cmdArgs = "-v \"https://developer.api.autodesk.com/authentication/v1/authenticate\" -H \"Content-Type:application/x-www-form-urlencoded\" -d \"client_id=sWSQ59iBg1FQqLvLRcYwNEyuCBomL3xj&client_secret=C4fe9fe9df9cc47c&grant_type=client_credentials&scope=data:read%20data:write\"";
        p.StartInfo.Arguments = cmdArgs;
        p.Start();
        p.StandardInput.WriteLine("exit"); //需要有这句，不然程序会挂机
        string output = p.StandardOutput.ReadToEnd();
        Newtonsoft.Json.Linq.JObject o = (Newtonsoft.Json.Linq.JObject)Newtonsoft.Json.JsonConvert.DeserializeObject(output);
        object v = o.GetValue("access_token");
        return v + "";
    }

    /// <summary>
    /// 将上传的文件保存在服务器中
    /// </summary>
    /// <param name="file"></param>
    /// <returns>文件路径</returns>
    private string SaveTempleteFile(HttpPostedFile file)
    {
        if (file == null)
            throw new ArgumentNullException();
        string path = System.IO.Path.Combine(@"D:\WorkManager\models", file.FileName);
        file.SaveAs(path);
        return path;
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}