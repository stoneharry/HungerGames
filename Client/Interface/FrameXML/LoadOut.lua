
SELECTED_PERKS = {0, 0, 0, 0}

local PERKS = {
	-- FORMAT: Name, Description, Icon
	--   Requirement: 0 = None
	--                1 = Achievement
	--   
	--   ID of requirement
	--   Message if not unlocked
	{"Potions Galore", "Start with two healing potions.", [[Interface\Icons\INV_Potion_120]], 0},
	{"Hunter's Blunderbuss", "Increases damage against beasts by 10%.", [[Interface\Icons\Ability_Hunter_LockAndLoad]], 0},
	{"Intelligence", "Your prowess in thinking increases your chance to land a critical strike by 3%.", [[Interface\Icons\Spell_Arcane_MindMastery]], 0},
	{"Lungs of Air", "Allows you to breath underwater for 300% longer.", [[Interface\Icons\Spell_Shadow_DemonBreath]], 0},
	{"Cheat Death", "You cheat death! Any damage that would normally kill you will spare you with 1 health left. This effect can only be triggered once per battle.", [[Interface\Icons\Ability_FiegnDead]], 0},
	{"Cowards Bane", "Deal 10% more damage when hitting an enemy from behind.", [[Interface\Icons\Ability_Druid_Cower]], 0},
	{"Nightstalker", "During night time, walking will make you harder to find.", [[Interface\Icons\Ability_Stealth]], 0},
	{"Sun's Endurance", "During day time, your movement speed is slightly increased.", [[Interface\Icons\Spell_Holy_SurgeOfLight]], 0},
	{"King of the Murloc", "All Murloc's will not attack you unless you attack them first.", [[Interface\Icons\INV_Misc_MonsterHead_01]], 1, 50, "This perk has not yet been unlocked."}, -- @TODO: Correct achievement ID
	{"Voodoo Shuffle", "While within a Troll controlled area, your chance to dodge is increased by 10%.", [[Interface\Icons\Achievement_Boss_trollgore]], 1, 50, "This perk has not yet been unlocked."}, -- @TODO: Correct achievement ID
	{"Time is Money!", "While within a Goblin controlled area, your attack speed is increased by 5%.", [[Interface\Icons\INV_Misc_Coin_01]], 1, 50, "This perk has not yet been unlocked."}, -- @TODO: Correct achievement ID
	{"To the Rescue!", "Your health regeneration is increased by 5% while out of combat.", [[Interface\Icons\Spell_Holy_ArdentDefender]], 1, 50, "This perk has not yet been unlocked."} -- @TODO: Correct achievement ID
}

--[[local function OnClickedFrame(self, button)
	print(self:GetName() .. " clicked with " .. button)
end]]

local function OnEnterFrame(self, motion)
	local index = self.index
	if not index then
		return
	end
	GameTooltip:Hide()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine("|cFFFFFFFF" .. PERKS[index][1])
	local description = ""
	local wantingToBreak = false
	for i=1,#PERKS[index][2] do
		local c = PERKS[index][2]:sub(i, i)
		-- The below code works, don't ask why or how, just accept it
		if wantingToBreak then
			if c == " " then
				description = description .. "\r\n"
				wantingToBreak = false
			else
				description = description .. c
				if i % 35 == 0 then
					wantingToBreak = true
				end
			end
		else
			description = description .. c
			if i % 35 == 0 then
				wantingToBreak = true
			end
		end
		-- End hacky mess
	end
	GameTooltip:AddLine(description)
	if (PERKS[index][6]) then
		GameTooltip:AddLine("|cFFFF0000" .. PERKS[index][6])
	end
	GameTooltip:SetFrameLevel(5)
	GameTooltip:Show()
end

local function OnLeaveFrame(self, motion)
	GameTooltip:Hide()
end

local function OnDragStart(self)
	self:StartMoving()
end

local function OnDragStop(self)
	self:StopMovingOrSizing()
	for i=1,4 do
		if MouseIsOver(_G["loadout_slot"..tostring(i)]) then
			local f = _G["loadout_slot"..tostring(i)]
			index = self.index
			local nope = false
			for j=1,4 do
				local t = _G["loadout_slot"..tostring(j)]
				if t.index then
					if t.index == index then
						nope = true
					end
				end
			end
			if not nope then
				--self:Hide() -- no need to hide
				--f:SetTexture(PERKS[index][3])
				f:SetBackdrop({bgFile = PERKS[index][3], 
							edgeFile = "", 
							tile = false, tileSize = 68, edgeSize = 16, 
							insets = { left = 4, right = 4, top = 4, bottom = 4 }});
				f.index = index
				SELECTED_PERKS[i] = index
				PlaySound("GAMESPELLACTIVATE")
			end
		end
	end
	self:ClearAllPoints()
	self:SetPoint("BOTTOM", "LOADOUT_FRAME", "BOTTOM", self.X, self.Y)
end

local function ReturnToMainMenu(self)
	MENU_SELECTED = 1
	LOADOUT_FRAME:Hide()
	MainFrame_Back:Show()
	MainFrame_Chat:Show()
	MainFrame_Header:Show()
	MainFrame_OnlinePlayerList:Show()
	PlaySound("igMainMenuOption")
end

function ToggleLoadoutFrame()
	MainFrame_Back:Hide()
	MainFrame_Chat:Hide()
	MainFrame_Header:Hide()
	MainFrame_OnlinePlayerList:Hide()
	
	if (_G["LOADOUT_FRAME"]) then
		_G["LOADOUT_FRAME"]:Show()
		--[[for i=1,#PERKS do
			_G["loadout_perk_"..tostring(i)]:Show()
		end]]
		return
	end
	
	local frame = CreateFrame("frame", "LOADOUT_FRAME")
	frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
								edgeFile = "Interface/Portal/Widgets/bnet-dialoguebox-border", 
								tile = true, tileSize = 32, edgeSize = 64, 
								insets = { left = 5, right = 5, top = 5, bottom = 5 }});
	frame:SetBackdropColor(0,0,0,1);
	frame:SetFrameLevel(3)
	frame:SetWidth(500)
	frame:SetHeight(500)
	frame:SetPoint("CENTER")
	
	local charmodel = CreateFrame("DressUpModel", nil, frame, nil)
	charmodel:SetWidth(316)
	charmodel:SetHeight(331)
	charmodel:SetPoint("CENTER", frame, "CENTER", 0, 90)
	charmodel:SetUnit("player")
	
	local pos = -100
	for i=1,4 do
		local texture = CreateFrame("Button", "loadout_slot"..tostring(i), frame, nil)
		texture:SetWidth(68)
		texture:SetHeight(68)
		texture:SetPoint("CENTER", frame, "CENTER", pos, -80)
		texture:SetFrameLevel(4)
		texture:SetBackdrop({bgFile = [[Interface\FrameXML\slot]], 
								edgeFile = "", 
								tile = false, tileSize = 68, edgeSize = 16, 
								insets = { left = 4, right = 4, top = 4, bottom = 4 }});
		texture:SetScript("OnEnter", OnEnterFrame)
		texture:SetScript("OnLeave", OnLeaveFrame)	
		pos = pos + 70
	end
	
	local button = CreateFrame("Button", nil, frame, "BigButtonTemplate")
	button:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -20, -20)
	button:SetText("Done")
	button:SetFrameLevel(5)
	button:SetWidth(150)
	button:SetHeight(40)
	button:SetScript("OnClick", ReturnToMainMenu)
	
	pos = -135
	local count = 0
	local offset = 80
	local max_per_line = 9
	for i=1,#PERKS do
		local texture = CreateFrame("Button", "loadout_perk_"..tostring(i), frame, nil)
		texture:SetWidth(36)
		texture:SetHeight(36)
		texture:SetPoint("BOTTOM", frame, "BOTTOM", pos, offset)
		texture.X = pos
		texture.Y = offset
		texture.index = i
		texture:SetFrameLevel(5)
		texture:SetBackdrop({bgFile = PERKS[i][3], 
								edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
								tile = false, tileSize = 36, edgeSize = 16, 
								insets = { left = 4, right = 4, top = 4, bottom = 4 }});
								
		local requirement = PERKS[i][4]
		local unlocked = true
	
		if requirement == 1 then
			local _, _, _, completed, _, _, _, _, _, _, _, _, _, _ = GetAchievementInfo(PERKS[i][5])
			if not completed then
				unlocked = false
			end
		end
		
		texture:SetScript("OnEnter", OnEnterFrame)
		texture:SetScript("OnLeave", OnLeaveFrame)	
		
		if unlocked then
			texture:SetMovable(true)
			--texture:SetScript("OnClick", OnClickedFrame)
			texture:RegisterForDrag("LeftButton")
			texture:SetScript("OnDragStart", OnDragStart)
			texture:SetScript("OnDragStop", OnDragStop)
		else
			select(-9, texture:GetRegions()):SetDesaturated(1)
		end
		
		pos = pos + 35
		count = count + 1
		if count == max_per_line then
			pos = -135
			offset = offset - 34
			count = 0
		end
	end
end

