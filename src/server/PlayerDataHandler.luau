local PlayerDataHandler = {}

local dataTemplate = {
	Settings = {
		PreviousMode = {}
	}
}

local ProfileService = require(script.Parent.ProfileService)
local Players = game:GetService("Players")

local ProfileStore = ProfileService.GetProfileStore(
	"PlayerProfile",
	dataTemplate
)

local Profiles = {}

local function playerAdded(player)
	local profile = ProfileStore:LoadProfileAsync("Player_"..player.UserId)

	if profile then
		profile:AddUserId(player.UserId)
		profile:Reconcile()

		profile:ListenToRelease(function()
			Profiles[player] = nil

			player:Kick()
		end)

		if not player:IsDescendantOf(Players) then
			profile:Release()
		else
			Profiles[player] = profile
			print(Profiles[player].Data)
		end
	else
		player:Kick("Err 1: No Profile Found")
	end
end

function PlayerDataHandler:Init()
	for _,player in game.Players:GetPlayers() do
		task.spawn(playerAdded, player)
	end

	game.Players.PlayerAdded:Connect(playerAdded)
	game.Players.PlayerRemoving:Connect(function(player)
		if Profiles[player] then
			Profiles[player]:Release()
		end
	end)
end

local function getProfile(player)
	assert(Profiles[player], "Profile does not exist for "..tostring(player.UserId))
	return Profiles[player]
end

function PlayerDataHandler:Get(player, key)
	local profile = getProfile(player)
	assert(profile.Data[key], "Data does not exist for key: "..key)

	return profile.Data[key]
end

function PlayerDataHandler:Set(player, key, value)
	local profile = getProfile(player)
	assert(profile.Data[key], "Data does not exist for key: "..key)

	assert(type(profile.Data[key]) == type(value), "Value type does not match key type")
	profile.Data[key] = value
end

function PlayerDataHandler:Update(player, key, callback)
	local profile = getProfile(player)

	local oldData = self:Get(player, key)
	local newData = callback(oldData)

	self:Set(player, key, newData)
end

return PlayerDataHandler