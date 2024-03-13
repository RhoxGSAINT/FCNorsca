function wolftribe_spawn_unique_agents(wolftribe_unique_agents)
	for i = 1, #wolftribe_unique_agents do
		local details = wolftribe_unique_agents[i]
		local current_subtype = details[1]	
		local current_faction = details[2]
		local world = cm:model():world()
		
		if world:faction_exists(current_faction) then
			local faction = cm:model():world():faction_by_key(current_faction);	
			local faction_cqi = faction:command_queue_index();
			local faction_leader_cqi = faction:faction_leader():command_queue_index();
			cm:spawn_unique_agent_at_character(faction_cqi, current_subtype, faction_leader_cqi, true)
		end;
	end;
end;

cm:add_first_tick_callback(function()	

	if cm:is_new_game() then
					
		local wolftribe_unique_agents = {
			{"arngrim_01", "wh_dlc08_nor_naglfarlings"},
			{"rana_01", "wh_dlc08_nor_naglfarlings"},
			{"wolffather_01", "wh_dlc08_nor_naglfarlings"}
		}

		local faction = cm:get_faction("wh_dlc08_nor_naglfarlings");

		if not faction:is_human() then
			wolftribe_spawn_unique_agents(wolftribe_unique_agents)
		end

		if faction:is_human() then
			unique_agent_setup_arngrim()
		end

		cm:callback(function()	
			cm:disable_event_feed_events(false, "wh_event_category_agent", "", "")
		end, 3
		);
		cm:callback(function()
			cm:disable_event_feed_events(false, "wh_event_category_agent", "", "");
			CampaignUI.ClearSelection();
		end, 0.5);
		out("UNIQ: Spawned hero next to Rafford the Wolf");
	end
end)

--[[
	Script by Aexrael Dex
	Spawns a Unique Agent next to the starting lord of a specified faction
]]

function unique_agent_setup_arngrim()
	-- Agent Details
	local agent_details = {
		faction_str = "wh_dlc08_nor_naglfarlings",	-- faction_key from factions
		forename_key = "names_name_240931",						-- forename_key from names
		family_name_key = "",					-- family_name_key from names
		subtype_key = "arngrim_01",			-- agent subtype_key from agent_subtypes
		art_set_key = "arngrim_01",	-- agent art_set_id from campaign_character_arts
		unique_string = "arngrim_01",			-- unique agent string from unique_agents
		saved_value = "unique_agent_enabled",						-- saved_value string
	};

	-- Monitor activated, listening for FactionTurnStart for The Huntmarshals Expedition
	core:add_listener(
		"arngrim_unique_agent_setup",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == agent_details.faction_str;
		end,
		function(context)
			-- Spawning Arngrim as a unique agent next to Rafford
			local faction = cm:get_faction(agent_details.faction_str);
			local faction_cqi = faction:command_queue_index();
			local faction_leader_cqi = faction:faction_leader():command_queue_index();

			cm:disable_event_feed_events(true, "wh_event_category_agent", "", "");
			cm:spawn_unique_agent_at_character(
				faction_cqi,
				agent_details.unique_string,
				faction_leader_cqi,
				true
			);
			cm:callback(function()
				cm:disable_event_feed_events(false, "wh_event_category_agent", "", "");
				CampaignUI.ClearSelection();
			end, 0.5);
			out("UNIQ: Spawned Arngrim Frostaxe next to Rafford the Wolf");

			-- Looping through the character list for The Huntmarshals Expedition
			local char_list = faction:character_list();

			for i = 0, char_list:num_items() - 1 do
				local current_char = char_list:item_at(i);
				local char_str = cm:char_lookup_str(current_char);

				-- Adding Joreks trait, replenishing AP and overriding the art set
				if current_char:is_null_interface() == false and current_char:character_subtype_key() == agent_details.subtype_key then

					-- Replenishing action points
					cm:replenish_action_points(char_str);
					out("UNIQ: Replenishing the action points of Arngrim");

					-- Failsafe for the random chance that the art_set doesn't apply properly
					cm:add_unit_model_overrides(char_str, agent_details.art_set_key);
					out("UNIQ: Adding unit model override for Arngrim");
				end;
			end;

			-- Setting saved value, so that the script doesn't run again when reloaded from a saved game
			cm:set_saved_value(agent_details.saved_value, true);
			out("UNIQ: Setting saved value " .. agent_details.saved_value);
		end,
		false
	);
end;