local varg_faction_key ="wh_main_nor_varg"

core:add_listener(
    "rhox_varg_hrothgar_unlock",
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

local corruption_to_unit={
    wh3_main_corruption_chaos="wh_main_chs_mon_chaos_spawn",
    wh3_main_corruption_khorne="wh3_main_kho_mon_spawn_of_khorne_0",
    wh3_main_corruption_nurgle="wh3_main_nur_mon_spawn_of_nurgle_0",
    wh3_main_corruption_slaanesh="wh3_main_sla_mon_spawn_of_slaanesh_0",
    wh3_main_corruption_tzeentch="wh3_main_tze_mon_spawn_of_tzeentch_0",
}


core:add_listener(
    "rhox_varg_battle_completed",
    "CharacterCompletedBattle",
    function(context)
        local character = context:character()
        local faction = character:faction()
        local pb = context:pending_battle();
        local base_chance = 100
        local bonus_chance = character:bonus_values():scripted_value("rhox_varg_bonus_chance", "value")

        if character:is_at_sea() or not character:region() then
            --out("Rhox Varg: This character does not have region or is at sea")
            return false
        end

        local corruption_type, chaos_corruption = cm:get_highest_corruption_in_region(character:region())

        if not corruption_to_unit[corruption_type] or chaos_corruption < 50 then
            --out("Rhox Varg: Highest corruption is wrong type: " .. corruption_type .. "or corruption is less than 50: "..chaos_corruption)
            
            return false
        end
        
        return faction:name()==varg_faction_key and pb:has_been_fought() and character:won_battle() and cm:model():random_percent(base_chance+bonus_chance)
    end,
    function(context)
        out("Rhox Varg: Check")
        local character = context:character()
        local faction = character:faction()
        local corruption_type, chaos_corruption = cm:get_highest_corruption_in_region(character:region())
        
        local amount = 1

        if chaos_corruption > 60 then
            amount = 2
        elseif chaos_corruption > 80 then
            amount = 3
        end
        
        if faction:is_human() then
            local incident_builder = cm:create_incident_builder("rhox_varg_chaos_spawn_incident")
            incident_builder:add_target("default", character)
            local payload_builder = cm:create_payload()            
            payload_builder:add_mercenary_to_faction_pool(corruption_to_unit[corruption_type], amount)  
            incident_builder:set_payload(payload_builder)
            cm:launch_custom_incident_from_builder(incident_builder, faction)
        else
            cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), corruption_to_unit[corruption_type], amount)
        end
    end,
    true
)


