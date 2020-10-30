GiveMeAShot = LibStub("AceAddon-3.0"):NewAddon("GiveMeAShot", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local addonName = GiveMeAShot:GetName()
--
local L = LibStub("AceLocale-3.0"):GetLocale("GiveMeAShot")
local Config, Util
--
local LDB = LibStub("LibDataBroker-1.1"):NewDataObject(addonName, {
  type = "launcher",
  text = L["MinimapButtonTooltipTitle"],
  icon = "Interface\\Icons\\trade_engineering",
  OnTooltipShow = function(tooltip)
    tooltip:SetText(L["MinimapButtonTooltipTitle"])
    tooltip:AddLine(L["MinimapButtonTooltipInfo"], 1, 1, 1)
    tooltip:Show()
  end,
  OnClick = function(self, button)
    if button == "LeftButton" then
      GiveMeAShot:ShowHelpFrame()
    elseif button == "RightButton" then
      GiveMeAShot:ShowOptionsFrame()
    end
  end})
local MiniMapButton = LibStub("LibDBIcon-1.0")


--------------------------------------------------
-- Variable definitions
--------------------------------------------------
local _state = {}


--------------------------------------------------
-- General Functions
--------------------------------------------------


--------------------------------------------------
-- Interface Events & Functions
--------------------------------------------------


--------------------------------------------------
-- Functions
--------------------------------------------------
function GiveMeAShot:ShowHelpFrame()
  -- double call to open the correct interface options panel -> Blizzard needs to fix
  InterfaceOptionsFrame_OpenToCategory(GiveMeAShot.helpFrame)
  InterfaceOptionsFrame_OpenToCategory(GiveMeAShot.helpFrame)
end

function GiveMeAShot:ShowOptionsFrame()
  -- double call to open the correct interface options panel -> Blizzard needs to fix
  InterfaceOptionsFrame_OpenToCategory(GiveMeAShot.optionsFrame)
  InterfaceOptionsFrame_OpenToCategory(GiveMeAShot.optionsFrame)
end

function GiveMeAShot:ToggleMinimapButton()
  Config:SetProfile('minimapButton.hide', not Config:GetProfile('minimapButton.hide'))
  if Config:GetProfile('minimapButton.hide') then
    MiniMapButton:Hide("GiveMeAShot")
  else
    MiniMapButton:Show("GiveMeAShot")
  end
end


--------------------------------------------------
-- Register Slash Commands
--------------------------------------------------
SLASH_RELOADUI1 = "/rl";
SlashCmdList.RELOADUI = ReloadUI;

function GiveMeAShot:ChatCommands(msg)
  local msg, msgParam = strsplit(" ", msg, 2)
  
  -- if msg == "minimap" then
  --   GiveMeAShot:ToggleMinimapButton()
  -- else
    GiveMeAShot:ShowOptionsFrame()
  -- end
end


--------------------------------------------------
-- Main Events
--------------------------------------------------
function GiveMeAShot:OnInitialize()
  -- -- setup popup dialogs
  -- self:SetupPopupDialogs()
end

function GiveMeAShot:OnEnable()
  -- load modules
  Config = self:GetModule('Config')
  Util = self:GetModule('Util')

  -- setup options frame
  Config:SetupOptionsUI();
  -- setup help site
  Config:SetupHelpUI();

  -- register minimap button
  MiniMapButton:Register("GiveMeAShot", LDB, Profile('minimapButton'))

  -- register slash commands
  self:RegisterChatCommand("givemeashot", "ChatCommands")

  -- Setup current character values
  Config:SetChar('level', UnitLevel("player"))
  Config:SetChar('race', select(2, UnitRace("player")))
  Config:SetChar('class', UnitClass("player"))
  Config:SetChar('class2', select(2, UnitClass("player")))
  Config:SetChar('faction', UnitFactionGroup("player"))
end