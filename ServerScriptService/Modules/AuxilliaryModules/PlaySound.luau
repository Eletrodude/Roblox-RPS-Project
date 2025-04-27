--!strict
local SendSoundModule = {}

local RemotesFolder = game:GetService('ReplicatedStorage'):WaitForChild('Remotes')
local SoundEvent = RemotesFolder:WaitForChild('Auxilliary'):WaitForChild('SoundEvent')

local SettingsModule


--If fireForPlayers is nil, then fire for ALL players, else fire for player inside the table
--FireForPlayers is a table with the player to fire audio to
function SendSoundModule.PlaySoundGlobal(Player:Player,SoundInstance:Sound,FireForAllPlayers:{})
	if not Player then 
		warn('Player not found')
		return
	end
	
	if not SoundInstance then 
		warn('SoundInstance not found')
		return
	end
	
	local FireAll 


	if not FireForAllPlayers or #FireForAllPlayers == 0 then 
		FireAll = true
	else 
		FireAll = false	
	end

	if FireAll == true then 
		SoundEvent:FireAllClients(SoundInstance)
		
	elseif FireAll == false then 
		for index,value in pairs(FireForAllPlayers) do 
			SoundEvent:FireClient(value,SoundInstance)
		end
	end
	
	game.Debris:AddItem(SoundInstance,SoundInstance.TimeLength+3)
	
end






return SendSoundModule