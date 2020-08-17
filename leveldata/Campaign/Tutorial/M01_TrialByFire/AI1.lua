aitrace("CPU: LOADING MISSION 12 PLAYER 1")
dofilepath("data:ai/default.lua")
setLevelOfDifficulty(1)
rawset(globals(), "Logic_military_groupvars", NIL)

function Override_Init()
	sg_dobuild = 1
	sg_doresearch = 1
	sg_domilitary = 1
	cp_processResource = 1
	cp_processMilitary = 1
end

function Override_ResourceInit()
	cpMaxThreatAddedDistance = 6000
	cpMinThreatAddedDistance = 12000
	SetResourceDockFamily("Utility")
	sg_minNumCollectors = 0
	sg_maxNumCollectors = 0
	sg_refineryMilitaryLimit = 10000000
	sg_collectorMinForRefinery = 10000000
end

function Logic_military_groupvars()
	cp_minSquadGroupSize = 3
	cp_minSquadGroupValue = 300
end

function Override_ShipDemand()
	DetermineCounterDemand()
	ShipDemandAddByClass(eFighter, 4)
	ShipDemandAddByClass(eCorvette, 4)
	ShipDemandAddByClass(eFrigate, 4)
	ShipDemandAddByClass(eCapital, -100)
	ShipDemandAddByClass(eBuilder, -100)
end
