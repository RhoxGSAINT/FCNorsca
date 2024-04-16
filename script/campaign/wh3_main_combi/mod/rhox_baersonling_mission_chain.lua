--[[ Not doing this till later
local mission_chain_key ="rhox_baersonling_chain_"
local baersonling_faction_key = "wh_main_nor_baersonling"


local baersonling_mission_table={
    {mission_trigger= 
    function(index)
        local mm = mission_manager:new(faction:name(), mission_chain_key.. tostring(index))
        if not mm then
            return
        end
        mm:add_new_objective("CONSTRUCT_N_BUILDINGS_INCLUDING");
        mm:add_condition("building_level rhox_fc_norsca_ruins_of_vinnskor");
        mm:add_condition("total 1");
        mm:add_payload("money 1000");
        mm:add_payload("text_display rhox_baersonling_your_journey_continues");
        mm:trigger()
    end,}, --mission 1 triggers mission 2
    {incident = true,
    mission_trigger= 
    function(index)
        local mm = mission_manager:new(faction:name(), mission_chain_key.. tostring(index))
        if not mm then
            return
        end
        mm:add_new_objective("RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING");
        mm:add_condition("region wh3_main_combi_region_altar_of_spawns");
        mm:add_condition("region wh3_main_combi_region_the_forbidden_citadel");
        mm:add_condition("region wh3_main_combi_region_monolith_of_flesh");
        mm:add_condition("total 3");
        mm:add_payload("money 1000");
        mm:add_payload("text_display rhox_baersonling_your_journey_continues");
        mm:trigger()
    end,},
    {incident = true,
    mission_trigger= 
    function(index)
        local mm = mission_manager:new(faction:name(), mission_chain_key.. tostring(index))
        if not mm then
            return
        end
        mm:add_new_objective("RECRUIT_AGENT");
        mm:add_condition("total 4");
        mm:add_payload("money 1000");
        mm:add_payload("text_display rhox_baersonling_your_journey_continues");
        mm:trigger()
    end,},
    {incident = true,
    mission_trigger= 
    function(index)
        cm:trigger_mission(baersonling_faction_key, mission_chain_key.. tostring(index), true)
        
    end,},
    {incident = true,
    function(index)
        local mm = mission_manager:new(faction:name(), mission_chain_key.. tostring(index))
        if not mm then
            return
        end
        mm:add_new_objective("CAPTURE_REGIONS");
        mm:add_condition("region wh3_main_combi_region_temple_of_heimkel");
        mm:add_condition("ignore_allies");
        mm:add_payload("money 1000");
        mm:add_payload("text_display rhox_baersonling_your_journey_continues");
        mm:trigger()
    end,},
    {incident = true,},
    {},
}


local function rhox_baersonling_trigger_mission(index)
    index=tonumber(index)

    local faction = cm:get_faction(baersonling_faction_key)
    local mission_info = baersonling_mission_table[index]
    if mission_info.incident then
        local incident_builder = cm:create_incident_builder(mission_chain_key.. "index")
        cm:launch_custom_incident_from_builder(incident_builder, faction)
    end
    if mission_info.mission_trigger then
        mission_info.mission_trigger(index)
    end
end

cm:add_first_tick_callback(
	function()
        local baersonling_faction=cm:get_faction(baersonling_faction_key)
        if baersonling_faction and baersonling_faction:is_human() then
            core:add_listener(
                "rhox_baersonling_init",
                "FactionTurnStart",
                function(context)
                    local faction = context:faction()
                    local turn = cm:model():turn_number();
                    return faction:name() == "wh_main_nor_baersonling" and turn ==5 and cm:get_campaign_name() ~= "cr_oldworld"
                end,
                function(context)
                    local faction = context:faction()
                    local mm = mission_manager:new(faction:name(), mission_chain_key.. "1")--init trigger
                    if not mm then
                        return
                    end
                    mm:add_new_objective("CAPTURE_REGIONS");
                    mm:add_condition("region wh3_main_combi_region_temple_of_heimkel");
                    mm:add_condition("ignore_allies");
                    mm:add_payload("money 1000");
                    mm:add_payload("text_display rhox_baersonling_your_journey_continues");
                    mm:trigger()

                    local incident_builder = cm:create_incident_builder(mission_chain_key.. "1")
                    cm:launch_custom_incident_from_builder(incident_builder, faction)
                end,
                false
            );

            core:add_listener(
                "rhox_baersonling_mission_success",
                "MissionSucceeded",
                function(context)
                    local faction = context:faction()
                    local mission_key = context:mission():mission_record_key();
                    return mission_key:starts_with(mission_chain_key)
                end,
                function(context)
                    local mission_key = context:mission():mission_record_key();
                    local index = string.gsub(mission_key, mission_chain_key, "")
                    rhox_baersonling_trigger_mission(index)
                end,
                true
            );

            core:add_listener(
                "rhox_baersonling_mission_failsafe",
                "MissionCancelled",
                function(context)
                    local faction = context:faction()
                    local mission_key = context:mission():mission_record_key();
                    return mission_key:starts_with(mission_chain_key)
                end,
                function(context)
                    local mission_key = context:mission():mission_record_key();
                    local index = string.gsub(mission_key, mission_chain_key, "")
                    rhox_baersonling_trigger_mission(index)
                end,
                true
            );



        end
	end
)

--]]