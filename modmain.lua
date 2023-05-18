local _G = GLOBAL
local jsonUtil = require "json"
------------------------------------------------
--------------- 配置QQ群----------------------------
function getQQGroup()
    local qqgroup = ""
    for i = 1, 11, 1 do
        local num = GetModConfigData("QQ" .. i)
        if num ~= -1 then
            qqgroup = qqgroup .. num
        end
    end
    return GLOBAL.tonumber(qqgroup)
end

--打印日志
printLog = function(log)
    if (GetModConfigData("isLog")) then
        print(log)
    end
end

----------------------- 相关配置--------------------------
QQGroup = getQQGroup() or 664372315;
BotQQ = 2136703269;
RoomName = GLOBAL.TheNet:GetServerName() or 'xsluck'
isPrefix = GetModConfigData("isPrefix")

printLog("已经设置QQ群为：" .. QQGroup)
printLog("机器人QQ：" .. BotQQ)
printLog("房间名：" .. RoomName)

--------------- 服务相关URL ----------------------
local host = 'http://127.0.0.1:8081'
local session = ""
--获取session URL
local getSessionUrl = host .. "/verify";
--绑定session URL
local bindSessionUrl = host .. "/bind";
--发送群组消息 URL
local sendGroupMessageUrl = host .. "/sendGroupMessage";
--接受群组消息 URL
local peekLatestMessageUrl = host .. "/fetchLatestMessage";
------------------------------------------------
-- session初始化
AddSimPostInit(function(...)
    getSession();
end)
--发送群组消息初始化
AddPrefabPostInit("world", function(inst)
    local OldNetworking_Say = GLOBAL.Networking_Say
    GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote)
        local r = OldNetworking_Say(guid, userid, name, prefab, message, colour, whisper, isemote)
        if GLOBAL.TheNet and GLOBAL.TheNet:GetIsServer() and inst.ismastershard then
            if (isPrefix) then
                if (string.lower(string.sub(message, 1, 1)) == ":") then
                    message = string.sub(message, 2)
                    sendGroupMsg(guid, userid, name, prefab, message, colour, whisper, isemote)
                end
            else
                sendGroupMsg(guid, userid, name, prefab, message, colour, whisper, isemote)
            end
        end
        return r;
    end
end)
--发送群组消息
sendGroupMsg = function(guid, userid, name, prefab, message, colour, whisper, isemote)
    printLog(guid .. userid .. name .. prefab .. message)
    local userIdStr = userid
    if GLOBAL.ThePlayer ~= nil then
        userIdStr = GLOBAL.ThePlayer.userid
    end
    if(string.sub(message, 1, 1) == "#") then
        local txt = string.sub(message, 2);
        if(txt == "复活") then
            local str = 'local player = UserToPlayer("' .. name .. '") if (player ~= nil) then player:PushEvent("respawnfromghost") player.rezsource = "复活指令" end';
            _G.ExecuteConsoleCommand(str);
        elseif(txt == "重选") then
            local str = 'local player = UserToPlayer("' .. name .. '") if (player ~= nil) then c_despawn(player) end';
            _G.ExecuteConsoleCommand(str)
        elseif(txt == "自杀") then
            local str = 'local player = UserToPlayer("' .. name .. '") if (player ~= nil) then player:PushEvent("death") player.deathpkname = "自杀指令" end';
            _G.ExecuteConsoleCommand(str);
        else
            printLog(txt .. "指令错误！ #复活 #自杀 #重选")
        end
    else
        local groupDate = {}
        groupDate.sessionKey = session
        groupDate.target = QQGroup
        local tbl1 = {}
        tbl1.type = "Plain"
        tbl1.text = RoomName .. "的" .. name .. "说：\n" .. message
        local tbl2 = {}
        tbl2.type = "Plain"
        tbl2.text = "\n\nkleiId:" .. userIdStr
        groupDate.messageChain = {tbl1, tbl2}
        printLog(jsonUtil.encode(groupDate));
        GLOBAL.TheSim:QueryServer(sendGroupMessageUrl, onSendGroupMsgResult, "POST", jsonUtil.encode(groupDate))
    end
end
--发送指令消息
sendApduMsg = function(message)
    local groupDate = {}
    groupDate.sessionKey = session
    groupDate.target = QQGroup
    local tbl1 = {}
    tbl1.type = "Plain"
    tbl1.text = message
    groupDate.messageChain = {tbl1}
    printLog(jsonUtil.encode(groupDate));
    GLOBAL.TheSim:QueryServer(sendGroupMessageUrl, onSendGroupMsgResult, "POST", jsonUtil.encode(groupDate))
end
--获取群消息初始化
AddSimPostInit(function(inst)
    if GLOBAL.TheNet and GLOBAL.TheNet:GetIsServer() then
        -- 每500毫秒拉取一次消息
        GLOBAL.TheWorld:DoPeriodicTask(0.5, function(inst)
            if inst.ismastershard then
                GLOBAL.TheSim:QueryServer(peekLatestMessageUrl .. '?sessionKey=' .. session .. '', onGetGroupMsgResult, "GET")
            end
        end)
    end
end)
--获取session
getSession = function(...)
    --验证数据
    local verifyData = '{"verifyKey":"XSLUCKLOVEYOU"}';
    if GLOBAL.TheNet and GLOBAL.TheNet:GetIsServer() then
        GLOBAL.TheSim:QueryServer(getSessionUrl, onVerifyResult, "POST", verifyData);
    end
end
--解析获取session结果并绑定session
function onVerifyResult(result, isSuccessful, resultCode)
    if isSuccessful and string.len(result) > 1 and resultCode == 200 then
        result = jsonUtil.decode(result);
        if (result.code == 0) then
            session = result.session;
            printLog("获取Session成功:" .. result.session .. "，将绑定session。");
            local bindData = '{"qq":"' .. BotQQ .. '","sessionKey":"' .. session .. '"}';
            GLOBAL.TheSim:QueryServer(bindSessionUrl, onBindResult, "POST", bindData);
        else
            printLog("获取Session失败:" .. jsonUtil.encode(result));
        end
    else
        printLog("请求Session失败:" .. result .. "返回码：" .. resultCode);
    end
end

--解析绑定session结果
function onBindResult(result, isSuccessful, resultCode)
    if isSuccessful and string.len(result) > 1 and resultCode == 200 then
        result = jsonUtil.decode(result);
        if (result.code == 0) then
            printLog("绑定Session成功");
        else
            printLog("绑定Session失败:" .. jsonUtil.encode(result));
        end
    else
        printLog("请求绑定Session失败:" .. result .. "返回码：" .. resultCode);
    end
end

--解析发送群组消息结果
function onSendGroupMsgResult(result, isSuccessful, resultCode)
    if isSuccessful and string.len(result) > 1 and resultCode == 200 then
        result = jsonUtil.decode(result);
        if (result.code == 0) then
            printLog("发送消息成功");
        else
            printLog("发送消息失败:" .. jsonUtil.encode(result));
            if (result.code == 3) then
                getSession();
            end
        end
    end
end

--解析获取群组消息结果
function onGetGroupMsgResult(result, isSuccessful, resultCode)
    if isSuccessful and string.len(result) > 1 and resultCode == 200 then
        printLog("获取消息成功:" .. result);
        result = jsonUtil.decode(result);
        if (result.code == 0) then
            for i, v in GLOBAL.ipairs(result.data) do
                if (GLOBAL.next(result.data) ~= nil and result.data[i].type == "GroupMessage" and result.data[i].sender.group.id == QQGroup) then
                    for j, k in GLOBAL.ipairs(result.data[i].messageChain) do
                        if (result.data[i].messageChain[j].type == "Plain") then
                            if(string.sub(result.data[i].messageChain[j].text, 1, 1) == "/") then
                                local txt = string.sub(result.data[i].messageChain[j].text, 2);
                                printLog("txt" .. txt)
                                if(txt == "用户" or txt == "users") then
                                    sendApduMsg(getlistplayers());
                                elseif(txt == "世界" or txt == "words") then
                                    sendApduMsg(getworldstate());
                                elseif(txt == "复活") then
                                    local str = 'local player = UserToPlayer("' .. result.data[i].sender.memberName .. '") if (player ~= nil) then player:PushEvent("respawnfromghost") player.rezsource = "因QQ复活" end';
                                    _G.ExecuteConsoleCommand(str);
                                    sendApduMsg(result.data[i].sender.memberName.."复活已执行！");
                                elseif(txt == "重选") then
                                    local str = 'local player = UserToPlayer("' .. result.data[i].sender.memberName .. '") if (player ~= nil) then c_despawn(player) end';
                                    _G.ExecuteConsoleCommand(str)
                                    sendApduMsg(result.data[i].sender.memberName.."重选已执行！");
                                elseif(txt == "自杀") then
                                    local str = 'local player = UserToPlayer("' .. result.data[i].sender.memberName .. '") if (player ~= nil) then player:PushEvent("death") player.deathpkname = "因QQ死亡" end';
                                    _G.ExecuteConsoleCommand(str);
                                    sendApduMsg(result.data[i].sender.memberName.."自杀已执行！");
                                elseif(result.data[i].sender.permission == "OWNER" or result.data[i].sender.permission == "ADMINISTRATOR") then
                                    command = string.sub(txt, 1, 6);
                                    printLog("command" .. command)
                                    if(command == "重置")then
                                        _G.ExecuteConsoleCommand("c_regenerateworld()")
                                    elseif (command == "回档") then
                                        _G.ExecuteConsoleCommand("c_rollback(2)")
                                    elseif (command == "保存") then
                                        _G.ExecuteConsoleCommand("c_save()")
                                    elseif (command == "关机") then
                                        _G.ExecuteConsoleCommand("c_shutdown(true)")
                                    elseif (command == "重启") then
                                        _G.ExecuteConsoleCommand("c_reset()")
                                    elseif (command == "春") then
                                        _G.ExecuteConsoleCommand('TheWorld:PushEvent("ms_setseason", "spring")')
                                    elseif (command == "夏") then
                                        _G.ExecuteConsoleCommand('TheWorld:PushEvent("ms_setseason", "summer")')
                                    elseif (command == "秋") then
                                        _G.ExecuteConsoleCommand('TheWorld:PushEvent("ms_setseason", "autumn")')
                                    elseif (command == "冬") then
                                        _G.ExecuteConsoleCommand('TheWorld:PushEvent("ms_setseason", "winter")')
                                    elseif (command == "公告") then
                                        local str = string.sub(txt, 7);
                                        _G.ExecuteConsoleCommand('c_announce("'..str..'")')
                                    else
                                        _G.ExecuteConsoleCommand(txt)
                                    end
                                    sendApduMsg(txt.."已执行！");
                                else
                                    sendApduMsg("只有管理员才能执行任何指令！");
                                end
                            elseif (isPrefix) then
                                if (string.sub(result.data[i].messageChain[j].text, 1, 1) == ":") then
                                    txt = string.sub(result.data[i].messageChain[j].text, 2);
                                    GLOBAL.TheNet:SystemMessage("来自异界" .. result.data[i].sender.memberName .. "的消息：" .. txt);
                                end
                            else
                                txt = result.data[i].messageChain[j].text
                                printLog("获取消息成功:" .. txt);
                                GLOBAL.TheNet:SystemMessage("来自异界" .. result.data[i].sender.memberName .. "的消息：" .. txt);
                            end
                        end
                    end
                end
            end
            printLog("获取消息成功");
        else
            printLog("获取消息失败:" .. jsonUtil.encode(result));
            if (result.code == 3) then
                getSession();
            end
            if (result.code == 4) then
                getSession();
            end
        end
    end
end

--获取玩家列表
function getlistplayers()
    local allPlayers = {}
    local isdedicated = not _G.TheNet:GetServerIsClientHosted()
    local index = 1
    local str = ""
    for i, v in ipairs(_G.TheNet:GetClientTable() or {}) do
        if not isdedicated or v.performance == nil then
            local player = {}
            player.userid = v.userid
            player.name = v.name
            player.prefab = v.prefab
            allPlayers[index] = player
            str = str.."kleiId："..v.userid.."，玩家："..v.name.."，角色："..v.prefab.."\n"
            printLog(string.format("%s[%d] (%s) %s <%s>", v.admin and "*" or " ", index, v.userid, v.name, v.prefab))
            index = index + 1
        end
    end
    return str
end

--获取世界状态
function getworldstate()
    local worldstate = {}
    worldstate.season = _G.TheWorld.state.season
    worldstate.temperature = _G.TheWorld.state.temperature
    worldstate.remainingdaysinseason = _G.TheWorld.state.remainingdaysinseason
    if _G.TheWorld.components and _G.TheWorld.components.worldstate and _G.TheWorld.components.worldstate.data then
        worldstate.days = _G.TheWorld.components.worldstate.data.cycles
    end
    local str = "季节："..worldstate.season.."\n温度："..string.sub(worldstate.temperature, 1, 2) .. "\n季节剩余天数："..worldstate.remainingdaysinseason.."\n天数："..worldstate.days
    return str
end
