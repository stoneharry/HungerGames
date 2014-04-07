
#include "HG_Game.h"

HG_Game::HG_Game(std::string gameName)
{
	GUID = ++CUR_GUID;
	this->gameName = gameName;
	inGame = false;
	killMe = false;
}

HG_Game::~HG_Game()
{
}