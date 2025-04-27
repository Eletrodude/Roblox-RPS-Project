--!strict
--[[
Title: [Cutscene Received Script]
Description: [When cutscene is over, disable screenGui]
Author: [Eletrodude]
Date: [16/03/2025]
--]]
-- SERVICES
-- (Game services like Players, DataStoreService, ReplicatedStorage, etc.)
local ReplicatedStorage = game:GetService('ReplicatedStorage')
-- VARIABLES
-- (Local variables that store data or references)
-- CONSTANTS
-- (Values that do not change throughout the script)
local CutsceneEvent = ReplicatedStorage:WaitForChild('Remotes'):WaitForChild('Auxilliary'):WaitForChild('FireCutscene')
local PickAbility = ReplicatedStorage:WaitForChild('BindableEvents'):WaitForChild('PickAbility')
-- MODULES
-- (Require any external modules or scripts)
local Maid = require(game:GetService('ServerScriptService').Modules.CoreModules.Maid)
local Winner = require(game:GetService('ServerScriptService').Modules.CoreModules.WinnerTable)
-- FUNCTIONS
-- (Define reusable functions here)
local function onReceive()
	local Round =workspace:GetAttribute('Round')
	local WinnerPlayer = Winner.LookForWinner(Round)
	
	
	CutsceneEvent:FireAllClients(WinnerPlayer)
	task.wait(1)
	PickAbility:Fire()
	
	task.delay(3,function()
		if workspace:GetAttribute('CutsceneEnded') == false then
			repeat task.wait(0.5)
				PickAbility:Fire()
			until workspace:GetAttribute('CutsceneEnded') == true
			
		end
	end)
	

end
-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)
local MaidInstance = Maid.new()
CutsceneEvent.OnServerEvent:Connect(function(Player)
	local Round = workspace:GetAttribute('Round')
	local PlayerWhoWon:{Player} = Winner.LookForWinner(Round)
	
	CutsceneEvent:FireAllClients(PlayerWhoWon)
	PickAbility:Fire()
	
end)
-- HANDLERS
-- (Event listeners and connections)
-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)