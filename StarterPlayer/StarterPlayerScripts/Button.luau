--!strict
--[[
Title: [TopBarPlus]
Description: [Loads TopBarPlus for the client with respawn handling]
--]]
-- SERVICES
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local TweenService = game:GetService('TweenService')
local TweenInformation = TweenInfo.new(0.1,Enum.EasingStyle.Linear)
local Players = game:GetService('Players')



-- MODULES
local Data = ReplicatedStorage:WaitForChild('TopbarPlus'):WaitForChild('Icon')
local TopBarPlus = require(Data)

-- VARIABLES
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild('PlayerGui')
local SettingsGui = PlayerGui:WaitForChild('SettingsGui')
local Frame = SettingsGui.SettingsFrame::ScrollingFrame
local OriginalPosition = Frame.Position

local Icon =  TopBarPlus.new()
Icon:setImage('rbxassetid://96957318452720')
Icon:setLabel('Settings','Viewing')
Icon:setCaption('Open Settings')
Icon:bindToggleItem(Frame)
Icon:bindToggleKey(Enum.KeyCode.M)
Icon:setEnabled(true)
Icon:align('Left')



Icon.selected:Connect(function(fromSource)
	Frame.Position -= UDim2.new(0,0,0.2,0)
	TweenService:Create(Frame,TweenInformation,{Position = Frame.Position + UDim2.new(0,0,0.2,0)}):Play()
	
end)	

Icon.deselected:Connect(function(fromsource)
	TweenService:Create(Frame,TweenInformation,{Position = OriginalPosition}):Play()

end)

local frame = Instance.new('ScrollingFrame')

-- Connect to character respawn
Player.CharacterAdded:Connect(function()
	-- Wait for player to load in completely
	PlayerGui = Player:WaitForChild('PlayerGui')
	Frame = PlayerGui:WaitForChild('SettingsGui'):WaitForChild('SettingsFrame')::ScrollingFrame
	Icon:bindToggleItem(Frame)
	
	
	
	
end)