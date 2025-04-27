--!strict
local DataStoreService = game:GetService('DataStoreService')
export type SettingsTable  = {
	Player:Player,
	
	Settings: {
		Combat: {
			DefaultAttackCooldown: number,
			MaxComboCount: number,
			DefaultDamage: number,
			ResetTimer: number,
			FinalComboHit: number
		},
		PlayerTable: {
			Health: number,
			Sprint: number
		},
		PerformanceSettings: {
			RenderDistance: number,
			Effects: string,
			ShowHitboxes: boolean,
			EnableParticles: boolean
		},
		Debug: {
			EnableLogging: boolean,
			ShowHitboxes: boolean,
			VerboseErrorReporting: boolean
		},
		Audio: {
			MasterVolume: number,
			MusicVolume: number,
			SFXVolume: number
		},
		GeneralSettings: {
			AutoRun: boolean,
			AutoUse: boolean,
			CameraFollow: boolean,
			CameraShake: boolean,
			DamageNumbers: boolean,
			ViewHitboxes: boolean
		}
	}
}




local LoadingService = DataStoreService:GetDataStore('Settings')

local erroredPlayers = {}

local SettingsTable = {} 
SettingsTable.__index = SettingsTable


--Creates a new Table for Player
function SettingsTable.new(Player:Player):SettingsTable
	if not Player or  not Player:IsA('Player') then
		warn('Not a player or invalid')
		return
	end
	
	local self = setmetatable({},SettingsTable)
	
	self.Player = Player
	self.Settings = {
		Combat = {
			DefaultAttackCooldown = 0.4,
			MaxComboCount = 4,
			DefaultDamage = 3.5,
			ResetTimer = 1.2,
			FinalComboHit = 4
		},


		PlayerTable = {
			Health = 150,
			Sprint = 1.5
		},

		PerformanceSettings = {
			RenderDistance = 250,
			Effects = 'Medium',
			ShowHitboxes = true,
			EnableParticles = true
		},

		Debug = {
			EnableLogging = false,
			ShowHitboxes = false,
			VerboseErrorReporting = false,
		},


		Audio = {
			MasterVolume = 1,
			MusicVolume = 1,
			SFXVolume = 1,
		},
		
		GeneralSettings = {
			AutoRun = false,
			AutoUse = false,
			CameraFollow  = false,
			CameraShake = false,
			DamageNumbers = false,
			ViewHitboxes = false,
		}

	}

	return self
end

	--Gets the current settings for Player
function SettingsTable:GetSettings():{Instance}?
	print('Settings received successfully!')
	return self.Settings
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
function SettingsTable:SetSettings(Category:string,SettingsName:string,Value):{Instance}?
	print("DEBUG: Category:", Category)
	print("DEBUG: SettingsName:", SettingsName)
	print("DEBUG: Value:", Value)
	print("DEBUG: Self.Settings[Category]:", self.Settings[Category])
	print("DEBUG: Self.Settings[Category][SettingsName]:", self.Settings[Category][SettingsName])
	
	
	if not Category then
		warn('Category missing')
		return
	end
	
	if not SettingsName then 
		warn('SettingsName missing') 
		return
	end
	
	if not Value and Value == nil then 
		warn('Value missing')
		warn(Value)
		return
	end
	
	if self.Settings[Category] == nil then
		warn('Invalid Category: ' .. tostring(Category))
		return
	end

	if self.Settings[Category][SettingsName] == nil then
		warn('Invalid Setting Name: ' .. tostring(SettingsName) .. ' for Category: ' .. tostring(Category))
		return
	end

	
	if self.Settings[Category]  then
		self.Settings[Category][SettingsName] = Value
		print('Settings set successfully!')
	else 
		warn('Invalid Category',Category,' Setting',SettingsName,' or Value!',Value)
		local Value = self.Settings[Category][SettingsName]
		
		print(Value)
		
	end

end	
	
--Saves Settings for Player
function SettingsTable:SaveSettings():{Instance}?
	local Retries = 3
	
	local success,result
	
	for index = 1,Retries do 
		success,result = pcall(function()
			return LoadingService:UpdateAsync(self.Player.UserId,function(OldData)
				return self.Settings
			end)
		end)

		if not success then 
			erroredPlayers[self.Player.UserId] = true
			warn(self.Player,'has failed to save their data! Error message: ', result)
			print('Attempt',index,'of 3!')
			
		else
			print('Settings saved successfully!')
			return
		end
		
	end
	
	erroredPlayers[self.Player.UserId] = true 
	warn(self.Player.Name .. ' has failed to save their data after ' .. Retries .. ' attempts.')

end

--Loads settings for Player, if not found then generates Default settings for said Player
function SettingsTable:LoadSettings():{Instance}?
	local success,result = pcall(function()
		return LoadingService:GetAsync(self.Player.UserId)
	end)
	
	if success then 
		if result then
			self.Settings = result 
			print('Settings loaded successfully!')
		else
			warn('No saved settings found, using defaults')
		end
	else 
		warn('Failed to load settings for ', self.Player, '. Error message: ', result)
	end

	return self.Settings
end



return SettingsTable