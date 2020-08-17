dofilepath("data:scripts/SCAR/SCAR_Util.lua")
obj_attack = "Destroy the Vaygr Carriers"
obj_attack_id = 0
obj_prep = "Build reaction forces for attack."
obj_prep_id = 0
obj_defend = "Escort the Missile Cruiser."
obj_defend_id = 0
g_startBuildingCarrier = 0
g_startCarriers = 0
g_vaygrArrival_Interval = 180
g_shipyardReinforce_Interval = (14 * 60)
g_carriersDestroyed = 0
g_startedAntiCruiser = 0

g_nextFighterTime = 0
g_nextFighterInterval = 105
g_nextCorvetteTime = 0
g_nextCorvetteInterval = 90
g_nextFrigateTime = 0
g_nextFrigateInterval = 120
g_gametime = 0
g_madeNewReinforcements = 0

function OnInit()
  HW2_RestrictCampaignOptions()
  Rule_Add("Rule_Init")

  SetupPlayer_1()
  SetupPlayer_2()
  SetupPlayer_3()
  Event_Start("intelevent_Intro")
  SetAlliance(0, 1)
  SetAlliance(0, 2)
end

function Rule_Init()
  SobGroup_Create("tempSobGroup")
  SobGroup_Create("Carrier")
  SobGroup_Create("Cruiser")
  SobGroup_Create("CruiserWithinStrike")
  SobGroup_Create("AntiCruiser")
  Rule_Add("Rule_CreateCarrier")
  Rule_Remove("Rule_Init")
end

function SetupPlayer_1()
  SetAlliance(1, 0)
  SetAlliance(1, 2)
  SobGroup_CreateSubSystem("Shipyard", "Hgn_MS_Production_Fighter")
  SobGroup_CreateSubSystem("Shipyard", "Hgn_MS_Production_Corvette")
  SobGroup_CreateSubSystem("Shipyard", "Hgn_MS_Production_Frigate")
  SobGroup_CreateSubSystem("Shipyard", "Hgn_MS_Module_Research")
  SobGroup_CreateSubSystem("Shipyard", "Hgn_MS_Module_ResearchAdvanced")
  SobGroup_CreateSubSystem("Shipyard", "Hgn_MS_Module_PlatformControl")
  SobGroup_CreateSubSystem("Shipyard", "Hgn_SY_Production_CapShip")
  Player_SetPlayerName(1, "Hiigaran Defense Fleet")
  Player_SetRU(1, 50000)
  Player_SetDefaultShipTactic(1, AggressiveTactics)
end
function SetupPlayer_2()
  SetAlliance(2, 0)
  SetAlliance(2, 1)
  Player_SetPlayerName(2, "Mothership Fleet")
  Player_SetRU(2, 0)
end
function SetupPlayer_3()
  Player_SetPlayerName(3, "Vaygr Raiders")
  Player_SetRU(3, 10000)
  Player_SetDefaultShipTactic(3, AggressiveTactics)
  SobGroup_CreateSubSystem("Vgr_Carrier_1", "Vgr_C_Production_Fighter")
  SobGroup_CreateSubSystem("Vgr_Carrier_1", "Vgr_C_Module_Research")
  SobGroup_CreateSubSystem("Vgr_Carrier_1", "vgr_c_sensors_defensesuite")
  SobGroup_CreateSubSystem("Vgr_Carrier_1", "vgr_bpd_flak")
  SobGroup_EnterHyperSpaceOffMap("Vgr_Carrier_1")
  SobGroup_CreateSubSystem("Vgr_Carrier_2", "Vgr_C_Production_Corvette")
  SobGroup_CreateSubSystem("Vgr_Carrier_2", "Vgr_C_Module_Hyperspace")
  SobGroup_CreateSubSystem("Vgr_Carrier_2", "vgr_c_sensors_defensesuite")
  SobGroup_CreateSubSystem("Vgr_Carrier_2", "vgr_bpd_flak")
  SobGroup_EnterHyperSpaceOffMap("Vgr_Carrier_2")
  SobGroup_CreateSubSystem("Vgr_Carrier_3", "Vgr_C_Production_Frigate")
  SobGroup_CreateSubSystem("Vgr_Carrier_3", "Vgr_C_Module_Research")
  SobGroup_CreateSubSystem("Vgr_Carrier_3", "vgr_c_sensors_defensesuite")
  SobGroup_CreateSubSystem("Vgr_Carrier_3", "vgr_bpd_flak")
  SobGroup_EnterHyperSpaceOffMap("Vgr_Carrier_3")
end

function Rule_CreateCarrier()
  if (g_startBuildingCarrier == 1) then
    Hgn_Carrier_Free = SobGroup_CreateShip("Shipyard", "Hgn_Carrier_187")
    SobGroup_SwitchOwner(Hgn_Carrier_Free, 0)

    Rule_Remove("Rule_CreateCarrier")
    Rule_AddInterval("Rule_MakeCollectors", 1)
    Rule_AddInterval("Rule_PlayerLoses",5)
    Rule_AddInterval("Rule_StartVaygrArrive", g_vaygrArrival_Interval)
  end
end

g_collector = {0, 0, 0, 0, 0, 0}
g_collectorSwitched = {2, 2, 2, 2, 2, 2}
function Rule_MakeCollectors()
  Player_FillShipsByType("Carrier", 0, "Hgn_Carrier_187")
  SobGroup_SetTeamColours("Carrier", {0, 0, 0}, {0.9, 0.9, 0.9}, "DATA:Badges/Hiigaran.tga")

  for i = 1, 6 do
    g_collector[i] = SobGroup_CreateShip("Shipyard", "Hgn_ResourceCollector")
  end 
  Rule_Add("SwitchCollectors")
  Rule_Remove("Rule_MakeCollectors")
end
function SwitchCollectors()
  collectorslaunched = 0
  for i = 1, 6 do
    if (SobGroup_IsDockedSobGroup(g_collector[i], "Shipyard") == 0) then
      if (g_collectorSwitched[i] ~= 1) then
        SobGroup_SwitchOwner(g_collector[i], 0)
        g_collectorSwitched[i] = 1
      end
      collectorslaunched = (collectorslaunched + 1)
    end
  end 
  if (collectorslaunched == 6) then
    Rule_Remove("SwitchCollectors")
  end
end

function Rule_StartVaygrArrive()
  Event_Start("intelevent_VaygrArrive")
  Rule_Add("Rule_VaygrArrive")
  Rule_Remove("Rule_StartVaygrArrive")
end
function Rule_VaygrArrive()
  if(g_startCarriers == 1) then
    Objective_SetState(obj_prep_id, OS_Complete)
    SobGroup_ExitHyperSpace("Vgr_Carrier_1", "vol_Vgr_Carrier_1" )
    SobGroup_ExitHyperSpace("Vgr_Carrier_2", "vol_Vgr_Carrier_2" )
    SobGroup_ExitHyperSpace("Vgr_Carrier_3", "vol_Vgr_Carrier_3" )
    FOW_RevealGroup("Vgr_Carrier_1", 1)
    FOW_RevealGroup("Vgr_Carrier_2", 1)
    FOW_RevealGroup("Vgr_Carrier_3", 1)
    Rule_AddInterval("Rule_VaygrCollectors",10)
    Rule_AddInterval("Rule_CarriersDestroyed",5)
    Rule_AddInterval("Rule_CruiserReinforce",g_shipyardReinforce_Interval)
    Rule_Remove("Rule_VaygrArrive")
  end
end
function Rule_VaygrCollectors()
  for i = 1, 4 do
    SobGroup_CreateShip("Vgr_Carrier_1", "Vgr_ResourceCollector")
  end
  for i = 1, 4 do
    SobGroup_CreateShip("Vgr_Carrier_2", "Vgr_ResourceCollector")
  end
  for i = 1, 4 do
    SobGroup_CreateShip("Vgr_Carrier_3", "Vgr_ResourceCollector")
  end
  Rule_Remove("Rule_VaygrCollectors")
end

function Rule_CruiserReinforce()
  Event_Start("intelevent_CruiserLaunched")
  SobGroup_CreateShip("Shipyard", "Hgn_HeavyCruiser")
  Rule_AddInterval("Rule_CruiserController",1)
  Rule_Remove("Rule_CruiserReinforce")
end

g_carrierState = {1, 1, 1}
function Rule_CarriersDestroyed()
  for i = 1, 3 do
    if (SobGroup_Empty("Vgr_Carrier_"..i) == 1 and g_carrierState[i] == 1) then
      g_carrierState[i] = 0
      g_carriersDestroyed = (g_carriersDestroyed + 1)
      if (g_carriersDestroyed == 3) then
        Objective_SetState(obj_attack_id, OS_Complete)
        Rule_Remove("Rule_CarriersDestroyed")
        Rule_Remove("Rule_CruiserController")
        Event_Start("MissionWon")
      end
    end
  end
end

function Rule_CruiserController()
  if(SobGroup_Empty("Cruiser") == 1) then
    Player_FillShipsByType("Cruiser", 1, "Hgn_HeavyCruiser")
    if(SobGroup_Empty("Cruiser") == 1) then
      CPU_AddSobGroup(3, "AntiCruiser")
      Rule_Remove("Rule_CruiserController")
      return
    else
      CPU_RemoveSobGroup(1, "Cruiser")
      SobGroup_Move(1, "Cruiser", "vol_Cruiser_Move")
    end
  end
  if (g_startedAntiCruiser ~= 1) then
    if(SobGroup_Empty("Vgr_Carrier_1") ~= 1) then
      Player_FillProximitySobGroup("tempSobGroup", 1, "Vgr_Carrier_1", 50000)
    elseif(SobGroup_Empty("Vgr_Carrier_2") ~= 1) then
      Player_FillProximitySobGroup("tempSobGroup", 1, "Vgr_Carrier_2", 53000)
    else
      Player_FillProximitySobGroup("tempSobGroup", 1, "Vgr_Carrier_3", 53000)
    end
    SobGroup_FillShipsByType("CruiserWithinStrike", "tempSobGroup", "Hgn_HeavyCruiser")
    if (SobGroup_Count("CruiserWithinStrike") >= 1) then
      g_startedAntiCruiser = 1
      SobGroup_AttackPlayer("Cruiser", 3)
    end
  end
  if (g_startedAntiCruiser == 1) then
    g_gametime = Universe_GameTime()
    if (SobGroup_Empty("Vgr_Carrier_1") ~= 1) then
      if(g_gametime >= g_nextFighterTime) then
        g_nextFighterTime = g_gametime + g_nextFighterInterval
        for i = 1, 2 do
          newships = SobGroup_CreateShip("Vgr_Carrier_1", "Vgr_HeavyBomber")
        end
        newships = SobGroup_CreateShip("Vgr_Carrier_1", "Vgr_MultiroleFighter")
        g_madeNewReinforcements = 1
      end
    end
    if (SobGroup_Empty("Vgr_Carrier_2") ~= 1) then
      if(g_gametime >= g_nextCorvetteTime) then
        g_nextCorvetteTime = g_gametime + g_nextCorvetteInterval
        for i = 1, 2 do
          newships = SobGroup_CreateShip("Vgr_Carrier_2", "Vgr_TrinityCorvette")
        end
        g_madeNewReinforcements = 1
      end
    end
    if (SobGroup_Empty("Vgr_Carrier_3") ~= 1) then
      if(g_gametime >= g_nextFrigateTime) then
        g_nextFrigateTime = g_gametime + g_nextFrigateInterval
        for i = 1, 2 do
          newships = SobGroup_CreateShip("Vgr_Carrier_3", "Vgr_Warfrigate2")
        end
        g_madeNewReinforcements = 1
      end
    end
    if(g_madeNewReinforcements == 1) then
      g_madeNewReinforements = 0
      SobGroup_Clear("AntiCruiser")
      Player_FillShipsByType("tempSobGroup", 3, "Vgr_HeavyBomber")
      SobGroup_SobGroupAdd("AntiCruiser","tempSobGroup")
      Player_FillShipsByType("tempSobGroup", 3, "Vgr_MultiroleFighter")
      SobGroup_SobGroupAdd("AntiCruiser","tempSobGroup")
      Player_FillShipsByType("tempSobGroup", 3, "Vgr_TrinityCorvette")
      SobGroup_SobGroupAdd("AntiCruiser","tempSobGroup")
      Player_FillShipsByType("tempSobGroup", 3, "Vgr_WarFrigate2")
      SobGroup_SobGroupAdd("AntiCruiser","tempSobGroup")

      CPU_RemoveSobGroup(3, "AntiCruiser")
      SobGroup_Attack(3, "AntiCruiser", "Cruiser")
    end
  end
end

function Rule_PlayerLoses()
  if (SobGroup_Empty("Carrier") == 1 or SobGroup_Empty("Shipyard") == 1) then
    Event_Start("speechevent_playerloses")
    Rule_Remove("Rule_PlayerLoses")
  end
end




Events = {}
Events["intelevent_Intro"] = {
  {
    {"Sound_EnableAllSpeech(1)", ""}, 
    {"Universe_EnableSkip(1)", ""}, 
    {"Camera_UseCameraPoint('camera_openingShot')", ""}, 
    {"Sound_EnterIntelEvent()", ""}, 
    {"Sound_SetMuteActor('Fleet')", ""}, 
    HW2_Wait(1)
  },
  {HW2_Letterbox(1), HW2_Wait(1)},  
  {HW2_LocationCardEvent("SARUM - FLEET STAGING AREA", 3)}, 
  {{"SobGroup_EnterHyperSpaceOffMap( 'Player_Ships2' )", ""}, HW2_Wait(6)},
  {{"g_startBuildingCarrier = 1", ""}, HW2_Wait(3)},
  {{"Camera_Interpolate('here', 'camera_focusOnShipyard', 2)", ""}, HW2_Wait(6)}, 
  {
    {"obj_prep_id = Objective_Add(obj_prep , OT_Primary)", ""}, 
    {"Objective_AddDescription(obj_prep_id, 'Prepare for possible Vaygr reinforcements.')", ""}, 
  },
  {
    {"Sound_ExitIntelEvent()", ""}, 
    {"Sound_SetMuteActor('')", ""}, 
    {"Camera_SetLetterboxStateNoUI(0, 2)", ""}, 
    HW2_Wait(2), {"Universe_EnableSkip(0)", ""},
  },
}
Events["intelevent_VaygrArrive"] = {
  {
    {"Sound_EnableAllSpeech(1)", ""}, 
    {"Universe_EnableSkip(1)", ""},  
    {"Sound_EnterIntelEvent()", ""}, 
    {"Sound_SetMuteActor('Fleet')", ""}, 
  },
  {HW2_Letterbox(1)},  
  {{"Camera_Interpolate('here', 'camera_focusOnCarrier', 2)", ""},{"g_startCarriers = 1", ""},HW2_Wait(3)},
  {{"Camera_Interpolate('here', 'camera_focusOnCarrier2', 3)", ""},HW2_Wait(4)},   
  {{"Camera_Interpolate('here', 'camera_focusOnCarrier3', 3)", ""},HW2_Wait(5)}, 
  {
    {"obj_attack_id = Objective_Add(obj_attack , OT_Primary)", ""}, 
    {"Objective_AddDescription(obj_attack_id, 'Destroy the Vaygr carriers.')", ""}, 
  },
  {
    {"Sound_ExitIntelEvent()", ""}, 
    {"Sound_SetMuteActor('')", ""}, 
    {"Camera_SetLetterboxStateNoUI(0, 2)", ""}, 
    HW2_Wait(2), {"Universe_EnableSkip(0)", ""},
  },
}
Events["intelevent_CruiserLaunched"] = {
  {
    {"Sound_EnableAllSpeech(1)", ""}, 
    {"Universe_EnableSkip(1)", ""},  
    {"Sound_EnterIntelEvent()", ""}, 
    {"Sound_SetMuteActor('Fleet')", ""}, 
    HW2_Wait(1)
  },
  {HW2_Letterbox(1),HW2_Wait(1)},  
  {{"Camera_Interpolate('here', 'camera_focusOnCruiser', 2)", ""},HW2_Wait(8)},
  {
    {"obj_defend_id = Objective_Add(obj_defend , OT_Secondary)", ""}, 
    {"Objective_AddDescription(obj_defend_id, 'Escort Missile Cruiser while it destroys the carriers.')", ""}, 
  },
  {
    {"Sound_ExitIntelEvent()", ""}, 
    {"Sound_SetMuteActor('')", ""}, 
    {"Camera_SetLetterboxStateNoUI(0, 2)", ""}, 
    HW2_Wait(2), {"Universe_EnableSkip(0)", ""},
  },
}
Events["speechevent_playerloses"] = {
  {
    {"Sound_EnterIntelEvent()", ""}, 
    {"Sound_SetMuteActor('Fleet')", ""}, 
    {"Subtitle_TimeCounterEnd()", ""}, 
    HW2_Pause(1), 
    HW2_Letterbox(1), 
    HW2_Fade(1), 
    HW2_Wait(2)
  },
  {HW2_LocationCardEvent("MISSION: FAILED", 4)}, 
  {
    {"setMissionComplete(0)", ""}, 
    {"Sound_ExitIntelEvent()", ""}, 
    {"Sound_SetMuteActor('')", ""},
  },
}
Events["MissionWon"] = {
  {
    {"Universe_EnableSkip(1)", ""}, 
    {"Sound_EnterIntelEvent()", ""}, 
    {"Sound_EnableAllSpeech( 1 )", ""}, 
    HW2_Letterbox(1)
  },{{"Camera_FocusSobGroupWithBuffer( 'Carrier', 1, 1000, 1 )", ""}, HW2_Wait(2)}, 
  {{"Universe_AllowPlayerOrders( 0 )", ""}, HW2_Fade(1), HW2_Wait(1)}, 
  {{"Player_InstantlyGatherAllResources( 0 )", ""}, {"Player_InstantDockAndParade( 0, 'Carrier', 0 )", ""}, HW2_Wait(1)}, 
  {{"Subtitle_Message( '$3652', 2 )", ""}, HW2_Wait(2)}, 
  {HW2_Fade(0), HW2_Wait(2)},  
  {{"SobGroup_EnterHyperSpaceOffMap( 'Player_Ships0' )", ""}, HW2_Wait(6)},  
  {{"Universe_Fade( 1, 2 )", ""}, HW2_Wait(2)}, 
  {HW2_LocationCardEvent("MISSION: COMPLETED", 4)}, 
  {{"setMissionComplete( 1 )", ""}, 
  {"Sound_ExitIntelEvent()", ""},},
}