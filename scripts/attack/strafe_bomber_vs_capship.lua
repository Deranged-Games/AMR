AttackStyleName = AttackRun
Data = {
  howToBreakFormation = StraightAndScatter,
  maxBreakDistance = 1900,
  distanceFromTargetToBreak = 900,
  safeDistanceFromTargetToDoActions = 1200,
  coordSysToUse = Target,
  horizontalMin = 0.6,
  horizontalMax = 0.9,
  horizontalFlip = 1,
  verticalMin = 0.3,
  verticalMax = 0.7,
  verticalFlip = 1,
  RandomActions = {
    {
      Type = PickNewTarget,
      Weighting = 1,
    },
    {
      Type = NoAction,
      Weighting = 2,
    },
  },
  BeingAttackedActions = {},
  FiringActions = {
    {
      Type = NoAction,
      Weighting = 13,
    },
    {
      Type = FlightManeuver,
      Weighting = 1,
      FlightManeuverName = "RollCW_slow",
    },
    {
      Type = FlightManeuver,
      Weighting = 1,
      FlightManeuverName = "RollCCW_slow",
    },
  },
}
