using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// 常用常量
/// </summary>
public class Resources
{
    public const String LOGIN_USER_INFO = "LOGIN_USER_INFO";//登录用户信息保存在会话中的字典对象的键名
    public const String SUPER_USER_NAME = "superuser";
    public const string SUPER_USER_PASSWORD = "BIM123456";
    public const string SUPER_USER_ROLE = "超级管理员";
    /// <summary>
    /// web请求中的参数名
    /// </summary>
    public class RequestParams
    {
        public const string TABLE_NAME = "t";// 数据库表名
    }
}