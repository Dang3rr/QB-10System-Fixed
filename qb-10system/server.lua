local QBCore = nil
local QBCore = exports['qb-core']:GetCoreObject()
local onlineOfficers = {}
local data = json.decode(LoadResourceFile(GetCurrentResourceName(), "./info.json"))

RegisterNetEvent("10system:Server:add")
AddEventHandler("10system:Server:add", function(status)
    local src = tonumber(source)
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local grade,code = GetPlayerData(citizenid)
    onlineOfficers[tostring(src)] = {
        src = src,
        name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
        code = code,
        grade = Player.PlayerData.job.grade.name,
        duty = status,
        channel = exports[Config.VoiceResource]:getPlayerRadio(src),
        talking = false
    }
    TriggerClientEvent("10system:Update", -1, onlineOfficers) 
end)

RegisterNetEvent("10system:Server:code")
AddEventHandler("10system:Server:code", function(info)
    local src = tostring(source)
    local Player = QBCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    if onlineOfficers[src] ~= nil then
        if info[1] ~= nil then 
            onlineOfficers[src].code = info[1]
        end
        data[citizenid] = {
            code = info[1],
        }
        Player.Functions.SetMetaData("callsign", info[1])
        SaveResourceFile(GetCurrentResourceName(), "./info.json", json.encode(data))
        TriggerClientEvent("10system:Update", -1, onlineOfficers)
    end
end)

RegisterNetEvent("10system:Server:remove")
AddEventHandler("10system:Server:remove", function()
    local src = tostring(source)
    if onlineOfficers[src] ~= nil then
        onlineOfficers[src] = nil
        TriggerClientEvent("10system:Update", -1, onlineOfficers)
    end
end)

AddEventHandler("playerDropped", function()
    local src = tostring(source)
    if onlineOfficers[src] ~= nil then
        onlineOfficers[src] = nil
        TriggerClientEvent("10system:Update", -1, onlineOfficers)
    end
end)

function GetPlayerData(citizenid)
    local grade = Config.grade
    local code = Config.code
    if data[citizenid] ~= nil then
        if data[citizenid].grade ~= nil then
            grade = data[citizenid].grade
        end
        if data[citizenid].code ~= nil then
            code = data[citizenid].code
        end
    end
    return grade,code
end

RegisterNetEvent("10system:server:updateChannel")
AddEventHandler("10system:server:updateChannel", function(sid,channel)
    sid = tostring(sid)
    if onlineOfficers[sid] then 
        onlineOfficers[sid].channel = channel
        TriggerClientEvent("10system:Update", -1, onlineOfficers)
    end
end)

RegisterNetEvent("10system:server:updateTalking")
AddEventHandler("10system:server:updateTalking", function(state)
    local sid = tostring(source)
    if onlineOfficers[sid] then 
        onlineOfficers[sid].talking = state
        TriggerClientEvent("10system:Update", -1, onlineOfficers, onlineOfficers[sid].channel)
    end
end)