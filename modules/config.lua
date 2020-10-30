local Config = GiveMeAShot:NewModule('Config')
local L = LibStub('AceLocale-3.0'):GetLocale("GiveMeAShot")
local Util = GiveMeAShot:GetModule('Util')
local Controls = GiveMeAShot:GetModule('Controls')

--------------------------------------------------
-- Locals
--------------------------------------------------


--------------------------------------------------
-- Defaults
--------------------------------------------------
local _defaultConfig = {
  profile = {
    minimapButton = {
      hide = true,
      lock = false,
      minimapPos = 0,
    },
    config = {
      debugMode = false
    }
  },
  char = {
    level = level,
    race = race,
    class = class,
    faction = faction
  }
}


--------------------------------------------------
-- Access methods
--------------------------------------------------
function Config:GetProfile(info)
  if type(info) == 'table' then
    return self.db.profile[info[#info]]
  else
    return self.db.profile[tostring(info)]
  end
end

function Config:SetProfile(info, value)
  if type(info) == 'table' then
    local old = self.db.profile[info[#info]]
    Util:DebugOption(info[#info], value, old)
    self.db.profile[info[#info]] = value
  else
    self.db.profile[tostring(info)] = value
  end
end

function Config:GetChar(info)
  if type(info) == 'table' then
    return self.db.char[info[#info]]
  else
    return self.db.char[tostring(info)]
  end
end

function Config:SetChar(info, value)
  if type(info) == 'table' then
    local old = self.db.char[info[#info]]
    Util:DebugOption(info[#info], value, old)
    self.db.char[info[#info]] = value
  else
    self.db.char[tostring(info)] = value
  end
end

function Config:RefreshConfig(db)
  --TODO
end


--------------------------------------------------
-- Interface Events & Functions
--------------------------------------------------
function Config:SetupOptionsUI()
  GiveMeAShot.optionsFrame = CreateFrame("Frame", "GiveMeAShot_Options", InterfaceOptionsFramePanelContainer)
  GiveMeAShot.optionsFrame.name = L["Addon_Title"]
  GiveMeAShot.optionsFrame:SetAllPoints()
  HideUIPanel(GiveMeAShot.optionsFrame)

  local title = GiveMeAShot.optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 10, -10)
  title:SetText(L["Addon_Title"])

  -- Debug Mode
  local debugModeCheckbox = Controls:createCheckbox(
    GiveMeAShot.optionsFrame,
    "GiveMeAShot_DebugMode_Checkbox",
    L["DebugMode"],
    L["DebugMode_Desc"],
    false,
    function(self, value)
      if value then
        Util:PrintColored(L["DebugMode_Activated"], Util:GetColor('custom', 'warning'))
      else
        Util:PrintColored(L["DebugMode_Deactivated"], Util:GetColor('custom', 'warning'))
      end
      Config:SetProfile('config.debugMode', value)
    end
  )
  debugModeCheckbox:SetPoint("TOPRIGHT", GiveMeAShot.optionsFrame, -100, -10)

  -- Minimap Button
  local minimapButtonCheckbox = Controls:createCheckbox(
    GiveMeAShot.optionsFrame,
    "GiveMeAShot_MinimapButton_Checkbox",
    L["MinimapButton"],
    L["MinimapButton_Desc"],
    false,
    function(self, value)
      GiveMeAShot:ToggleMinimapButton()
    end
  )
  minimapButtonCheckbox:SetChecked(not Config:GetProfile('minimapButton.hide'))
  minimapButtonCheckbox:SetPoint("TOPLEFT", title, 10, -30)

  -- add to interface options
  InterfaceOptions_AddCategory(GiveMeAShot.optionsFrame);
end

function Config:SetupHelpUI()
  local MAX_FRAME_WIDTH = 550

  GiveMeAShot.helpFrame = CreateFrame("Frame", "GiveMeAShot_Help", GiveMeAShot.optionsFrame)
  GiveMeAShot.helpFrame.name = L["Help"]
  GiveMeAShot.helpFrame.parent = GiveMeAShot.optionsFrame.name
  GiveMeAShot.helpFrame:SetAllPoints()
  HideUIPanel(GiveMeAShot.helpFrame)

  local title = GiveMeAShot.helpFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 10, -10)
  title:SetText(L["Addon_Title"] .. " :: " .. L["Help"])

  -- Opener
  local helpLabelOpener = Controls:createLabel(GiveMeAShot.helpFrame, "GiveMeAShot_HelpLabel_Opener", L["Help_Opener"], "GameFontNormal", MAX_FRAME_WIDTH)
  helpLabelOpener:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -20)

  -- add to interface options
  InterfaceOptions_AddCategory(GiveMeAShot.helpFrame);
end


--------------------------------------------------
-- INIT
--------------------------------------------------
function Options:OnInitialize()
  -- register database
  self.db = LibStub('AceDB-3.0'):New('GiveMeAShotDB', _defaultConfig)
  self.db:RegisterDefaults(_defaultConfig)

  -- setup profile options
  profileOptions = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
  LibStub("AceConfig-3.0"):RegisterOptionsTable("GiveMeAShot_Profiles", profileOptions)
  profileSubMenu = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GiveMeAShot_Profiles", L["Profiles"], L["Addon_Title_Short"])
  
  self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
  self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
  self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
end