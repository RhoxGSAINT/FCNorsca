
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