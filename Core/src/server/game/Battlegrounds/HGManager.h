#ifndef HGManager_h__
#define HGManager_h__

#include "Common.h"
#include "DBCEnums.h"
#include <ace/Singleton.h>

namespace HG
{
	class Game;
	class Lobby;

	struct Message
	{
		std::string command;
		std::string subcommand;
		std::function<void(Player*, std::string)> handler;
	};

	typedef std::list<Message> HandlerList;
	extern std::list<Message> handlers;

	class Manager
	{
		friend class ACE_Singleton<Manager, ACE_Null_Mutex>;

	private:
		Manager();
		~Manager();

	public:
		void HandleGamesAvilable(Player *sender, std::string cmd);
		void HandleCreateGame(Player *sender, std::string cmd);
		void HandlePlayerList(Player *sender, std::string cmd);
		void HandleJoinGame(Player *sender, std::string cmd);
		void HandleSelectTalents(Player *sender, std::string cmd);

	private:

	};
}

#define sHGManager ACE_Singleton<HG::Manager, ACE_Null_Mutex>::instance()

#endif // HGManager_h__
