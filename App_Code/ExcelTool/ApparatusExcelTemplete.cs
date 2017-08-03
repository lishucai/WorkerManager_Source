using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// ApparatusExcelTemplete 的摘要说明
/// </summary>
public class ApparatusExcelTemplete : ExcelTemplete
{
    public ApparatusExcelTemplete()
    {
        init();
    }

    private void init()
    {
        this.TableName = "apparatus";
        this.HeaderRowNum = 0;
        this.ColumnFiledMap = new Dictionary<string, string>();

        this.ColumnFiledMap.Add("序号", "bianhao");
        this.ColumnFiledMap.Add("机种", "jizhong");
        this.ColumnFiledMap.Add("编号", "no");
        this.ColumnFiledMap.Add("部门/班组", "bumeng");
        this.ColumnFiledMap.Add("责任人", "zherenren");
        this.ColumnFiledMap.Add("操作人", "caozuoren");
        this.ColumnFiledMap.Add("作业情况", "zuoye");
        this.ColumnFiledMap.Add("检修信息", "jianxiu");
    }
}