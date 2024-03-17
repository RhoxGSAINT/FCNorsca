local icefang_faction = "wh_dlc08_nor_vanaheimlings"

local storm_duration = 3

local rhox_drenok_faction_list={
    wh_dlc08_nor_vanaheimlings=true
}

core:add_listener(
	"icefang_garrison_occupied_even",
	"GarrisonOccupiedEvent",
	function(context)
		local faction = context:character():faction();
		local settlement = context:garrison_residence():settlement_interface()
		
		if not settlement then
            return false
		end
		local climate = settlement:get_climate()
		return faction:name() == icefang_faction and (climate=="climate_frozen" or climate=="climate_chaotic")
	end,
	function(context)
		local character = context:character()
		cm:create_storm_for_region(character:region():name(), 1, storm_duration, "ksl_winter");
		cm:apply_effect_bundle_to_region("rhox_icefang_region_winter_storm", character:region():name(), storm_duration)
	end,
	true
);





core:add_listener(
    "rhox_Beorg_confederation",
    "FactionJoinsConfederation",
    function(context)
        return context:confederation():culture() == "wh_dlc08_nor_norsca" and context:faction():name() == "wh_dlc08_nor_vanaheimlings"
    end,
    function(context)
        if not rhox_drenok_faction_list[context:confederation()] then
            rhox_drenok_faction_list[context:confederation()]= true
            cm:add_unit_to_faction_mercenary_pool(context:confederation(),"dead_drenok_ice_golem","renown",0,100,20,0,"","","",true,"dead_drenok_ice_golem")
            cm:add_unit_to_faction_mercenary_pool(context:confederation(),"dead_drenok_ice_bears","renown",0,100,20,0,"","","",true,"dead_drenok_ice_bears")
            cm:add_unit_to_faction_mercenary_pool(context:confederation(),"dead_drenok_greater_ice_golem","renown",0,100,20,0,"","","",true,"dead_drenok_greater_ice_golem")
        end
    end,
    true
)

core:add_listener(
    "rhox_drenok_CharacterTurnStart",
    "CharacterTurnStart",
    function(context) 
        local character=context:character()--he might have passed to other faction via two confederations
        
        return character:character_subtype_key() == "hkrul_drenok" and not rhox_drenok_faction_list[character:faction():name()]
    end,
    function(context) 
        local character=context:character()--he might have passed to other faction via two confederations
        rhox_drenok_faction_list[character:faction():name()] = true
        cm:add_unit_to_faction_mercenary_pool(character:faction():name(),"dead_drenok_ice_golem","renown",0,100,20,0,"","","",true,"dead_drenok_ice_golem")
        cm:add_unit_to_faction_mercenary_pool(character:faction():name(),"dead_drenok_ice_bears","renown",0,100,20,0,"","","",true,"dead_drenok_ice_bears")
        cm:add_unit_to_faction_mercenary_pool(character:faction():name(),"dead_drenok_greater_ice_golem","renown",0,100,20,0,"","","",true,"dead_drenok_greater_ice_golem")
    end,
    true
)


core:add_listener(
    "rhox_drenok_battle_completed",
    "CharacterCompletedBattle",
    function(context)
        local character = context:character()
        local faction = character:faction()
        local pb = context:pending_battle();
        local base_chance =20
        local bonus_chance = character:bonus_values():scripted_value("rhox_drenok_bonus_chance", "value")

        if character:is_at_sea() or not character:region() or not character:region():settlement() then
            return false
        end
        local climate = character:region():settlement():get_climate()
        return (character:character_subtype_key() == "hkrul_drenok" or faction:name()==icefang_faction) and (climate=="climate_frozen" or climate=="climate_chaotic")
        and pb:has_been_fought() and character:won_battle() and cm:model():random_percent(base_chance+bonus_chance)
    end,
    function(context)
        local character = context:character()
        local faction = character:faction()
        
        
        if faction:is_human() then
            local incident_builder = cm:create_incident_builder("rhox_drenok_ice_unit_incident")
            incident_builder:add_target("default", character)
            local payload_builder = cm:create_payload()
            payload_builder:add_mercenary_to_faction_pool("dead_drenok_ice_golem", 1)  
            payload_builder:add_mercenary_to_faction_pool("dead_drenok_ice_bears", 1)
            payload_builder:add_mercenary_to_faction_pool("dead_drenok_greater_ice_golem", 1)
            incident_builder:set_payload(payload_builder)
            cm:launch_custom_incident_from_builder(incident_builder, faction)
        else
            cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), "dead_drenok_ice_golem", 1)
            cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), "dead_drenok_ice_bears", 1)
            cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), "dead_drenok_greater_ice_golem", 1)
        end
    end,
    true
)




----save/load

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_drenok_faction_list", rhox_drenok_faction_list, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			rhox_drenok_faction_list = cm:load_named_value("rhox_drenok_faction_list", rhox_drenok_faction_list, context)
		end
	end
)