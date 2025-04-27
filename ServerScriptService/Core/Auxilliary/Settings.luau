--!strict
--[[
Title: [Settings]
Description: [Allows players to change settings dynamically]
Author: [Eletrodude]
Date: [26/03/2025]
--]]
-- SERVICES
-- (Game services like Players, DataStoreService, ReplicatedStorage, etc.)
local ServerScriptService = game:GetService('ServerScriptService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local DataStore = game:GetService('DataStoreService')
local Players = game:GetService('Players')

-- MODULES
-- (Require any external modules or scripts)
local SettingsModule = require(ServerScriptService.Infos.Settings)

-- VARIABLES
-- (Local variables that store data or references)
local PlayerTable  = {}


-- CONSTANTS
-- (Values that do not change throughout the script)
local SettingsEvent = ReplicatedStorage.Remotes.Auxilliary.SettingsEvent
local dataStore = DataStore:GetDataStore('Settings')
-- FUNCTIONS
-- (Define reusable functions here)




local function OnJoin(Player:Player)
	if not PlayerTable[Player.UserId] then 
		PlayerTable[Player.UserId] = SettingsModule.new(Player)
	end
end

--[[
Categories are:
- Combat: Game mechanics related settings
- Player: Character-specific settings
- PerformanceSettings: Graphics and rendering configurations
- Debug: Diagnostic and development settings
- Audio: Sound and volume configurations

settingName are:
- For Combat:
  * DefaultAttackCooldown: Initial attack speed
  * MaxComboCount: Maximum number of combo hits
  * DefaultDamage: Base damage for attacks
  * ResetTimer: Time before combo resets
  * FinalComboHit: Combo threshold for special attack

- For Player:
  * Health: Starting player health
  * Sprint: Movement speed multiplier

- For PerformanceSettings:
  * RenderDistance: How far game objects are rendered
  * Effects: Quality of visual effects
  * ShowHitboxes: Debug visualization of hitbox areas
  * EnableParticles: Toggle particle effects

- For Debug:
  * EnableLogging: Toggle detailed logging
  * ShowHitboxes: Visual hitbox debugging
  * VerboseErrorReporting: Detailed error messages

- For Audio:
  * MasterVolume: Overall sound volume
  * MusicVolume: Background music volume
  * SFXVolume: Sound effects volume
]]
local function SetDefaults(Player:Player,Category,SettingsName,Value)
	PlayerTable[Player.UserId]:SetSettings(Category,SettingsName,Value)
end

local function GetDefaults(Player)
	return PlayerTable[Player.UserId]:GetSettings()
end

local function SetDataStore(Player,Settings)
	return PlayerTable[Player.UserId]:SaveSettings()
end

local function GetDataStore(Player)
	return PlayerTable[Player.UserId]:LoadSettings()
end

local function clearDataStore()
	-- WARNING: This will delete ALL data in the DataStore
	local success, err = pcall(function()
		-- Retrieve all keys
		local pages = dataStore:ListKeysAsync(100)

		while true do
			local keys = pages:GetCurrentPage()

			if #keys == 0 then
				break
			end

			-- Remove each key
			for _, key in ipairs(keys) do
				dataStore:RemoveAsync(key.KeyName)
				print("Removed key: " .. key.KeyName)
			end

			-- Move to next page of keys
			if not pages.IsFinished then
				pages:AdvanceToNextPageAsync()
			else
				break
			end
		end
	end)

	if success then
		print("DataStore cleared successfully!")
	else
		warn("Error clearing DataStore: " .. tostring(err))
	end
end

-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)

Players.PlayerAdded:Connect(function(Player)
	OnJoin(Player)
	
	Player.CharacterAdded:Connect(function(Character)
		
		if Character:GetAttribute('LoadedIn') == true then 
			return
		else
			
			Character:SetAttribute('LoadedIn',true)
			local Data = GetDataStore(Player)
			warn(Data)
			
			
			local DataForClient = 
				{
				Audio = Data.Audio,
				GeneralSettings = Data.GeneralSettings,
					PerformanceSettings = Data.PerformanceSettings
				}
			
			Character:SetAttribute('MasterVolume',Data.Audio['MasterVolume'])
			Character:SetAttribute('EffectsVolume',Data.Audio['SFXVolume'])
			Character:SetAttribute('MusicVolume',Data.Audio['MusicVolume'])
			--print(DataForClient)
			
			--warn(Character:GetAttribute('MasterVolume'))
			--warn(Character:GetAttribute('EffectsVolume'))
			--warn(Character:GetAttribute('MusicVolume'))

			

			
			SettingsEvent:FireClient(Player,DataForClient)
			--warn(Data)
		end
		
	end)
	
end)

Players.PlayerRemoving:Connect(function(Player)
	SetDataStore(Player)
end)


-- HANDLERS
-- (Event listeners and connections)
SettingsEvent.OnServerEvent:Connect(function(Player,Category,SettingName,Value)
	--SetDefaults(Player,'Audio','MasterVolume',value)
	print(Category,SettingName,Value)
	SetDefaults(Player,Category,SettingName,Value)
	
	if Category == 'Audio' then
		local Character = Player.Character
		print(Category,SettingName)
		
		if SettingName == 'SFXVolume' then 
			Character:SetAttribute('EffectsVolume',Value)
			SettingName = 'EffectsVolume'
		else
			Character:SetAttribute(SettingName,Value)
		end
		
	
		
		warn(Character:GetAttribute(SettingName))
	end
	
end)
-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)




--local DataStoreService = game:GetService("DataStoreService")

---- Replace "YourDataStoreName" with the actual name of your DataStore
--local dataStore = DataStoreService:GetDataStore("Settings")

-- Function to clear all values


-- Call the function to clear the DataStore
--clearDataStore()