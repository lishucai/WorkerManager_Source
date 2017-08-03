using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;

/// <summary>
/// ExcelImportor 的摘要说明
/// </summary>
public class ExcelReader
{
    public ExcelReader()
    {
    }

    private DataTable Translate(DataTable srcDt, ExcelTemplete templete)
    {
        if (srcDt == null)
            return null;
        DataTable resultDt = new DataTable();
        if (templete != null)
        {
            resultDt.TableName = templete.TableName;
            
            //修改列名
            foreach (DataColumn srcColumn in srcDt.Columns)
            {
                string srcColumnName = srcColumn.ColumnName;
                string mapColumnName = srcColumnName;
                if (templete.ColumnFiledMap != null)
                    templete.ColumnFiledMap.TryGetValue(srcColumn.ColumnName, out mapColumnName);
                if (!string.IsNullOrEmpty(mapColumnName))
                {
                    resultDt.Columns.Add(mapColumnName);
                }
            }

            //复制数据
            foreach (DataRow dr in srcDt.Rows)
            {
                DataRow copy = resultDt.NewRow();
                foreach (DataColumn column in srcDt.Columns)
                {
                    string srcColumnName = column.ColumnName;
                    string mapColumnName = srcColumnName;
                    if (templete.ColumnFiledMap != null)
                        templete.ColumnFiledMap.TryGetValue(srcColumnName, out mapColumnName);
                    if (!string.IsNullOrEmpty(mapColumnName))
                    {
                        copy[mapColumnName] = dr[srcColumnName];
                    }
                }
                resultDt.Rows.Add(copy);
            }
        }
        return resultDt;
    }

    /// <summary>
    /// 加载excel数据
    /// </summary>
    /// <param name="strFileName"></param>
    /// <param name="sheetHeaderRowNum">每张sheet的标头行号</param>
    public DataSet Extract(Stream file, List<ExcelTemplete> templetes)
    {

        Dictionary<int, int> sheetHeaderRowNum = null;
        if (templetes != null && templetes.Count > 0)
        {
            sheetHeaderRowNum = new Dictionary<int, int>();
            for (int i = 0; i < templetes.Count; i++)
                sheetHeaderRowNum.Add(i, templetes[i].HeaderRowNum);
        }
        XSSFWorkbook hssfworkbook = null;
       
        hssfworkbook = new XSSFWorkbook(file);

        if (hssfworkbook == null)
            throw new Exception("未知错误");

        int sheetCount = 0;

        if (sheetHeaderRowNum == null)
            sheetCount = hssfworkbook.NumberOfSheets;
        else
            sheetCount = Math.Min(sheetHeaderRowNum.Count, hssfworkbook.NumberOfSheets);

        DataSet ds = new DataSet();
        for (int sheetNum = 0; sheetNum < sheetCount; sheetNum++)
        {
            ISheet sheet = hssfworkbook.GetSheetAt(sheetNum);
            if (sheet == null)
                continue;
            int headerRowNum = sheetHeaderRowNum.Values.ElementAt<int>(sheetNum);
            DataTable dt = createDataTableFromSheet(sheet, headerRowNum);
            if (dt != null && dt.Columns.Count > 0)
            {
                DataTable dt2 = dt;
                if (templetes != null && templetes.Count > sheetNum)
                    dt2 = Translate(dt, templetes[sheetNum]);
                ds.Tables.Add(dt2);
            }
        }

        return ds;
    }

    private DataTable createDataTableFromSheet(ISheet sheet, int headerRowNum)
    {
        if (sheet == null)
            return null;
        IRow headerRow = sheet.GetRow(headerRowNum);
        if (headerRow == null)
            return null;

        int cellCount = headerRow.LastCellNum;
        System.Collections.IEnumerator rows = sheet.GetRowEnumerator();
        DataTable dt = new DataTable();
        for (int j = 0; j < cellCount; j++)
        {
            ICell cell = headerRow.GetCell(j);
            if (cell == null)
                break;
            dt.Columns.Add(cell.ToString());
        }

        for (int i = headerRowNum + 1; i <= sheet.LastRowNum; i++)
        {
            IRow row = sheet.GetRow(i);
            if (row == null)
                break;
            DataRow dataRow = dt.NewRow();
            for (int j = row.FirstCellNum; j < cellCount; j++)
            {
                if (row.GetCell(j) != null)
                    dataRow[j] = row.GetCell(j).ToString();
            }
            dt.Rows.Add(dataRow);
        }
        return dt;
    }

}