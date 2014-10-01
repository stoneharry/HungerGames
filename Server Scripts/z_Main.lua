
print("\n---------------")
print("Loaded main")
print("---------------")

-- Prototypes
local functionLookup

-- Handle addon messages
local function onReceiveAddonMsg(event, plr, Type, prefix, msg, receiver)
	if receiver ~= plr then return end
	if not msg or not prefix or not plr then return end
	local func = functionLookup[prefix]
	if func then
		func(plr, msg)
	end
end

RegisterServerEvent(30, onReceiveAddonMsg)

-- Handle selecting talents
function SelectTalents(plr, msg)
	if msg:len() < 8 then return end
	local talents = {}
	table.insert(talents, msg:sub(1, 2))
	table.insert(talents, msg:sub(3, 4))
	table.insert(talents, msg:sub(5, 6))
	table.insert(talents, msg:sub(7, 8))
	for i=1,4 do
		talents[i] = tonumber(talents[i])
		if not talents[i] then return end
	end
	-- Will probably need some sort of verification to see if the player can use this talent
	CharDBQuery("REPLACE INTO `character_perks` VALUES (\'".. 
		tostring(plr:GetGUIDLow()) .."\', \'" ..
		tostring(talents[1]) .. "\', \'" .. tostring(talents[2]) ..
		"\', \'" .. tostring(talents[3]) .. "\', \'" ..
		tostring(talents[4]) .. "\')")
end

-- function lookup
functionLookup = {
	["MAINMENU"] = GetTheGamesAvailable,
	["CREATEGAME"] = CREATEGAME,
	["PLRSLB"] = PLRSLB,
	["JoinGame"] = JoinGame,
	["SelectTalents"] = SelectTalents
}
