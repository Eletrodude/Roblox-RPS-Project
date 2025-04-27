--!strict
local TeleportBackEvent = game.ReplicatedStorage.Remotes.Auxilliary.TeleportBack

local ScreenGui = script.Parent
local Frame = ScreenGui.Frame





TeleportBackEvent.OnClientEvent:Connect(function(Str,Winner)
	if Str == 'Player Left' then
	
	Frame.Visible = true
		Frame.TextLabel.Text = 'Other Player has left the game'
	task.wait(2)
	Frame.TextLabel.Text = 'Now teleporting you back'
	
	task.spawn(function()
		local DotCounter = 0
		
		while task.wait(0.5) do
			DotCounter += 1 
			
			if DotCounter == 1 then 
				Frame.TextLabel.Text = 'Now teleporting you back.'
			elseif DotCounter == 2 then
				Frame.TextLabel.Text = 'Now teleporting you back..'
			elseif DotCounter == 3 then
				Frame.TextLabel.Text = 'Now teleporting you back...'
				DotCounter = 0
			end
			
			
		end
		
		
		
		
	end)
	
	elseif Str == 'Lives'  then
		Frame.Visible = true
		
		
		if Winner == game.Players.LocalPlayer then
			Frame.TextLabel.Text = 'You have won!'
		elseif Winner ~= game.Players.LocalPlayer and Winner ~= 'THEREYLORDMASTER' then
			Frame.TextLabel.Text = 'Better luck next time!'
		else 
			Frame.TextLabel.Text = 'Noob, imagine cheating, I think i gotta ban u tbh'
		end
	
		task.wait(2)
		Frame.TextLabel.Text = 'Now teleporting you back'

		task.spawn(function()
			local DotCounter = 0

			while task.wait(0.5) do
				DotCounter += 1 

				if DotCounter == 1 then 
					Frame.TextLabel.Text = 'Now teleporting you back.'
				elseif DotCounter == 2 then
					Frame.TextLabel.Text = 'Now teleporting you back..'
				elseif DotCounter == 3 then
					Frame.TextLabel.Text = 'Now teleporting you back...'
					DotCounter = 0
				end
			end

		end)
		
	end	
	
	
end)
