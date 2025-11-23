
local norsca_ror_table={
    {"wh_dlc08_nor_art_hellcannon_battery", "wh_dlc08_nor_art_hellcannon_battery"},
    {"wh_pro04_nor_mon_war_mammoth_ror_0", "wh_pro04_nor_mon_war_mammoth_ror_0"},
    {"wh_dlc08_nor_mon_frost_wyrm_ror_0", "wh_dlc08_nor_mon_frost_wyrm_ror_0"},
    {"wh_pro04_nor_inf_chaos_marauders_ror_0","wh_pro04_nor_inf_chaos_marauders_ror_0"}, 
    {"wh_pro04_nor_mon_fimir_ror_0", "wh_pro04_nor_mon_fimir_ror_0"},
    {"wh_pro04_nor_mon_marauder_warwolves_ror_0", "wh_pro04_nor_mon_warwolves_ror_0"},
    {"wh_pro04_nor_inf_marauder_berserkers_ror_0","wh_pro04_nor_inf_marauder_berserkers_ror_0"},
    {"wh_pro04_nor_mon_skinwolves_ror_0","wh_pro04_nor_mon_skinwolves_ror_0"}, 
    {"wh_dlc08_nor_mon_war_mammoth_ror_1", "wh_dlc08_nor_mon_war_mammoth_ror_1"},
}


local function rhox_add_warriors_units (faction_obj, unit_group)
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
			v[1].."_warriors_faction_pool"
		);
	end	
end

local function rhox_add_faction_pool_units (faction_obj, unit_group)
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
			v[1].."_faction_pool"
		);
	end	
end


local function rhox_transfer_region(region_key, faction_key)
    local target_region = cm:get_region(region_key)
    cm:transfer_region_to_faction(region_key,faction_key)
    cm:heal_garrison(target_region:cqi())
end

local rhox_faction_list={
    wh3_dlc20_nor_dolgan ={
        leader={
            subtype="hkrul_sayl",
            unit_list="wh_main_nor_inf_chaos_marauders_1,wh_dlc08_nor_mon_war_mammoth_0,wh_main_nor_mon_chaos_warhounds_1,wh_dlc08_nor_mon_war_mammoth_0,wh_main_nor_inf_chaos_marauders_1",
            forename ="names_name_5670700451",
            familiyname ="names_name_5670700450",
        },
        how_they_play="rhox_fc_norsca_dolgan_how_they_play",
        pic=800,
        faction_trait="hkrul_sayl_faction_trait",
        kill_previous_leader=true,
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
            
            cm:spawn_unique_agent_at_character(faction:command_queue_index(), "hkrul_lokjar", faction:faction_leader():command_queue_index(), true)
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    wh_dlc08_nor_vanaheimlings ={
        leader={
            subtype="hkrul_drenok",
            unit_list="dead_drenok_ice_golem,wh_dlc08_nor_mon_frost_wyrm_0,wh_dlc08_nor_cav_marauder_warwolves_chariot_0,dead_drenok_ice_bears,wh_dlc08_nor_mon_warwolves_0",
            forename ="names_name_5680700356",
            familiyname ="names_name_5680700355",
        },
        agent={	
            type="dignitary",
            subtype="wh_dlc08_nor_fimir_balefiend_shadow"
        },
        how_they_play="rhox_fc_norsca_icefang_how_they_play",
        pic=800,
        faction_trait="hkrul_drenok_faction_trait",
        kill_previous_leader=true,
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
            cm:add_unit_to_faction_mercenary_pool(faction,"dead_drenok_ice_golem","renown",0,100,20,0,"","","",true,"dead_drenok_ice_golem")
            cm:add_unit_to_faction_mercenary_pool(faction,"dead_drenok_ice_bears","renown",0,100,20,0,"","","",true,"dead_drenok_ice_bears")
            cm:add_unit_to_faction_mercenary_pool(faction,"dead_drenok_greater_ice_golem","renown",0,100,20,0,"","","",true,"dead_drenok_greater_ice_golem")
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    wh_main_nor_baersonling ={
        leader={
            subtype="hkrul_einar",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_1,wh_main_nor_inf_chaos_marauders_0,wh_dlc08_nor_inf_marauder_hunters_0,wh3_dlc24_tze_mon_cockatrice,wh3_main_monster_feral_ice_bears,hkrul_norsca_ymir_ror",
            forename ="names_name_5670700356",
            familiyname ="names_name_5670700355",
        },	
        how_they_play="rhox_fc_norsca_baersonling_how_they_play",
        pic=800,
        faction_trait="hkrul_einar_faction_trait",
        kill_previous_leader=true,
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
            cm:spawn_unique_agent_at_character(faction:command_queue_index(), "hkrul_rafn", faction:faction_leader():command_queue_index(), true)
            cm:spawn_unique_agent_at_character(faction:command_queue_index(), "scm_norsca_asta", faction:faction_leader():command_queue_index(), true)
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    wh_main_nor_bjornling ={
        leader={
            subtype="hkrul_ulfric",
             unit_list="rhox_bjornling_huscarl,hkrul_norsca_ymir,wh_dlc08_nor_inf_marauder_hunters_1,nor_longship_ror,wh_dlc08_nor_mon_norscan_giant_0",
            forename ="names_name_5270700351",
            familiyname ="names_name_5270700350",
        },	
        how_they_play="rhox_fc_norsca_bjornling_how_they_play",
        pic=800,
        faction_trait="hkrul_ulfric_faction_trait",
        kill_previous_leader=true,
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
		    cm:add_unit_to_faction_mercenary_pool(faction,"wh_pro04_nor_mon_fimir_ror_0","renown",0,0,0,0,"","","",true,"wh_pro04_nor_mon_fimir_ror_0")
            cm:spawn_unique_agent_at_character(faction:command_queue_index(), "hkrul_oda", faction:faction_leader():command_queue_index(), true)
            cm:make_diplomacy_available(faction_key, "wh_main_emp_nordland")
            cm:force_make_trade_agreement(faction_key, "wh_main_emp_nordland")
            
            if faction:is_human() then
                
                --this is because they don't get allegiance
                cm:set_saved_value("norscan_favour_lvl_3_reached_" .. faction_key, true) --this will also block hunting rewards
                cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "attain_chaos_god_favour_lvl_2", true)
                cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "attain_chaos_god_favour", true)

            end
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    wh_main_nor_graeling ={
        leader={
            subtype="hkrul_harald",
            unit_list="wh_dlc08_nor_inf_marauder_berserkers_0,wh_dlc08_nor_inf_marauder_berserkers_0,wh_dlc08_nor_inf_marauder_hunters_0,wh_dlc08_nor_mon_skinwolves_1,wh_main_nor_mon_chaos_warhounds_1,rhox_graeling_werekin_of_fijgard",
            forename ="names_name_5670700351",
            familiyname ="names_name_5670700350",
        },	
        how_they_play="rhox_fc_norsca_graeling_how_they_play",
        pic=800,
        faction_trait="hkrul_harald_faction_trait",
        kill_previous_leader=true,
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
            unit_list="wh_dlc08_nor_feral_manticore,wh_main_nor_inf_chaos_marauders_1,wh_dlc08_nor_inf_marauder_hunters_1,wh_dlc08_nor_inf_marauder_hunters_1,wh_main_nor_mon_chaos_trolls,wh_main_nor_inf_chaos_marauders_1,hkrul_sarl_hunters_ror",
            forename ="names_name_5682700361",
            familiyname ="names_name_5682700360",
        },
        agent={
            type="wizard",
            subtype="wh_dlc08_nor_shaman_sorcerer_death"
        },
        how_they_play="rhox_fc_norsca_wh_main_nor_sarl_how_they_play",
        pic=800,
        faction_trait="hkrul_birna_faction_trait",
        kill_previous_leader=true,
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:spawn_unique_agent_at_character(faction:command_queue_index(), "hkrul_mortensen", faction:faction_leader():command_queue_index(), true)

        end,
        first_tick = function(faction, faction_key) 
        end
    },
    wh_main_nor_aesling ={
        leader={
            subtype="hkrul_hakka",
            unit_list="wh_dlc08_nor_inf_marauder_champions_1,wh_dlc08_nor_inf_marauder_berserkers_0,scm_fc_norsca_aesling_nor_marauder,scm_fc_norsca_aesling_nor_marauder,hkrul_skraevold,wh_main_nor_inf_chaos_marauders_1,wh_main_nor_inf_chaos_marauders_1",
            forename ="names_name_2570700351",
            familiyname ="names_name_2570700350",
        },
        how_they_play="rhox_fc_norsca_wh_main_nor_aesling_how_they_play",
        pic=800,
        faction_trait="hkrul_hakka_faction_trait",
        kill_previous_leader="human_only",--they're first target of Throgg, so needs to be careful
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
		    cm:spawn_unique_agent_at_character(faction:command_queue_index(), "hkrul_kolsveinn", faction:faction_leader():command_queue_index(), true)
		    cm:spawn_unique_agent_at_character(faction:command_queue_index(), "scm_norsca_alfkael", faction:faction_leader():command_queue_index(), true)
		    cm:spawn_unique_agent_at_character(faction:command_queue_index(), "hkrul_olaf", faction:faction_leader():command_queue_index(), true)
		    cm:spawn_unique_agent_at_character(faction:command_queue_index(), "hkrul_tuula", faction:faction_leader():command_queue_index(), true)
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    cr_nor_brennuns ={
        leader={
            subtype="hkrul_yngve",
            unit_list="wh_dlc08_nor_feral_manticore,wh_main_nor_inf_chaos_marauders_1,wh_dlc08_nor_mon_norscan_giant_0,wh_dlc08_nor_mon_norscan_giant_0,wh_main_nor_inf_chaos_marauders_1,wh_dlc08_nor_inf_marauder_hunters_1",
            forename ="names_name_5670700633",
            familiyname ="names_name_5670700632",
        },	
        agent={
            type="champion",
            subtype="wh_dlc08_nor_skin_wolf_werekin"            
        },
        region="cr_oldworld_region_crow_brethren_roost",
        how_they_play="rhox_fc_norsca_brennuns_how_they_play",
        pic=800,
        faction_trait="hkrul_yngve_faction_trait",
        kill_previous_leader="human_only",--they're first target of Azazel, so needs to be careful
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
        end,
        first_tick = function(faction, faction_key) 
        end
    },    
    wh_main_nor_varg ={
        leader={
            subtype="hkrul_surtha_ek",
            unit_list="wh_dlc08_nor_inf_marauder_berserkers_0,wh_main_nor_inf_chaos_marauders_0,wh_main_chs_mon_chaos_spawn,wh_main_nor_cav_chaos_chariot,wh_main_nor_cav_chaos_chariot,wh_dlc08_nor_veh_marauder_warwolves_chariot_0",
            forename ="names_name_2147345608",
            familiyname ="names_name_2147345760",
        },	
        agent={
            type="dignitary",
            subtype="wh_dlc08_nor_fimir_balefiend_fire"
        },
        how_they_play="rhox_fc_norsca_varg_how_they_play",
        pic=800,
        faction_trait="hkrul_ek_faction_trait",
        kill_previous_leader=true,
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
		    cm:add_unit_to_faction_mercenary_pool(faction, "wh_mod_nor_veh_mammoth_siege_tower_0", "renown", 1, 20, 1, 0.1, "", "", "", true, "wh_mod_nor_veh_mammoth_siege_tower_0")
		    cm:add_event_restricted_unit_record_for_faction("wh_mod_nor_veh_mammoth_siege_tower_0", faction_key, "wh_mod_nor_veh_mammoth_siege_tower_0_lock")
            if faction:is_human() then
                local mm = mission_manager:new(faction_key, "rhox_varg_hrothgar_mission")
                mm:add_new_objective("SCRIPTED");
                mm:add_condition("script_key rhox_varg_devotion");
                mm:add_condition("override_text mission_text_text_rhox_varg_devotion");
                mm:add_payload("text_display rhox_varg_hrothgar_joins");
                mm:trigger()
            end
            
            local function rhox_add_faction_varg_pool_units (faction_obj, unit_group)
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
                        "rhox_varg_"..v[1]
                    );
                end	
            end
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
            local rhox_varg_units = {
                ---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
                    {"wh3_main_kho_mon_spawn_of_khorne_0", "nurgle_buildings", 0, 0, 20},
                    {"wh3_main_nur_mon_spawn_of_nurgle_0", "nurgle_buildings", 0, 0, 20},
                    {"wh3_main_sla_mon_spawn_of_slaanesh_0", "nurgle_buildings", 0, 0, 20},
                    {"wh3_main_tze_mon_spawn_of_tzeentch_0", "nurgle_buildings", 0, 0, 20},
                    {"wh_main_chs_mon_chaos_spawn", "nurgle_buildings", 0, 0, 20},
            }
            
            rhox_add_faction_varg_pool_units(faction, rhox_varg_units)
            
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    wh_dlc08_nor_naglfarlings ={
        leader={
            subtype="scm_norsca_huern",
            unit_list="wh_dlc08_nor_mon_warwolves_0,wh_dlc08_nor_mon_warwolves_0,wh_dlc08_nor_mon_skinwolves_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_1",
            forename ="names_name_240922",
            familiyname ="names_name_240923",
        },	
        how_they_play="rhox_fc_norsca_wh_dlc08_nor_naglfarlings_how_they_play",
        pic=800,
        faction_trait="wh_mod_lord_trait_nor_naglfarings",
        kill_previous_leader=true,
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
		    cm:spawn_unique_agent_at_character(faction:command_queue_index(), "scm_norsca_ulsdau", faction:faction_leader():command_queue_index(), true)
		    cm:spawn_unique_agent_at_character(faction:command_queue_index(), "hkrul_graill", faction:faction_leader():command_queue_index(), true)
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    mixer_nor_beorg ={
        leader={
            subtype="hkrul_beorg",
            unit_list="wh_main_nor_mon_chaos_warhounds_0,hkrul_bearmen,hkrul_beorg_brown_feral,hkrul_beorg_brown_feral,hkrul_beorg_brown_feral_marked",
            forename ="names_name_5677700722",
            familiyname ="names_name_5677700721",
        },
        hand_over_region="cr_oldworld_region_hall_of_urslo",
        region="cr_oldworld_region_hall_of_urslo",
        how_they_play="rhox_iee_lccp_how_they_play_beorg",
        pic=800,
        faction_trait="rhox_beorg_faction_trait",
        additional = function(faction, faction_key)
            for i, ror in pairs(norsca_ror_table) do
                cm:add_unit_to_faction_mercenary_pool(faction,ror[1],"renown",1,100,1,0.1,"","","",true,ror[2])
            end 
            cm:add_unit_to_faction_mercenary_pool(faction,"hkrul_beorg_brown_feral","renown",0,100,20,0,"","","",true,"hkrul_beorg_brown_feral")
            cm:add_unit_to_faction_mercenary_pool(faction,"hkrul_beorg_brown_feral_marked","renown",0,100,20,0,"","","",true,"hkrul_beorg_brown_feral_marked")
            cm:add_unit_to_faction_mercenary_pool(faction,"hkrul_beorg_ice_feral","renown",0,100,20,0,"","","",true,"hkrul_beorg_ice_feral")
            
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
		    cm:spawn_unique_agent(faction:command_queue_index(), "hkrul_oerl", true)
		    
		    if cm:get_faction("cr_nor_ursfjordlings"):is_human() == false then
                cm:force_confederation("mixer_nor_beorg", "cr_nor_ursfjordlings")
		    end

        end,
        first_tick = function(faction, faction_key) 
        end
    },
    mixer_nor_geimdall_huscarls = {
    leader = {
        subtype = "hkrul_geimdall",
        unit_list = "wh_main_nor_inf_chaos_marauders_0,rhox_bjornling_huscarl_ror,wh_main_nor_mon_chaos_trolls,wh_dlc08_nor_inf_marauder_hunters_1,wh_dlc08_nor_mon_skinwolves_1,wh_dlc08_nor_mon_warwolves_0",
        forename = "names_name_7610711834",
        familiyname = "names_name_7610711833",  -- Fixed typo
    },
    hand_over_region = "cr_oldworld_region_oseberg",
    region = "cr_oldworld_region_oseberg",

    agent = {    
        type = "spy",
        subtype = "hkrul_skald_drum"
    },

    how_they_play = "rhox_fc_norsca_geimdall_how_they_play",
    pic = 800,
    faction_trait = "hkrul_geimdall_faction_trait",
    kill_previous_leader = true,

    additional = function(faction, faction_key)
        cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1", faction_key, "norsca_monster_hunt_ror_unlock")
        cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock")
        cm:spawn_unique_agent(faction:command_queue_index(), "hkrul_hildr", true)
        cm:force_declare_war("mixer_nor_geimdall_huscarls", "cr_teb_order_of_the_blazing_sun", false, false)

        if faction:is_human() then
            -- This is because they don't get allegiance
            cm:set_saved_value("norscan_favour_lvl_3_reached_" .. faction_key, true) -- This will also block hunting rewards
            cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "attain_chaos_god_favour_lvl_2", true)
            cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "attain_chaos_god_favour", true)
        end
    end,

    first_tick = function(faction, faction_key)
        -- Placeholder for potential first-tick logic
    end
    },
    --[[
    mixer_nor_snaegr = {
    leader = {
        subtype = "hkrul_olaf",
        unit_list = "wh3_dlc20_chs_inf_chaos_marauders_mkho_dualweapons,wh_main_chs_art_hellcannon,wh3_dlc20_chs_inf_chaos_marauders_mkho,wh_dlc08_nor_inf_marauder_hunters_0,wh_dlc08_nor_feral_manticore,wh_dlc08_nor_mon_warwolves_0,wh3_main_kho_inf_flesh_hounds_of_khorne_0",
        forename = "names_name_3610711834",
        familiyname = "names_name_3610711833",  -- Fixed typo
    },
    hand_over_region = "cr_oldworld_region_aarvik",
    region = "cr_oldworld_region_aarvik",

    agent = {    
        type = "wizard",
        subtype = "wh_dlc08_nor_shaman_sorcerer_fire"
    },

    how_they_play = "rhox_fc_norsca_olaf_how_they_play",
    pic = 800,
    faction_trait = "hkrul_olaf_faction_trait",
    kill_previous_leader = true,
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:spawn_unique_agent(faction:command_queue_index(), "hkrul_tuula", true)
		    cm:force_declare_war("mixer_nor_snaegr", "wh_main_nor_skaeling", false, false)
        end,
        first_tick = function(faction, faction_key) 
        end
    },--]] 
    wh3_dlc20_nor_yusak ={
        leader={
            subtype="hkrul_sarg",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh3_dlc20_chs_inf_chaos_warriors_msla,wh3_main_sla_inf_marauders_0,wh_dlc08_nor_cav_marauder_horsemasters_0,wh_main_nor_cav_marauder_horsemen_0,wh_main_nor_cav_marauder_horsemen_0,wh_main_nor_cav_marauder_horsemen_1",
            forename ="names_name_1770700351",
            familiyname ="names_name_1770700350",
        },
        how_they_play="rhox_fc_norsca_wh_main_nor_yusak_how_they_play",
        pic=800,
        faction_trait="hkrul_sarg_faction_trait",
        kill_previous_leader=true,
        additional = function(faction, faction_key)
		    cm:spawn_unique_agent_at_character(faction:command_queue_index(), "hkrul_uzul", faction:faction_leader():command_queue_index(), true)
            
            local rhox_sarg_gift_units = {
                ---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
                    {"wh3_main_sla_inf_daemonette_0", "daemonic_summoning", 1, 0, 4},
                    {"wh3_main_sla_mon_keeper_of_secrets_0", "daemonic_summoning", 0, 0, 2},
                    {"wh3_main_sla_mon_soul_grinder_0", "daemonic_summoning", 0, 0, 2},
                    {"wh3_main_sla_mon_fiends_of_slaanesh_0", "daemonic_summoning", 0, 0, 4},
                    {"wh_main_chs_art_hellcannon", "daemonic_summoning", 0, 0, 4},
                    {"wh3_main_sla_veh_seeker_chariot_0", "daemonic_summoning", 0, 0, 4}
            }
            local rhox_sarg_faction_units = {
                ---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
                    {"wh3_dlc20_chs_mon_warshrine", "daemonic_summoning", 0, 0, 2},
                    {"wh3_dlc20_chs_mon_warshrine_msla", "daemonic_summoning", 0, 0, 2},
            }
            rhox_add_warriors_units(cm:get_faction(faction_key), rhox_sarg_gift_units);
            rhox_add_faction_pool_units(cm:get_faction(faction_key), rhox_sarg_faction_units);
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    wh3_dlc20_nor_kul ={
        leader={
            subtype="hkrul_akkorak",
            unit_list="wh_dlc08_nor_cav_marauder_horsemasters_0,wh_dlc08_nor_cav_marauder_horsemasters_0,wh_main_chs_cav_chaos_knights_1,wh_main_chs_cav_chaos_knights_0,wh_main_chs_cav_chaos_knights_0,wh_main_nor_cav_marauder_horsemen_0",
            forename ="names_name_3670700351",
            familiyname ="names_name_3670700350",
        },	
        agent={
            type="dignitary",
            subtype="wh_dlc08_nor_fimir_balefiend_fire"
        },
        how_they_play="rhox_fc_norsca_kul_how_they_play",
        pic=800,
        faction_trait="hkrul_akkorak_faction_trait",
        kill_previous_leader=true,
        additional = function(faction, faction_key)
            local function rhox_add_faction_akkorak_pool_units (faction_obj, unit_group)
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
                        "rhox_akkorak_"..v[1]
                    );
                end	
            end
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
            local rhox_akkorak_units = {
                ---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
                    {"wh3_dlc20_chs_cav_chaos_knights_mkho", "daemonic_summoning_belakor", 0, 0, 20},
                    {"wh3_dlc20_chs_cav_chaos_knights_mkho_lances", "daemonic_summoning_belakor", 0, 0, 20},
                    {"wh3_main_tze_cav_chaos_knights_0", "daemonic_summoning_belakor", 0, 0, 20},
                    {"wh3_dlc20_chs_cav_chaos_knights_mtze_lances", "daemonic_summoning_belakor", 0, 0, 20},
                    {"wh3_dlc20_chs_cav_chaos_knights_mnur", "daemonic_summoning_belakor", 0, 0, 20},
                    {"wh3_dlc20_chs_cav_chaos_knights_mnur_lances", "daemonic_summoning_belakor", 0, 0, 20},
                    {"wh3_dlc20_chs_cav_chaos_knights_msla", "daemonic_summoning_belakor", 0, 0, 20},
                    {"wh3_dlc20_chs_cav_chaos_knights_msla_lances", "daemonic_summoning_belakor", 0, 0, 20},
                    {"wh_main_chs_cav_chaos_knights_0", "daemonic_summoning_belakor", 1, 0, 20},
                    {"wh_main_chs_cav_chaos_knights_1", "daemonic_summoning_belakor", 1, 0, 20},
            }
            
            rhox_add_faction_akkorak_pool_units(faction, rhox_akkorak_units)

        end,
        first_tick = function(faction, faction_key) 
        end
    },
    --[[mixer_nor_fjordlings ={
        leader={
            subtype="wh_main_nor_marauder_chieftain",
            unit_list="",
            x=604,
            y=911,
            forename ="",
            familiyname ="",
        },	
        how_they_play="rhox_fc_norsca_mixer_nor_fjordlings_how_they_play",
        pic=800,
        faction_trait="hkrul_vandred_faction_trait",
        kill_previous_leader=true,
        additional = function(faction, faction_key)
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
        end,
        first_tick = function(faction, faction_key) 
        end
    },--]]
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

            if not faction_info.region then
                faction_info.region = faction:home_region():name()
            end

            if not faction_info.leader.x or not faction_info.leader.y then
                faction_info.leader.x, faction_info.leader.y = cm:find_valid_spawn_location_for_character_from_settlement(
                    faction_key,
                    faction_info.region,
                    false,
                    true,
                    5
                )
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
                    cm:set_character_unique(cm:char_lookup_str(cqi),true)
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

local turn2_incidents={
    mixer_nor_geimdall_huscarls="rhox_geimdall_turn_two_incident",
    wh_main_nor_sarl="hkrul_birna_turn_two_incident",
    mixer_nor_snaegr="hkrul_olaf_turn_two_incident",
    wh_main_nor_baersonling="rhox_baersonling_chain_1",
}
cm:add_first_tick_callback(
	function()
        for faction_key, faction_info in pairs(rhox_faction_list) do
            pcall(function()
                mixer_set_faction_trait(faction_key, faction_info.faction_trait, true)
            end)
            faction_info.first_tick(cm:get_faction(faction_key), faction_key)
        end
        if cm:model():turn_number() < 3 then 
            core:add_listener(
                "rhox_fc_norsca_turn2_incidents_RoundStart",
                "FactionRoundStart",
                function(context)
                    return context:faction():is_human() and turn2_incidents[context:faction():name()] and cm:model():turn_number() == 2
                end,
                function(context)
                    local faction_key = context:faction():name()
                    local incident_key = turn2_incidents[faction_key]
                    local incident_builder = cm:create_incident_builder(incident_key)
                    cm:launch_custom_incident_from_builder(incident_builder, context:faction())
                end,
                true --might be multiple players
            )
        end
	end
)