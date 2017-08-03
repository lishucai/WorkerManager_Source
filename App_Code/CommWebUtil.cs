using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Web;

public class CommWebUtil
{

    public static string GetHtml(string url)
    {
        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12| SecurityProtocolType.Ssl3;
        System.Net.ServicePointManager.ServerCertificateValidationCallback = new System.Net.Security.RemoteCertificateValidationCallback(CheckValidationResult);
        HttpWebRequest request = WebRequest.Create(url) as HttpWebRequest;
        HttpWebResponse response = request.GetResponse() as HttpWebResponse;
        return response.StatusCode.ToString();
    }


    private static bool CheckValidationResult(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors errors)
    {
        return true; //总是接受  
    }

    public static string HttpUploadFile(string url, string path)
    {
        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
        System.Net.ServicePointManager.ServerCertificateValidationCallback = new System.Net.Security.RemoteCertificateValidationCallback(CheckValidationResult);
       
        // 设置参数

        HttpWebRequest request = WebRequest.Create(url) as HttpWebRequest;
    //request.ProtocolVersion = HttpVersion.Version10;

        CookieContainer cookieContainer = new CookieContainer();

        request.CookieContainer = cookieContainer;

        request.AllowAutoRedirect = true;

        request.Method = "POST";

        string boundary = DateTime.Now.Ticks.ToString("X"); // 随机分隔线

        request.ContentType = "multipart/form-data;charset=utf-8;boundary=" + boundary;

        byte[] itemBoundaryBytes = Encoding.UTF8.GetBytes("\r\n--" + boundary + "\r\n");

        byte[] endBoundaryBytes = Encoding.UTF8.GetBytes("\r\n--" + boundary + "--\r\n");
        int pos = path.LastIndexOf("\\");

        string fileName = path.Substring(pos + 1);
        string token = "eyJhbGciOiJIUzI1NiIsImtpZCI6Imp3dF9zeW1tZXRyaWNfa2V5In0.eyJjbGllbnRfaWQiOiJzV1NRNTlpQmcxRlFxTHZMUmNZd05FeXVDQm9tTDN4aiIsImV4cCI6MTQ5OTgzMzM0NCwic2NvcGUiOlsiZGF0YTpyZWFkIiwiZGF0YTp3cml0ZSJdLCJhdWQiOiJodHRwczovL2F1dG9kZXNrLmNvbS9hdWQvand0ZXhwNjAiLCJqdGkiOiJEZTFSWlhibnBJVXl3VWlsM2lSSGZTUWtTbDFWbnJRV3VPWERDVExMQ2Z5N1RjQUJEY3BHbG1DaFlQUmZPcGs1In0.7AUxtfmNusem01KBBin9kN5jCZXQKRIW-ggzi6dcJ3g";
        //请求头部信息 
        string headers = "Content-Disposition:form-data;name=\"file\";filename=\"{0}\"\r\nContent-Type:application/octet-stream\r\nAuthorization: Bearer {1}\r\n\r\n";


        StringBuilder sbHeader = new StringBuilder(string.Format(headers, fileName,token));

        byte[] postHeaderBytes = Encoding.UTF8.GetBytes(sbHeader.ToString());
        FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read);

        byte[] bArr = new byte[fs.Length];

        fs.Read(bArr, 0, bArr.Length);

        fs.Close();
        Stream postStream = request.GetRequestStream();

        postStream.Write(itemBoundaryBytes, 0, itemBoundaryBytes.Length);

        postStream.Write(postHeaderBytes, 0, postHeaderBytes.Length);

        postStream.Write(bArr, 0, bArr.Length);

        postStream.Write(endBoundaryBytes, 0, endBoundaryBytes.Length);

        postStream.Close();
        //发送请求并获取相应回应数据

        HttpWebResponse response = request.GetResponse() as HttpWebResponse;

        //直到request.GetResponse()程序才开始向目标网页发送Post请求

        Stream instream = response.GetResponseStream();

        StreamReader sr = new StreamReader(instream, Encoding.UTF8);

        //返回结果网页（html）代码

        string content = sr.ReadToEnd();

        return content;
    }





    public static string SendHttpRequest(string url)
    {
        System.Net.Http.HttpClient httpClient = new System.Net.Http.HttpClient();
        List<KeyValuePair<String, String>> paramList = new List<KeyValuePair<String, String>>();
        paramList.Add(new KeyValuePair<string, string>("scope", "data:read data:write"));
        paramList.Add(new KeyValuePair<string, string>("client_secret", "C4fe9fe9df9cc47c"));
        paramList.Add(new KeyValuePair<string, string>("grant_type", "client_credentials"));
        paramList.Add(new KeyValuePair<string, string>("client_id", "sWSQ59iBg1FQqLvLRcYwNEyuCBomL3xj"));
        System.Net.Http.FormUrlEncodedContent content = new System.Net.Http.FormUrlEncodedContent(paramList);
   
        content.Headers.ContentType.MediaType = "application/x-www-form-urlencoded";
        System.Net.Http.HttpResponseMessage response = httpClient.PostAsync(new Uri(url), content).Result;
        string res = response.Content.ReadAsStringAsync().Result;
        return res;
    }

    public static string SendHttpRequest(string url, List<KeyValuePair<String, String>> paramList, string contentType = "application/x-www-form-urlencoded")
    {
        System.Net.Http.HttpClient httpClient = new System.Net.Http.HttpClient();        
        System.Net.Http.FormUrlEncodedContent content = new System.Net.Http.FormUrlEncodedContent(paramList);
        content.Headers.ContentType.MediaType = contentType;
        System.Net.Http.HttpResponseMessage response = httpClient.PostAsync(new Uri(url), content).Result;
        string res = response.Content.ReadAsStringAsync().Result;
        return res;
    }


    public static System.Data.DataTable ExtractData(HttpContext context, string dbTableName, SQLHelper sqlHelper)
    {
        if (context == null || string.IsNullOrEmpty(dbTableName) || sqlHelper == null)
            throw new ArgumentNullException();

        string sql = "select * from " + dbTableName + " where 1=2";

        System.Data.DataTable dt = sqlHelper.ExecuteQuery(sql);
        if (dt != null)
        {
            dt.TableName = dbTableName;
            System.Data.DataRow dr = dt.NewRow();
            foreach (System.Data.DataColumn column in dt.Columns)
            {
                string columnName = column.ColumnName;
                string value = context.Request.Params[columnName];
                if (string.IsNullOrEmpty(value))
                    value = context.Request.Params[string.Format("models[0][{0}]", columnName)];
                if (string.IsNullOrEmpty(value))
                    dr[columnName] = DBNull.Value;
                else
                    dr[columnName] = value;
            }
            dt.Rows.Add(dr);
            dt.AcceptChanges();
        }
        return dt;
    }

    public static SQLHelper GetSQLHelper(HttpContext context)
    {

        SQLHelper sqlHeler = context.Cache["MY_BIMOUN_SQLHELPER"] as SQLHelper;
        if (sqlHeler == null)
            sqlHeler = new SQLHelper(System.Configuration.ConfigurationManager.AppSettings["SqlServerConnectionString"]);
        context.Cache["MY_BIMOUN_SQLHELPER"] = sqlHeler;
        return sqlHeler;
    }

    /// <summary>
    /// 附加查询字符串
    /// </summary>
    /// <param name="srcUrl"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static string AppendQueryString(string srcUrl, HttpContext context)
    {
        if (context != null)
            return AppendQueryString(srcUrl, context.Request);
        else
            return srcUrl;
    }

    public static string AppendQueryString(string srcUrl, HttpRequest request)
    {
        if (request == null || srcUrl == null || string.IsNullOrEmpty(request.Url.Query))
            return srcUrl;
        else
        {
            if (srcUrl.Contains(@"?"))
            {
                return srcUrl + "&" + request.Url.Query.Substring(1);
            }
            else
            {
                return srcUrl + request.Url.Query;
            }
        }
    }



}