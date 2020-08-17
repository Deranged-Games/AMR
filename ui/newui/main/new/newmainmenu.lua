NewMainMenu = { 
  size = { 0, 0, 800, 600, }, 
  stylesheet = "HW2StyleSheet", 
  RootElementSettings = { 
    backgroundColor = { 0, 0, 0, 255, },
  }, 
  pixelUVCoords = 1,
  ;{ 
    type = "Frame", 
    position = { 0, 100, }, 
    size = { 800, 400, }, 
    BackgroundGraphic = { 
      size = { 800, 400, }, 
      texture = "DATA:UI/NewUI/Background/load_background.mres", 
      textureUV = { 0, 56, 800, 455, },
    }, 
  },{ 
    type = "Frame", 
    autosize = 1, 
    backgroundColor = "FEColorBackground1", 
    position = { 511, 164, }, 
    autoarrange = 1, 
    autoarrangeWidth = 304, 
    autoarrangeSpace = 0, 
    maxSize ={ 273, 500, },
    ;{ 
      type = "Frame", 
      size = { 304, 2, }, 
    },{ 
      type = "TextLabel", 
      size = { 304, 13, }, 
      Text = { 
        textStyle = "FEHeading3", 
        text = "Main Menu", 
        offset = { 8, 0, },
      }, 
    },{ 
      type = "Frame", 
      size = { 304, 2, }, 
    },{ 
      type = "TextLabel", 
      name = "m_lblSubTitle", 
      size = { 304, 10, }, 
      Text = { 
        textStyle = "FEHeading4", 
        text = "$2618",
        offset = { 8, 0, },
      }, 
    },{ 
      type = "Frame", 
      size = { 304, 4, }, 
    },{ 
      type = "Frame", 
      size = { 4, 50, }, 
    },{ 
      type = "Frame", 
      outerBorderWidth = 2, 
      borderColor = "FEColorOutline", 
      autosize = 1, 
      autoarrange = 1, 
      autoarrangeSpace = 2, 
      autoarrangeWidth = 256,
      ;{ 
        type = "TextButton", 
        buttonStyle = "FEButtonStyle1", 
        text = "TRIALS OF THE 4/87TH", 
        name = "btnTutorial", 
        width = 240, 
      },{ 
        type = "TextButton", 
        buttonStyle = "FEButtonStyle1", 
        text = "$2603", 
        name = "btnCampaign", 
        width = 240, 
      },{
        type = "TextButton", 
        buttonStyle = "FEButtonStyle1", 
        text = "$2604", 
        name = "btnPlayerVsCPU", 
        width = 240, 
      },{ 
        type = "TextButton", 
        buttonStyle = "FEButtonStyle1", 
        text = "$2614", 
        name = "btnMultiplayer", 
        width = 240, 
        onMouseClicked = "UI_ShowScreen('ConnectionType', eTransition);", 
      },{ 
        type = "TextButton", 
        buttonStyle = "FEButtonStyle1", 
        width = 240, 
        enabled = 1, 
        text = "$2605", 
        onMouseClicked = "UI_ShowScreen('PatchScreen', eTransition);", 
      },{ 
        type = "TextButton", 
        buttonStyle = "FEButtonStyle1", 
        text = "$2616", 
        name = "btnProfile", 
        width = 240, 
        onMouseClicked = [[UI_SetNextScreen("UserProfile", "NewMainMenu"); UI_SetPreviousScreen("UserProfile", "NewMainMenu"); UI_ShowScreen("UserProfile", eTransition)]], 
      },{ 
        type = "TextButton", 
        buttonStyle = "FEButtonStyle1", 
        text = "$2607", 
        name = "btnOptions", 
        width = 240, 
        onMouseClicked = [[UI_ShowScreen("FEGameOptions", eTransition)]], 
      },{ 
        type = "TextButton", 
        buttonStyle = "FEButtonStyle1", 
        text = "$2608", 
        name = "btnMovies", 
        width = 240, 
        onMouseClicked = [[UI_ShowScreen("PlayMoviesScreen", eTransition)]], 
      },{ 
        type = "Frame", 
        size = { 296, 15, }, 
      },{ 
        type = "TextButton", 
        buttonStyle = "FEButtonStyle2", 
        text = "Exit", 
        name = "btnExit", 
        width = 240, 
        onMouseClicked = "UI_ExitApp();",
      }, 
    },{ 
      type = "Frame", 
      size = { 300, 4, },
    }, 
  },{ 
    type = "TextListBoxItem", 
    buttonStyle = "FEListBoxItemButtonStyle", 
    name = "m_levelListBoxItem", 
    visible = 0, 
    enabled = 0, 
    Text = { 
      textStyle = "FEListBoxItemTextStyle",
    }, 
  },{ 
    type = "TextLabel", 
    name = "lblVersion", 
    size = { 400, 13, }, 
    position = { (578 + -400), (518 + -56), }, 
    Text = { 
      text = "Advanced Mod: Revived v1.5 (08/14/12)", 
      font = "ButtonFont", 
      hAlign = "Right", 
      vAlign = "Top", 
      color = { 119, 166, 191, 255, }, 
      offset = { -2, 0, },
    },
  }, 
}