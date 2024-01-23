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