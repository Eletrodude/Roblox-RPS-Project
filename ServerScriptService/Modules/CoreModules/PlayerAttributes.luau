--!strict
local PlayerAttributes = {}

-- Default attributes for players
PlayerAttributes.Defaults = {
	-- Core Stats
	Health = 100,
	Defense = 10,
	Speed = 16,
	JumpHeight = 50,
	AttackPower = 15,
	AbilityPower = 10,
	CooldownReduction = 0, -- In percentage (0 = no reduction)
	ElementalResistance = 0, -- Future proofing
	ElementalAffinity = "None", -- Fire, Ice, Lightning, etc.

	-- Combat Mechanics
	ParryWindow = 0.5, -- Seconds to parry
	KnockbackResistance = 0.2, -- % reduction in knockback
	ComboStringing = true, -- Allows fluid attacks
	HyperArmor = false, -- Certain attacks ignore hitstun
	DodgeResponsiveness = 1, -- Multiplier for dodge speed
	CounterattackSpeed = 1.2, -- Multiplier for counterattacks
	HitboxScaling = 1, -- Default size

	-- Visual Effects
	UltimateCutscenes = true, -- Cinematic effect
	AttackCameraShake = true,
	SlowMoOnFinishers = true,
	HitEffects = true,
	AfterimageEffect = false,
	CameraLockOn = false,
	CinematicZoom = true,

	-- Extra Features
	FinishingMoves = true,
	RagdollPhysics = true,
	KillCamReplay = true,
	DynamicEnvironmentDestruction = false
}

-- Function to apply attributes to a player
function PlayerAttributes.ApplyAttributes(player)
	if not player then return end
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	-- Assign each attribute to the player
	for statName, statValue in pairs(PlayerAttributes.Defaults) do
		local attribute = Instance.new("NumberValue") -- Use StringValue for text-based values
		attribute.Name = statName

		if typeof(statValue) == "boolean" then
			attribute = Instance.new("BoolValue") -- Use BoolValue for true/false settings
		elseif typeof(statValue) == "string" then
			attribute = Instance.new("StringValue")
		end

		attribute.Value = statValue
		attribute.Parent = leaderstats
	end
end

return PlayerAttributes
