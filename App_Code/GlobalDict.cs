using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// 全局数据字典
/// </summary>
public class DataDict
{
    public enum DictItemType //数据字典项目类型
    {
        Category,//项目类别
        SubItem,
        Default,
    }

    public class DictItem
    {
        public string itemId
        {
            get;
            set;
        }

        public string ItemName
        {
            get;
            set;
        }

        public string Code
        {
            get;
            set;
        }

        public DictItemType ItemType
        {
            get;
            set;
        }

        public string ItemDesc
        {
            get;
            set;
        }

    }

    private HashSet<DictItem> Items;

    public DataDict()
    {
        Items = new HashSet<DictItem>();
    }

    public void LoadDict(SQLHelper sqlHelper)
    {

    }

    public void GetDictItem(ref DictItem item)
    {
        if (item == null)
            return;
        if(string.IsNullOrEmpty(item.itemId))
        {

        }
    }
}