--!strict
--[[
Title: [Your Script Title]
Description: [Short description of what this script does]
Author: [Eletrodude]
Date: [10/03/2025]
--]]

-- SERVICES
-- (Game services like Players, DataStoreService, ReplicatedStorage, etc.)
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ContentProider = game:GetService('ContentProvider')
local TweenService = game:GetService('TweenService')
local StarterGui = game:GetService('StarterGui')

-- VARIABLES
-- (Local variables that store data or references)

local LoadGame = ReplicatedStorage:WaitForChild('BindableFunctions'):WaitForChild('LoadGame')
local LoadingGui = StarterGui.LoadingGui
local TextLabel = LoadingGui.Frame.TextLabel
local LoadingText = TextLabel.Text
-- CONSTANTS
-- (Values that do not change throughout the script)
local TweenInformation = TweenInfo.new(0.5,Enum.EasingStyle.Linear)
local Properties = {BackgroundTransparency = 1,TextTransparency = 1}


-- MODULES
-- (Require any external modules or scripts)

-- FUNCTIONS
-- (Define reusable functions here)



local i = 0 
local function UpdateProgress(loadedAssets,TotalAssets)
	local AssetTable = math.floor((loadedAssets/TotalAssets))
	LoadingText = 'Assets Loaded:'..loadedAssets.."/"..TotalAssets
	
end



local function LoadTheGame()
	local AssetTable = {}
	LoadingGui.Enabled = true
	LoadingGui.Frame.Visible = true
	LoadingGui.Frame.TextLabel.Visible = true
	
	print('OnLoad')
	
	for _,value in pairs(ReplicatedStorage:GetDescendants()) do 
		table.insert(AssetTable,value)
	end
	
	local TotalAssets = #AssetTable
	local LoadedAssets = 0
	
	
	UpdateProgress(LoadedAssets,TotalAssets)
	
	local assetsLoaded = 0 
	
	
	ContentProider:PreloadAsync(AssetTable,function(assetId,status)
		if status == Enum.AssetFetchStatus.Success then
			assetsLoaded +=1
			
			UpdateProgress(assetsLoaded,TotalAssets)
		end
	end)
	
	local StartTime = os.clock()
	local Timeout  = 25
	
	while assetsLoaded < TotalAssets and (tick() - StartTime) < Timeout do 
		task.wait(0.1)
	end
	UpdateProgress(assetsLoaded,assetsLoaded)
	
	if assetsLoaded >= TotalAssets then 
		print('Starting the game!')
		LoadingText = 'Assets fully loaded!'
		
		local Tween = TweenService:Create(LoadingGui.Frame.TextLabel,TweenInformation,Properties)
		Tween:Play()
		return true
	else
		print('Assets not fully loaded for player: '..game.Players.LocalPlayer)
		LoadingText = 'Assets not fully loaded, starting game with current loaded assets'
		local Tween = TweenService:Create(LoadingGui.Frame.TextLabel,TweenInfo,Properties)
		Tween:Play()
		return false
	end
	
	
	
end

-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)

-- HANDLERS
-- (Event listeners and connections)
LoadGame.OnInvoke = LoadTheGame

-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)


