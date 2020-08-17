dofilepath("data:scripts/SCAR/SCAR_Util.lua")
obj_prim_planetkiller = "$47000"
obj_prim_planetkiller_id = 0
obj_prim_destroyvaygr = "$47001"
obj_prim_destroyvaygr_id = 0
obj_prim_protecthiigara = "$47002"
obj_prim_protecthiigara_id = 0
ping_planet_killer = "$47340"
ping_planet_killer_id = 0
ping_pkiller_missile = "$47341"
ping_pkiller_missile_id = 0
ping_vaygr_forces = "$47342"
ping_vaygr_forces_id = 0
g_planet_killer_timer_interval = 180
g_hiigara_count = 0
g_hiigara_population = 180
g_sobgroups_in_volume = ""
g_sobgroups_in_accelerate_volume = ""
g_launchspeechid = 47220
g_pointer_default_1 = 0
g_pointer_default_2 = 0
g_pointer_default_3 = 0
g_pkillersdestroyed = 0
g_beginentry = 0
g_save_id = 0
missilesAccelerated = {0, 0, 0, 0, 0, 0}

function testit()
  playBgLightAnim("super_beam_background_ring")
end

function OnInit()
  Rule_Add("Rule_Init")
  Preload_Ship("Vgr_PlanetKiller")
  Preload_Ship("Kpr_Sajuuk")
  Camera_UseCameraPoint("camera_openingShot")
end

function Rule_PlaySaveGameLocationCard()
  Subtitle_Message("$3651", 3)
  Rule_Remove("Rule_PlaySaveGameLocationCard")
end

function Rule_Init()
  SobGroup_Create("tempSobGroup")
  Rule_AddInterval("Rule_DisableBuilderInterval", 20)
  HW2_SetResearchLevel(15)
  DisableHigFleet();
  Sound_SpeechSubtitlePath("speech:missions/m_15/")
  Sound_MusicPlayType("data:sound/music/battle/battle_01", MUS_Ambient)
  SetupPlayer_1();
  SetupPlayer_2();
  SetupPlayer_3();
  SetupPlayer_4();
  SetupPlayer_5();
  Rule_Add("Rule_PlayerDestroyedVaygr")
  Rule_Add("Rule_PlayerWins")
  Event_Start("intelevent_enemyfleetsdetected")
  Rule_Add("Rule_HyperspaceInFleet")
  Player_SetPlayerName(0, "$47006")
  Rule_Add("Rule_GrantAIResearch")
  Rule_Remove("Rule_Init")
  Sound_EnableAllSpeech(0)
  Rule_Add("Rule_PlaySaveGameLocationCard")
  Rule_AddInterval("Rule_SaveTheGameMissionStart", 1)
end

function Rule_GrantAIResearch()
   for AINum = 1, 3 do
	Player_GrantResearchOption(AINum, "CorvetteTech")
	Player_GrantResearchOption(AINum, "FrigateTech")
	Player_GrantResearchOption(AINum, "PlasmaBombs")
	Player_GrantResearchOption(AINum, "LanceBeams")
	Player_GrantResearchOption(AINum, "MFmissiles")
	Player_GrantResearchOption(AINum, "heavyfighterchassis")
	Player_GrantResearchOption(AINum, "fighterlasers")
	Player_GrantResearchOption(AINum, "fightersystems")
	Player_GrantResearchOption(AINum, "strikemissiles")
	Player_GrantResearchOption(AINum, "CorvetteCommand")
	Player_GrantResearchOption(AINum, "CorvetteLaser")
	Player_GrantResearchOption(AINum, "microlanceturret")
	Player_GrantResearchOption(AINum, "FrigateInfiltrationTech")
	Player_GrantResearchOption(AINum, "CrusaderFrigateResearch")
	Player_GrantResearchOption(AINum, "StealthTorpedoResearch")
	Player_GrantResearchOption(AINum, "railgunsystems")
	Player_GrantResearchOption(AINum, "rapiermissilesystem")
	Player_GrantResearchOption(AINum, "DestroyerGuns")
	Player_GrantResearchOption(AINum, "BattleshipEngines")
	Player_GrantResearchOption(AINum, "heavydestroyerchassis")
	Player_GrantResearchOption(AINum, "IonCruiserChassis")
	Player_GrantResearchOption(AINum, "PlatformHeavyMissiles")
	Player_GrantResearchOption(AINum, "HyperspaceGateTech")
	Player_GrantResearchOption(AINum, "RepairAbility")
	Player_GrantResearchOption(AINum, "ScoutEMPAbility")
	Player_GrantResearchOption(AINum, "BomberImprovedBombs")
   end
   Rule_Remove("Rule_GrantAIResearch")
end

function Rule_DisableBuilderInterval()
  HW2_DisableBuilderOnCapture("tempSobGroup")
end

function DisableHigFleet()
  SobGroup_TakeDamage("Hiigaran_Debris", 0.6)
  SobGroup_FillBattleScar("Hiigaran_Debris", "Plasma_Bomb/Plasma_Bomb")
end

function Rule_SaveTheGameMissionStart()
  Rule_Remove("Rule_SaveTheGameMissionStart")
  g_save_id = (g_save_id + 1)
  Campaign_QuickSaveNb(g_save_id, "$6460")
end

function Rule_HyperspaceInFleet()
  if (g_beginentry == 1) then
    SobGroup_LoadPersistantData("Kpr_Sajuuk")
    Sajuuk = "Sajuuk"
    SobGroup_Create(Sajuuk)
    SobGroup_FillShipsByType(Sajuuk, "Player_Ships0", "Kpr_Sajuuk")
    ShipToParadeRoundTypeName = "Kpr_Sajuuk"
    Rule_AddInterval("Rule_PlayNIS", g_planet_killer_timer_interval)
    Rule_Add("Rule_PlayerLoses")
    Rule_Remove("Rule_HyperspaceInFleet")
  end
end

AvailableStrikeGroups = {"movers", "wall", "tortoise", "inverted leaping goose"}

function SetupPlayer_1()
  SetAlliance(1, 2)
  SetAlliance(1, 3)
  SetAlliance(1, 4)
  Player_SetPlayerName(1, "$47007")
  Player_SetRU(1, 10000)
  Player_SetDefaultShipTactic(1, AggressiveTactics)
  CPU_RemoveSobGroup(1, "Debris_Attackers")
  SobGroup_CreateSubSystem("VF1_Carrier1", "FighterProduction")
  SobGroup_CreateSubSystem("VF1_Carrier2", "FighterProduction")
  SobGroup_FormStrikeGroup("VF1_Fighter_Attack_1", AvailableStrikeGroups[3])
  SobGroup_FormStrikeGroup("VF1_Fighter_Attack_2", AvailableStrikeGroups[3])
  CPU_RemoveSobGroup(1, "VF1_Fighter_Attack_1")
  CPU_RemoveSobGroup(1, "VF1_Fighter_Attack_2")
end

function SetupPlayer_2()
  SetAlliance(2, 1)
  SetAlliance(2, 3)
  SetAlliance(2, 4)
  Player_SetPlayerName(2, "$47007")
  Player_SetRU(2, 10000)
  Player_SetDefaultShipTactic(2, AggressiveTactics)
  SobGroup_FormStrikeGroup("VF2_Major_Attack_1", AvailableStrikeGroups[2])
  HW2_InitializeBuilder("VF2_Shipyard", "tempSobGroup")
  CPU_RemoveSobGroup(2, "VF2_Major_Attack_1")
end

function SetupPlayer_3()
  SetAlliance(3, 1)
  SetAlliance(3, 2)
  SetAlliance(3, 4)
  Player_SetPlayerName(3, "$47007")
  Player_SetRU(3, 10000)
  Player_SetDefaultShipTactic(3, AggressiveTactics)
  SobGroup_FormStrikeGroup("VF3_Major_Attack_1", AvailableStrikeGroups[2])
  HW2_InitializeBuilder("VF3_Shipyard", "tempSobGroup")
  CPU_RemoveSobGroup(3, "VF3_Major_Attack_1")
end

function SetupPlayer_4()
  SetAlliance(4, 1)
  SetAlliance(4, 2)
  SetAlliance(4, 3)
  print("setup player 4")
  Player_SetPlayerName(4, "$47007")
  Player_SetDefaultShipTactic(4, AggressiveTactics)
end

function SetupPlayer_5()
  Player_SetPlayerName(5, "$47006")
  Player_SetRU(5, 20000)
  SetAlliance(0, 5)
  SetAlliance(5, 0)
  Player_SetDefaultShipTactic(4, AggressiveTactics)
  SobGroup_CreateSubSystem("Carrier_187th", "Hgn_C_Production_Fighter")
  SobGroup_CreateSubSystem("Carrier_187th", "Hgn_C_Production_Corvette")
  SobGroup_CreateSubSystem("Carrier_187th", "Hgn_C_Production_Frigate")
  SobGroup_CreateSubSystem("Carrier_187th", "Hgn_C_Module_Research")
  SobGroup_CreateSubSystem("Carrier_187th", "Hgn_C_Module_Hyperspace")
  SobGroup_CreateSubSystem("Carrier_187th", "Hgn_C_Sensors_AdvancedArray")
  SobGroup_CreateSubSystem("Carrier_187th", "Hgn_bpd_pulsar")
  SobGroup_CreateSubSystem("Carrier_187th", "Hgn_bpd_pulsar2")
  SobGroup_CreateSubSystem("SupplementaryCarrier", "Hgn_LC_Production_Fighter")
  SobGroup_CreateSubSystem("SupplementaryCarrier", "Hgn_LC_Production_Corvette")
  SobGroup_CreateSubSystem("SupplementaryCarrier", "Hgn_LC_Module_Hyperspace")
  SobGroup_CreateSubSystem("SupplementaryCarrier", "Hgn_LC_Sensors_AdvancedArray")
  SobGroup_CreateSubSystem("Battlecruiser_Center", "hgn_bc_tubes")
  SobGroup_CreateSubSystem("Battlecruiser_Center", "hgn_bc_PDSArray")
  Player_GrantResearchOption(5, "OverclockedFrigatePower")
  Player_GrantResearchOption(5, "AttackBomberImprovedBombs")
  Player_GrantResearchOption(5, "DefenseFieldFrigateShield")
  Player_GrantResearchOption(5, "InstaAdvancedFrigateTech")
  Player_GrantResearchOption(5, "InstaAdvancedFighterTech")
  Player_GrantResearchOption(5, "InstaAdvancedFighterTech2")
end

function Rule_PlayNIS()
  Event_Start("speechevent_incoming")
  Rule_Add("Rule_NowPlayNIS")
  Rule_Remove("Rule_PlayNIS")
end

function Rule_NowPlayNIS()
  if (Event_IsDone("speechevent_incoming") == 1) then
    SobGroup_SetInvulnerability("Player_Ships0", 1)
    SobGroup_SetInvulnerability("Player_Ships1", 1)
    SobGroup_SetInvulnerability("Player_Ships2", 1)
    SobGroup_SetInvulnerability("Player_Ships3", 1)
    SobGroup_SetInvulnerability("Player_Ships4", 1)
    SobGroup_SetInvulnerability("Player_Ships5", 1)
    NISLoad("nis/NIS15")
    Sensors_EnableCameraZoom(0)
    Sensors_Toggle(0)
    Sensors_EnableToggle(0)
    g_currentNISPlaying_id = NISPlay("nis/NIS15")
    Rule_Add("Rule_NISCompleted")
    Rule_Remove("Rule_NowPlayNIS")
  end
end

function Rule_NISCompleted()
  if (NISComplete(g_currentNISPlaying_id) == 1) then
    Sound_MusicPlayType("data:sound/MUSIC/BATTLE/BATTLE_01", MUS_Battle)
    Sensors_EnableToggle(1)
    Sensors_EnableCameraZoom(1)
    SobGroup_SetInvulnerability("Player_Ships0", 0)
    SobGroup_SetInvulnerability("Player_Ships1", 0)
    SobGroup_SetInvulnerability("Player_Ships2", 0)
    SobGroup_SetInvulnerability("Player_Ships3", 0)
    SobGroup_SetInvulnerability("Player_Ships4", 0)
    SobGroup_SetInvulnerability("Player_Ships5", 0)
    Event_Start("intelevent_planetkillers")
    Rule_Add("Rule_SaveAfterPlanetkillersArrive")
    FOW_RevealGroup("Planet_Killer_1", 1)
    FOW_RevealGroup("Planet_Killer_2", 1)
    FOW_RevealGroup("Planet_Killer_3", 1)
    obj_prim_planetkiller_id = Objective_Add(obj_prim_planetkiller, OT_Primary)
    Objective_AddDescription(obj_prim_planetkiller_id, "$47350")
    Objective_AddDescription(obj_prim_planetkiller_id, "$47354")
    Rule_Add("Rule_PkillerDestroyed")
    SobGroup_Attack(1, "Planet_Killer_1", "Sajuuk")
    SobGroup_Attack(2, "Planet_Killer_2", "Sajuuk")
    SobGroup_Attack(3, "Planet_Killer_3", "Sajuuk")
    Rule_Remove("Rule_NISCompleted")
  end
end

function Rule_SaveAfterPlanetkillersArrive()
  if (Event_IsDone("intelevent_planetkillers") == 1) then
    Rule_Remove("Rule_SaveAfterPlanetkillersArrive")
    Rule_Add("Rule_PlaySaveGameLocationCard")
    Rule_AddInterval("Rule_SaveTheGamePlanetKillersArrive", 1)
  end
end

function Rule_SaveTheGamePlanetKillersArrive()
  Rule_Remove("Rule_SaveTheGamePlanetKillersArrive")
  g_save_id = (g_save_id + 1)
  Campaign_QuickSaveNb(g_save_id, "$6461")
end

g_pkillerstate = {1, 1, 1}

function Rule_PkillerDestroyed()
  for i = 1, 3 do
    if (SobGroup_Empty("Planet_Killer_"..i) == 1 and g_pkillerstate[i] == 1) then
      print("SCAR: Planet Killer"..i.." destroyed")
      g_pkillerstate[i] = 0
      g_pkillersdestroyed = (g_pkillersdestroyed + 1)
      if (g_pkillersdestroyed == 1) then
        Event_Start("speechevent_firstplanetkillerdestroyed")
      elseif (g_pkillersdestroyed == 2) then
        Event_Start("speechevent_secondplanetkillerdestroyed")
      elseif (g_pkillersdestroyed == 3) then
        Objective_SetState(obj_prim_planetkiller_id, OS_Complete)
        Rule_Remove("Rule_PkillerDestroyed")
      end
    end
  end
end

function Rule_PlayerDestroyedVaygr()
  if (SobGroup_AreAnyOfTheseTypes("Player_Ships1", "Vgr_ShipYard, Vgr_Carrier") == 0) then
    if (SobGroup_AreAnyOfTheseTypes("Player_Ships2", "Vgr_ShipYard, Vgr_Carrier") == 0) then
      if (SobGroup_AreAnyOfTheseTypes("Player_Ships3", "Vgr_ShipYard, Vgr_Carrier") == 0) then
        Objective_SetState(obj_prim_destroyvaygr_id, OS_Complete)
        Rule_Remove("Rule_PlayerDestroyedVaygr")
      end
    end
  end
end

function Rule_Vaygr_Carriers_Destroyed()
  if (SobGroup_AreAnyOfTheseTypes("Player_Ships2", "Vgr_Carrier") == 0) then
    Objective_SetState(obj_prim_destroyvaygr_id, OS_Complete)
    Rule_Remove("Rule_Vaygr_Carriers_Destroyed")
  end
end

function Rule_PlayerLoses()
  if (SobGroup_Empty(Sajuuk) == 1) then
    Event_Start("speechevent_playerloses")
    Rule_Remove("Rule_PlayerLoses")
  end
end

function Rule_PlayerWins()
  if (Objective_GetState(obj_prim_planetkiller_id) == OS_Complete) then
    Event_Start("speechevent_victoryisours")
    VaygrFlee();
    Rule_Remove("Rule_PlayerWins")
  end
end

function VaygrFlee()
  vaygrShipList = {{"Vgr_Scout", 2}, {"Vgr_Interceptor", 2}, {"Vgr_MultiroleFighter", 2}, {"Vgr_HeavyFighter", 2}, {"Vgr_LanceFighter", 2}, {"Vgr_Defender", 2}, {"Vgr_Bomber", 2}, {"Vgr_HeavyBomber", 2}, {"Vgr_MissileCorvette", 0}, {"Vgr_LaserCorvette", 0}, {"Vgr_MultilanceCorvette", 0}, {"Vgr_TrinityCorvette", 0}, {"Vgr_MinelayerCorvette", 0}, {"Vgr_CommandCorvette", 0}, {"Vgr_AssaultFrigate", 1}, {"Vgr_GunFrigate", 1}, {"Vgr_HeavyMissileFrigate", 1}, {"Vgr_ArtilleryFrigate", 1}, {"Vgr_CrusaderFrigate", 1}, {"Vgr_WarFrigate", 1}, {"Vgr_WarFrigate2", 1}, {"Vgr_Battleship", 1}, {"Vgr_Destroyer", 1}, {"Vgr_HeavyDestroyer", 1}, {"Vgr_Cruiser", 1}, {"Vgr_LightCruiser", 1}, {"Vgr_ArtilleryCruiser", 1},{"Vgr_BattleCruiser", 1}, {"Vgr_HeavyCruiser", 1},  {"Vgr_Carrier", 1}, {"Vgr_ShipYard", 1}, {"Vgr_ResourceCollector", 0}, {"Vgr_ResourceController", 0},}
  for i = 1, getn(vaygrShipList) do
    for j = 1, 3 do
      SobGroup_FillShipsByType("tempSobGroup", "Player_Ships"..j, vaygrShipList[i][1])
      if (SobGroup_Empty("tempSobGroup") == 0) then
        if (vaygrShipList[i][2] == 0) then
          SobGroup_TakeDamage("tempSobGroup", 1)
        elseif (vaygrShipList[i][2] == 1) then
          SobGroup_EnterHyperSpaceOffMap("tempSobGroup")
        elseif (vaygrShipList[i][2] == 2) then
          SobGroup_Kamikaze("tempSobGroup", "Player_Ships0")
        end
      end
    end
  end 
end

Events = {}
Events["intelevent_enemyfleetsdetected"] = {{{"Sound_EnableAllSpeech(1)", ""}, {"Universe_EnableSkip(1)", ""}, {"Camera_UseCameraPoint('camera_openingShot')", ""}, {"Sound_EnterIntelEvent()", ""}, {"Sound_SetMuteActor('Fleet')", ""}, HW2_Wait(1)}, {HW2_LocationCardEvent("$47004", 5)}, {HW2_Letterbox(1), HW2_Wait(2)}, {HW2_SubTitleEvent(Actor_AllShips, "$47230", 5)}, {HW2_Wait(1)}, {HW2_SubTitleEvent(Actor_AllShips, "$47231", 5)}, {HW2_Wait(5)}, {{"g_beginentry = 1", ""}, HW2_Wait(2)}, {{"Camera_Interpolate('here', 'camera_focusOnStart', 0)", ""}, HW2_Wait(12)}, {HW2_SubTitleEvent(Actor_FleetCommand, "$47134", 5)}, {HW2_Wait(1)}, {HW2_SubTitleEvent(Actor_FleetCommand, "$47011", 5)}, {HW2_Wait(1)}, {HW2_SubTitleEvent(Actor_FleetCommand, "$47012", 3)}, {{"Sensors_Toggle(1)", ""}, HW2_Wait(2)}, {{"Camera_Interpolate('here', 'camera_showVaygrInIntro', 3)", ""}, {"ping_vaygr_forces_id = HW2_PingCreateWithLabel(ping_vaygr_forces, 'Vaygr_Force_1')", ""}, {"Ping_AddDescription(ping_vaygr_forces_id, 0, '$47345')", ""}, {"ping_vaygr_forces_id = HW2_PingCreateWithLabel(ping_vaygr_forces, 'Vaygr_Force_2')", ""}, {"Ping_AddDescription(ping_vaygr_forces_id, 0, '$47345')", ""}, {"ping_vaygr_forces_id = HW2_PingCreateWithLabel(ping_vaygr_forces, 'Vaygr_Force_3')", ""}, {"Ping_AddDescription(ping_vaygr_forces_id, 0, '$47345')", ""}, {"g_pointer_default_1 = HW2_CreateEventPointerSobGroup('Vaygr_Force_1')", ""}, {"g_pointer_default_2 = HW2_CreateEventPointerSobGroup('Vaygr_Force_2')", ""}, {"g_pointer_default_3 = HW2_CreateEventPointerSobGroup('Vaygr_Force_3')", ""}, HW2_SubTitleEvent(Actor_FleetIntel, "$47013", 7)}, {HW2_Wait(1)}, {HW2_SubTitleEvent(Actor_FleetIntel, "$47015", 3)}, {HW2_Wait(1)}, {{"obj_prim_destroyvaygr_id = Objective_Add(obj_prim_destroyvaygr , OT_Primary)", ""}, {"Objective_AddDescription(obj_prim_destroyvaygr_id, '$47351')", ""}, HW2_SubTitleEvent(Actor_FleetIntel, "$47014", 4)}, {{"EventPointer_Remove(g_pointer_default_1)", ""}, {"EventPointer_Remove(g_pointer_default_2)", ""}, {"EventPointer_Remove(g_pointer_default_3)", ""}, {"Camera_Interpolate('here', 'camera_returntoFleet', 2)", ""}, HW2_Wait(2)}, {{"Sensors_Toggle(0)", ""}, {"Timer_Resume(0)", ""}, {"Sound_ExitIntelEvent()", ""}, {"Sound_SetMuteActor('')", ""}, {"Camera_SetLetterboxStateNoUI(0, 2)", ""}, HW2_Wait(2), {"Universe_EnableSkip(0)", ""},},}
Events["intelevent_planetkillers"] = {{{"Universe_EnableSkip(1)", ""}, {"Sound_EnterIntelEvent()", ""}, {"Sound_SetMuteActor('Fleet')", ""}, HW2_Pause(1), HW2_Letterbox(1), {"Sensors_Toggle(1)", ""}, HW2_Wait(2), {"Sound_MusicPlayType('data:sound/MUSIC/BATTLE/BATTLE_01', MUS_Battle)", ""},}, {{"ping_planet_killer_id = HW2_PingCreateWithLabel(ping_planet_killer, 'Planet_Killer_1')", ""}, {"ping_planet_killer_id = HW2_PingCreateWithLabel(ping_planet_killer, 'Planet_Killer_2')", ""}, {"ping_planet_killer_id = HW2_PingCreateWithLabel(ping_planet_killer, 'Planet_Killer_3')", ""}, {"Ping_AddDescription(ping_planet_killer_id, 0, '$47343')", ""}, HW2_SubTitleEvent(Actor_FleetIntel, "$47020", 5)}, {HW2_Wait(1)}, {HW2_SubTitleEvent(Actor_FleetIntel, "$47201", 5)}, {HW2_SubTitleEvent(Actor_FleetIntel, "$47202", 5)}, {{"Universe_EnableSkip(0)", ""}, {"Sensors_Toggle(0)", ""}, {"Sound_ExitIntelEvent()", ""}, {"Sound_SetMuteActor('')", ""}, HW2_Letterbox(0), HW2_Pause(0), HW2_Wait(4)},}
Events["intelevent_pkillerpoweringup"] = {{{"Sound_EnterIntelEvent()", ""}, {"Sound_SetMuteActor('Fleet')", ""}, HW2_Wait(1)}, {HW2_SubTitleEvent(Actor_FleetIntel, "$"..g_launchspeechid, 5)}, {{"Sound_ExitIntelEvent()", ""}, {"Sound_SetMuteActor('')", ""},},}
Events["speechevent_incoming"] = {{{"Sound_EnterIntelEvent()", ""}, {"Sound_SetMuteActor('Fleet')", ""}, HW2_Wait(1)}, {HW2_SubTitleEvent(Actor_FleetIntel, "$47022", 5)},}
Events["speechevent_firstplanetkillerdestroyed"] = {{{"Sound_EnterIntelEvent()", ""}, {"Sound_SetMuteActor('Fleet')", ""}, HW2_Wait(1)}, {HW2_SubTitleEvent(Actor_FleetIntel, "$47110", 5)}, {{"Sound_ExitIntelEvent()", ""}, {"Sound_SetMuteActor('')", ""},},}
Events["speechevent_secondplanetkillerdestroyed"] = {{{"Sound_EnterIntelEvent()", ""}, {"Sound_SetMuteActor('Fleet')", ""}, HW2_Wait(1)}, {HW2_SubTitleEvent(Actor_FleetIntel, "$47120", 5)}, {{"Sound_ExitIntelEvent()", ""}, {"Sound_SetMuteActor('')", ""},},}
Events["speechevent_victoryisours"] = {{HW2_Wait(7)}, {{"Universe_AllowPlayerOrders(0)", ""}, {"Universe_EnableSkip(1)", ""}, {"Sound_EnterIntelEvent()", ""}, {"Sound_SetMuteActor('Fleet')", ""}, {"SobGroup_SetTactics('Player_Ships0', PassiveTactics)", ""}, HW2_Wait(1), HW2_Letterbox(1)}, {{"Camera_FocusSobGroupWithBuffer(Sajuuk, 1000, 1000, 3)", ""}, HW2_SubTitleEvent(Actor_FleetIntel, "$47130", 5)}, {HW2_Wait(2)}, {HW2_SubTitleEvent(Actor_FleetIntel, "$47131", 5)}, {HW2_Wait(1)}, {HW2_SubTitleEvent(Actor_FleetCommand, "$47133", 5)}, {HW2_Wait(2)}, {{"Universe_Fade(1, 2)", ""}, HW2_Wait(3)}, {HW2_LocationCardEvent("$47360", 4)}, {HW2_Wait(2)}, {{"setMissionComplete(1)", ""},},}
Events["speechevent_playerloses"] = {{{"Sound_EnterIntelEvent()", ""}, {"Sound_SetMuteActor('Fleet')", ""}, {"Subtitle_TimeCounterEnd()", ""}, HW2_Pause(1), HW2_Letterbox(1), HW2_Fade(1), HW2_Wait(2)}, {HW2_LocationCardEvent("$47005", 4)}, {{"setMissionComplete(0)", ""}, {"Sound_ExitIntelEvent()", ""}, {"Sound_SetMuteActor('')", ""},},}
