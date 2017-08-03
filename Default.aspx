<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="/images/favicon.ico">
    <title>中交班组管理系统</title>
    <!-- Bootstrap core CSS -->
    <link href="/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="signin.css" rel="stylesheet">

</head>
<body>
    <div class="container">
        <form id="form1" class="form-signin" runat="server" action="LoginCheckHandler.ashx">
            <h2 class="form-signin-heading">请输入</h2>
            <label for="inputEmail" class="sr-only">用户名</label>
            <input id="inputEmail" name="loginUserName" class="form-control" placeholder="用户名" required autofocus>
            <label for="inputPassword" class="sr-only">密码</label>
            <input type="password" name="loginPassword" id="inputPassword" class="form-control" placeholder="密码" required>
            <div class="checkbox">
                <label>
                    <input type="checkbox" value="remember-me">记住我
                </label>
            </div>
            <button class="btn btn-lg btn-primary btn-block" type="submit">进入系统</button>
        </form>
        <a href="/views/info.aspx?is_guest_login=true" runat="server" id="guestLogin">使用游客身份</a>
    </div>
</body>
</html>
