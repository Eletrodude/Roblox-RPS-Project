--!strict
local SliderModule = {}
SliderModule.__index = SliderModule






function SliderModule:SliderModuleSetUp(Slider:TextButton,Bar:Frame,OnSliderMoved)
	local UserInputService = game:GetService('UserInputService')
	local Player = game.Players.LocalPlayer
	local Mouse = Player:GetMouse()
	local IsDragging = false
	local Min,Max = SetInitialPosition(SliderModule,Bar)
	
	Slider.MouseButton1Down:Connect(function(Min,Max)
		IsDragging = true
		Slider.Position = UDim2.new(Mouse.X,0,Slider.Position.Y,0)
	end)
	
	
	Slider.MouseButton1Up:Connect(function()
		IsDragging = false
		
	end)
	
	
end


function SetInitialPosition(Slider:TextButton,Bar:Frame)
	
	
	
	local MinimumPosition =  Bar.AbsolutePosition.X
	local MaximumPosition = MinimumPosition + Bar.AbsoluteSize.X
	
	return MinimumPosition,MaximumPosition
	
end


return SliderModule