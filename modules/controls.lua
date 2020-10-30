local Controls = GiveMeAShot:NewModule('Controls')
local L = LibStub('AceLocale-3.0'):GetLocale("GiveMeAShot")
local Util = GiveMeAShot:GetModule('Util')


--------------------------------------------------
-- UI Widget Functions
--------------------------------------------------
function Controls:createSlider(parent, name, label, description, minVal, maxVal, valStep, onValueChanged, onShow)
  local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
  local editbox = CreateFrame("EditBox", name.."EditBox", slider, "InputBoxTemplate")

  slider:SetMinMaxValues(minVal, maxVal)
  slider:SetValue(minVal)
  slider:SetValueStep(1)
  slider.text = _G[name.."Text"]
  slider.text:SetText(label)
  slider.textLow = _G[name.."Low"]
  slider.textHigh = _G[name.."High"]
  slider.textLow:SetText(floor(minVal))
  slider.textHigh:SetText(floor(maxVal))
  slider.textLow:SetTextColor(0.4,0.4,0.4)
  slider.textHigh:SetTextColor(0.4,0.4,0.4)
  slider.tooltipText = label
  slider.tooltipRequirement = description

  editbox:SetSize(50,30)
  editbox:SetNumeric(true)
  editbox:SetMultiLine(false)
  editbox:SetMaxLetters(5)
  editbox:ClearAllPoints()
  editbox:SetPoint("TOP", slider, "BOTTOM", 0, -5)
  editbox:SetNumber(slider:GetValue())
  editbox:SetCursorPosition(0);
  editbox:ClearFocus();
  editbox:SetAutoFocus(false)
  editbox.tooltipText = label
  editbox.tooltipRequirement = description

	slider:SetScript("OnValueChanged", function(self,value)
		self.editbox:SetNumber(floor(value))
		if(not self.editbox:HasFocus()) then
			self.editbox:SetCursorPosition(0);
			self.editbox:ClearFocus();
		end
        onValueChanged(self, value)
	end)

  slider:SetScript("OnShow", function(self,value)
      onShow(self, value)
  end)

	editbox:SetScript("OnTextChanged", function(self)
		local value = self:GetText()

		if tonumber(value) then
			if(floor(value) > maxVal) then
				self:SetNumber(maxVal)
			end

			if floor(self:GetParent():GetValue()) ~= floor(value) then
				self:GetParent():SetValue(floor(value))
			end
		end
	end)

	editbox:SetScript("OnEnterPressed", function(self)
		local value = self:GetText()
		if tonumber(value) then
			self:GetParent():SetValue(floor(value))
				self:ClearFocus()
		end
	end)

	slider.editbox = editbox
	return slider
end

function Controls:createCheckbox(parent, name, label, description, hideLabel, onClick)
  local check = CreateFrame("CheckButton", name, parent, "InterfaceOptionsCheckButtonTemplate")
  check.label = _G[check:GetName() .. "Text"]
  if not hideLabel then
    check.label:SetText(label)
    check:SetFrameLevel(8)
  end
  check.tooltipText = label
  check.tooltipRequirement = description

  -- events
  check:SetScript("OnClick", function(self)
    local tick = self:GetChecked()
    onClick(self, tick and true or false)
  end)

  return check
end

function Controls:createEditbox(parent, name, tooltipTitle, tooltipDescription, width, height, multiline, onTextChanged)
  local editbox = CreateFrame("EditBox", name, parent, "InputBoxTemplate")
	editbox:SetSize(width, height)
	editbox:SetMultiLine(multiline)
	editbox:SetFrameLevel(9)
	editbox:ClearFocus()
  editbox:SetAutoFocus(false)
  
  if onTextChanged ~= nil then
    editbox:SetScript("OnTextChanged", function(self)
      onTextChanged(self)
    end)
  end

	editbox:SetScript("OnEnter", function(self, motion)
    Controls:ShowTooltip(self, tooltipTitle, tooltipDescription)
	end)
	editbox:SetScript("OnLeave", function(self, motion)
    Controls:HideTooltip(self)
	end)

  return editbox
end

function Controls:createLabel(parent, name, text, inheritsFrom, maxLineWidth)  
  inheritsFrom = inheritsFrom or "GameFontNormal"
  maxLineWidth = maxLineWidth or 0
  local label = parent:CreateFontString(name, "ARTWORK", inheritsFrom)  
  
  if maxLineWidth > 0  then
    local tblLines = {}
    local tblWords = {}
    local width = 0
    local str = ""
    local strSaved = ""

    -- split all single words
    for s in string.gmatch(text, "[^ ]+") do
      table.insert(tblWords, s)
    end

    -- iterate each word
    for i = 1, #tblWords do
      if str == "" then
        str = tblWords[i] 
      else 
        str = str .. " " .. tblWords[i]
      end

      -- set text to label and get width of new FontString
      label:SetText(str)
      width = label:GetStringWidth();

      -- check width and create lines
      if width <= maxLineWidth and i < #tblWords then
        strSaved = str
      else     
        if i == #tblWords then
          strSaved = str
        end

        -- create line and clear values
        table.insert(tblLines, strSaved)
        str = ""
        strSaved = ""
      end     
    end

    -- concatenate final string
    local finalLabelText = tblLines[1]
    for j = 2, #tblLines do
      finalLabelText = finalLabelText .. "\n" .. tblLines[j]
    end
    label:SetText(finalLabelText)
  else 
    label:SetText(text)
  end

  return label
end


--------------------------------------------------
-- Interface Events & Functions
--------------------------------------------------
function Controls:ShowTooltip(self, title, description)
  if self then
    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
    GameTooltip:SetText(title)
    GameTooltip:AddLine(description, 1, 1, 1, true)
    GameTooltip:Show()
  end
end

function Controls:HideTooltip(self)
  GameTooltip:Hide()
end