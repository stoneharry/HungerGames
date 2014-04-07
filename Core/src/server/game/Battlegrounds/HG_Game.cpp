
#include "HG_Game.h"

HG_Game::HG_Game(std::string gameName, Player* plr)
{
	GUID = ++CUR_GUID;
	this->gameName = gameName;
	inGame = false;
	killMe = false;

	playersInGame[0] = plr;
	for (int i = 1; i < 10; ++i)
		playersInGame[i] = NULL;
}

HG_Game::~HG_Game()
{
}