
print("\n---------------")
print("Loaded hooks")
print("---------------")

local function PLAYER_EVENT_ON_ENTER_COMBAT(event, player, enemy)
	if enemy then
		-- play battle music
		player:PlayMusicToPlayer(20002)
		player:SetData("combatMusic", true)
	end
end

RegisterPlayerEvent(33, PLAYER_EVENT_ON_ENTER_COMBAT)

local function PLAYER_EVENT_ON_LEAVE_COMBAT(event, player)
	if player:GetData("combatMusic") then
		-- play normal music
		player:PlayMusicToPlayer(20001)
		player:SetData("combatMusic", nil)
	end
end

RegisterPlayerEvent(34, PLAYER_EVENT_ON_LEAVE_COMBAT)

--[[local function PLAYER_EVENT_ON_LOGIN(event, player)
	player:SendBroadcastMessage("You have logged in!")
	print("Player has logged in!")
	local map = player:GetMap()
	if map and map:GetMapId() ~= 13 then
		player:ResurrectPlayer()
		player:Teleport(13, 0.0, 0.0, 0.0, 0.0)
	end
end

RegisterPlayerEvent(3, PLAYER_EVENT_ON_LOGIN)]]

local function PLAYER_EVENT_ON_REPOP(event, player)
	player:SendBroadcastMessage("Repop")
	player:ResurrectPlayer()
	player:Teleport(13, 0.0, 0.0, 0.0, 0.0, 0.0)
	player:SetData("GAME", nil)
	sendAddonMessage(player, "RESET", 3)
end

RegisterPlayerEvent(35, PLAYER_EVENT_ON_REPOP)


--[[
PLAYER_EVENT_ON_CHARACTER_CREATE        =     1,        // (event, player)
PLAYER_EVENT_ON_CHARACTER_DELETE        =     2,        // (event, guid)
PLAYER_EVENT_ON_LOGIN                   =     3,        // (event, player)
PLAYER_EVENT_ON_LOGOUT                  =     4,        // (event, player)
PLAYER_EVENT_ON_SPELL_CAST              =     5,        // (event, player, spell, skipCheck)
PLAYER_EVENT_ON_KILL_PLAYER             =     6,        // (event, killer, killed)
PLAYER_EVENT_ON_KILL_CREATURE           =     7,        // (event, killer, killed)
PLAYER_EVENT_ON_KILLED_BY_CREATURE      =     8,        // (event, killer, killed)
PLAYER_EVENT_ON_DUEL_REQUEST            =     9,        // (event, target, challenger)
PLAYER_EVENT_ON_DUEL_START              =     10,       // (event, player1, player2)
PLAYER_EVENT_ON_DUEL_END                =     11,       // (event, winner, loser, type)
PLAYER_EVENT_ON_GIVE_XP                 =     12,       // (event, player, amount, victim)
PLAYER_EVENT_ON_LEVEL_CHANGE            =     13,       // (event, player, oldLevel)
PLAYER_EVENT_ON_MONEY_CHANGE            =     14,       // (event, player, amount)
PLAYER_EVENT_ON_REPUTATION_CHANGE       =     15,       // (event, player, factionId, standing, incremental)
PLAYER_EVENT_ON_TALENTS_CHANGE          =     16,       // (event, player, points)
PLAYER_EVENT_ON_TALENTS_RESET           =     17,       // (event, player, noCost)
PLAYER_EVENT_ON_CHAT                    =     18,       // (event, player, msg, Type, lang) - Can return false
PLAYER_EVENT_ON_WHISPER                 =     19,       // (event, player, msg, Type, lang, receiver)
PLAYER_EVENT_ON_GROUP_CHAT              =     20,       // (event, player, msg, Type, lang, group) - Can return false
PLAYER_EVENT_ON_GUILD_CHAT              =     21,       // (event, player, msg, Type, lang, guild) - Can return false
PLAYER_EVENT_ON_CHANNEL_CHAT            =     22,       // (event, player, msg, Type, lang, channel) - Can return false
PLAYER_EVENT_ON_EMOTE                   =     23,       // (event, player, emote) - Not triggered on any known emote
PLAYER_EVENT_ON_TEXT_EMOTE              =     24,       // (event, player, textEmote, emoteNum, guid)
PLAYER_EVENT_ON_SAVE                    =     25,       // (event, player)
PLAYER_EVENT_ON_BIND_TO_INSTANCE        =     26,       // (event, player, difficulty, mapid, permanent)
PLAYER_EVENT_ON_UPDATE_ZONE             =     27,       // (event, player, newZone, newArea)
PLAYER_EVENT_ON_MAP_CHANGE              =     28,       // (event, player)
PLAYER_EVENT_ON_EQUIP                   =     29,       // (event, player, item, bag, slot)
PLAYER_EVENT_ON_FIRST_LOGIN             =     30,       // (event, player)
PLAYER_EVENT_ON_CAN_USE_ITEM            =     31,       // (event, player, itemEntry)
PLAYER_EVENT_ON_LOOT_ITEM               =     32,       // (event, player, item, count)
PLAYER_EVENT_ON_ENTER_COMBAT            =     33,       // (event, player, enemy)
PLAYER_EVENT_ON_LEAVE_COMBAT            =     34,       // (event, player)
PLAYER_EVENT_ON_REPOP                   =     35,       // (event, player)
PLAYER_EVENT_ON_RESURRECT               =     36,       // (event, player)
PLAYER_EVENT_ON_LOOT_MONEY              =     37,       // (event, player, amount)
]]