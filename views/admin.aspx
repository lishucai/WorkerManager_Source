<%@ Page Language="C#" AutoEventWireup="true" CodeFile="admin.aspx.cs" Inherits="ui_Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>班组管理系统</title>
    <meta charset="utf-8" />
    <meta name="renderer" content="webkit" />
    <link href="/kendoui/styles/kendo.common.min.css" rel="stylesheet" />
    <link href="/kendoui/styles/kendo.silver.min.css" rel="stylesheet" />

    <link href="/bootstrap/css/bootstrap.min.css" rel="stylesheet" />

    <link href="admin.css" rel="stylesheet" />
    <style>
        * {
            font-size: 12px;
        }

        body > div {
            margin: 4px;
        }

        .grid-toolbar-template {
            float: right;
        }

        .inner_grid_container {
        }

        .auto-size-grid {
            margin: 0;
            padding: 0;
            border-width: 0;
            height: 100%;             
            /* DO NOT USE !important for setting the Grid height! */



        }

        #topnavbar {
            /*box-shadow: #808080 0px 2px ;*/
        }

            #topnavbar a {
                color: white;
            }

            #topnavbar li.active a {
                color: darkblue;
                background-color: #FFF;
            }

        .navbar-header .navbar-brand {
            background-image: url("../images/logo中交.png");
            background-repeat: no-repeat;
            background-size: 50px;
            background-position-y: 5px;
            background-position-x: 5px;
            padding-left: 55px;
        }

        .nav-tabs a {
            color: gray;
        }

        .nav-tabs .active a {
            color: black;
            font-weight: bold;
        }

        #userInfoEditWindow .formLbl {
            display: inline-block;
            width: 100px;
            text-align: right;
            margin-right: 5px;
        }


            #userInfoEditWindow p {
                margin: auto;
                width: 120px;
            }

        #errorMessage {
            color: red;
        }

        #navbar a:hover{
            color:cyan;
        }
    </style>
    <script src="/kendoui/js/jquery.min.js"></script>
    <script src="/kendoui/js/kendo.all.min.js"></script>
    <script src="/kendoui/js/messages/kendo.messages.zh-CN.min.js"></script>
    <script src="/kendoui/js/cultures/kendo.culture.zh-CN.min.js"></script>
    <script src="/bootstrap/js/bootstrap.min.js"></script>
    <script src="/kendoui/js/jszip.min.js"></script>
    <script src="admin.js"></script>
</head>
<body>
    <nav id="topnavbar" class="navbar navbar-default" style="margin-bottom: 2px;">
        <div class="container-fluid" style="background-color: darkblue;">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">中交班组管理系统1.2</a>
            </div>
            <div id="navbar" class="navbar-collapse collapse">
                <ul class="nav navbar-nav">
                    <li><a href="#" onclick="OnActiveGroup()">班组管理</a></li>
                    <li><a href="#" onclick="OnActivePersons()">人员台账</a></li>
                    <li><a href="#" onclick="OnActiveApparatus()">机械台账</a></li>
                </ul>
                <ul class="nav navbar-nav  navbar-right">
                    <li><a href="#" runat="server" id="loginUserName"></a></li>
                    <li><a href="#" id="edit_login_passowrd">修改密码</a></li>
                    <li><a href="LogoutHandler.ashx" runat="server" id="logout">退出</a></li>
                </ul>
            </div>
            <!--/.nav-collapse -->
        </div>
    </nav>

    <input type="hidden" id="currentUerGroups" runat="server" />

    <!-- 用户信息修改窗口 -->
    <div id="userInfoEditWindow">
        <label class="formLbl">用户名</label><input id="UserName" runat="server" readonly="readonly" /><br />
        <label class="formLbl" for="LoginPassword">登录密码</label><input type="password" id="LoginPassword" /><br />
        <label class="formLbl" for="ConfirmPassword">确认密码</label><input type="password" id="ConfirmPassword" /><br />
        <label id="errorMessage"></label>
        <p>
            <button  id="saveUserInfo" class="k-button">保存</button>&nbsp;&nbsp;<button id="resetUserForm" class="k-button">重置</button>
        </p>
    </div>
    <script type="text/javascript">
        function InitUserInfoForm() {
            $("#saveUserInfo").on("click", function () {
                if ($("#LoginPassword").val().length == 0) {
                    $("#errorMessage").html("密码不能为空");
                } else if ($("#LoginPassword").val() != $("#ConfirmPassword").val()) {
                    $("#errorMessage").html("两次输入的密码不一致");
                } else {
                    //提交用户表单
                    var url = "/views/UpdateUserHandler.ashx";
                    var data = {
                        new_password: $("#LoginPassword").val(),
                    };
                    var success = function(){
                        $("#errorMessage").html("密码已保存,请牢记您的新密码");
                    }
                    $.post(url, data, success);
                }
            });

            $("#resetUserForm").on("click", function () {
                $("#LoginPassword").val("");
                $("#ConfirmPassword").val("");
                $("#errorMessage").html("");
            });

            $("#edit_login_passowrd").on("click", function () {
                var win = $("#userInfoEditWindow").data("kendoWindow");
                win.center().open();
            });

            //创建弹窗
            $("#userInfoEditWindow").kendoWindow({
                visible: false,
                modal: true,
                width: "350px",
                title: "修改密码"
            });
        }
       
    </script>

    <!--查看二维码窗口-->
    <div id="viewQTCodeWindow">
        <p>
            <img src="#" id="QTCodeImage" />
        </p>
        <p>
            <a class="k-button" id="downLoadQTCode" href="#">下载</a>
        </p>
    </div>

    <div id="uploadSingelPhotoWin">
        <p>
            <img src="#" id="photopreview" width="128" />
            <br />
            <input type="file" accept="image/*" id="uploadSingelPhoto" />
        </p>
    </div>
    <div id="uploadZipWin">
        <p>
            <input type="file" accept="image/*" id="uploadZip" />
        </p>
    </div>
    <div id="uploadExcelFileWin">
        <p>
            <input type="file" accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" id="uploadExcelFile" />
        </p>
    </div>
    <div id="parent">
        <div id="grid_container">
            <div id="grid_groups">
            </div>
        </div>

        <div id="navtab_persons">
            <!-- nav tabs -->
            <ul class="nav nav-tabs" role="tablist">
            </ul>
            <!-- tab panes -->
            <div class="tab-content">
            </div>
        </div>
        <div id="navtab_apparatus">
            <!-- Nav tabs -->
            <ul class="nav nav-tabs" role="tablist">
            </ul>
            <!-- Tab panes -->
            <div class="tab-content">
            </div>
            <a onclick="return "></a>
        </div>
    </div>
    <script id="template" type="text/x-kendo-template">
        <a class="k-button" href="\#" onclick="return truncate()">Command</a>
    </script>
    <script>
        var all_grid = new Array();

        function resizeGrid(gridElement) {
            var topbarHeight = $("#topnavbar").height();
            var h = window.innerHeight - topbarHeight - 20;
            $("#grid_container").height(h);
            $(".inner_grid_container").height(h - 30);
            gridElement.data("kendoGrid").resize();
        }
        $(window).resize(function () {
            $(".auto-size-grid").each(function () {
                resizeGrid($(this));
            });
        });

        function truncate(table, groupid) {
            if (window.confirm("你确定要删除全部记录吗")) {
                if (window.confirm("在继续操作之前确认是否已经备份好数据？")) {
                    $.ajax("/views/truncateDataHandler.ashx?table=" + table + "&groupid=" + groupid, {
                        complete: function () {
                            alert("操作完成");
                        }
                    });
                }
            }
        }

        $(function () {

            var nPageSize = 10; //每页记录数           

            var dsGroups = null;
            $.ajax("group/LoadGroupsHandler2.ashx", {
                dataType: "json",
                success: function (data) {
                    initGroupList(data, nPageSize);
                }
            });

            var arryGroups = JSON.parse($("#currentUerGroups").val());
            if (arryGroups) {
                $.each(arryGroups, function (idx, value) {
                    var toolbar1Templ = CreatePersonsGridToolbarTempl(value.Id);
                    var toolbar2Templ = CreateApparatusGridToolbarTempl(value.Id);
                    var removeCmd = kendo.template('<a class="k-button" href="\\#" style="color:red" onclick="return truncate(\'persons\',\'' + value.Id + '\')">清空(慎用)</a>');
                    var toolbar1 = [{ name: "create" }, { name: "save" }, { name: "cancel" }, { name: "destroy" }, { template: removeCmd }, { template: toolbar1Templ }];
                    removeCmd = kendo.template('<a class="k-button" href="\\#"  style="color:red"  onclick="return truncate(\'apparatus\',\'' + value.Id + '\')">清空(慎用)</a>');
                    var toolbar2 = [{ name: "create" }, { name: "save" }, { name: "cancel" }, { name: "destroy" }, { template: removeCmd }, { template: toolbar2Templ }];
                    AddPersonGroup("#navtab_persons", value.Id, value.GroupName, toolbar1, nPageSize);
                    AddapparatusGroup("#navtab_apparatus", value.Id, value.GroupName, toolbar2, nPageSize);
                });
            }

            OnActivePersons();

            $("#uploadSingelPhoto").kendoUpload({
                async: {
                    saveUrl: "/views/uploadPhotoHandler.ashx?bianhao=-1",
                    autoUpload: false
                },
                directory: false,
                multiple: false,
                success: function (e) {
                    var url = "/views/PreviewPhotoHandler.ashx?" + Math.random() + "&bianhao=" + e.response.bianhao + "&groupid=" + e.response.groupid;
                    $("#photopreview").attr("src", url);
                },
            });
            $("#uploadZip").kendoUpload({
                async: {
                    saveUrl: "/views/uploadPhotoHandler.ashx?bianhao=-1",
                    autoUpload: false
                },
                directory: true,
                multiple: true,
            });

            //创建上传Excel文件控件
            $("#uploadExcelFile").kendoUpload({
                async: {
                    saveUrl: "/views/UploadPersonsExcelHandler.ashx?groupid=0",
                    autoUpload: false,
                },
                multiple: false,
                validation: {
                    maxFileSize: 100 * 1024 * 1024
                }
            });

            //创建上传Excel文件弹窗
            $("#uploadExcelFileWin").kendoWindow({
                visible: false,
                modal: true,
                width: "350px",
                title: "上传人员和机械台账Excel文件"
            });

            //创建查看二维码弹窗
            $('#viewQTCodeWindow').kendoWindow({
                visible: false,
                modal: true,
                width: "350px",
                title: "查看二维码"
            }).data("kendoWindow");

            //创建编辑照片弹窗
            $('#uploadSingelPhotoWin').kendoWindow({
                visible: false,
                modal: true,
                width: "350px",
                title: "修改照片"
            }).data("kendoWindow");

            //创建批量上传照片弹窗
            $('#uploadZipWin').kendoWindow({
                visible: false,
                modal: true,
                width: "350px",
                title: "上传多个图片文件或包含图片的文件夹"
            }).data("kendoWindow");

            $('#navtab_persons a:first').tab('show');
            $('#navtab_persons ul a').click(function (e) {
                e.preventDefault()
                $(this).tab('show');
                $(".auto-size-grid").each(function () {
                    resizeGrid($(this));
                });
            })

            InitUserInfoForm();

        }); // <!--  $(document).ready  -->

    </script>
</body>
</html>
