local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

_G.inteleport = {}

-- Config
local placeId = 79002926326482 -- Replace with your actual place ID
local MAX_PLAYERS = 8
local MIN_PLAYERS = 2
local TIMER_DURATION = 20

-- References
local l1d = Workspace:WaitForChild("LobbyL1"):WaitForChild("Door 1")
local exitbutton = ReplicatedStorage:WaitForChild("exitbutton")
local promptPart = l1d:WaitForChild("PromtPart")
local prompt = promptPart:WaitForChild("ProximityPrompt")
local TextPart = l1d:WaitForChild("TextPart")
local TextLabel = TextPart:WaitForChild("SurfaceGui"):WaitForChild("TextLabel")
TextLabel.Text = "Waiting for Players"
local room = "room1"

-- Image Area
local Images = {
	promptPart.SurfaceGui:WaitForChild("I1"),
	promptPart.SurfaceGui:WaitForChild("I2"),
	promptPart.SurfaceGui:WaitForChild("I3"),
	promptPart.SurfaceGui:WaitForChild("I4"),
	promptPart.SurfaceGui:WaitForChild("I5"),
	promptPart.SurfaceGui:WaitForChild("I6"),
	promptPart.SurfaceGui:WaitForChild("I7"),
	promptPart.SurfaceGui:WaitForChild("I8")
}

-- State
local teleportQueue = {}
local teleporting = false
local timerRunning = false
local stop = false

-- Make a player transparent or visible
local function Playertrans(player, transparency)
	local character = player.Character or player.CharacterAdded:Wait()
	for _, part in pairs(character:GetDescendants()) do
		if (part:IsA("BasePart") and part.Name ~= "HumanoidRootPart") or part:IsA("Decal") then
			part.Transparency = transparency
		end
	end
end

-- Teleport players
local function teleportPlayers(players)
	teleporting = true

	local success, codeOrError = pcall(function()
		return TeleportService:ReserveServer(placeId)
	end)

	if success then
		local options = Instance.new("TeleportOptions")
		options.ReservedServerAccessCode = codeOrError
		TeleportService:TeleportAsync(placeId, players, options)
	else
		warn("Teleport failed:", codeOrError)
	end

	TextLabel.Text = "Waiting for Players"

	-- Clean up
	local teleportSet = {}
	for _, p in ipairs(teleportQueue) do
		teleportSet[p] = true
	end

	for i = #_G.inteleport, 1, -1 do
		if teleportSet[_G.inteleport[i]] then
			table.remove(_G.inteleport, i)
		end
	end

	teleportQueue = {}
	timerRunning = false
	stop = false
	teleporting = false

	for _, image in ipairs(Images) do
		image.Image = ""
	end
end

-- Start teleport countdown
local function startTeleportTimer(player)
	if timerRunning then return end
	timerRunning = true
	stop = false

	for i = TIMER_DURATION, 0, -1 do
		if stop and #teleportQueue < MIN_PLAYERS then
			TextLabel.Text = "Waiting for Players"
			timerRunning = false
			return
		end

		TextLabel.Text = tostring(i)
		wait(1)
	end

	if #teleportQueue >= MIN_PLAYERS then
		TextLabel.Text = "Teleporting"
		teleportPlayers(teleportQueue)
	else
		warn("Not enough players to teleport.")
		for _, p in ipairs(teleportQueue) do
			Playertrans(p, 0)
			exitbutton:FireClient(p,false,nil)
		end
		teleportQueue = {}
		TextLabel.Text = "Not enough players"
		wait(1.5)
		TextLabel.Text = "Waiting for Players"
		timerRunning = false
		for _, image in ipairs(Images) do
			image.Image = ""
		end
	end
end

-- Player joins teleport queue
prompt.Triggered:Connect(function(player)
	if teleporting or table.find(teleportQueue, player) or table.find(_G.inteleport, player) then return end
	if #teleportQueue == MAX_PLAYERS then return end

	exitbutton:FireClient(player, true, room)

	table.insert(teleportQueue, player)
	table.insert(_G.inteleport, player)
	Playertrans(player, 1)

	-- Get and display player headshot
	local userId = player.UserId
	local thumbType = Enum.ThumbnailType.HeadShot
	local thumbSize = Enum.ThumbnailSize.Size420x420

	local success, content = pcall(function()
		return Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
	end)

	if success and Images[#teleportQueue] then
		Images[#teleportQueue].Image = content
	end

	if #teleportQueue == 1 then
		startTeleportTimer(player)
	end

	if #teleportQueue == MAX_PLAYERS then
		teleportPlayers(teleportQueue)
	end
end)

-- Player leaves teleport queue
exitbutton.OnServerEvent:Connect(function(player, r)
	if r == room then
		local userId = player.UserId
		local thumbType = Enum.ThumbnailType.HeadShot
		local thumbSize = Enum.ThumbnailSize.Size420x420

		local success, content = pcall(function()
			return Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
		end)

		local inum = 0
		for i, p in ipairs(teleportQueue) do
			if p == player then
				table.remove(teleportQueue, i)
				break
			end
		end

		for i, p in ipairs(_G.inteleport) do
			if p == player then
				table.remove(_G.inteleport, i)
				break
			end
		end

		if success then
			for i, image in ipairs(Images) do
				if image.Image == content then
					image.Image = ""
					inum = i
				end
			end

			for i = inum, MAX_PLAYERS - 1 do
				if Images[i] and Images[i + 1] then
					Images[i].Image = Images[i + 1].Image
				end
			end

			if Images[MAX_PLAYERS] then
				Images[MAX_PLAYERS].Image = ""
			end
		end

		Playertrans(player, 0)
		stop = true
	end
end)
