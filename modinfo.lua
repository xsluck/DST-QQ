name = "游戏Q群聊天互通"
description = [[
在QQ群中可以与游戏中聊天，优先配置好QQ群(来自另一大佬的灵感配置)，需要自己搭建机器人
已实现Q群发送 /重启，/重置，/保存，/回档，/关机，/公告+公告内容，/春，/夏，/秋，/冬，/世界，/用户，/复活，/重选，/自杀等指令。（还未测试）
已实现游戏内 #复活，#自杀，#重选 等指令
也可Q群管理员自己编辑发送指令，例如 /c_give("物品")
机器人需和饥荒服务器在同一台设备上，否则需要重新修改mod文件
代码很简单，自己看看就能改了
 
 
v0.0.7 修复使用消息前缀时饥荒中有两条记录的问题
v0.0.6 修复非群管理员也能发送操作服务器指令的bug
 
]]
author = "xsluck"
version = "0.0.7"
forumthread = ""
api_version = 10

dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true
all_clients_require_mod = false
client_only_mod = false

icon_atlas = 'xs.xml'
icon = "xs.tex"

configuration_options =
{
    {
        name = "isPrefix",
        label = "消息前缀",
        hover = "启用则前面带:的消息才会回传",
        options =
        {
            {description = "禁用", data = false},
            {description = "启用", data = true},
        },
        default = false,
        }, {
        name = "isLog",
        label = "日志",
        hover = "打印日志便于排错，默认禁用",
        options =
        {
            {description = "禁用", data = false},
            {description = "启用", data = true},
        },
        default = false,
    },
    {
        name = "QQ1",
        label = "QQ群第1位数字",
        hover = "位数不够请选择为-1",
        options =
        {
            {description = "-1", data = -1},
            {description = "0", data = 0},
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "4", data = 4},
            {description = "5", data = 5},
            {description = "6", data = 6},
            {description = "7", data = 7},
            {description = "8", data = 8},
            {description = "9", data = 9},
        },
        default = -1,
    },
    {
        name = "QQ2",
        label = "QQ群第2位数字",
        hover = "位数不够请选择为-1",
        options =
        {
            {description = "-1", data = -1},
            {description = "0", data = 0},
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "4", data = 4},
            {description = "5", data = 5},
            {description = "6", data = 6},
            {description = "7", data = 7},
            {description = "8", data = 8},
            {description = "9", data = 9},
        },
        default = -1,
    },
    {
        name = "QQ3",
        label = "QQ群第3位数字",
        hover = "位数不够请选择为-1",
        options =
        {
            {description = "-1", data = -1},
            {description = "0", data = 0},
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "4", data = 4},
            {description = "5", data = 5},
            {description = "6", data = 6},
            {description = "7", data = 7},
            {description = "8", data = 8},
            {description = "9", data = 9},
        },
        default = -1,
    },
    {
        name = "QQ4",
        label = "QQ群第4位数字",
        hover = "位数不够请选择为-1",
        options =
        {
            {description = "-1", data = -1},
            {description = "0", data = 0},
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "4", data = 4},
            {description = "5", data = 5},
            {description = "6", data = 6},
            {description = "7", data = 7},
            {description = "8", data = 8},
            {description = "9", data = 9},
        },
        default = -1,
    },
    {
        name = "QQ5",
        label = "QQ群第5位数字",
        hover = "位数不够请选择为-1",
        options =
        {
            {description = "-1", data = -1},
            {description = "0", data = 0},
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "4", data = 4},
            {description = "5", data = 5},
            {description = "6", data = 6},
            {description = "7", data = 7},
            {description = "8", data = 8},
            {description = "9", data = 9},
        },
        default = -1,
    },
    {
        name = "QQ6",
        label = "QQ群第6位数字",
        hover = "位数不够请选择为-1",
        options =
        {
            {description = "-1", data = -1},
            {description = "0", data = 0},
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "4", data = 4},
            {description = "5", data = 5},
            {description = "6", data = 6},
            {description = "7", data = 7},
            {description = "8", data = 8},
            {description = "9", data = 9},
        },
        default = -1,
    },
    {
        name = "QQ7",
        label = "QQ群第7位数字",
        hover = "位数不够请选择为-1",
        options =
        {
            {description = "-1", data = -1},
            {description = "0", data = 0},
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "4", data = 4},
            {description = "5", data = 5},
            {description = "6", data = 6},
            {description = "7", data = 7},
            {description = "8", data = 8},
            {description = "9", data = 9},
        },
        default = -1,
    },
    {
        name = "QQ8",
        label = "QQ群第8位数字",
        hover = "位数不够请选择为-1",
        options =
        {
            {description = "-1", data = -1},
            {description = "0", data = 0},
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "4", data = 4},
            {description = "5", data = 5},
            {description = "6", data = 6},
            {description = "7", data = 7},
            {description = "8", data = 8},
            {description = "9", data = 9},
        },
        default = -1,
    },
    {
        name = "QQ9",
        label = "QQ群第9位数字",
        hover = "位数不够请选择为-1",
        options =
        {
            {description = "-1", data = -1},
            {description = "0", data = 0},
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "4", data = 4},
            {description = "5", data = 5},
            {description = "6", data = 6},
            {description = "7", data = 7},
            {description = "8", data = 8},
            {description = "9", data = 9},
        },
        default = -1,
    },
    {
        name = "QQ10",
        label = "QQ群第10位数字",
        hover = "位数不够请选择为-1",
        options =
        {
            {description = "-1", data = -1},
            {description = "0", data = 0},
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "4", data = 4},
            {description = "5", data = 5},
            {description = "6", data = 6},
            {description = "7", data = 7},
            {description = "8", data = 8},
            {description = "9", data = 9},
        },
        default = -1,
    },
    {
        name = "QQ11",
        label = "QQ群第11位数字",
        hover = "位数不够请选择为-1",
        options =
        {
            {description = "-1", data = -1},
            {description = "0", data = 0},
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "4", data = 4},
            {description = "5", data = 5},
            {description = "6", data = 6},
            {description = "7", data = 7},
            {description = "8", data = 8},
            {description = "9", data = 9},
        },
        default = -1,
    },
}
bugtracker_config = {
    email = "weq114@qq.com",
    lang = "CHI",
    upload_client_log = false,
    upload_server_log = true,
}
