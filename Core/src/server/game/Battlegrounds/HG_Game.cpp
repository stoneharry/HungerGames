
#include "HG_Game.h"

static uint64_t HG_GUID_COUNTER = 0;

HG_Game::HG_Game()
{
	GUID = HG_GUID_COUNTER++;
	IsInGame = false;
	for (int i = 0; i < 10; ++i)
		playersInGame[i] = 0;
	// To do: Put proper coordinates in here
	locations[0] = WorldLocation(800, -4303.87, 3279.05, 0.435464, 0);
	locations[1] = WorldLocation(800, -4303.87, 3279.05, 0.435464, 0);
	locations[2] = WorldLocation(800, -4303.87, 3279.05, 0.435464, 0);
	locations[3] = WorldLocation(800, -4303.87, 3279.05, 0.435464, 0);
	locations[4] = WorldLocation(800, -4303.87, 3279.05, 0.435464, 0);
	locations[5] = WorldLocation(800, -4303.87, 3279.05, 0.435464, 0);
	locations[6] = WorldLocation(800, -4303.87, 3279.05, 0.435464, 0);
	locations[7] = WorldLocation(800, -4303.87, 3279.05, 0.435464, 0);
	locations[8] = WorldLocation(800, -4303.87, 3279.05, 0.435464, 0);
	locations[9] = WorldLocation(800, -4303.87, 3279.05, 0.435464, 0)
	std::random_shuffle(std::begin(locations), std::end(locations));
}

HG_Game::~HG_Game()
{
}

bool HG_Game::SetupBattleground()
{
	// Spawn creatures in here
	return true;
}

void HG_Game::AddPlayer(Player* player)
{
	Battleground::AddPlayer(player);
	for (int i = 0; i < 10; ++i)
	{
		if (playersInGame[i] == 0)
		{
			playersInGame[i] = player->GetGUIDLow();
			break;
		}
	}
	for (int i = 9; i >= 0; --i)
	{
		if (playersInGame[i] == 0)
			return;
		Player * plr = sObjectMgr->GetPlayerByLowGUID(playersInGame[i]);
		if (plr == NULL)
		{
			playersInGame[i] = 0;
			return;
		}
	}
	for (int i = 0; i < 10; ++i) {
		if (playersInGame[i] != 0) // should always be really
		{
			Player * plr = sObjectMgr->GetPlayerByLowGUID(playersInGame[i]);
			if (plr != NULL)
				plr->TeleportTo(locations[i]);
		}
	}
}

void HG_Game::RemovePlayer(Player* plr, uint64 guid, uint32 team)
{
	for (int i = 0; i < 10; ++i)
	{
		if (playersInGame[i] == guid)
		{
			playersInGame[i] = 0;
			return;
		}
	}
}

bool HG_Game::HasPlayer(uint64 GUID)
{
	for (int i = 0; i < 10; ++i)
	{
		if (playersInGame[i] == GUID)
			return true;
	}
	return false;
}

std::string HG_Game::getPlayerNameListStr()
{
	std::stringstream str;
	str << "PLAYERS";
	for (int i = 0; i < 10; ++i)
	{
		if (playersInGame[i] != 0)
		{
			Player * plr = sObjectMgr->GetPlayerByLowGUID(playersInGame[i]);
			if (plr != NULL)
				str << "-" << plr->GetName();
			else
				playersInGame[i] = 0;
		}
	}
	return str.str();
}

bool HG_Game::SetGameName(std::string name, uint64 playerGUID)
{
    if (playerGUID == 0 && !IsHost(playerGUID))
        return false;
    if (GetStatus() >= STATUS_IN_PROGRESS)
        return false;
    //Todo: Filter non latin characters, disallow excessive caps ect.
    GameName = name;
    return true;
}
