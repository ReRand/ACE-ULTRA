local images = script.Parent.Parent.images:GetChildren();
local ts = game:GetService("TweenService");

math.randomseed(os.time())
math.random(); math.random(); math.random()


script.Parent.Parent.Parent.Sound:Play();
script.Parent.Parent.Parent.Static:Play()


while task.wait(1) do
	local color = Color3.new(math.random(0, 1), math.random(0, 1), math.random(0, 1))
	
	script.Parent.Image = images[math.random(1, #images)].Image
	script.Parent.ImageColor3 = color;
	script.Parent.Parent.Parent.SurfaceLight.Color = color;
end