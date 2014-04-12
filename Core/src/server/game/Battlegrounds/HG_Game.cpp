
#include "HG_Game.h"

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
	Battleground::RemovePlayer(player, guid, team);
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