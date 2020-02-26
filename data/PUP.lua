--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- __________.__                                ________                          __               .__.__  __      __  .__    .__           _____.__.__              
-- \______   |  |   ____ _____    ______ ____   \______ \   ____     ____   _____/  |_    ____   __| _|___/  |_  _/  |_|  |__ |__| ______ _/ ____|__|  |   ____      
--  |     ___|  | _/ __ \\__  \  /  ____/ __ \   |    |  \ /  _ \   /    \ /  _ \   __\ _/ __ \ / __ ||  \   __\ \   __|  |  \|  |/  ___/ \   __\|  |  | _/ __ \     
--  |    |   |  |_\  ___/ / __ \_\___ \\  ___/   |    `   (  <_> ) |   |  (  <_> |  |   \  ___// /_/ ||  ||  |    |  | |   Y  |  |\___ \   |  |  |  |  |_\  ___/     
--  |____|   |____/\___  (____  /____  >\___  > /_______  /\____/  |___|  /\____/|__|    \___  \____ ||__||__|    |__| |___|  |__/____  >  |__|  |__|____/\___  > /\ 
--                     \/     \/     \/     \/          \/              \/                   \/     \/                      \/        \/                      \/  \/ 
--
--	Please do not edit this file!							Please do not edit this file!							Please do not edit this file!
--
--	Editing this file will cause you to be unable to use Github Desktop to update!
--
--	Any changes you wish to make in this file you should be able to make by overloading. That is Re-Defining the same variables or functions in another file, by copying and
--	pasting them to a file that is loaded after the original file, all of my library files, and then job files are loaded first.
--	The last files to load are the ones unique to you. User-Globals, Charactername-Globals, Charactername_Job_Gear, in that order, so these changes will take precedence.
--
--	You may wish to "hook" into existing functions, to add functionality without losing access to updates or fixes I make, for example, instead of copying and editing
--	status_change(), you can instead use the function user_status_change() in the same manner, which is called by status_change() if it exists, most of the important 
--  gearswap functions work like this in my files, and if it's unique to a specific job, user_job_status_change() would be appropriate instead.
--
--  Variables and tables can be easily redefined just by defining them in one of the later loaded files: autofood = 'Miso Ramen' for example.
--  States can be redefined as well: state.HybridMode:options('Normal','PDT') though most of these are already redefined in the gear files for editing there.
--	Commands can be added easily with: user_self_command(commandArgs, eventArgs) or user_job_self_command(commandArgs, eventArgs)
--
--	If you're not sure where is appropriate to copy and paste variables, tables and functions to make changes or add them:
--		User-Globals.lua - 			This file loads with all characters, all jobs, so it's ideal for settings and rules you want to be the same no matter what.
--		Charactername-Globals.lua -	This file loads with one character, all jobs, so it's ideal for gear settings that are usable on all jobs, but unique to this character.
--		Charactername_Job_Gear.lua-	This file loads only on one character, one job, so it's ideal for things that are specific only to that job and character.
--
--
--	If you still need help, feel free to contact me on discord or ask in my chat for help: https://discord.gg/ug6xtvQ
--  !Please do NOT message me in game about anything third party related, though you're welcome to message me there and ask me to talk on another medium.
--
--  Please do not edit this file!							Please do not edit this file!							Please do not edit this file!
-- __________.__                                ________                          __               .__.__  __      __  .__    .__           _____.__.__              
-- \______   |  |   ____ _____    ______ ____   \______ \   ____     ____   _____/  |_    ____   __| _|___/  |_  _/  |_|  |__ |__| ______ _/ ____|__|  |   ____      
--  |     ___|  | _/ __ \\__  \  /  ____/ __ \   |    |  \ /  _ \   /    \ /  _ \   __\ _/ __ \ / __ ||  \   __\ \   __|  |  \|  |/  ___/ \   __\|  |  | _/ __ \     
--  |    |   |  |_\  ___/ / __ \_\___ \\  ___/   |    `   (  <_> ) |   |  (  <_> |  |   \  ___// /_/ ||  ||  |    |  | |   Y  |  |\___ \   |  |  |  |  |_\  ___/     
--  |____|   |____/\___  (____  /____  >\___  > /_______  /\____/  |___|  /\____/|__|    \___  \____ ||__||__|    |__| |___|  |__/____  >  |__|  |__|____/\___  > /\ 
--                     \/     \/     \/     \/          \/              \/                   \/     \/                      \/        \/                      \/  \/ 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    -- Load and initialize the include file.
    include('Sel-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()

	state.Buff['Aftermath: Lv.3'] = buffactive['Aftermath: Lv.3'] or false

    -- List of pet weaponskills to check for
    petWeaponskills = S{"Slapstick", "Knockout", "Magic Mortar",
        "Chimera Ripper", "String Clipper",  "Cannibal Blade", "Bone Crusher", "String Shredder",
        "Arcuballista", "Daze", "Armor Piercer", "Armor Shatterer"}

    -- Map automaton heads to combat roles

	state.PartyChatWS = M(false, 'Report pet weaponskills in party chat.')

    -- Subset of modes that use magic
    magicPetModes = S{'Nuke','Heal','Magic'}

    -- Var to track the current pet mode.
    state.PetMode = M{['description']='Pet Mode', 'None','Melee','Ranged','HybridRanged','Tank','LightTank','Magic','Heal','Nuke'}

	state.AutoManeuvers = M{['description']='Pet Mode', 'Default','Melee','Ranged','HybridRanged','Tank','LightTank','Magic','Heal','Nuke'}
	state.AutoPuppetMode = M(false, 'Auto Puppet Mode')
	state.AutoRepairMode = M(true, 'Auto Repair Mode')
	state.AutoDeployMode = M(true, 'Auto Deploy Mode')
	state.AutoPetMode 	 = M(true, 'Auto Pet Mode')
	state.PetWSGear		 = M(true, 'Pet WS Gear')
	state.PetEnmityGear	 = M(true, 'Pet Enmity Gear')

    autows = "Victory Smite"
	autofood = 'Akamochi'
	lastpettp = 0
	deactivatehpp = 100
	repairhpp = 45
	PupFlashReady = 0
	PupVokeReady = 0
	PupFlashRecast = 38
	PupVokeRecast = 23

	update_pet_mode()
	update_melee_groups()
	init_job_states({"Capacity","AutoPuppetMode","PetWSGear","AutoRepairMode","AutoRuneMode","AutoTrustMode","AutoWSMode","AutoShadowMode","AutoFoodMode","AutoStunMode","AutoDefenseMode",},{"AutoBuffMode","AutoSambaMode","Weapons","OffenseMode","WeaponskillMode","IdleMode","Passive","RuneElement","TreasureMode",})
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events. 
-------------------------------------------------------------------------------------------------------------------
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.

function job_filtered_action(spell, eventArgs)

end

function job_pretarget(spell, spellMap, eventArgs)

end

function job_precast(spell, spellMap, eventArgs)

end

function job_post_precast(spell, spellMap, eventArgs)
	if spell.type == 'WeaponSkill' then
		local WSset = standardize_set(get_precast_set(spell, spellMap))
		local wsacc = check_ws_acc()
		
		if (WSset.ear1 == "Moonshade Earring" or WSset.ear2 == "Moonshade Earring") then
			-- Replace Moonshade Earring if we're at cap TP
			if get_effective_player_tp(spell, WSset) > 3200 then
				if wsacc:contains('Acc') and not buffactive['Sneak Attack'] and sets.AccMaxTP then
					equip(sets.AccMaxTP[spell.english] or sets.AccMaxTP)
				elseif sets.MaxTP then
					equip(sets.MaxTP[spell.english] or sets.MaxTP)
				else
				end
			end
		end
	end
end

-- Called when pet is about to perform an action
function job_pet_midcast(spell, spellMap, eventArgs)
--[[ Not working due to delay, preserving in case it does in the future.
    if petWeaponskills:contains(spell.english) then
        classes.CustomClass = "Weaponskill"

		if sets.midcast.Pet.WeaponSkill[spell] then
			equip(sets.midcast.Pet.WeaponSkill[spell.english])
		else
			equip(sets.midcast.Pet.WeaponSkill)
		end
    end
]]
end

windower.raw_register_event('action', function(act)
	if pet.isvalid and pet.id == act.actor_id then
		if act.category == 11 then
			if act.param == 1945 then
				PupVokeReady = os.clock() +	PupVokeRecast
			elseif act.param == 1947 then
				PupFlashReady = os.clock() + PupFlashRecast
			end
			send_command('gs c forceequip')
		end
	end
end)

function job_pet_aftercast(spell, spellMap, eventArgs)
	if petWeaponskills:contains(spell.english) then
		if state.PartyChatWS.value then
			windower.chat.input('/p '..auto_translate('Automaton')..' '..auto_translate('Weapon Skill')..' '..spell.english..'')
		end
    end
end

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	update_melee_groups()
end

-- Called when a player gains or loses a pet.
-- pet == pet gained or lost
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(pet, gain)
    update_pet_mode()
end

-- Called when the pet's status changes.
function job_status_change(newStatus, oldStatus, eventArgs)
	if newStatus == "Engaged" and pet.isvalid and pet.status == "Idle" and player.target.type == "MONSTER" and state.AutoDeployMode.value and player.target.distance < 20 then
		windower.chat.input('/pet Deploy <t>')
	end

--[[
    if newStatus == 'Engaged' then
        display_pet_status()
    end
]]--
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	update_melee_groups()
end


-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    display_pet_status()
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
	if  default_spell_map == 'Cure' or default_spell_map == 'Curaga'  then
		if world.weather_element == 'Light' then
                return 'LightWeatherCure'
		elseif world.day_element == 'Light' then
                return 'LightDayCure'
        end
	end	
end

function job_customize_idle_set(idleSet)
	if pet.isvalid and pet.status == 'Engaged' and sets.midcast.Pet then
		local now = os.clock()
		if state.PetWSGear.value and pet.tp and pet.tp > 999 then
			if sets.midcast.Pet.PetWSGear and sets.midcast.Pet.PetWSGear[state.PetMode.value] then
				idleSet = set_combine(idleSet, sets.midcast.Pet.PetWSGear[state.PetMode.value])
			elseif sets.midcast.Pet.PetWSGear then
				idleSet = set_combine(idleSet, sets.midcast.Pet.PetWSGear)
			end
		elseif state.PetEnmityGear.value and sets.midcast.Pet.PetEnmityGear and ((PupFlashReady < now and buffactive['Light Maneuver']) or (PupVokeReady < now and buffactive['Fire Maneuver'])) then
			idleSet = set_combine(idleSet, sets.midcast.Pet.PetEnmityGear)
		elseif sets.idle.Pet.Engaged[state.PetMode.value] then
			idleSet = set_combine(idleSet, sets.idle.Pet.Engaged[state.PetMode.value])
		else
			idleSet = set_combine(idleSet, sets.idle.Pet.Engaged)
		end
	elseif  mageJobs:contains(player.sub_job) then
		if player.mpp < 51 and (state.IdleMode.value == 'Normal' or state.IdleMode.value:contains('Sphere')) then
			if sets.latent_refresh then
				idleSet = set_combine(idleSet, sets.latent_refresh)
			end
		end
	end
	return idleSet
end

function job_customize_melee_set(meleeSet)
	if pet.isvalid and pet.status == 'Engaged' and sets.midcast.Pet then
		local now = os.clock()
		if state.PetWSGear.value and pet.tp and pet.tp > 999 and player.tp < 999 and sets.midcast.Pet and sets.midcast.Pet.PetWSGear then
			if sets.midcast.Pet.PetWSGear[state.PetMode.value] then
				meleeSet = set_combine(meleeSet, sets.midcast.Pet.PetWSGear[state.PetMode.value])
			else
				meleeSet = set_combine(meleeSet, sets.midcast.Pet.PetWSGear)
			end
		elseif state.PetEnmityGear.value and sets.midcast.Pet.PetEnmityGear and ((PupFlashReady < now and buffactive['Light Maneuver']) or (PupVokeReady < now and buffactive['Fire Maneuver'])) then
			meleeSet = set_combine(meleeSet, sets.midcast.Pet.PetEnmityGear)
		end
	end
	
    return meleeSet
end
-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(commandArgs, eventArgs)
	if commandArgs[1] == 'maneuver' then
		if pet.isvalid then
			if commandArgs[2] == nil then
				for i = 1,8 do
					local maneuver = defaultManeuvers[state.PetMode.Value][i]
					if maneuver then
						local maneuversActive = buffactive[maneuver.Name] or 0
						if maneuversActive < maneuver.Amount then
							windower.chat.input('/pet "'..maneuver.Name..'" <me>')
							return
						end
					else
						return
					end
				end
				add_to_chat(123,'Current Maneuvers match Default')
			elseif S{'1','2','3','4','5','6','7','8'}:contains(commandArgs[2]) then
				if defaultManeuvers[state.PetMode.Value][tonumber(commandArgs[2])] then
					windower.chat.input('/pet "'..defaultManeuvers[state.PetMode.Value][tonumber(commandArgs[2])].Name..'" <me>')
				else
					add_to_chat(123,'Error: You don\'t have that many maneuvers listed.')
				end
			else
				add_to_chat(123,'Error: Maneuver command format is wrong.')
			end
        else
            add_to_chat(123,'Error: No valid pet.')
        end
    end
end

function job_tick()
	if check_repair() then return true end
	if check_auto_pet() then return true end
	if check_maneuver() then return true end

	if state.PetWSGear.value and pet.isvalid and pet.tp and pet.tp ~= lastpettp then
		if (pet.tp > 999 and lastpettp < 1000) or (pet.tp < 1000 and lastpettp > 999) then
			windower.send_command('gs c update')
		end
		lastpettp = pet.tp
	end

	return false
end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Get the pet mode value based on the equipped frame of the automaton.
-- Returns nil if pet is not valid.
function update_pet_mode()
	if pet.isvalid and state.AutoPetMode.value then
		state.PetMode:set(get_pet_mode())
	end
	
	update_custom_groups()
end

function get_pet_mode()
	if pet.frame == 'Sharpshot Frame' then
		if pet.head == 'Valoredge Head' or pet.head == 'Harlequin Head' then
			return 'HybridRanged'
		else
			return 'Ranged'
		end
	elseif pet.frame == 'Valoredge Frame' then
		if pet.head == 'Soulsoother Head' then
			return 'Tank'
		else
			return 'Melee'
		end
	elseif pet.head == 'Sharpshot Head' or pet.head == 'Stormwaker Head' then
		return 'Magic'
	elseif pet.head == 'Spiritreaver Head' then
		return 'Nuke'
	elseif pet.frame == 'Harlequin Frame' then
		if pet.head == 'Harlequin Head' then
			return 'Melee'
		else
			return 'LightTank'
		end
	else
			if pet.head == 'Soulsoother Head' then
				return 'Heal'
			elseif pet.head == 'Valoredge Head' then
				return 'Melee'
			else
				return 'Magic'
			end
	end
end

-- Update custom groups based on the current pet.
function update_custom_groups()
    classes.CustomIdleGroups:clear()
    if pet.isvalid then
        classes.CustomIdleGroups:append(state.PetMode.value)
    end
end

-- Display current pet status.
function display_pet_status()
    if pet.isvalid then
        local petInfoString = pet.name..' ['..pet.head..']['..pet.frame..']('..state.PetMode.Value..'): '..tostring(pet.status)..'  TP='..tostring(pet.tp)..'  HP%='..tostring(pet.hpp)

        if magicPetModes:contains(state.PetMode.value) then
            petInfoString = petInfoString..'  MP%='..tostring(pet.mpp)
        end

        add_to_chat(122,petInfoString)
    end
end

function update_melee_groups()
	if player.equipment.main then
		classes.CustomMeleeGroups:clear()

		if player.equipment.main == "Kenkonken" and state.Buff['Aftermath: Lv.3'] then
				classes.CustomMeleeGroups:append('AM')
		end
	end
end

function check_auto_pet()

	if not state.AutoPuppetMode.value or areas.Cities:contains(world.area) then return false end

	local abil_recasts = windower.ffxi.get_ability_recasts()

	if not pet.isvalid then

		if abil_recasts[205] < latency then
			windower.chat.input('/ja "Activate" <me>')
			tickdelay = os.clock() + 1.1
			return true
		elseif abil_recasts[115] < latency then
			windower.chat.input('/ja "Deus Ex Automata" <me>')
			tickdelay = os.clock() + 1.1
			return true
		end

	elseif pet.status == "Idle" then
		if pet.max_mp > 50 and pet.mpp < 10 and pet.hpp >= deactivatehpp and abil_recasts[208] < latency then
			windower.chat.input('/pet "Deactivate" <me>')
			tickdelay = os.clock() + 1.1
			return true
		elseif player.target.type == "MONSTER" and abil_recasts[207] < latency then
			windower.chat.input('/pet "Deploy" <t>')
			tickdelay = os.clock() + 1.1
			return true
		end
	end

	return false
end

function check_repair()

	if state.AutoRepairMode.value and pet.isvalid and pet.hpp < repairhpp then
		local abil_recasts = windower.ffxi.get_ability_recasts()

		if abil_recasts[206] < latency and item_available('Automat. Oil +3') then
			windower.chat.input('/ja "Repair" <me>')
			tickdelay = os.clock() + 1.1
			return true
		end
	end

	return false
end

function check_maneuver()
    if state.AutoBuffMode.value ~= 'Off' and pet.isvalid and pet.status == 'Engaged' and windower.ffxi.get_ability_recasts()[210] < latency then
        for i = 1,8 do
			local maneuver
			if state.AutoManeuvers.value == 'Default' then
				maneuver = defaultManeuvers[state.PetMode.Value][i]
			else
				maneuver = defaultManeuvers[state.AutoManeuvers.value][i]
			end
            if maneuver then
                local maneuversActive = buffactive[maneuver.Name] or 0
                if maneuversActive < maneuver.Amount then
                    windower.chat.input('/pet "'..maneuver.Name..'" <me>')
                    tickdelay = os.clock() + 1.1
                    return true
                end
			else
				return false
            end
        end
    end

	return false
end

function job_aftercast(spell, spellMap, eventArgs)
	if pet_midaction() or spell.english == 'Activate' or spell.english == 'Deus Ex Automata' then
		eventArgs.handled = true
	end
end
