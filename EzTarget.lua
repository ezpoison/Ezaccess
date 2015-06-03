
function OnLoad()
    RebornLoaded, RevampedLoaded, MMALoaded, SxOrbLoaded, SOWLoaded = false, false, false, false, false
	-- Set Target Selector
	TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, 850, DAMAGE_MAGIC, true)
	TargetSelector.name = "Custom Target Selector"
	
	Menu = scriptConfig("EzTarget", "EzTarget")
	Menu:addTS(TargetSelector)
    Menu:addSubMenu("Drawings", "Drawings")
    --Target Drawing
	Menu.Drawings:addParam("Target", "Draw Circle on Target", SCRIPT_PARAM_ONOFF, true)
	
	--SAC Orbwalk Target Support
	DelayAction(Orbwalk, 1)
end

function OnDraw()
	if Menu.Drawings.Target and _G.EzTarget ~= nil then
		DrawCircle(_G.EzTarget.x, _G.EzTarget.y, _G.EzTarget.z, 80, ARGB(255, 10, 255, 10))
	end
end

function OnTick()
	_G.EzTarget = GetTarget()
	if _G.Reborn_Initialised then
	_G.AutoCarry.Crosshair:ForceTarget(_G.EzTarget)
	end
end

function ScriptMsg(msg)
  print("<font color=\"#daa520\"><b>EzTarget:</b></font> <font color=\"#FFFFFF\">"..msg.."</font>")
end

function Orbwalk()
  if _G.AutoCarry then
    if _G.Reborn_Initialised then
      RebornLoaded = true
      ScriptMsg("Found SAC: Reborn.")
	  _G.AutoCarry.Crosshair:SetSkillCrosshairRange(5000)
    else
      RevampedLoaded = true
      ScriptMsg("Found SAC: Revamped.")
    end
    
  elseif _G.Reborn_Loaded then
    DelayAction(Orbwalk, 1)
  elseif _G.MMA_Loaded then
    MMALoaded = true
    ScriptMsg("Found MMA.")
  else
    ScriptMsg("Orbwalk not founded.")
  end
  
end


function GetTarget()
	if ValidTarget(targetSelected) then
		target = targetSelected
	else
		TargetSelector:update()
		target = TargetSelector.target
	end
	return target
end


function OnWndMsg(msg, key)
	-- // Check if the message is an input from Left mouse button
	if msg == WM_LBUTTONDOWN then
		local enemyDistance, enemySelected = 0, nil
		for _,enemy in pairs(GetEnemyHeroes()) do
			-- // Check if enemy is valid (not death, visible, etc.) and if the distance between enemy and mouse is below 200 units
			if ValidTarget(enemy) and GetDistance(enemy, mousePos) < 200 then 
				-- // Check if the distance between the enemy and mouse is below the distance checked on last enemy or if we don't have any target yet.
				if GetDistance(enemy, mousePos) <= enemyDistance or not enemySelected then
					-- // set new distance to check on next enemy
					enemyDistance = GetDistance(enemy, mousePos)
					-- // Set the target
					enemySelected = enemy
				end
			end
		end
		
		-- // Check if we have a target from last checks.
		if enemySelected then
			-- // check if we don't have a target selected or the target from last check is different from current selected target
			if not targetSelected or targetSelected.hash ~= enemySelected.hash then
				-- // set new target
				targetSelected = enemySelected
			end
		else
			targetSelected = nil
		end
	end
end

