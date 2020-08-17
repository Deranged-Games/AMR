AttackStyleName = DogFight
Data = {
  howToBreakFormation = StraightAndScatter,
  minSpeedFraction = 1.6,
  maxBreakDistance = 400,
  distanceFromTargetToBreak = 250,
  RandomActions = {
    {
      Type = PickNewTarget,
      Weighting = 1,
    },
    {
      Type = NoAction,
      Weighting = 19,
    },
  },
  BeingAttackedActions = {
    {
      Type = NoAction,
      Weighting = 20,
    },
    {
      Type = PickNewTarget,
      Weighting = 8,
    },
    {
      Type = FlightManeuver,
      Weighting = 3,
      FlightManeuverName = "JinkLeftAndBack",
    },
    {
      Type = FlightManeuver,
      Weighting = 3,
      FlightManeuverName = "JinkRightAndBack",
    },
    {
      Type = FlightManeuver,
      Weighting = 2,
      FlightManeuverName = "NinetyDegRightTurn",
    },
    {
      Type = FlightManeuver,
      Weighting = 2,
      FlightManeuverName = "NinetyDegLeftTurn",
    },
    {
      Type = FlightManeuver,
      Weighting = 3,
      FlightManeuverName = "ImmelMann",
    },
    {
      Type = FlightManeuver,
      Weighting = 1,
      FlightManeuverName = "Split_S",
    },
  },
  FiringActions = {
    {
      Type = NoAction,
      Weighting = 25,
    },
    {
      Type = FlightManeuver,
      Weighting = 3,
      FlightManeuverName = "RollCW",
    },
    {
      Type = FlightManeuver,
      Weighting = 3,
      FlightManeuverName = "RollCCW",
    },
  },
}