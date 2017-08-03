using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// GenericHelper 的摘要说明
/// </summary>
public class GenericHelper
{
    public GenericHelper()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }

    /// <summary>
    /// MD5 32位加密大写
    /// </summary>
    /// <param name="ConvertString"></param>
    /// <returns></returns>
    public static string GetStrMd5(string ConvertString)
    {
        System.Security.Cryptography.MD5CryptoServiceProvider md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
        string t2 = BitConverter.ToString(md5.ComputeHash(System.Text.UTF8Encoding.Default.GetBytes(ConvertString)));
        t2 = t2.Replace("-", "");
        return t2;
    }

    /// <summary>
    /// 将数据表转换成匿名对象，表列成为对象属性名，
    /// </summary>
    /// <param name="dt"></param>
    /// <returns></returns>
    public static List<Dictionary<string, object>> Parse(System.Data.DataTable dt)
    {
        if (dt == null)
            return null;
        List<Dictionary<string, object>> table = new List<Dictionary<string, object>>();
        foreach (System.Data.DataRow dr in dt.Rows)
        {
            Dictionary<string, object> row = new Dictionary<string, object>();
            foreach (System.Data.DataColumn column in dt.Columns)
            {
                string columnName = column.ColumnName;
                object value = dr[columnName];
                row.Add(columnName, value);
            }
            table.Add(row);
        }
        return table;
    }

    //往数据集每个表添加列
    public static void AppendColumn(System.Data.DataSet ds, string columnName, object defaultValue)
    {
        if (ds == null && ds.Tables.Count == 0)
            return;

        foreach (System.Data.DataTable dt in ds.Tables)
        {
            dt.Columns.Add(columnName);

            foreach (System.Data.DataRow dr in dt.Rows)
                dr[columnName] = defaultValue;

            dt.AcceptChanges();
        }
    }
}