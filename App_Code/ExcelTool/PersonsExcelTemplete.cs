using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// BanzhuExcelTemplete 的摘要说明
/// </summary>
public class PersonsExcelTemplete : ExcelTemplete
{
    public PersonsExcelTemplete()
    {
        init();
    }

    private void init()
    {
        this.TableName = "persons";
        this.HeaderRowNum = 2;
        ColumnFiledMap = new Dictionary<string, string>();
        this.ColumnFiledMap.Add("Column1", "bianhao");
        this.ColumnFiledMap.Add("姓名", "name");
        this.ColumnFiledMap.Add("单位", "danwei");
        this.ColumnFiledMap.Add("部门/标段", "bumen");
        this.ColumnFiledMap.Add("职位/工种", "zhiwei");
        this.ColumnFiledMap.Add("联系方式", "lianxifangsi");
        this.ColumnFiledMap.Add("身份证号码", "shengfengzheng");
        this.ColumnFiledMap.Add("籍贯", "jiguan");
        this.ColumnFiledMap.Add("家庭住址", "homeaddress");
        this.ColumnFiledMap.Add("年龄", "age");
        this.ColumnFiledMap.Add("亲属联系方式", "qslianxifanshi");
        this.ColumnFiledMap.Add("文化程度", "wenhua");
        this.ColumnFiledMap.Add("教育经历", "jiaoyu");
        this.ColumnFiledMap.Add("技能掌握", "jineng");
        this.ColumnFiledMap.Add("证书情况", "zhengshu");
        this.ColumnFiledMap.Add("工作经历", "work");
        this.ColumnFiledMap.Add("培训经历", "learn");
        this.ColumnFiledMap.Add("进行任务", "task");
        this.ColumnFiledMap.Add("工时记录", "worktime");
        this.ColumnFiledMap.Add("工资记录", "solary");
        this.ColumnFiledMap.Add("交底记录", "jiaodi");
        this.ColumnFiledMap.Add("安全教育记录", "safe");
    }




}