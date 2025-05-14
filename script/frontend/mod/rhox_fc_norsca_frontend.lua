mixer_factions_that_require_dlc["mixer_nor_beorg"]="TW_WH1_NORSCA"
core:add_ui_created_callback(
	function(context)
		if vfs.exists("script/frontend/mod/mixer_frontend.lua")then
		
			mixer_change_lord_name("876077643", "hkrul_adella")
			mixer_add_starting_unit_list_for_faction("wh2_main_nor_skeggi", {"hkrul_skeggi_inf_chaos_marauders_0","hkrul_skeggi_giant","r1kko_adella_tze_bastiladon","hkrul_skeggi_inf_marauder_champions_1", "hkrul_skeggi_inf_marauder_hunters_1,rhox_skeggi_dodvakt"})
			mixer_add_faction_to_major_faction_list("wh2_main_nor_skeggi")
			
			mixer_change_lord_name("1176817909", "hkrul_sayl")
			mixer_change_lord_name("110688960", "hkrul_sayl")--TOW
			mixer_add_starting_unit_list_for_faction("wh3_dlc20_nor_dolgan", {"wh_dlc08_nor_mon_war_mammoth_0","wh_main_nor_mon_chaos_warhounds_1","hkrul_dummy_kurgan_chaos_marauders_1"})
			mixer_add_faction_to_major_faction_list("wh3_dlc20_nor_dolgan")
			
			mixer_change_lord_name("1503698398", "hkrul_drenok")
			mixer_change_lord_name("340463644", "hkrul_drenok")--TOW
			mixer_add_starting_unit_list_for_faction("wh_dlc08_nor_vanaheimlings", {"wh_dlc08_nor_mon_frost_wyrm_0","wh_dlc08_nor_mon_warwolves_0","dead_drenok_ice_golem","dead_drenok_ice_bears"})
			mixer_add_faction_to_major_faction_list("wh_dlc08_nor_vanaheimlings")
			
			mixer_change_lord_name("329040993", "hkrul_einar")
			mixer_change_lord_name("721832094", "hkrul_einar")--TOW
			mixer_add_starting_unit_list_for_faction("wh_main_nor_baersonling", {"wh3_main_monster_feral_ice_bears","hkrul_dummy_baersonling_inf_chaos_marauders_0","wh3_dlc24_tze_mon_cockatrice","hkrul_dummy_baersonling_marauder_hunters_0","hkrul_dummy_baersonling_chaos_marauders_1","hkrul_norsca_ymir_ror"})
			mixer_add_faction_to_major_faction_list("wh_main_nor_baersonling")
			
			mixer_change_lord_name("106797993", "hkrul_ulfric")
			mixer_change_lord_name("681891162", "hkrul_ulfric")--TOW
			mixer_add_starting_unit_list_for_faction("wh_main_nor_bjornling", {"hkrul_norsca_ymir","rhox_bjornling_huscarl","nor_longship_ror","hkrul_bjornling_inf_marauder_hunters_0","wh_dlc08_nor_mon_norscan_giant_0"})
			mixer_add_faction_to_major_faction_list("wh_main_nor_bjornling")
			
			mixer_change_lord_name("835161619", "hkrul_harald")
			mixer_change_lord_name("1926208045", "hkrul_harald")--TOW
			mixer_add_starting_unit_list_for_faction("wh_main_nor_graeling", {"wh_dlc08_nor_inf_marauder_berserkers_0","wh_dlc08_nor_inf_marauder_hunters_0","wh_main_nor_mon_chaos_warhounds_1","wh_dlc08_nor_mon_skinwolves_1","rhox_graeling_werekin_of_fijgard"})
			mixer_add_faction_to_major_faction_list("wh_main_nor_graeling")
			
			mixer_change_lord_name("383940030", "hkrul_birna")
			mixer_change_lord_name("1974292008", "hkrul_birna")--TOW
			mixer_add_starting_unit_list_for_faction("wh_main_nor_sarl", {"wh_dlc08_nor_feral_manticore","hkrul_dummy_sarl_marauder_hunters_0","hkrul_sarl_hunters_ror","hkrul_sarl_hunters","hkrul_birna_river_trolls","hkrul_dummy_sarl_chaos_marauders_1","hkrul_sarl_hunters_ror"})
			mixer_add_faction_to_major_faction_list("wh_main_nor_sarl")
			
			
			mixer_change_lord_name("960993442", "hkrul_hakka")
			mixer_change_lord_name("311474807", "hkrul_hakka")--TOW
			mixer_add_starting_unit_list_for_faction("wh_main_nor_aesling", {"hkrul_dummy_aesling_inf_marauder_champions_1","scm_fc_norsca_aesling_nor_marauder","hkrul_skraevold","hkrul_dummy_aesling_inf_marauder_berserkers_0","wh_dlc08_nor_mon_war_mammoth_0","scm_fc_norsca_aesling_nor_marauder_great_weapons"})
			mixer_add_faction_to_major_faction_list("wh_main_nor_aesling")
			
			mixer_change_lord_name("1752931370", "hkrul_surtha_ek")
			mixer_change_lord_name("1244242706", "hkrul_surtha_ek")--TOW
			mixer_add_starting_unit_list_for_faction("wh_main_nor_varg", {"hkrul_dummy_varg_inf_marauder_berserkers_0","wh_main_chs_mon_chaos_spawn","hkrul_dummy_varg_inf_chaos_marauders_0","wh_dlc08_nor_veh_marauder_warwolves_chariot_0","wh_main_nor_cav_chaos_chariot"})
			mixer_add_faction_to_major_faction_list("wh_main_nor_varg")
			
			
			mixer_change_lord_name("1523023879", "hkrul_akkorak")
			mixer_add_starting_unit_list_for_faction("wh3_dlc20_nor_kul", {"wh_main_chs_cav_chaos_knights_0","wh_main_chs_cav_chaos_knights_1","wh_main_nor_cav_marauder_horsemen_0","wh_dlc08_nor_cav_marauder_horsemasters_0"})
			mixer_add_faction_to_major_faction_list("wh3_dlc20_nor_kul")
			
			mixer_change_lord_name("1519128795", "hkrul_sarg")
			mixer_add_starting_unit_list_for_faction("wh3_dlc20_nor_yusak", {"scm_fc_norsca_yusak_nor_marauder","wh3_dlc20_chs_inf_chaos_warriors_msla","hkrul_dummy_yusak_marauder_horsemen_0","hkrul_dummy_yusak_marauder_horsemen_1"})
			mixer_add_faction_to_major_faction_list("wh3_dlc20_nor_yusak")
			
			mixer_change_lord_name("1657503126", "scm_norsca_huern")
			mixer_change_lord_name("59318390", "scm_norsca_huern")--TOW
			mixer_add_starting_unit_list_for_faction("wh_dlc08_nor_naglfarlings",
            {"wh_dlc08_nor_mon_warwolves_0", "wh_dlc08_nor_mon_warwolves_0", "wh_dlc08_nor_mon_skinwolves_0", "hkrul_dummy_wolf_inf_chaos_marauders_0","hkrul_dummy_wolf_chaos_marauders_1"})
            mixer_add_faction_to_major_faction_list("wh_dlc08_nor_naglfarlings")
            
            mixer_change_lord_name("1902922690", "hkrul_beorg")
            mixer_enable_custom_faction("1902922690")
            mixer_add_starting_unit_list_for_faction("mixer_nor_beorg", {"hkrul_beorg_brown_feral","wh_main_nor_mon_chaos_warhounds_0","hkrul_bearmen","hkrul_beorg_brown_feral_marked"})
            mixer_add_faction_to_major_faction_list("mixer_nor_beorg")    
        
            mixer_change_lord_name("1929903855", "hkrul_geimdall")
            mixer_enable_custom_faction("1929903855")
            mixer_add_starting_unit_list_for_faction("mixer_nor_geimdall_huscarls", {"hkrul_bjornling_inf_chaos_marauders_0","rhox_bjornling_huscarl_ror","wh_main_nor_mon_chaos_warhounds_0","hkrul_bjornling_inf_marauder_hunters_0"})
            mixer_add_faction_to_major_faction_list("mixer_nor_geimdall_huscarls")

            -------TOW ones
            mixer_change_lord_name("1266743791", "hkrul_beorg")
            mixer_enable_custom_faction("1266743791")
            
            mixer_change_lord_name("1140359289", "hkrul_sarg")
			mixer_change_lord_name("1105930739", "hkrul_akkorak")
            
            mixer_change_lord_name("1319642446", "hkrul_geimdall")
            mixer_enable_custom_faction("1319642446")
            
            mixer_change_lord_name("1388671848", "hkrul_yngve")
            mixer_enable_custom_faction("1388671848")
            mixer_add_faction_to_major_faction_list("cr_nor_brennuns")            
            mixer_add_starting_unit_list_for_faction("cr_nor_brennuns", {"wh_dlc08_nor_feral_manticore","wh_dlc08_nor_mon_norscan_giant_0","wh_main_nor_inf_chaos_marauders_1","wh_dlc08_nor_inf_marauder_hunters_1"})
            --mixer_enable_custom_faction("718726083")
            --mixer_add_starting_unit_list_for_faction("mixer_nor_fjordlings", {"wh_main_nor_cav_marauder_horsemen_0"})
			--mixer_add_faction_to_major_faction_list("mixer_nor_fjordlings")
            mixer_change_lord_name("1821595411", "hkrul_olaf")
            mixer_enable_custom_faction("1821595411")
            mixer_add_faction_to_major_faction_list("mixer_nor_snaegr")            
            mixer_add_starting_unit_list_for_faction("mixer_nor_snaegr", {"wh_dlc08_nor_feral_manticore","wh3_dlc20_chs_inf_chaos_marauders_mkho","wh3_dlc20_chs_inf_chaos_marauders_mkho_dualweapons","wh_main_chs_art_hellcannon","hkrul_dummy_bloodfjord_marauder_hunters_0"})			
		end		
	end
)