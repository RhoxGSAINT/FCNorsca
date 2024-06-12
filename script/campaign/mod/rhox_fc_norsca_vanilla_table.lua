local add_ll_to_pool = true


local function rhox_totn_add_ll_to_ll_pool(add)
    if not NORSCA_LEGENDARY_LORDS or not type(NORSCA_LEGENDARY_LORDS) == "table" then
        return --don't do anything if this table exists
    end

    if add then
        NORSCA_LEGENDARY_LORDS["hkrul_adella"]=true
        NORSCA_LEGENDARY_LORDS["hkrul_akkorak"]=true
        NORSCA_LEGENDARY_LORDS["hkrul_birna"]=true
        NORSCA_LEGENDARY_LORDS["hkrul_drenok"]=true
        NORSCA_LEGENDARY_LORDS["hkrul_einar"]=true
        NORSCA_LEGENDARY_LORDS["hkrul_harald"]=true
        NORSCA_LEGENDARY_LORDS["hkrul_sayl"]=true
        NORSCA_LEGENDARY_LORDS["hkrul_ulfric"]=true
        NORSCA_LEGENDARY_LORDS["hkrul_hakka"]=true
        NORSCA_LEGENDARY_LORDS["hkrul_hrothgar"]=true
        NORSCA_LEGENDARY_LORDS["hkrul_sarg"]=true
        NORSCA_LEGENDARY_LORDS["hkrul_surtha_ek"]=true
        NORSCA_LEGENDARY_LORDS["scm_norsca_huern"]=true
        NORSCA_LEGENDARY_LORDS["hkrul_beorg"]=true
        NORSCA_LEGENDARY_LORDS["hkrul_beorg_bear"]=true
    else
        NORSCA_LEGENDARY_LORDS["hkrul_adella"]=nil
        NORSCA_LEGENDARY_LORDS["hkrul_akkorak"]=nil
        NORSCA_LEGENDARY_LORDS["hkrul_birna"]=nil
        NORSCA_LEGENDARY_LORDS["hkrul_drenok"]=nil
        NORSCA_LEGENDARY_LORDS["hkrul_einar"]=nil
        NORSCA_LEGENDARY_LORDS["hkrul_harald"]=nil
        NORSCA_LEGENDARY_LORDS["hkrul_sayl"]=nil
        NORSCA_LEGENDARY_LORDS["hkrul_ulfric"]=nil
        NORSCA_LEGENDARY_LORDS["hkrul_hakka"]=nil
        NORSCA_LEGENDARY_LORDS["hkrul_hrothgar"]=nil
        NORSCA_LEGENDARY_LORDS["hkrul_sarg"]=nil
        NORSCA_LEGENDARY_LORDS["hkrul_surtha_ek"]=nil
        NORSCA_LEGENDARY_LORDS["scm_norsca_huern"]=nil
        NORSCA_LEGENDARY_LORDS["hkrul_beorg"]=nil
        NORSCA_LEGENDARY_LORDS["hkrul_beorg_bear"]=nil
    end
end


core:add_listener(
    "rhox_totn_mct_initialize",
    "MctInitialized",
    true,
    function(context)
        
        local mct = context:mct()

        local my_mod = mct:get_mod_by_key("scm_totn")

        
        local add_ll_to_pool_option = my_mod:get_option_by_key("add_to_ll_pool")
        add_ll_to_pool = add_ll_to_pool_option:get_finalized_setting()
                
        rhox_totn_add_ll_to_ll_pool(add_ll_to_pool)
    end,
    true
)

core:add_listener(
    "rhox_totn_mct_finalized",
    "MctOptionSettingFinalized",
    true,
    function(context)
        
        local mct = context:mct()

        local my_mod = mct:get_mod_by_key("scm_totn")

        
        local add_ll_to_pool_option = my_mod:get_option_by_key("add_to_ll_pool")
        add_ll_to_pool = add_ll_to_pool_option:get_finalized_setting()
                
        rhox_totn_add_ll_to_ll_pool(add_ll_to_pool) 
    end,
    true
)






-----------------------------Vanilla Legendary Hero thing
------------Baesonling --nedd check
table.insert(character_unlocking.character_data["aekold"]["override_allowed_factions"]["main_warhammer"], "wh_main_nor_baersonling")
table.insert(character_unlocking.character_data["aekold"]["mission_chain_keys"]["main_warhammer"], "rhox_baersonling_tze_aekold_helbrass_stage_1_nor")
table.insert(character_unlocking.character_data["aekold"]["mission_chain_keys"]["main_warhammer"], "rhox_baersonling_tze_aekold_helbrass_stage_2_nor")
character_unlocking.character_data["aekold"]["mission_keys"]["wh_main_nor_baersonling"]={}
character_unlocking.character_data["aekold"]["mission_keys"]["wh_main_nor_baersonling"]["main_warhammer"]="rhox_baersonling_tze_aekold_helbrass_stage_1_nor"

table.insert(character_unlocking.character_data["scribes"]["override_allowed_factions"]["main_warhammer"], "wh_main_nor_baersonling")
table.insert(character_unlocking.character_data["scribes"]["mission_chain_keys"]["main_warhammer"], "rhox_baersonling_tze_blue_scribes_stage_1_nor")
table.insert(character_unlocking.character_data["scribes"]["mission_chain_keys"]["main_warhammer"], "rhox_baersonling_tze_blue_scribes_stage_2_b_nor")
table.insert(character_unlocking.character_data["scribes"]["mission_chain_keys"]["main_warhammer"], "rhox_baersonling_tze_blue_scribes_stage_2_nor")
table.insert(character_unlocking.character_data["scribes"]["mission_chain_keys"]["main_warhammer"], "rhox_baersonling_tze_blue_scribes_stage_3_nor")
table.insert(character_unlocking.character_data["scribes"]["missions_to_trigger_dilemma"]["main_warhammer"], "rhox_baersonling_tze_blue_scribes_stage_3_nor")
character_unlocking.character_data["scribes"]["mission_keys"]["wh_main_nor_baersonling"]={}
character_unlocking.character_data["scribes"]["mission_keys"]["wh_main_nor_baersonling"]["main_warhammer"]="rhox_baersonling_tze_blue_scribes_stage_1_nor"





initiative_cultures["wh_dlc08_nor_norsca"]=true

--Baersonling upgrade
table.insert(initiative_templates,
    {
        ["initiative_key"] = "rhox_baersonling_chaos_lord_tzeentch_from_marauder_chieftain",
        ["event"] = {"CharacterRankUp", "CharacterRecruited"},
		["condition"] =
			function(context)
				return context:character():rank() >= 15
			end
	}
)
table.insert(initiative_templates,
    {
        ["initiative_key"] = "rhox_baersonling_daemon_prince_tzeentch_from_chaos_lord_tzeentch",
        ["event"] = {"CharacterRankUp", "CharacterRecruited"},
		["condition"] =
			function(context)
				return context:character():rank() >= 30
			end
	}
)



CUS.initiative_to_agent_junctions["rhox_baersonling_chaos_lord_tzeentch_from_marauder_chieftain"] = 
{
    type ="general",
    subtype ="rhox_baersonling_chs_lord_mtze",
} 

CUS.initiative_to_agent_junctions["rhox_baersonling_daemon_prince_tzeentch_from_chaos_lord_tzeentch"] = 
{
    type ="general",
    subtype ="rhox_baersonling_daemon_prince_tzeentch",
} 


CUS.subtype_to_bonus_traits["wh_main_nor_marauder_chieftain"]={
    rhox_baersonling_chs_lord_mtze = "rhox_baesonling_chieftain_to_marked_lord",
}

CUS.subtype_to_bonus_traits["rhox_baersonling_chs_lord_mtze"]={
    rhox_baersonling_daemon_prince_tzeentch = "wh3_dlc20_legacy_trait_lord_to_daemon_prince",
}


CUS.subtypes_to_tints["rhox_baersonling_daemon_prince_tzeentch"] = 
{
    primary = {key = "wh3_main_daemon_prince_tzeentch_primary", intensity_min = 200, intensity_max = 255},
    secondary = {key = "wh3_main_daemon_prince_tzeentch_secondary", intensity_min = 200, intensity_max = 255}
}

CUS.subtypes_to_composite_scenes["rhox_baersonling_daemon_prince_tzeentch"] = "wh3_campaign_chaos_upgrade_daemons"


--defeated traits
cm:add_first_tick_callback(
	function()
        campaign_traits.legendary_lord_defeated_traits["hkrul_adella"] ="hkrul_defeated_trait_adella"
        campaign_traits.legendary_lord_defeated_traits["hkrul_akkorak"] ="hkrul_defeated_trait_akkorak" 
        campaign_traits.legendary_lord_defeated_traits["hkrul_birna"] ="hkrul_defeated_trait_birna" 
        campaign_traits.legendary_lord_defeated_traits["hkrul_drenok"] ="hkrul_defeated_trait_drenok" 
        campaign_traits.legendary_lord_defeated_traits["hkrul_einar"] ="hkrul_defeated_trait_einar" 
        campaign_traits.legendary_lord_defeated_traits["hkrul_harald"] ="hkrul_defeated_trait_harald" 
        campaign_traits.legendary_lord_defeated_traits["hkrul_sayl"] ="hkrul_defeated_trait_sayl" 
        campaign_traits.legendary_lord_defeated_traits["hkrul_ulfric"] ="hkrul_defeated_trait_ulfric" 
        campaign_traits.legendary_lord_defeated_traits["hkrul_hakka"] ="hkrul_defeated_trait_hakka"
        campaign_traits.legendary_lord_defeated_traits["hkrul_hrothgar"] ="hkrul_defeated_trait_hrothgar" 
        campaign_traits.legendary_lord_defeated_traits["hkrul_sarg"] ="hkrul_defeated_trait_sarg" 
        campaign_traits.legendary_lord_defeated_traits["hkrul_surtha_ek"] ="hkrul_defeated_trait_surtha_ek" 
        campaign_traits.legendary_lord_defeated_traits["scm_norsca_huern"] ="hkrul_defeated_trait_huern" 
        campaign_traits.legendary_lord_defeated_traits["hkrul_beorg"] ="hkrul_defeated_trait_beorg"

        campaign_traits.legendary_lord_defeated_traits["hkrul_bjornling_ogg"] ="hkrul_defeated_trait_ogg" 
        
        rhox_totn_add_ll_to_ll_pool(add_ll_to_pool)
	end
)