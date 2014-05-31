
local BATTLEGROUND_MAP_STR = "The Trial of Darkspear" -- DO NOT CHANGE
local WELCOME_MESSAGE_STR = "Version 1.0"
local CLICK_GAME_TO_JOIN_STR = "Click a game to join it."
local WAITING_FOR_PLRS_STR = "Waiting for all players to be ready..."

local PLAYER_IN_GAME_STR = nil
MENU_SELECTED = 0
-- Lobby channels WIP, disabled atm since buggy
local MENU_CHANNELS = {"Lobby", "Game"}
local numScrollBarButtons = 50
local dur = 29
local mus_dur = 0
local ONLINE_PLAYERS = {}
local UPDATE_INTERVALS = {30, 5, 5, 0 ,0, 60}
local playing = nil
local links = {}
local IN_GAME = false

-- Set up background model
local model = CreateFrame("Model"--[[, "BackgroundF", MainFrame]])
model:SetCamera(0)
--model:SetFrameStrata("BACKGROUND")
model:SetPoint("TOPLEFT", 0, 0)
model:SetPoint("BOTTOMRIGHT", 0, 0)
model:SetFrameLevel(0)
model:SetLight(1,0,0,-0.5,-0.5,0.7,1.0,1.0,1.0,0.8,1.0,1.0,0.8)

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

-- For debug purposes
function hgdebug()
	toggleLobbyUI(true)
	IN_GAME = true
end

function toggleLobbyUI(hide)
	toggleInterface(not hide)
	if hide then
		model:Hide()
		MainFrame_Back:Hide()
		MainFrame_Header:Hide()
		MainFrame_Chat:Hide()
		MainFrame_OnlinePlayerList:Hide()
		MainFrame_Chat_2:Hide()
		MainFrame_OnlinePlayerList_2:Hide()
	else
		model:Show()
		MainFrame_Back:Show()
		MainFrame_Header:Show()
		MainFrame_Chat:Show()
		MainFrame_OnlinePlayerList:Show()	
	end
end

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
	if math.random(1,2) == 1 then
		model:SetModel([[Interface\Glues\Models\UI_Orc\UI_Orc.m2]])
	else
		model:SetModel([[Interface\GLUES\MODELS\UI_SCOURGE\UI_Scourge.m2]])
	end
	-- Set frame levels
	MainFrame_Back:SetFrameLevel(1)
	MainFrame_Header:SetFrameLevel(1)

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
	
	button = CreateFrame("Button", "SmallButtonOnTopRight1", MainFrame_Back, "SmallButtonTemplate")
	button:SetPoint("TOPLEFT", MainFrame_Back, "TOPLEFT", 641, -23)
	button:SetFrameLevel(3)
	_G["SmallButtonOnTopRight1Icon"]:SetTexture([[Interface\Portal\SmallButtonIcons\1]])
	
	button = CreateFrame("Button", "SmallButtonOnTopRight2", MainFrame_Back, "SmallButtonTemplate")
	button:SetPoint("TOPLEFT", MainFrame_Back, "TOPLEFT", 727, -23)
	button:SetFrameLevel(3)
	_G["SmallButtonOnTopRight2Icon"]:SetTexture([[Interface\Portal\SmallButtonIcons\2]])
	button:SetScript("OnClick", function() ToggleAchievementFrame(false) end)
	
	button = CreateFrame("Button", "SmallButtonOnTopRight3", MainFrame_Back, "SmallButtonTemplate")
	button:SetPoint("TOPLEFT", MainFrame_Back, "TOPLEFT", 813, -23)
	button:SetFrameLevel(3)
	_G["SmallButtonOnTopRight3Icon"]:SetTexture([[Interface\Portal\SmallButtonIcons\3]])
	button:SetScript("OnClick", function() MENU_SELECTED = 5; PlaySound("igMainMenuOption"); ToggleLoadoutFrame() end)
	
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
	
	-- Listen for addon messages
	MainFrame_Chat_2:RegisterEvent("CHAT_MSG_ADDON")
	MainFrame_Chat_2:SetScript("OnEvent", eventHandlerMainFrame)
	
	fontString = MainFrame_OnlinePlayerList_2:CreateFontString("HowToJoinGameStr", "OVERLAY")
	fontString:SetFontObject("GameFontNormalHuge")
	fontString:SetTextColor(1, 1, 1)
	fontString:SetText(CLICK_GAME_TO_JOIN_STR)
	fontString:SetPoint("TOPLEFT", MainFrame_OnlinePlayerList_2, "TOPLEFT", 30, -50)
	
	fontString = MainFrame_Chat_2:CreateFontString("GameNameStr", "OVERLAY")
	fontString:SetFontObject("GameFontNormalHuge")
	fontString:SetTextColor(1, 1, 1)
	fontString:SetText("Game Name:")
	fontString:SetPoint("TOPLEFT", MainFrame_Chat_2, "TOPLEFT", 30, -50)
	
	local editBoxBackdrop = {
	  bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
	  edgeFile = [[Interface\Glues\Common\Glue-Tooltip-Border]],
	  tile = true,
	  tileSize = 16,
	  edgeSize = 16,
	  insets = {
		left = 10,
		right = 5,
		top = 4,
		bottom = 9
	  }
	}
	fontString = CreateFrame("EditBox", "GameNameInput", MainFrame_Chat_2)
	fontString:SetWidth(250)
	fontString:SetHeight(37)
	fontString:SetPoint("TOPLEFT", MainFrame_Chat_2, "TOPLEFT", 160, -47)
	fontString:SetFontObject("ChatFontNormal")
	fontString:SetMaxLetters(40)
	fontString:SetBackdrop(editBoxBackdrop)
	fontString:SetBackdropBorderColor(0.8, 0.8, 0.8)
	fontString:SetBackdropColor(0.09, 0.09, 0.09)
	-- Sets the insets from the edit box's edges which determine its interactive text area
	fontString:SetTextInsets(14, -14, 0, 4)
	fontString:SetScript("OnTextChanged",
		function(self, userInput)
			if string.len(self:GetText()) <= 3 then
				CreateGameBtn:Disable();
			else
				CreateGameBtn:Enable();
			end
		end)
	
	button = CreateFrame("Button", "CreateGameBtn", MainFrame_OnlinePlayerList_2, "LeftMiddleButtonTemplate")
	button:SetPoint("BOTTOMRIGHT", MainFrame_OnlinePlayerList_2, "BOTTOMRIGHT", -118, -65)
	button:SetText("Create Game")
	button:SetWidth(200)
	button:SetFrameLevel(4)
	button:Disable()
	button:SetScript("OnClick",
		function()
			SendAddonMessage("CREATEGAME", _G["GameNameInput"]:GetText(), "WHISPER", UnitName("player"))
			OpenGameLobby(_G["GameNameInput"]:GetText())
		end)
	
	button = CreateFrame("Button", "GoBackBtn", MainFrame_OnlinePlayerList_2, "LeftMiddleButtonTemplate")
	button:SetPoint("BOTTOMRIGHT", MainFrame_OnlinePlayerList_2, "BOTTOMRIGHT", -123, -155)
	button:SetText("Go Back")
	button:SetWidth(190)
	button:SetFrameLevel(4)
	button:SetScript("OnClick", GoBackToMainMenu)
	
	for i=1,50 do
		_G["ScrollBarEntry"..tostring(i)]:SetScript("OnClick", HandleScollBarEntryClick)
	end
	
	--JoinChannelByName(MENU_CHANNELS[1])
end

function HandleScollBarEntryClick(self)
	if not self:GetText() then
		return
	end
	-- If wanting to join a game
	if MENU_SELECTED == 1 then
		-- substring 9, 10 if whitespace
		local lobbyName = string.sub(self:GetText(), 9)
		if string.starts(lobbyName, " ") then
			lobbyName = string.sub(lobbyName, 1)
		end
		SendAddonMessage("JoinGame", lobbyName, "WHISPER", UnitName("player"))
		OpenGameLobby(lobbyName)
	-- If in game lobby or main lobby
	elseif MENU_SELECTED == 0 or MENU_SELECTED == 2 then
		-- disable this function
		-- This needs writing properly
		--[[
		local buttonNumber = tonumber(string.sub(self:GetName(), 15))
		table.insert(ONLINE_PLAYERS, buttonNumber + 1, {"  |cFF00FF00 0 Wins", "1"})
		table.insert(ONLINE_PLAYERS, buttonNumber + 2, {"  |cFFFF0000 0 Losses", "1"})
		-- update view
		SB_Main_ScrollBar_Update()
		]]
	end
end

function PlayGame()
	PlaySound("igMainMenuOption");
	MainFrame_Back:Hide()
	MainFrame_Chat:Hide()
	MainFrame_OnlinePlayerList_2:Show()
	MainFrame_Chat_2:Show()
	MainFrame_OnlinePlayerList:Show()
	ONLINE_PLAYERS = {}
	local str = _G["HowToJoinGameStr"]
	if str then
		str:SetText(CLICK_GAME_TO_JOIN_STR)
	end
	str = _G["CreateGameBtn"]
	if str then
		str:Show()
	end	
	str = _G["GoBackBtn"]
	if str then
		str:Show()
	end	
	-- Update menu selected
	MENU_SELECTED = 1
	dur = 31
end

function GoBackToMainMenu()
	PlaySound("igMainMenuOption");
	MainFrame_Back:Show()
	MainFrame_Chat:Show()
	MainFrame_OnlinePlayerList_2:Hide()
	MainFrame_Chat_2:Hide()
	
	if PLAYER_IN_GAME_STR then
		--LeaveChannelByName(PLAYER_IN_GAME_STR)
	end
	--JoinChannelByName(MENU_CHANNELS[1])
	
	-- Update menu selected
	MENU_SELECTED = 0
	dur = 31
end

function OpenGameLobby(gameName)
	PlaySound("igMainMenuOption");
	PLAYER_IN_GAME_STR = gameName
	--LeaveChannelByName(MENU_CHANNELS[1])
	--JoinChannelByName(gameName)
	MENU_SELECTED = 2
	dur = 31
	_G["HowToJoinGameStr"]:SetText(WAITING_FOR_PLRS_STR)
	_G["CreateGameBtn"]:Hide()
	_G["GoBackBtn"]:Hide()
	MainFrame_Chat_2:Hide()
end

function eventHandlerMainFrame(self, event, message, _, Type, Sender)
    if (event == "CHAT_MSG_ADDON" and Sender == UnitName("player")) then
		local packet, link, linkCount, MSG = message:match("(%d%d%d)(%d%d)(%d%d)(.+)");
		if not packet or not link or not linkCount or not MSG then
			return
		end
		packet, link, linkCount = tonumber(packet), tonumber(link), tonumber(linkCount);
		
		links[packet] = links[packet] or {count = 0};
		links[packet][link] = MSG;
		links[packet].count = links[packet].count + 1;
		
		if (links[packet].count ~= linkCount) then
			return
		end
		
		local fullMessage = table.concat(links[packet]);
		links[packet] = {count = 0};
		
        -- Handle addon messages
		-- Handle game list
		if string.starts(fullMessage, "GAMES-") then
			
			local tokens = scen_split(fullMessage)
			local pos = 1
			for i=2, #tokens, 2 do
				ONLINE_PLAYERS[pos] = {tokens[i + 1], tokens[i]}
				pos = pos + 1
			end
			
			-- update view
			SB_Main_ScrollBar_Update()
		elseif string.starts(fullMessage, "PLAYERS-") then
			local tokens = scen_split(fullMessage)
			for i=2, #tokens do
				ONLINE_PLAYERS[i - 1] = {tokens[i], "1"}
			end
			
			-- update view
			SB_Main_ScrollBar_Update()		
		elseif string.starts(fullMessage, "SelectedPerks-") then
			local tokens = scen_split(fullMessage)
			local perks = tokens[2]
			local offsets = {1, 3, 5, 7}
			for i=1,4 do
				SELECTED_PERKS[i] = tonumber(perks:sub(offsets[i], offsets[i] + 1))
			end
		end
	end
end

function my_FriendsFrame_OnEvent(self, event, message, _, Type, Sender)
	if event == "WHO_LIST_UPDATE" and not IN_GAME then
		for i=1, GetNumWhoResults() do
			-- name, guild, level, race, class, zone, classFileName
			local name, _, _, _, _, zone, _ = GetWhoInfo(i)
			ONLINE_PLAYERS[i] = {name, zone}
		end
		-- update
		SB_Main_ScrollBar_Update()
	else
		original_FriendsFrame_OnEvent(self, event, message, _, Type, Sender)
	end
end

original_FriendsFrame_OnEvent = FriendsFrame_OnEvent;
FriendsFrame_OnEvent = my_FriendsFrame_OnEvent;

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function scen_split(str)
	local b = {}
	local c = 1
	local d = {}
	string.gsub(str, "[%w%s-]", function(a)
		if (a == "-") then
			c = c + 1
		else
			if (not b[c]) then
				b[c] = {}
			end
			table.insert(b[c], a)
		end
	end)
	for k, v in pairs (b) do
		table.insert(d, table.concat(v))
	end
	return d
end

-- SCROOLLLL BARRSSSS

function SB_Main_ScrollBar_Update()
	-- 50 is max entries, 5 is number of lines, 16 is pixel height of each line
	local entries = #ONLINE_PLAYERS
	-- 50 maximum
	if entries > 50 then
		entries = 50
	end
	FauxScrollFrame_Update(MainScrollBar, entries, 5, 16)
	
	local line
	local lineplusoffset
	for line=1,12 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(MainScrollBar)
		if lineplusoffset <= entries then
			if ONLINE_PLAYERS[lineplusoffset] then
				_G["ScrollBarEntry"..line]:SetText("     "..lineplusoffset..": "..ONLINE_PLAYERS[lineplusoffset][1])
				_G["ScrollBarEntry"..line]:Show()
				_G["ScrollBarEntry"..line.."Icon"]:Show()
				-- Main menu
				if MENU_SELECTED == 0 then
					if (ONLINE_PLAYERS[lineplusoffset][2] == BATTLEGROUND_MAP_STR) then
						_G["ScrollBarEntry"..line.."Icon"]:SetTexture([[Interface\Portal\Icons\2]])
					else
						_G["ScrollBarEntry"..line.."Icon"]:SetTexture([[Interface\Portal\Icons\1]])
					end
				-- Play Game menu
				elseif MENU_SELECTED == 1 then
					if (ONLINE_PLAYERS[lineplusoffset][2] == "1") then
						_G["ScrollBarEntry"..line.."Icon"]:SetTexture([[Interface\Portal\Icons\1]])
					else
						_G["ScrollBarEntry"..line.."Icon"]:SetTexture([[Interface\Portal\Icons\2]])
					end
				-- Players in game lobby
				elseif MENU_SELECTED == 2 then
					_G["ScrollBarEntry"..line.."Icon"]:SetTexture([[Interface\Portal\Icons\1]])			
				end
			else
				_G["ScrollBarEntry"..line]:Hide()
				_G["ScrollBarEntry"..line.."Icon"]:Hide()
			end
		else
			_G["ScrollBarEntry"..line]:Hide()
			_G["ScrollBarEntry"..line.."Icon"]:Hide()
		end
	end
end

function mainFrameUpdate(self, elapsed)
	if IN_GAME then
		return
	end
	dur = dur + elapsed
	mus_dur = mus_dur + elapsed
	if not playing then
		if mus_dur > 1.5 then
			PlayMusic([[Interface\FrameXML\1.mp3]])
			playing = 1
			mus_dur = 0
		end
	end
	if playing == 1 then
		if mus_dur > 69 then
			mus_dur = 0
			playing = 2
			PlayMusic([[Interface\FrameXML\2.mp3]])
		end
	elseif playing == 2 then
		if mus_dur > 81 then
			mus_dur = 0
			playing = 1
			PlayMusic([[Interface\FrameXML\1.mp3]])
		end
	end
	if dur > UPDATE_INTERVALS[MENU_SELECTED + 1] then
		dur = 0
		ONLINE_PLAYERS = {}
		if MENU_SELECTED == 0 then
			SetWhoToUI(1) -- do not appear in chat
			SendWho("")
		elseif MENU_SELECTED == 1 then
			-- Retrieve list of games running
			SB_Main_ScrollBar_Update()
			SendAddonMessage("MAINMENU", "GetTheGamesAvailable", "WHISPER", UnitName("player"))
		elseif MENU_SELECTED == 2 then
			SB_Main_ScrollBar_Update()
			-- Retrieve list of people in lobby
			if not PLAYER_IN_GAME_STR then
				print("ERROR: Game name is null and trying to retrieve the players in this games lobby.")
			else
				SendAddonMessage("PLRSLB", PLAYER_IN_GAME_STR, "WHISPER", UnitName("player"))
			end
		end
		-- hackfix location
		ScrollBarEntry1:SetPoint("TOPLEFT", MainScrollBar, "TOPLEFT", 8, 0)
	end
	-- This is hacky as hell, but hey ho. It's set on update as there
	--  needs to be a delay between on load and setting this.
	--  Also this conveniently prevents resizing.
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetFading(nil)
	ChatFrame1:SetPoint("BOTTOMLEFT", MainFrame_Back, "BOTTOMLEFT", 60, 50)
	ChatFrame1:SetFrameStrata("MEDIUM")
	if (MENU_SELECTED == 5) then
		ChatFrame1:SetWidth(325)
	else
		ChatFrame1:SetWidth(700)
	end
	ChatFrame1:SetHeight(300)
end