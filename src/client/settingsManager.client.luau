local player = game.Players.LocalPlayer
local ts = game:GetService("TweenService")
local playerGui = player:WaitForChild("PlayerGui"):WaitForChild("gui"):WaitForChild("main")

local guiAnimator = require(script.Parent.guiAnimator)

local mode = playerGui:WaitForChild("mode")
local puncAndNum = playerGui:WaitForChild("puncAndNum")
local quoteLength = playerGui:WaitForChild("quoteLength")
local wordTime = playerGui:WaitForChild("wordTime")

local currentMode = "time" -- TODO: Store user data to save what mode the user had on start
local launch = true

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function move(frame, targetPosition)
	ts:Create(frame, tweenInfo, { Position = targetPosition }):Play()
end

local function fade(object, transparency)
	local tween = ts:Create(object, tweenInfo, { TextTransparency = transparency })
	tween:Play()
	return tween
end

local function showWords()
	if launch or currentMode == "zen" then
		local ogTweenPos = guiAnimator.show({"left", puncAndNum}, {"right", wordTime})

		for _, data in ogTweenPos do
			move(data[0], data[1])
		end
	elseif currentMode == "time" then
		fade(wordTime.time1, 1)
		fade(wordTime.time2, 1)
		fade(wordTime.time3, 1)
		local tween = fade(wordTime.time4, 1)
		tween.Completed:Connect(function()
			fade(wordTime.word1, 0)
			fade(wordTime.word2, 0)
			fade(wordTime.word3, 0)
			fade(wordTime.word4, 0)
		end)
	elseif currentMode == "quote" then
		-- Tweenout puncAndNum while tweening in quoteLength
		-- Then moveout wordTime
		-- and if the boxes for time are visible fade therm out and fade in word
	end
	currentMode = "words"
end

showWords()
