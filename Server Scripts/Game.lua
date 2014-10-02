
print("\n---------------")
print("Loaded game")
print("---------------")

local NUM_PLAYERS_TO_START_GAME = 3
local gameId = 1
--			1    2     3       4     5			6		7
-- Game = { id, name, active, host, {players}, state, data }
local games = {}
local entities = {}

function JoinGame(plr, msg)
	-- Filter unwanted chars
	for i=1, msg:len() do
		if msg[i] == '-' then
			message[i] = '_'
		end
	end
	if plr:GetData("GAME") ~= nil then
		plr:SendBroadcastMessage("ERROR: You are already in game: " .. tostring(plr:GetData("GAME")))
		return
	end
	for _,v in pairs(games) do
		if v[2] == msg then
			if v[3] then
				plr:SendBroadcastMessage("You cannot join a game that is already in progress!")
				return
			end
			table.insert(v[5], plr:GetGUID())
			plr:SetData("GAME", msg)
			plr:SendBroadcastMessage("You have joined: " .. msg)
			return
		end
	end
end

function leaveGame(plr, msg)
	-- Filter unwanted chars
	for i=1, msg:len() do
		if msg[i] == '-' then
			message[i] = '_'
		end
	end
	for k,v in pairs(games) do
		if v[2] == msg then
			games[k][5][plr:GetGUID()] = nil
			plr:SetData("GAME", nil)
			plr:SendBroadcastMessage("You have left: " .. msg)
			return
		end
	end
end

function CREATEGAME(plr, msg)
	-- Filter unwanted chars
	for i=1, msg:len() do
		if msg[i] == '-' then
			message[i] = '_'
		end
	end
	if plr:GetData("GAME") ~= nil then
		plr:SendBroadcastMessage("ERROR: You are already in game: " .. tostring(plr:GetData("GAME")))
		return
	end
	-- Insert a new record
	local newGame = {gameId, msg, false, plr:GetGUID(), {plr:GetGUID()}}
	gameId = gameId + 1
	plr:SetData("GAME", msg)
	table.insert(games, newGame)
end

function GetTheGamesAvailable(plr, msg)
	local gameNames = "GAMES"
	for _,v in pairs(games) do
		if v[3] then
			gameNames = gameNames .. "-2-"
		else
			gameNames = gameNames .. "-1-"
		end
		gameNames = gameNames .. v[2]
	end
	sendAddonMessage(plr, gameNames, 1)
end

-- Retrieve names of people in this BG
function PLRSLB(plr, msg)
	-- Filter unwanted chars
	for i=1, msg:len() do
		if msg[i] == '-' then
			message[i] = '_'
		end
	end
	if plr:GetData("GAME") == nil then
		plr:SendBroadcastMessage("ERROR: You are not in a game.")
		return
	end
	for _,v in pairs(games) do
		if v[2] == msg then
			local peopleInGame = "PLAYERS"
			for _,k in pairs(v[5]) do
				if GetPlayerByGUID(k) then
					peopleInGame = peopleInGame .. "-" .. GetPlayerByGUID(k):GetName()
				end
			end
			sendAddonMessage(plr, peopleInGame, 2)
			return
		end
	end
end

------------------------------------------

local function updateAllGames()
	for k,game in pairs(games) do
--print("Handling: {" .. tostring(game[1]) .. ", " .. tostring(game[2]) .. ", " .. tostring(game[3]) .. ", " .. tostring(game[4]) .. ", " .. tostring(game[5]) .. "}")
		if game[3] then -- active
			handleActiveGame(game)
		else
			handleInactiveGame(game, k)
		end
	end
end

CreateLuaEvent(updateAllGames, 1000, 0)

function handleActiveGame(game)
	local state = game[6]
	if state == 1 then
		local locations = game[7]
		local temp = {}
		local count = 1
		for _,plr in pairs(game[5]) do
			plr = GetPlayerByGUID(plr)
			if plr then
				local obj = PerformIngameSpawn(2, 184719, 800, 0, locations[count][1], locations[count][2], locations[count][3], 0, false, 0, game[1])
				obj:SetScale(0.05)
				--obj:SetByteValue(6 + 0x000B, 0, 1)
				--obj:SetByteValue(6 + 0x000B, 3, 100)
				obj:SetUInt32Value(0x0006 + 0x0003, 0x1) -- untargetable
				count = count + 1
				table.insert(temp, obj)
			end
		end
		game[7] = temp
		state = state + 1
	elseif state < 30 then -- spawning
		state = state + 1
	elseif state == 30 then
		state = 31
		for _,obj in pairs(game[7]) do
			if obj then
				obj:Despawn(0)
			end
		end
		for _,plr in pairs(game[5]) do
			plr = GetPlayerByGUID(plr)
			if plr then
				plr:PlaySoundToPlayer(3439)
			end
		end
	end
	game[6] = state
end

function handleInactiveGame(game, k)
	-- Handle bad host
	if not GetPlayerByGUID(game[4]) then -- host
		for _,plr in pairs(game[5]) do -- all players
			local rPlr = GetPlayerByGUID(plr)
			if rPlr then
				sendAddonMessage(rPlr, "RESET", 3)
				rPlr:SendBroadcastMessage("You have been removed from the queue because the host went offline.")
				rPlr:SetData("GAME", nil)
			end
		end
		games[k] = nil
		return
	end
	-- Check we have enough players
	for kk,plr in pairs(game[5]) do
		local rPlr = GetPlayerByGUID(plr)
		if not rPlr then
			game[5][kk] = nil
		else
			if rPlr:GetMap():GetMapId() ~= 13 then
				rPlr:Teleport(13, 0.0, 0.0, 0.0, 0.0)
			end
		end
	end
	if #game[5] >= NUM_PLAYERS_TO_START_GAME then
		handleStartGame(game)
	end
end

function handleStartGame(game)
	game[3] = true -- active game now
	local locations = {
		{-4308.87, 3279.05, 0.435464, 0.0},
		{-4306.87, 3279.05, 13.735464, 0.0},
		{-4304.87, 3279.05, 13.735464, 0.0},
		{-4302.87, 3279.05, 13.735464, 0.0},
		{-4300.87, 3279.05, 13.735464, 0.0},
		{-4303.87, 3277.05, 13.735464, 0.0},
		{-4303.87, 3275.05, 13.735464, 0.0},
		{-4303.87, 3281.05, 13.735464, 0.0},
		{-4303.87, 3283.05, 13.735464, 0.0},
		{-4305.87, 3279.05, 13.735464, 0.0}
	}
	game[6] = 1 -- state
	locations = shuffled(locations)
	local count = 1
	for _,plr in pairs(game[5]) do
		local rPlr = GetPlayerByGUID(plr)
		if rPlr then
			rPlr:SendBroadcastMessage("The game will start in 30 seconds!")
			rPlr:SetPhaseMask(game[1]) -- currently phase = game ID
			rPlr:Teleport(800, locations[count][1], locations[count][2], locations[count][3], locations[count][4])
			sendAddonMessage(rPlr, "STARTINGGAME", 3) -- interface
			-- Set time to 7am
			local p = CreatePacket(66, 12)
			p:WriteULong(120000) -- time
			p:WriteFloat(1.20000024) -- speed
			p:WriteULong(0)
			count = count + 1
			rPlr:SendPacket(p)
		end
	end
	game[7] = locations
end

function shuffled(tab)
	local n, order, res = #tab, {}, {}
	for i=1,n do order[i] = { rnd = math.random(), idx = i } end
	table.sort(order, function(a,b) return a.rnd < b.rnd end)
	for i=1,n do res[i] = tab[order[i].idx] end
	return res
end

local function PLAYER_EVENT_ON_KILL_PLAYER(event, killer, killed)
	if killer and killed then
		print(killer:GetName() .. " killed  " .. killed:GetName())
	end
end

RegisterPlayerEvent(6, PLAYER_EVENT_ON_KILL_PLAYER)
RegisterPlayerEvent(8, PLAYER_EVENT_ON_KILL_PLAYER) -- death by creature

local function PLAYER_EVENT_ON_LOGOUT(event, player)
	if not player then
		return
	end
	local data = player:GetData("GAME")
	if not data then
		return
	end
	player:SetData("GAME", nil)
	for k,v in pairs(games) do
		if v[2] == data then
			table.remove(v[5], player:GetGUID())
			return
		end
	end
end

RegisterPlayerEvent(4, PLAYER_EVENT_ON_LOGOUT)























