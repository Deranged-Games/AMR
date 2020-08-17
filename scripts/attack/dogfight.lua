AttackStyleName = DogFight
Data = {
  howToBreakFormation = StraightAndScatter,
  minSpeedFraction = 1.6,
  RandomActions = {
    {
      Type = NoAction,
      Weighting = 700,
    },
    {
      Type = PickNewTarget,
      Weighting = 100,
    },
    {
      Type = FlightManeuver,
      Weighting = 1,
      FlightManeuverName = "RollCW",
    },
    {
      Type = FlightManeuver,
      Weighting = 1,
      FlightManeuverName = "RollCCW",
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
    {
      Type = FlightManeuver,
      Weighting = 1,
      FlightManeuverName = "HalfRollCW",
    },
    {
      Type = FlightManeuver,
      Weighting = 1,
      FlightManeuverName = "HalfRollCCW",
    },
   {
      Type = FlightManeuver,
      Weighting = 1,
      FlightManeuverName = "ImmelMann_speedy",
    },
   {
      Type = FlightManeuver,
      Weighting = 1,
      FlightManeuverName = "WingWaggle",
    },
  },
  BeingAttackedActions = {
    {
      Type = NoAction,
      Weighting = 400,
    },
    {
      Type = PickNewTarget,
      Weighting = 200,
    },
    {
      Type = FlightManeuver,
      Weighting = 75,
      FlightManeuverName = "JinkLeft",
    },
    {
      Type = FlightManeuver,
      Weighting = 75,
      FlightManeuverName = "JinkRight",
    },
    {
      Type = FlightManeuver,
      Weighting = 25,
      FlightManeuverName = "JinkLeftAndBack",
    },
    {
      Type = FlightManeuver,
      Weighting = 25,
      FlightManeuverName = "JinkRightAndBack",
    },
    {
      Type = FlightManeuver,
      Weighting = 75,
      FlightManeuverName = "NinetyDegRightTurn",
    },
    {
      Type = FlightManeuver,
      Weighting = 75,
      FlightManeuverName = "NinetyDegLeftTurn",
    },
    {
      Type = FlightManeuver,
      Weighting = 13,
      FlightManeuverName = "CustomBarrelRoll",
    },
    {
      Type = FlightManeuver,
      Weighting = 25,
      FlightManeuverName = "Reversal",
    },
    {
      Type = FlightManeuver,
      Weighting = 12,
      FlightManeuverName = "ImmelMann",
    },
    {
      Type = FlightManeuver,
      Weighting = 12,
      FlightManeuverName = "Split_S",
    },
  },
  FiringActions = {},
}
