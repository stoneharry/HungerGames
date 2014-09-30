
print("\n---------------")
print("Loaded game")
print("---------------")

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