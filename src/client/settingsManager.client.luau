local player = game.Players.LocalPlayer
local ts = game:GetService("TweenService")
local playerGui = player:WaitForChild("PlayerGui"):WaitForChild("gui"):WaitForChild("main")

local guiAnimator = require(script.Parent.guiAnimator)

local mode = playerGui:WaitForChild("mode")
local puncAndNum = playerGui:WaitForChild("puncAndNum")
local quoteLength = playerGui:WaitForChild("quoteLength")
local wordTime = playerGui:WaitForChild("wordTime")

local currentMode = "time" -- TODO: Store user data to save what mode the use on start
local launch = true

local function move(frame, targetPosition)
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local tween = ts:Create(frame, tweenInfo, { Position = targetPosition })
	tween:Play()
end

local function fade(object, transparency)
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local tween = ts:Create(object, tweenInfo, { TextTransparency = transparency })
	tween:Play()
	return tween
end

local function showWords()
	if currentMode == "time" and not launch then
		fade(wordTime.time1, 1)
		fade(wordTime.time2, 1)
		fade(wordTime.time3, 1)
		local tween = fade(wordTime.time4, 1)
		tween.Completed:Connect(function(playbackState)
			fade(wordTime.word1, 0)
			fade(wordTime.word2, 0)
			fade(wordTime.word3, 0)
			fade(wordTime.word4, 0)
		end)
	else
		local ogTweenPos = guiAnimator.show({"left", puncAndNum}, {"right", wordTime})

		local frameData = {
			{
				frame = mode,
				targetPosition = mode.Position
			}
		}

		for _, data in ipairs(ogTweenPos) do
			table.insert(frameData, data)
		end

		local leftmost = math.huge
		local rightmost = -math.huge

		for _, data in ipairs(frameData) do
			local frame = data.frame
			local pos = data.targetPosition
			local size = frame.Size

			frame.AnchorPoint = Vector2.new(0.5, frame.AnchorPoint.Y)

			local center = pos.X.Scale
			local halfWidth = size.X.Scale / 2

			local leftEdge = center - halfWidth
			local rightEdge = center + halfWidth

			if leftEdge < leftmost then
				leftmost = leftEdge
			end
			if rightEdge > rightmost then
				rightmost = rightEdge
			end
		end

		local groupCenter = (leftmost + rightmost) / 2
		local offset = 0.5 - groupCenter

		for _, data in ipairs(frameData) do
			local frame = data.frame
			local pos = data.targetPosition

			local adjustedPos = UDim2.new(
				pos.X.Scale + offset, pos.X.Offset,
				pos.Y.Scale, pos.Y.Offset
			)

			move(frame, adjustedPos)
		end
	end
	currentMode = "words"
end

showWords()