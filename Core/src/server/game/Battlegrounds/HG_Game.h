
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
		uint64 hostGUID;

		bool SetupBattleground();
		std::string getPlayerNameListStr();
		void AddPlayer(Player * plr);
		void RemovePlayer(Player* player, uint64 guid, uint32 /*team*/);
		bool HasPlayer(uint64 guid);

		const bool HasGameStarted() { return IsInGame; }

	private:
		Player* playersInGame[10];
		bool IsInGame;
};

#endif