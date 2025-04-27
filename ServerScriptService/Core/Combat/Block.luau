--!strict 

--Title: [Block Script]
--Description: [Verifies player blocking]
--Author: [Eletrodude]
--Date: [10/03/2025]

-- SERVICES
-- (Game services like Players, DataStoreService, ReplicatedStorage, etc.)
local ServerScriptService = game:GetService('ServerScriptService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
-- MODULES
-- (Require any external modules or scripts)
local AttributeModule = require(ServerScriptService.Modules.AuxilliaryModules.AttributeModule)
local ConfigTable = require(ServerScriptService.Infos.CombatConfiguration)
local SoundModule = require(ServerScriptService.Modules.AuxilliaryModules.PlaySound)
-- VARIABLES
-- (Local variables that store data or references)
local Config = {}
local BlockEvent = ReplicatedStorage.Remotes.UniversalCombat.Block
-- CONSTANTS
-- (Values that do not change throughout the script)
local BlockTable:{[number]:{}} = {}
-- FUNCTIONS
-- (Define reusable functions here)
local function VerifyBlock(Player:Player,bool:boolean):boolean
	local ReturnBool = false
	
	if not BlockTable[Player.UserId] then 
		BlockTable[Player.UserId] = {CanBlock = false,BlockDebounce = 0.5}
	end
	
	local State,Attribute = AttributeModule.CheckAttributes(Player,nil,nil,'IsBlocking')
	
	print(State,Attribute)
	if State == false and Attribute ~= 'Continue' then 
		warn('Cannot Block') 
		return false
	end
	
	return true
end

local function HandleBlock(Player:Player,Boolean:boolean)
	if not Player then 
		warn('No player')
		return
	end
	
	local Character:Model = Player.Character::Model
	local Humanoid = Character:FindFirstChildWhichIsA('Humanoid')::Humanoid
	
	if not Character then 
		warn('No character') 
		return
	end
	
	if Boolean == true then
		print('Now blocking')
		Character:SetAttribute('IsBlocking',true)
		AttributeModule:ModifyStats(Player,nil,'Block')

		
	else 
		task.wait(0.1)
		print('Now Unblocking')
		Character:SetAttribute('IsBlocking',false)
		AttributeModule:ModifyStats(Player,nil,'Default')
	end
	
end




-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)
-- HANDLERS
-- (Event listeners and connections)
BlockEvent.OnServerEvent:Connect(function(Player,Boolean:boolean)
	local Bool = VerifyBlock(Player,Boolean)
	
	local Character = Player.Character
	

	local Character:Model = Player.Character::Model

	HandleBlock(Player,Boolean)



	
		
	
	
end)
-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)
