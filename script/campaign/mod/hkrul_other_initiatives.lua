local ascensions = {
	hkrul_goftur_ascend = true,
	hkrul_grydal_ascend = true
}

local old_subtype_to_new = {
	hkrul_grydal = {subtype = "hkrul_urf", forename = "names_name_7610711131", surname = "names_name_7610711130"},
	hkrul_goftur = {subtype = "hkrul_mermedus", forename = "names_name_7610711234", surname = "names_name_7610711233"}
}

local region_key = {
	cr_darklands = "cr_oldworld_region_zharr_naggrund",
	cr_oldworld = "cr_oldworld_region_altdorf",
	cr_oldworldclassic = "cr_oldworld_region_altdorf",
	main_warhammer = "wh3_main_combi_region_altdorf"
}
		
core:add_listener(
	"CharacterInitiativeActivationChangedEventRoRRewards",
	"CharacterInitiativeActivationChangedEvent",
	function(context)
		return context:initiative():record_key() == "hkrul_goftur_initiative_05"
	end,
	function(context)
		local faction_key = context:character():faction():name()
		
		cm:remove_event_restricted_unit_record_for_faction("hkrul_shark_3", faction_key)
	end,
	true
)


core:add_listener(
	"rhox_hkrul_goftur_ascend_initiative_activated",
	"CharacterInitiativeActivationChangedEvent",
	function(context)
		return ascensions[context:initiative():record_key()]
	end,
	function(context)
		local character = context:character()
		local old_char_details = {
			mf = character:military_force(),
			rank = character:rank(),
			fm_cqi = character:family_member():command_queue_index(),
			character_details = character:character_details(),
			faction_key = character:faction():name(),
			character_forename = character:get_forename(),
			character_surname = character:get_surname(),
			parent_force = character:embedded_in_military_force(),
			subtype = character:character_subtype_key(),
			traits = character:all_traits(),
			ap = character:action_points_remaining_percent()
		}
		local faction = context:character():faction()
		local character_cqi = character:command_queue_index();
		local faction_key = faction:name()

		local x, y = cm:find_valid_spawn_location_for_character_from_character(faction_key, cm:char_lookup_str(character), true, 5)
		local new_char_interface = nil

		cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            faction_key,
            "",
            region_key[cm:get_campaign_name()],
            x,
            y,
            "general",
            old_subtype_to_new[old_char_details.subtype].subtype,
            old_subtype_to_new[old_char_details.subtype].forename,
            "",
            old_subtype_to_new[old_char_details.subtype].surname,
            "",
            character:is_faction_leader(),
            function(cqi)
                new_char_interface = cm:get_character_by_cqi(cqi)
				local new_char_lookup = cm:char_lookup_str(cqi)
				cm:reassign_ancillaries_to_character_of_same_faction(old_char_details.character_details, new_char_interface:character_details())
				
                cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
                cm:suppress_immortality(character:family_member():command_queue_index() ,true)
                
                --cm:kill_character(cm:char_lookup_str(character_cqi), true)
                cm:callback(function() cm:kill_character_and_commanded_unit(cm:char_lookup_str(character_cqi), true) end, 0.1);
                cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);

                local composite_scene = "wh3_campaign_chaos_upgrade_daemons"
                x = new_char_interface:logical_position_x();
                y = new_char_interface:logical_position_y();
                cm:add_scripted_composite_scene_to_logical_position(composite_scene, composite_scene, x, y, x, y + 1, true, false, false);

				if old_char_details.traits then
					for i =1, #old_char_details.traits do
						local trait_to_copy = old_char_details.traits[i]
						cm:force_add_trait(new_char_lookup, trait_to_copy)
					end
				end
				cm:replenish_action_points(new_char_lookup, 100)
				cm:add_agent_experience(new_char_lookup, old_char_details.rank, true)
				cm:set_character_unique(cm:char_lookup_str(cqi),true)
            end
        );
	end,
	true
)


