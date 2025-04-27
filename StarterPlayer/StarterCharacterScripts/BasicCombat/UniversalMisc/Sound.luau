--!strict
--[[
Title: [Your Script Title]
Description: [Short description of what this script does]
Author: [Eletrodude]
Date: [10/03/2025]
--]]

-- SERVICES
-- (Game services like Players, DataStoreService, ReplicatedStorage, etc.)
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local PlayerService = game:GetService('Players')
-- MODULES
-- (Require any external modules or scripts)
local Volume = require(ReplicatedStorage:WaitForChild('Modules'):WaitForChild('VolumeClient'))
-- VARIABLES
-- (Local variables that store data or references)
local SoundFolder = ReplicatedStorage:WaitForChild('Remotes'):WaitForChild('Auxilliary')
local SoundEvent = SoundFolder:WaitForChild('SoundEvent')
-- CONSTANTS
-- (Values that do not change throughout the script)
local Player = PlayerService.LocalPlayer
-- (Define reusable functions here)
local function PlaySound(Player:Player,Sound:Sound)
	local TotalVolume = Volume.AudioHandler(Player,Sound)
	Sound.Volume = TotalVolume
	Sound:Play()
	
	game.Debris:AddItem(Sound,Sound.TimeLength+1)
	
end
-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)
-- HANDLERS
-- (Event listeners and connections)
SoundEvent.OnClientEvent:Connect(function(Sound)
	print('reaching')
	if not Sound then 
		warn('No sound found')
		return
	end
	
	PlaySound(Player,Sound)
end)
-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)
