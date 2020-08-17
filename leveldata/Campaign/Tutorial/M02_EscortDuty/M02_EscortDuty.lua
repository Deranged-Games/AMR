dofilepath("data:scripts/SCAR/SCAR_Util.lua")

function OnInit()
  HW2_RestrictCampaignOptions()
  Rule_Add("Rule_Init")
end

function Rule_Init()
  Rule_Remove("Rule_Init")
end