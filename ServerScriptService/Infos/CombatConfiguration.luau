--!strict
-- CombatConfig.lua
local CombatConfig = {
	M1 = {
		Cooldown = {
			Normal = 0.395,
			Final = 2.0
		},
		Damage = {
			Normal = 3.0,
			Final = 3.5
		},
		Hitbox = {
			Size = Vector3.new(5, 7, 8),
			Offset = CFrame.new(0, 0, -3),
			Duration = 0.3
		},
		Knockback = {
			Force = 30,
			Duration = 0.1,
			Forward = Vector3.new(0, 0, 1)
		}
	},
	DamageTypes = {
		SingleHit = 1,
		MultiHit = 2,
		Percentage = 3,
		PercentageMultiHit = 4,
		TrueDamage = 5
	},
	Ragdoll = {
		DefaultDuration = 1.5,
		IgnoreParts = {"HumanoidRootPart", "LowerTorso", "UpperTorso", "Torso"}
	},
	
	Block = {
	Attributes = {WalkSpeed = 4,JumpPower = 0,JumpHeight = 0},
	Cooldown = {0.2}
	},
	
	
	Dash = {
		ForwardDash = {
			Cooldown = 7,
			VelocityMultiplier = 65,
			Duration = 0.8
			
		},
		AlternativeDash	 = {
			Cooldown = 3,
			VelocityMultiplier = 75,
			Duration = 0.3
		}
		
	},
	
	
	
	
}

return CombatConfig