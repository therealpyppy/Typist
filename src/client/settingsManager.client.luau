local player = game.Players.LocalPlayer
local ts = game:GetService("TweenService")
local playerGui = player:WaitForChild("PlayerGui"):WaitForChild("gui"):WaitForChild("main")

local guiAnimator = require(script.Parent.guiAnimator)

local mode = playerGui:WaitForChild("mode")
local puncAndNum = playerGui:WaitForChild("puncAndNum")
local quoteLength = playerGui:WaitForChild("quoteLength")
local wordTime = playerGui:WaitForChild("wordTime")

local currentMode = "quote" -- TODO: Store user data to save what mode the user had on start
local launch = false

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function move(frame, targetPosition)
	local tween = ts:Create(frame, tweenInfo, { Position = targetPosition })
	tween:Play()
	return tween
end

local function fade(object, transparency)
	if transparency == 0 then
		object.Visible = true
	end
	local tween = ts:Create(object, tweenInfo2, { TextTransparency = transparency })
	tween:Play()
	tween.Completed:Connect(function()
		if transparency == 1 then
			object.Visible = false
		end
	end)
	return tween
end

local function showWords()
	if launch or currentMode == "zen" then
		local ogTweenPos = guiAnimator.show({"left", puncAndNum}, {"right", wordTime})
		puncAndNum.Visible = true
		wordTime.Visible = true
		for _, data in ogTweenPos do
			move(data.frame, data.targetPosition)
		end
	elseif currentMode == "time" then
		local tweens = {
			fade(wordTime.time1, 1),
			fade(wordTime.time2, 1),
			fade(wordTime.time3, 1),
			fade(wordTime.time4, 1)
		}
		tweens[#tweens].Completed:Connect(function()
			fade(wordTime.word1, 0)
			fade(wordTime.word2, 0)
			fade(wordTime.word3, 0)
			fade(wordTime.word4, 0)
		end)
	elseif currentMode == "quote" then
		local hideTweenData = guiAnimator.hide({"right", quoteLength})

		move(hideTweenData[1].frame, hideTweenData[1].targetPosition)
		move(hideTweenData[2].frame, hideTweenData[2].targetPosition).Completed:Connect(function(playbackState)
			local moveOutWordTime = guiAnimator.show({"right", wordTime}, {"left", puncAndNum})
			for _, data in moveOutWordTime do
				move(data.frame, data.targetPosition)
				quoteLength.Visible = false
			end

			if wordTime.time1.TextTransparency ~= 1 then
				local tweens = {
					fade(wordTime.time1, 1),
					fade(wordTime.time2, 1),
					fade(wordTime.time3, 1),
					fade(wordTime.time4, 1),
				}

				tweens[#tweens].Completed:Connect(function()
					fade(wordTime.word1, 0)
					fade(wordTime.word2, 0)
					fade(wordTime.word3, 0)
					fade(wordTime.word4, 0)
				end)
			end
		end)
	end
	currentMode = "words"
end
task.wait(5)
showWords()
