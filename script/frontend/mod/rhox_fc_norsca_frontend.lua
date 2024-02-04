
core:add_ui_created_callback(
	function(context)
		if vfs.exists("script/frontend/mod/mixer_frontend.lua")then
		
			mixer_change_lord_name("876077643", "hkrul_adella")
			mixer_add_starting_unit_list_for_faction("wh2_main_nor_skeggi", {"hkrul_skeggi_inf_chaos_marauders_0","hkrul_skeggi_giant","wh2_main_lzd_mon_bastiladon_0","hkrul_skeggi_inf_marauder_champions_1", "hkrul_skeggi_inf_marauder_hunters_1"})
			mixer_add_faction_to_major_faction_list("wh2_main_nor_skeggi")
			
			mixer_change_lord_name("1176817909", "hkrul_sayl")
			mixer_add_starting_unit_list_for_faction("wh3_dlc20_nor_dolgan", {"wh_main_nor_inf_chaos_marauders_0","wh_main_nor_inf_chaos_marauders_1"})
			mixer_add_faction_to_major_faction_list("wh3_dlc20_nor_dolgan")
			
			mixer_change_lord_name("1503698398", "hkrul_drenok")
			mixer_add_starting_unit_list_for_faction("wh_dlc08_nor_vanaheimlings", {"wh_main_nor_inf_chaos_marauders_0","wh_main_nor_inf_chaos_marauders_1"})
			mixer_add_faction_to_major_faction_list("wh_dlc08_nor_vanaheimlings")
			
			mixer_change_lord_name("329040993", "hkrul_einar")
			mixer_add_starting_unit_list_for_faction("wh_main_nor_baersonling", {"wh_main_nor_inf_chaos_marauders_0","wh_main_nor_inf_chaos_marauders_1"})
			mixer_add_faction_to_major_faction_list("wh_main_nor_baersonling")
			
			mixer_change_lord_name("106797993", "hkrul_ulfric")
			mixer_add_starting_unit_list_for_faction("wh_main_nor_bjornling", {"hkrul_bjornling_inf_marauder_champions_0","hkrul_bjornling_inf_chaos_marauders_0","wh_dlc08_nor_mon_norscan_giant_0","hkrul_bjornling_inf_marauder_spearman_0"})
			mixer_add_faction_to_major_faction_list("wh_main_nor_bjornling")
			
			mixer_change_lord_name("835161619", "hkrul_harald")
			mixer_add_starting_unit_list_for_faction("wh_main_nor_graeling", {"wh_main_nor_inf_chaos_marauders_0","wh_main_nor_inf_chaos_marauders_1"})
			mixer_add_faction_to_major_faction_list("wh_main_nor_graeling")
			
			mixer_change_lord_name("383940030", "hkrul_birna")
			mixer_add_starting_unit_list_for_faction("wh_main_nor_sarl", {"wh_dlc08_nor_feral_manticore","wh_main_nor_mon_chaos_trolls","wh_main_nor_inf_chaos_marauders_1"})
			mixer_add_faction_to_major_faction_list("wh_main_nor_sarl")
			
			
			mixer_change_lord_name("960993442", "hkrul_hakka")
			mixer_add_starting_unit_list_for_faction("wh_main_nor_aesling", {"wh_main_nor_inf_chaos_marauders_0","wh_main_nor_inf_chaos_marauders_1"})
			mixer_add_faction_to_major_faction_list("wh_main_nor_aesling")
		end		
	end
)