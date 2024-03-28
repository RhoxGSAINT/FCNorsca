local rhox_fc_norsca_lh={
    scm_norsca_asta={--asta
        faction_key="wh_main_nor_baersonling",
        mission_key="rhox_fc_norsca_asta",
        mission_type="DB",
        ai_turn =5,
        building_key="rhox_fc_norsca_ruins_of_vinnskor",
    },
    scm_norsca_alfkael={--alfkael
        faction_key="wh_main_nor_aesling",
        mission_key="rhox_fc_norsca_bloodfather",
        mission_condition=function(mm) 
            mm:add_new_objective("KILL_X_ENTITIES")
            mm:add_condition("total 15000")
            mm:add_payload("money 1000")
            mm:add_payload("text_display nag_mortarch_krell_technology");
            mm:trigger()
        end,
        ai_turn =5,
        building_key="rhox_fc_norsca_valmir_aesling",
    },
}

cm:add_first_tick_callback(
	function()
        for agent_key,details in pairs(rhox_fc_norsca_lh) do
            local faction = cm:get_faction(details.faction_key)
            if faction:is_human() then
                core:add_listener(
                    "rhox_fc_norsca_lh_building_"..agent_key,
                    "BuildingCompleted",
                    function(context)
                        local building=context:building()
                        local faction = building:faction()
                        
                        return faction:name() == details.faction_key and cm:get_saved_value("rhox_fc_norsca_lh_building_"..agent_key) ~=true and building:name() == details.building_key
                    end,
                    function(context)
                        cm:set_saved_value("rhox_fc_norsca_lh_building_"..agent_key, true)
                        local building=context:building()
                        local faction = building:faction()
                        if details.mission_type == "DB" then
                            cm:trigger_mission(faction:name(), details.mission_key, true)
                        else
                            local mm = mission_manager:new(faction:name(), details.mission_key)
                            details.mission_condition(mm)
                        end
                    end,
                    true
                );
                core:add_listener(
                    "rhox_fc_norsca_lh_mission_"..agent_key,
                    "MissionSucceeded",
                    function(context)
                        local faction = context:faction()
                        local mission_key = context:mission():mission_record_key();
                        return mission_key== details.mission_key and cm:get_saved_value("rhox_fc_norsca_lh_mission_"..agent_key) ~=true
                    end,
                    function(context)
                        local faction = context:faction()
                        cm:set_saved_value("rhox_fc_norsca_lh_mission_"..agent_key,true)
                        cm:spawn_unique_agent(faction:command_queue_index(),agent_key, true)
                    end,
                    true
                );
            else
                core:add_listener(
                    "rhox_fc_norsca_lh_ai_"..agent_key,
                    "FactionTurnStart",
                    function(context)
                        local faction = context:faction()
                        local turn = cm:model():turn_number();
                        return faction:name() == details.faction_key and turn == details.ai_turn
                    end,
                    function(context)
                        local faction = context:faction()
                        cm:spawn_unique_agent(faction:command_queue_index(),agent_key, true)
                    end,
                    true
                );
            end
        end
        local varg_faction = cm:get_faction("wh_main_nor_varg")
        if varg_faction:is_human() == false and cm:model():turn_number() < 25 then
            core:add_listener(
                "rhox_fc_norsca_lh_ai_hrothgar",
                "FactionTurnStart",
                function(context)
                    local faction = context:faction()
                    local turn = cm:model():turn_number();
                    return faction:name() == "wh_main_nor_varg" and turn ==25
                end,
                function(context)
                    local faction = context:faction()
                    cm:spawn_unique_agent(faction:command_queue_index(),"hkrul_hrothgar", true)
                end,
                false
            );
        end
        
        
        local baersonling_faction = cm:get_faction("wh_main_nor_baersonling")
        if baersonling_faction:is_human() and cm:model():turn_number() < 5 then
            core:add_listener(
                "rhox_fc_norsca_lh_asta_helper",
                "FactionTurnStart",
                function(context)
                    local faction = context:faction()
                    local turn = cm:model():turn_number();
                    return faction:name() == "wh_main_nor_baersonling" and turn ==5
                end,
                function(context)
                    local faction = context:faction()
                    local mm = mission_manager:new(faction:name(), "rhox_fc_norsca_asta_hint")
                    mm:add_new_objective("CAPTURE_REGIONS");
                    mm:add_condition("region wh3_main_combi_region_temple_of_heimkel");
                    mm:add_condition("ignore_allies");
                    mm:add_payload("money 1000");
                    mm:trigger()
                end,
                false
            );
        end
	end
)
