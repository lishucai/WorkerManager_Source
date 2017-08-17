using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// SQLHelper 的摘要说明
/// </summary>
public class SQLHelper
{
    private string _connectionStr;
    public SQLHelper(string connectionStr)
    {
        this._connectionStr = connectionStr;
    }

    public int Delete(string table, Dictionary<string,object> conditions) 
    {
        string whereClause = " where 1 = 1 ";
        Dictionary<string, object> parameters = new Dictionary<string, object>();
        foreach (var field in conditions)
        {
            string fieldName = field.Key;
            object fieldValue = field.Value;
            whereClause += " and " + fieldName + "=@" + fieldName;
            parameters.Add("@" + fieldName, fieldValue);
        }
        return ExecuteNotQuery("delete from " + table + whereClause, parameters);
    }

    public int Update(DataTable dt, List<string> conditionFiledNames, SqlTransaction trans = null)
    {
        if (dt == null || dt.TableName == null)
            return 0;
        int result = 0;

        string whereClause = "";
        string fieldList = "";
        for (int i = 0; i < dt.Columns.Count; i++)
        {
            string fieldName = dt.Columns[i].ColumnName;
            if (conditionFiledNames != null && !conditionFiledNames.Contains(fieldName))
                fieldList += "," + fieldName + "=@" + fieldName;
        }
        if (fieldList.Length > 0)
            fieldList = fieldList.Substring(1);
        if (conditionFiledNames != null && conditionFiledNames.Count > 0)
        {
            whereClause = " where 1=1  ";
            foreach (var fieldName in conditionFiledNames)
            {
                whereClause += " and " + fieldName + "=@" + fieldName;
            }
        }
        string sql = string.Format("update {0} set {1} {2}", dt.TableName, fieldList, whereClause);
        Dictionary<string, object> parameters = new Dictionary<string, object>();
        foreach (DataRow dr in dt.Rows)
        {
            parameters.Clear();
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                DataColumn column = dt.Columns[i];
                string field = column.ColumnName;
                object value = dr[field];
                parameters.Add(field, value);
            }
            if (trans != null)
                result += ExecuteNotQuery(sql, trans, parameters);
            else
                result += ExecuteNotQuery(sql, parameters);
        }


        return result;
    }

    public int Save(DataTable dt, SqlTransaction trans = null)
    {
        if (dt == null || dt.TableName == null)
            return 0;
        int result = 0;

        string parametersList = null;
        string fieldList = null;
        for (int i = 0; i < dt.Columns.Count; i++)
        {
            DataColumn column = dt.Columns[i];
            if (parametersList == null)
            {
                parametersList = "@" + column.ColumnName;
                fieldList = column.ColumnName;
            }
            else
            {
                parametersList += ",@" + column.ColumnName;
                fieldList += "," + column.ColumnName;
            }
        }

        string sql = string.Format("insert into {0}({1}) values({2})", dt.TableName, fieldList, parametersList);
        Dictionary<string, object> parameters = new Dictionary<string, object>();
        foreach (DataRow dr in dt.Rows)
        {
            parameters.Clear();
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                DataColumn column = dt.Columns[i];
                string field = column.ColumnName;
                object value = dr[field];
                parameters.Add(field, value);
            }
            if (trans != null)
                result += ExecuteNotQuery(sql, trans, parameters);
            else
                result += ExecuteNotQuery(sql, parameters);
        }


        return result;
    }

    /// <summary>
    /// 保存模式
    /// </summary>
    public enum SaveMode
    {
        Trancate,
        Append,
        Normal, // 有相同记录的不重复
    }


    public DataTable ExecuteQuery(string sql, SqlTransaction _trans, Dictionary<string, object> parameters = null)
    {
        if (_trans == null)
            throw new ArgumentNullException();
        SqlCommand sqlCommand = new SqlCommand(sql, _trans.Connection, _trans);
        if (parameters != null)
        {
            foreach (var p in parameters)
            {
                sqlCommand.Parameters.Add(new SqlParameter(p.Key, p.Value));
            }
        }
        DataTable dataTable = new DataTable();
        using (SqlDataAdapter da = new SqlDataAdapter(sqlCommand))
        {
            da.Fill(dataTable);
        }
        return dataTable;

    }

    public DataTable ExecuteQuery(string sql, Dictionary<string, object> parameters = null)
    {

        SqlConnection conn = OpenConnection();
        SqlCommand sqlCommand = new SqlCommand(sql, conn);
        if (parameters != null)
        {
            foreach (var p in parameters)
            {
                sqlCommand.Parameters.Add(new SqlParameter(p.Key, p.Value));
            }
        }
        DataTable dataTable = new DataTable();
        using (SqlDataAdapter da = new SqlDataAdapter(sqlCommand))
        {
            da.Fill(dataTable);
        }
        CloseConnection(conn);
        return dataTable;

    }

    public int ExecuteNotQuery(string sql, SqlTransaction _trans, Dictionary<string, object> parameters = null)
    {
        if (_trans == null)
            throw new ArgumentNullException();
        SqlCommand sqlCommand = new SqlCommand(sql, _trans.Connection, _trans);
        if (parameters != null)
        {
            foreach (var p in parameters)
            {
                sqlCommand.Parameters.Add(new SqlParameter(p.Key, p.Value));
            }
        }
        int retcode = sqlCommand.ExecuteNonQuery();
        return retcode;
    }

    public int ExecuteNotQuery(string sql, Dictionary<string, object> parameters = null)
    {
        SqlConnection conn = OpenConnection();
        SqlCommand sqlCommand = new SqlCommand(sql, conn);
        if (parameters != null)
        {
            foreach (var p in parameters)
            {
                sqlCommand.Parameters.Add(new SqlParameter(p.Key, p.Value));
            }
        }
        SqlDataAdapter sda = new SqlDataAdapter();

        int retcode = sqlCommand.ExecuteNonQuery();
        CloseConnection(conn);
        return retcode;
    }
    public int Save(DataSet ds)
    {
        int retCode = 0;
        if (ds == null || ds.Tables.Count == 0)
            return 0;
        foreach (DataTable dt in ds.Tables)
        {
            retCode += Save(dt);
        }
        return retCode;
    }

    public SqlTransaction BeginTransaction()
    {
        SqlConnection _conn = OpenConnection();
        if (_conn != null)
        {
            SqlTransaction _trans = _conn.BeginTransaction();
            return _trans;
        }
        else
            return null;
    }

    public void Rollback(SqlTransaction _trans)
    {
        if (_trans != null)
        {
            _trans.Rollback();
            // _trans.Connection.Close();
        }
    }

    public void Commit(SqlTransaction _trans)
    {
        if (_trans != null)
        {
            _trans.Commit();
            //_trans.Connection.Close();
        }
    }




    private SqlConnection OpenConnection()
    {
        SqlConnection conn = new SqlConnection(_connectionStr);
        conn.Open();
        return conn;
    }

    private void CloseConnection(SqlConnection conn)
    {
        if (conn != null && conn.State != ConnectionState.Closed)
            try
            {
                conn.Close();
                conn = null;
            }
            catch (Exception)
            {
                throw;
            }
    }
}