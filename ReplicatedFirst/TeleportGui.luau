--!strict
local TeleportService = game:GetService('TeleportService')
local RepFirst = game:GetService('ReplicatedFirst')
local TeleportGui = TeleportService:GetArrivingTeleportGui()
local ContentProvider = game:GetService('ContentProvider')
--local LoadingGui = game:GetService('StarterGui'):WaitForChild('LoadingGui')
local LoadGame = game:GetService('ReplicatedStorage'):WaitForChild('BindableFunctions'):WaitForChild('LoadGame')
local StartGame  = game:GetService('ReplicatedStorage'):WaitForChild('Remotes'):WaitForChild('Auxilliary'):WaitForChild('StartGame')
local LoadingLoop:any
local CheckRunStudio:any
local AssetsToLoad = {}
local DisableRespawnEvent = game:GetService('ReplicatedStorage'):WaitForChild('Remotes'):WaitForChild('Auxilliary'):WaitForChild('DisableRespawn')

local StartRound = false

---// Roblox Services
local StarterGUI = game:GetService("StarterGui")


local function DisableRespawn()
	repeat -- Starts the repeat loop
		local success = pcall(function() 
			StarterGUI:SetCore("ResetButtonCallback", false) 
		end)
		task.wait(1) -- Cooldown to avoid freezing
	until success -- Runs the loop until the Reset Button is disabled.
	--print("SUCCESS | Reset button core GUI disabled!") -- Debuggin

end


if TeleportGui then
	local Frame:Frame = TeleportGui:WaitForChild('Frame',5) ::Frame
	local ViewportFrame:ViewportFrame = Frame:WaitForChild('ViewportFrame',5) ::ViewportFrame
	local TextLabel:TextLabel = ViewportFrame:WaitForChild('TextLabel',5) ::TextLabel
	
	local PlayerGui = game:GetService('Players'):WaitForChild('LocalPlayer'):WaitForChild('PlayerGui',10)
	RepFirst:RemoveDefaultLoadingScreen()
	TeleportGui.Parent = PlayerGui
	
	ViewportFrame.ZIndex = 100
	ViewportFrame.Visible = true
	ViewportFrame.BackgroundTransparency = 0
	TextLabel.BackgroundTransparency = 0
	TextLabel.Visible = true
	
	LoadingLoop = task.spawn(function()
		local loadingText = "Loading"
		local maxDots = 3
		local waitTime = 0.5  -- Slightly faster animation

		while true do
			for dotCount = 0, maxDots do
				local dots = string.rep(".", dotCount)
				TextLabel.Text = loadingText .. dots
				task.wait(waitTime)
			end
		end
	end)
	
	local Boolean = LoadGame:Invoke()

	
	if Boolean  then
		
		local TweenService = game:GetService('TweenService')
		local tInfo = TweenInfo.new(0.5,Enum.EasingStyle.Linear)
		local Tween = TweenService:Create(ViewportFrame,tInfo,{BackgroundTransparency = 1})
		local Tween2 = TweenService:Create(TextLabel,tInfo,{BackgroundTransparency = 1})	local Tween = TweenService:Create(ViewportFrame,tInfo,{BackgroundTransparency = 1})
		local Tween3 = TweenService:Create(TextLabel,tInfo,{TextTransparency = 1})

		Tween:Play()
		Tween2:Play()
		Tween3:Play()

		Tween.Completed:Connect(function()
			TeleportGui:Destroy()	
			StartGame:FireServer()
			task.cancel(LoadingLoop)
		end)

		task.delay(25,function()
			if TeleportGui then
				TeleportGui:Destroy()
				StartGame:FireServer()
			end

			if LoadingLoop and coroutine.status(LoadingLoop) == 'suspended' then
				task.cancel(LoadingLoop) 
			end
		end)
		
		
	end
	

	
end



DisableRespawn()

DisableRespawnEvent.OnClientEvent:Connect(DisableRespawn)


CheckRunStudio = task.spawn(function()
	task.wait(3)
	if game["Run Service"]:IsStudio() == true then
		StartGame:FireServer('Studio')
	else 
		task.cancel(LoadingLoop)
	end	
end)
