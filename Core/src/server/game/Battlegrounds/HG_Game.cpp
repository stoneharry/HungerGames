
#include "HG_Game.h"

HG_Game::HG_Game()
{
	IsInGame = false;
	//playersInGame[0] = plr;
	for (int i = 1; i < 10; ++i)
		playersInGame[i] = NULL;
}

HG_Game::~HG_Game()
{
}

bool HG_Game::SetupBattleground()
{
	return true;
}

void HG_Game::AddPlayer(Player* player)
{
	Battleground::AddPlayer(player);
}

void HG_Game::RemovePlayer(Player* player, uint64 guid, uint32 /*team*/)
{
	
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