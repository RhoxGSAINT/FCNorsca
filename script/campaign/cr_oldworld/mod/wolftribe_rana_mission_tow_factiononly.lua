-- Move a character to Bordeleaux = Rana spawns on your faction leader
-- Mission is available to all Norscan factions

local function spawn_rana_ime(faction)
	-- Agent Details
	local agent_details = {
		faction_str = "wh_dlc08_nor_naglfarlings",	-- faction_key from factions
		forename_key = "names_name_240929",						-- forename_key from names
		family_name_key = "",					-- family_name_key from names
		subtype_key = "rana_01",			-- agent subtype_key from agent_subtypes
		art_set_key = "rana_01",	-- agent art_set_id from campaign_character_arts
		unique_string = "rana_01",			-- unique agent string from unique_agents
		saved_value = "unique_agent_enabled",						-- saved_value string
	};

	local agent_unique_string = "rana_01"
	local faction_cqi = faction:command_queue_index()
	local faction_leader_cqi = faction:faction_leader():command_queue_index()

	-- Spawn unique agent at character position
	ModLog("Spawning Rana...")
	cm:spawn_unique_agent_at_character(faction_cqi, agent_details.unique_string, faction_leader_cqi, true)
	ModLog("Rana spawned")
	
	--local region = cm:get_region("wh3_main_combi_region_bordeleaux")
	--local region_cqi = region:command_queue_index()
	--cm:spawn_unique_agent_at_region(faction_cqi, agent_unique_string, region_cqi, false)
	
	cm:callback(function()
		CampaignUI.ClearSelection()
	end, 0.5)

	-- Setting immortality and replenishing action points.
	local char_list = faction:character_list()

	for i = 0, char_list:num_items() - 1 do
		local current_char = char_list:item_at(i)
		local char_str = cm:char_lookup_str(current_char)

		if current_char:is_null_interface() == false and current_char:character_subtype_key() == agent_details.subtype_key then
			ModLog("Replenishing Rana's action_points and setting her as immortal...")
			cm:replenish_action_points(char_str)
			cm:set_character_immortality(char_str, true);
			ModLog("Rana's action_points reset and she is immortal");

			-- Failsafe for the random chance that the art_set doesn't apply properly
			cm:add_unit_model_overrides(char_str, agent_details.art_set_key);
			out("UNIQ: Adding unit model override for Anarsis");
		end;
	end;
end;

local function add_rana_listener_ime()
	ModLog("Adding Rana mission-complete listener")
	core:add_listener(
		"Rana_MissionSucceeded",
		"MissionSucceeded",
		function(context)
			return (context:mission():mission_record_key() == "wolftribe_nor_rana_tow")
		end,
		function(context)
			faction = context:faction()
			spawn_rana_ime(faction)
			cm:set_saved_value("rana_spawned", true)
		end,
		false
	);
end

local function trigger_rana_mission_ime()

	local player_faction = cm:get_human_factions()
		
	for i = 1, #player_faction do
		if player_faction[i] == "wh_dlc08_nor_naglfarlings" then
			cm:callback(function()
				ModLog("Starting Rana mission")
				cm:trigger_mission(player_faction[i], "wolftribe_nor_rana_tow", true)
			end, 0.5)
		end
	end

	cm:set_saved_value("rana_unlocked", true)
end



local function double_check_rana_spawned_ime()
	local player_faction = cm:get_human_factions()
		
	for i = 1, #player_faction do
		local faction = cm:get_faction(player_faction[i])
		if player_faction[i] == "wh_dlc08_nor_naglfarlings" then
			
			local found_rana = false
			
			local char_list = faction:character_list()
			for j = 0, char_list:num_items() - 1 do
				local current_char = char_list:item_at(j)
				local char_str = cm:char_lookup_str(current_char)

				if current_char:is_null_interface() == false and current_char:character_subtype_key() == "rana_01" then
					found_rana = true
				end
			end
			
			if found_rana then
				--do nothing
				ModLog("Rana found, all is well")
			else
				--otherwise, force-spawn him in
				ModLog("Rana not found, panic! Force-spawning her in...")
				spawn_rana_ime(faction)
			end
			
		end
	end
end

cm:add_first_tick_callback(
	function()
		--check if the mission has been triggered
		if cm:get_saved_value("rana_unlocked") == nil then
			trigger_rana_mission_ime()
		end

		--check if the mission has been completed
		if cm:get_saved_value("rana_spawned") == nil then
			add_rana_listener_ime()
		elseif cm:get_saved_value("rana_spawned") == true then
			double_check_rana_spawned_ime()
		end
	end
);
