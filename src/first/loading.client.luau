local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TweenService = game:GetService("TweenService")

local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

ReplicatedFirst:RemoveDefaultLoadingScreen()

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local loadingScreen = script:WaitForChild("loadingScreen"):Clone()
loadingScreen.Parent = playerGui

local frame = loadingScreen:WaitForChild("base")
local loadingText = frame:WaitForChild("generalInfo")
local moreInfo = frame:WaitForChild("info")
local bar = frame:WaitForChild("loadingBar"):WaitForChild("bar")

local assets = game:GetDescendants()
for i, v in assets do
	moreInfo.Text = v.Name.."\n"..moreInfo.Text
	ContentProvider:PreloadAsync({v})
	local progress = i / #assets
	loadingText.Text = "Loading: "..i.." / "..#assets
	bar.Size = UDim2.new(progress, 0, 1, 0)
end

local tween = TweenService:Create(frame, tweenInfo, { BackgroundTransparency = 1 })
tween:Play()
tween.Completed:Connect(function(playbackState)
	loadingScreen:Destroy()
end)
for i, v in frame:GetDescendants() do
	if v:IsA("Frame") then
		local tween = TweenService:Create(v, tweenInfo, { BackgroundTransparency = 1 })
		tween:Play()
	elseif v:IsA("TextLabel") then
		local tween = TweenService:Create(v, tweenInfo, { TextTransparency = 1 })
		tween:Play()
	end
end