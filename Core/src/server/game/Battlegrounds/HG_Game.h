
#ifndef HG_GAME_HEADER
#define HG_GAME_HEADER

#include <vector>
#include <string>
#include "Battleground.h"
#include "Player.h"

class HG_Game : public Battleground
{
	public:
		HG_Game();
		~HG_Game();
		unsigned int GUID;
		std::string gameName;
		uint64 hostGUID;
		bool inGame;
		bool killMe;

		std::string getPlayerNameListStr();
		void AddPlayer(Player * plr);
		bool RemovePlayer(Player * plr);
	
	private:
		Player* playersInGame[10];
};

// These scope accross the entire project, bad Harry.
static std::vector<HG_Game*> HG_Game_List;
static unsigned int CUR_GUID = 0;

#endif