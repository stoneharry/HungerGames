#include "HGManager.h"

#include "Player.h"
#include "HGGame.h"

namespace HG
{
	std::list<Message> handlers = {
			{ "MAINMENU", "GetTheGamesAvailable", std::bind(&Manager::HandleGamesAvilable, sHGManager, std::placeholders::_1, std::placeholders::_2) },
			{ "CREATEGAME", "", std::bind(&Manager::HandleCreateGame, sHGManager, std::placeholders::_1, std::placeholders::_2) },
			{ "PLRSLB", "", std::bind(&Manager::HandlePlayerList, sHGManager, std::placeholders::_1, std::placeholders::_2) },
			{ "JoinGame", "", std::bind(&Manager::HandleJoinGame, sHGManager, std::placeholders::_1, std::placeholders::_2) },
			{ "SelectTalents", "", std::bind(&Manager::HandleSelectTalents, sHGManager, std::placeholders::_1, std::placeholders::_2) },
	};


	Manager::Manager()
	{}

	Manager::~Manager()
	{}

	void Manager::HandleGamesAvilable(Player *sender, std::string cmd)
	{
		/*// Send: GAMES-icon-gamename...
			std::stringstream str;

			str << "GAMES";

			for (auto& pair : sBattlegroundMgr->bgDataStore[BATTLEGROUND_HG_1].m_Battlegrounds)
			{
			BattlegroundStatus status = pair.second->GetStatus();
			if (status != STATUS_WAIT_LEAVE)
			{
			str << (status >= STATUS_WAIT_JOIN ? "-2-" : "-1-");
			str << ((HG_Game *)pair.second)->GetGameName();
			}
			}

			SendAddonMessage(sender, str.str(), 2);*/
	}

	void Manager::HandleCreateGame(Player *sender, std::string cmd)
	{
		/*// second = game name
		// Handle second contains game name
		if (second.length() < 3)
		{
		sWorld->SendServerMessage(SERVER_MSG_STRING, "Game name is too short!", sender);
		return;
		}
		// Filter characters that could cause bugs
		for (unsigned int i = 0; i < second.length(); ++i)
		if (second[i] == '-')
		second[i] = '_';
		// Check game name doesn't already exist
		for (auto& pair : sBattlegroundMgr->bgDataStore[BATTLEGROUND_HG_1].m_Battlegrounds)
		{
		HG_Game* temp = (HG_Game*)pair.second;
		if (!temp->HasPlayer(sender->GetGUID())) //wat? what has that to do with game name?
		{
		sender->LeaveBattleground(true);
		break;
		}
		}
		// Add BG
		HG_Game* temp = new HG_Game();
		temp->AddPlayer(sender);
		temp->SetHost(sender->GetGUID());
		temp->SetGameName(second, sender->GetGUID());
		temp->SetTypeID(BATTLEGROUND_HG_1);
		temp->SetInstanceID(temp->GetGUID());
		sBattlegroundMgr->AddBattleground(temp);*/
	}

	void Manager::HandlePlayerList(Player *sender, std::string cmd)
	{
		/*// Filter characters that could cause bugs
		for(uint32 i = 0; i < second.length(); ++i)
			if(second[i] == '-')
				second[i] = '_';

		for(auto& pair : sBattlegroundMgr->bgDataStore[BATTLEGROUND_HG_1].m_Battlegrounds)
		{
			HG_Game* temp = (HG_Game*)pair.second;
			if(temp->GetGameName().compare(second) == 0)
			{
				SendAddonMessage(sender, temp->getPlayerNameListStr(), 1);
				return;
			}
		}*/
	}

	void Manager::HandleJoinGame(Player *sender, std::string cmd)
	{
		/*// Filter characters that could cause bugs
		for (uint32 i = 0; i < second.length(); ++i)
		if (second[i] == '-')
		second[i] = '_';
		// Retrieve which game is being requested for
		for (auto& pair : sBattlegroundMgr->bgDataStore[BATTLEGROUND_HG_1].m_Battlegrounds)
		{
		HG_Game* temp = (HG_Game*)pair.second;
		if (temp->GetGameName().compare(second) == 0)
		{
		if (!temp->HasPlayer(sender->GetGUID()))
		temp->AddPlayer(sender);
		else
		sWorld->SendServerMessage(SERVER_MSG_STRING, "Cheat detected, failed to add to game.", sender);
		return;
		}
		}
		sWorld->SendServerMessage(SERVER_MSG_STRING, "Something went wrong trying to join this game!", sender);*/
	}

	void Manager::HandleSelectTalents(Player *sender, std::string cmd)
	{
		/*
		if(second.length() < 8)
			return;
		int32 perks[4];
		std::string talents[4];
		// retrieve talents
		talents[0] = second.substr(0, 2);
		talents[1] = second.substr(2, 2);
		talents[2] = second.substr(4, 2);
		talents[3] = second.substr(6, 2);
		for(int32 i = 0; i < 4; ++i)
		{
			// verify them
			if(!isdigit(talents[i][0]) || !isdigit(talents[i][1]))
				return;
			// Set selected perk
			perks[i] = atoi(talents[i].c_str());
			sender->SetSelectedPerk(i, perks[i]);
		}
		// Save to database
		QueryResult result = CharacterDatabase.PQuery("SELECT COUNT(*) FROM `character_perks` WHERE `GUID` = '%u'", sender->GetGUIDLow());
		uint64 rows = result->Fetch()[0].GetUInt64();
		if(rows == 0)
		{
			CharacterDatabase.DirectPExecute("INSERT INTO `character_perks` VALUES ('%u', '%d', '%d', '%d', '%d')",
											 sender->GetGUIDLow(), perks[0], perks[1], perks[2], perks[3]);
		}
		else if(rows == 1)
		{
			CharacterDatabase.DirectPExecute("UPDATE `character_perks` SET `perk1`='%d',`perk2`='%d',`perk3`='%d',`perk4`='%d' WHERE `GUID` = '%u'",
											 perks[0], perks[1], perks[2], perks[3], sender->GetGUIDLow());
		}
		else
		{
			TC_LOG_INFO("server.error", "[ERROR]: Character %s has multiple perk records in the database.", sender->GetName().c_str());
		}*/
	}
}
