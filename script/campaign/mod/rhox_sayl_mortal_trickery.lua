rhox_sayl_chaos_spawn = {
	sayl_faction_key = "wh3_dlc20_nor_dolgan",
	effect_bundle_key = "rhox_sayl_chaos_spawn_gift", -- timed effect bundle
	effect_bundle_duration = 20,
	incident_key="rhox_sayl_chaos_spawn_incident",
}

function rhox_sayl_chaos_spawn:start()
	
	
	core:add_listener(
		"rhox_sayl_wins_the_battle",
		"BattleCompleted",
		function()
			return cm:pending_battle_cache_faction_is_involved(self.sayl_faction_key) and cm:model():pending_battle():has_been_fought()
		end,
		function()
			local character = false
			local char_cqi = false
			local mf_cqi = false
			local faction_name = false
			
			if cm:pending_battle_cache_faction_is_attacker(self.sayl_faction_key) then
				char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(1)
			else
				char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(1)
			end
			
			if char_cqi then
				character = cm:get_character_by_cqi(char_cqi)
			end
			
			if character then
				if cm:pending_battle_cache_faction_won_battle(self.sayl_faction_key) then
					self:apply_effect_bundle(character)
				elseif cm:pending_battle_cache_faction_lost_battle(self.sayl_faction_key) then
					self:remove_effect_bundle(character)
				end
			end
		end,
		true
	)
	
	-- clear any effect bundles if belakor's faction dies
	core:add_listener(
		"rhox_sayl_faction_dies",
		"WorldStartRound",
		true,
		function()
			if not cm:get_saved_value("rhox_sayl_faction_dead") and cm:get_faction(self.sayl_faction_key):is_dead() then
				-- only do this the first round belakor's faction is dead
				cm:set_saved_value("rhox_sayl_faction_dead", true)
				
				local faction_list = cm:model():world():faction_list()
				
				for i = 0, faction_list:num_items() - 1 do
					local current_faction = faction_list:item_at(i)
					
					if not current_faction:is_dead() then
						local character_list = current_faction:character_list()
						
						for j = 0, character_list:num_items() - 1 do
							local current_character = character_list:item_at(j)
							
							if cm:char_is_general(current_character) then
								self:remove_effect_bundle(current_character)
							end
						end
					end
				end
			else
				cm:set_saved_value("rhox_sayl_faction_dead", false)
			end
		end,
		true
	)
end

function rhox_sayl_chaos_spawn:apply_effect_bundle(character)
	if cm:char_is_general_with_army(character) and not character:character_details():is_unique() and not character:is_faction_leader() and not cm:is_agent_transformation_available(character:character_subtype_key()) then
		if not character:has_effect_bundle(self.effect_bundle_key) then
			cm:apply_effect_bundle_to_character(self.effect_bundle_key, character, self.effect_bundle_duration)
		else--transform
			if cm:get_faction(self.sayl_faction_key):is_human() then
				local incident_builder = cm:create_incident_builder(self.incident_key)
				incident_builder:add_target("default", character:family_member())
				cm:launch_custom_incident_from_builder(incident_builder, cm:get_faction(self.sayl_faction_key))
			end
			local x, y = cm:find_valid_spawn_location_for_character_from_character(self.sayl_faction_key, cm:char_lookup_str(character), true, 5);
			if x~= -1 and y~= -1 then 
				cm:create_force_with_general(
					-- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
					self.sayl_faction_key,
					"wh_dlc03_bst_mon_chaos_spawn_0,wh_dlc03_bst_mon_chaos_spawn_0,wh_dlc03_bst_mon_chaos_spawn_0,wh_dlc03_bst_mon_chaos_spawn_0,wh_dlc03_bst_mon_chaos_spawn_0",
					"wh3_main_combi_region_floating_mountain",
					x,
					y,
					"general",
					"wh_main_nor_marauder_chieftain",
					"",
					"",
					"",
					"",
					false,
					function(cqi)
					end);
			end
			cm:kill_character_and_commanded_unit(cm:char_lookup_str(character), false)
		end
	end
end

function rhox_sayl_chaos_spawn:remove_effect_bundle(character)
	if character:has_effect_bundle(self.effect_bundle_key) then
		cm:remove_effect_bundle_from_character(self.effect_bundle_key, character)
	end
end

cm:add_first_tick_callback(
	function()
		rhox_sayl_chaos_spawn:start()
	end
)