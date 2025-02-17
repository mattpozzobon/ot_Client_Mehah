Icons = {}
Icons[PlayerStates.Poison] = {
    tooltip = tr('You are poisoned'),
    path = '/images/game/states/poisoned',
    id = 'condition_poisoned'
}
Icons[PlayerStates.Burn] = {
    tooltip = tr('You are burning'),
    path = '/images/game/states/burning',
    id = 'condition_burning'
}
Icons[PlayerStates.Energy] = {
    tooltip = tr('You are electrified'),
    path = '/images/game/states/electrified',
    id = 'condition_electrified'
}
Icons[PlayerStates.Drunk] = {
    tooltip = tr('You are drunk'),
    path = '/images/game/states/drunk',
    id = 'condition_drunk'
}
Icons[PlayerStates.ManaShield] = {
    tooltip = tr('You are protected by a magic shield'),
    path = '/images/game/states/magic_shield',
    id = 'condition_magic_shield'
}
Icons[PlayerStates.Paralyze] = {
    tooltip = tr('You are paralysed'),
    path = '/images/game/states/slowed',
    id = 'condition_slowed'
}
Icons[PlayerStates.Haste] = {
    tooltip = tr('You are hasted'),
    path = '/images/game/states/haste',
    id = 'condition_haste'
}
Icons[PlayerStates.Swords] = {
    tooltip = tr('You may not logout during a fight'),
    path = '/images/game/states/logout_block',
    id = 'condition_logout_block'
}
Icons[PlayerStates.Drowning] = {
    tooltip = tr('You are drowning'),
    path = '/images/game/states/drowning',
    id = 'condition_drowning'
}
Icons[PlayerStates.Freezing] = {
    tooltip = tr('You are freezing'),
    path = '/images/game/states/freezing',
    id = 'condition_freezing'
}
Icons[PlayerStates.Dazzled] = {
    tooltip = tr('You are dazzled'),
    path = '/images/game/states/dazzled',
    id = 'condition_dazzled'
}
Icons[PlayerStates.Cursed] = {
    tooltip = tr('You are cursed'),
    path = '/images/game/states/cursed',
    id = 'condition_cursed'
}
Icons[PlayerStates.PartyBuff] = {
    tooltip = tr('You are strengthened'),
    path = '/images/game/states/strengthened',
    id = 'condition_strengthened'
}
Icons[PlayerStates.PzBlock] = {
    tooltip = tr('You may not logout or enter a protection zone'),
    path = '/images/game/states/protection_zone_block',
    id = 'condition_protection_zone_block'
}
Icons[PlayerStates.Pz] = {
    tooltip = tr('You are within a protection zone'),
    path = '/images/game/states/protection_zone',
    id = 'condition_protection_zone'
}
Icons[PlayerStates.Bleeding] = {
    tooltip = tr('You are bleeding'),
    path = '/images/game/states/bleeding',
    id = 'condition_bleeding'
}
Icons[PlayerStates.Hungry] = {
    tooltip = tr('You are hungry'),
    path = '/images/game/states/hungry',
    id = 'condition_hungry'
}

healthInfoWindow = nil
healthBar = nil
manaBar = nil
energyBar = nil
experienceBar = nil
energyTooltip = 'Your character energy is %d out of %d.'
healthTooltip = 'Your character health is %d out of %d.'
manaTooltip = 'Your character mana is %d out of %d.'
experienceTooltip = 'You have %d%% to advance to level %d.'

function init()
    connect(LocalPlayer, {
        onHealthChange = onHealthChange,
        onManaChange = onManaChange,
		onEnergyChange = onEnergyChange,
        onLevelChange = onLevelChange,
        onStatesChange = onStatesChange,
    })

    connect(g_game, {
        onGameStart = online,
        onGameEnd = offline
    })

    healthInfoButton = modules.client_topmenu.addRightGameToggleButton('healthInfoButton', tr('Health Information'),
                                                                       '/images/topbuttons/healthinfo', toggle)
    healthInfoButton:setOn(true)

    healthInfoWindow = g_ui.loadUI('healthinfo')
    healthInfoWindow:disableResize()
    healthBar = healthInfoWindow:recursiveGetChildById('healthBar')
    manaBar = healthInfoWindow:recursiveGetChildById('manaBar')
	energyBar = healthInfoWindow:recursiveGetChildById('energyBar')
    experienceBar = healthInfoWindow:recursiveGetChildById('experienceBar')

    -- load condition icons
    for k, v in pairs(Icons) do
        g_textures.preload(v.path)
    end

    if g_game.isOnline() then
        local localPlayer = g_game.getLocalPlayer()
        onHealthChange(localPlayer, localPlayer:getHealth(), localPlayer:getMaxHealth())
        onManaChange(localPlayer, localPlayer:getMana(), localPlayer:getMaxMana())
		onEnergyChange(localPlayer, localPlayer:getEnergy(), localPlayer:getMaxEnergy())
        onLevelChange(localPlayer, localPlayer:getLevel(), localPlayer:getLevelPercent())
        onStatesChange(localPlayer, localPlayer:getStates(), 0)
    end

    healthInfoWindow:setup()
    if g_game.isOnline() then
        healthInfoWindow:setupOnStart()
    end
end

function terminate()
    disconnect(LocalPlayer, {
        onHealthChange = onHealthChange,
        onManaChange = onManaChange,
		onEnergyChange = onEnergyChange,
        onLevelChange = onLevelChange,
        onStatesChange = onStatesChange,
    })

    disconnect(g_game, {
        onGameStart = online,
        onGameEnd = offline
    })

    healthInfoWindow:destroy()
    healthInfoButton:destroy()

    healthInfoWindow = nil
    healthBar = nil
    manaBar = nil
	energyBar = nil
    experienceBar = nil
end

function toggle()
    if healthInfoButton:isOn() then
        healthInfoWindow:close()
        healthInfoButton:setOn(false)
    else
        healthInfoWindow:open()
        healthInfoButton:setOn(true)
    end
end

function toggleIcon(bitChanged)
    local content = healthInfoWindow:recursiveGetChildById('conditionPanel')

    local icon = content:getChildById(Icons[bitChanged].id)
    if icon then
        icon:destroy()
    else
        icon = loadIcon(bitChanged)
        icon:setParent(content)
    end
end

function loadIcon(bitChanged)
    local icon = g_ui.createWidget('ConditionWidget', content)
    icon:setId(Icons[bitChanged].id)
    icon:setImageSource(Icons[bitChanged].path)
    icon:setTooltip(Icons[bitChanged].tooltip)
    return icon
end

function online()
    healthInfoWindow:setupOnStart() -- load character window configuration
end

function offline()
    healthInfoWindow:setParent(nil, true)
    healthInfoWindow:recursiveGetChildById('conditionPanel'):destroyChildren()
end

-- hooked events
function onMiniWindowOpen()
    healthInfoButton:setOn(true)
end

function onMiniWindowClose()
    healthInfoButton:setOn(false)
end

function onHealthChange(localPlayer, health, maxHealth)
    healthBar:setText(health .. ' / ' .. maxHealth)
    healthBar:setTooltip(tr(healthTooltip, health, maxHealth))
    healthBar:setValue(health, 0, maxHealth)
end

function onEnergyChange(localPlayer, energy, maxEnergy)
    energyBar:setText(energy .. ' / ' .. maxEnergy)
    energyBar:setTooltip(tr(energyTooltip, energy, maxEnergy))
    energyBar:setValue(energy, 0, maxEnergy)
end

function onManaChange(localPlayer, mana, maxMana)
    manaBar:setText(mana .. ' / ' .. maxMana)
    manaBar:setTooltip(tr(manaTooltip, mana, maxMana))
    manaBar:setValue(mana, 0, maxMana)
end

function onLevelChange(localPlayer, value, percent)
    experienceBar:setText(percent .. '%')
    experienceBar:setTooltip(tr(experienceTooltip, percent, value + 1))
    experienceBar:setPercent(percent)
end

function onSoulChange(localPlayer, soul)
    soulLabel:setText(tr('Soul') .. ': ' .. soul)
end

function onFreeCapacityChange(player, freeCapacity)
    capLabel:setText(tr('Cap') .. ': ' .. freeCapacity)
end

function onStatesChange(localPlayer, now, old)
    if now == old then
        return
    end

    local bitsChanged = bit.bxor(now, old)
    for i = 1, 32 do
        local pow = math.pow(2, i - 1)
        if pow > bitsChanged then
            break
        end
        local bitChanged = bit.band(bitsChanged, pow)
        if bitChanged ~= 0 then
            toggleIcon(bitChanged)
        end
    end
end

-- personalization functions
function hideLabels()
    local removeHeight = math.max(capLabel:getMarginRect().height, soulLabel:getMarginRect().height)
    capLabel:setOn(false)
    soulLabel:setOn(false)
    healthInfoWindow:setHeight(math.max(healthInfoWindow.minimizedHeight, healthInfoWindow:getHeight() - removeHeight))
end

function hideExperience()
    local removeHeight = experienceBar:getMarginRect().height
    experienceBar:setOn(false)
    healthInfoWindow:setHeight(math.max(healthInfoWindow.minimizedHeight, healthInfoWindow:getHeight() - removeHeight))
end

function setHealthTooltip(tooltip)
    healthTooltip = tooltip

    local localPlayer = g_game.getLocalPlayer()
    if localPlayer then
        healthBar:setTooltip(tr(healthTooltip, localPlayer:getHealth(), localPlayer:getMaxHealth()))
    end
end

function setEneryTooltip(tooltip)
    energyTooltip = tooltip
    local localPlayer = g_game.getLocalPlayer()
    if localPlayer then
        energyBar:setTooltip(tr(energyTooltip, localPlayer:getEnergy(), localPlayer:getMaxEnergy()))
    end
end

function setManaTooltip(tooltip)
    manaTooltip = tooltip
    local localPlayer = g_game.getLocalPlayer()
    if localPlayer then
        manaBar:setTooltip(tr(manaTooltip, localPlayer:getMana(), localPlayer:getMaxMana()))
    end
end

function setExperienceTooltip(tooltip)
    experienceTooltip = tooltip
    local localPlayer = g_game.getLocalPlayer()
    if localPlayer then
        experienceBar:setTooltip(tr(experienceTooltip, localPlayer:getLevelPercent(), localPlayer:getLevel() + 1))
    end
end
