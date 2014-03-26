
local debugMode = true

local WELCOME_MESSAGE_STR = "Welcome to Stoneharry's project!"

-- Set up background model
local model = CreateFrame("Model"--[[, "BackgroundF", MainFrame]]);
model:SetCamera(0);
--model:SetFrameStrata("BACKGROUND")
model:SetPoint("TOPLEFT", 0, 0)
model:SetPoint("BOTTOMRIGHT", 0, 0)
model:SetFrameLevel(0);
model:SetLight(1,0,0,-0.5,-0.5,0.7,1.0,1.0,1.0,0.8,1.0,1.0,0.8);

-- This gets the width/height of the screen
--[[
local res = GetCVar("gxResolution")
local vars = 1
for value in string.gmatch(res, '([^x]+)') do
	if vars == 1 then
		--model:SetWidth(value)
		SCREEN_WIDTH = tonumber(value)
		vars = nil
	else
		--model:SetHeight(value)
		SCREEN_HEIGHT = tonumber(value)
	end
end
res = nil
]]

function toggleInterface(hide)
	if hide then
		MiniMapWorldMapButton:Hide()
		GameTimeFrame:Hide()
		MinimapZoomIn:Hide() -- hides the zoom-in-button (+)
		MinimapZoomOut:Hide() -- hides the zoom-out-button (-)
		--RemoveMainActionBar()
		MainMenuBar:Hide()
		MainMenuBarLeftEndCap:Hide() -- to hide the left one
		MainMenuBarRightEndCap:Hide() -- to hide the right one
		ShapeshiftBarFrame:Hide()
		MultiBarBottomLeft:Hide()
		MultiBarBottomRight:Hide()
		MultiBarLeft:Hide()
		MultiBarRight:Hide()
		MainMenuExpBar:Hide()
	else
		MiniMapWorldMapButton:Show()
		GameTimeFrame:Show()
		MinimapZoomIn:Show() -- hides the zoom-in-button (+)
		MinimapZoomOut:Show() -- hides the zoom-out-button (-)
		--AddMainActionBar()
		MainMenuBar:Show()
		MainMenuBarLeftEndCap:Show() -- to hide the left one
		MainMenuBarRightEndCap:Show() -- to hide the right one
		--ShapeshiftBarFrame:Show()
	end
end

function mainFrameLoaded()
	-- Set background model
	model:SetModel("Interface\\Glues\\Models\\UI_Orc\\UI_Orc.m2");
	-- Set frame levels
	MainFrame_Back:SetFrameLevel(1)
	MainFrame_Header:SetFrameLevel(1)
	
	--MainFrame_Back:SetFrameStrata("BACKGROUND")
	
	-- Hide main interface
	toggleInterface(true)
	
	-- Make the edges a higher layer
	for i = -1, -8, -1 do
		select(i, MainFrame_Back:GetRegions()):SetDrawLayer("OVERLAY")
		select(i, MainFrame_Header:GetRegions()):SetDrawLayer("OVERLAY")
	end
	
	-- Buttons are easier to do in Lua it seems
	local button = CreateFrame("Button", nil, MainFrame_Back, "BigButtonTemplate")
	button:SetPoint("TOPLEFT", MainFrame_Back, "TOPLEFT", 337, -20)
	button:SetText("Play Game")
	button:SetFrameLevel(3)
	--button:SetBackdropColor(1, 0, 0 --[[, alpha]])
	
	button = CreateFrame("Button", nil, MainFrame_Back, "SmallButtonTemplate")
	button:SetPoint("TOPLEFT", MainFrame_Back, "TOPLEFT", 641, -23)
	button:SetFrameLevel(3)
	
	button = CreateFrame("Button", nil, MainFrame_Back, "SmallButtonTemplate")
	button:SetPoint("TOPLEFT", MainFrame_Back, "TOPLEFT", 727, -23)
	button:SetFrameLevel(3)
	
	button = CreateFrame("Button", nil, MainFrame_Back, "SmallButtonTemplate")
	button:SetPoint("TOPLEFT", MainFrame_Back, "TOPLEFT", 813, -23)
	button:SetFrameLevel(3)
	
	button = CreateFrame("Button", nil, MainFrame_Back, "LeftMiddleButtonTemplate")
	button:SetPoint("TOPLEFT", MainFrame_Back, "TOPLEFT", 30, -117)
	button:SetText("Change Lobby")
	button:SetFrameLevel(4)
	button:Disable()
	
	button = CreateFrame("Button", nil, MainFrame_Back, "LeftMiddleButtonTemplate")
	button:SetPoint("BOTTOMRIGHT", MainFrame_Back, "BOTTOMRIGHT", -28, 120)
	button:SetText("Logout")
	button:SetWidth(200)
	button:SetFrameLevel(4)
	button:SetScript("OnClick", function() Logout() end)
	
	button = CreateFrame("Button", nil, MainFrame_Back, "LeftMiddleButtonTemplate")
	button:SetPoint("BOTTOMRIGHT", MainFrame_Back, "BOTTOMRIGHT", -32, 30)
	button:SetText("Exit Game")
	button:SetWidth(190)
	button:SetFrameLevel(4)
	button:SetScript("OnClick", function() Quit() end)
	
	local fontString = MainFrame_Back:CreateFontString("MainFrame_Back_WelcomeFontString", "OVERLAY")
	fontString:SetFontObject("GameFontNormalHuge")
	fontString:SetTextColor(1, 1, 1)
	fontString:SetText(WELCOME_MESSAGE_STR)
	fontString:SetPoint("TOPLEFT", MainFrame_Back, "TOPLEFT", 255, -124)
end

function mainFrameUpdate()
	if not debugMode then
		UIParent:Hide()
	end

	-- This is hacky as hell, but hey ho. It's set on update as there
	--  needs to be a delay between on load and setting this.
	--  Also this conveniently prevents resizing.
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetFading(nil)
	ChatFrame1:SetPoint("BOTTOMLEFT", MainFrame_Back, "BOTTOMLEFT", 60, 50)
	ChatFrame1:SetFrameLevel(4)
	ChatFrame1:SetFrameStrata("HIGH")
	ChatFrame1:SetWidth(700)
	ChatFrame1:SetHeight(300)
end