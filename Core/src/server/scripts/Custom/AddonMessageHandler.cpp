

class HookAddonMessages : public PlayerScript
{
	public:
		HookAddonMessages() : PlayerScript("HookAddonMessagesScript")
		{
		}
		
		void OnChat(Player* player, uint32 type, uint32 lang, std::string& msg)
		{
			if (type == CHAT_MSG_ADDON)
			{
				// Do something
			}
		}
};

void AddMainScript_HungerGames()
{
	new HookAddonMessages();
}