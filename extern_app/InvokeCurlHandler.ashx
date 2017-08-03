<%@ WebHandler Language="C#" Class="InvokeCurlHandler" %>

using System;
using System.Web;

public class InvokeCurlHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";




        string curlCommand = context.Server.MapPath("~/extern_app/curl.exe");
        System.Diagnostics.Process p = new System.Diagnostics.Process();
        p.StartInfo.FileName = curlCommand;
        p.StartInfo.UseShellExecute = false;
        p.StartInfo.RedirectStandardInput = true;
        p.StartInfo.RedirectStandardOutput = true;
        p.StartInfo.CreateNoWindow = false;

        string accessToken = GetAccessToken(p);
        //读取命令行参数
        string filePath = context.Server.MapPath("~/extern_app/cmdline_arguments.txt");
        System.IO.StreamReader sr = new System.IO.StreamReader(filePath);
        string cmdArgs = sr.ReadLine();
        cmdArgs = cmdArgs.Replace("++++", accessToken);

        sr.Close();
        p.StartInfo.Arguments = cmdArgs;
        p.Start();
        p.StandardInput.WriteLine("exit"); //需要有这句，不然程序会挂机
        string output = p.StandardOutput.ReadToEnd(); //这句可以用来获取执行命令的输出结果
        context.Response.Write(output);
    }


    private string GetAccessToken(System.Diagnostics.Process p)
    {
        if (p == null)
            throw new ArgumentNullException();

        p.StartInfo.Arguments = "-v \"https://developer.api.autodesk.com/authentication/v1/authenticate\" -H \"Content-Type:application/x-www-form-urlencoded\" -d \"client_id=sWSQ59iBg1FQqLvLRcYwNEyuCBomL3xj&client_secret=C4fe9fe9df9cc47c&grant_type=client_credentials&scope=data:write\"";
        p.Start();
        p.StandardInput.WriteLine("exit"); //需要有这句，不然程序会挂机
        string output = p.StandardOutput.ReadToEnd(); //这句可以用来获取执行命令的输出结果
        Newtonsoft.Json.Linq.JObject o = (Newtonsoft.Json.Linq.JObject)Newtonsoft.Json.JsonConvert.DeserializeObject(output);
        object v = o.GetValue("access_token");
        return v + "";
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}