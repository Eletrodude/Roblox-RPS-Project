--!strict

--[[ 
    Title: [Map Chooser]
    Description: [When enough player join, players can decide what map size they wish to pick, and the
    game randomly picks a map for them.]
    Author: [Eletrodude]
    Date: [13/03/2025]	
--]]

-- SERVICES
-- (Game services like Players, DataStoreService, ReplicatedStorage, etc.)
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Teams = game:GetService('Teams')
local StarterPlayer = game:GetService('StarterPlayer')
local ServerScriptService = game:GetService('ServerScriptService')

-- VARIABLES
-- (Local variables that store data or references)
local MapsFolder = ReplicatedStorage:FindFirstChild('Maps')
local RemotesFolder = ReplicatedStorage:FindFirstChild('Remotes')
local BindableEvents = ReplicatedStorage:FindFirstChild('BindableEvents')
local MapSizeEvent = assert(RemotesFolder.Auxilliary.MapSizeEvent,'Not found') ::RemoteEvent
local TeleportBackEvent  = assert(RemotesFolder.Auxilliary.TeleportBack,'Not found') ::RemoteEvent
local StartGame = assert(RemotesFolder.Auxilliary.StartGame,'Not found') ::RemoteEvent
local DisableRespawnEvent = assert(RemotesFolder.Auxilliary.DisableRespawn) ::RemoteEvent
local TopBarPlusEvent = assert(RemotesFolder.Auxilliary.TopbarPlus,'Not found') ::RemoteEvent

local RPSEvents = BindableEvents.RPSEvent

local TotalPlayers:number = 2
local CurrentPlayers:number = 0
local LoadingTimer:number = 25
local StartLosingLives:boolean = false
local PlayerTable:{Player} = {}
local ChooseMapBool:boolean = true
local MapSelectionVAR:boolean = false
local ChangeRound:boolean = false
local Connection:RBXScriptConnection 
local Choices:{[Player]:string  } = {}
local MaidTable:{[Player]:any  } = {}
--CONSTANTS
-- (Values that do not change throughout the script)
local Map:Instance
local PlaceID = 135610424267411	

-- MODULES
-- (Require any external modules or scripts)
local SafeTeleport = require(game.ServerScriptService.Modules.CoreModules.SafeTeleport)
local Maid = require(game:GetService('ServerScriptService'):FindFirstChild('Modules'):FindFirstChild('CoreModules')
	:FindFirstChild('Maid')
)
local CreateMap = require(game:GetService('ServerScriptService').Modules.SetUpModules.MapManager)
local PlayerModule:any = require(game:GetService('ServerScriptService').Modules.CoreModules.PlayerTable)
local CooldownModule  = require(game:GetService('ServerScriptService').Modules.CombatModules.Jump)
local TimeManager = require(ServerScriptService.Infos.TimeManager)
-- FUNCTIONS
-- (Define reusable functions here)

local function GetHumDesc(Player) :HumanoidDescription
	if Player:IsA('Player') then
		-- Check if UserId is valid (greater than 0)
		if Player.UserId and Player.UserId > 0 then
			local success, fullHumDesc = pcall(function()
				return game:GetService('Players'):GetHumanoidDescriptionFromUserId(Player.UserId)
			end)

			if success then
				-- Create a new HumanoidDescription with only accessories and clothing
				local clothingDesc:HumanoidDescription = Instance.new("HumanoidDescription")

				-- Copy accessory properties
				clothingDesc.HatAccessory = fullHumDesc.HatAccessory
				clothingDesc.HairAccessory = fullHumDesc.HairAccessory
				clothingDesc.FaceAccessory = fullHumDesc.FaceAccessory
				clothingDesc.NeckAccessory = fullHumDesc.NeckAccessory
				clothingDesc.ShouldersAccessory = fullHumDesc.ShouldersAccessory
				clothingDesc.FrontAccessory = fullHumDesc.FrontAccessory
				clothingDesc.BackAccessory = fullHumDesc.BackAccessory
				clothingDesc.WaistAccessory = fullHumDesc.WaistAccessory

				-- Copy clothing properties
				clothingDesc.Shirt = fullHumDesc.Shirt
				clothingDesc.Pants = fullHumDesc.Pants
				--clothingDesc.ShirtGraphic = fullHumDesc.ShirtGraphic

				-- Copy other appearance properties if needed
				clothingDesc.GraphicTShirt = fullHumDesc.GraphicTShirt
				-- Return the description with only clothing and accessories
				return clothingDesc
			end
		end

		-- Fallback for invalid UserIds or errors
		return game:GetService('Players'):GetHumanoidDescriptionFromUserId(126659087)
	end
	
	return Instance.new('HumanoidDescription')
end


local function SetUpLives(Player:Player)
	local leaderstats:Folder = Instance.new('Folder')::Folder
	leaderstats.Name = 'leaderstats'
	leaderstats.Parent = Player
	local Lives:IntValue = Instance.new('IntValue')
	Lives.Name = 'Lives'
	Lives.Value = 3
	Lives.Parent = leaderstats
	
	local Character = Player.CharacterAdded:Wait()
	local Humanoid:Humanoid = Character:FindFirstChildWhichIsA('Humanoid')::Humanoid
	
	local HumDesc = GetHumDesc(Player)
	
	Humanoid:ApplyDescription(HumDesc)
	
end

local function ChooseMap()
	if MapSelectionVAR == true then return end 
	if ChooseMapBool == false then return end
	MapSizeEvent:FireAllClients('EnableGui')
end

local function RespawnCharacter(Character,Map)
	local respawnTable = {}

	for _,Parts in pairs(Map:GetDescendants()) do 
		local Part = Parts::Instance
		if Part:IsA('SpawnLocation') then
			table.insert(respawnTable,Parts)
		end
	end

	local Location = math.random(1,#respawnTable)
	local player = game.Players:GetPlayerFromCharacter(Character)
	if player then
		player.RespawnLocation = respawnTable[Location]
		player:LoadCharacter()
	else
		warn("Could not find player from character")
	end
end

local function SetUpMap(MapSize:string)
	local Number 

	Map = CreateMap(MapSize)

	for i,v in pairs(game:GetService('Players'):GetChildren()) do
		if v:IsA('Player') then
			task.wait(3)
			StartLosingLives = true
		end
	end
	return Map
end






-- MAIN SCRIPT LOGIC
-- (Core script execution and function calls)
game.Players.PlayerAdded:Connect(function(Player:Player)
	local PlayerMaid:any = Maid.new()
	
	

	SetUpLives(Player)
	
	
	
	

	--StarterCharacter:WaitForChild('Humanoid'):ApplyDescription(HumDesc)
	

	if not table.find(PlayerTable, Player) then
		table.insert(PlayerTable, Player)
	end

	if not MaidTable[Player] then
		MaidTable[Player] = PlayerMaid
	end

	if CurrentPlayers < TotalPlayers then
		CurrentPlayers += 1
	end
	
	
	--Player:LoadCharacter()

	if CurrentPlayers == 1 then
		-- Set up first player model	
		local success, errorMsg = pcall(function()
			
			local Folder = ReplicatedStorage:FindFirstChild('Models')
			
			local Model:Model = Folder:WaitForChild('Model1', 5)::Model
			if Model and PlayerTable[1] then
				local HumDesc = GetHumDesc(PlayerTable[1])
				local Humanoid:Humanoid = Model:FindFirstChildWhichIsA('Humanoid')::Humanoid
				Model.Name = PlayerTable[1].Name
				Humanoid:ApplyDescription(HumDesc) 
				local Clone = Model:Clone()
				Clone.Parent = game:GetService('StarterGui')["RPS-Screen"].Cutscene
				return 'Clone Found!'
			else
				warn("Missing model or player for Player 1 setup")
				return 'Clone not found'
			end
		end)

		if not success then
			warn("Error setting up Player 1 model: "..errorMsg)
		end
		
		
	end


	if CurrentPlayers == TotalPlayers then
		print('Start Choose Map!')

		-- Set up second player model with more error handling
		local success, errorMsg = pcall(function()
			local Folder = ReplicatedStorage:FindFirstChild('Models')
			local Model:Model = Folder:FindFirstChild('Model2')::Model

			if #PlayerTable >= 2 then
				local Player2 = PlayerTable[2]
				

				if Player2 then
					local Humanoid:Humanoid = Model:FindFirstChildWhichIsA('Humanoid')::Humanoid
					local HumDesc = GetHumDesc(Player2)
					Model.Name = Player2.Name
					Humanoid:ApplyDescription(HumDesc)
					return 'Success'
				else
					warn("Player2 is nil when setting up model")
					Model.Name = "Player2"
					return'Invalid'
				end
			else
				warn("PlayerTable doesn't have enough players yet")
				Model.Name = "Waiting for Player"
				return 'Invalid Players'
			end
		end)

		if not success then
			warn("Error setting up Player 2 model: " .. errorMsg)
		end
		
		local Player1,Player2 = PlayerTable[1],PlayerTable[2]
		
		PlayerModule:AddPlayers(Player1,Player2)
		
		
		
	end

	local CharacterConnection 
	


	CharacterConnection = Player.CharacterAdded:Connect(function(Character)
		local Humanoid = Character:FindFirstChildWhichIsA('Humanoid')

		if not Humanoid then
			warn("No humanoid found in character")
			return
		end
		
		local HumDesc = GetHumDesc(Player)
		Humanoid:ApplyDescription(HumDesc)
		
		

		PlayerMaid['DiedEvent'] = nil

		PlayerMaid['DiedEvent'] = Humanoid.Died:Connect(function()
			print(Humanoid.Parent)
			if StartLosingLives == true then 
				local leaderstats:Folder = Player:FindFirstChild('leaderstats')::Folder
				if leaderstats and leaderstats:FindFirstChild('Lives') then
					local Lives:IntValue = leaderstats:FindFirstChild('Lives')::IntValue
					Lives.Value -= 1
					print(Humanoid.Parent, ' has lost a life!')
					if Lives.Value == 0 then
						local Winner
						for _, v in pairs(PlayerTable) do 
							if v ~= Player then
								Winner = v
							end
						end
						
						
					

						if Winner then
							task.wait(0.5)
							TeleportBackEvent:FireAllClients('Lives', Winner)
							for i,Players in PlayerTable do 
								SafeTeleport(PlaceID, Players)

							end							
							
						else
							warn("Could not determine winner")
						end
					end
					
					task.delay(1,function()
						
						for _,v in ipairs(game:GetService('Players'):GetPlayers()) do 
							if v then
								v:LoadCharacter()
							end
								
						end
						
						task.wait(1)
						local Round = workspace:GetAttribute('Round')
						print(workspace:GetAttribute('Round'))
						Round+=1
						workspace:SetAttribute('Round',Round)
						DisableRespawnEvent:FireAllClients()
					end)

					
					
					if Map then
						local respawnTable = {}

						for _, v in pairs(Map:GetDescendants()) do 
							if v:IsA('SpawnLocation') then
								table.insert(respawnTable, v)
							end
						end

						if #respawnTable > 0 then
							local Location = math.random(1, #respawnTable)
							Player.RespawnLocation = respawnTable[Location]
						else
							warn("No spawn locations found in map")
						end
					else
						warn("Map is nil during respawn")
					end
				else
					warn("Leaderstats or Lives not found for player")
				end
			end
		end)
	end)

	PlayerMaid["CharacterAdded"] = CharacterConnection
end)

game.Players.PlayerRemoving:Connect(function(Player)
	local playerMaid:any = MaidTable[Player]
	if playerMaid then
		playerMaid:Destroy() -- Disconnect all stored connections
		MaidTable[Player] = nil
	end

	if CurrentPlayers > 0 then
		CurrentPlayers -= 1
		local playerIndex = table.find(PlayerTable, Player)
		if playerIndex then
			table.remove(PlayerTable, playerIndex)
		end
	end

	if CurrentPlayers ~= TotalPlayers then
		TeleportBackEvent:FireAllClients('Player Left')
		for i,Players in PlayerTable do 
			SafeTeleport(PlaceID, Players)

		end	
	end
end)

-- HANDLERS
-- (Event listeners and connections)



Connection = MapSizeEvent.OnServerEvent:Connect(function(Player,Choice)

	local PlayerTable = {}
	local MapSizeChoice:string

	if ChooseMapBool == false or MapSelectionVAR == true then return end

	if not Player then 
		return
	end

	if not Player.Character then
		return
	end

	local UserID = Player.UserId

	if not Choices[Player] then
		Choices[Player] = Choice
		
		warn(Choices)
	end

	for index,value in pairs(Choices) do
		table.insert(PlayerTable,{index,value})
		warn(PlayerTable)
	end



	if #PlayerTable == TotalPlayers and MapSelectionVAR == false then
		MapSelectionVAR = true
		ChooseMapBool = false
		--local CutsceneFrame = game:GetService('StarterGui'):WaitForChild('RPS-Screen',10):WaitForChild('Cutscene',10)

		local Player1,Player2 = PlayerTable[1],PlayerTable[2]
		


		local MapChosen = math.random(0,10)

		if MapChosen <= 5  then
			MapSizeChoice = Player1[2]
		elseif MapChosen >=6 then
			MapSizeChoice = Player2[2]
		end




		local Map = SetUpMap(MapSizeChoice)

		RespawnCharacter(Player1[1].Character,Map)
		--Player1[1].Team = Teams["Stormborn Sentinels"]
		RespawnCharacter(Player2[1].Character,Map)
		--Player2[1].Team = Teams:FindFirstChild('Ember Titans')

		task.delay(3,function()

			if workspace:FindFirstChild('LobbyMap') then
				workspace:FindFirstChild('LobbyMap'):Destroy()
			end
		end)

		task.wait(1)
		RPSEvents:Fire(Player1[1],Player2[1])
		Connection:Disconnect()




	end


end)


StartGame.OnServerEvent:Once(function(Player,String)
	if CurrentPlayers == TotalPlayers then 
		ChooseMap()

	elseif String == 'Studio'   then
		ChooseMap()
	end
end)



workspace:GetAttributeChangedSignal('Round'):Connect(function()
	local Player1,Player2 = PlayerModule:LookForPlayers()
	
	
	
	if workspace:GetAttribute('Round') then
		print(workspace:GetAttribute('Round'))
		RPSEvents:Fire(Player1,Player2)
	end
end)




-- ERROR HANDLING
-- (pcall or other error-handling mechanisms)

