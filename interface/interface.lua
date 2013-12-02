-- ProbablyEngine Rotations - https://probablyengine.com/
-- Released under modified BSD, see attached LICENSE.

-- Handle the minimap icon

local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local button_moving = false

function ProbablyEngine_Minimap_Reposition()
  if not ProbablyEngine.config.read('minimap_position') then ProbablyEngine.config.write('minimap_position', 45) end
  local position = ProbablyEngine.config.read('minimap_position')
  ProbablyEngine_Minimap:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(position)),(80*sin(position))-52)
end

function ProbablyEngine_Minimap_DraggingFrame_OnUpdate()
  local xpos,ypos = GetCursorPosition()
  local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()
  xpos = xmin-xpos/UIParent:GetScale()+70 -- get coordinates as differences from the center of the minimap
  ypos = ypos/UIParent:GetScale()-ymin-70
  ProbablyEngine.config.write('minimap_position', math.floor(math.deg(math.atan2(ypos,xpos)))) -- save the degrees we are relative to the minimap center
  ProbablyEngine_Minimap_Reposition() -- move the button
end

function ProbablyEngine_Minimap_OnClick(button)
  if button == 'RightButton' then
    if not button_moving then
      ProbablyEngine.buttons.frame:Show()
      button_moving = true
    else
      ProbablyEngine.buttons.frame:Hide()
      button_moving = false
    end
  else
    InterfaceOptionsFrame_OpenToCategory('ProbablyEngine')
    InterfaceOptionsFrame_OpenToCategory('ProbablyEngine')
  end
end

function ProbablyEngine_Minimap_OnEnter(self)
  GameTooltip:SetOwner( self, "ANCHOR_BOTTOMLEFT" )
  GameTooltip:AddLine("|cff" .. ProbablyEngine.addonColor .. ProbablyEngine.addonName.. "|r ".. ProbablyEngine.version)
  GameTooltip:AddLine("|cff" .. ProbablyEngine.addonColor .. pelg('left_click') .. "|r " .. pelg('open_config'))
  GameTooltip:AddLine("|cff" .. ProbablyEngine.addonColor .. pelg('right_click') .. "|r " .. pelg('unlock_buttons'))
  GameTooltip:AddLine("|cff" .. ProbablyEngine.addonColor .. pelg('drag') .. "|r " ..  pelg('move_minimap'))
  GameTooltip:Show()
end

function ProbablyEngine_Minimap_OnLeave(self)
  GameTooltip:Hide()
end


-- Lag Timer stuff

PE_CycleLag = CreateFrame("Frame", "PE_CycleLag", UIParent)
local CycleLag = PE_CycleLag
CycleLag.show = false
CycleLag:SetFrameLevel(90)
CycleLag:SetWidth(32)
CycleLag:SetHeight(32)
CycleLag:SetPoint("CENTER", UIParent)
CycleLag:SetMovable(true)
CycleLag:Hide()

local CycleLag_texture = CycleLag:CreateTexture(nil, "BACKGROUND")
CycleLag_texture:SetTexture(0,0,0,0.3)
CycleLag_texture:SetAllPoints(CycleLag)
CycleLag.texture = CycleLagText_texture

CycleLag.text = CycleLag:CreateFontString('PE_CycleLagText')
CycleLag.text:SetFont("Fonts\\ARIALN.TTF", 10)
CycleLag.text:SetPoint("CENTER", CycleLag, 0, 0)
CycleLag.text:SetText("Action")

CycleLag:SetScript("OnMouseDown", function(self, button)
  if not self.isMoving then
   self:StartMoving()
   self.isMoving = true
  end
end)
CycleLag:SetScript("OnMouseUp", function(self, button)
  if self.isMoving then
   self:StopMovingOrSizing()
   self.isMoving = false
  end
end)
CycleLag:SetScript("OnHide", function(self)
  if self.isMoving then
   self:StopMovingOrSizing()
   self.isMoving = false
  end
end)