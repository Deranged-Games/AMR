aitrace("CPU: LOADING MISSION 4 PLAYER 3")
dofilepath("data:ai/default.lua")
setLevelOfDifficulty(2)
rawset(globals(), "Logic_military_groupvars", NIL)

function Override_Init()
	sg_dobuild = 1
	sg_doresearch = 1
	sg_domilitary = 1
	cp_processResource = 1
	cp_processMilitary = 1
end

function Logic_military_groupvars()
	cp_minSquadGroupSize = 2
	cp_minSquadGroupValue = 100
end

function Override_ShipDemand()
	DetermineCounterDemand()
	ShipDemandAddByClass(eFighter, 4)
	ShipDemandAddByClass(eCorvette, 5)
	ShipDemandAddByClass(eFrigate, 5)
	ShipDemandAddByClass(eCapital, -100)
	ShipDemandAddByClass(eBuilder, -100)
	ShipDemandAdd(VGR_COMMANDCORVETTE, -20)
	ShipDemandAdd(VGR_INFILTRATORFRIGATE, -20)
end
