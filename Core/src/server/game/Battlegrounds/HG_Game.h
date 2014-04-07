
#ifndef HG_GAME_HEADER
#define HG_GAME_HEADER

#include <vector>
#include <string>

class HG_Game {
	public:
		HG_Game(std::string gameName);
		~HG_Game();
		unsigned int GUID;
		std::string gameName;
		bool inGame;
		bool killMe;
};

// These scope accross the entire project, bad Harry.
static std::vector<HG_Game*> HG_Game_List;
static unsigned int CUR_GUID = 0;

#endif