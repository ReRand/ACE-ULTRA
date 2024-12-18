local Revared = require(workspace.Modules.Revared);
local Captions = Revared:GetModule("Captions");


local player = game.Players.LocalPlayer;
local PlayerGui = player:WaitForChild("PlayerGui");
local TweenService = game:GetService("TweenService");


local CaptionGui = PlayerGui:WaitForChild("CaptionGui");


Captions.from(workspace.Captions.Raw, CaptionGui, "CaptionLabel", "Background", "AuthorLabel");


Captions:SetTweens({
	Background = {
		In = { 
			TweenInfo.new(0.2), {
				BackgroundTransparency = 0.7
			}
		},
		
		Out = { 
			TweenInfo.new(0.2), {
				BackgroundTransparency = 1
			}
		}
	},
	
	
	Label = {
		In = { 
			TweenInfo.new(0.2), {
				TextStrokeTransparency = 0,
				TextTransparency = 0,
			}
		},

		Out = { 
			TweenInfo.new(0.2), {
				TextStrokeTransparency = 1,
				TextTransparency = 1,
			}
		}
	},
	
	
	Author = {
		In = { 
			TweenInfo.new(0.2), {
				TextStrokeTransparency = 0,
				TextTransparency = 0,
			}
		},

		Out = { 
			TweenInfo.new(0.2), {
				TextStrokeTransparency = 1,
				TextTransparency = 1,
			}
		}
	}
});