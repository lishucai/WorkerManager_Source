using LiuShengFeng.Core;
using System;
using System.Collections.Generic;

/// <summary>
/// PeronsDAO 的摘要说明
/// </summary>
public class PeronsDAO
{
   // private SQLHelper _sqlHelper;

    public PeronsDAO(SQLHelper sqlHelper)
    {
     //   _sqlHelper = sqlHelper;
    }

    public string encodingBianhao(string groupid, SQLHelper sqlHelper)
    {
        string sql = @"select g.group_name, p.group_name
                    from t_group g, t_group p
                    where g. group_id=@group_id and g.parentId = p.group_id
                    ";
        Dictionary<string, object> parameters = new Dictionary<string, object>();
        parameters.Add("group_id", groupid);
        System.Data.DataTable dt = sqlHelper.ExecuteQuery(sql, parameters);
        string pre = string.Empty;
        if (dt != null && dt.Rows != null && dt.Rows.Count > 0)
            pre = string.Format("{0}-{1}-", dt.Rows[0][1], dt.Rows[0][0]);

        return pre;
    }

    public int generatNextNo(string groupid, SQLHelper sqlHelper, System.Data.SqlClient.SqlTransaction trans)
    {
        if (sqlHelper == null || trans == null)
            throw new ArgumentNullException();

        string sql = @"select max( SUBSTRING(bianhao, LEN(bianhao) - 2 ,3))
                            from persons where bianhao is not null and LEN(bianhao) > 3
                            and group_id=@group_id 
                        ";
        Dictionary<string, object> parameters = new Dictionary<string, object>();
        parameters.Add("group_id", groupid);
        System.Data.DataTable dt = sqlHelper.ExecuteQuery(sql, trans, parameters);
        int no = 1;
        string pre = string.Empty;
        if (dt != null && dt.Rows != null && dt.Rows.Count > 0)
        {
            int.TryParse(dt.Rows[0][0] + "", out no);
            no++;
        }
        return no;
    }
}