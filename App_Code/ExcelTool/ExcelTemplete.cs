using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// Excel模板
/// </summary>
public class ExcelTemplete
{
    public ExcelTemplete()
    {

    }

    /// <summary>
    /// 对应数据库表名
    /// </summary>
    public string TableName
    {
        get;
        set;
    }

    /// <summary>
    /// 表头所在行号
    /// </summary>
    public int HeaderRowNum
    {
        get;
        set;
    }
    /// <summary>
    /// 列名与字段名映射
    /// </summary>
    public Dictionary<string, string> ColumnFiledMap
    {
        set;
        get;
    }

    

}