
-- Set up background model
local model = CreateFrame("Model"--[[, "BackgroundF", MainFrame]]);
model:SetCamera(0);
model:SetPoint("CENTER",0,0);
--model:SetFrameStrata("HIGH");
model:SetFrameLevel(0);
-- This gets the width/height of the screen
local res = GetCVar("gxResolution")
local vars = 1
for value in string.gmatch(res, '([^x]+)') do
	if vars == 1 then
		model:SetWidth(value)
		vars = nil
	else
		model:SetHeight(value)
	end
end
res = nil
model:SetLight(1,0,0,-0.5,-0.5,0.7,1.0,1.0,1.0,0.8,1.0,1.0,0.8);

-- Set background model
function mainFrameLoaded()
	model:SetModel("Interface\\Glues\\Models\\UI_Orc\\UI_Orc.m2");
	MainFrame_Back:SetFrameLevel(1)
	UIParent:Hide()
end