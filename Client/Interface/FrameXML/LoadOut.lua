
SELECTED_PERKS = {0, 0, 0, 0}

local PERKS = {
	-- FORMAT: Name, Description, Icon, Required Wins To Use
	{"Potions Galore", "Start with two healing potions.", [[Interface\Icons\Ability_Creature_Cursed_05]], 0},
	-- Test data
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_02]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_03]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_04]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1},
	{"test", "test.", [[Interface\Icons\Ability_Creature_Cursed_01]], 1}
}

--[[local function OnClickedFrame(self, button)
	print(self:GetName() .. " clicked with " .. button)
end]]

local function OnEnterFrame(self, motion)
	local index = string.sub(self:GetName(), 14)
	if string.starts(index, "_") then
		index = string.sub(index, 1)
	end
	index = tonumber(index)
	GameTooltip:Hide()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine("|cFFFFFFFF" .. PERKS[index][1])
	GameTooltip:AddLine(PERKS[index][2])
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
			self:Hide()
			local index = string.sub(self:GetName(), 14)
			if string.starts(index, "_") then
				index = string.sub(index, 1)
			end
			index = tonumber(index)
			f:SetTexture(PERKS[index][3])
			f.ID = index
			SELECTED_PERKS[i] = index
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
	if (_G["LOADOUT_FRAME"]) then
		_G["LOADOUT_FRAME"]:Show()
		return
	end
	local frame = CreateFrame("frame", "LOADOUT_FRAME")
	frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
								edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
								tile = true, tileSize = 16, edgeSize = 16, 
								insets = { left = 4, right = 4, top = 4, bottom = 4 }});
	frame:SetBackdropColor(0,0,0,1);
	frame:SetFrameLevel(5)
	frame:SetWidth(500)
	frame:SetHeight(500)
	frame:SetPoint("CENTER")
	
	MainFrame_Back:Hide()
	MainFrame_Chat:Hide()
	MainFrame_Header:Hide()
	MainFrame_OnlinePlayerList:Hide()
	
	local charmodel = CreateFrame("DressUpModel", nil, frame, nil)
	charmodel:SetWidth(316)
	charmodel:SetHeight(331)
	charmodel:SetPoint("CENTER", frame, "CENTER", 0, 100)
	charmodel:SetUnit("player")
	
	local pos = -100
	for i=1,4 do
		local texture = frame:CreateTexture("loadout_slot"..tostring(i))
		texture:SetTexture([[Interface\FrameXML\slot]])
		texture:SetWidth(68)
		texture:SetHeight(68)
		texture:SetPoint("CENTER", frame, "CENTER", pos, -80)
		pos = pos + 70
	end
	
	local button = CreateFrame("Button", nil, frame, "BigButtonTemplate")
	button:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -10)
	button:SetText("Done")
	button:SetFrameLevel(6)
	button:SetWidth(150)
	button:SetHeight(40)
	button:SetScript("OnClick", ReturnToMainMenu)
	
	pos = -200
	local count = 0
	local offset = 80
	local max_per_line = 12
	for i=1,#PERKS do
		local texture = CreateFrame("Button", "loadout_perk_"..tostring(i), frame, nil)
		texture:SetWidth(36)
		texture:SetHeight(36)
		texture:SetPoint("BOTTOM", frame, "BOTTOM", pos, offset)
		texture.X = pos
		texture.Y = offset
		texture:SetBackdrop({bgFile = PERKS[i][3], 
								edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
								tile = false, tileSize = 36, edgeSize = 16, 
								insets = { left = 4, right = 4, top = 4, bottom = 4 }});
		texture:SetMovable(true)
		
		texture:SetScript("OnEnter", OnEnterFrame)
		texture:SetScript("OnLeave", OnLeaveFrame)	
		--texture:SetScript("OnClick", OnClickedFrame)
		texture:RegisterForDrag("LeftButton")
		texture:SetScript("OnDragStart", OnDragStart)
		texture:SetScript("OnDragStop", OnDragStop)
		
		pos = pos + 35
		count = count + 1
		if count == max_per_line then
			pos = -200
			offset = offset - 34
			count = 0
		end
	end
	
	-- Enable this to create dummy icons to fill the row
	--[[if (count < max_per_line) then
		for i=count,max_per_line - 1 do
			local texture = CreateFrame("frame", nil, frame, nil)
			texture:SetWidth(36)
			texture:SetHeight(36)
			texture:SetPoint("BOTTOM", frame, "BOTTOM", pos, offset)
			texture:SetBackdrop({bgFile = "Interface/Icons/INV_Misc_QuestionMark",
									edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
									tile = false, tileSize = 36, edgeSize = 16, 
									insets = { left = 4, right = 4, top = 4, bottom = 4 }});
			pos = pos + 35
			count = count + 1
			if count == max_per_line then
				pos = -200
				offset = offset - 34
				count = 0
			end
		end
	end]]
end
