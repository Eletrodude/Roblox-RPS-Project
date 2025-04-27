--!strict
local Ragdoll = {}
local RunService = game:GetService("RunService")
local RagdollEvent = game.ReplicatedStorage.Remotes.Auxilliary.Ragdoll

-- Initialize attributes if they don't exist
local function EnsureAttributes(Character)
	if Character:GetAttribute("IsRagdolled") == nil then
		Character:SetAttribute("IsRagdolled", false)
	end
end

function Ragdoll.Ragdolling(Character)
	if not Character then
		warn("Character is nil in Ragdolling")
		return
	end

	EnsureAttributes(Character)

	if Character:GetAttribute("IsRagdolled") == true then 
		return 
	end

	Character:SetAttribute("IsRagdolled", true)

	local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
	if not Humanoid then
		warn("No Humanoid found in Character during Ragdolling")
		return
	end

	Humanoid.RequiresNeck = false
	Humanoid.PlatformStand = true
	Humanoid.AutoRotate = false

	local IgnoreParts = {"HumanoidRootPart", "LowerTorso", "UpperTorso", "Torso"}

	-- Stop all animations
	task.spawn(function()
		local Animator = Humanoid:FindFirstChildWhichIsA("Animator")
		if Animator then
			for _, Track in pairs(Animator:GetPlayingAnimationTracks()) do
				Track:Stop()
			end
		end

		for _, Track in pairs(Humanoid:GetPlayingAnimationTracks()) do
			Track:Stop()
		end
	end)

	-- Apply ragdoll physics
	for _, Part in pairs(Character:GetDescendants()) do
		if Part:IsA("Motor6D") then
			-- Create constraints for joints
			local Socket = Instance.new("BallSocketConstraint", Part.Parent)
			local Attachment0 = Instance.new("Attachment")
			local Attachment1 = Instance.new("Attachment")

			Attachment0.CFrame = Part.C0
			Attachment1.CFrame = Part.C1

			Socket.Attachment0 = Attachment0
			Socket.Attachment1 = Attachment1
			Socket.TwistLimitsEnabled = true
			Socket.LimitsEnabled = true

			Part.Enabled = false

			Attachment0.Parent = Part.Part0
			Attachment1.Parent = Part.Part1

		elseif Part:IsA("BasePart") and not table.find(IgnoreParts, Part.Name) then
			-- Create collision parts for ragdoll physics
			local CollisionPart = Instance.new("Part")
			local Weld = Instance.new("WeldConstraint")

			Weld.Part0 = CollisionPart
			Weld.Part1 = Part
			CollisionPart.Name = "RagdollPart"
			CollisionPart.CFrame = Part.CFrame
			CollisionPart.Size = Part.Size * 0.8
			CollisionPart.Transparency = 1
			Weld.Parent = CollisionPart
			CollisionPart.CollisionGroup = "RagdollParts"
			CollisionPart.CanQuery = false
			CollisionPart.CanTouch = false
			CollisionPart.Massless = true
			CollisionPart.Parent = Character
		end
	end

	-- Apply physics state
	local Player = game.Players:GetPlayerFromCharacter(Character)
	if Player then
		RagdollEvent:FireClient(Player, Enum.HumanoidStateType.Physics)
	else
		Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	end
end

function Ragdoll.UnRagdoll(Character)
	if not Character then
		warn("Character is nil in UnRagdoll")
		return
	end

	EnsureAttributes(Character)

	if Character:GetAttribute("IsRagdolled") == false then 
		return 
	end

	local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
	if not Humanoid then
		warn("No Humanoid found in Character during UnRagdoll")
		return
	end

	if Humanoid.Health == 0 then 
		return
	end

	Character:SetAttribute("IsRagdolled", false)
	Humanoid.RequiresNeck = true
	Humanoid.PlatformStand = false
	Humanoid.AutoRotate = true

	-- Clean up ragdoll parts and restore joints
	for _, Part in pairs(Character:GetDescendants()) do
		if Part:IsA("Motor6D") then
			Part.Enabled = true
		elseif Part:IsA("BallSocketConstraint") then
			Part:Destroy()
		elseif Part.Name == "RagdollPart" then
			Part:Destroy()
		end
	end

	-- Return to normal state
	local Player = game.Players:GetPlayerFromCharacter(Character)
	if Player then
		RagdollEvent:FireClient(Player, Enum.HumanoidStateType.GettingUp)
	else
		Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end

	Humanoid.Jump = true
end

function Ragdoll.RagdollPlayer(Character, Duration)
	if not Character then
		warn("Character is nil in RagdollPlayer")
		return
	end

	Duration = Duration or 1
	
	
	

	Ragdoll.Ragdolling(Character)

	task.delay(Duration, function()
		if Character and Character.Parent then
			Ragdoll.UnRagdoll(Character)
		end
	end)
end

return Ragdoll