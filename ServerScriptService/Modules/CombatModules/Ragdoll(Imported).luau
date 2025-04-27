--!strict
local PhysicsService = game:GetService("PhysicsService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local module = {}

local function compare(x, ...)
	return table.find({...}, x) ~= nil
end

function module.Start(Rig : Model)
	if not module[Rig] then
		module[Rig] = {
			ID = HttpService:GenerateGUID(false),
			Properties = {},
			Collision = {},
			Instances = {}
		}

		local selected = module[Rig]
		local Humanoid = Rig:FindFirstChildWhichIsA("Humanoid")

		Rig.PrimaryPart:SetNetworkOwner(nil)
		Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		Rig:SetAttribute('IsRagdolled',true)

		PhysicsService:RegisterCollisionGroup(selected.ID)
		PhysicsService:CollisionGroupSetCollidable(selected.ID, selected.ID, false)

		for _, Descendant in Rig:GetDescendants() do
			if Descendant:IsA("Motor6D") and Descendant.Part0 and Descendant.Part1 then
				-- if not HRP
				if not compare(Rig.PrimaryPart, Descendant.Part0, Descendant.Part1) and
					-- if not Head
					not compare(Enum.Limb.Head, Humanoid:GetLimb(Descendant.Part0), Humanoid:GetLimb(Descendant.Part1)) then
					Descendant.Enabled = false

					local Attachment0 = Instance.new("Attachment")
					Attachment0.CFrame = Descendant.C0
					Attachment0.Parent = Descendant.Part0
					table.insert(selected.Instances, Attachment0)

					local Attachment1 = Instance.new("Attachment")
					Attachment1.CFrame = Descendant.C1
					Attachment1.Parent = Descendant.Part1
					table.insert(selected.Instances, Attachment1)

					local BallSocketConstraint = Instance.new("BallSocketConstraint")
					BallSocketConstraint.Attachment0 = Attachment0
					BallSocketConstraint.Attachment1 = Attachment1
					BallSocketConstraint.LimitsEnabled = true
					BallSocketConstraint.TwistLimitsEnabled = true
					BallSocketConstraint.Parent = Descendant.Parent
					table.insert(selected.Instances, BallSocketConstraint)
				end
			elseif Descendant:IsA("BasePart") then
				selected.Collision[Descendant] = {
					CollisionGroup = Descendant.CollisionGroup,
					CanCollide = Descendant.CanCollide
				}

				Descendant.CollisionGroup = selected.ID
				Descendant.CanCollide = true
			end
		end

		local Properties = {
			PlatformStand = true,
			AutoRotate = false,
			WalkSpeed = 0,
			JumpPower = 0,
			JumpHeight = 0
		}

		for name, value in Properties do
			selected.Properties[name] = Humanoid[name]
			Humanoid[name] = value
		end
		
	end
end

function module.Stop(Rig : Model)
	local selected =  module[Rig]

	if selected then
		local Humanoid = Rig:FindFirstChildWhichIsA("Humanoid")
		Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		Rig:SetAttribute('IsRagdolled',false)

		for name, value in selected.Properties do
			Humanoid[name] = value
		end

		for part, info in selected.Collision do
			part.CanCollide = info.CanCollide
			part.CollisionGroup = info.CollisionGroup
		end
		
		for _, instance in selected.Instances do
			instance:Destroy()
		end
		
		PhysicsService:UnregisterCollisionGroup(selected.ID)

		for _, Descendant in Rig:GetDescendants() do
			if Descendant:IsA("Motor6D") then
				Descendant.Enabled = true
			end
		end

		module[Rig] = nil
	end
	
	Rig.PrimaryPart:SetNetworkOwner(Players:GetPlayerFromCharacter(Rig))
end

return module