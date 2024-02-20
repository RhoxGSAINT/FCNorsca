local faction_key_to_mission_key={
    wh2_dlc17_nor_deadwood_ravagers ={	"wh3_main_combi_region_the_twisted_towers", "wh3_main_combi_region_black_rock", "wh3_main_combi_region_the_silvered_tower_of_sorcerers" }, --Khrag
    wh2_main_nor_aghol={	"wh3_main_combi_region_fortress_of_the_damned", "wh3_main_combi_region_the_frozen_city" },
    wh2_main_nor_mung={	"wh3_main_combi_region_dagraks_end", "wh3_main_combi_region_the_palace_of_ruin" },
    --wh2_main_nor_skeggi={	"wh3_main_combi_region_skeggi" },--they don't actually have dark fortress
    wh3_dlc20_nor_dolgan={	"wh3_main_combi_region_the_challenge_stone", "wh3_main_combi_region_the_volary" },
    wh3_dlc20_nor_kul={	"wh3_main_combi_region_the_writhing_fortress", "wh3_main_combi_region_zanbaijin", "wh3_main_combi_region_karak_dum" },
    wh3_dlc20_nor_tong={	"wh3_main_combi_region_the_howling_citadel", "wh3_main_combi_region_the_crystal_spires" },
    wh3_dlc20_nor_yusak={	"wh3_main_combi_region_red_fortress", "wh3_main_combi_region_bloodwind_keep"},
    wh_dlc08_nor_goromadny_tribe={	"wh3_main_combi_region_karak_vlag", "wh3_main_combi_region_kraka_drak" },
    wh_dlc08_nor_naglfarlings={	"wh3_main_combi_region_doomkeep", "wh3_main_combi_region_altar_of_the_crimson_harvest" },
    wh_dlc08_nor_vanaheimlings={	"wh3_main_combi_region_konquata", "wh3_main_combi_region_monolith_of_borkill_the_bloody_handed" },
    wh_main_nor_baersonling	={"wh3_main_combi_region_praag" },
    wh_main_nor_sarl	={"wh3_main_combi_region_the_tower_of_khrakk" },
    wh_main_nor_varg	={"wh3_main_combi_region_the_monolith_of_katam", "wh3_main_combi_region_the_forbidden_citadel" },
}

local function rhox_fc_norsca_trigger_dark_fortress_mission_and_open_gate(faction_key)
    
    local regions = faction_key_to_mission_key[faction_key]
    
    local teleport_node_key = "rhox_fc_norsca_dark_fortress_teleport_"
    if cm:model():campaign_name_key() == "cr_combi_expanded" then
        teleport_node_key="rhox_fc_norsca_dark_fortress_teleport_iee_"
    end
    
    
    
    local mm = mission_manager:new(faction_key, "rhox_fc_norsca_protect_dark_fortress")
    mm:add_new_objective("OWN_N_REGIONS_INCLUDING")
    
    --out("Rhox FC Norsca: Number of regions: ".. #regions)
    
    for i = 1, #regions do
        --out("Rhox fc norsca: ".. regions[i])
        mm:add_condition("region "..regions[i]);
        --out("Rhox FC Norsca: "..teleport_node_key .. faction_key .. "_" .. tostring(i))
        cm:teleportation_network_open_node(teleport_node_key .. faction_key .. "_" .. tostring(i))--some of them misses actual node, but that won't cause issues, right?
        
    end
    mm:add_condition("total 900");--to make it uncompletable. they need to see what place is a Dark Fortress
    --mm:add_new_objective("SCRIPTED")
    --mm:add_condition("script_key rhox_fc_norsca_protect_dark_fortress")
    --mm:add_condition("override_text rhox_fc_norsca_protect_dark_fortress")
    mm:add_payload("text_display rhox_fc_norsca_protect_dark_fortress");
    mm:trigger()
    
    
    local incident_builder = cm:create_incident_builder("rhox_fc_norsca_darkfortress")
    core:add_listener(
        "rhox_fc_norsca_dark_fortress_incident",
        "ScriptEventIntroCutsceneFinished",
        true,
        function(context)
            cm:callback(function() cm:launch_custom_incident_from_builder(incident_builder, cm:get_faction(faction_key)) end, 0.5)
        end,
        false
    )
    
    
    
    --cm:callback(function() cm:launch_custom_incident_from_builder(incident_builder, cm:get_faction(faction_key)) end, 5);
end

local function rhox_transfer_region(region_key, faction_key)
    local target_region = cm:get_region(region_key)
    cm:transfer_region_to_faction(region_key,faction_key)
    cm:heal_garrison(target_region:cqi())
end

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
            unit_list="wh_main_nor_inf_chaos_marauders_1,wh_dlc08_nor_mon_war_mammoth_0,wh_main_nor_mon_chaos_warhounds_1,wh_dlc08_nor_mon_war_mammoth_0,wh_dlc08_nor_inf_marauder_hunters_0,wh_main_nor_inf_chaos_marauders_1",
            x=1012,
            y=723,
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
        enemy={
            key="wh3_main_ogr_fleshgreeders",
        },
        additional = function(faction, faction_key)
            local function rhox_add_faction_sayl_pool_units (faction_obj, unit_group)
                for i, v in pairs(unit_group) do
                    cm:add_unit_to_faction_mercenary_pool(
                        faction_obj,
                        v[1], -- key
                        v[2], -- recruitment source
                        v[3], -- count
                        v[4], --replen chance
                        v[5], -- max units
                        0, -- max per turn
                        "",	--faction restriction
                        "",	--subculture restriction
                        "",	--tech restriction
                        false, --partial
                        "rhox_sayl_"..v[1]
                    );
                end	
            end
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
            local rhox_sayl_units = {
                ---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
                    {"wh3_dlc20_chs_inf_chosen_mkho", "daemonic_summoning_belakor", 0, 0, 20},
                    {"wh3_dlc20_chs_inf_chosen_mkho_dualweapons", "daemonic_summoning_belakor", 0, 0, 20},
                    {"wh3_dlc20_chs_inf_chosen_mtze", "daemonic_summoning_belakor", 0, 0, 20},
                    {"wh3_dlc20_chs_inf_chosen_mtze_halberds", "daemonic_summoning_belakor", 0, 0, 20},
                    {"wh3_dlc20_chs_inf_chosen_mnur", "daemonic_summoning_belakor", 0, 0, 20},
                    {"wh3_dlc20_chs_inf_chosen_mnur_greatweapons", "daemonic_summoning_belakor", 0, 0, 20},
                    {"wh3_dlc20_chs_inf_chosen_msla", "daemonic_summoning_belakor", 0, 0, 20},
                    {"wh3_dlc20_chs_inf_chosen_msla_hellscourges", "daemonic_summoning_belakor", 0, 0, 20}
            }
            
            rhox_add_faction_sayl_pool_units(faction, rhox_sayl_units)
        end,
        first_tick = function(faction, faction_key) 
        end
    },

    wh3_dlc20_nor_kul ={
        leader={
            subtype="hkrul_akkorak",
            unit_list="wh_dlc08_nor_cav_marauder_horsemasters_0,wh_dlc08_nor_cav_marauder_horsemasters_0,wh_main_chs_cav_chaos_knights_1,wh_main_chs_cav_chaos_knights_0,wh_main_chs_cav_chaos_knights_0,wh_main_nor_cav_marauder_horsemen_0",
            x=922,
            y=878,
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
        enemy={
            key="wh3_main_sla_exquisite_pain",
        },
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 

        end,
        first_tick = function(faction, faction_key) 
        end
    },
    wh_dlc08_nor_vanaheimlings ={
        leader={
            subtype="hkrul_drenok",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_dlc08_nor_mon_frost_wyrm_0,wh_dlc08_nor_cav_marauder_warwolves_chariot_0,wh3_main_monster_feral_ice_bears,wh_dlc08_nor_mon_warwolves_0",
            x=352,
            y=733,
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
        enemy={
            key="wh3_dlc20_tze_the_sightless",
            subtype="wh3_dlc20_chs_sorcerer_lord_metal_mtze",
            unit_list="wh3_main_pro_tze_inf_blue_horrors_0,wh3_main_pro_tze_inf_blue_horrors_0",
            x=348,
            y=736
        },
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
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_1,wh_main_nor_inf_chaos_marauders_0,wh_dlc08_nor_inf_marauder_hunters_0,wh3_dlc24_tze_mon_cockatrice,wh3_main_monster_feral_ice_bears",
            x=729,
            y=700,
            forename ="names_name_5670700356",
            familiyname ="names_name_5670700355",
        },	
        region="wh3_main_combi_region_fort_jakova",
        how_they_play="rhox_fc_norsca_baersonling_how_they_play",
        pic=800,
        faction_trait="hkrul_einar_faction_trait",
        kill_previous_leader="human_only",--they're first target of Tzarina, so needs to be careful
        enemy={
            key="wh3_main_ogr_rock_skulls",
            subtype="wh3_main_ogr_tyrant",
            unit_list="wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_cav_crushers_1,wh3_main_ogr_inf_leadbelchers_0,wh3_main_ogr_inf_maneaters_0",
            x=736,
            y=712
        },
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
            cm:spawn_unique_agent_at_character(faction:command_queue_index(), "hkrul_rafn", faction:faction_leader():command_queue_index(), true)
            if faction:is_human() then
                rhox_transfer_region("wh3_main_combi_region_fort_jakova", "wh3_main_ogr_rock_skulls")
                rhox_transfer_region("wh3_main_combi_region_vitevo", "wh3_main_ksl_the_ice_court")
                
                local loop_char_list = faction:character_list()
				
				for i = 0, loop_char_list:num_items() - 1 do
					local looping = loop_char_list:item_at(i)
					if looping:forename("names_name_1010314968") and looping:surname("names_name_1240989680") then
                        local character_cqi= looping:command_queue_index();
						cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
                        cm:set_character_immortality(cm:char_lookup_str(character_cqi), false);          
                        cm:kill_character_and_commanded_unit(cm:char_lookup_str(character_cqi), true)
                        cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);
						break
					end
				end
            end
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    wh_main_nor_bjornling ={
        leader={
            subtype="hkrul_ulfric",
            unit_list="hkrul_bjornling_inf_marauder_spearman_0,hkrul_bjornling_inf_marauder_spearman_0,hkrul_bjornling_inf_chaos_marauders_0,wh_dlc08_nor_mon_norscan_giant_0,hkrul_bjornling_inf_marauder_champions_0",
            x=434,
            y=858,
            forename ="names_name_5270700351",
            familiyname ="names_name_5270700350",
        },	
        region="wh3_main_combi_region_troll_fjord",
        how_they_play="rhox_fc_norsca_bjornling_how_they_play",
        pic=800,
        faction_trait="hkrul_ulfric_faction_trait",
        kill_previous_leader=false,--they're first enemy of the Wulfric, so needs to be careful
        human_only_enemy={
            key="wh_main_nor_varg",
            subtype="wh_main_nor_marauder_chieftain",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_cav_chaos_chariot,wh_main_nor_cav_chaos_chariot,wh_dlc08_nor_inf_marauder_hunters_0",
            x=430,
            y=853
        },
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
            cm:spawn_unique_agent_at_character(faction:command_queue_index(), "hkrul_oda", faction:faction_leader():command_queue_index(), true)
            cm:make_diplomacy_available(faction_key, "wh_main_emp_nordland")
            cm:force_make_trade_agreement(faction_key, "wh_main_emp_nordland")
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    wh_main_nor_graeling ={
        leader={
            subtype="hkrul_harald",
            unit_list="wh_dlc08_nor_inf_marauder_berserkers_0,wh_dlc08_nor_inf_marauder_berserkers_0,wh_dlc08_nor_inf_marauder_hunters_0,wh_dlc08_nor_mon_skinwolves_1,wh_main_nor_mon_chaos_warhounds_1,wh_dlc08_nor_mon_skinwolves_0",
            x=488,
            y=827,
            forename ="names_name_5670700351",
            familiyname ="names_name_5670700350",
        },	
        region="wh3_main_combi_region_graeling_moot",
        how_they_play="rhox_fc_norsca_graeling_how_they_play",
        pic=800,
        faction_trait="hkrul_harald_faction_trait",
        kill_previous_leader=true,
        human_only_enemy={
            key="wh_dlc08_nor_naglfarlings",
            subtype="wh_main_nor_marauder_chieftain",
            unit_list="wh_main_nor_inf_chaos_marauders_1,wh_main_nor_inf_chaos_marauders_0,wh_dlc08_nor_feral_manticore,wh_dlc08_nor_inf_marauder_hunters_1,wh_main_nor_inf_chaos_marauders_1",
            x=495,
            y=827
        },
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
            unit_list="wh_dlc08_nor_feral_manticore,wh_main_nor_inf_chaos_marauders_1,wh_dlc08_nor_inf_marauder_hunters_1,wh_dlc08_nor_inf_marauder_hunters_1,wh_main_nor_mon_chaos_trolls,wh_main_nor_inf_chaos_marauders_1",
            x=624,
            y=815,
            forename ="names_name_5682700361",
            familiyname ="names_name_5682700360",
        },
        agent={
            type="wizard",
            subtype="wh_dlc08_nor_shaman_sorcerer_death"
        },
        region="wh3_main_combi_region_sarl_encampment",
        enemy={
            key="wh3_main_ksl_brotherhood_of_the_bear",
        },
        --[[human_only_enemy={
            key="wh_dlc08_nor_naglfarlings",
            subtype="wh_main_nor_marauder_chieftain",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0",
            x=565,
            y=843
        },]]
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
    wh_main_nor_aesling ={
        leader={
            subtype="hkrul_hakka",
            unit_list="wh_dlc08_nor_inf_marauder_champions_1,wh_dlc08_nor_inf_marauder_hunters_0,wh_dlc08_nor_mon_war_mammoth_0,wh_main_nor_inf_chaos_marauders_1,wh_main_nor_inf_chaos_marauders_1",
            x=638,
            y=858,
            forename ="names_name_2570700351",
            familiyname ="names_name_2570700350",
        },
        human_only_enemy={
            key="wh_dlc08_nor_wintertooth",
            subtype="wh_main_nor_marauder_chieftain",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_dlc08_nor_mon_norscan_ice_trolls_0,wh_main_nor_mon_chaos_trolls,wh_main_nor_mon_chaos_trolls",
            x=645,
            y=863
        },
        region="wh3_main_combi_region_the_forbidden_citadel",
        how_they_play="rhox_fc_norsca_wh_main_nor_aesling_how_they_play",
        pic=800,
        faction_trait="hkrul_hakka_faction_trait",
        kill_previous_leader="human_only",--they're first target of Throgg, so needs to be careful
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
		    cm:spawn_unique_agent_at_character(faction:command_queue_index(), "hkrul_kolsveinn", faction:faction_leader():command_queue_index(), true)
		    if faction:is_human() then                
                cm:transfer_region_to_faction("wh3_main_combi_region_altar_of_spawns","wh_dlc08_nor_wintertooth")
                local transferred_region = cm:get_region("wh3_main_combi_region_altar_of_spawns")
                local transferred_region_cqi = transferred_region:cqi()
                cm:heal_garrison(transferred_region_cqi)
            end
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    wh_main_nor_varg ={
        leader={
            subtype="hkrul_hrothgar",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0",
            x=470,
            y=867,
            forename ="names_name_7410711835",
            familiyname ="names_name_7410711834",
        },	
        agent={
            type="dignitary",
            subtype="wh_dlc08_nor_fimir_balefiend_fire"
        },
        region="wh3_main_combi_region_varg_camp",
        how_they_play="rhox_fc_norsca_varg_how_they_play",
        pic=800,
        faction_trait="hkrul_hrothgar_faction_trait",
        kill_previous_leader=false,--It's Surtha Ek, people will riot if we kill him
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 

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
        
        
        if vfs.exists("script/frontend/mod/ovn_albion_frontend.lua") then --have to make initial enemy for him
            rhox_faction_list["wh_dlc08_nor_vanaheimlings"].enemy=nil

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
            if faction_info.kill_previous_leader == "human_only" then
                if faction:is_human() then
                    cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
                    cm:set_character_immortality(cm:char_lookup_str(faction_leader_cqi), false);          
                    cm:kill_character_and_commanded_unit(cm:char_lookup_str(faction_leader_cqi), true)
                    cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);
                end
            elseif faction_info.kill_previous_leader then 
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
            if faction:is_human() and faction_key_to_mission_key[faction_key] then
                rhox_fc_norsca_trigger_dark_fortress_mission_and_open_gate(faction_key)
            end
            if faction:is_human() and faction_info.human_only_enemy then
                cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
                cm:force_declare_war(faction_key, faction_info.human_only_enemy.key, false, false)
                cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.5)
                
                
                if faction_info.human_only_enemy.subtype and cm:get_faction(faction_info.human_only_enemy.key):is_human() == false then
                    local x2=nil
                    local y2=nil
                    if faction_info.human_only_enemy.x and faction_info.human_only_enemy.y then
                        x2= faction_info.human_only_enemy.x
                        y2 = faction_info.human_only_enemy.y
                    else
                        x2,y2 = cm:find_valid_spawn_location_for_character_from_settlement(
                            faction_info.human_only_enemy.key,
                            faction_info.region,
                            false,
                            true,
                            20
                        )
                    end
                    
                    
                    cm:create_force_with_general(
                    -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
                    faction_info.human_only_enemy.key,
                    faction_info.human_only_enemy.unit_list,
                    faction_info.region,
                    x2,
                    y2,
                    "general",
                    faction_info.human_only_enemy.subtype,
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