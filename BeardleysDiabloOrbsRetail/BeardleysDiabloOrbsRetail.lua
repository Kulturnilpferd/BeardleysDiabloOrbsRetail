local addonName, BDO = ...
local images = "Interface/AddOns/BeardleysDiabloOrbsRetail/art/"
scaleFactor = 1
------------------------------------------------
-- Artwork Helper
------------------------------------------------
local function addArtworkFrame(name, parent, textureFile, strata, level, x, y, width, height, l, r, t, b, alpha)
    local frame = CreateFrame("Frame", name, parent)
    frame:SetFrameStrata(strata)
    frame:SetFrameLevel(level)
    frame:SetSize(width, height)
    frame:SetPoint("CENTER", x, y)
    frame:SetAlpha(alpha)
    local tex = frame:CreateTexture(nil, "BACKGROUND")
    tex:SetAllPoints(frame)
    tex:SetTexture(textureFile)
    tex:SetTexCoord(l, r, t, b)
    frame.texture = tex
    return frame
end

local function HideArt(frame)
	local y={ frame:GetRegions() } 
	for k,v in pairs(y)do 
		if v:GetObjectType()=="Texture" then 
			v:SetTexture(nil)
		end 
	end 
	y={ frame:GetChildren() } 
	for k,v in pairs(y)do 
		if v:GetObjectType()~="CheckButton" and v:GetObjectType()~="Button" then  
			HideArt(v)
		end 
	end 
end

------------------------------------------------
-- Frame beweglich machen
------------------------------------------------
--local function makeFrameMovable(frame)
--    frame:SetMovable(true)
--    frame:EnableMouse(true)
--    frame:RegisterForDrag("LeftButton")
--    frame:SetScript("OnDragStart", function(self)
--        if IsShiftKeyDown() then
--            self:StartMoving()
--        end
--    end)
--    frame:SetScript("OnDragStop", function(self)
--        self:StopMovingOrSizing()
--   end)
--end

local function reconfigUI()
    -- Actionbars und Pet-Actionbuttons Anpassung
 -- MainMenuBar ausblenden

    HideArt(MainMenuBar)
    MainMenuBar:SetMovable(true)
    MainMenuBar:SetUserPlaced(true)
    MainMenuBar:ClearAllPoints()
    MainMenuBar:SetPoint("CENTER",UIParent,"BOTTOM",0,38)

    --MainMenuBar.SetPoint = function() end
    MainMenuBar.ActionBarPageNumber:ClearAllPoints()
    MainMenuBar.ActionBarPageNumber:SetPoint("BOTTOM", UIParent, "BOTTOM", -310, 52)
    MainMenuBar.ActionBarPageNumber.ignoreFramePositionManager = true
    --MainMenuBar:SetScale(0.67)
    --MainMenuBar.SetScale = function() end
    --MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 5, 320)
    --MainMenuBar.SetPoint = function() end   
    -- Buttons aus der MainMenuBar herauslösen und ihre Position direkt auf dem UI setzen
    for i = 1, 12 do
        local button = _G["ActionButton"..i]
        if button then
            -- Setze den Parent des Buttons auf den UIParent, damit er unabhängig ist
            button.SlotArt:Hide()
            button.IconMask:Hide()
            button:ClearAllPoints()
            button:SetPoint("BOTTOM", UIParent, "BOTTOM", 28 + ((i - 7) * 51), 48)
            button.ignoreFramePositionManager = true
        end
    end

    -- Wiederhole dies für alle anderen ActionBars, falls notwendig
    for i = 1, 12 do
        local button = _G["MultiBarBottomLeftButton"..i]
        if button then
            button:ClearAllPoints()
            button:SetPoint("BOTTOM", UIParent, "BOTTOM", 28 + (i - 7) * 51, 98)
            button.ignoreFramePositionManager = true
        end
    end

    for i = 1, 12 do
        local button = _G["MultiBarBottomRightButton"..i]
        if button then
            button:ClearAllPoints()
            button:SetPoint("BOTTOM", UIParent, "BOTTOM", 28 + (i - 7) * 51, 162)
            button.ignoreFramePositionManager = true
        end
    end

    -- Pet Action Bar
    PetActionBar:ClearAllPoints()
    PetActionBar:SetPoint("BOTTOM", UIParent, "BOTTOM", -143, 210)
    PetActionBar.ignoreFramePositionManager = true

    -- Micromenu
    MicroMenuContainer:ClearAllPoints()
    MicroMenuContainer:SetPoint("BOTTOM", UIParent, "BOTTOM",-18, 2)
    MicroMenuContainer.ignoreFramePositionManager = true

    -- Bagsbar Bags 
    BagsBar:ClearAllPoints()
    BagsBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 268, -2)
    BagsBar.ignoreFramePositionManager = true

    -- Stance Buttons Anpassung
    for i = 1, 6 do
        local stanceButton = _G["StanceButton" .. i]
        if stanceButton then
            stanceButton:ClearAllPoints()
            stanceButton:SetPoint("BOTTOM", UIParent, "BOTTOM", -320 + (i - 1) * 31, 5)
            stanceButton.ignoreFramePositionManager = true
        end
    end

    -- Erfahrungs Bar
    MainStatusTrackingBarContainer:ClearAllPoints()
    MainStatusTrackingBarContainer:SetPoint("BOTTOM", UIParent, "BOTTOM", 4, 142)
    MainStatusTrackingBarContainer.ignoreFramePositionManager = true

    -- Ändere die FrameStrata der Chatframes
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        if chatFrame then
            chatFrame:SetFrameStrata("DIALOG")  -- Setze die Strata auf DIALOG, damit der Chat immer oben ist
        end
    end
end

------------------------------------------------
-- Setup Orbs & Bars
------------------------------------------------
function setupOrbs()
    local orbSize = 230

    ----------------------------------------
    -- Health Fill-Frame
    ----------------------------------------
    if not BDOMod_HealthFill then
        BDOMod_HealthFill = CreateFrame("Frame", nil, BDOMod_HealthOrb)
        BDOMod_HealthFill:SetPoint("BOTTOM")
        BDOMod_HealthFill:SetSize(orbSize, orbSize)
        BDOMod_HealthFill:SetClipsChildren(true)
        BDOMod_HealthFill:SetFrameLevel(2)
        -- Rotation der Texture BDOMod_RedOrb anwenden
        BDOMod_HealthFill:SetScript("OnUpdate", function(self, elapsed)
            local rotation = BDOMod_RedOrb:GetRotation() + (elapsed * 0.08)  -- Geschwindigkeit der Rotation anpassen
            BDOMod_RedOrb:SetRotation(rotation)
        end)
    end

    ----------------------------------------
    -- Health Orb parenten und Mask setzen
    ----------------------------------------
    if BDOMod_RedOrb then
        BDOMod_RedOrb:ClearAllPoints()
        BDOMod_RedOrb:SetParent(BDOMod_HealthFill)
        BDOMod_RedOrb:SetPoint("BOTTOM")
        BDOMod_RedOrb:SetSize(orbSize, orbSize)
        BDOMod_RedOrb:SetVertexColor(0, 1, 0)
        BDOMod_RedOrb:SetAlpha(1)
        BDOMod_RedOrb:SetTexture(images.."orb_filling1.png")
    end


    ----------------------------------------
    -- Shield Fill-Frame
    ----------------------------------------
    if not BDOMod_ShieldFill then
        BDOMod_ShieldFill = CreateFrame("Frame", nil, BDOMod_HealthOrb)
        BDOMod_ShieldFill:SetPoint("BOTTOM")
        BDOMod_ShieldFill:SetSize(orbSize, orbSize)
        BDOMod_ShieldFill:SetClipsChildren(true)
        BDOMod_ShieldFill:SetFrameLevel(1)  -- Falls das Frame eine andere Ebene braucht
        -- Rotation der Shield Orb Texture anwenden
        BDOMod_ShieldFill:SetScript("OnUpdate", function(self, elapsed)
            local rotation = BDOMod_RedOrbShield:GetRotation() + (elapsed * 0.08)  -- Geschwindigkeit der Rotation anpassen
            BDOMod_RedOrbShield:SetRotation(rotation)
        end)
    end

    ----------------------------------------
    -- Shield Orb parenten und Mask setzen
    ----------------------------------------
    if BDOMod_RedOrbShield then
        BDOMod_RedOrbShield:ClearAllPoints()
        BDOMod_RedOrbShield:SetParent(BDOMod_ShieldFill)
        BDOMod_RedOrbShield:SetPoint("BOTTOM")
        BDOMod_RedOrbShield:SetSize(orbSize, orbSize)
        BDOMod_RedOrbShield:SetVertexColor(1, 1, 1)
        BDOMod_RedOrbShield:SetAlpha(1)
        BDOMod_RedOrbShield:SetTexture(images.."blank_orb.png")
    end



    ----------------------------------------
    -- Mana Fill-Frame
    ----------------------------------------
    if not BDOMod_ManaFill then
        BDOMod_ManaFill = CreateFrame("Frame", nil, BDOMod_ManaOrb)
        BDOMod_ManaFill:SetPoint("BOTTOM")
        BDOMod_ManaFill:SetSize(orbSize, orbSize)
        BDOMod_ManaFill:SetClipsChildren(true)
        BDOMod_ManaFill:SetFrameLevel(1)
        -- Rotation der Mana Orb Texture anwenden
        BDOMod_ManaFill:SetScript("OnUpdate", function(self, elapsed)
            local rotation = BDOMod_BlueOrb:GetRotation() + (elapsed * 0.08)  -- Geschwindigkeit der Rotation anpassen
            BDOMod_BlueOrb:SetRotation(rotation)
        end)
    end

    ----------------------------------------
    -- Mana Orb parenten und Mask setzen
    ----------------------------------------
    if BDOMod_BlueOrb then
        BDOMod_BlueOrb:ClearAllPoints()
        BDOMod_BlueOrb:SetParent(BDOMod_ManaFill)
        BDOMod_BlueOrb:SetPoint("BOTTOM")
        BDOMod_BlueOrb:SetSize(orbSize, orbSize)
        BDOMod_BlueOrb:SetVertexColor(0, 0, 1)
        BDOMod_BlueOrb:SetAlpha(1)
        BDOMod_BlueOrb:SetTexture(images.."orb_filling1.png")
    end

    ----------------------------------------
    -- Health Texte über eigenem Frame (nur einmal erstellen)
    ----------------------------------------
    -- Holen der aktuellen Schriftart und -Flags


    if not BDOMod_HealthText then
        local healthTextFrame = CreateFrame("Frame", nil, BDOMod_HealthOrb)
        
        healthTextFrame:SetAllPoints(BDOMod_HealthOrb)
        healthTextFrame:SetFrameLevel(BDOMod_HealthFill:GetFrameLevel() + 2)
 
        BDOMod_HealthPercentage = healthTextFrame:CreateFontString(nil, "OVERLAY", "ChatFontNormal")
        BDOMod_HealthPercentage:SetPoint("CENTER", BDOMod_HealthOrb, "CENTER", 0, 20)

        BDOMod_HealthText = healthTextFrame:CreateFontString(nil, "OVERLAY", "ChatFontNormal")
        BDOMod_HealthText:SetPoint("CENTER", BDOMod_HealthOrb, "CENTER", 0, 0)

        local fontName, _, fontFlags = BDOMod_HealthPercentage:GetFont()
        BDOMod_HealthPercentage:SetFont(fontName, 18, fontFlags)  -- 16 ist die neue Schriftgröße
        BDOMod_HealthText:SetFont(fontName, 18, fontFlags)  -- 16 ist die neue Schriftgröße
    end

    ----------------------------------------
    -- Mana Texte über eigenem Frame (nur einmal erstellen)
    ----------------------------------------
    if not BDOMod_ManaText then
        local manaTextFrame = CreateFrame("Frame", nil, BDOMod_ManaOrb)
        manaTextFrame:SetAllPoints(BDOMod_ManaOrb)
        manaTextFrame:SetFrameLevel(BDOMod_ManaFill:GetFrameLevel() + 2)

        BDOMod_ManaPercentage = manaTextFrame:CreateFontString(nil, "OVERLAY", "ChatFontNormal")
        BDOMod_ManaPercentage:SetPoint("CENTER", BDOMod_ManaOrb, "CENTER", 0, 20)
 
        BDOMod_ManaText = manaTextFrame:CreateFontString(nil, "OVERLAY", "ChatFontNormal")
        BDOMod_ManaText:SetPoint("CENTER", BDOMod_ManaOrb, "CENTER", 0, 0)

        local fontName, _, fontFlags = BDOMod_ManaPercentage:GetFont()
        BDOMod_ManaPercentage:SetFont(fontName, 18, fontFlags)  -- 16 ist die neue Schriftgröße
        BDOMod_ManaText:SetFont(fontName, 18, fontFlags)  -- 16 ist die neue Schriftgröße

    end

    ----------------------------------------
    -- Artwork
    ----------------------------------------
    sfactor = 1.62
    if not BDO_Bar3 then  addArtworkFrame("BDO_Bar3", BDOMod_Bar, images.."bar3.png", "LOW", 0, 0, -14, 512 * sfactor, 150 * sfactor, 0, 1, 0, 1, 1) end
    if not BDO_LeftArtwork then addArtworkFrame("BDO_LeftArtwork", BDOMod_HealthOrb, images.."leftArtwork.png", "MEDIUM", 3, -190, 64, 350, 350, 0, 1, 0, 1, 1) end
    if not BDO_RightArtwork then addArtworkFrame("BDO_RightArtwork", BDOMod_ManaOrb, images.."rightArtwork.png", "MEDIUM", 3, 180, 64, 350, 350, 0, 1, 0, 1, 1) end
    if not BDO_GlossLeft then addArtworkFrame("BDO_GlossLeft", BDOMod_HealthOrb, images.."orb_gloss.png", "MEDIUM", 2, 0, 0, 238, 238, 0, 1, 0, 1, 1) end
    if not BDO_GlossRight then addArtworkFrame("BDO_GlossRight", BDOMod_ManaOrb, images.."orb_gloss.png", "MEDIUM", 2, 0, 0, 238, 238, 1, 0, 0, 1, 1) end
    
    
    ----------------------------------------
    -- Orbs beweglich
    ----------------------------------------
    --makeFrameMovable(BDOMod_HealthOrb)
    --makeFrameMovable(BDOMod_ManaOrb)

    ----------------------------------------
    -- Initial Update
    ----------------------------------------
    updateHealthOrb()
    updateManaOrb()
end

------------------------------------------------
-- Update Functions
------------------------------------------------
local healthOrbSpeed = 1  -- Geschwindigkeit der Animation (je kleiner, desto langsamer)
local absorptionOrbSpeed = 1  -- Geschwindigkeit der Absorptions-Animation

local currentHealth = UnitHealth("player") or 0
local currentAbsorption = 0

function updateHealthOrb()
    local health = UnitHealth("player") or 1
    local maxHealth = UnitHealthMax("player")
    local absorption = UnitGetTotalAbsorbs("player") or 0  -- Absorption des Spielers abrufen

    if maxHealth == 0 then return end
    local percentHealth = health / maxHealth
    local percentAbsorption = absorption / maxHealth  -- Absorption als Prozentsatz der maximalen Gesundheit berechnen

    local orbSize = 230

    -- Zielwerte für die Animation berechnen
    local targetHealth = orbSize * percentHealth
    local targetAbsorption = orbSize * (percentHealth + percentAbsorption)

    -- Aktualisierung der Gesundheits-Orb
    if currentHealth < targetHealth then
        currentHealth = currentHealth + healthOrbSpeed
        if currentHealth > targetHealth then currentHealth = targetHealth end
    elseif currentHealth > targetHealth then
        currentHealth = currentHealth - healthOrbSpeed
        if currentHealth < targetHealth then currentHealth = targetHealth end
    end

    -- Aktualisierung der Absorptions-Orb
    if currentAbsorption < targetAbsorption then
        currentAbsorption = currentAbsorption + absorptionOrbSpeed
        if currentAbsorption > targetAbsorption then currentAbsorption = targetAbsorption end
    elseif currentAbsorption > targetAbsorption then
        currentAbsorption = currentAbsorption - absorptionOrbSpeed
        if currentAbsorption < targetAbsorption then currentAbsorption = targetAbsorption end
    end

    -- Update der Orbs
    BDOMod_HealthFill:SetHeight(currentHealth)
    if absorption > 0 then
        BDOMod_ShieldFill:SetHeight(currentAbsorption)
        BDOMod_ShieldFill:Show()
    else
        BDOMod_ShieldFill:Hide()
    end

    -- Update der Texte
    BDOMod_HealthText:SetText(string.format("%d / %d", health, maxHealth))
    BDOMod_HealthPercentage:SetText(string.format("%d%%", percentHealth * 100))
end

local manaOrbSpeed = 1  -- Geschwindigkeit der Animation (je kleiner, desto langsamer)
local currentMana = UnitPower("player") or 0
local lastPowerType = -1  -- Eine Variable, um den letzten PowerType zu speichern

function updateManaOrb()
    local power = UnitPower("player")
    local maxPower = UnitPowerMax("player")
    if maxPower == 0 then return end
    local percent = power / maxPower

    -- Bestimmen des Ressourcentypen
    local powerType = UnitPowerType("player")

    -- Wenn sich der PowerType geändert hat, setze den Füllwert sofort auf den aktuellen Prozentsatz
    if powerType ~= lastPowerType then
        currentMana = percent * 230  -- Sofortige Anpassung der Mana-Orb-Höhe

        -- Bestimme die Orb-Farbe sofort, basierend auf dem PowerType
        local r, g, b = 0.2, 0.4, 1.0  -- Standardfarbe für Mana (Blau)

        if powerType == 1 then
            -- Wut (Rot)
            r, g, b = 1.0, 0.0, 0.0
        elseif powerType == 3 then
            -- Energie (Gelb)
            r, g, b = 1.0, 1.0, 0.0
        elseif powerType == 4 then
            -- Runen (Grün)
            r, g, b = 0.0, 1.0, 0.0
        elseif powerType == 5 then
            -- Fokus (Blau)
            r, g, b = 0.0, 0.6, 1.0
        elseif powerType == 6 then
            -- Runenmacht (Lila)
            r, g, b = 0.6, 0.0, 1.0
        end

        -- Setze sofort die neue Farbe der Mana-Orb
        BDOMod_BlueOrb:SetVertexColor(r, g, b)

        -- Aktualisiere den letzten PowerType
        lastPowerType = powerType
    end

    -- Zielwert für die Animation (Mana-Orb)
    local orbSize = 230
    local targetMana = orbSize * percent

    -- Schrittweise Aktualisierung der Mana-Orb
    if currentMana < targetMana then
        currentMana = currentMana + manaOrbSpeed
        if currentMana > targetMana then currentMana = targetMana end
    elseif currentMana > targetMana then
        currentMana = currentMana - manaOrbSpeed
        if currentMana < targetMana then currentMana = targetMana end
    end

    -- Update der Mana-Orb
    BDOMod_ManaFill:SetHeight(currentMana)

    -- Update Textanzeigen
    BDOMod_ManaText:SetText(string.format("%d / %d", power, maxPower))
    BDOMod_ManaPercentage:SetText(string.format("%d%%", percent * 100))
end

------------------------------------------------
-- OnLoad & Event Handling
------------------------------------------------
function BDOMod_OnLoad(self)
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:SetScript("OnUpdate", function(self, elapsed)
        updateHealthOrb()
        updateManaOrb()
    end)
end

function BDOMod_OnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        reconfigUI()
        setupOrbs()
    end
end
