local rhox_fc_norsca_confederation_count={}


local rhox_fc_norsca_subtype_to_conf_effect={
	hkrul_adella={
		effect="wh2_dlc16_effect_magic_cost_all_lores_enemy",
		scope="character_to_force_enemy_provincewide",
		value="2",
	},
	hkrul_birna={
		effect="wh_main_effect_force_stat_missile_damage",
		scope="character_to_force_own",
		value="2",
	},
	hkrul_drenok={
		effect="wh_main_effect_character_stat_missile_block",
		scope="character_to_force_own",
		value="2",
	},
	hkrul_einar={
		effect="wh_main_effect_force_stat_melee_attack",
		scope="character_to_force_own",
		value="2",
	},
	hkrul_harald={
		effect="wh_main_effect_force_stat_leadership",
		scope="character_to_force_own",
		value="3",
	},
	hkrul_eyri={
		effect="wh_main_effect_economy_trade_tariff_mod",
		scope="character_to_faction_unseen",
		value="5",		
	},
	hkrul_grydal={
		effect="wh3_main_effect_force_all_campaign_movement_range_post_raze_bonus",
		scope="character_to_character_own",
		value="5",			
	},
	hkrul_sayl={
		effect="wh3_main_effect_winds_of_magic_pool_cap",
		scope="character_to_force_own_unseen",
		value="2",
	},
	hkrul_surtha_ek={
		effect="wh_main_effect_force_stat_weapon_strength_chaos_chariots",
		scope="character_to_force_own_unseen",
		value="5",
	},
	hkrul_ulfric={
		effect="wh_main_effect_economy_gdp_mod_trade_sea",
		scope="character_to_region_own_factionwide",
		value="5",
	},
	hkrul_hakka={
		effect="wh_main_effect_force_stat_charge_bonus_pct",
		scope="character_to_force_own",
		value="2",
	},
	hkrul_akkorak={
		effect="wh_main_effect_force_stat_armour",
		scope="character_to_force_own",
		value="2",
	},
    hkrul_geimdall={
		effect="wh_main_effect_force_stat_melee_defence",
		scope="character_to_force_own",
		value="2",
	},
    hkrul_olaf={
		effect="wh_main_effect_force_all_campaign_raid_income",
		scope="character_to_force_own",
		value="5",		
	},
	hkrul_sarg={
		effect="wh_main_effect_force_stat_speed",
		scope="character_to_force_own",
		value="5",
	},
	hkrul_goftur={
		effect="hkrul_norsca_post_battle_sea",
		scope="character_to_force_own",
		value="5",
	},	
	scm_norsca_huern={
		effect="wh_dlc08_effect_force_stat_weapon_strength_skin_wolves_warhounds",
		scope="character_to_force_own",
		value="2",
	},
	wh_dlc08_nor_wulfrik={
		effect="wh_main_effect_character_stat_bonus_vs_infantry",
		scope="character_to_force_own",
		value="1",
	},
	wh_dlc08_nor_throgg={
		effect="wh_main_effect_character_stat_bonus_vs_large",
		scope="character_to_force_own",
		value="1",
	},-----below are LCCP ones
	hkrul_valbrand={
		effect="wh_main_effect_character_stat_weapon_strength_ap_damage_mult",
		scope="character_to_force_own",
		value="1",
	},
	hkrul_volrik={
		effect="wh3_main_effect_battle_barrier_health_mod",
		scope="character_to_force_own",
		value="2",
	},
	hkrul_thorgar={
		effect="wh_main_effect_economy_gdp_mod_all",
		scope="character_to_region_own_provincewide",
		value="5",
	},
	hkrul_vroth={
		effect="wh3_main_effect_force_stat_unit_mass_percentage_mod",
		scope="character_to_force_own",
		value="2",
	},
	hkrul_beorg={
		effect="wh_main_effect_character_stat_weapon_strength_base_mult",
		scope="character_to_force_own",
		value="2",
	},
}



local function rhox_fc_norsca_recalculate_confederation_bonus(character)
	local faction = character:faction()
	local faction_key = faction:name()
	


	local confederation_effect_bundle_key= "rhox_fc_norsca_confederation_bonus"
	cm:remove_effect_bundle_from_character(confederation_effect_bundle_key, character)

	if not rhox_fc_norsca_confederation_count[faction_key] or rhox_fc_norsca_confederation_count[faction_key] ==0 then
		return 
	end


	local conf_effect = rhox_fc_norsca_subtype_to_conf_effect[character:character_subtype_key()]
	

	
	local confederation_effect_bundle = cm:create_new_custom_effect_bundle(confederation_effect_bundle_key)

	confederation_effect_bundle:add_effect(conf_effect.effect, conf_effect.scope, rhox_fc_norsca_confederation_count[faction_key]*conf_effect.value)
	confederation_effect_bundle:set_duration(0)

	
	
	cm:apply_custom_effect_bundle_to_character(confederation_effect_bundle, character)

	return
end

local function get_character_by_subtype(subtype, faction)
    local character_list = faction:character_list()
    
    for i = 0, character_list:num_items() - 1 do
        local character = character_list:item_at(i)
        
        if character:character_subtype(subtype) then
            return character
        end
    end
    return false
end



core:add_listener(
    "rhox_fc_norsca_confederation_bundle_backup",
    "CharacterTurnStart",
    function(context)
        local character = context:character()
        return rhox_fc_norsca_subtype_to_conf_effect[character:character_subtype_key()]
    end,
    function(context)
        local character = context:character()    
        local faction = character:faction()
        rhox_fc_norsca_recalculate_confederation_bonus(character)
        
    end,
    true
)

core:add_listener(
    "rhox_fc_norsca_confederation",
    "FactionJoinsConfederation",
    true,
    function(context)
        local faction = context:confederation()

		if not rhox_fc_norsca_confederation_count[faction:name()] then
			rhox_fc_norsca_confederation_count[faction:name()] = 0
		end

		local absorbed_faction = context:faction()

		if rhox_fc_norsca_confederation_count[absorbed_faction:name()] then
			rhox_fc_norsca_confederation_count[faction:name()] = rhox_fc_norsca_confederation_count[faction:name()]+rhox_fc_norsca_confederation_count[absorbed_faction:name()] --you gain target's bonus also
		end 

		rhox_fc_norsca_confederation_count[faction:name()] = rhox_fc_norsca_confederation_count[faction:name()]+1 --since you absorbed one

		for character_type, _ in pairs(rhox_fc_norsca_subtype_to_conf_effect) do
			local character = get_character_by_subtype(character_type, faction)	
			if character then
				rhox_fc_norsca_recalculate_confederation_bonus(character)
			end
		end
    end,
    true
)


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_fc_norsca_confederation_count", rhox_fc_norsca_confederation_count, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			rhox_fc_norsca_confederation_count = cm:load_named_value("rhox_fc_norsca_confederation_count", rhox_fc_norsca_confederation_count, context);
		end;
	end
);