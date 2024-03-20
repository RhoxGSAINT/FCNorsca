local function scm_norsca_huern_start()
	if cm:is_new_game() then

        out("XXX Huern Begin XXX");
        local wolftribe = cm:get_faction("wh_dlc08_nor_naglfarlings");
        local wolftribe_faction_leader_cqi = wolftribe:faction_leader():command_queue_index();
        cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
        cm:set_character_immortality(cm:char_lookup_str(wolftribe_faction_leader_cqi), false);          
        cm:kill_character(wolftribe_faction_leader_cqi, true, true);
        cm:disable_event_feed_events(false, "wh_event_category_character", "", "")
        cm:create_force_with_general(
                        -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
                        "wh_dlc08_nor_naglfarlings",
                        "wolftribe_nor_inf_wolf_champions_ror_0,wh_dlc08_nor_mon_warwolves_0,wh_dlc08_nor_mon_warwolves_0,wh_dlc08_nor_mon_skinwolves_0,wh_dlc08_nor_mon_skinwolves_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0", -- unit
                        "cr_oldworld_region_naglheim",
                        760,
                        1320,
                        "general",
                        "scm_norsca_huern",
                        "names_name_240922",
                        "",
                        "names_name_240923",
                        "",
                        true,-- make_faction_leader,
                        function(cqi) -- callback
                            local str = "character_cqi:" .. cqi
                            cm:set_character_immortality(str, true);
                            cm:set_character_unique(str, true);
                        end
                    ); 
        
        cm:apply_effect_bundle("wh_mod_lord_trait_nor_naglfarings", "wh_dlc08_nor_naglfarlings", 0 );
        
	end;
end;

-- Rename replace_starting_general to match the function name at the top
cm:add_first_tick_callback(function() scm_norsca_huern_start() end);