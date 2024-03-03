core:add_listener(
    "rhox_adella_mission_completed",
    "MissionSucceeded",
    function(context)    
        local mission_key = context:mission():mission_record_key();
        return mission_key == "rhox_adella_landmark_mission"
    end,
    function(context)
        local faction_key = context:faction():name()
        cm:remove_event_restricted_building_record_for_faction("wh2_main_special_skeggi_hall",faction_key)
    end,
    true
)


local agent_subtype_to_level_and_mission={
    hkrul_ulfric={
        level= 14,
        mission= "hkrul_bjornling_ulfric_crown_final_battle"
    },
    hkrul_adella={
        level= 7,
        mission= "hkrul_skeggi_adella_sword_final"
    },
}

core:add_listener(
    "rhox_fc_norsca_qb_issuer",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local subtype = character:character_subtype_key()
        local faction = character:faction()
        return faction:is_human() and agent_subtype_to_level_and_mission[subtype] and character:rank() >= agent_subtype_to_level_and_mission[subtype].level and cm:get_saved_value("rhox_fc_norsca_mission_checker_"..subtype.."_"..agent_subtype_to_level_and_mission[subtype].mission) ~= true
    end,
    function(context)
        local character = context:character()
        local subtype = character:character_subtype_key()
        local faction = character:faction()
        
        cm:set_saved_value("rhox_fc_norsca_mission_checker_"..subtype.."_"..agent_subtype_to_level_and_mission[subtype].mission,true)
        cm:trigger_mission(faction:name(), agent_subtype_to_level_and_mission[subtype].mission, true)
    end,
    true
)
    
