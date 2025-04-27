--!strict
local Players = game:GetService("Players")

type AttributeValue = boolean|number|string

local TimeManager = require(game:GetService('ServerScriptService').Infos.TimeManager)



-- Default attribute values
local DEFAULT_ATTRIBUTES :{[string]:AttributeValue} = {
	
	-- General Combat
	IsStunned = false,
	IsAttacking = false,
	IsBlocking = false,
	IsDashing = false,
	IsRagdolled = false,
	CanBeDamaged = true,
	ComboCooldown = false,
	GettingAttacked = false,

	-- Health & Damage
	Health = 100,
	MaxHealth = 100,
	DefenseMultiplier = 1.0,
	DamageMultiplier = 1.0,
	Lifesteal = 0,
	BaseWalkSpeed = 16,
	WalkSpeed = 16,
	JumpHeight = 7.3,
	BaseJumpHeight = 7.3,
	JumpPower = 50,
	BaseJumpPower = 50,
	
	
	-- Movement & Stamina
	SpeedMultiplier = 1.0,
	Stamina = 100,
	MaxStamina = 100,
	StaminaRegenRate = 5,

	-- Abilities & Power System
	CurrentAbility = "",
	CurrentAbility2 = "",
	AbilityCooldown = 0,
	IsAbilityActive = false,
	Energy = 100,
	MaxEnergy = 100,

	-- Miscellaneous & Utility
	InCombat = false,
	ComboCounter = 0,
	LastHitTime = 0,
	IsInvincible = false,
	InShiftLock = false,
	InLockOn = false,
	HoldingSpace = false,
	Combo = 0,
	MouseHolding = false,
	LoadedIn = false,
	
	
	--Audio
	MasterVolume = 1,
	EffectsVolume = 1,
	MusicVolume = 1
	
}

-- Function to initialize attributes for a character
local function initializeAttributes(character)
	for attributeName, defaultValue in pairs(DEFAULT_ATTRIBUTES) do
		if character:GetAttribute(attributeName) == nil then
			character:SetAttribute(attributeName, defaultValue)
		end
	end
	
end

local function ModifyAttributes(Character:Model)
	if not Character or not Character:IsA('Model') then 
		warn(Character, 'not found or invalid')
	end

	local Humanoid:Humanoid = Character:FindFirstChildWhichIsA('Humanoid')::Humanoid

	local TableOfAttributes = 
		{'WalkSpeed','JumpHeight','JumpPower','Health'}

	for i,AttributeName in ipairs(TableOfAttributes) do 
		Character:GetAttributeChangedSignal(AttributeName):Connect(function()
			print('changed')
			if AttributeName == 'WalkSpeed' then
				Humanoid.WalkSpeed = Character:GetAttribute(AttributeName)
			elseif AttributeName == 'JumpHeight' then
				Humanoid.JumpHeight = Character:GetAttribute(AttributeName)
			elseif AttributeName == 'JumpPower' then
				Humanoid.JumpPower = Character:GetAttribute(AttributeName)
			elseif AttributeName == 'Health' then
				Humanoid.Health = Character:GetAttribute(AttributeName)
			end
		end)
	end



end



-- Connect to PlayerAdded event
Players.PlayerAdded:Connect(function(Player:Player)
	Player.CharacterAdded:Connect(function(Character:Model)
		
		ModifyAttributes(Character)
		initializeAttributes(Character)
		
	end)
end)

-- Initialize attributes for players already in-game (if script runs mid-session)
for _, Player in ipairs(Players:GetPlayers()) do
	local Character = Player.Character
	
	if typeof(Character) == 'Instance' and Character:IsA('Model') then
		initializeAttributes(Character)
	end
	Player.CharacterAdded:Connect(function(Character:Model)
		initializeAttributes(Character)
	end)
end

for _,Rigs in workspace:GetDescendants() do 
	if Rigs.Name == 'Dummy'and Rigs:IsA('Model') then 
		for attributeName, defaultValue in pairs(DEFAULT_ATTRIBUTES) do
			if Rigs:GetAttribute(attributeName) == nil then
				Rigs:SetAttribute(attributeName, defaultValue)
			end
		end
	end
end

