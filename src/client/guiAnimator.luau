local TweenService = game:GetService("TweenService")

local guiAnimator = {}

local player = game.Players.LocalPlayer
local mode = player:WaitForChild("PlayerGui"):WaitForChild("gui"):WaitForChild("main"):WaitForChild("mode")

local function adjustFramePositions(frameData)
	local leftmost, rightmost = math.huge, -math.huge

	for _, data in ipairs(frameData) do
		local frame = data.frame
		local pos, size = data.targetPosition, frame.Size

		frame.AnchorPoint = Vector2.new(0.5, frame.AnchorPoint.Y)

		local center = pos.X.Scale
		local halfWidth = size.X.Scale / 2
		local leftEdge, rightEdge = center - halfWidth, center + halfWidth

		leftmost = math.min(leftmost, leftEdge)
		rightmost = math.max(rightmost, rightEdge)
	end

	local offset = 0.5 - (leftmost + rightmost) / 2

	local adjusted = {}
	for _, data in ipairs(frameData) do
		local pos = data.targetPosition
		local adjustedPos = UDim2.new(pos.X.Scale + offset, pos.X.Offset, pos.Y.Scale, pos.Y.Offset)
		table.insert(adjusted, { frame = data.frame, targetPosition = adjustedPos })
	end

	return adjusted
end

local function computeFramePosition(side, frame)
	local frameScaleX = frame.Size.X.Scale
	local modeScaleX = mode.Size.X.Scale
	local modePosScaleX = mode.Position.X.Scale

	local startX, targetX

	if side == "left" then
		startX = modePosScaleX - modeScaleX / 2 + frameScaleX / 2
		targetX = modePosScaleX - modeScaleX / 2 - frameScaleX / 2
	elseif side == "right" then
		startX = modePosScaleX + modeScaleX / 2 - frameScaleX / 2
		targetX = modePosScaleX + modeScaleX / 2 + frameScaleX / 2
	end

	return startX, targetX
end

function guiAnimator.show(...)
	local args = { ... }
	local frameData = { { frame = mode, targetPosition = mode.Position } }

	for _, pair in ipairs(args) do
		local side, frame = pair[1], pair[2]
		local startX, targetX = computeFramePosition(side, frame)

		frame.Position = UDim2.new(startX, 0, frame.Position.Y.Scale, 0)
		frame.Visible = true

		if side == "left" then
			mode.UICornerOverlayL.Visible = true
		elseif side == "right" then
			mode.UICornerOverlayR.Visible = true
		end

		local targetPosition = UDim2.new(targetX, 0, frame.Position.Y.Scale, 0)
		table.insert(frameData, { frame = frame, targetPosition = targetPosition })
	end

	return adjustFramePositions(frameData)
end

function guiAnimator.hide(...)
	local args = { ... }
	local frameData = { { frame = mode, targetPosition = mode.Position } }

	for _, pair in ipairs(args) do
		local side, frame = pair[1], pair[2]
		local targetX, endX = computeFramePosition(side, frame)

		frame.Position = UDim2.new(targetX, 0, frame.Position.Y.Scale, 0)
		frame.Visible = true

		if side == "left" then
			mode.UICornerOverlayL.Visible = false
		elseif side == "right" then
			mode.UICornerOverlayR.Visible = false
		end

		local targetPosition = UDim2.new(endX, 0, frame.Position.Y.Scale, 0)
		table.insert(frameData, { frame = frame, targetPosition = targetPosition })
	end

	return adjustFramePositions(frameData)
end

return guiAnimator
