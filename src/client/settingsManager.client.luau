local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui"):WaitForChild("gui"):WaitForChild("main")

local guiAnimator = require(script.Parent.guiAnimator)

local mode = playerGui:WaitForChild("mode")
local puncAndNum = playerGui:WaitForChild("puncAndNum")
local quoteLength = playerGui:WaitForChild("quoteLength")
local wordTime = playerGui:WaitForChild("wordTime")

local function showWords()
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

		-- TODO: tweenOut(frame, adjustedPos)
	end
end


showWords()