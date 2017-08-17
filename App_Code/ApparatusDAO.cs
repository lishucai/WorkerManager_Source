using LiuShengFeng.Core;
using System;
using System.Collections.Generic;

/// <summary>
/// ApparatusDAO 的摘要说明
/// </summary>
public class ApparatusDAO
{
    public ApparatusDAO()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }

    public int generatNextNo(string groupid, SQLHelper sqlHelper, System.Data.SqlClient.SqlTransaction trans)
    {
        if (sqlHelper == null || trans == null)
            throw new ArgumentNullException();

        string sql = @" select max(bianhao) from apparatus where bianhao is not null and group_id=@group_id ";
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