local rhox_fc_norsca_baersonling_incident_three_turn =999
local baersonling_faction_key = "wh_main_nor_baersonling"


local mission_to_next={
    hkrul_baerson_einar_aesling_battle=function() cm:trigger_mission(baersonling_faction_key, "rhox_baersonling_chain_2", true) end,
    rhox_baersonling_chain_2=function() 
        local faction = cm:get_faction(baersonling_faction_key)
        local incident_builder = cm:create_incident_builder("rhox_baersonling_chain_1")
        cm:launch_custom_incident_from_builder(incident_builder, faction)
        rhox_fc_norsca_baersonling_incident_three_turn=cm:model():turn_number()+2 
    end,
    rhox_baersonling_chain_3=function() 
        local faction = cm:get_faction(baersonling_faction_key)
        local dilemma_builder = cm:create_dilemma_builder("rhox_baersonling_chain_3");
		local payload_builder = cm:create_payload();
        payload_builder:text_display("rhox_baersonling_hkrul_usta_joins")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        payload_builder:text_display("rhox_baersonling_hkrul_orgrim_joins")
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        payload_builder:clear();
        cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
        core:add_listener(
            "rhox_baersonling_choice_made_for_chain_3",
            "DilemmaChoiceMadeEvent",
            function(context)
                local dilemma_key = context:dilemma()
                return dilemma_key == "rhox_baersonling_chain_3"
            end,
            function(context)
                local choice = context:choice()
                if choice==0 then
                    cm:spawn_unique_agent(faction:command_queue_index(),"hkrul_usta", true)
                    cm:trigger_mission(baersonling_faction_key, "rhox_baersonling_chain_4", true)
                elseif choice==1 then
                    cm:spawn_unique_agent(faction:command_queue_index(),"hkrul_orgrim", true)
                   cm:trigger_mission(baersonling_faction_key, "rhox_baersonling_chain_4b", true)
                end
            end,
            false
        )

    end,
    
    
    rhox_baersonling_chain_4=function() 
        local faction = cm:get_faction(baersonling_faction_key)
        local incident_builder = cm:create_incident_builder("rhox_baersonling_chain_4")
        cm:launch_custom_incident_from_builder(incident_builder, faction)
        cm:trigger_mission(baersonling_faction_key, "rhox_baersonling_chain_5", true)
    end,
    rhox_baersonling_chain_4b=function() --needs to be same with above. I know stupid, didn't want to make another function
        local faction = cm:get_faction(baersonling_faction_key)
        local incident_builder = cm:create_incident_builder("rhox_baersonling_chain_4")
        cm:launch_custom_incident_from_builder(incident_builder, faction)
        cm:trigger_mission(baersonling_faction_key, "rhox_baersonling_chain_5", true)
    end,
    rhox_baersonling_chain_5=function() 
        local faction = cm:get_faction(baersonling_faction_key)
        local dilemma_builder = cm:create_dilemma_builder("rhox_baersonling_chain_5");
		local payload_builder = cm:create_payload();
		payload_builder:text_display("rhox_baersonling_hkrul_berus_joins")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        payload_builder:text_display("rhox_baersonling_hkrul_kammler_joins")
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        payload_builder:clear();
        cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
        core:add_listener(
            "rhox_baersonling_choice_made_for_chain_5",
            "DilemmaChoiceMadeEvent",
            function(context)
                local dilemma_key = context:dilemma()
                return dilemma_key == "rhox_baersonling_chain_5"
            end,
            function(context)
                local choice = context:choice()
                if choice==0 then
                   cm:spawn_unique_agent(faction:command_queue_index(),"hkrul_berus", true)
                elseif choice==1 then
                   cm:spawn_unique_agent(faction:command_queue_index(),"hkrul_kammler", true)
                end
                --IDK what will come of the choice
                cm:trigger_mission(baersonling_faction_key, "hkrul_baerson_einar_bubos_battle", true)
            end,
            false
        )
    end,
    hkrul_baerson_einar_bubos_battle=function() 
        local faction = cm:get_faction(baersonling_faction_key)
        local incident_builder = cm:create_incident_builder("rhox_baersonling_chain_6")
        cm:launch_custom_incident_from_builder(incident_builder, faction)
        
        local mm = mission_manager:new(faction:name(), "rhox_baersonling_chain_7")
        mm:add_new_objective("DESTROY_FACTION");
        mm:add_condition("faction wh3_dlc25_nur_epidemius");
        mm:add_condition("faction wh3_dlc25_nur_tamurkhan");
        mm:add_condition("faction wh3_main_nur_maggoth_kin");
        mm:add_condition("confederation_valid");
        mm:add_payload("money 1000");
        mm:add_payload("text_display rhox_baersonling_your_journey_continues");
        mm:trigger()
    end,
    rhox_baersonling_chain_7=function() 
        local faction = cm:get_faction(baersonling_faction_key)
        local incident_builder = cm:create_incident_builder("rhox_baersonling_chain_7")
        cm:launch_custom_incident_from_builder(incident_builder, faction)
        cm:trigger_mission(baersonling_faction_key, "hkrul_baerson_einar_palace_battle", true)
    end,
    hkrul_baerson_einar_palace_battle=function() 
        local faction = cm:get_faction(baersonling_faction_key)
        local dilemma_builder = cm:create_dilemma_builder("rhox_baersonling_chain_8");
		local payload_builder = cm:create_payload();
		
		local teleport_bundle = cm:create_new_custom_effect_bundle("rhox_baersonling_teleport");
        teleport_bundle:add_effect("wh3_dlc26_effect_stance_availability_tunneling_enable", "faction_to_faction_own", 1);
        teleport_bundle:set_duration(0);
			
		payload_builder:effect_bundle_to_faction(teleport_bundle)
		payload_builder:text_display("rhox_baersonling_asta_joins")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        payload_builder:faction_ancillary_gain("hkrul_festerheart")
        payload_builder:text_display("rhox_baersonling_hkrul_festerheart")
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        payload_builder:clear();
        cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
        core:add_listener(
            "rhox_baersonling_choice_made_for_chain_8",
            "DilemmaChoiceMadeEvent",
            function(context)
                local dilemma_key = context:dilemma()
                return dilemma_key == "rhox_baersonling_chain_8"
            end,
            function(context)
                local choice = context:choice()
                if choice==0 then
                   cm:spawn_unique_agent(faction:command_queue_index(),"scm_norsca_asta", true)
                elseif choice==1 then
                    local x, y = cm:find_valid_spawn_location_for_character_from_settlement("wh_dlc08_chs_chaos_challenger_tzeentch", "wh3_main_combi_region_fort_jakova", false, true)
                    local unit_list = WH_Random_Army_Generator:generate_random_army("rhox_baersonling_tzeentch_invasion", "wh3_main_sc_tze_tzeentch", 20, 2, true)
                    
                    local spawned_force

                    cm:create_force_with_general(
                    -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
                    "wh_dlc08_chs_chaos_challenger_tzeentch",
                    unit_list,
                    "wh3_main_combi_region_fort_jakova",
                    x,
                    y,
                    "general",
                    "wh3_main_tze_exalted_lord_of_change_tzeentch",
                    "",
                    "",
                    "",
                    "",
                    false,
                    function(cqi)
                        local forename = common:get_localised_string("names_name_7170700356")
                        cm:change_character_custom_name(cm:get_character_by_cqi(cqi), forename, "","","")
                        spawned_force=cm:get_character_by_cqi(cqi):military_force();
                    end);
                    
                    
                    rhox_baersonling_tzeentch_invasion = invasion_manager:new_invasion_from_existing_force("rhox_baersonling_tzeentch_invasion",spawned_force)
                    rhox_baersonling_tzeentch_invasion:apply_effect("wh_main_bundle_military_upkeep_free_force", -1)
                    rhox_baersonling_tzeentch_invasion:start_invasion(true)
                    cm:force_declare_war("wh_dlc08_chs_chaos_challenger_tzeentch", baersonling_faction_key, false, false)
                end
            end,
            false
        )
    end,
}


cm:add_first_tick_callback(
	function()
        local baersonling_faction=cm:get_faction(baersonling_faction_key)
        if baersonling_faction and baersonling_faction:is_human() then

            core:add_listener(
                "rhox_baersonling_mission_success",
                "MissionSucceeded",
                function(context)
                    local mission_key = context:mission():mission_record_key();
                    return mission_to_next[mission_key]
                end,
                function(context)
                    local mission_key = context:mission():mission_record_key();
                    mission_to_next[mission_key]()
                end,
                true
            );

            core:add_listener(
                "rhox_baersonling_mission_failsafe",
                "MissionCancelled",
                function(context)
                    local mission_key = context:mission():mission_record_key();
                    return mission_to_next[mission_key]
                end,
                function(context)
                    local mission_key = context:mission():mission_record_key();
                    mission_to_next[mission_key]()
                end,
                true
            );
            ------------------passing turn 2 after mission 2 check 
            core:add_listener(
                "rhox_baersonling_incident_three_checker",
                "FactionTurnStart",
                function(context)
                    local faction = context:faction()
                    return faction:name() == baersonling_faction_key and faction:is_human() and cm:model():turn_number() == rhox_fc_norsca_baersonling_incident_three_turn
                end,
                function(context)
                    local faction = context:faction()
                    local incident_builder = cm:create_incident_builder("rhox_baersonling_chain_2")
                    cm:launch_custom_incident_from_builder(incident_builder, faction)
                    
                    
                    local mm = mission_manager:new(faction:name(), "rhox_baersonling_chain_3")
                    mm:add_new_objective("CAPTURE_REGIONS");
                    mm:add_condition("region wh3_main_combi_region_temple_of_heimkel");
                    mm:add_condition("ignore_allies");
                    mm:add_payload("money 1000");
                    mm:add_payload("text_display rhox_baersonling_your_journey_continues");
                    mm:trigger()
                end,
                true
            );

        end
	end
)



--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_fc_norsca_baersonling_incident_three_turn", rhox_fc_norsca_baersonling_incident_three_turn, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			rhox_fc_norsca_baersonling_incident_three_turn = cm:load_named_value("rhox_fc_norsca_baersonling_incident_three_turn", rhox_fc_norsca_baersonling_incident_three_turn, context);
		end;
	end
);