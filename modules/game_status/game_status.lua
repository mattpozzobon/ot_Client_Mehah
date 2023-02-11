topBarButton = nil
mainWindow = nil

primary_cost = 1
secondary_cost = 1

points = 0
pointsCalculo = 0
pointsToRemove = 0
str = 0
strToAdd = 0
int = 0
intToAdd = 0
dex = 0
dexToAdd = 0
wis = 0
wisToAdd = 0
con = 0
conToAdd = 0
luck = 0
luckToAdd = 0

health = 0
healthToAdd = 0
mana = 0
manaToAdd = 0
energy = 0
energyToAdd = 0
speed = 0
speedToAdd = 0
capacity = 0
capacityToAdd = 0
pdamage = 0
pdamageToAdd = 0
mdamage = 0
mdamageToAdd = 0
pdefense = 0
pdefenseToAdd = 0
mdefense = 0
mdefenseToAdd = 0
attackspeed = 0
attackspeedToAdd = 0
dodge = 0
dodgeToAdd = 0
cooldown = 0
cooldownToAdd = 0
critical = 0
criticalToAdd = 0

--str
local widget_str_toAdd = nil
local widget_str_button_remove = nil
--dex
local widget_dex_toAdd = nil
local widget_dex_button_remove = nil
--int
local widget_int_toAdd = nil
local widget_int_button_remove = nil
--wis
local widget_wis_toAdd = nil
local widget_wis_button_remove = nil
--con
local widget_con_toAdd = nil
local widget_con_button_remove = nil
--luck
local widget_luck_toAdd = nil
local widget_luck_button_remove = nil
----
local widget_points_remove = nil

------------------------------------------------------
local conversion = { str_pdamage = 5, str_energy = 5, dex_attackspeed = 5, dex_pdefense = 5, int_mdamage = 5, int_mana = 5, wis_mdefense = 5, wis_cooldown = 5, con_health = 5, con_speed = 5, luck_dodge = 5, luck_critical = 5}
local label_health = nil
local label_health_extra = nil
local label_energy = nil
local label_mana = nil
local label_mana_extra = nil
local label_energy_extra = nil 	
local label_speed =  nil
local label_speed_extra = nil
local label_capacity = nil
local label_capacity_extra = nil
local label_pdamage = nil	
local label_pdamage_extra = nil
local label_mdamage = nil
local label_mdamage_extra = nil
local label_pdefense = nil		
local label_pdefense_extra = nil
local label_mdefense = nil
local label_mdefense_extra = nil
local label_attackspeed = nil	
local label_attackspeed_extra= nil
local label_dodge = nil	
local label_dodge_extra = nil
local label_cooldown = nil
local label_cooldown_extra = nil
local label_critical = nil
local label_critical_extra = nil

function init()	
	ProtocolGame.registerExtendedOpcode(100, onReceive)
	
	topBarButton = modules.client_topmenu.addRightToggleButton('topBarButton', tr('Status') .. ' (Ctrl+S)', '/game_status/skills', toggle)
	mainWindow = g_ui.displayUI('game_status')
	turn_off()
	g_keyboard.bindKeyDown('Ctrl+S', toggle)
	
	widget_str_toAdd = 		mainWindow:recursiveGetChildById('str_points_to_add')
	widget_str_button_remove = mainWindow:recursiveGetChildById('str_remove')

	widget_dex_toAdd = 		mainWindow:recursiveGetChildById('dex_points_to_add')
	widget_dex_button_remove = mainWindow:recursiveGetChildById('dex_remove')

	widget_int_toAdd = 		mainWindow:recursiveGetChildById('int_points_to_add')
	widget_int_button_remove = mainWindow:recursiveGetChildById('int_remove')

	widget_wis_toAdd = 		mainWindow:recursiveGetChildById('wis_points_to_add')
	widget_wis_button_remove = mainWindow:recursiveGetChildById('wis_remove')

	widget_con_toAdd = 		mainWindow:recursiveGetChildById('con_points_to_add')
	widget_con_button_remove = mainWindow:recursiveGetChildById('con_remove')

	widget_luck_toAdd = 	mainWindow:recursiveGetChildById('luck_points_to_add')
	widget_luck_button_remove = mainWindow:recursiveGetChildById('luck_remove')
	
	label_health =  		mainWindow:recursiveGetChildById('health_value')
	label_health_extra =  	mainWindow:recursiveGetChildById('health_add')
	
	label_energy =  		mainWindow:recursiveGetChildById('energy_value')
	label_energy_extra =  	mainWindow:recursiveGetChildById('energy_add')
	
	label_mana =  			mainWindow:recursiveGetChildById('mana_value')
	label_mana_extra =  	mainWindow:recursiveGetChildById('mana_add')
	
	label_speed =  			mainWindow:recursiveGetChildById('speed_value')
	label_speed_extra =  	mainWindow:recursiveGetChildById('speed_add')
	
	label_capacity =  		mainWindow:recursiveGetChildById('capacity_value')
	label_capacity_extra =  mainWindow:recursiveGetChildById('capacity_add')

	label_pdamage =  		mainWindow:recursiveGetChildById('pdamage_value')
	label_pdamage_extra =  	mainWindow:recursiveGetChildById('pdamage_add')
	
	label_mdamage =  		mainWindow:recursiveGetChildById('mdamage_value')
	label_mdamage_extra =  	mainWindow:recursiveGetChildById('mdamage_add')
	
	label_pdefense =  		mainWindow:recursiveGetChildById('pdefense_value')
	label_pdefense_extra =  mainWindow:recursiveGetChildById('pdefense_add')

	label_mdefense =  		mainWindow:recursiveGetChildById('mdefense_value')
	label_mdefense_extra =  mainWindow:recursiveGetChildById('mdefense_add')

	label_attackspeed =  	mainWindow:recursiveGetChildById('attackspeed_value')
	label_attackspeed_extra=mainWindow:recursiveGetChildById('attackspeed_add')

	label_dodge =  			mainWindow:recursiveGetChildById('dodge_value')
	label_dodge_extra =  	mainWindow:recursiveGetChildById('dodge_add')

	label_cooldown =  		mainWindow:recursiveGetChildById('cooldown_value')
	label_cooldown_extra =  mainWindow:recursiveGetChildById('cooldown_add')
	
	label_critical =  		mainWindow:recursiveGetChildById('critical_value')
	label_critical_extra =  mainWindow:recursiveGetChildById('critical_add')
	
	--button
	confirm_button = 		mainWindow:recursiveGetChildById('confirm')
	cancel_button = 		mainWindow:recursiveGetChildById('cancel')
	--points
	widget_points_remove = 	mainWindow:recursiveGetChildById('total_points_label_remove')

	
	connect(g_game, {
		onGameStart = onStart,
		onGameEnd = turn_off	
	})
	
end

function onStart() 
	cancel()
	turn_on()
	askForInfo()
end


function terminate()
  ProtocolGame.unregisterExtendedOpcode(100, onReceive)
  topBarButton:destroy()
  mainWindow:destroy()
end

function turn_off()
	topBarButton:setVisible(false)
	mainWindow:setVisible(false)
end

function turn_on()
  topBarButton:setVisible(true)
  topBarButton:setOn(false)
  mainWindow:setVisible(false)
  confirm_button:setVisible(false)
  cancel_button:setVisible(false)
end

function toggle_on()
	mainWindow:setVisible(true)
    topBarButton:setOn(true)
end

function toggle_off()
	mainWindow:setVisible(false)
    topBarButton:setOn(false)
end


function toggle()
  if topBarButton:isVisible() then
	  if topBarButton:isOn() then
		toggle_off()
	  else
		toggle_on()
		mainWindow:focus()
	  end
  end
end


----------------------------------------------------------------------------------------------function melon()
function askForInfo()
	local protocolGame = g_game.getProtocolGame()
	if protocolGame then
		protocolGame:sendExtendedOpcode(100, json.encode({code = 1}))
	end
end

function update()

	if strToAdd > 0 then
		widget_str_toAdd:setVisible(true)
		widget_str_toAdd:setText("+"..strToAdd)
		widget_str_toAdd:setColor("green")
		widget_str_button_remove:setVisible(true)
		label_energy_extra:setVisible(true)
		label_pdamage_extra:setVisible(true)
		label_energy_extra:setText("+"..energyToAdd)
		label_energy_extra:setColor("green")
		label_pdamage_extra:setText("+"..pdamageToAdd)
		label_pdamage_extra:setColor("green")
	else
		label_energy_extra:setVisible(false)
		label_pdamage_extra:setVisible(false)
		widget_str_toAdd:setVisible(false)
		widget_str_button_remove:setVisible(false)
	end
	
	if dexToAdd > 0 then
		widget_dex_toAdd:setVisible(true)
		widget_dex_toAdd:setText("+"..dexToAdd)
		widget_dex_toAdd:setColor("green")
		widget_dex_button_remove:setVisible(true)
		label_pdefense_extra:setVisible(true)
		label_pdefense_extra:setText("+"..pdefenseToAdd)
		label_pdefense_extra:setColor("green")
		label_attackspeed_extra:setVisible(true)
		label_attackspeed_extra:setText("+"..attackspeedToAdd)
		label_attackspeed_extra:setColor("green")
	else
		label_pdefense_extra:setVisible(false)
		label_attackspeed_extra:setVisible(false)
		widget_dex_toAdd:setVisible(false)
		widget_dex_button_remove:setVisible(false)
	end
	
	if intToAdd > 0 then
		widget_int_toAdd:setVisible(true)
		widget_int_toAdd:setText("+"..intToAdd)
		widget_int_toAdd:setColor("green")
		widget_int_button_remove:setVisible(true)
		
		label_mdamage_extra:setVisible(true)
		label_mdamage_extra:setText("+"..mdamageToAdd)
		label_mdamage_extra:setColor("green")
		label_mana_extra:setVisible(true)
		label_mana_extra:setText("+"..manaToAdd)
		label_mana_extra:setColor("green")
	else
		label_mdamage_extra:setVisible(false)
		label_mana_extra:setVisible(false)
		widget_int_toAdd:setVisible(false)
		widget_int_button_remove:setVisible(false)
	end
	
	if wisToAdd > 0 then
		widget_wis_toAdd:setVisible(true)
		widget_wis_toAdd:setText("+"..wisToAdd)
		widget_wis_toAdd:setColor("green")
		widget_wis_button_remove:setVisible(true)
		label_cooldown_extra:setVisible(true)
		label_cooldown_extra:setText("+"..cooldownToAdd)
		label_cooldown_extra:setColor("green")
		label_mdefense_extra:setVisible(true)
		label_mdefense_extra:setText("+"..mdefenseToAdd)
		label_mdefense_extra:setColor("green")
	else
		label_cooldown_extra:setVisible(false)
		label_mdefense_extra:setVisible(false)
		widget_wis_toAdd:setVisible(false)
		widget_wis_button_remove:setVisible(false)
	end
	
	if conToAdd > 0 then
		widget_con_toAdd:setVisible(true)
		widget_con_toAdd:setText("+"..conToAdd)
		widget_con_toAdd:setColor("green")
		widget_con_button_remove:setVisible(true)
		label_health_extra:setVisible(true)
		label_health_extra:setText("+"..healthToAdd)
		label_health_extra:setColor("green")
		label_speed_extra:setVisible(true)
		label_speed_extra:setText("+"..speedToAdd)
		label_speed_extra:setColor("green")
	else
		label_health_extra:setVisible(false)
		label_speed_extra:setVisible(false)
		widget_con_toAdd:setVisible(false)
		widget_con_button_remove:setVisible(false)
	end
	
	if luckToAdd > 0 then
		widget_luck_toAdd:setVisible(true)
		widget_luck_toAdd:setText("+"..luckToAdd)
		widget_luck_toAdd:setColor("green")
		widget_luck_button_remove:setVisible(true)
		label_dodge_extra:setVisible(true)
		label_dodge_extra:setText("+"..dodgeToAdd)
		label_dodge_extra:setColor("green")
		label_critical_extra:setVisible(true)
		label_critical_extra:setText("+"..criticalToAdd)
		label_critical_extra:setColor("green")
	else
		label_critical_extra:setVisible(false)
		label_dodge_extra:setVisible(false)
		widget_luck_toAdd:setVisible(false)
		widget_luck_button_remove:setVisible(false)
	end
	
	if pointsToRemove >= 1 then
		widget_points_remove:setVisible(true)
		widget_points_remove:setText("-"..pointsToRemove)
		widget_points_remove:setColor("red")
		
		confirm_button:setVisible(true)
		cancel_button:setVisible(true)
	else
		widget_points_remove:setVisible(false)
		
		confirm_button:setVisible(false)
		cancel_button:setVisible(false)
	end
end

function basicAdd(x)
	if pointsCalculo >= x then
		pointsCalculo = pointsCalculo - x
		pointsToRemove = pointsToRemove + x
		return true
	end
	return false
end

function basicRemove(x)
	pointsCalculo = pointsCalculo + primary_cost
	pointsToRemove = pointsToRemove - primary_cost
	update()
end

function add_str()
	if basicAdd(primary_cost) then
		strToAdd = strToAdd + 1
		energyToAdd = energyToAdd + conversion.str_energy
		pdamageToAdd = pdamageToAdd + conversion.str_pdamage
		update()
	end
end

function add_int()
	if basicAdd(primary_cost) then
		intToAdd = intToAdd + 1
		mdamageToAdd = mdamageToAdd + conversion.int_mdamage
		manaToAdd = manaToAdd + conversion.int_mana
		update()
	end
end

function add_wis()
	if basicAdd(primary_cost) then
		wisToAdd = wisToAdd + 1
		cooldownToAdd = cooldownToAdd + conversion.wis_cooldown
		mdefenseToAdd = mdefenseToAdd + conversion.wis_mdefense
		update()
	end
end

function add_con()
	if basicAdd(primary_cost) then
		conToAdd = conToAdd + 1
		healthToAdd = healthToAdd + conversion.con_health
		speedToAdd = speedToAdd + conversion.con_speed
		update()
	end
end

function add_luck()
	if basicAdd(primary_cost) then
		luckToAdd = luckToAdd + 1
		dodgeToAdd = dodgeToAdd + conversion.luck_dodge
		criticalToAdd = criticalToAdd + conversion.luck_critical
		update()
	end
end

function add_dex()
	if basicAdd(primary_cost) then
		dexToAdd = dexToAdd + 1
		attackspeedToAdd = attackspeedToAdd + conversion.dex_attackspeed
		pdefenseToAdd = pdefenseToAdd + conversion.dex_pdefense
		update()
	end
end

function remove_luck()
	luckToAdd = luckToAdd - 1
	dodgeToAdd = dodgeToAdd - conversion.luck_dodge
	criticalToAdd = criticalToAdd - conversion.luck_critical
	basicRemove(primary_cost)
end

function remove_con()
	conToAdd = conToAdd - 1
	healthToAdd = healthToAdd - conversion.con_health
	speedToAdd = speedToAdd - conversion.con_speed
	basicRemove(primary_cost)
end

function remove_wis()
	wisToAdd = wisToAdd - 1
	cooldownToAdd = cooldownToAdd - conversion.wis_cooldown
	mdefenseToAdd = mdefenseToAdd - conversion.wis_mdefense
	basicRemove(primary_cost)
end

function remove_int()
	intToAdd = intToAdd - 1
	mdamageToAdd = mdamageToAdd - conversion.int_mdamage
	manaToAdd = manaToAdd - conversion.int_mana
	basicRemove(primary_cost)
end

function remove_dex()
	dexToAdd = dexToAdd - 1
	attackspeedToAdd = attackspeedToAdd - conversion.dex_attackspeed
	pdefenseToAdd = pdefenseToAdd - conversion.dex_pdefense
	basicRemove(primary_cost)
end

function remove_str()
	strToAdd = strToAdd - 1
	energyToAdd = energyToAdd - conversion.str_energy
	pdamageToAdd = pdamageToAdd - conversion.str_pdamage
	basicRemove(primary_cost)
end

function cancel()
	reset()
end


function confirm()
	local protocolGame = g_game.getProtocolGame()
	if protocolGame then
		data = {
			code = 5,
			points = pointsToRemove,
			str = strToAdd,			
			dex = dexToAdd, 
			int = intToAdd,
			con = conToAdd,
			wis = wisToAdd,
			luck = luckToAdd,
		}
	
		protocolGame:sendExtendedOpcode(100, json.encode(data))
		reset()
	end
end

function reset()
	pointsCalculo = points
	pointsToRemove = 0
	strToAdd = 0
	intToAdd = 0
	dexToAdd = 0
	conToAdd = 0
	wisToAdd = 0
	luckToAdd = 0
	healthToAdd = 0
	manaToAdd = 0
	energyToAdd = 0
	speedToAdd = 0
	capacityToAdd = 0
	pdamageToAdd = 0
	mdamageToAdd = 0
	pdefenseToAdd = 0
	mdefenseToAdd = 0
	attackspeedToAdd = 0
	dodgeToAdd = 0
	cooldownToAdd = 0
	criticalToAdd = 0
	update()
end

function showAddButton(x)
	if x > 0 then
		str = mainWindow:recursiveGetChildById('str_add'):setVisible(true)
		dex = mainWindow:recursiveGetChildById('dex_add'):setVisible(true)
		int = mainWindow:recursiveGetChildById('int_add'):setVisible(true)
		con = mainWindow:recursiveGetChildById('con_add'):setVisible(true)
		wis = mainWindow:recursiveGetChildById('wis_add'):setVisible(true)
		luck = mainWindow:recursiveGetChildById('luck_add'):setVisible(true)
	else
		str = mainWindow:recursiveGetChildById('str_add'):setVisible(false)
		dex = mainWindow:recursiveGetChildById('dex_add'):setVisible(false)
		int = mainWindow:recursiveGetChildById('int_add'):setVisible(false)
		con = mainWindow:recursiveGetChildById('con_add'):setVisible(false)
		wis = mainWindow:recursiveGetChildById('wis_add'):setVisible(false)
		luck = mainWindow:recursiveGetChildById('luck_add'):setVisible(false)
	end
end

function onReceive(protocol, opcode, buffer)
    local player = g_game.getLocalPlayer()
    if not player then return end
    local status, json_data = pcall(function()return json.decode(buffer)end)
    if not status then return false end
	
	if json_data.code == 1 then
	
		
		print("Points: ".. json_data.points )
		local getWidget = mainWindow:recursiveGetChildById('total_points_label')
		points = json_data.points
		pointsCalculo = json_data.points
		getWidget:setText(points)
		showAddButton(points)
		
		print("str: ".. json_data.str )
		local getWidget = mainWindow:recursiveGetChildById('str_points')
		str = json_data.str
		getWidget:setText(str)
		
		print("dex: ".. json_data.dex )
		local getWidget = mainWindow:recursiveGetChildById('dex_points')
		dex = json_data.dex
		getWidget:setText(json_data.dex)
		
		print("int: ".. json_data.int )
		local getWidget = mainWindow:recursiveGetChildById('int_points')
		int = json_data.int
		getWidget:setText(int)
		
		print("con: ".. json_data.con )
		local getWidget = mainWindow:recursiveGetChildById('con_points')
		con = json_data.con
		getWidget:setText(con)
		
		print("wis: ".. json_data.wis )
		local getWidget = mainWindow:recursiveGetChildById('wis_points')
		wis = json_data.wis
		getWidget:setText(wis)
		
		print("luck: ".. json_data.luck )
		local getWidget = mainWindow:recursiveGetChildById('luck_points')
		luck = json_data.luck
		getWidget:setText(luck)
	end
end