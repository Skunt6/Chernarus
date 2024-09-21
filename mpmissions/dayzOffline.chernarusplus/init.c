void main()
{
    // Fast travel boards
    DC_FastTravel.SpawnBoard(1, "3711.67 403.273 5992.69", "63 0 0"); // Green Mountain
    DC_FastTravel.SpawnBoard(2, "10722.2 350.986 5678.11", "-162.716 0 0"); // Echo
    DC_FastTravel.SpawnBoard(3, "14201.3 196.715 15285.3", "-74.1487 0 0"); // Trailside
    DC_FastTravel.SpawnBoard(4, "1896.99 442.394 15000.9", "-135.043 0 0"); // North Tisy

    // INIT ECONOMY --------------------------------------
    CreateHive();
    GetHive().InitOffline();

    int year, month, day, hour, minute;
    GetGame().GetWorld().GetDate(year, month, day, hour, minute);

    // Change the date to December 25, 2011
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

        // Event system initialization (if Namalsk Survival or similar events are being used)
        if (m_EventManagerServer)
        {
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

    // Set random health for items (no change)
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

class CustomPlayerBase : PlayerBase
{
    override void EEHitBy(Object source, int component, string zone, string ammo, vector modelPos, float speedCoef)
    {
        PlayerBase attacker;

        // Check if the source of the hit is another player (PvP)
        if (Class.CastTo(attacker, source))
        {
            if (attacker != this) // Ensure it's not self-inflicted
            {
                // Block PvP damage
                Print("PvP damage blocked between " + GetIdentity().GetName() + " and " + attacker.GetIdentity().GetName());

                // Set health back to current value to nullify damage
                SetHealth(GetHealth());
                return;
            }
        }

        // Allow normal damage from AI or environment
        super.EEHitBy(source, component, zone, ammo, modelPos, speedCoef);
    }
}

// Create custom mission and custom player
Mission CreateCustomMission(string path)
{
    return new CustomMission();
}
