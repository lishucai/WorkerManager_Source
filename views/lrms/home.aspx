<%@ Page Language="C#" AutoEventWireup="true" CodeFile="home.aspx.cs" Inherits="views_lrms_home" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8"/>
    <meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no"/>
    <title>中交征拆管理系统</title>

    <link href="/kendoui/styles/kendo.common.min.css" rel="stylesheet"/>
    <link href="/kendoui/styles/kendo.default.min.css" rel="stylesheet"/>
    
    <link href="home.css" rel="stylesheet" />

    <script src="/kendoui/js/jquery.min.js"></script>
    <script src="/kendoui/js/kendo.all.min.js"></script>
    <script src="home.js"></script>
    

    <script>
        jQuery(document).ready(function ($) {
            enableLayoutAutoSize("#nav-menu", "#main-content");
            $("#menu").kendoMenu({ orientation: 'vertical' });
        });


        function ViewProcess(url) {
            $("#view3d_iframe").attr("src", url);
            return false;
        }
    </script>

</head>
<body>
    <div id="caption">
        <h1>征地拆迁管理系统</h1>
    </div>
    <div id="nav-menu">
        <ul id="menu">
            <li>系统管理
                <ul>
                    <li>用户管理
                    </li>
                    <li>角色管理
                    </li>
                    <li>组织架构
                    </li>
                    <li>权限管理
                    </li>
                </ul>
            </li>
            <li>基础数据
            </li>
            <li>工程管理
                <ul>
                    <li><a href="#"  onclick="return ViewProcess('/views/lrms/arcgis/map_viewer.aspx')">项目信息</a></li>
                    <li>补偿标准</li>
                </ul>
            </li>
            <li>被征拆户资料
            </li>
            <li>
                <a href="#">征拆进度</a>
            </li>
            <li>征拆费用
            </li>
            <li><a href="#" onclick="return ViewProcess('/views/3dModels/uploadmodel.aspx')">上传模型</a></li>
            <li>模型管理
                <ul runat="server" id="ul_models_mng">
                </ul>   
            </li>
        </ul>
    </div>
    <div id="main-content">
        <iframe id="view3d_iframe"  frameborder="0"></iframe>
    </div>
</body>
</html>
