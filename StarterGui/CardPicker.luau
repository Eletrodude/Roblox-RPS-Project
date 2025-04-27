--!strict
--[[
Title: [Client Picker Event]
Description: [Lets the client pick the cards]
Author: [Eletrodude]
Date: [16/03/2025]
--]]
-- SERVICES
-- (Game services like Players, DataStoreService, ReplicatedStorage, etc.)
local PlayerService = game:GetService('Players')
local TweeenService = game:GetService('TweenService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

-- MODULES
-- (Require any external modules or scripts)
local Maid = require(ReplicatedStorage:WaitForChild('Modules'):WaitForChild('CoreModule(Client)'):WaitForChild('Maid'))
-- VARIABLES
-- (Local variables that store data or references)
local ClientPickerEvent = ReplicatedStorage:WaitForChild('Remotes'):WaitForChild('Auxilliary'):WaitForChild('PickAbilities')
local ScreenGui = script.Parent
local ViewportFrame = ScreenGui.ViewportFrame
local Initiation = false



local CardImageIDs = {
	Common = "rbxassetid://106921988215901",
	Rare = "rbxassetid://86030085287494",
	Legendary = 'rbxassetid://74112205025560',
	Mythical = "rbxassetid://85489540974413"
}
local Cards = {
	ViewportFrame.Card1,
	ViewportFrame.Card2,
	ViewportFrame.Card3,
	ViewportFrame.Card4
}
local ShadowCards = {
	Cards[1].Card1Shadow,
	Cards[2].Card2Shadow,
	Cards[3].Card3Shadow,
	Cards[4].Card4Shadow
}
local TextColor = {
	['Common'] = ShadowCards[1].TextColor3,
	['Rare'] = ShadowCards[2].TextColor3,
	['Legendary'] = ShadowCards[3].TextColor3,
	['Mythical'] = ShadowCards[4].TextColor3
}

-- CONSTANTS
-- (Values that do not change throughout the script)

-- FUNCTIONS
-- (Define reusable functions here)

local function SetImageIDS(TableofRarities)
	

	
	for index = 1,4 do
		if TableofRarities[index] then 
			local Rarity = TableofRarities[index][1]
			Cards[index].Image = CardImageIDs[Rarity]
			Cards[index].Visible = true 
			ShadowCards[index].Text = Rarity
			ShadowCards[index].TextColor3 = TextColor[Rarity]
			ShadowCards[index].UIStroke.Enabled = false
			ShadowCards[index].TextTransparency = 1
			ShadowCards[index].Visible = true
		else
			Cards[index].Visible = false
			ShadowCards[index].Visible = false
		end
	
		
	end
	

	
	print(TableofRarities)

	ScreenGui.Enabled = true
	ViewportFrame.Visible = true
	script.Parent.Parent["RPS-Screen"].Cutscene.Visible = false
	script.Parent.Parent["RPS-Screen"].Enabled = false
	script.Parent.Parent["RPS-Screen"].Waiting.Visible = false
	
	
end

local function RemoveCard(Card:number)
	if Cards[Card] then
	ShadowCards[Card].Visible = false
	Cards[Card].Visible = false
	
	end
end


-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)
-- HANDLERS
-- (Event listeners and connections)
ClientPickerEvent.OnClientEvent:Connect(function(CardsToPick,Str,CardNum)
	if Str == 'Initiate' or Str == 'Turn' then

		SetImageIDS(CardsToPick)
	
	elseif Str == 'WaitingForTurn' then 
		ScreenGui.Enabled = false
		
		
	elseif Str == 'Remove' then 
		RemoveCard(CardNum)
		
		
	elseif Str == 'Close' then
		
		
		
		print('False')
		ScreenGui.Enabled = false
		ViewportFrame.Visible = false
		for i = 1,4 do 
			Cards[i].Visible = true
			ShadowCards[i].Visible = true
		end
	

		repeat -- Starts the repeat loop
			local success = pcall(function() 
				game:GetService('StarterGui'):SetCore("ResetButtonCallback", true) 
			end)
			task.wait(1) -- Cooldown to avoid freezing
		until success -- Runs the loop until the Reset Button is disabled.

		print("SUCCESS | Reset button core GUI enabled!") -- Debuggin

	



	end
	
end)



for i = 1, 4 do
	-- Mouse enter
	ShadowCards[i].MouseEnter:Connect(function()
		ShadowCards[i].BackgroundTransparency = 0.8
		ShadowCards[i].TextTransparency = 0
		ShadowCards[i].UIStroke.Enabled = true
	end)

	-- Mouse leave
	ShadowCards[i].MouseLeave:Connect(function()
		ShadowCards[i].BackgroundTransparency = 1
		ShadowCards[i].TextTransparency = 1
		ShadowCards[i].UIStroke.Enabled = false
	end)

	-- Mouse click
	ShadowCards[i].MouseButton1Click:Connect(function()
		ClientPickerEvent:FireServer(i)
		ScreenGui.Enabled = false
	end)
end









--ShadowCards[1].MouseButton1Click:Connect(function()
--	ClientPickerEvent:FireServer(1)
--	ScreenGui.Enabled = false
	
--end)
--ShadowCards[2].MouseButton1Click:Connect(function()
--	ClientPickerEvent:FireServer(2)
--	ScreenGui.Enabled = false

--end)
--ShadowCards[3].MouseButton1Click:Connect(function()
--	ClientPickerEvent:FireServer(3)
--	ScreenGui.Enabled = false

--end)
--ShadowCards[4].MouseButton1Click:Connect(function()
--	ClientPickerEvent:FireServer(4)
--	ScreenGui.Enabled = false

--end)



-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)

