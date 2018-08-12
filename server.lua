--[[
##################
#    Oskarr      #
#    MysticRP    #
#   server.lua   #
#      2017      #
##################
Edited by: redoper, 2018
--]]

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local tax = 0.80 -- 0.80 : 100000$ dirty = 80000$  // 0.80 : 100 000 dirty money = 80 000$ clean money


RegisterServerEvent("blanchisseur:BlanchirCash")
AddEventHandler("blanchisseur:BlanchirCash", function(amount)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local money = xPlayer.getMoney()
	local dirtyMoney = xPlayer.getAccount('black_money').money
	local amount = amount

	if (dirtyMoney <= 0) then
		TriggerClientEvent("esx:showNotification", source, "~y~Tu n'a pas d'argent à blanchir.")
	else
		local washedMoney = amount * tax
		local total = money + washedMoney
		local totald = dirtyMoney - amount
		xPlayer.setMoney(total)
		xPlayer.setAccountMoney('black_money', totald)
		TriggerClientEvent("esx:showNotification", source, "Vous avez blanchi ~r~$".. tonumber(amount) .."~s~ d'argent sale.~s~ Vous avez maintenant ~g~$".. tonumber(total) ..".")
	end
end)
