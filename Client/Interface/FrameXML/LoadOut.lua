
local NOT_UNLOCKED_STR = "This perk has not yet been unlocked."

SELECTED_PERKS = {0, 0, 0, 0}

local PERKS = {
	-- FORMAT: Name, Description, Icon
	--   Requirement: 0 = None
	--                1 = Achievement
	--   ID of requirement
	
	-- Default unlocked
	{"Potions Galore", "Start with two healing potions.", [[Interface\Icons\INV_Potion_120]], 0},
	{"Bandages", "Start with two bandages.", [[Interface\Icons\INV_Misc_Bandage_16]], 0},
	{"Hunter's Blunderbuss", "Increases damage against beasts by 10%.", [[Interface\Icons\Ability_Hunter_LockAndLoad]], 0},
	{"Nimble Reflexes", "Your sharpely tuned reflexes increases your chance to land a critical strike by 5%.", [[Interface\Icons\Ability_Rogue_Eviscerate]], 0},
	{"Coward's Bane", "Deal 10% more critical damage when hitting an enemy from behind.", [[Interface\Icons\Ability_Druid_Cower]], 0},
	{"Unending Breath", "Allows you to breath underwater for 300% longer.", [[Interface\Icons\Spell_Shadow_DemonBreath]], 0},
	{"Spyglass", "Start with a spyglass.", [[Interface\Icons\INV_Misc_Spyglass_03]], 0},
	{"\"Team Work\"", "When attacking a player, any other players attacking that player will also be hit by your attacks.", [[Interface\Icons\Spell_Shaman_SpiritLink]], 0},
	-- Unlockable
	{"Cheat Death", "You cheat death! Any damage that would normally kill you will spare you with 1 health left. This effect can only be triggered once per battle.", [[Interface\Icons\Ability_FiegnDead]], 1, 5000},
	{"To the Rescue!", "Your health regeneration is increased by 5% while out of combat.", [[Interface\Icons\Spell_Holy_ArdentDefender]], 1, 5001},
	{"Nightstalker", "During night time, walking will make you harder to find.", [[Interface\Icons\Ability_Stealth]], 1, 5002},
	{"Solar Winds", "During day time, your movement speed is increased by 10%.", [[Interface\Icons\Spell_Holy_SurgeOfLight]], 1, 5003},
	{"King of the Murlocs", "All Murlocs are neutral instead of hostile. All Murlocs will turn hostile when attacked.", [[Interface\Icons\INV_Misc_Head_Murloc_01]], 1, 5004},
	{"Voodoo Shuffle", "While within a Troll controlled area, your chance to dodge is increased by 10%.", [[Interface\Icons\inv_banner_01]], 1, 5005},
	{"Time is Money!", "While within a Goblin controlled area, your attack speed is increased by 5%.", [[Interface\Icons\INV_Misc_Coin_01]], 1, 5006},
	{"Crystal Meal", "Deal 10% more damage but take 20% more damage.", [[Interface\Icons\INV_Misc_Gem_Variety_02]], 1, 5018},
	{"Gem of True Sight", "Allows visibility of all units at all times.", [[Interface\Icons\INV_Stone_03]], 1, 5019},
	{"Grave Robber", "Allows you to instantly loot killed players.", [[Interface\Icons\INV_Misc_Shovel_01]], 1, 5020},
	{"Poisoned Blade", "When attacking with a melee weapon you have a 2% chance of inflicting a poison that will slowly kill the target over a long period of time.", [[Interface\Icons\INV_Misc_Slime_01]], 1, 5021},
	{"Potion of Fire", "You start with 2 potions of fire.", [[Interface\Icons\INV_SummerFest_FirePotion]], 1, 5022},
	{"Berserker", "When you are below 10% health you deal 75% more damage.", [[Interface\Icons\RACIAL_TROLL_BERSERK]], 1, 5023},
	{"Divine Sacrifice", "Gain the ability to kill yourself but deal your remaining health as damage to all enemies within 30 yards.", [[Interface\Icons\Spell_Shadow_SacrificialShield]], 1, 5024},
	{"Aura of Exhaustion", "Decrease the movement speed and life regeneration rate of nearby players by 10%. If no players are within range, the effect is cast on yourself.", [[Interface\Icons\Ability_Creature_Cursed_05]], 1, 5025},
	{"Blood for the Blood God", "Your attacks heal you for 15% of the damage you deal but you take constant damage and do not regenerate health naturally.", [[Interface\Icons\Ability_Warlock_DemonicEmpowerment]], 1, 5026}
}

local function OnClickedFrame(self, button)
	if not self.index then
		return
	end
	local id = tonumber(self:GetName():sub(13,13))
	self:SetBackdrop({bgFile = [[Interface\FrameXML\slot]], 
					edgeFile = "", 
					tile = false, tileSize = 68, edgeSize = 16, 
					insets = { left = 4, right = 4, top = 4, bottom = 4 }});
	self.index = nil
	SELECTED_PERKS[id] = 0
	PlaySound("GAMESPELLACTIVATE")
end

local function OnEnterFrame(self, motion)
	local index = self.index
	if not index then
		return
	end
	GameTooltip:Hide()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine("|cFFFFFFFF" .. PERKS[index][1])
	local description = WordWrap(PERKS[index][2], 42)
	for _,v in pairs(description) do
		GameTooltip:AddLine(v)
	end
	if (PERKS[index][5]) then
		local _, _, _, completed = GetAchievementInfo(PERKS[index][5])
		if not completed then
			GameTooltip:AddLine("|cFFFF0000" .. NOT_UNLOCKED_STR)
		end
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
	MENU_SELECTED = 0
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
		-- Perks may now be unlocked that were locked previously, so update
		for i=1,#PERKS do
			local requirement = PERKS[i][4]
			local unlocked = 0
			if requirement == 1 then
				local _, _, _, completed, _, _, _, _, _, _, _, _, _, _ = GetAchievementInfo(PERKS[i][5])
				if not completed then
					unlocked = 1
				end
			end
			select(-9, _G["loadout_perk_"..tostring(i)]:GetRegions()):SetDesaturated(unlocked)
		end
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
		texture:RegisterForClicks("RightButtonUp")
		texture:SetScript("OnClick", OnClickedFrame)
		pos = pos + 70
	end
	
	local button = CreateFrame("Button", nil, frame, "BigButtonTemplate")
	button:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -20, -20)
	button:SetText("Done")
	button:SetFrameLevel(5)
	button:SetWidth(150)
	button:SetHeight(40)
	button:SetScript("OnClick", ReturnToMainMenu)
	
	pos = -152
	local count = 0
	local offset = 90
	local max_per_line = 10
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
			texture:RegisterForDrag("LeftButton")
			texture:SetScript("OnDragStart", OnDragStart)
			texture:SetScript("OnDragStop", OnDragStop)
		else
			select(-9, texture:GetRegions()):SetDesaturated(1)
		end
		
		pos = pos + 35
		count = count + 1
		if count == max_per_line then
			pos = -152
			offset = offset - 34
			count = 0
		end
	end
end

-- For text wrap

function WordWrap(input, width)
	local result = {};
	
	for extra = 0, 1 do
		local res = {lines = {}, missed = 0, missedSq = 0};
		
		local exploded = {};
		for match in input:gmatch("(%S+)") do
			table.insert(exploded, match);
		end
		local i = 1;
		while i <= #exploded do
			local t = {};
			local len = 0;
			while len < width do
				local str = exploded[i];
				if (not str) then
					break;
				elseif (len == 0 and #str >= width) then
					if (#str == width) then
						i = i + 1;
					else
						exploded[i] = str:sub(width+1);
						str = str:sub(1, width);
					end
				elseif (len + #str + extra > width) then
					break;
				else
					i = i + 1;
				end
				table.insert(t, str);
				len = len + #str + 1;
			end
			
			local line = table.concat(t, " ");
			res.missed = res.missed + (width - #line);
			res.missedSq = res.missedSq + (width - #line)^2;
			
			table.insert(res.lines, line);
		end
		
		table.insert(result, res);
	end
	
	local current;
	local ret = false;
	
	for _, res in ipairs(result) do
		if (not current) then
			current = res;
		else
			if (#res.lines < #current.lines) then
				current = res;
				ret = true;
			end
		end
	end
	
	if (ret) then
		return current.lines;
	end
	
	current = nil;
	for _, res in ipairs(result) do
		if (not current) then
			current = res;
		else
			if (res.missed < current.missed) then
				current = res;
				ret = true;
			end
		end
	end
	
	if (ret) then
		return current.lines;
	end
	
	current = nil;
	for _, res in ipairs(result) do
		if (not current) then
			current = res;
		else
			if (res.missedSq <= current.missedSq) then
				current = res;
				ret = true;
			end
		end
	end
	
	return current.lines;
end
