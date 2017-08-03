<%@ Page Language="C#" AutoEventWireup="true" CodeFile="uploadmodel.aspx.cs" Inherits="views_3dModels_uploadmodel" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script src="/jquery/jquery-3.2.1.js"></script>
    <script>
        //选择文件后，自动使用当前文件名填充目标和项目名称文本框
        function fillModelName() {
            var path = $("#srcFile").val();
            var fileName = path.substr(path.lastIndexOf("\\") + 1);
            $("#target_name").val(fileName);
            var modeName = fileName.substr(0, fileName.lastIndexOf("."));
            $("#modelName").val(modeName);
        }
    </script>
</head>
<body>
    <form action="Upload3DModelsFileHandler.ashx" method="post" enctype="multipart/form-data">
        <!--<label for="srcFile">选择文件</label>-->
        <input id="srcFile" name="srcFile" type="file" onchange="fillModelName()" /><br />
        <label for="target_name">目标名称</label><input id="target_name" name="target_name" type="text" /><br />
        <label for="modelName">项目名称</label><input id="modelName" name="modelName" type="text" /><br />
        <button type="submit">开始上传</button>&nbsp;&nbsp;
        <button type="reset">重置</button>
    </form>
</body>
</html>
