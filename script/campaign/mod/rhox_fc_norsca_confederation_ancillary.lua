local confederation_items_list={
    "hkrul_norsca_helmet_1",
    "hkrul_norsca_helmet_2",
    "hkrul_norsca_helmet_3",
    "hkrul_norsca_shield_1",
    "hkrul_norsca_shield_2",
    "hkrul_norsca_shield_3",
    "hkrul_norsca_axe_1",
    "hkrul_norsca_axe_2",
    "hkrul_norsca_axe_3",
    "hkrul_norsca_axe_4",
    "hkrul_norsca_axe_5",
    "hkrul_norsca_sword_1",
    "hkrul_norsca_sword_2",
    "hkrul_norsca_sword_3",
    "hkrul_norsca_sword_4",
    "hkrul_norsca_ship_1",
    "hkrul_norsca_ship_2",
    "hkrul_norsca_ship_3",
    "hkrul_norsca_ship_4",
    "hkrul_norsca_ship_7",   
    "hkrul_norsca_ship_8", 
    "hkrul_norsca_ship_11",      
    "hkrul_norsca_follower_1",
    "hkrul_norsca_follower_2",
    "hkrul_norsca_enchanted_1",
    "hkrul_norsca_enchanted_2",
    "hkrul_norsca_enchanted_3",
    "hkrul_norsca_enchanted_4",
}


core:add_listener(
    "rhox_fc_norsca_ancillary_giver",
    "DilemmaChoiceMadeEvent",
    function(context)
        return (context:dilemma() == subjugation.dilemmas.execute["wh_dlc08_nor_norsca"] and context:choice() == 2) or (context:dilemma() == subjugation.dilemmas.no_execute["wh_dlc08_nor_norsca"] and context:choice() == 1)
		
    end,
    function(context)
		local faction = context:faction()
		local available_item_list = {}
		for i=1,#confederation_items_list do
			if not faction:ancillary_exists(confederation_items_list[i]) then
				table.insert(available_item_list, confederation_items_list[i])
			end
		end
		if #available_item_list>=1 then
            cm:add_ancillary_to_faction(faction, available_item_list[cm:random_number(#available_item_list)],false)
        else--just give random if player has all already
            cm:add_ancillary_to_faction(faction, confederation_items_list[cm:random_number(#confederation_items_list)],false)
        end
    end,
    true
);
