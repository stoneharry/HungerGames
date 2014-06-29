
#include "ScriptMgr.h"
#include "ScriptedCreature.h"

enum CREATURES
{
	TROLL_GUY = 50000
};

class generalAI : public CreatureScript
{
public:
	generalAI() : CreatureScript("generalAI") { }

	CreatureAI* GetAI(Creature* creature) const OVERRIDE
	{
		return new generalAI_(creature);
	}

	struct generalAI_ : public ScriptedAI
    {
		generalAI_(Creature* creature) : ScriptedAI(creature) { TC_LOG_INFO("server.debug", "CREATURE CONSTRUCTOR!"); }

        void EnterCombat(Unit* aggro) OVERRIDE
        {
			Creature me = ((Creature)this);

			int entry = me.GetEntry();
			switch (entry)
			{
				case TROLL_GUY:
				{
				int option = urand(0, 7);
				std::stringstream msg;
				switch (option)
				{
				case 0:
					msg << "I be killin' " << getRaceString(aggro->getRace()) << "!";
					break;
				case 1:
					msg << "Time to feast on " << getRaceString(aggro->getRace()) << "!";
					break;
				case 2:
					msg << "You die now!";
				}
				if (msg.str().length() != 0)
					me.MonsterSay(msg.str().c_str(), LANG_UNIVERSAL, NULL);
				break;
				}
			}
        }

		void JustDied(Unit* killer) OVERRIDE
		{
			Creature me = ((Creature)this);
			int entry = me.GetEntry();
			switch (entry)
			{
				case TROLL_GUY:
				{
					int option = urand(0, 5);
					std::stringstream msg;
					switch (option)
					{
					case 0:
						msg << "Curse 'mon...";
						break;
					case 1:
						msg << "Hakkar I beg ye'...";
					}
					if (msg.str().length() != 0)
						me.MonsterSay(msg.str().c_str(), LANG_UNIVERSAL, NULL);
					break;
				}
			}
		}

		/*void KilledUnit(Unit* victim) OVERRIDE
		{

		}*/

		std::string getRaceString(int race)
		{
			switch (race)
			{
			case RACE_HUMAN:
				return "Human";
			case RACE_DWARF:
				return "Dwarf";
			case RACE_NIGHTELF:
				return "Night elf";
			case RACE_GNOME:
				return "Gnome";
			case RACE_DRAENEI:
				return "Draenei";
			case RACE_ORC:
				return "Orc";
			case RACE_UNDEAD_PLAYER:
				return "Undead";
			case RACE_TAUREN:
				return "Tauren";
			case RACE_TROLL:
				return "a traitor to the tribe";
			case RACE_BLOODELF:
				return "Blood elf";
			}
			return "ERROR";
		}
	};
};

void addHG_GeneralAI()
{
	new generalAI();
}