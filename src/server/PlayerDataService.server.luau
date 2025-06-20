local PlayerDataHandler: ModuleScript = require(script.Parent.PlayerDataHandler)
PlayerDataHandler:Init()

local Players = game:GetService("Players")
local getUserData: RemoteFunction = game:GetService("ReplicatedStorage").getUserData

getUserData.OnServerInvoke = function(player)
	return PlayerDataHandler:Get(player, "Settings")
end

local function isValid(data)
	if type(data) == type(0) and string.len(tostring(data)) == 4 then
		local data = data:split("")
		if math.clamp(data[1], 0, 3) ~= data[1] then
			return false, 0
		elseif math.clamp(data[2], 0, 3) ~= data[2] then
			return false, 0
		elseif math.clamp(data[3], 0, 5) ~= data[3] then
			return false, 0
		elseif math.clamp(data[4], 0, 5) ~= data[4] then
			return false, 0
		elseif math.clamp(data[5], 0, 4) ~= data[5] then
			return false, 0
		else
			return true, 1
		end
	elseif type(data) == type({0,0}) and table.len(data) == 4 then
	end
end