
local olaf_faction_key = "mixer_nor_bloodfjord"


local mission_to_next={
    
    hkrul_olaf_spear_0=function() 
        local faction = cm:get_faction(olaf_faction_key)
        local incident_builder = cm:create_incident_builder("hkrul_olaf_turn_three_incident")
        cm:launch_custom_incident_from_builder(incident_builder, faction)
        cm:trigger_mission(olaf_faction_key, "hkrul_olaf_spear_1", true)
    end,
    hkrul_olaf_spear_1=function() 
        local faction = cm:get_faction(olaf_faction_key)
        local incident_builder = cm:create_incident_builder("hkrul_olaf_turn_four_incident")
        cm:launch_custom_incident_from_builder(incident_builder, faction)
        local mm = mission_manager:new(faction:name(), "hkrul_olaf_spear_2")
        mm:add_new_objective("RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING");
        mm:add_condition("region wh3_main_combi_region_salzenmund");
        mm:add_condition("region wh3_main_combi_region_dietershafen");
        mm:add_condition("region wh3_main_combi_region_norden");
        mm:add_condition("region wh3_main_combi_region_aarnau");
        mm:add_condition("total 4");
        mm:add_payload("money 1000");
        mm:add_payload("text_display rhox_baersonling_your_journey_continues");
        mm:trigger()
    end,
    hkrul_olaf_spear_2=function() 
        local faction = cm:get_faction(olaf_faction_key)
        local incident_builder = cm:create_incident_builder("hkrul_olaf_turn_five_incident")
        cm:launch_custom_incident_from_builder(incident_builder, faction)
        local mm = mission_manager:new(faction:name(), "hkrul_olaf_spear_3")
        mm:add_new_objective("RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING");
        mm:add_condition("region wh3_main_combi_region_middenheim");
        mm:add_condition("total 1");
        mm:add_payload("money 1000");
        mm:add_payload("text_display rhox_baersonling_your_journey_continues");
        mm:trigger()
    end,
    hkrul_olaf_spear_3=function() 
        local faction = cm:get_faction(olaf_faction_key)
        local incident_builder = cm:create_incident_builder("hkrul_olaf_turn_six_incident")
        cm:launch_custom_incident_from_builder(incident_builder, faction)
        cm:trigger_mission(olaf_faction_key, "hkrul_bloodtide_olaf_spear_final_battle", true)
    end,
    hkrul_bloodtide_olaf_spear_final_battle=function() 
        local faction = cm:get_faction(olaf_faction_key)
        local dilemma_builder = cm:create_dilemma_builder("hkrul_olaf_turn_seven_incident");
		local payload_builder = cm:create_payload();
        --payload_builder:text_display("rhox_baersonling_hkrul_usta_joins")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        --payload_builder:text_display("rhox_baersonling_hkrul_orgrim_joins")
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        payload_builder:clear();
        cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
        core:add_listener(
            "rhox_olaf_choice_made_for_final_chain",
            "DilemmaChoiceMadeEvent",
            function(context)
                local dilemma_key = context:dilemma()
                return dilemma_key == "hkrul_olaf_turn_seven_incident"
            end,
            function(context)
                local choice = context:choice()
                if choice==0 then
                    
                elseif choice==1 then
                    
                end
            end,
            false
        )

    end,
    
}

--[[






]]

cm:add_first_tick_callback(
	function()
        local olaf_faction=cm:get_faction(olaf_faction_key)
        if olaf_faction and olaf_faction:is_human() then

            core:add_listener(
                "rhox_olaf_mission_success",
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
                "rhox_olaf_mission_failsafe",
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

            core:add_listener(
                "rhox_olaf_turn2_start",
                "FactionTurnStart",
                function(context)
                    local faction = context:faction()
                    
                    return faction:name() == olaf_faction_key and faction:is_human() and cm:model():turn_number() == 2
                end,
                function(context)
                    local faction = context:faction()
                    
                    cm:trigger_mission(olaf_faction_key, "hkrul_olaf_spear_0", true)
                end,
                true
            );
        end
	end
)


