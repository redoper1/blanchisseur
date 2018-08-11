--[[
##################
#    Oskarr      #
#    MysticRP    #
#   client.lua   #
#      2017      #
##################
Edited by: redoper, 2018
--]]

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local showBlip = true
local maxDirty = 100000
local openKey = 51
local emplacement = {
{name="Money laundry", id=500, colour=75, x=1269.73, y=-1710.25, z=54.7715},
}
local options = {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.04,
    scale = 0.4,
    font = 0,
    menu_title = "Money laundry",
    menu_subtitle = "Menu",
    color_r = 255,
    color_g = 10,
    color_b = 20,
}

-- Show blip
Citizen.CreateThread(function()
 if (showBlip == true) then
    for _, item in pairs(emplacement) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipColour(item.blip, item.colour)
      SetBlipAsShortRange(item.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
    end
 end
end)

--- Location
Citizen.CreateThread(
	function()
		local x = 1269.73
		local y = -1710.25
		local z = 54.7715
		while true do
			Citizen.Wait(0)
			local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
			if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 100.0) then
				DrawMarker(0, x, y, z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.0001, 255, 10, 10,165, 0, 0, 0,0)
				if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 4.0) then
					DisplayHelpText('Press ~INPUT_CONTEXT~ to ~g~launder~s~ your ~r~dirty money')
					if (IsControlJustReleased(1, openKey)) then
						LaundryMoneyMenu()
						Menu.hidden = not Menu.hidden
					end
					Menu.renderGUI(options)
				end

			end
		end
end)


---- FONCTIONS ----
function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
---------------------
---- Menu
function LaundryMoneyMenu()
   options.menu_subtitle = "Money laundry"
    ClearMenu()
	Menu.addButton("Launder the money", "LaundryMoney", -1)
	Menu.addButton("Close the menu", "CloseMenu", nil)
end

function CloseMenu()
    Menu.hidden = true
end
--------------------------------------------
function LaundryMoney(amount)
		if(amount == -1) then
			DisplayOnscreenKeyboard(1, "", "", "", "", "", "", 20)
			while (UpdateOnscreenKeyboard() == 0) do
				DisableAllControlActions(0);
				Wait(0);
			end
			if (GetOnscreenKeyboardResult()) then
				local res = tonumber(GetOnscreenKeyboardResult())
				if(res ~= nil and res ~= 0 and res <= maxDirty) then
					amount = res
                else
                 ESX.ShowNotification("~r~You can not launder that much at once! Maximum at once is $"..maxDirty)
				end
			end
		end
		if(amount ~= -1 and amount ~= nil) then
			TriggerServerEvent("blanchisseur:BlanchirCash", tonumber(amount))
		elseif (amount == nil) then
			ESX.ShowNotification('~h~~r~ERROR:~nrt~ amount to launder is NIL!!!')
		end
end
-----------------
