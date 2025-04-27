--!strict
local Audio = {}

BaseVolume = 1
DefaultMasterAudio = 1 --100%
DefaultEffectsAudio = 1 --100%
DefaultMusicAudio = 1 --100%


--If fireForPlayers is nil, then fire for ALL players, else fire for player inside the table
--FireForPlayers is a table with the player to fire audio to
function Audio.AudioHandler(Player:Player,SoundInstance:Sound)
	
	if not Player then 
		warn('Player not found')
		return
	end
	
	local Character = Player.Character
	
	if not Character then 
		warn('Character not found')
		return
	end
	
	if not SoundInstance then 
		warn('SoundInstance not found')
		return
	end
	
	
	local MasterVolume = Character:GetAttribute('MasterVolume')/100
	local EffectsVolume = Character:GetAttribute('EffectsVolume')/100
	local MusicVolume = Character:GetAttribute('MusicVolume')/100
	
	local SoundEffectAudio = SoundInstance:GetAttribute('EffectsAudio')
	local MusicAudio = SoundInstance:GetAttribute('MusicAudio')
	
	local TotalVolume = 0 
	
	if SoundEffectAudio == true then 

		TotalVolume = TotalVolume + (BaseVolume * MasterVolume * EffectsVolume)
	
	elseif MusicAudio == true then 
		TotalVolume = TotalVolume + (BaseVolume * MasterVolume * MusicVolume)
	
	end
	
	
	
	
	
	return TotalVolume
end



return Audio