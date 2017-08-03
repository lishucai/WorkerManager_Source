using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;


public class SystemUserDAO
{
    public SystemUserDAO()
    {

    }

    public int UpdateUser(SystemUserInfo user, SQLHelper sqlHelper)
    {
        if (sqlHelper == null)
            throw new ArgumentNullException();

        if (user == null)
            return 0;

        DataTable dt = new DataTable();
        dt.TableName = "t_user";
        dt.Columns.Add("user_id");
        dt.Columns.Add("user_name");
      //  dt.Columns.Add("login_name");
        dt.Columns.Add("login_password");
        DataRow dr = dt.NewRow();
        dr["user_id"] = user.Id;
        dr["user_name"] = user.Name;
       // dr["login_name"] = user.LoginName;
        dr["login_password"] = user.LoginPassword;
        dt.Rows.Add(dr);
        return sqlHelper.Update(dt, new List<string>() { "user_id" });
    }


}


/// <summary>
/// SystemUserInfo 的摘要说明
/// </summary>
public class SystemUserInfo
{
    private string _name;
    private string _id;
    private string _loginName;
    private string _loginPassword;
    private List<SystemRole> _roles;
    private List<UserGroup> _groups;


    public string Name
    {
        get
        {
            return _name;
        }

        set
        {
            _name = value;
        }
    }

    public string Id
    {
        get
        {
            return _id;
        }

        set
        {
            _id = value;
        }
    }

    public string LoginName
    {
        get
        {
            return _loginName;
        }

        set
        {
            _loginName = value;
        }
    }

    public string LoginPassword
    {
        get
        {
            return _loginPassword;
        }

        set
        {
            _loginPassword = value;
        }
    }

    public List<SystemRole> Roles
    {
        get
        {
            return _roles;
        }

        set
        {
            _roles = value;
        }
    }

    public List<UserGroup> Groups
    {
        get
        {
            return _groups;
        }

        set
        {
            _groups = value;
        }
    }
    public SystemUserInfo()
    {

        this.Roles = new List<SystemRole>();
        this.Groups = new List<UserGroup>();
    }
    public SystemUserInfo(string name, string id, string loginName, string loginPassword)
    {
        this.Name = name;
        this.Id = id;
        this.LoginName = loginName;
        this.LoginPassword = loginPassword;
        this.Roles = new List<SystemRole>();
        this.Groups = new List<UserGroup>();
    }
}

public class SystemRole
{
    private string _id;
    private string _roleName;
    private string _roleLevel;
    public SystemRole()
    {

    }
    public SystemRole(string id, string roleName, string roleLevel)
    {
        this._id = id;
        this._roleLevel = roleLevel;
        this._roleName = roleName;
    }

    public string Id
    {
        get
        {
            return _id;
        }

        set
        {
            _id = value;
        }
    }

    public string RoleName
    {
        get
        {
            return _roleName;
        }

        set
        {
            _roleName = value;
        }
    }

    public string RoleLevel
    {
        get
        {
            return _roleLevel;
        }

        set
        {
            _roleLevel = value;
        }
    }
}

public class UserGroup
{
    private string _id;
    private string _groupName;
    private string _desc;
    private string _parentid;
    private string _treeid;
    public UserGroup()
    {
    }
    public UserGroup(string id, string groupName, string desc)
    {
        this._desc = desc;
        this._id = id;
        this._groupName = groupName;
    }

    public string Id
    {
        get
        {
            return _id;
        }

        set
        {
            _id = value;
        }
    }

    public string GroupName
    {
        get
        {
            return _groupName;
        }

        set
        {
            _groupName = value;
        }
    }

    public string Desc
    {
        get
        {
            return _desc;
        }

        set
        {
            _desc = value;
        }
    }

    public string Parentid
    {
        get
        {
            return _parentid;
        }

        set
        {
            _parentid = value;
        }
    }

    public string Treeid
    {
        get
        {
            return _treeid;
        }

        set
        {
            _treeid = value;
        }
    }
}