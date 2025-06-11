local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

char.Humanoid.WalkSpeed = 0
char.Humanoid.JumpPower = 0
char.Humanoid.UseJumpPower = true