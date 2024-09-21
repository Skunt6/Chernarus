void main()
{
    // Fast travel boards
    DC_FastTravel.SpawnBoard(1, "3711.67 403.273 5992.69", "63 0 0"); // Green Mountain with m_ID = 1 in the config
    DC_FastTravel.SpawnBoard(2, "10722.2 350.986 5678.11", "-162.716 0 0"); // Echo with m_ID = 2 in the config
    DC_FastTravel.SpawnBoard(3, "14201.3 196.715 15285.3", "-74.1487 0 0"); // Trailside with m_ID = 3 in the config
    DC_FastTravel.SpawnBoard(4, "1896.99 442.394 15000.9", "-135.043 0 0"); // North Tisy with m_ID = 4 in the config

    // INIT ECONOMY --------------------------------------
    CreateHive();
    GetHive().InitOffline();

    int year, month, day, hour, minute;
    GetGame().GetWorld().GetDate(year, month, day, hour, minute);

    // Change here the dates for whatever months you desire
    if (month < 12)
    {
        year = 2011;
        month = 12;
        day = 25;
        GetGame().GetWorld().SetDate(year, month, day, hour, minute);
    }
}

class CustomMission : MissionServer
{
    override void OnInit()
    {
        super.OnInit();

        // This piece of code is recommended otherwise event system is switched on automatically and runs from default values
        // Comment this whole block if NOT using Namalsk Survival
        if (m_EventManagerServer)
        {
            // Enable/disable event system, min time between events, max time between events, max number of events at the same time
            m_EventManagerServer.OnInitServer(true, 550, 1000, 2);

            // Registering events and their probability
            m_EventManagerServer.RegisterEvent(Aurora, 0.85);
            m_EventManagerServer.RegisterEvent(Blizzard, 0.4);
            m_EventManagerServer.RegisterEvent(ExtremeCold, 0.4);
            m_EventManagerServer.RegisterEvent(Snowfall, 0.6);
            m_EventManagerServer.RegisterEvent(EVRStorm, 0.35);
            m_EventManagerServer.RegisterEvent(HeavyFog, 0.3);
        }
    }

    // Function to disable PvP damage
    override void OnPlayerHit(PlayerBase victim, Object source, float damage, int type, string zone, string ammo)
    {
        PlayerBase attacker;

        // Check if the source of the hit is a player (PvP)
        if (Class.CastTo(attacker, source))
        {
            // If the attacker is a player, prevent PvP damage
            if (attacker != victim)
            {
                // Block the damage
                Print("PvP damage blocked between " + victim.GetIdentity().GetName() + " and " + attacker.GetIdentity().GetName());

                // Prevent damage to the victim
                victim.SetHealth(victim.GetHealth()); // Reset health to block damage
                return; // Stop further damage processing
            }
        }

        // Allow normal AI damage and environmental damage
        super.OnPlayerHit(victim, source, damage, type, zone, ammo);
    }

    // Set random health for items (no change here)
    void SetRandomHealth(EntityAI itemEnt)
    {
        if (itemEnt)
        {
            float rndHlt = Math.RandomFloat(0.45, 0.65);
            itemEnt.SetHealth01("", "", rndHlt);
        }
    }

    override PlayerBase CreateCharacter(PlayerIdentity identity, vector pos, ParamsReadContext ctx, string characterName)
    {
        Entity playerEnt;
        playerEnt = GetGame().CreatePlayer(identity, characterName, pos, 0, "NONE");
        Class.CastTo(m_player, playerEnt);

        GetGame().SelectPlayer(identity, m_player);
        return m_player;
    }

    override void StartingEquipSetup(PlayerBase player, bool clothesChosen)
    {
        EntityAI itemClothing;
        EntityAI itemEnt;
        ItemBase itemBs;
        float rand;

        itemClothing = player.FindAttachmentBySlotName("Body");
        if (itemClothing)
        {
            SetRandomHealth(itemClothing);

            itemEnt = itemClothing.GetInventory().CreateInInventory("BandageDressing");
            player.SetQuickBarEntityShortcut(itemEnt, 2);

            string chemlightArray[] = {"Chemlight_White", "Chemlight_Yellow", "Chemlight_Green", "Chemlight_Red"};
            int rndIndex = Math.RandomInt(0, 4);
            itemEnt = itemClothing.GetInventory().CreateInInventory(chemlightArray[rndIndex]);
            player.SetQuickBarEntityShortcut(itemEnt, 1);
            SetRandomHealth(itemEnt);
        }

        itemClothing = player.FindAttachmentBySlotName("Legs");
        if (itemClothing)
        {
            SetRandomHealth(itemClothing);
        }

        itemClothing = player.FindAttachmentBySlotName("Feet");
    }
}

// Create the custom mission
Mission CreateCustomMission(string path)
{
    return new CustomMission();
}
