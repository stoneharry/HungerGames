
local BATTLEGROUND_MAP_STR = "Warsong Gulch" -- DO NOT CHANGE
local WELCOME_MESSAGE_STR = "Welcome to Hunger Games WoW! Version 1.0"
local numScrollBarButtons = 50
-- Get who results every 30 seconds
local dur = 27
local ONLINE_PLAYERS = {}

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
	model:SetModel([[Interface\Glues\Models\UI_Orc\UI_Orc.m2]]);
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
	button:SetScript("OnClick", PlayGame)
	--button:SetBackdropColor(1, 0, 0 --[[, alpha]])
	
	button = CreateFrame("Button", "SmallButtonOnTopRight1", MainFrame_Back, "SmallButtonTemplate")
	button:SetPoint("TOPLEFT", MainFrame_Back, "TOPLEFT", 641, -23)
	button:SetFrameLevel(3)
	_G["SmallButtonOnTopRight1Icon"]:SetTexture([[Interface\Portal\SmallButtonIcons\1]])
	
	button = CreateFrame("Button", "SmallButtonOnTopRight2", MainFrame_Back, "SmallButtonTemplate")
	button:SetPoint("TOPLEFT", MainFrame_Back, "TOPLEFT", 727, -23)
	button:SetFrameLevel(3)
	_G["SmallButtonOnTopRight2Icon"]:SetTexture("Interface\\Portal\\SmallButtonIcons\\2")
	button:SetScript("OnClick", function() ToggleAchievementFrame(false) end)
	
	button = CreateFrame("Button", "SmallButtonOnTopRight3", MainFrame_Back, "SmallButtonTemplate")
	button:SetPoint("TOPLEFT", MainFrame_Back, "TOPLEFT", 813, -23)
	button:SetFrameLevel(3)
	_G["SmallButtonOnTopRight3Icon"]:SetTexture("Interface\\Portal\\SmallButtonIcons\\3")
	
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

function PlayGame()
	MainFrame_Back:Hide()
	MainFrame_OnlinePlayerList:Hide()
	MainFrame_Chat:Hide()
	MainFrame_OnlinePlayerList_2:Show()
	MainFrame_Chat_2:Show()
end

-- SCROOLLLL BARRSSSS

function SB_Main_ScrollBar_Update()
	-- 50 is max entries, 5 is number of lines, 16 is pixel height of each line
	FauxScrollFrame_Update(MainScrollBar, 50, 5, 16);
	
	local line; -- 1 through 5 of our window to scroll
	local lineplusoffset; -- an index into our data calculated from the scroll offset
	for line=1,12 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(MainScrollBar);
		if lineplusoffset <= 50 then
			if ONLINE_PLAYERS[lineplusoffset] then
				getglobal("ScrollBarEntry"..line):SetText("     "..lineplusoffset..": "..ONLINE_PLAYERS[lineplusoffset][1]);
				getglobal("ScrollBarEntry"..line):Show();
				getglobal("ScrollBarEntry"..line.."Icon"):Show();
				if (ONLINE_PLAYERS[lineplusoffset][2] == BATTLEGROUND_MAP_STR) then
					getglobal("ScrollBarEntry"..line.."Icon"):SetTexture([[Interface\Portal\Icons\2]])
				else
					getglobal("ScrollBarEntry"..line.."Icon"):SetTexture([[Interface\Portal\Icons\1]])
				end
			else
				getglobal("ScrollBarEntry"..line):Hide();
				getglobal("ScrollBarEntry"..line.."Icon"):Hide();
			end
		else
			getglobal("ScrollBarEntry"..line):Hide();
			getglobal("ScrollBarEntry"..line.."Icon"):Hide();
		end
	end
end

function mainFrameUpdate(self, elapsed)
	dur = dur + elapsed
	if dur > 30 then
		dur = 0
		SendWho("")
		ONLINE_PLAYERS = {}
		for i=1, GetNumWhoResults() do
			-- name, guild, level, race, class, zone, classFileName
			local name, _, _, _, _, zone, _ = GetWhoInfo(i)
			ONLINE_PLAYERS[i] = {name, zone}
		end
		-- hackfix location
		ScrollBarEntry1:SetPoint("TOPLEFT", MainScrollBar, "TOPLEFT", 8, 0)
		-- update view
		SB_Main_ScrollBar_Update()
	end
	-- This is hacky as hell, but hey ho. It's set on update as there
	--  needs to be a delay between on load and setting this.
	--  Also this conveniently prevents resizing.
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetFading(nil)
	ChatFrame1:SetPoint("BOTTOMLEFT", MainFrame_Back, "BOTTOMLEFT", 60, 50)
	ChatFrame1:SetFrameStrata("MEDIUM")
	ChatFrame1:SetWidth(700)
	ChatFrame1:SetHeight(300)
	-- Keep that friends frame hidden
	_G["FriendsFrame"]:Hide()
end