local TweenService = game:GetService("TweenService")

local settingsChanger = {}
local player = game.Players.LocalPlayer
local mode = player:WaitForChild("PlayerGui"):WaitForChild("gui"):WaitForChild("main"):WaitForChild("mode")

function settingsChanger.show(side, frame)
	local parent = frame.Parent
	local parentSizeX = parent.AbsoluteSize.X

	local frameScaleX = frame.Size.X.Scale
	local modeScaleX = mode.Size.X.Scale
	local modePosScaleX = mode.Position.X.Scale

	local targetX

	if side == "left" then
		frame.Position = UDim2.new(modePosScaleX - modeScaleX / 2 + frameScaleX / 2, 0, frame.Position.Y.Scale, 0)
		frame.Visible = true

		targetX = modePosScaleX - modeScaleX / 2 - frameScaleX / 2
		mode.UICornerOverlayL.Visible = true
	elseif side == "right" then
		frame.Position = UDim2.new(modePosScaleX + modeScaleX / 2 - frameScaleX / 2, 0, frame.Position.Y.Scale, 0)
		frame.Visible = true

		targetX = modePosScaleX + modeScaleX / 2 + frameScaleX / 2
		mode.UICornerOverlayR.Visible = true
	end

	local targetPosition = UDim2.new(targetX, 0, frame.Position.Y.Scale, 0)
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(frame, tweenInfo, { Position = targetPosition })

	tween:Play()
end

function settingsChanger.hide(side, frame)
	local parent = frame.Parent

	local frameScaleX = frame.Size.X.Scale
	local modeScaleX = mode.Size.X.Scale
	local modePosScaleX = mode.Position.X.Scale

	local startX
	local targetX

	if side == "left" then
		startX = modePosScaleX - modeScaleX / 2 - frameScaleX / 2
		targetX = modePosScaleX - modeScaleX / 2 + frameScaleX / 2
		frame.Position = UDim2.new(startX, 0, frame.Position.Y.Scale, 0)
		frame.Visible = true
		mode.UICornerOverlayL.Visible = false
	elseif side == "right" then
		startX = modePosScaleX + modeScaleX / 2 + frameScaleX / 2
		targetX = modePosScaleX + modeScaleX / 2 - frameScaleX / 2
		frame.Position = UDim2.new(startX, 0, frame.Position.Y.Scale, 0)
		frame.Visible = true
		mode.UICornerOverlayR.Visible = false
	end

	local targetPosition = UDim2.new(targetX, 0, frame.Position.Y.Scale, 0)
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(frame, tweenInfo, { Position = targetPosition })

	tween:Play()
	tween.Completed:Connect(function()
		frame.Visible = false
	end)
end

return settingsChanger
