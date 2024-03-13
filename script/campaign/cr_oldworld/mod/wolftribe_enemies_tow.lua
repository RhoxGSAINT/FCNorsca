local function wolftribe_new_region_setups()
	cm:create_force_with_general(
		"wh_main_nor_graeling", -- faction_key,
        "wh_main_nor_cav_marauder_horsemen_0,wh_main_nor_inf_chaos_marauders_1,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_1,wh_dlc08_nor_inf_marauder_hunters_1,wh_main_nor_mon_chaos_trolls,wh_main_nor_mon_chaos_trolls",
        "cr_oldworld_region_naglfarling_keep", -- region_key,
		710, -- x,
		1294, -- y,
		"general", -- type,
		"wh_main_nor_marauder_chieftain", -- subtype,
		"", -- name1,
		"", -- name2,
		"", -- name3,
		"", -- name4,
		false,-- make_faction_leader,
        function(cqi)
            out("Force created with char cqi: " .. cqi);
        end
	);
	
	cm:transfer_region_to_faction("cr_oldworld_region_naglfarling_keep", "wh_main_nor_graeling");
	cm:transfer_region_to_faction("cr_oldworld_region_pyramid_of_burning_skulls", "wh_main_nor_graeling");
	cm:transfer_region_to_faction("cr_oldworld_region_wrath_of_galrauch", "wh_main_nor_varg");
	cm:transfer_region_to_faction("cr_oldworld_region_monolith_of_ingvar", "wh_main_nor_varg");
	cm:transfer_region_to_faction("cr_oldworld_region_monolith_of_gutrot", "wh_main_nor_varg");

end

cm:add_first_tick_callback(
	function()
		if cm:is_new_game() then
            local ok, err =
                pcall(
                function()
                    wolftribe_new_region_setups()
                end
            )
            if not ok then
                script_error(err)
            end
		end
	end
)