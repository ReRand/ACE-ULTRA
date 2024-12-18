local MobileMockGui = {};
MobileMockGui.__index = MobileMockGui


local cas = game:GetService("ContextActionService")


function MobileMockGui.init()
	local self = setmetatable({}, MobileMockGui)
	return self;
end


function MobileMockGui:Replicate(name, from)
	
	-- print(name, from);
	
	if not from then from = "ContextButtonFrame"; end
	local button = cas:GetButton(name);
	
	-- repeat task.wait(); print(button); button = cas:GetButton(name) until button;

	if not button then return; end

	local mockButton = game.StarterGui.MobileGuiMock:WaitForChild("ContextActionGui"):WaitForChild(from):WaitForChild(name);
	
	button.Position = mockButton.Position
	button.Size = mockButton.Size
	button.Rotation = mockButton.Rotation

	button.Image = mockButton.Image;

	for _, actionthing in pairs(mockButton:GetChildren()) do
		if button:FindFirstChild(actionthing.Name) then
			button[actionthing.Name]:Destroy()
		end

		actionthing:Clone().Parent = button;
	end
end



return MobileMockGui;