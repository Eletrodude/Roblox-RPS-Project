--!strict
for index,value in pairs(game.StarterGui.SettingsGui:GetDescendants()) do 
	if value:IsA('TextLabel') and value.Name == 'BigText' then 
		value.Position = UDim2.new(0.2,0,0.3,0)
	end
	
	
end