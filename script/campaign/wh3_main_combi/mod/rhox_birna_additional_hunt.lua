local sarl_faction ="wh_main_nor_sarl"

local mission_to_next={
    hkrul_birna_turn_two_incident = function() 
        local mm = mission_manager:new(sarl_faction, "hkrul_sarl_birna_bogtusk_mission_1")
        mm:add_new_objective("CAPTURE_REGIONS")
        mm:add_condition("region wh3_main_combi_region_castle_alexandronov")
        mm:add_payload("money 3000")
        mm:trigger()
        --out("Rhox: mission occured check")
    end,
    hkrul_sarl_birna_bogtusk_mission_1  = function()
		local mm = mission_manager:new(sarl_faction, "hkrul_sarl_birna_bogtusk_mission_2")
        mm:add_new_objective("RECRUIT_N_UNITS_FROM")
        mm:add_condition("unit hkrul_sarl_hunters")
		mm:add_condition("exclude_existing true")
		mm:add_condition("total 2")
		mm:add_payload("money 3000")
        mm:trigger()
	end,
    hkrul_sarl_birna_bogtusk_mission_2 = function() 
		cm:trigger_mission(sarl_faction, "hkrul_sarl_birna_bogtusk_mission_3", true)
    end,
    hkrul_sarl_birna_bogtusk_mission_3 = function() 
        local mm = mission_manager:new(sarl_faction, "hkrul_sarl_birna_bogtusk_mission_4")
		mm:add_new_objective("HAVE_N_AGENTS_OF_TYPE")
		mm:add_condition("total 2")
        mm:add_condition("agent_subtype wh_dlc08_nor_skin_wolf_werekin")
        mm:add_payload("money 3000")
        mm:trigger()
    end,
    hkrul_sarl_birna_bogtusk_mission_4 = function() 
		cm:trigger_mission(sarl_faction, "hkrul_sarl_birna_bogtusk_final_battle", true)
    end,
	hkrul_sarl_birna_bogtusk_final_battle = function() 
       
    end,
}

local function birna_bogtus_listeners()
	local sarl_faction_interface = cm:get_faction(sarl_faction)
	if sarl_faction_interface and sarl_faction_interface:is_human() then

		core:add_listener(
			"rhox_birna_mission_success",
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
			"rhox_birna_mission_failsafe",
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
		)
		
		core:add_listener(
			"birna_incident_occured_event",
			"IncidentOccuredEvent",
			function(context)
				local incident = context:dilemma()
				--out("Rhox: Check incident name "..incident)
				return mission_to_next[incident]
			end,
			function(context)
                --out("Rhox: Incident occured check")
				local incident = context:dilemma()
				mission_to_next[incident]()
			end,
			true
		)
	end
end

cm:add_first_tick_callback(birna_bogtus_listeners)
