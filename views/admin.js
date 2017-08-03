function initGroupList(groupList, nPageSize) {
    //创建部门管理GRID
    var ds = new kendo.data.DataSource({
        batch: false,
        transport: {
            read: {
                url: "group/LoadGroupsHandler.ashx",
                type: "POST",
                dataType: "json",
            },
            destroy: {
                url: "group/destroy.ashx",
                type: "POST",
                dataType: "json",
            },
            create: {
                url: "group/NewGroupsHandler.ashx",
                type: "POST",
                dataType: "json"
            },
            update: {
                url: "group/update.ashx",
                type: "POST",
                dataType: "json"
            }
        },
        schema: {
            errors: "error",
            model: {
                id: "group_id",
                fields: {
                    No: {
                        editable: false
                    },
                    parentid: {
                        editable: false
                    },
                    group_name: {
                        validation: { // validation rules
                            required: true, // the field is required
                            required: { message: "班组名称不能为空" }
                        },
                    }
                }
            }
        },
        // page: 1,
        autoSync: true,
        //  pageSize: nPageSize,
        error: function (e) {
            ds.cancelChanges();
            alert(e.errors);
        },

    });

    var vcolumns = [
    {
        "field": "No",
        "title": "序号",
    },
    {
        "field": "group_id",
        "title": "ID标识",
        hidden: true,
    },
    {
        field: "group_name",
        title: "班组名称"
    },
    {
        field: "parentid",
        title: "所属标段",
        values: groupList,
    },
{
    field: "group_desc",
    title: "备注"
},
{ command: ["destroy"] },
    ];
    var refreshBtn = '';
    refreshBtn += '<a href="\\#" class="k-button" title="Refresh"><span class="k-icon k-i-reload"></span></a>';
    var vtoolbar = [
            { name: "create" },
            { template: refreshBtn }
    ];
    $("#grid_groups").addClass("auto-size-grid");
    var grid = $("#grid_groups").kendoGrid({
        dataSource: ds,
        autoBind: true,
        toolbar: vtoolbar,
        columns: vcolumns,
        selectable: 'multiple, row',
        editable: true,
        resizable: true,
        selectable: true,
        scrollable: true,
        navigatable: true,
    });
    grid.find(".k-grid-toolbar").on("click", ".k-pager-refresh", function (e) {
        e.preventDefault();
        grid.data("kendoGrid").dataSource.read();
    });
}

function createGrid(container, vdataSource, vtoolbar, vcolumns) {
    $(container).addClass("auto-size-grid");
    var grid = $(container).kendoGrid({
        dataSource: vdataSource,
        autoBind: true,
        scrollable: true,
        filterable: true,
        toolbar: vtoolbar,
        columns: vcolumns,
        columnResizeHandleWidth: 6,
        resizable: true,
        selectable: 'multiple, row',
        persistSelection: true,
        editable: true,
        pageable: {
            refresh: true,
            pageSizes: true,
            buttonCount: 5
        },
    });
    return grid;
}

function appendselectedRow(thisObj, t, groupId) {
    var url = 'ExportQTCodes.ashx?t=' + t + '&groupId=' + groupId;
    var grid = $('#' + t + groupId).data("kendoGrid");
    var selectedId = grid.selectedKeyNames();
    if (selectedId.length > 0) {
        url += "&selected=";
        for (var idx in selectedId)
            url += "," + selectedId[idx];
    }
    $(thisObj).attr('href', url);
    return true;
}

function CreatePersonsGridToolbarTempl(groupId) {
    var templHtml = "";
    templHtml += '<div class="grid-toolbar-template">';
    templHtml += '<a class="k-button k-grid-excel"><span class="k-icon k-i-file-excel"></span>导出Excel</a>';
    templHtml += '<a class="k-button" href="\\#" onclick="return appendselectedRow(this,\'persons\', \'' + groupId + '\')">导出二维码</a>';
    templHtml += '<a class="k-button" href="\\#"  onclick="return openUploadPhotosWindow(\'' + groupId + '\')"><span class="k-icon k-i-upload"></span>上传照片</a>';
    templHtml += '<a class="k-button" href="\\#"  onclick="return openUploadPersonsExcelWindow(\'' + groupId + '\')">上传Excel</a>';
    templHtml += '</div>';
    return kendo.template(templHtml);
}

function CreateApparatusGridToolbarTempl(groupId) {
    var templHtml = "";
    templHtml += '<div class="grid-toolbar-template">';
    templHtml += '<a class="k-button k-grid-excel"><span class="k-icon k-i-file-excel"></span>导出Excel</a>';
    templHtml += '<a class="k-button"  href="\\#" onclick="return appendselectedRow(this,\'apparatus\', \'' + groupId + '\')">导出二维码</a>';
    templHtml += '<a class="k-button"  href="\\#" onclick="return openUploadApparatusExcelWindow(\'' + groupId + '\')">上传Excel</a>';
    templHtml += '</div>';
    return kendo.template(templHtml);
}


function openViewQTCodeWindow(groupid, bianhao) {
    var url = "/views/viewQTCodeHandler.ashx?groupid=" + groupid + "&bianhao=" + bianhao;
    $("#QTCodeImage").attr("src", url);
    $("#downLoadQTCode").attr("href", url);
    var win = $("#viewQTCodeWindow").data("kendoWindow");
    win.center().open();
}

function openUploadPhotosWindow(groupId) {
    openWindowForUpload('uploadZip', 'uploadZipWin', -1, groupId, false);
}

function openWindowForUpload(elementId, winId, currentBianHao, groupid, isPreview) {
    $("#" + elementId).data("kendoUpload").clearAllFiles();
    $("#" + elementId).data("kendoUpload").setOptions({
        async: {
            saveUrl: "/views/uploadPhotoHandler.ashx?groupid=" + groupid + "&bianhao=" + currentBianHao,
        },
    });
    if (isPreview)
        $("#photopreview").attr("src", "/views/PreviewPhotoHandler.ashx?" + Math.random() + "&bianhao=" + currentBianHao + "&groupid=" + groupid);
    var win = $("#" + winId).data("kendoWindow");
    win.center().open();
    return false;
}


function openUploadApparatusExcelWindow(groupId) {
    $("#uploadExcelFile").data("kendoUpload").clearAllFiles();
    $("#uploadExcelFile").data("kendoUpload").setOptions({
        async: {
            saveUrl: "/views/UploadApparatusExcelHandler.ashx?groupid=" + groupId,
            autoUpload: false,
        },
    });
    $('#uploadExcelFileWin').data('kendoWindow').center().open();
}
function openUploadPersonsExcelWindow(groupId) {
    $("#uploadExcelFile").data("kendoUpload").clearAllFiles();
    $("#uploadExcelFile").data("kendoUpload").setOptions({
        async: {
            saveUrl: "/views/UploadPersonsExcelHandler.ashx?groupid=" + groupId,
            autoUpload: false,
        },
    });
    $('#uploadExcelFileWin').data('kendoWindow').center().open();
}

function AddPersonGroup(container, groupid, groupName, toolbar, nPageSize) {
    var settings = new PersonsGridSettings(groupid);
    var dataSource = new kendo.data.DataSource(settings.DataSourceOptions);
    var grid_id = "persons" + groupid;
    $(container).children("ul").append('<li role="presentation"><a href="#tabpanel' + grid_id + '"  role="tab" data-toggle="tab">' + groupName + '</a></li>');
    $(container).children('div').append('<div role="tabpanel"  class="inner_grid_container tab-pane" id="tabpanel' + grid_id + '"><div id="' + grid_id + '"></div></div>');
    var g = createGrid("#" + grid_id, dataSource, toolbar, settings.Columns);
    g.find(".k-grid-delete").on("click", function (e) {
        e.preventDefault();
        var selectedItem = g.data("kendoGrid").select();
        g.data("kendoGrid").removeRow(selectedItem);
    });
}

function AddapparatusGroup(container, groupid, groupName, toolbar, nPageSize) {
    var settings = new ApparatusGridSettings(groupid);
    var dataSource = new kendo.data.DataSource(settings.DataSourceOptions);
    var grid_id = "apparatus" + groupid;
    $(container).children("ul").append('<li role="presentation"><a href="#tabpanel' + grid_id + '"  role="tab" data-toggle="tab">' + groupName + '</a></li>');
    $(container).children('div').append('<div role="tabpanel"  class="inner_grid_container tab-pane" id="tabpanel' + grid_id + '"><div id="' + grid_id + '"></div></div>');
    var g = createGrid("#" + grid_id, dataSource, toolbar, settings.Columns);
    g.find(".k-grid-delete").on("click", function (e) {
        e.preventDefault();
        var selectedItem = g.data("kendoGrid").select();
        g.data("kendoGrid").removeRow(selectedItem);
    });
}

function PersonsGridSettings(groupid) {
    this.DataSourceOptions = {
        transport: {
            read: {
                url: "/views/persons/read.ashx?t=persons&groupid=" + groupid,
                type: "POST",
                dataType: "json",
            },
            destroy: {
                url: "/views/persons/destroy.ashx",
                type: "POST",
                dataType: "json",
            },
            create: {
                url: "/views/persons/create.ashx?groupid=" + groupid,
                type: "POST",
                dataType: "json"
            },
            update: {
                url: "/views/persons/update.ashx",
                type: "POST",
                dataType: "json"
            }
        },// end transport
        schema: {
            errors: "error",
            model: {
                id: "bianhao",
                fields: {
                    bianhao: {
                        editable: false
                    },
                    name: {
                        validation: {
                            required: true,
                            required: { message: "姓名不能为空" }
                        },
                    }
                }
            },
        },// end schema
        autoSync: false,
        batch: true,
        pageSize: 20
    };
    this.Columns = [
    {
        'field': "bianhao",
        'title': "编号",
        'width': 180,
        'locked': true,
        'attributes': {
            'style': " font-size: 12px"
        },
        'headerAttributes': {
            'style': "text-align: center;vertical-align:middle;"
        }
    },
    {
        'field': "group_id",
        'hidden': true,
    },
    //{
    //    'field': "isChecked",
    //    'title': '选择',
    //},
    {
        'field': "name",
        'title': "姓名",
        'width': 100,
        'locked': true,
        'attributes': {
            'style': " font-size: 12px"
        },
        'headerAttributes': {
            'style': "text-align: left;vertical-align:middle;"
        },
    },
    {
        'title': "基础信息",
        'attributes': {
            'style': " font-size: 12px"
        },
        'headerAttributes': {
            'style': "text-align: center;vertical-align:middle;"
        },
        'columns': [
          {
              'field': "danwei",
              'title': "单位",
              'width': 200,
              'attributes': {
                  'style': " font-size: 12px"
              },
              'headerAttributes': {
                  'style': "text-align: left;vertical-align:middle;"
              },
          },
          {
              'field': "bumen",
              'title': "部门/标段",
              'width': 150,
              'attributes': {
                  'style': " font-size: 12px"
              },
              'headerAttributes': {
                  'style': "text-align: left;vertical-align:middle;"
              },
          },
          {
              'field': "zhiwei",
              'title': "职位/工种",
              'width': 150,
              'attributes': {
                  'style': " font-size: 12px"
              },
              'headerAttributes': {
                  'style': "text-align: left;vertical-align:middle;"
              },
          },
          {
              'field': "lianxifangsi",
              'title': "联系方式",
              'width': 200,
              'attributes': {
                  'style': " font-size: 12px"
              },
              'headerAttributes': {
                  'style': "text-align: left;vertical-align:middle;"
              },
          },
        ]
    },
    {
        'title': "高级信息",
        'attributes': {
            'style': " font-size: 12px"
        },
        'headerAttributes': {
            'style': "text-align: center;vertical-align:middle;"
        },
        'columns': [
          {
              'title': "个人信息",
              'attributes': {
                  'style': " font-size: 12px"
              },
              'headerAttributes': {
                  'style': "text-align: center;vertical-align:middle;"
              },
              'columns': [
                {
                    'field': "shengfengzheng",
                    'title': "身份证号码",
                    'width': 200,
                    'attributes': {
                        'style': " font-size: 12px"
                    },
                    'headerAttributes': {
                        'style': "text-align: left;vertical-align:middle;"
                    },
                },
                {
                    'field': "jiguan",
                    'title': "籍贯",
                    'width': 300,
                    'attributes': {
                        'style': " font-size: 12px"
                    },
                    'headerAttributes': {
                        'style': "text-align: left;vertical-align:middle;"
                    },
                },
                {
                    'field': "homeaddress",
                    'title': "家庭住址",
                    'width': 300,
                    'attributes': {
                        'style': " font-size: 12px"
                    },
                    'headerAttributes': {
                        'style': "text-align: left;vertical-align:middle;"
                    },
                },
                {
                    'field': "age",
                    'title': "年龄",
                    'width': 100,
                    'attributes': {
                        'style': " font-size: 12px"
                    },
                    'headerAttributes': {
                        'style': "text-align: left;vertical-align:middle;"
                    },
                },
                {
                    'field': "qslianxifanshi",
                    'title': "亲属联系方式",
                    'width': 200,
                    'attributes': {
                        'style': " font-size: 12px"
                    },
                    'headerAttributes': {
                        'style': "text-align: left;vertical-align:middle;"
                    },
                }
              ]
          },
          {
              'title': "技能水准",
              'attributes': {
                  'style': " font-size: 12px"
              },
              'headerAttributes': {
                  'style': "text-align: center;vertical-align:middle;"
              },
              'columns': [
                {
                    'field': "wenhua",
                    'title': "文化程度",
                    'width': 200,
                    'attributes': {
                        'style': " font-size: 12px"
                    },
                    'headerAttributes': {
                        'style': "text-align: left;vertical-align:middle;"
                    },
                },
                {
                    'field': "jiaoyu",
                    'title': "教育经历",
                    'width': 200,
                    'attributes': {
                        'style': " font-size: 12px"
                    },
                    'headerAttributes': {
                        'style': "text-align: left;vertical-align:middle;"
                    },
                },
                {
                    'field': "jineng",
                    'title': "技能掌握",
                    'width': 200,
                    'attributes': {
                        'style': " font-size: 12px"
                    },
                    'headerAttributes': {
                        'style': "text-align: left;vertical-align:middle;"
                    },
                },
                {
                    'field': "zhengshu",
                    'title': "证书情况",
                    'width': 200,
                    'attributes': {
                        'style': " font-size: 12px"
                    },
                    'headerAttributes': {
                        'style': "text-align: left;vertical-align:middle;"
                    },
                },
                {
                    'field': "work",
                    'title': "工作经历",
                    'width': 200,
                    'attributes': {
                        'style': " font-size: 12px"
                    },
                    'headerAttributes': {
                        'style': "text-align: left;vertical-align:middle;"
                    },
                },
                {
                    'field': "learn",
                    'title': "培训经历",
                    'width': 200,
                    'attributes': {
                        'style': " font-size: 12px"
                    },
                    'headerAttributes': {
                        'style': "text-align: left;vertical-align:middle;"
                    },
                }
              ]
          },
          {
              'title': "工作记录",
              'attributes': {
                  'style': " font-size: 12px"
              },
              'headerAttributes': {
                  'style': "text-align: center;vertical-align:middle;"
              },
              'columns': [
                {
                    'field': "task",
                    'title': "进行任务",
                    'width': 200,
                    'attributes': {
                        'style': " font-size: 12px"
                    },
                    'headerAttributes': {
                        'style': "text-align: left;vertical-align:middle;"
                    },
                },
                {
                    'field': "worktime",
                    'title': "工时记录",
                    'width': 200,
                    'attributes': {
                        'style': " font-size: 12px"
                    },
                    'headerAttributes': {
                        'style': "text-align: left;vertical-align:middle;"
                    },
                },
                {
                    'field': "solary",
                    'title': "工资记录",
                    'width': 200,
                    'attributes': {
                        'style': " font-size: 12px"
                    },
                    'headerAttributes': {
                        'style': "text-align: left;vertical-align:middle;"
                    },
                }
              ]
          },
          {
              'title': "教育培训",
              'attributes': {
                  'style': " font-size: 12px"
              },
              'headerAttributes': {
                  'style': "text-align: center;vertical-align:middle;"
              },
              'columns': [
                {
                    'field': "jiaodi",
                    'title': "交底记录",
                    'width': 200,
                    'attributes': {
                        'style': " font-size: 12px"
                    },
                    'headerAttributes': {
                        'style': "text-align: left;vertical-align:middle;"
                    },
                },
                {
                    'field': "safe",
                    'title': "安全教育记录",
                    'width': 200,
                    'attributes': {
                        'style': " font-size: 12px"
                    },
                    'headerAttributes': {
                        'style': "text-align: left;vertical-align:middle;"
                    },
                }
              ]
          }
        ]
    },
    {
        'title': "照片",
        'width': 80,
        'command': [
          {
              'name': "editPhoto",
              'text': " ",
              'className': "edit-photo-button",
              'click': function (e) {
                  e.preventDefault();
                  var tr = $(e.target).closest("tr");
                  var data = this.dataItem(tr);
                  openWindowForUpload("uploadSingelPhoto", "uploadSingelPhotoWin", data.bianhao, data.group_id, true);
              }
          }
        ],
        'headerAttributes': {
            'style': "text-align: left;vertical-align:middle;"
        }
    },
    {
        'title': "二维码",
        'width': 80,
        'command': [
          {
              'name': "viewQTCodeCmd",
              'text': "二维码",
              'click': function (e) {
                  e.preventDefault();
                  var tr = $(e.target).closest("tr");
                  var data = this.dataItem(tr);
                  openViewQTCodeWindow(data.group_id, data.bianhao);
              }
          },
        ],
        'headerAttributes': {
            'style': "text-align: left;vertical-align:middle;"
        }
    }
    ];// end this.Columns
}

function ApparatusGridSettings(groupid) {
    this.DataSourceOptions = {
        transport: {
            read: {
                url: "/views/apparatus/read.ashx?t=apparatus&groupid=" + groupid,
                type: "POST",
                dataType: "json",
            },
            destroy: {
                url: "/views/apparatus/destroy.ashx",
                type: "POST",
                dataType: "json",
            },
            create: {
                url: "/views/apparatus/create.ashx?groupid=" + groupid,
                type: "POST",
                dataType: "json"
            },
            update: {
                url: "/views/apparatus/update.ashx",
                type: "POST",
                dataType: "json"
            }
        },// end transport
        schema: {
            errors: "error",
            model: {
                id: "bianhao",
                fields: {
                    bianhao: {
                        editable: false
                    },
                }
            },
        },// end schema
        autoSync: false,
        batch: true,
        pageSize: 20
    };

    this.Columns = [
  {
      "field": "group_id",
      "hidden": true
  },
  {
      "field": "bianhao",
      "title": "序号"
  },
  {
      "field": "jizhong",
      "title": "机种"
  },
  {
      "field": "no",
      "title": "编号"
  },
  {
      "field": "bumeng",
      "title": "部门/班组"
  },
  {
      "field": "zherenren",
      "title": "责任人"
  },
  {
      "field": "caozuoren",
      "title": "操作人"
  },
  {
      "field": "zuoye",
      "title": "作业情况"
  },
  {
      "field": "jianxiu",
      "title": "检修信息"
  }
    ];
}

function toggleGrid(displayDiv, hiddenDiv1, hiddenDiv2) {
    $(displayDiv).show();
    $(hiddenDiv1).hide();
    $(hiddenDiv2).hide();
}

function OnActiveGroup() {
    toggleGrid('#grid_container', '#navtab_persons', '#navtab_apparatus');
    $("#navbar li").removeClass("active");
    $("#navbar li").eq(0).addClass("active");
    $(".auto-size-grid").each(function () {
        resizeGrid($(this));
    });
}

function OnActivePersons() {
    toggleGrid('#navtab_persons', '#navtab_apparatus', '#grid_container');
    $("#navbar li").removeClass("active");
    $("#navbar li").eq(1).addClass("active");
    $(".auto-size-grid").each(function () {
        resizeGrid($(this));
    });
}

function OnActiveApparatus() {
    toggleGrid('#navtab_apparatus', '#navtab_persons', '#grid_container');
    $("#navbar li").removeClass("active");
    $("#navbar li").eq(2).addClass("active");
    $(".auto-size-grid").each(function () {
        resizeGrid($(this));
    });
}