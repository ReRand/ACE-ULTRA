local HttpService = game:GetService("HttpService");

function AddUID(child)
	child:SetAttribute("UID", HttpService:GenerateGUID(false))
	child.ChildAdded:Connect(AddUID);
end

game.DescendantAdded:Connect(AddUID)
