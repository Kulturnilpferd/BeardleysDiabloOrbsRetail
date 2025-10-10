local addonName, BDO = ...
local images = "Interface/AddOns/BeardleysDiabloOrbsRetail/art/"
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

local function moveItem(frame, point, relativeTo, relativePoint, offsetX, offsetY)
    frame:SetMovable(true)
    frame:SetUserPlaced(true)
    frame:ClearAllPoints()
    frame:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY)
    frame.ignoreFramePositionManager = true
end

local function reconfigUI()
    -- Actionbars und Pet-Actionbuttons Anpassung
 -- MainMenuBar ausblenden

    HideArt(MainMenuBar)
    moveItem(MainMenuBar, "CENTER", BDOMod_Bar, "BOTTOM", 0, 38)
    moveItem(MainMenuBar.ActionBarPageNumber, "BOTTOM", BDOMod_Bar, "BOTTOM", -306, 54)

    -- Buttons aus der MainMenuBar herauslösen und ihre Position direkt auf dem UI setzen
    for i = 1, 12 do
        local button = _G["ActionButton"..i]
        if button then
            -- Setze den Parent des Buttons auf den UIParent, damit er unabhängig ist
            button.SlotArt:Hide()
            button.IconMask:Hide()
            moveItem(button, "BOTTOM", BDOMod_Bar, "BOTTOM", 26 + ((i - 7) * 50), 49)
        end
    end

    -- Wiederhole dies für alle anderen ActionBars, falls notwendig
    for i = 1, 12 do
        local button = _G["MultiBarBottomLeftButton"..i]
        if button then
            moveItem(button, "BOTTOM", BDOMod_Bar, "BOTTOM", 26 + (i - 7) * 50, 99)
        end
    end

    for i = 1, 12 do
        local button = _G["MultiBarBottomRightButton"..i]
        if button then
            moveItem(button, "BOTTOM", BDOMod_Bar, "BOTTOM", 26 + (i - 7) * 50, 163)
        end
    end

    -- Pet Action Bar
    moveItem(PetActionBar, "BOTTOM", BDOMod_Bar, "BOTTOM", -143, 210)

    -- Micromenu
    moveItem(MicroMenuContainer, "BOTTOM", BDOMod_Bar, "BOTTOM",-18, 2)

    -- Bagsbar Bags
    moveItem(BagsBar, "BOTTOM", BDOMod_Bar, "BOTTOM", 268, -2)
    BagsBar:SetFrameLevel(5)

    -- Stance Buttons Anpassung
    for i = 1, 6 do
        local button = _G["StanceButton" .. i]
        if button then
            moveItem(button, "BOTTOM", BDOMod_Bar, "BOTTOM", -320 + (i - 1) * 31, 5)
        end
    end

    -- Erfahrungs Bar
    moveItem(MainStatusTrackingBarContainer, "BOTTOM", BDOMod_Bar, "BOTTOM", 4, 143)

    -- Ändere die FrameStrata der Chatframes
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        if chatFrame then
            chatFrame:SetFrameStrata("DIALOG")
        end
    end
end

------------------------------------------------
-- Setup Orbs & Bars
------------------------------------------------
function setupOrbs()
    local orbSize = 230
------------------------------------------------
    ----------------------------------------
    -- Health Fill-Frame
    ----------------------------------------
    if not BDOMod_HealthFillBackground then
        BDOMod_HealthFillBackground = CreateFrame("Frame", nil, BDOMod_HealthOrb)
        BDOMod_HealthFillBackground:SetPoint("BOTTOM")
        BDOMod_HealthFillBackground:SetSize(orbSize, orbSize)
        BDOMod_HealthFillBackground:SetClipsChildren(true)
        BDOMod_HealthFillBackground:SetFrameLevel(1)
        -- Rotation der Texture BDOMod_RedOrb anwenden
    end

    ----------------------------------------
    -- Health Orb parenten und Mask setzen
    ----------------------------------------
    if BDOMod_RedOrbBackground then
        BDOMod_RedOrbBackground:ClearAllPoints()
        BDOMod_RedOrbBackground:SetParent(BDOMod_HealthFillBackground)
        BDOMod_RedOrbBackground:SetPoint("BOTTOM")
        BDOMod_RedOrbBackground:SetSize(orbSize, orbSize)
        BDOMod_RedOrbBackground:SetVertexColor(0, 1, 0)
        BDOMod_RedOrbBackground:SetAlpha(1)
        BDOMod_RedOrbBackground:SetTexture(images.."orb_fill.png")
    end
------------------------------------------------
    ----------------------------------------
    -- Shield Fill-Frame
    ----------------------------------------
    if not BDOMod_ShieldFill then
        BDOMod_ShieldFill = CreateFrame("Frame", nil, BDOMod_HealthOrb)
        BDOMod_ShieldFill:SetPoint("BOTTOM")
        BDOMod_ShieldFill:SetSize(orbSize, orbSize)
        BDOMod_ShieldFill:SetClipsChildren(true)
        BDOMod_ShieldFill:SetFrameLevel(2)  -- Falls das Frame eine andere Ebene braucht
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
        BDOMod_RedOrbShield:SetTexture(images.."orb_fill.png")
    end
------------------------------------------------
    ----------------------------------------
    -- Health Fill-Frame
    ----------------------------------------
    if not BDOMod_HealthFill then
        BDOMod_HealthFill = CreateFrame("Frame", nil, BDOMod_HealthOrb)
        BDOMod_HealthFill:SetPoint("BOTTOM")
        BDOMod_HealthFill:SetSize(orbSize, orbSize)
        BDOMod_HealthFill:SetClipsChildren(true)
        BDOMod_HealthFill:SetFrameLevel(3)
        -- Rotation der Texture BDOMod_RedOrb anwenden
        BDOMod_HealthFill:SetScript("OnUpdate", function(self, elapsed)
            local rotation = BDOMod_RedOrb:GetRotation() - (elapsed * 0.05)  -- Geschwindigkeit der Rotation anpassen
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
        BDOMod_RedOrb:SetTexture(images.."orb_mist.png")
    end
------------------------------------------------
------------------------------------------------
------------------------------------------------
    ----------------------------------------
    -- Mana Fill Background-Frame
    ----------------------------------------
    if not BDOMod_ManaFillBackground then
        BDOMod_ManaFillBackground = CreateFrame("Frame", nil, BDOMod_ManaOrb)
        BDOMod_ManaFillBackground:SetPoint("BOTTOM")
        BDOMod_ManaFillBackground:SetSize(orbSize, orbSize)
        BDOMod_ManaFillBackground:SetClipsChildren(true)
        BDOMod_ManaFillBackground:SetFrameLevel(1)
        -- Rotation der Mana Orb Texture anwenden
    end

    ----------------------------------------
    -- Mana Orb parenten und Mask setzen
    ----------------------------------------
    if BDOMod_BlueOrbBackground then
        BDOMod_BlueOrbBackground:ClearAllPoints()
        BDOMod_BlueOrbBackground:SetParent(BDOMod_ManaFillBackground)
        BDOMod_BlueOrbBackground:SetPoint("BOTTOM")
        BDOMod_BlueOrbBackground:SetSize(orbSize, orbSize)
        BDOMod_BlueOrbBackground:SetVertexColor(0, 0, 1)
        BDOMod_BlueOrbBackground:SetAlpha(1)
        BDOMod_BlueOrbBackground:SetTexture(images.."orb_fill.png")
    end
------------------------------------------------
    ----------------------------------------
    -- Mana Fill-Frame
    ----------------------------------------
    if not BDOMod_ManaFill then
        BDOMod_ManaFill = CreateFrame("Frame", nil, BDOMod_ManaOrb)
        BDOMod_ManaFill:SetPoint("BOTTOM")
        BDOMod_ManaFill:SetSize(orbSize, orbSize)
        BDOMod_ManaFill:SetClipsChildren(true)
        BDOMod_ManaFill:SetFrameLevel(2)
        -- Rotation der Mana Orb Texture anwenden
        BDOMod_ManaFill:SetScript("OnUpdate", function(self, elapsed)
            local rotation = BDOMod_BlueOrb:GetRotation() + (elapsed * 0.05)  -- Geschwindigkeit der Rotation anpassen
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
        BDOMod_BlueOrb:SetTexture(images.."orb_mist.png")
    end
------------------------------------------------
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
    local sfactor = 1.62
    if not BDO_Bar3 then  addArtworkFrame("BDO_Bar3", BDOMod_Bar, images.."bar3.png", "LOW", 0, 0, -14, (512 * sfactor)-10, (150 * sfactor) + 2, 0, 1, 0, 1, 1) end
    if not BDO_LeftArtwork then addArtworkFrame("BDO_LeftArtwork", BDOMod_HealthOrb, images.."leftArtwork.png", "MEDIUM", 5, -190, 64, 350, 350, 0, 1, 0, 1, 1) end
    if not BDO_RightArtwork then addArtworkFrame("BDO_RightArtwork", BDOMod_ManaOrb, images.."rightArtwork.png", "MEDIUM", 5, 180, 64, 350, 350, 0, 1, 0, 1, 1) end
    if not BDO_GlossLeft then addArtworkFrame("BDO_GlossLeft", BDOMod_HealthOrb, images.."orb_gloss.png", "MEDIUM", 4, 0, 0, 238, 238, 0, 1, 0, 1, 1) end
    if not BDO_GlossRight then addArtworkFrame("BDO_GlossRight", BDOMod_ManaOrb, images.."orb_gloss.png", "MEDIUM", 4, 0, 0, 238, 238, 1, 0, 0, 1, 1) end
        
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
local healthOrbSpeed = 1.5  -- Geschwindigkeit der Animation (je kleiner, desto langsamer)
local absorptionOrbSpeed = 1.5  -- Geschwindigkeit der Absorptions-Animation

local currentHealth = 0
local currentAbsorption = 0

function updateHealthOrb()
    -- Hole die aktuellen Werte für Gesundheit, maximale Gesundheit und Absorption
    local health = UnitHealth("player") or 0
    local maxHealth = UnitHealthMax("player") or 1  -- Um zu verhindern, dass maxHealth 0 wird
    local absorption = UnitGetTotalAbsorbs("player") or 0  -- Absorption des Spielers abrufen

    -- Wenn maxHealth 0 ist, breche ab und setze die Höhe auf 0
    if maxHealth == 0 then 
        BDOMod_HealthFill:SetHeight(0)
        BDOMod_HealthFillBackground:SetHeight(0)
        BDOMod_ShieldFill:Hide()  -- Verstecke die Absorption
        BDOMod_HealthText:SetText("0 / 0")
        BDOMod_HealthPercentage:SetText("0%")
        return
    end

    -- Berechne den Prozentsatz der Gesundheit und der Absorption
    local percentHealth = health / maxHealth
    local percentAbsorption = absorption / maxHealth  -- Absorption als Prozentsatz der maximalen Gesundheit berechnen

    -- Zielgröße der Orbs
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

    -- Update der Health-Orb
    BDOMod_HealthFill:SetHeight(currentHealth)
    BDOMod_HealthFillBackground:SetHeight(currentHealth)

    -- Update der Absorption-Orb
    if absorption > 0 then
        BDOMod_ShieldFill:SetHeight(currentAbsorption)
        BDOMod_ShieldFill:Show()
    else
        BDOMod_ShieldFill:Hide()  -- Verstecke das Absorptions-Orb, wenn keine Absorption vorhanden ist
    end

    -- Update der Textanzeigen
    BDOMod_HealthText:SetText(string.format("%d / %d", health, maxHealth))
    BDOMod_HealthPercentage:SetText(string.format("%d%%", percentHealth * 100))
end

local function SetOrbColor(powerType)
    local powerColors = {
        [0] = {0.2, 0.4, 1.0},    -- Mana
        [1] = {1.0, 0.0, 0.0},    -- Wut
        [3] = {1.0, 1.0, 0.0},    -- Energie
        [4] = {0.0, 1.0, 0.0},    -- Runen
        [5] = {0.0, 0.6, 1.0},    -- Fokus
        [6] = {0.6, 0.0, 1.0},    -- Runenmacht
        [7] = {0.78, 0.51, 1.0},  -- Seelenmacht
        [8] = {0.3, 0.52, 0.9},   -- Astrale Macht
        [9] = {0.71, 1.0, 0.92},  -- Chi
        [10] = {1.0, 0.25, 0.25}, -- Hölle/Fury
        [11] = {1.0, 0.9, 0.0},   -- Glück
    }
    local r, g, b = unpack(powerColors[powerType] or {0.2, 0.4, 1.0})
    BDOMod_BlueOrb:SetVertexColor(r, g, b)
end

local lastPowerType = -1
local currentMana = 1
local manaOrbSpeed = 1.5 -- Geschwindigkeit, mit der die Mana-Orb-Anzeige aktualisiert wird

function updateManaOrb()
    -- Hole den aktuellen Power-Wert und den maximalen Power-Wert des Spielers
    local power = UnitPower("player") or 0
    local maxPower = UnitPowerMax("player") or 1

    -- Wenn der maximale Power-Wert 0 ist, tun wir nichts
    if maxPower == 0 then 
        BDOMod_ManaFill:SetHeight(0)
        BDOMod_ManaFillBackground:SetHeight(0)
        BDOMod_ManaText:SetText("0 / 0")
        BDOMod_ManaPercentage:SetText("0%")
        return 
    end

    -- Berechne den Prozentwert
    local percent = power / maxPower

    -- Bestimmen des Ressourcentyps (Mana, Energie, etc.)
    local powerType = UnitPowerType("player")

    -- Wenn sich der Power-Typ geändert hat, setze den Füllwert sofort auf den aktuellen Prozentsatz
    if lastPowerType ~= powerType then
        SetOrbColor(powerType)  -- Diese Funktion setzt die Farbe des Orbs basierend auf dem Power-Typ
        lastPowerType = powerType
    end

    -- Zielwert für die Animation (Mana-Orb)
    local orbSize = 230
    local targetMana = orbSize * percent

    -- Dynamische Anpassung der Geschwindigkeit basierend auf der Differenz
    local diff = math.abs(currentMana - targetMana)
    local dynamicSpeed = math.min(manaOrbSpeed, diff / 10) -- Passen Sie den Divisor nach Bedarf an

    -- Schrittweise Aktualisierung der Mana-Orb (smooth animation)
    if currentMana < targetMana then
        currentMana = currentMana + dynamicSpeed
        if currentMana > targetMana then currentMana = targetMana end
    elseif currentMana > targetMana then
        currentMana = currentMana - dynamicSpeed
        if currentMana < targetMana then currentMana = targetMana end
    end

    -- Update der Mana-Orb, nur wenn sich der Wert geändert hat
    if currentMana ~= targetMana then
        BDOMod_ManaFill:SetHeight(currentMana)
        BDOMod_ManaFillBackground:SetHeight(currentMana)
    end

    -- Update der Textanzeigen
    BDOMod_ManaText:SetText(string.format("%d / %d", power, maxPower))
    BDOMod_ManaPercentage:SetText(string.format("%d%%", percent * 100))
end

-- OnLoad & Event Handling
------------------------------------------------
function BDOMod_OnLoad(self)
    -- Bestehende Events
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("UNIT_AURA")

    -- Neue Events für UI-Änderungen, Cutscenes etc.
    self:RegisterEvent("CINEMATIC_START")
    self:RegisterEvent("CINEMATIC_STOP")
    self:RegisterEvent("PLAY_MOVIE")
    self:RegisterEvent("DISPLAY_SIZE_CHANGED")
    self:RegisterEvent("UI_SCALE_CHANGED")
    self:RegisterEvent("UNIT_ENTERED_VEHICLE")
    self:RegisterEvent("UNIT_EXITED_VEHICLE")
    self:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")

    -- Optional: Combat-Events, falls du UI nicht im Kampf anpassen darfst
    -- self:RegisterEvent("PLAYER_REGEN_ENABLED")

    -- Update-Loop (z. B. für Animationen)
    self:SetScript("OnUpdate", function(self, elapsed)
        updateHealthOrb()
        updateManaOrb()
    end)

    -- Event-Handler verbinden
    self:SetScript("OnEvent", BDOMod_OnEvent)
end

function BDOMod_OnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        reconfigUI()
        setupOrbs()
        local powerType = UnitPowerType("player")
        SetOrbColor(powerType)

    elseif event == "UNIT_AURA" then
        local unit = ...
        if unit == "player" then
            updateManaOrb()
            local powerType = UnitPowerType("player")
            SetOrbColor(powerType)
        end

    elseif event == "CINEMATIC_START" or event == "PLAY_MOVIE" then
        -- Verstecke UI bei Cutscenes
        BDOMod_Bar:Hide()

    elseif event == "CINEMATIC_STOP" or event == "UNIT_EXITED_VEHICLE"
        or event == "DISPLAY_SIZE_CHANGED" or event == "UI_SCALE_CHANGED"
        or event == "PLAYER_ENTERING_WORLD" then
        -- Nach Änderungen oder Cutscene-Ende UI neu aufbauen
        C_Timer.After(0.1, function()
            reconfigUI()
            setupOrbs()
            local powerType = UnitPowerType("player")
            SetOrbColor(powerType)
            BDOMod_Bar:Show()
        end)

    elseif event == "UNIT_ENTERED_VEHICLE" then
        -- Optional: Orb ausblenden im Fahrzeug
        BDOMod_Bar:Hide()

    elseif event == "UPDATE_OVERRIDE_ACTIONBAR" then
        -- Prüfen, ob die Override-Actionbar aktiv ist
        local isOverride = HasOverrideActionBar()
        if isOverride then
            if BDOMod_Bar then BDOMod_Bar:Hide() end
        else
            C_Timer.After(0.1, function()
                if BDOMod_Bar then
                    reconfigUI()
                    BDOMod_Bar:Show() 
                end
            end)
        end
    end
end
