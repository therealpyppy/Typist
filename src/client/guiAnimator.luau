local TweenService = game:GetService("TweenService")

local settingsChanger = {}
local player = game.LocalPlayer
local mode = player:WaitForChild("PlayerGUI"):WaitForChild("gui"):WaitForChild("main"):WaitForChild("mode")

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

return settingsChanger
