--!strict
--local Jump = {}

--function Jump:InitilizeJumpForPlayer(Player:Player)
--	local PlayerData = {
--		LastClickTime = 0,
--		CooldownDuration = 0.6,
--		CooldownThread = nil		
--	}
	
	
	
	
--	self.Players[Player.UserId] = {PlayerData}
	
	
--	self:ExtendCooldown(Player)
	
		
--end


--function Jump:ExtendCooldown(Player:Player)
--	local PlayerData = self.Players[Player.UserID]
--	if not PlayerData then return end
	
--	PlayerData.LastClicked = os.clock()
--	PlayerData.JumpDisabled = true 
	
--	local Character = Player.Character
	
--	if not Character then
--		warn('No Character Found')
--		return
--	end
	
--	local Humanoid = Character:FindFirstChildWhichIsA('Humanoid')
	
--	if not Humanoid then 
--		warn('No Humanoid Found')
--		return
--	end
	
--	if  Character and  Humanoid then 
--		Humanoid.JumpPower = 0
--		Humanoid.JumpHeight = 0
--	end
	
--end

--function Jump:UpdateCooldown(Player:Player)
--	local PlayerData = self.Player[Player.UserId]
--	if not PlayerData then return end
	
--	local CurrentTime = os.clock()
	
--	local TimeElapsed = CurrentTime - PlayerData.LastClickedTime
	
--	local Character = Player.Character
	
--	if not Character then 
--		return 
--	end
	
--	local Humanoid = Character:FindFirstChildWhichIsA('Humanoid')
	
--	if not Humanoid then 
--		return 
--	end
	
	
	
--	if TimeElapsed >= PlayerData.CooldownDuration then 
--		PlayerData.JumpDisabled = false
		
--		Humanoid.JumpPower = 50
--		Humanoid.JumpHeight = 7.2
--	end
	
--end


--return Jump




local JumpDisable = {}

local PlayerList = {}

local RunService = game:GetService('RunService')




function JumpDisable:Cooldowns(Player:Player,JumpDur)
	
	if not PlayerList[Player.UserId] then 
		PlayerList[Player.UserId] = {
			LastClicked = 0,
			JumpDisabled = false,
			JumpStun = 0,
			Thread = nil
		}
	end

	local Data = PlayerList[Player.UserId]
	
	
	Data.LastClicked = os.clock()
	Data.JumpStun = JumpDur
	
	
	
	
	
	if not Data.Thread then 
		Player.Character.Humanoid.JumpPower = 0
		Player.Character.Humanoid.JumpHeight = 0
		
		Data.Thread = RunService.Heartbeat:Connect(function(DT)
			local CurrentTime = os.clock()
			local TimeElapsed = CurrentTime-Data.LastClicked
			
			if TimeElapsed >= Data.JumpStun then 
				Data.Thread:Disconnect()
				Data.Thread = nil
				Player.Character.Humanoid.JumpPower = 50
				Player.Character.Humanoid.JumpHeight = 7.2

			end
			
		end)
		
	else 
		Data.LastClicked = os.clock()
		Data.JumpStun = JumpDur
		
	end
	
end




return JumpDisable