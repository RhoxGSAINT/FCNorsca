
core:add_ui_created_callback(
	function(context)
		if vfs.exists("script/frontend/mod/mixer_frontend.lua")then
		
			mixer_change_lord_name("876077643", "hkrul_adella")
			mixer_add_starting_unit_list_for_faction("wh2_main_nor_skeggi", {"hkrul_skeggi_inf_chaos_marauders_0","hkrul_skeggi_giant","wh2_main_lzd_mon_bastiladon_0","hkrul_skeggi_inf_marauder_champions_1", "hkrul_skeggi_inf_marauder_hunters_1"})
			mixer_add_faction_to_major_faction_list("wh2_main_nor_skeggi")
			
			mixer_change_lord_name("1176817909", "hkrul_sayl")
			mixer_add_starting_unit_list_for_faction("wh3_dlc20_nor_dolgan", {"wh_dlc08_nor_mon_war_mammoth_0","wh_main_nor_mon_chaos_warhounds_1","hkrul_dummy_kurgan_chaos_marauders_1"})
			mixer_add_faction_to_major_faction_list("wh3_dlc20_nor_dolgan")
			
			mixer_change_lord_name("1503698398", "hkrul_drenok")
			mixer_add_starting_unit_list_for_faction("wh_dlc08_nor_vanaheimlings", {"wh_main_nor_inf_chaos_marauders_0","wh_dlc08_nor_mon_frost_wyrm_0","wh_dlc08_nor_mon_warwolves_0","dead_drenok_ice_bears"})
			mixer_add_faction_to_major_faction_list("wh_dlc08_nor_vanaheimlings")
			
			mixer_change_lord_name("329040993", "hkrul_einar")
			mixer_add_starting_unit_list_for_faction("wh_main_nor_baersonling", {"wh3_main_monster_feral_ice_bears","hkrul_dummy_baersonling_inf_chaos_marauders_0","wh3_dlc24_tze_mon_cockatrice","hkrul_dummy_baersonling_marauder_hunters_0","hkrul_dummy_baersonling_chaos_marauders_1"})
			mixer_add_faction_to_major_faction_list("wh_main_nor_baersonling")
			
			mixer_change_lord_name("106797993", "hkrul_ulfric")
			mixer_add_starting_unit_list_for_faction("wh_main_nor_bjornling", {"hkrul_bjornling_inf_marauder_champions_0","rhox_bjornling_huscarl_ror","wh_dlc08_nor_mon_norscan_giant_0","hkrul_bjornling_inf_marauder_spearman_0"})
			mixer_add_faction_to_major_faction_list("wh_main_nor_bjornling")
			
			mixer_change_lord_name("835161619", "hkrul_harald")
			mixer_add_starting_unit_list_for_faction("wh_main_nor_graeling", {"wh_dlc08_nor_inf_marauder_berserkers_0","wh_dlc08_nor_inf_marauder_hunters_0","wh_main_nor_mon_chaos_warhounds_1","wh_dlc08_nor_mon_skinwolves_1","wh_dlc08_nor_mon_skinwolves_0"})
			mixer_add_faction_to_major_faction_list("wh_main_nor_graeling")
			
			mixer_change_lord_name("383940030", "hkrul_birna")
			mixer_add_starting_unit_list_for_faction("wh_main_nor_sarl", {"wh_dlc08_nor_feral_manticore","wh_dlc08_nor_inf_marauder_hunters_1","wh_main_nor_mon_chaos_trolls","wh_main_nor_inf_chaos_marauders_1"})
			mixer_add_faction_to_major_faction_list("wh_main_nor_sarl")
			
			
			mixer_change_lord_name("960993442", "hkrul_hakka")
			mixer_add_starting_unit_list_for_faction("wh_main_nor_aesling", {"hkrul_dummy_aesling_inf_marauder_champions_1","scm_fc_norsca_aesling_nor_marauder","wh_dlc08_nor_mon_war_mammoth_0","scm_fc_norsca_aesling_nor_marauder_great_weapons"})
			mixer_add_faction_to_major_faction_list("wh_main_nor_aesling")
			
			mixer_change_lord_name("1752931370", "hkrul_surtha_ek")
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
		end		
	end
)