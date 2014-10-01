
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
			table.insert(v[5], plr)
			plr:SetData("GAME", msg)
			plr:SendBroadcastMessage("You have joined: " .. msg)
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
	local newGame = {gameId, msg, false, plr, {plr}}
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
				peopleInGame = peopleInGame .. "-" .. k:GetName()
			end
			sendAddonMessage(plr, peopleInGame, 2)
			return
		end
	end
end

------------------------------------------

local function updateAllGames()
	for _,game in pairs(games) do
--print("Handling: {" .. tostring(game[1]) .. ", " .. tostring(game[2]) .. ", " .. tostring(game[3]) .. ", " .. tostring(game[4]) .. ", " .. tostring(game[5]) .. "}")
		if game[3] then -- active
			handleActiveGame(game)
		else
			handleInactiveGame(game)
		end
	end
end

CreateLuaEvent(updateAllGames, 5000, 0)

function handleActiveGame(game)

end

function handleInactiveGame(game)
	-- Handle bad host
	if not game[4] or not game[4]:IsInWorld() then -- host
		for _,plr in pairs(game[5]) do -- all players
			if plr and plr:IsInWorld() then
				plr:SendBroadcastMessage("You have been removed from the queue because the host went offline.")
				plr:SetData("GAME", nil)
			end
		end
		table.remove(games, game)
		return
	end
	-- Check we have enough players
	for _,plr in pairs(game[5]) do
		if not plr or not plr:IsInWorld() then
			table.remove(game[5], plr)
		else
			if plr:GetMap():GetMapId() ~= 13 then
				plr:Teleport(13, 0.0, 0.0, 0.0, 0.0)
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
		if plr then
			plr:SendBroadcastMessage("The game will start in 30 seconds!")
			plr:Teleport(800, locations[count][1], locations[count][2], locations[count][3], locations[count][4])
			sendAddonMessage(plr, "STARTINGGAME", 3)
			-- need some sort of phasing system
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





























