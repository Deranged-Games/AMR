
aitrace("LOADING CPU RESEARCH")

function CpuResearch_Init()

	if (s_race == Race_Hiigaran) then
	
		dofilepath("data:ai/hiigaran_upgrades.lua")
		
		DoUpgradeDemand = DoUpgradeDemand_Hiigaran
		DoResearchTechDemand = DoResearchTechDemand_Hiigaran
	
	else
	
		dofilepath("data:ai/vaygr_upgrades.lua")
		
		DoUpgradeDemand = DoUpgradeDemand_Vaygr
		DoResearchTechDemand = DoResearchTechDemand_Vaygr
	
	end
	
	sg_lastUpgradeTime = gameTime()
	sg_upgradeDelayTime = 180 + Rand(80)
		
	-- this hook allows you to add randomness to the choosing of the best research
	cp_researchDemandRange = 0.5
	if (g_LOD == 1) then
		cp_researchDemandRange = 1
	end
	if (g_LOD == 0) then
		cp_researchDemandRange = 2
	end
	
	if (Override_ResearchInit) then
		Override_ResearchInit()
	end

end

function CpuResearch_DefaultResearchDemandRules()

	local threatlevel = UnderAttackThreat()
	-- if we are threatened
	if (threatlevel > 100) then
		return
	end
	
	-- add demand for each tech research - could add a global 'tech' demand bonus (a personality trait)
	DoResearchTechDemand()
	
	local curGameTime = gameTime()
	local timeSinceLastUpgrade = curGameTime - sg_lastUpgradeTime
	
	local economicValue = 0
	local numCollecting = GetNumCollecting();
	local numRU = GetRU()
	
	if ( (numRU > 2500 and numCollecting > 9) or numRU > 10000) then
		economicValue = 2
	elseif ( (numRU > 1500 and numCollecting > 7) or numRU > 6000) then
		economicValue = 1
	end
	
	-- upgrade every so often - every X seconds OR when we have excess amounts of money
	if (sg_doupgrades == 1 and threatlevel < -20 and s_militaryPop > 7 and economicValue > 0 and 
		(timeSinceLastUpgrade > sg_upgradeDelayTime or economicValue>1)) then
		
		-- add upgrade demand
		DoUpgradeDemand()
		sg_lastUpgradeTime = gameTime();
		
	end

end

function CpuResearch_Process()
	
	--aitrace("*CpuResearch_Process")
	
	-- if we are doing poorly economically or we are under quite a bit of threat then do not research
	if (GetNumCollecting() < sg_minNumCollectors and GetRU() < 2000) then
		return 0
	end
	
	-- if we have no research subsystems we can't research
	if (NumResearchSubSystems() == 0) then
		return 0
	end
	
	-- no need to continue processing research requests if the research system is full
	if (IsResearchBusy()==1) then
		return 0
	end

	-- must reset the reset demand every frame - then recaclulate it based on the current world state
	ResearchDemandClear()
	
	if (Override_ResearchDemand) then
		Override_ResearchDemand()
	else 
		CpuResearch_DefaultResearchDemandRules()
	end
	
	-- choose the research with the highest demand
	local bestResearch = FindHighDemandResearch()
		
	if ( bestResearch ~= 0) then
		Research( bestResearch )
		return 1
	end
	
	return 0
end

function DoResearchTechDemand_Vaygr()

		--
	-- NO RULES YET FOR
	--
	--REPAIRABILITY
	--SCOUTEMPABILITY
	
	if (Util_CheckResearch(HYPERSPACEGATETECH)) then
		local demand = ShipDemandGet(kShipYard)
		if (demand > 0) then
			ResearchDemandSet( HYPERSPACEGATETECH, demand+0.5 )
		end
	end
	
	
	local numShipyards = NumSquadrons(kShipYard) + NumSquadronsQ(kShipYard)
	if (numShipyards > 0 and Util_CheckResearch(BATTLESHIPCHASSIS)) then
		local Demand = ShipDemandGet(VGR_ALKHALID)
		if (Demand > 0) then
			ResearchDemandSet( BATTLESHIPCHASSIS, Demand )
		end
	end

	if (numShipyards > 0 and Util_CheckResearch(BATTLECRUISERIONWEAPONS)) then
		local battleCruiserDemand = ShipDemandGet( kBattleCruiser )
		if (battleCruiserDemand > 0) then
			ResearchDemandSet( BATTLECRUISERIONWEAPONS, battleCruiserDemand )
		end
	end

	if (Util_CheckResearch(CRUISERCHASSIS)) then
		local demand = ShipDemandGet(VGR_LIGHTCRUISER)
		if (demand > 0) then
			ResearchDemandSet( CRUISERCHASSIS, demand )
		end
	end

	if (Util_CheckResearch(IONCRUISERCHASSIS)) then
		local demand = ShipDemandGet(VGR_CRUISER)
		if (demand > 0) then
			ResearchDemandSet( IONCRUISERCHASSIS, demand )
		end
	end
	
	if (Util_CheckResearch(DESTROYERGUNS)) then
		local demand = ShipDemandGet(VGR_DESTROYER)
		if (demand > 0) then
			ResearchDemandSet( DESTROYERGUNS, demand )
		end
	end

	if (Util_CheckResearch(BATTLESHIPENGINES)) then
		local battleshipdemand = ShipDemandGet(VGR_BATTLESHIP)
		if (battleshipdemand > 0) then
			ResearchDemandSet( BATTLESHIPENGINES, battleshipdemand )
		end
	end

	if (Util_CheckResearch(HEAVYDESTROYERCHASSIS)) then
		local demand = ShipDemandGet(VGR_HEAVYDESTROYER)
		if (demand > 0) then
			ResearchDemandSet( HEAVYDESTROYERCHASSIS, demand )
		end
	end

	if (Util_CheckResearch(CRUSADERFRIGATERESEARCH)) then
		local demand = ShipDemandGet(VGR_CRUSADERFRIGATE)
		if (demand > 0) then
			ResearchDemandSet( CRUSADERFRIGATERESEARCH, demand )
		end
	end

	if (Util_CheckResearch(RAILGUNSYSTEMS)) then
		local demand = ShipDemandGet(VGR_ARTILLERYFRIGATE)
		if (demand > 0) then
			ResearchDemandSet( RAILGUNSYSTEMS, demand )
		end
	end

	if (Util_CheckResearch(RAPIERMISSILESYSTEM)) then
		local demand = ShipDemandGet(VGR_WARFRIGATE) + ShipDemandGet(VGR_WARFRIGATE2)
		if (demand > 0) then
			ResearchDemandSet( RAPIERMISSILESYSTEM, demand )
		end
	end
	
	if (Util_CheckResearch(LANCEBEAMS)) then
		local lancedemand = ShipDemandGet(VGR_LANCEFIGHTER)
		if (lancedemand > 0) then
			ResearchDemandSet( LANCEBEAMS, lancedemand + 0.5 ) -- offset because its cheap
		end
	end
	
	
	if (Util_CheckResearch(PLASMABOMBS) ) then
		local bomberdemand = ShipDemandGet( VGR_BOMBER )
		if (bomberdemand > 0) then
			ResearchDemandSet( PLASMABOMBS, bomberdemand+1.0 ) -- offset because its cheap
		end
	end

	if (Util_CheckResearch(STRIKEMISSILES) ) then
		local hbomberdemand = ShipDemandGet( VGR_HEAVYBOMBER )
		if (hbomberdemand > 0) then
			ResearchDemandSet( STRIKEMISSILES, hbomberdemand+1.0 ) -- offset because its cheap
		end
	end

	if (Util_CheckResearch(HEAVYFIGHTERCHASSIS) ) then
		local heavydemand = ShipDemandGet( VGR_HEAVYFIGHTER )
		if (heavydemand > 0) then
			ResearchDemandSet( HEAVYFIGHTERCHASSIS, heavydemand+1.0 ) -- offset because its cheap
		end
	end

	if (Util_CheckResearch(FIGHTERLASERS) ) then
		local strikedemand = ShipDemandGet( VGR_STRIKEFIGHTER )
		if (strikedemand > 0) then
			ResearchDemandSet( FIGHTERLASERS, strikedemand+1.0 ) -- offset because its cheap
		end
	end
	
	
	
	if (Util_CheckResearch(CORVETTELASER)) then
		local laserdemand = (ShipDemandGet(VGR_LASERCORVETTE) + ShipDemandGet(VGR_TRINITYCORVETTE))
		if (laserdemand > 0) then
			ResearchDemandSet( CORVETTELASER, laserdemand )
		end
	end

	if (Util_CheckResearch(MICROLANCETURRET)) then
		local mlcdemand = ShipDemandGet(VGR_MULTILANCECORVETTE)
		if (mlcdemand > 0) then
			ResearchDemandSet( MICROLANCETURRET, mlcdemand )
		end
	end

	if (Util_CheckResearch(MICROTRINITYARRAY)) then
		local htcdemand = ShipDemandGet(VGR_TRINITYCORVETTE)
		if (htcdemand > 0) then
			ResearchDemandSet( MICROTRINITYARRAY, htcdemand )
		end
	end
	
	if (Util_CheckResearch(PLATFORMHEAVYMISSILES)) then
		local demand = ShipDemandGet(VGR_WEAPONPLATFORM_MISSILE)
		if (demand > 0) then
			ResearchDemandSet( PLATFORMHEAVYMISSILES, demand )
		end
	end
	
	if (Util_CheckResearch(BOMBERIMPROVEDBOMBS) ) then
		local numBombers = NumSquadrons( kBomber )
		if (numBombers > 2) then
			ResearchDemandSet( BOMBERIMPROVEDBOMBS, numBombers )
		end
	end
	
	if (Util_CheckResearch(CORVETTETECH) ) then
		local corvdemand = ShipDemandMaxByClass( eCorvette )
		if (corvdemand > 0) then
			ResearchDemandSet( CORVETTETECH, corvdemand+0.5 )
		end
	end
	
	if (Util_CheckResearch(FRIGATETECH) ) then
		local frigdemand = ShipDemandMaxByClass( eFrigate )
		if (frigdemand > 0) then
			ResearchDemandSet( FRIGATETECH, frigdemand+0.5 )
		end
	end
	
	if (s_militaryPop > 15 and GetRU() > 750) then
	
		if (Util_CheckResearch(CORVETTEGRAVITICATTRACTION) ) then
			local mineLayerDemand = ShipDemandGet(VGR_MINELAYERCORVETTE)
			if (mineLayerDemand > 0) then
				ResearchDemandSet( CORVETTEGRAVITICATTRACTION, mineLayerDemand )
			end
		end
		
		if (Util_CheckResearch(CORVETTECOMMAND)) then
			local commanddemand = ShipDemandGet(VGR_COMMANDCORVETTE)
			if (commanddemand > 0) then
				ResearchDemandSet( CORVETTECOMMAND, commanddemand )
			end
		end
		
		if (Util_CheckResearch(FRIGATEINFILTRATIONTECH)) then
			local demand = ShipDemandGet(VGR_INFILTRATORFRIGATE)
			if (demand > 0) then
				ResearchDemandSet( FRIGATEINFILTRATIONTECH, demand )
			end
		end

		if (Util_CheckResearch(STEALTHTORPEDORESEARCH)) then
			local demand = ShipDemandGet(VGR_EMPFRIGATE)
			if (demand > 0) then
				ResearchDemandSet( STEALTHTORPEDORESEARCH, demand )
				ResearchDemandSet( SCOUTEMPABILITY, demand )
			end
		end
	
	end
		
end

-- check to see if research is not done but currently available
function Util_CheckResearch( researchId )
	if (IsResearchDone(researchId) == 0 and 
	    IsResearchAvailable(researchId)==1) then
		return 1
	end
	return nil
end

function DoResearchTechDemand_Hiigaran()

	-- NO RULES YET FOR
	--
	--REPAIRABILITY
	--SCOUTEMPABILITY
	--SCOUTPINGABILITY

	local numShipyards = NumSquadrons(kShipYard) + NumSquadronsQ(kShipYard)
	if (numShipyards > 0 and Util_CheckResearch(BATTLECRUISERIONWEAPONS)) then
		local battlecruiserdemand = ShipDemandGet(HGN_BATTLECRUISER)
		if (battlecruiserdemand > 0) then
			ResearchDemandSet( BATTLECRUISERIONWEAPONS, battlecruiserdemand ) 
		end
	end

	if (numShipyards > 0 and Util_CheckResearch(ASSAULTCARRIERPRODUCTIONFACILITYS)) then
		local cruiserDemand = ShipDemandGet(HGN_CRUISER)
		if (cruiserDemand > 0) then
			ResearchDemandSet( ASSAULTCARRIERPRODUCTIONFACILITYS, cruiserDemand ) -- offset to open up larger research
		end
	end
	
	-- ionturret - needed to build ion turrets so use the same demand value
	if (Util_CheckResearch(PLATFORMIONWEAPONS)) then
		local ionTurretDemand = ShipDemandGet(HGN_IONTURRET)
		if (ionTurretDemand > 0) then
			ResearchDemandSet( PLATFORMIONWEAPONS, ionTurretDemand )
		end
	end
	
	if (Util_CheckResearch(LRDESTROYERTECH) ) then
		-- get the demand for destroyer
		local lrdestroyerDemand = ShipDemandGet(HGN_LRDESTROYER)
		if (lrdestroyerDemand > 0) then
			ResearchDemandSet( LRDESTROYERTECH, lrdestroyerDemand )
		end
	end

	if (Util_CheckResearch(DESTROYERTECH) ) then
		-- get the demand for destroyer
		local destroyerDemand = ShipDemandGet(HGN_DESTROYER)
		if (destroyerDemand > 0) then
			ResearchDemandSet( DESTROYERTECH, destroyerDemand )
		end
	end

	if (Util_CheckResearch(BATTLESHIPTECH) ) then
		-- get the demand for battleship
		local battleshipDemand = ShipDemandGet(HGN_BATTLESHIP)
		if (battleshipDemand > 0) then
			ResearchDemandSet( BATTLESHIPTECH, battleshipDemand )
		end
	end

	if (Util_CheckResearch(OVERCLOCKEDFRIGATEPOWER) ) then
		local plasmaDemand = ShipDemandGet(HGN_PLASMAFRIGATE)
		if (plasmaDemand > 0) then
			ResearchDemandSet( OVERCLOCKEDFRIGATEPOWER, plasmaDemand*2 ) --offset so that the ai will actually want to build these. (they're awesome)
		end
	end
	
	if (Util_CheckResearch(ATTACKBOMBERIMPROVEDBOMBS) ) then
		local numBombers = NumSquadrons( kBomber )
		if (numBombers > 2) then
			ResearchDemandSet( ATTACKBOMBERIMPROVEDBOMBS, numBombers )
		end
	end
	
	if (Util_CheckResearch(IMPROVEDTORPEDO) ) then
		local numTorpedoFrigs = NumSquadrons( HGN_TORPEDOFRIGATE )
		if (numTorpedoFrigs > 2) then
			ResearchDemandSet( IMPROVEDTORPEDO, numTorpedoFrigs )
		end
	end
	
	if (s_militaryPop > 15 and GetRU() > 750) then
		
		if (Util_CheckResearch(EMPRESISTANCERESEARCH) ) then
			local EMPRSDemand = s_militaryStrength
			if (EMPRSDemand > 0) then
				ResearchDemandSet( EMPRESISTANCERESEARCH, EMPRSDemand )
			end
		end

		if (Util_CheckResearch(DEFENSEFIELDFRIGATESHIELD) ) then
			local DFFDemand = ShipDemandGet(HGN_DEFENSEFIELDFRIGATE)
			if (DFFDemand > 0) then
				ResearchDemandSet( DEFENSEFIELDFRIGATESHIELD, DFFDemand )
			end
		end
		
		if (Util_CheckResearch(ECMPROBE) ) then
			local ecmProbeDemand = ShipDemandGet(HGN_ECMPROBE)
			if (ecmProbeDemand>0) then
				ResearchDemandSet( ECMPROBE, ecmProbeDemand )
			end
		end
			
		if (Util_CheckResearch(GRAVITICATTRACTIONMINES) ) then
			local mineLayerDemand = ShipDemandGet(HGN_MINELAYERCORVETTE)
			if (mineLayerDemand > 0) then
				ResearchDemandSet( GRAVITICATTRACTIONMINES, mineLayerDemand )
			end
		end
		
	end


end

function DoUpgradeDemand_Hiigaran()
	
	-- based on the actual count of each ship determine which upgrades to do
	
	-- make sure we are winning before doing some of these upgrades
	if (s_militaryStrength > 10 or g_LOD == 0) then
		
		-- mothership upgrades
		
		-- if underattack (or some random factor - need more intel here)
		inc_upgrade_demand( rt_mothership, 0.5  )
		
		-- also demand for build speed upgrade on the MS
		ResearchDemandAdd( MOTHERSHIPBUILDSPEEDUPGRADE1, 0.5 )
		
		-- hyperspace upgrades - what prereqs ? num carriers, 
		--inc_upgrade_demand( rt_hyperspace, 0.5  )
		
		-- do platforms
		local numPlatforms = numActiveOfClass( s_playerIndex, ePlatform )
		if (numPlatforms > 1) then
			local numGunTurret = NumSquadrons( HGN_GUNTURRET )
			if (numGunTurret > 1) then
				inc_upgrade_demand( rt_platform.gunturret, numGunTurret*1 )
			end
			local numPulsarTurret = NumSquadrons( HGN_PULSARTURRET )
			if (numPulsarTurret > 1) then
				inc_upgrade_demand( rt_platform.pulsarturret, numPulsarTurret*1 )
			end
			local numIonTurret = NumSquadrons( HGN_IONTURRET )
			if (numIonTurret > 1) then
				inc_upgrade_demand( rt_platform.ionturret, numIonTurret*1 )
			end
		end
		
		-- collectors are always around - good to upgrades these (unless playtesters tell us otherwise)
		local numCollectors = NumSquadrons( kCollector )
		if (numCollectors > 0) then
			inc_upgrade_demand( rt_collector, numCollectors*.1 )
		end
		
		local numRefinery = NumSquadrons( kRefinery )
		if (numRefinery > 0) then
			inc_upgrade_demand( rt_refinery, numRefinery*1.5 )
		end
		
		-- carrier
		local numCarrier = NumSquadrons( kCarrier )
		if (numCarrier > 0) then
			inc_upgrade_demand( rt_carrier, numCarrier*1 )
			ResearchDemandAdd( CARRIERBUILDSPEEDUPGRADE1, numCarrier*1.25 )
		end

		-- light carrier
		local numlightCarrier = NumSquadrons( HGN_LIGHTCARRIER )
		if (numlightCarrier > 0) then
			inc_upgrade_demand( rt_lightcarrier, numlightCarrier*1 )
			ResearchDemandAdd( LIGHTCARRIERBUILDSPEEDUPGRADE1, numlightCarrier*1.25 )
		end
		
		-- shipyard
		local numShipYards = NumSquadrons( kShipYard )
		if (numShipYards > 0) then
			inc_upgrade_demand( rt_shipyard, numShipYards*1.5  )
			ResearchDemandAdd( SHIPYARDBUILDSPEEDUPGRADE1, numShipYards*1.75 )
		end
	end
	
	-- do fighter upgrades
	local numFighter = numActiveOfClass( s_playerIndex, eFighter )
	if (numFighter > 1) then
		local numInterceptors = NumSquadrons( kInterceptor )
		if (numInterceptors > 1) then
			inc_upgrade_demand( rt_fighter.interceptor, numInterceptors )
		end
		local numHeavyFighter = NumSquadrons( HGN_HEAVYFIGHTER )
		if (numHeavyFighter > 1) then
			inc_upgrade_demand( rt_fighter.heavyfighter, numHeavyFighter )
		end
		local numstrikeFighter = NumSquadrons( HGN_STRIKEFIGHTER )
		if (numstrikeFighter > 1) then
			inc_upgrade_demand( rt_fighter.strikefighter, numstrikeFighter )
		end
		local numbeamFighter = NumSquadrons( HGN_BEAMFIGHTER )
		if (numbeamFighter > 1) then
			inc_upgrade_demand( rt_fighter.beamfighter, numbeamFighter )
		end
		local numBombers = NumSquadrons( kBomber )
		if (numBombers > 1) then
			inc_upgrade_demand( rt_fighter.bomber, numBombers*1.5 )
		end
		local numHbombers = NumSquadrons( HGN_HEAVYBOMBER )
		if (numHbombers > 1) then
			inc_upgrade_demand( rt_fighter.heavybomber, numHbombers )
		end
	end
	
	-- battlecruiser upgrades
	local numBattleCruiser = NumSquadrons( kBattleCruiser )
	if (numBattleCruiser > 0) then
		inc_upgrade_demand( rt_battlecruiser, numBattleCruiser*2.5  )
	end
	local numLightCruiser = NumSquadrons( HGN_LIGHTCRUISER )
	if (numLightCruiser > 0) then
		inc_upgrade_demand( rt_lightcruiser, numLightCruiser*2  )
	end
	local numcruisers = NumSquadrons( HGN_CRUISER )
	if (numcruisers > 0) then
		inc_upgrade_demand( rt_cruiser, numcruisers*2  )
	end
	
	-- destroyer upgrades
	local numDestroyers = NumSquadrons( kDestroyer )
	if (numDestroyers > 0) then
		inc_upgrade_demand( rt_destroyer, numDestroyers*2  )
	end
	local numBattleships = NumSquadrons( HGN_BATTLESHIP )
	if (numBattleships > 0) then
		inc_upgrade_demand( rt_battleship, numBattleships*2  )
	end
	local numLRDestroyer = NumSquadrons( HGN_LRDESTROYER )
	if (numLRDestroyer > 0) then
		inc_upgrade_demand( rt_lrdestroyer, numLRDestroyer*2  )
	end
	
	-- do corvette upgrades
	local numCorvette = numActiveOfClass( s_playerIndex, eCorvette )
	if (numCorvette > 1) then
		local numAssaultCorvette = NumSquadrons( HGN_ASSAULTCORVETTE )
		if (numAssaultCorvette>2) then
			inc_upgrade_demand( rt_corvette.assault, numAssaultCorvette*1.25 )
		end
		local numPulsarCorvette = NumSquadrons( HGN_PULSARCORVETTE )
		if (numPulsarCorvette>2) then
			inc_upgrade_demand( rt_corvette.pulsar, numPulsarCorvette*1.25 )
		end
		local nummultigun = NumSquadrons( HGN_MULTIGUNCORVETTE )
		if (nummultigun>2) then
			inc_upgrade_demand( rt_corvette.multi, nummultigun*1.25 )
		end
		local numSiegeCorvette = NumSquadrons( HGN_SIEGECORVETTE )
		if (numSiegeCorvette>2) then
			inc_upgrade_demand( rt_corvette.siege, numSiegeCorvette*1.25 )
		end
	end
	
	-- do frigate upgrades
	local numFrigate = numActiveOfClass( s_playerIndex, eFrigate )
	if (numFrigate > 2) then
		local numTorpedoFrigate = NumSquadrons( HGN_TORPEDOFRIGATE )
		if (numTorpedoFrigate>2) then
			inc_upgrade_demand( rt_frigate.torpedo, numTorpedoFrigate*1.5 )
		end
		local numIonFrigate = NumSquadrons( HGN_IONCANNONFRIGATE )
		if (numIonFrigate>2) then
			inc_upgrade_demand( rt_frigate.ioncannon, numIonFrigate*1.5 )
		end
		local numAssaultFrigate = NumSquadrons( HGN_ASSAULTFRIGATE )
		if (numAssaultFrigate>2) then
			inc_upgrade_demand( rt_frigate.assault, numAssaultFrigate*1.5 )
		end
		local numGunFrigate = NumSquadrons( HGN_GUNFRIGATE )
		if (numGunFrigate>2) then
			inc_upgrade_demand( rt_frigate.gun, numGunFrigate*1.5 )
		end
		local numMissileFrigate = NumSquadrons( HGN_MISSILEFRIGATE )
		if (numMissileFrigate>2) then
			inc_upgrade_demand( rt_frigate.missile, numMissileFrigate*1.5 )
		end
		local numPlasmaFrigate = NumSquadrons( HGN_PLASMAFRIGATE )
		if (numPlasmaFrigate>2) then
			inc_upgrade_demand( rt_frigate.plasma, numPlasmaFrigate*1.5 )
		end
	end
	
	
	
end

function DoUpgradeDemand_Vaygr()
	
	-- based on the actual count of each ship determine which upgrades to do
	
	if (s_militaryStrength > 10 or g_LOD == 0) then
	
		-- mothership upgrades
		-- if underattack (or some random factor - need more intel here)
		inc_upgrade_demand( rt_mothership, 0.5 )
		
		-- also demand for build speed upgrade on the MS
		ResearchDemandAdd( MOTHERSHIPBUILDSPEEDUPGRADE1, 0.5 )
		
		-- do corvette upgrades
		local numCorvette = numActiveOfClass( s_playerIndex, eCorvette )
		if (numCorvette > 2) then
			inc_upgrade_demand( rt_corvette, numCorvette )
		end
		
		-- do frigate upgrades
		local numFrigate = numActiveOfClass( s_playerIndex, eFrigate )
		if (numFrigate > 2) then
			inc_upgrade_demand( rt_frigate, numFrigate*1 )
		end
		
		-- do platforms
		local numPlatforms = numActiveOfClass( s_playerIndex, ePlatform )
		if (numPlatforms > 0) then
			inc_upgrade_demand( rt_platform, numPlatforms*1 )
		end
		
		local numCapital = numActiveOfClass( s_playerIndex, eCapital )
		if (numCapital > 1) then
			inc_upgrade_demand( rt_capital, numCapital*0.5 )
		end
		
		-- carrier
		local numCarrier = NumSquadrons( kCarrier )
		if (numCarrier > 0) then
			ResearchDemandAdd( CARRIERBUILDSPEEDUPGRADE1, numCarrier*1.25 )
		end
		
		-- shipyard
		local numShipYards = NumSquadrons( kShipYard )
		if (numShipYards > 0) then
			ResearchDemandAdd( SHIPYARDBUILDSPEEDUPGRADE1, numShipYards*1.75 )
		end
	end
	
end

-- RESEARCH HELPER FUNCTIONS

-- could move this to code if its too slow
function inc_research_demand( researchtype, val)

	local typeis = typeid(researchtype);
	
	-- recursive function that 
	if (typeis == LT_TABLE) then
		for i, v in researchtype do
			inc_research_demand(v, val);
		end
	else
		if (Util_CheckResearch(researchtype)) then
			ResearchDemandAdd( researchtype, val )
		end
	end
end

function inc_upgrade_demand( upgradetype, val )
	inc_research_demand( upgradetype, val )
end


