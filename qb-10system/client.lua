local PlayerJob = {}
local show = false
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
	local duty = exports[Config.PoliceResource]:duty()
	PlayerJob = QBCore.Functions.GetPlayerData().job
	if isValidJob() and duty then
		show = true
		TriggerServerEvent('10system:Server:add',duty)
	end
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate")
AddEventHandler("QBCore:Client:OnJobUpdate", function(JobInfo)
	local duty = exports[Config.PoliceResource]:duty()
	PlayerJob = JobInfo
	if isValidJob() and duty then
		show = true
		TriggerServerEvent('10system:Server:add',duty)
	else
		show = false
		TriggerServerEvent('10system:Server:remove')
		SendNUIMessage({action = "hide"})
	end
end)

RegisterNetEvent('10system:Client:Duty')
AddEventHandler('10system:Client:Duty', function(duty)
	if duty then
		show = true
		TriggerServerEvent('10system:Server:add',duty)
	else
		show = true
		TriggerServerEvent('10system:Server:remove')
		SendNUIMessage({action = "hide"})
	end
end)

RegisterNetEvent('10system:Update')
AddEventHandler('10system:Update', function(data, channel)
	local duty = exports[Config.PoliceResource]:duty()
	if isValidJob() and duty then
		local id = GetPlayerServerId(PlayerId())

		if channel and channel > 0 and data[tostring(id)].channel ~= channel then
			return;
		end

		for i,v in pairs(data) do 
			   if v.src == id then
				v.me = true
			end
		end
		SendNUIMessage({action = "update", data = data})
	end
end)

RegisterNUICallback('gradeCode', function(data,cb)

	TriggerServerEvent('10system:Server:code', {data.code, data.grade})
end)

RegisterNUICallback('closeActive', function()
	show = false
end)

RegisterNUICallback('openActive', function()
	show = true
end)

RegisterNUICallback('close', function()
	SetNuiFocus(false, false)
end)

function isValidJob()
	return PlayerJob.name == 'police'
end

RegisterCommand("+open10System",function()
	if (PlayerJob.name == "police") then
		if not show then 
			SendNUIMessage({action = "settings"})
		end
		SetNuiFocus(true, true)
	end
end)

RegisterKeyMapping('+open10System', 'Open 10system (Police only)', 'keyboard', 'EQUALS')