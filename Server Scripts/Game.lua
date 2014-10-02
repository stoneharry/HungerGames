
print("\n---------------")
print("Loaded game")
print("---------------")

local NUM_PLAYERS_TO_START_GAME = 3

local gameId = 1
--			1    2     3       4     5
-- Game = { id, name, active, host, {players} }
local games = {
	--[[{1000, "Test Game 1", false},
	{1001, "Test Game 2", true}]]
}

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

CreateLuaEvent(updateAllGames, 5000, 0)

function handleActiveGame(game)

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
		{-4303.87, 3279.05, 0.435464, 0.0},
		{-4303.87, 3279.05, 0.435464, 0.0},
		{-4303.87, 3279.05, 0.435464, 0.0},
		{-4303.87, 3279.05, 0.435464, 0.0},
		{-4303.87, 3279.05, 0.435464, 0.0},
		{-4303.87, 3279.05, 0.435464, 0.0},
		{-4303.87, 3279.05, 0.435464, 0.0},
		{-4303.87, 3279.05, 0.435464, 0.0},
		{-4303.87, 3279.05, 0.435464, 0.0},
		{-4303.87, 3279.05, 0.435464, 0.0}
	}
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
			rPlr:SendPacket(p)
		end
	end
end

function shuffled(tab)
	local n, order, res = #tab, {}, {}
	for i=1,n do order[i] = { rnd = math.random(), idx = i } end
	table.sort(order, function(a,b) return a.rnd < b.rnd end)
	for i=1,n do res[i] = tab[order[i].idx] end
	return res
end





























