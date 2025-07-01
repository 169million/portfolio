-- NEEDS TO BE IN LOCALSCRIPT
local player = game.Players.LocalPlayer
local character = player.character
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://[ANIMATION_ID_HERE]"
local animationTrack = animator:LoadAnimation(animation)
animationTrack:Play()
