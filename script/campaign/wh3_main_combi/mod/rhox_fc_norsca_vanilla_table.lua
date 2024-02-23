
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

------confed mission thing

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
        

        campaign_traits.legendary_lord_defeated_traits["hkrul_bjornling_ogg"] ="hkrul_defeated_trait_ogg" 
        
	end
)