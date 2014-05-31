
#include "HG_Game.h"

static uint64_t HG_GUID_COUNTER = 0;

HG_Game::HG_Game()
{
	GUID = HG_GUID_COUNTER++;
	IsInGame = false;
	for (int i = 0; i < 10; ++i)
		playersInGame[i] = NULL;
}

HG_Game::~HG_Game()
{
}

bool HG_Game::SetupBattleground()
{
	// spawn creatures and stuff here
	return true;
}

void HG_Game::AddPlayer(Player* player)
{
	Battleground::AddPlayer(player);
	for (int i = 0; i < 10; ++i)
	{
		if (playersInGame[i] == NULL)
		{
			playersInGame[i] = player;
			return;
		}
	}
}

// This is not currently calld when a player logs out and needs to be
void HG_Game::RemovePlayer(Player* player, uint64 guid, uint32 team)
{
	for (int i = 0; i < 10; ++i)
	{
		if (playersInGame[i] != NULL && playersInGame[i]->GetGUID() == guid)
		{
			playersInGame[i] = NULL;
			return;
		}
	}
}

bool HG_Game::HasPlayer(uint64 GUID)
{
	for (int i = 0; i < 10; ++i)
	{
		if (playersInGame[i] != NULL && playersInGame[i]->GetGUID() == GUID)
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
		if (playersInGame[i] != NULL)
		{
			str << "-" << playersInGame[i]->GetName();
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
