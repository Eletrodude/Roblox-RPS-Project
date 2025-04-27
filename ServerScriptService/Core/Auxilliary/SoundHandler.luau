--!strict
--[[
Title: [Audio handler]
Description: [Handles audio dynamically]
Author: [Eletrodude]
Date: [10/03/2025]
--]]
-- SERVICES
-- (Game services like Players, DataStoreService, ReplicatedStorage, etc.)
local ServerStorage = game:GetService('ServerStorage')

-- MODULES
-- (Require any external modules or scripts)
-- VARIABLES
-- (Local variables that store data or references)
local GlobalAudio = ServerStorage.GlobalSounds

-- CONSTANTS
-- (Values that do not change throughout the script)
-- FUNCTIONS
-- (Define reusable functions here)
-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)
for index,value in pairs(GlobalAudio:GetChildren()) do 
	for num,Attributes in pairs(value:GetChildren()) do
		if value.Name == 'Effects' then 
			Attributes:SetAttribute('EffectsAudio',true)
			Attributes:SetAttribute('MusicAudio',false)
		elseif value.Name == 'Music' then 
			Attributes:SetAttribute('EffectsAudio',false)
			Attributes:SetAttribute('MusicAudio',true)
		end		
		
	end
	
	
end
-- HANDLERS
-- (Event listeners and connections)
-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)





