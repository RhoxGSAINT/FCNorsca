local rhox_faction_list={
    wh2_main_nor_skeggi ={
        leader={
            subtype="hkrul_adella",
            unit_list="hkrul_skeggi_inf_chaos_marauders_0,wh2_main_lzd_mon_bastiladon_0,hkrul_skeggi_inf_chaos_marauders_0,hkrul_skeggi_giant,hkrul_skeggi_inf_marauder_hunters_1,hkrul_skeggi_inf_marauder_champions_1",
            x=115,
            y=512,
            forename ="names_name_5670500338",
            familiyname ="names_name_5670500337",
        },
        region="wh3_main_combi_region_skeggi",
        how_they_play="rhox_adella_how_they_play",
        pic=800,
        faction_trait="hkrul_adella_faction_trait",
        kill_previous_leader=true,
        enemy={
            key="wh2_main_def_ssildra_tor",
            subtype="wh2_main_def_dreadlord",
            unit_list="wh2_main_def_inf_bleakswords_0,wh2_main_def_inf_darkshards_1,wh2_main_def_inf_black_ark_corsairs_0,wh2_main_def_inf_black_ark_corsairs_0,wh2_main_def_inf_black_ark_corsairs_1",
            x=107,
            y=512
        },
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
		    --cm:spawn_unique_agent(faction:command_queue_index(), "hkrul_soren", true)
		    cm:spawn_unique_agent_at_character(faction:command_queue_index(), "hkrul_soren", faction:faction_leader():command_queue_index(), true)
		    
		    if faction:is_human() then
                local target_region = cm:get_region("wh3_main_combi_region_skeggi")
                cm:instantly_set_settlement_primary_slot_level(target_region:settlement(), 1)
                --local target_slot = target_region:slot_list():item_at(1)
                --cm:instantly_upgrade_building_in_region(target_slot, "wh_main_nor_garrison_2")
                cm:heal_garrison(target_region:cqi())
                
                target_region = cm:get_region("wh3_main_combi_region_ziggurat_of_dawn")
                cm:transfer_region_to_faction("wh3_main_combi_region_ziggurat_of_dawn","wh2_main_def_ssildra_tor")
                cm:heal_garrison(target_region:cqi())
                
                cm:add_event_restricted_building_record_for_faction("wh2_main_special_skeggi_hall", faction_key, "rhox_adella_skaeggi_hall_landmark_building_lock")
                --rhox_adella_landmark_mission
                local mm = mission_manager:new(faction_key, "rhox_adella_landmark_mission")
                mm:add_new_objective("MOVE_TO_REGION");
                mm:add_condition("region wh3_main_combi_region_troll_fjord");
                mm:add_payload("text_display rhox_adella_landmark");
                mm:add_payload("money 1000");
                mm:trigger()

            end
            

        end,
        first_tick = function(faction, faction_key) 
        end
    },	
    wh3_dlc20_nor_dolgan ={
        leader={
            subtype="hkrul_sayl",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0",
            x=1025,
            y=780,
            forename ="names_name_5670700451",
            familiyname ="names_name_5670700450",
        },
        agent={
            type="champion",
            subtype="wh_dlc08_nor_skin_wolf_werekin"
        },
        region="wh3_main_combi_region_floating_mountain",
        how_they_play="rhox_fc_norsca_dolgan_how_they_play",
        pic=800,
        faction_trait="hkrul_sayl_faction_trait",
        kill_previous_leader=true,
        --[[
        enemy={
            key="wh2_main_def_ssildra_tor",
            subtype="wh2_main_def_dreadlord",
            unit_list="wh2_main_def_inf_bleakswords_0,wh2_main_def_inf_darkshards_1",
            x=107,
            y=512
        },
        --]]
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 

        end,
        first_tick = function(faction, faction_key) 
        end
    },
    --[[--in development
    wh3_dlc20_nor_kul ={
        leader={
            subtype="hkrul_akkorak",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0",
            x=922,
            y=847,
            forename ="names_name_3670700351",
            familiyname ="names_name_3670700350",
        },	
        agent={
            type="dignitary",
            subtype="wh_dlc08_nor_fimir_balefiend_fire"
        },
        region="wh3_main_combi_region_the_bleeding_spire",
        how_they_play="rhox_fc_norsca_kul_how_they_play",
        pic=800,
        faction_trait="hkrul_akkorak_faction_trait",
        kill_previous_leader=true,
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 

        end,
        first_tick = function(faction, faction_key) 
        end
    },
    --]]
    wh_dlc08_nor_vanaheimlings ={
        leader={
            subtype="hkrul_drenok",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0",
            x=356,
            y=722,
            forename ="names_name_5680700356",
            familiyname ="names_name_5680700355",
        },
        agent={	
            type="dignitary",
            subtype="wh_dlc08_nor_fimir_balefiend_shadow"
        },
        region="wh3_main_combi_region_isle_of_wights",
        how_they_play="rhox_fc_norsca_icefang_how_they_play",
        pic=800,
        faction_trait="hkrul_drenok_faction_trait",
        kill_previous_leader=true,
        --[[
        enemy={
            key="wh2_main_def_ssildra_tor",
            subtype="wh2_main_def_dreadlord",
            unit_list="wh2_main_def_inf_bleakswords_0,wh2_main_def_inf_darkshards_1",
            x=107,
            y=512
        },
        --]]
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 

        end,
        first_tick = function(faction, faction_key) 
        end
    },
    wh_main_nor_baersonling ={
        leader={
            subtype="hkrul_einar",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0",
            x=729,
            y=700,
            forename ="names_name_5670700356",
            familiyname ="names_name_5670700355",
        },	
        agent={
            type="wizard",
            subtype="wh_dlc08_nor_shaman_sorcerer_death"
        },
        region="wh3_main_combi_region_fort_jakova",
        how_they_play="rhox_fc_norsca_baersonling_how_they_play",
        pic=800,
        faction_trait="hkrul_einar_faction_trait",
        kill_previous_leader=true,
        --[[
        enemy={
            key="wh2_main_def_ssildra_tor",
            subtype="wh2_main_def_dreadlord",
            unit_list="wh2_main_def_inf_bleakswords_0,wh2_main_def_inf_darkshards_1",
            x=107,
            y=512
        },
        --]]
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 

        end,
        first_tick = function(faction, faction_key) 
        end
    },
    wh_main_nor_bjornling ={
        leader={
            subtype="hkrul_ulfric",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0",
            x=390,
            y=792,
            forename ="names_name_5270700351",
            familiyname ="names_name_5270700350",
        },	
        agent={
            type="wizard",
            subtype="wh_dlc08_nor_shaman_sorcerer_fire"
        },
        region="wh3_main_combi_region_troll_fjord",
        how_they_play="rhox_fc_norsca_bjornling_how_they_play",
        pic=800,
        faction_trait="hkrul_ulfric_faction_trait",
        kill_previous_leader=false,--they're first enemy of the Wulfric, so needs to be careful
        --[[
        enemy={
            key="wh2_main_def_ssildra_tor",
            subtype="wh2_main_def_dreadlord",
            unit_list="wh2_main_def_inf_bleakswords_0,wh2_main_def_inf_darkshards_1",
            x=107,
            y=512
        },
        --]]
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 

        end,
        first_tick = function(faction, faction_key) 
        end
    },
    wh_main_nor_graeling ={
        leader={
            subtype="hkrul_harald",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0",
            x=473,
            y=822,
            forename ="names_name_5670700351",
            familiyname ="names_name_5670700350",
        },	
        --[[
        agent={
            type="wizard",
            subtype="wh_dlc08_nor_shaman_sorcerer_metal"
        },
        --]]
        region="wh3_main_combi_region_graeling_moot",
        how_they_play="rhox_fc_norsca_graeling_how_they_play",
        pic=800,
        faction_trait="hkrul_harald_faction_trait",
        kill_previous_leader=true,
        --[[
        enemy={
            key="wh2_main_def_ssildra_tor",
            subtype="wh2_main_def_dreadlord",
            unit_list="wh2_main_def_inf_bleakswords_0,wh2_main_def_inf_darkshards_1",
            x=107,
            y=512
        },
        --]]
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
            cm:spawn_unique_agent_at_character(faction:command_queue_index(), "hkrul_verdandi", faction:faction_leader():command_queue_index(), true)
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    wh_main_nor_sarl ={
        leader={
            subtype="hkrul_birna",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0",
            x=576,
            y=850,
            forename ="names_name_5682700361",
            familiyname ="names_name_5682700360",
        },
        agent={
            type="wizard",
            subtype="wh_dlc08_nor_shaman_sorcerer_death"
        },
        region="wh3_main_combi_region_sarl_encampment",
        how_they_play="rhox_fc_norsca_wh_main_nor_sarl_how_they_play",
        pic=800,
        faction_trait="hkrul_birna_faction_trait",
        kill_previous_leader=true,
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 

        end,
        first_tick = function(faction, faction_key) 
        end
    },
    wh_main_nor_graeling ={
        leader={
            subtype="hkrul_harald",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0",
            x=473,
            y=822,
            forename ="names_name_5670700351",
            familiyname ="names_name_5670700350",
        },	
        --[[
        agent={
            type="wizard",
            subtype="wh_dlc08_nor_shaman_sorcerer_metal"
        },
        --]]
        region="wh3_main_combi_region_graeling_moot",
        how_they_play="rhox_fc_norsca_graeling_how_they_play",
        pic=800,
        faction_trait="hkrul_harald_faction_trait",
        kill_previous_leader=true,
        --[[
        enemy={
            key="wh2_main_def_ssildra_tor",
            subtype="wh2_main_def_dreadlord",
            unit_list="wh2_main_def_inf_bleakswords_0,wh2_main_def_inf_darkshards_1",
            x=107,
            y=512
        },
        --]]
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
            cm:spawn_unique_agent_at_character(faction:command_queue_index(), "hkrul_verdandi", faction:faction_leader():command_queue_index(), true)
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    wh_main_nor_aesling ={
        leader={
            subtype="hkrul_kolsveinn",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0",
            x=612,
            y=850,
            forename ="names_name_516997750",
            familiyname ="names_name_516997749",
        },
        agent={
            type="dignitary",
            subtype="wh_dlc08_nor_fimir_balefiend_fire"
        },
        region="wh3_main_combi_region_the_forbidden_citadel",
        how_they_play="rhox_fc_norsca_wh_main_nor_aesling_how_they_play",
        pic=800,
        faction_trait="hkrul_kolsveinn_faction_trait",
        kill_previous_leader=false,--they're first target of Throgg, so needs to be careful
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
            cm:spawn_unique_agent_at_character(faction:command_queue_index(), "hkrul_swyrd", faction:faction_leader():command_queue_index(), true)
        end,
        first_tick = function(faction, faction_key) 
        end
    },
}



cm:add_first_tick_callback_new(
    function()
        if cm:is_multiplayer() then
            mixer_disable_starting_zoom = true
        end


        for faction_key, faction_info in pairs(rhox_faction_list) do
			local faction = cm:get_faction(faction_key);
            local faction_leader_cqi = faction:faction_leader():command_queue_index();

            if faction_info.hand_over_region then
                cm:transfer_region_to_faction(faction_info.hand_over_region,faction_key)
                local target_region_cqi = cm:get_region(faction_info.hand_over_region):cqi()
                cm:heal_garrison(target_region_cqi)
            end

            cm:create_force_with_general(
                -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
                faction_key,
                faction_info.leader.unit_list,
                faction_info.region,
                faction_info.leader.x,
                faction_info.leader.y,
                "general",
                faction_info.leader.subtype,
                faction_info.leader.forename,
                "",
                faction_info.leader.familiyname,
                "",
                true,
                function(cqi)
                end
            );
            if faction_info.kill_previous_leader then 
                cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
                cm:set_character_immortality(cm:char_lookup_str(faction_leader_cqi), false);          
                cm:kill_character_and_commanded_unit(cm:char_lookup_str(faction_leader_cqi), true)
                cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);
            end

            if faction_info.agent then
                local agent_x, agent_y = cm:find_valid_spawn_location_for_character_from_position(faction_key, faction_info.leader.x, faction_info.leader.y, false, 5);
                cm:create_agent(faction_key, faction_info.agent.type, faction_info.agent.subtype, agent_x, agent_y);       
            end

            if faction_info.enemy then
                cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
                cm:force_declare_war(faction_key, faction_info.enemy.key, false, false)
                cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.5)
                
                
                if faction_info.enemy.subtype and cm:get_faction(faction_info.enemy.key):is_human() == false then
                    local x2=nil
                    local y2=nil
                    if faction_info.enemy.x and faction_info.enemy.y then
                        x2= faction_info.enemy.x
                        y2 = faction_info.enemy.y
                    else
                        x2,y2 = cm:find_valid_spawn_location_for_character_from_settlement(
                            faction_info.enemy.key,
                            faction_info.region,
                            false,
                            true,
                            20
                        )
                    end
                    
                    
                    cm:create_force_with_general(
                    -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
                    faction_info.enemy.key,
                    faction_info.enemy.unit_list,
                    faction_info.region,
                    x2,
                    y2,
                    "general",
                    faction_info.enemy.subtype,
                    "",
                    "",
                    "",
                    "",
                    false,
                    function(cqi)
                    end);
                end
            end


            cm:callback(
                function()
                    cm:show_message_event(
                        faction_key,
                        "event_feed_strings_text_wh2_scripted_event_how_they_play_title",
                        "factions_screen_name_" .. faction_key,
                        "event_feed_strings_text_".. faction_info.how_they_play,
                        true,
                        faction_info.pic
                    );
                end,
                1
            )
            faction_info.additional(faction, faction_key)
		end
    end
)
cm:add_first_tick_callback(
	function()
        for faction_key, faction_info in pairs(rhox_faction_list) do
            pcall(function()
                mixer_set_faction_trait(faction_key, faction_info.faction_trait, true)
            end)
            faction_info.first_tick(cm:get_faction(faction_key), faction_key)
        end
	end
)
