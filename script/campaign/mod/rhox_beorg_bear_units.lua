
local rhox_beorg_ror_list={
    hkrul_bearmen =true,
    hkrul_beorg_bear_sem =true
}

local rhox_beorg_faction_list={
    mixer_nor_beorg=true
}


core:add_listener(
    "Beorg_makes_alliance",
    "PositiveDiplomaticEvent",
    function(context)
        return ((context:recipient():name() =="mixer_nor_beorg" and context:proposer():culture() == "wh_dlc08_nor_norsca") 
        or (context:proposer():name() =="mixer_nor_beorg" and context:recipient():culture() == "wh_dlc08_nor_norsca")) 
        and (context:is_military_alliance() or context:is_defensive_alliance())
    end,
    function(context)
        if context:recipient():name() =="mixer_nor_beorg" then
            for unit_key, _ in pairs(rhox_beorg_ror_list) do
                cm:remove_event_restricted_unit_record_for_faction(unit_key, context:proposer():name())
            end
        else
            for unit_key, _ in pairs(rhox_beorg_ror_list) do
                cm:remove_event_restricted_unit_record_for_faction(unit_key, context:recipient():name())
            end
        end
        
        
    end,
    true
)



core:add_listener(
    "rhox_Beorg_confederation",
    "FactionJoinsConfederation",
    function(context)
        return context:confederation():culture() == "wh_dlc08_nor_norsca" and context:faction():name() == "mixer_nor_beorg"
    end,
    function(context)
        for unit_key, _ in pairs(rhox_beorg_ror_list) do
            cm:remove_event_restricted_unit_record_for_faction(unit_key, context:confederation():name())
        end
        
        if not rhox_beorg_faction_list[context:confederation()] then
            rhox_beorg_faction_list[context:confederation()]= true
            cm:add_unit_to_faction_mercenary_pool(context:confederation(),"hkrul_beorg_brown_feral","renown",0,100,20,0,"","","",true,"hkrul_beorg_brown_feral")
            cm:add_unit_to_faction_mercenary_pool(context:confederation(),"hkrul_beorg_brown_feral_marked","renown",0,100,20,0,"","","",true,"hkrul_beorg_brown_feral_marked")
            cm:add_unit_to_faction_mercenary_pool(context:confederation(),"hkrul_beorg_ice_feral","renown",0,100,20,0,"","","",true,"hkrul_beorg_ice_feral")
        end
    end,
    true
)

core:add_listener(
    "rhox_beorg_CharacterTurnStart",
    "CharacterTurnStart",
    function(context) 
        local character=context:character()--he might have passed to other faction via two confederations
        
        return character:character_subtype_key() == "hkrul_beorg" and not rhox_beorg_faction_list[character:faction():name()]
    end,
    function(context) 
        local character=context:character()--he might have passed to other faction via two confederations
        rhox_beorg_faction_list[character:faction():name()] = true
        cm:add_unit_to_faction_mercenary_pool(character:faction():name(),"hkrul_beorg_brown_feral","renown",0,100,20,0,"","","",true,"hkrul_beorg_brown_feral")
        cm:add_unit_to_faction_mercenary_pool(character:faction():name(),"hkrul_beorg_brown_feral_marked","renown",0,100,20,0,"","","",true,"hkrul_beorg_brown_feral_marked")
        cm:add_unit_to_faction_mercenary_pool(character:faction():name(),"hkrul_beorg_ice_feral","renown",0,100,20,0,"","","",true,"hkrul_beorg_ice_feral")
    end,
    true
)


core:add_listener(
    "rhox_beorg_battle_completed",
    "CharacterCompletedBattle",
    function(context)
        local character = context:character()
        local faction = character:faction()
        local pb = context:pending_battle();
        local base_chance =20
        local bonus_chance = character:bonus_values():scripted_value("rhox_beorg_bonus_chance", "value")

        return character:character_subtype_key() == "hkrul_beorg" and pb:has_been_fought() and character:won_battle() and cm:model():random_percent(base_chance+bonus_chance)
    end,
    function(context)
        local character = context:character()
        local faction = character:faction()
        
        
        if faction:is_human() then
            local incident_builder = cm:create_incident_builder("rhox_beorg_bear_unit_incident")
            incident_builder:add_target("default", character)
            local payload_builder = cm:create_payload()
            payload_builder:add_mercenary_to_faction_pool("hkrul_beorg_brown_feral", 1)  
            payload_builder:add_mercenary_to_faction_pool("hkrul_beorg_brown_feral_marked", 1)
            payload_builder:add_mercenary_to_faction_pool("hkrul_beorg_ice_feral", 1)
            incident_builder:set_payload(payload_builder)
            cm:launch_custom_incident_from_builder(incident_builder, faction)
        else
            cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), "hkrul_beorg_brown_feral", 1)
            cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), "hkrul_beorg_brown_feral_marked", 1)
            cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), "hkrul_beorg_ice_feral", 1)
        end
    end,
    true
)




cm:add_first_tick_callback_new(
    function()
        local all_factions = cm:model():world():faction_list();
        for i = 0, all_factions:num_items()-1 do
            local faction = all_factions:item_at(i);
            if faction:culture() == "wh_dlc08_nor_norsca" then
                for unit_key, _ in pairs(rhox_beorg_ror_list) do
                    cm:add_unit_to_faction_mercenary_pool(faction, unit_key, "renown", 1, 20, 1, 0.1, "", "", "", true, unit_key)
                    if faction:name() ~= "mixer_nor_beorg" then
                        cm:add_event_restricted_unit_record_for_faction(unit_key, faction:name(), unit_key.."_lock")
                    end
                end
            end
        end;
    end
)


----save/load

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_beorg_faction_list", rhox_beorg_faction_list, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			rhox_beorg_faction_list = cm:load_named_value("rhox_beorg_faction_list", rhox_beorg_faction_list, context)
		end
	end
)