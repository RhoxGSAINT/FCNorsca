local varg_faction_key ="wh_main_nor_varg"

core:add_listener(
    "the_changeling_rift_tech_unlock",
    "PooledResourceChanged",
    function(context)
        return context:resource():key() == "nor_progress_hound" and context:resource():value() >= 60 and context:faction():name() == varg_faction_key and cm:get_saved_value("rhox_varg_mission_complete") ~=true and context:faction():is_human()
    end,
    function(context)
        local faction = context:faction()
        cm:set_saved_value("rhox_varg_mission_complete", true)
        
        cm:complete_scripted_mission_objective(varg_faction_key, "rhox_varg_hrothgar_mission", "rhox_varg_devotion", true)
        
        local incident_builder = cm:create_incident_builder("rhox_varg_hrothgar_joins");
        local payload_builder = cm:create_payload();
        payload_builder:text_display("rhox_varg_hrothgar_appears");
        incident_builder:set_payload(payload_builder);
        cm:launch_custom_incident_from_builder(incident_builder, faction);
        
        
        
        cm:spawn_character_to_pool(faction:name(), "names_name_7410711835", "names_name_7410711834", "", "", 50, true, "general", "hkrul_hrothgar", true, "");
    end,
    true
)
