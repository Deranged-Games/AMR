GUID = {218, 133, 165, 204, 182, 239, 184, 193, 157, 20, 231, 124, 48, 169, 31, 97}

GameRulesName = "DM: RU Injections"
Description = "Deatchmatch with Resource Unit Injections."

GameSetupOptions = {
  {
    name = "resources",
    locName = "$3240",
    tooltip = "$3239",
    default = 1,
    visible = 1,
    choices = {
      "$3241",
      "0.5",
      "$3242",
      "1.0",
      "$3243",
      "2.0",
    },
  },
  {
    name = "unitcaps",
    locName = "$3214",
    tooltip = "$3234",
    default = 1,
    visible = 1,
    choices = {
      "$3215",
      "Small",
      "$3216",
      "Normal",
      "$3217",
      "Large",
      "Unlimited",
      "Unlimited",
    },
  },
  {
    name = "resstart",
    locName = "$3205",
    tooltip = "$3232",
    default = 0,
    visible = 1,
    choices = {
      "$3206",
      "1000",
      "$3207",
      "3000",
      "$3208",
      "10000",
      "$3209",
      "0",
    },
  },
  {
    name = "lockteams",
    locName = "$3220",
    tooltip = "$3235",
    default = 0,
    visible = 1,
    choices = {
      "$3221",
      "yes",
      "$3222",
      "no",
    },
  },
  {
    name = "startlocation",
    locName = "$3225",
    tooltip = "$3237",
    default = 0,
    visible = 1,
    choices = {
      "$3226",
      "random",
      "$3227",
      "fixed",
    },
  },
  {
    name = "ru_injection_time",
    locName = "RU Injection Every",
    tooltip = "CHOOSE THE INTERVAL IN MINUTES BETWEEN RU INJECTIONS",
    default = 0,
    visible = 1,
    choices = {
      "Off",
      "-1",
      "1 Minute",
      "1",
      "5 Minutes",
      "5",
      "10 Minutes",
      "10",
      "15 Minutes",
      "15",
    },
  },
  {
    name = "ru_injection_amount",
    locName = "RU Injection Amount",
    tooltip = "ADJUST THE AMOUNT OF RU GIVEN IN EACH INJECTION",
    default = 1,
    visible = 1,
    choices = {
      "500",
      "500",
      "1000",
      "1000",
      "2000",
      "2000",
      "5000",
      "5000",
      "10000",
      "10000",
    },
  },
}

dofilepath("data:scripts/scar/restrict.lua")

function OnInit()
  MPRestrict()
  Rule_Add("MainRule")
  
  print("Let's see here...")
  local rutime = GetGameSettingAsNumber("ru_injection_time")
  ruamount = GetGameSettingAsNumber("ru_injection_amount")
  print("  RU Injection Time:   " .. rutime)
  print("  RU Injection Amount: " .. ruamount)
  
  if (rutime ~= -1) then
    print("  Since RU Injection isn't off,")
    print("  I am adding a rule to execute every " .. 60 * rutime .. " seconds.")
    Rule_AddInterval("RUInject", 60 * rutime)
  end
end

function RUInject()
  print("RUInject called...")
  local playerIndex = 0
  local playerCount = Universe_PlayerCount()
  
  while playerIndex < playerCount do
    if Player_IsAlive(playerIndex) == 1 then
      if Player_HasShipWithBuildQueue(playerIndex) == 1 then
        local currentru = Player_GetRU(playerIndex)
        Player_SetRU(playerIndex, currentru + ruamount)
      end
    end
    
    playerIndex = playerIndex + 1
  end
end

function MainRule()
  local playerIndex = 0
  local playerCount = Universe_PlayerCount()
  
  while playerIndex < playerCount do
    if Player_IsAlive(playerIndex) == 1 then
      if Player_HasShipWithBuildQueue(playerIndex) == 0 then
        Player_Kill(playerIndex)
      end
    end
    
    playerIndex = playerIndex + 1
  end
  
  local numAlive = 0
  local numEnemies = 0
  local gameOver = 1

  playerIndex = 0

  while playerIndex < playerCount do
    if Player_IsAlive(playerIndex) == 1 then
      local otherPlayerIndex = 0
      
      while otherPlayerIndex < playerCount do
        if AreAllied(playerIndex, otherPlayerIndex) == 0 then
          if Player_IsAlive(otherPlayerIndex) == 1 then
            gameOver = 0
          else
            numEnemies = numEnemies + 1
          end
        end

        otherPlayerIndex = otherPlayerIndex + 1
      end
      
      numAlive = numAlive + 1
    end
    
    playerIndex = playerIndex + 1
  end

  if numEnemies == 0 then
    if numAlive > 0 then
      gameOver = 0
    end
  end

  if gameOver == 1 then
    Rule_Add("waitForEnd")
    Event_Start("endGame")
    Rule_Remove("MainRule")
  end
end

function waitForEnd()
  if Event_IsDone("endGame") then
    setGameOver()
    Rule_Remove("waitForEnd")
  end
end

Events = {
  endGame = {
    {
      {
        "wID = Wait_Start(5)",
        "Wait_End(wID)",
      },
    },
  },
}
