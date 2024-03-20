-- Move a character to Serpent Jetty = Alfkael spawns on your faction leader
-- Mission is available to all Norscan factions

local function spawn_hidolfr_ime(faction)
	local agent_unique_string = "scm_norsca_alfkael"
	local faction_cqi = faction:command_queue_index()
	local faction_leader_cqi = faction:faction_leader():command_queue_index()

	-- Spawn unique agent at character position
	ModLog("Spawning Alfkael...")
	cm:spawn_unique_agent_at_character(faction_cqi, agent_unique_string, faction_leader_cqi, true)
	ModLog("Alfkael spawned")
	
	--local region = cm:get_region("wh3_main_combi_region_serpent_jetty")
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

		if current_char:is_null_interface() == false and current_char:character_subtype_key() == agent_unique_string then
			ModLog("Replenishing Alfkael's action_points and setting him as immortal...")
			cm:replenish_action_points(char_str)
			cm:set_character_immortality(char_str, true);
			ModLog("Alfkael's action_points reset and he is immortal")
		end
	end
end


local function add_hidolfr_listener_ime()
	ModLog("Adding Alfkael mission-complete listener")
	core:add_listener(
		"Alfkael_MissionSucceeded",
		"MissionSucceeded",
		function(context)
			return (context:mission():mission_record_key() == "wolftribe_nor_hidolfr_tow")
		end,
		function(context)
			faction = context:faction()
			spawn_hidolfr_ime(faction)
			cm:set_saved_value("hidolfr_spawned", true)
		end,
		false
	);
end

local function trigger_hidolfr_mission_ime()

	local player_faction = cm:get_human_factions()
		
	for i = 1, #player_faction do
		if player_faction[i] == "wh_dlc08_nor_naglfarlings" then
			cm:callback(function()
				ModLog("Starting Alfkael mission")
				cm:trigger_mission(player_faction[i], "wolftribe_nor_hidolfr_tow", true)
			end, 0.5)
		end
	end

	cm:set_saved_value("hidolfr_unlocked", true)
end



local function double_check_hidolfr_spawned_ime()
	
	local player_faction = cm:get_human_factions()
		
	for i = 1, #player_faction do
		local faction = cm:get_faction(player_faction[i])
		if player_faction[i] == "wh_dlc08_nor_naglfarlings" then
			
			local found_hidolfr = false
			
			local char_list = faction:character_list()
			for j = 0, char_list:num_items() - 1 do
				local current_char = char_list:item_at(j)
				local char_str = cm:char_lookup_str(current_char)

				if current_char:is_null_interface() == false and current_char:character_subtype_key() == "scm_norsca_alfkael" then
					found_hidolfr = true
				end
			end
			
			if found_hidolfr then
				--do nothing
				ModLog("Alfkael found, all is well")
			else
				--otherwise, force-spawn him in
				ModLog("Alfkael not found, panic! Force-spawning him in...")
				spawn_hidolfr_ime(faction)
			end
			
		end
	end
end

cm:add_first_tick_callback(
	function()
		--check if the mission has been triggered
		if cm:get_saved_value("hidolfr_unlocked") == nil then
			trigger_hidolfr_mission_ime()
		end

		--check if the mission has been completed
		if cm:get_saved_value("hidolfr_spawned") == nil then
			add_hidolfr_listener_ime()
		elseif cm:get_saved_value("hidolfr_spawned") == true then
			double_check_hidolfr_spawned_ime()
		end
	end
);