--!strict
--[[ 
    Title: [RPS Handler]
    Description: [Handles the Rock Paper Scissors part]
    Author: [Eletrodude]
    Date: [13/03/2025]
--]]

-- SERVICES
-- (Game services like Players, DataStoreService, ReplicatedStorage, etc.)
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')
local PlayerService = game:GetService('Players')
-- VARIABLES
-- (Local variables that store data or references)
local Player = PlayerService.LocalPlayer
local Player2
local Character2
local Humanoid2
local HumanoidDescription2

local Connection 

-- CONSTANTS
-- (Values that do not change throughout the script)
local RPSChooserEvent = ReplicatedStorage.Remotes.Auxilliary.RPSChooser
local Tweeninfo = TweenInfo.new(0.1,Enum.EasingStyle.Linear)

local RPSGui = script.Parent
local WaitingFrame = RPSGui.Waiting
local CutsceneFrame = RPSGui.Cutscene
local Frame = RPSGui.Frame
local RockShadow = Frame.Rock.RockShadow
local Paper  = Frame.Paper
local Scissors = Frame.Scissors
local FireCutscene = ReplicatedStorage.Remotes.Auxilliary.FireCutscene

-- MODULES
-- (Require any external modules or scripts)
local AnimationPlayer = require(ReplicatedStorage.Modules["AnimationPlayer(New)"])

-- FUNCTIONS
-- (Define reusable functions here)

-- Add this before playing animations
local function ensureAnimationSetup(model)
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		humanoid = Instance.new("Humanoid")
		humanoid.Parent = model
	end

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	return humanoid, animator
end

-- Then in your animation code:

local function PlayAnimation(Table1, Table2, Winner, Model1, Model2)
	-- Debug information
	print("PlayAnimation called with:")
	print("Model1:", Model1 and Model1.Name or "nil")
	print("Model2:", Model2 and Model2.Name or "nil")
	print("Table1 player:", Table1 and Table1[1] and Table1[1].Name or "nil")
	print("Table2 player:", Table2 and Table2[1] and Table2[1].Name or "nil")

	-- Safety check for nil values
	if not Table1 or not Table2 or not Table1[1] or not Table2[1] or not Model1 or not Model2 then
		warn("Missing parameters in PlayAnimation")
		return
	end

	local Player1, Player2 = Table1[1], Table2[1]
	local AnimationFolder = ReplicatedStorage.GlobalAnimations

	-- More safety checks
	if not Player1 or not Player2 or not Player1.Name or not Player2.Name then
		warn("Player references are nil or invalid")
		return
	end

	if not Model1.Name or not Model2.Name then
		warn("Model references are nil or invalid")
		return
	end

	-- Player 1 animation
	if Player1.Name == Model1.Name then 
		local animation

		if Table1[2].Choice == 'Rock' then
			animation = AnimationFolder.Rock
		elseif Table1[2].Choice == 'Paper' then 
			animation = AnimationFolder.Paper
		elseif Table1[2].Choice == 'Scissors' then
			animation = AnimationFolder.Scissors
		end

		if animation then
			local AnimationID = animation.AnimationId
			local AnimPlayer = AnimationPlayer.new(nil, AnimationID, {}, nil, 1.2, FireCutscene, Model1)
			AnimPlayer:PlayAnimation()
		else
			warn("No animation found for Player1's choice")
		end
	elseif Player1.Name == Model2.Name then
		local animation

		if Table1[2].Choice == 'Rock' then
			animation = AnimationFolder.Rock
		elseif Table1[2].Choice == 'Paper' then 
			animation = AnimationFolder.Paper
		elseif Table1[2].Choice == 'Scissors' then
			animation = AnimationFolder.Scissors
		end

		if animation then
			local AnimationID = animation.AnimationId
			local AnimPlayer = AnimationPlayer.new(nil, AnimationID, {}, nil, 1.2, FireCutscene, Model2)
			AnimPlayer:PlayAnimation(Winner)
		else
			warn("No animation found for Player1's choice")
		end
	end

	-- Player 2 animation (fixed to use Table2)
	if Player2.Name == Model1.Name then 
		local animation

		if Table2[2].Choice == 'Rock' then -- Fixed: Table2 instead of Table1
			animation = AnimationFolder.Rock
		elseif Table2[2].Choice == 'Paper' then 
			animation = AnimationFolder.Paper
		elseif Table2[2].Choice == 'Scissors' then
			animation = AnimationFolder.Scissors
		end

		if animation then
			local AnimationID = animation.AnimationId
			local AnimPlayer = AnimationPlayer.new(nil, AnimationID, {}, nil, 1.2, FireCutscene, Model1)
			AnimPlayer:PlayAnimation(Winner)
		else
			warn("No animation found for Player2's choice")
		end
	elseif Player2.Name == Model2.Name then
		local animation

		if Table2[2].Choice == 'Rock' then -- Fixed: Table2 instead of Table1
			animation = AnimationFolder.Rock
		elseif Table2[2].Choice == 'Paper' then 
			animation = AnimationFolder.Paper
		elseif Table2[2].Choice == 'Scissors' then
			animation = AnimationFolder.Scissors
		end

		if animation then
			local AnimationID = animation.AnimationId
			local AnimPlayer = AnimationPlayer.new(nil, AnimationID, {}, nil, 1.2, FireCutscene, Model2)
			AnimPlayer:PlayAnimation(Winner)
		else
			warn("No animation found for Player2's choice")
		end
	end
end

local AnimationPlay = function(Model:Model,Animation:Animation)
	if not Model then 
		error('Model not Found')
	end

	if not Animation then
		error('Animation not Found')
	end

	local Humanoid = Model:FindFirstChildWhichIsA('Humanoid')

	if not Humanoid then 
		Humanoid = Instance.new('Humanoid')
		Humanoid.Parent = Model
	end

	local Animator = Humanoid:FindFirstChildWhichIsA('Animator')

	if not Animator then 
		Animator = Instance.new('Animator')
		Animator.Parent = Humanoid
	end

	local track = Animator:LoadAnimation(Animation)
	track:Play()
end

-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)

-- HANDLERS
-- (Event listeners and connections)
RPSChooserEvent.OnClientEvent:Connect(function(Round,Table1,Table2,Winner)

	-- Update Player2 reference only if it's nil
	if not Player2 then
		for i,v in pairs(PlayerService:GetPlayers()) do 
			if v ~= Player then
				Player2 = v
				print("Player2 set to:", Player2.Name)
			end
		end
	end

	local thread 

	if Round == 'First Round' then
		RPSGui.Enabled = true
		RPSGui.Frame.Visible = true
		RPSGui.Cutscene.Visible = false

	elseif Round == 'Second Round' then
		RPSGui.Enabled = true
		RPSGui.Frame.Visible = true
		RPSGui.Cutscene.Visible = false

	elseif Round == 'Third Round' then
		RPSGui.Enabled = true
		RPSGui.Frame.Visible = true
		RPSGui.Cutscene.Visible = false

	elseif Round == 'Wait' then
		RPSGui.Waiting.Visible = true
		RPSGui.Frame.Visible = false
		RPSGui.Cutscene.Visible = false

		thread = task.spawn(function()
			local loadingText = "Loading"
			local maxDots = 3
			local waitTime = 0.5  -- Slightly faster animation

			while true do
				for dotCount = 0, maxDots do
					local dots = string.rep(".", dotCount)
					WaitingFrame.TextLabel.Text = loadingText .. dots
					task.wait(waitTime)
				end
			end
		end)

	elseif Round == 'Remove' then
		RPSGui.Enabled = false
		RPSGui.Waiting.Visible = false
		RPSGui.Frame.Visible = true
		RPSGui.Cutscene.Visible = false

		if thread then 
			task.cancel(thread)
		end

	elseif Round == 'PlayAnimation' then
		RPSGui.Enabled = true
		RPSGui.Waiting.Visible = false
		RPSGui.Frame.Visible = false
		RPSGui.Cutscene.Visible = true

		print('Animation sequence started')

		if thread then 
			task.cancel(thread)
		end

		-- Clear previous models if they exist
		if CutsceneFrame.WorldModel:FindFirstChildWhichIsA("Model") then
			CutsceneFrame.WorldModel:ClearAllChildren()
		end

		local ModelNumber = 0
		local Model1, Model2

		-- Create new models for this round
		for index, value in pairs(ReplicatedStorage.Models:GetChildren()) do 
			if value:IsA('Model') then
				ModelNumber += 1
				if ModelNumber == 1 then 
					Model1 = value:Clone() -- Clone to avoid reference issues
					Model1.Parent = CutsceneFrame.WorldModel
					local humanoid, animator = ensureAnimationSetup(Model1)
					print("Model1 created:", Model1.Name)
				elseif ModelNumber == 2 then
					Model2 = value:Clone() -- Clone to avoid reference issues
					Model2.Parent = CutsceneFrame.WorldModel
					local humanoid, animator = ensureAnimationSetup(Model2)
					print("Model2 created:", Model2.Name)
				end
			end
		end

		-- Safety check for models
		if not Model1 or not Model2 then
			warn("Failed to create models for animation")
			return
		end

		local Camera = Instance.new('Camera')
		Camera.Parent = CutsceneFrame
		CutsceneFrame.CurrentCamera = Camera

		RPSGui.Cutscene.Visible = true

		-- Validate Table1 and Table2 data
		if Table1 and Table2 and Table1[1] and Table2[1] and 
			Table1[2] and Table2[2] and
			Table1[2].Choice and Table2[2].Choice then
			PlayAnimation(Table1, Table2, Winner, Model1, Model2)
		else
			warn("Invalid data for PlayAnimation:", Table1, Table2)
		end

		task.delay(2, function()
			FireCutscene:FireServer()
			task.wait(2)
			-- Use pcall to handle potential errors during cleanup
			pcall(function()
				if Model1 and Model1.Parent then Model1:Destroy() end
				if Model2 and Model2.Parent then Model2:Destroy() end
				if Camera and Camera.Parent then Camera:Destroy() end
			end)
		end)

		Camera.CFrame = CFrame.new(600, 1792, -507)
		Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, RPSGui.Cutscene.RockPaperScissorsArena.Position)
		Camera.CFrame = Camera.CFrame + (-Camera.CFrame.RightVector * 0.5)
	end
end)

RockShadow.MouseEnter:Connect(function()
	local Tween = TweenService:Create(RockShadow, Tweeninfo, {BackgroundTransparency = 0.8})
	Tween:Play()
end)

RockShadow.MouseLeave:Connect(function()
	local Tween = TweenService:Create(RockShadow, Tweeninfo, {BackgroundTransparency = 1})
	Tween:Play()
end)

RockShadow.MouseButton1Click:Connect(function()
	RPSChooserEvent:FireServer('Rock')
end)

Paper.MouseButton1Click:Connect(function()
	RPSChooserEvent:FireServer('Paper')
end)

Scissors.MouseButton1Click:Connect(function()
	RPSChooserEvent:FireServer('Scissors')
end)

-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)