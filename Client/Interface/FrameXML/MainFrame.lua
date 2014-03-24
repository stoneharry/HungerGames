
local debugMode = true

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
		SCREEN_WIDTH = value
		vars = nil
	else
		model:SetHeight(value)
		SCREEN_HEIGHT = value
	end
end
res = nil
model:SetLight(1,0,0,-0.5,-0.5,0.7,1.0,1.0,1.0,0.8,1.0,1.0,0.8);

function mainFrameLoaded()
	-- Set background model
	model:SetModel("Interface\\Glues\\Models\\UI_Orc\\UI_Orc.m2");
	-- Set frame levels
	MainFrame_Back:SetFrameLevel(1)
	MainFrame_Header:SetFrameLevel(1)
	
	--[[
	local SCREEN_HEIGHT
	local res = GetCVar("gxResolution")
	local vars = 0
	for value in string.gmatch(res, '([^x]+)') do
		vars = vars + 1
		if vars == 2 then
			SCREEN_HEIGHT = tonumber(value)
		end
	end
	
	local scale = 1
	if SCREEN_HEIGHT ~= 1080 then
		Head01:SetScale(SCREEN_HEIGHT / 1080)
		Head02:SetScale(SCREEN_HEIGHT / 1080)
		Head03:SetScale(SCREEN_HEIGHT / 1080)
	end
	]]
end

function mainFrameUpdate()
	if not debugMode then
		UIParent:Hide()
	end
end