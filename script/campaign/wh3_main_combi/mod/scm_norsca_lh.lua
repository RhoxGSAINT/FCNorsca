local rhox_fc_norsca_lh={
    rana_01={--asta
        faction_key="wh_main_nor_baersonling",
        mission_key="rhox_fc_norsca_asta",
        mission_type="DB",
        ai_turn =5,
        building_key="rhox_fc_norsca_ruins_of_vinnskor",
    },
    wolffather_01={--alfkael
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
                        return faction:name() == details.faction_key and turn ==5
                    end,
                    function(context)
                        local faction = context:faction()
                        cm:spawn_unique_agent(faction:command_queue_index(),agent_key, true)
                    end,
                    true
                );
            end
        end
	end
)

