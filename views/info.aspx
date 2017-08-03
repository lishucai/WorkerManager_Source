<%@ Page Language="C#" AutoEventWireup="true" CodeFile="info.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>查看信息</title>
    <!-- Bootstrap core CSS -->
    <link href="/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .HeadImage {
            width: 256px;
            display: block;
            position: absolute;
            right: 30px;
            top: 50px;
        }
        html body{
            font-size:xx-large;
        }
    </style>
    <script src="/jquery/jquery-3.2.1.js"></script>
    <script src="/bootstrap/js/bootstrap.min.js"></script>
</head>
<body>
    <div class="row">
        <div class="col-md-4">&nbsp;</div>
        <div class="col-md-4">
            <div>
                <h1 id="errorbar" class="container" runat="server"></h1>
                <a href="#" runat="server" id="logout"></a>
                <asp:Image CssClass="img-thumbnail HeadImage" ID="imgPhoto" runat="server" />
            </div>
        </div>
        <div class="col-md-4">&nbsp;</div>
    </div>


    <div>

        <!-- Nav tabs -->
        <ul class="nav nav-tabs" role="tablist">
            <li role="presentation" class="active"><a href="#home" aria-controls="home" role="tab" data-toggle="tab">基础信息</a></li>
            <li role="presentation"><a href="#profile" aria-controls="profile" role="tab" data-toggle="tab">高级信息</a></li>
        </ul>

        <!-- Tab panes -->
        <div class="tab-content">
            <div role="tabpanel" class="tab-pane active" id="home">

                <div id="basicInfoContent" runat="server">
                </div>

            </div>
        <div role="tabpanel" class="tab-pane" id="profile">
            <div id="seniorInfoContent" runat="server">
            </div>

        </div>
        </div>

    </div>


</body>
</html>
