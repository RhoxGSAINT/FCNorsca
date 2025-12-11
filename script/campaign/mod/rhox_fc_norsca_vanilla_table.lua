


-----------------------------Vanilla Legendary Hero thing
------------Baesonling 
table.insert(character_unlocking.character_data["aekold"]["override_allowed_factions"]["main_warhammer"], "wh_main_nor_baersonling")
table.insert(character_unlocking.character_data["aekold"]["mission_chain_keys"]["main_warhammer"], "rhox_baersonling_tze_aekold_helbrass_stage_1_nor")
table.insert(character_unlocking.character_data["aekold"]["mission_chain_keys"]["main_warhammer"], "rhox_baersonling_tze_aekold_helbrass_stage_2_nor")
character_unlocking.character_data["aekold"]["starting_mission_keys"]["wh_main_nor_baersonling"]={}
character_unlocking.character_data["aekold"]["starting_mission_keys"]["wh_main_nor_baersonling"]["main_warhammer"]="rhox_baersonling_tze_aekold_helbrass_stage_1_nor"

table.insert(character_unlocking.character_data["scribes"]["override_allowed_factions"]["main_warhammer"], "wh_main_nor_baersonling")
table.insert(character_unlocking.character_data["scribes"]["mission_chain_keys"]["main_warhammer"], "rhox_baersonling_tze_blue_scribes_stage_1_nor")
table.insert(character_unlocking.character_data["scribes"]["mission_chain_keys"]["main_warhammer"], "rhox_baersonling_tze_blue_scribes_stage_2_b_nor")
table.insert(character_unlocking.character_data["scribes"]["mission_chain_keys"]["main_warhammer"], "rhox_baersonling_tze_blue_scribes_stage_2_nor")
table.insert(character_unlocking.character_data["scribes"]["mission_chain_keys"]["main_warhammer"], "rhox_baersonling_tze_blue_scribes_stage_3_nor")
table.insert(character_unlocking.character_data["scribes"]["missions_to_trigger_dilemma"]["main_warhammer"], "rhox_baersonling_tze_blue_scribes_stage_3_nor")
character_unlocking.character_data["scribes"]["starting_mission_keys"]["wh_main_nor_baersonling"]={}
character_unlocking.character_data["scribes"]["starting_mission_keys"]["wh_main_nor_baersonling"]["main_warhammer"]="rhox_baersonling_tze_blue_scribes_stage_1_nor"


----Hakka
table.insert(character_unlocking.character_data["karanak"]["override_allowed_factions"]["main_warhammer"], "wh_main_nor_aesling")

character_unlocking.character_data["karanak"]["starting_mission_keys"]["wh_main_nor_aesling"]={}
character_unlocking.character_data["karanak"]["starting_mission_keys"]["wh_main_nor_aesling"]["main_warhammer"] ="rhox_totn_mis_ie_nor_karanak_unlock_01"

table.insert(character_unlocking.character_data["karanak"]["mission_chain_keys"]["main_warhammer"], "rhox_totn_mis_ie_nor_karanak_unlock_01")
table.insert(character_unlocking.character_data["karanak"]["missions_to_trigger_dilemma"]["main_warhammer"], "rhox_totn_mis_ie_nor_karanak_unlock_01")

table.insert(character_unlocking.character_data["skarr"]["override_allowed_factions"], "wh_main_nor_aesling")
table.insert(character_unlocking.character_data["skarr"]["required_buildings"], "wh_main_nor_military_3")

table.insert(character_unlocking.character_data["scyla"]["override_allowed_factions"], "wh_main_nor_aesling")
table.insert(character_unlocking.character_data["scyla"]["override_allowed_factions"], "wh2_main_nor_skeggi")
table.insert(character_unlocking.character_data["scyla"]["override_allowed_factions"], "wh3_dlc20_nor_kul")
table.insert(character_unlocking.character_data["scyla"]["override_allowed_factions"], "wh_dlc08_nor_vanaheimlings")
table.insert(character_unlocking.character_data["scyla"]["override_allowed_factions"], "wh_main_nor_graeling")
table.insert(character_unlocking.character_data["scyla"]["override_allowed_factions"], "wh_main_nor_varg")
table.insert(character_unlocking.character_data["scyla"]["override_allowed_factions"], "wh_dlc08_nor_naglfarlings")

table.insert(character_unlocking.character_data["scyla"]["override_allowed_factions"], "mixer_nor_fjordlings")
table.insert(character_unlocking.character_data["scyla"]["override_allowed_factions"], "mixer_nor_bloodfjord")
table.insert(character_unlocking.character_data["scyla"]["override_allowed_factions"], "mixer_nor_snaegr")


local rhox_totn_factions={
    mixer_nor_beorg=true,
    cr_nor_servants_of_mermedus=true,
    mixer_nor_eyristaad=true,
    mixer_nor_snaegr=true,
    mixer_nor_bloodfjord=true,
    mixer_nor_cult_of_mermedus=true,
    wh2_main_nor_skeggi=true,
    wh3_dlc20_nor_kul=true,
    wh_dlc08_nor_vanaheimlings=true,
    wh_main_nor_aesling=true,
    wh_main_nor_baersonling=true,
    wh_main_nor_bjornling=true,
    wh_main_nor_graeling=true,
    wh_main_nor_sarl=true,
    wh_main_nor_varg=true,
    mixer_nor_fjordlings=true,
    wh3_dlc20_nor_yusak=true,
    wh_main_nor_skaeling=true,
    wh_dlc08_nor_naglfarlings=true,
    mixer_nor_geimdall_huscarls=true,
}

local rhox_totn_special_factions={--non-chaos, or god dedicated
    wh_main_nor_aesling=true, --Khorne
    wh_main_nor_baersonling=true,--tzeentch
    wh3_dlc20_nor_yusak=true,--slaanesh
    mixer_nor_geimdall_huscarls=true,--neutral
    mixer_nor_bloodfjord=true,--Khorne
    mixer_nor_eyristaad=true,--neutral
    mixer_nor_snaegr=true,--Khorne
    wh_main_nor_bjornling=true,--neutral
}

------Norsca thing
for faction_key, _ in pairs(rhox_totn_factions) do
    table.insert(character_unlocking.character_data["beorg_bearstruck"]["override_allowed_factions"], faction_key)
    --Mixer adds all the factions to pillage and monster hunts and we don't have to
    norscan_gods.allegiance_advice_tracker[faction_key]=norscan_gods.allegiance_advice_tracker["wh_dlc08_nor_norsca"]
    if not rhox_totn_special_factions[faction_key] then
        norscan_gods.allegiance_factions[faction_key]= norscan_gods.allegiance_factions["wh_dlc08_nor_norsca"]
    end
end

norscan_gods.allegiance_factions["wh_main_nor_aesling"]={crow_dilemma_spawned = true, eagle_dilemma_spawned = true, hound_dilemma_spawned = false, serpent_dilemma_spawned = true, champion_spawned = false}
norscan_gods.allegiance_factions["mixer_nor_bloodfjord"]={crow_dilemma_spawned = true, eagle_dilemma_spawned = true, hound_dilemma_spawned = false, serpent_dilemma_spawned = true, champion_spawned = false}
norscan_gods.allegiance_factions["mixer_nor_snaegr"]={crow_dilemma_spawned = true, eagle_dilemma_spawned = true, hound_dilemma_spawned = false, serpent_dilemma_spawned = true, champion_spawned = false}
norscan_gods.allegiance_factions["wh_main_nor_baersonling"]= {crow_dilemma_spawned = true, eagle_dilemma_spawned = false, hound_dilemma_spawned = true, serpent_dilemma_spawned = true, champion_spawned = false}
norscan_gods.allegiance_factions["wh3_dlc20_nor_yusak"]= {crow_dilemma_spawned = true, eagle_dilemma_spawned = true, hound_dilemma_spawned = true, serpent_dilemma_spawned = false, champion_spawned = false}


character_unlocking.character_data["beorg_bearstruck"].priority_ai_faction="mixer_nor_beorg"
nor_generic_config.altar_raise_occupation_options_display_overrides["957887884"]="wh_main_settlement_norscaruin_tzeentch"
nor_generic_config.altar_raise_occupation_options_display_overrides["957887885"]="wh_main_settlement_norscaruin_slaanesh"
nor_generic_config.altar_raise_occupation_options_display_overrides["957887886"]="wh_main_settlement_norscaruin_khorne"


table.insert(character_unlocking.character_data["styrkaar"]["override_allowed_factions"], "wh3_dlc20_nor_yusak")



core:add_listener(
    "RhoxTotNChampion_DilemmaChoiceMadeEvent",
    "DilemmaChoiceMadeEvent",
    function(context)
        return string.find(context:dilemma(), norscan_gods.dilemma_key_prefix) and rhox_totn_factions[context:faction():name()] and context:choice() == 0
    end,
    function(context)
        local faction_key = context:faction():name()
        local dilemma= context:dilemma()
        local choice = context:choice()
        
        if dilemma == norscan_gods.dilemma_key_prefix.."eagle" then
            cm:spawn_character_to_pool(faction_key, "names_name_1270717835", "", "", "", 30, true, "general", "wh_dlc08_nor_arzik", true, "")
        elseif dilemma == norscan_gods.dilemma_key_prefix.."crow" then
            cm:spawn_character_to_pool(faction_key, "names_name_1270717836", "names_name_1270717837", "", "", 30, true, "general", "wh3_main_ie_nor_burplesmirk_spewpit", true, "")
        end
    end,
    true
)



------------initiatives
initiative_cultures.wh_dlc08_nor_norsca = true

local totn_initiative_templates = {
	{--Baersonling upgrade
        ["initiative_key"] = "rhox_baersonling_chaos_lord_tzeentch_from_marauder_chieftain",
        ["event"] = {"CharacterRankUp", "CharacterRecruited"},
		["condition"] =
			function(context)
				return context:character():rank() >= 15
			end
	},
    {
        ["initiative_key"] = "rhox_baersonling_daemon_prince_tzeentch_from_chaos_lord_tzeentch",
        ["event"] = {"CharacterRankUp", "CharacterRecruited"},
		["condition"] =
			function(context)
				return context:character():rank() >= 30
			end
	},
	{
        ["initiative_key"] = "hkrul_goftur_initiative_05",
        ["event"] = {"CharacterCompletedBattle", "CharacterParticipatedAsSecondaryGeneralInBattle"},
		["condition"] =
			function(context)
				if context:character():won_battle() and context:character():is_at_sea() then
					local count = cm:get_saved_value("hkrul_goftur_initiative_05") or 0
					
					count = count + 1
					cm:set_saved_value("hkrul_goftur_initiative_05", count)
					
					if count >= 6 then
						return true
					end
				end
			end,
		["grant_immediately"] = true
	},
	{
        ["initiative_key"] = "hkrul_goftur_initiative_02",
        ["event"] = {"CharacterRankUp", "CharacterRecruited"},
		["condition"] =
			function(context)
				return context:character():rank() >= 30
			end,
		["grant_immediately"] = true
	},
	{
        ["initiative_key"] = "hkrul_goftur_initiative_03",
        ["event"] = {"CharacterCompletedBattle", "CharacterParticipatedAsSecondaryGeneralInBattle"},
		["condition"] =
			function(context)
				local pirate_factions = {
					wh2_dlc11_cst_rogue_bleak_coast_buccaneers = true,
					wh2_dlc11_cst_rogue_boyz_of_the_forbidden_coast = true,
					wh2_dlc11_cst_rogue_freebooters_of_port_royale = true,
					wh2_dlc11_cst_rogue_grey_point_scuttlers = true,
					wh2_dlc11_cst_rogue_terrors_of_the_dark_straights = true,
					wh2_dlc11_cst_rogue_the_churning_gulf_raiders = true,
					wh2_dlc11_cst_rogue_tyrants_of_the_black_ocean = true,
					wh2_dlc11_cst_shanty_dragon_spine_privateers = true,
					wh2_dlc11_cst_shanty_middle_sea_brigands = true,
					wh2_dlc11_cst_shanty_shark_straight_seadogs = true
				}
				if context:character():won_battle() then
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1)
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1)
					local character_faction_name = context:character():faction():name()
					local is_attacker = attacker_faction_name == character_faction_name
					local is_defender = defender_faction_name == character_faction_name
					local count = cm:get_saved_value("hkrul_goftur_initiative_03") or 0
					
					if (is_attacker and pirate_factions[defender_faction_name]) or (is_defender and pirate_factions[attacker_faction_name]) then
						count = count + 1
					end
					
					cm:set_saved_value("hkrul_goftur_initiative_03", count)
					
					if count >= 2 then
						return true
					end
				end
			end,
		["grant_immediately"] = true
	},
	{
        ["initiative_key"] = "hkrul_goftur_initiative_04",
        ["event"] = {"CharacterTurnStart", "CharacterCapturedSettlementUnopposed", "CharacterPerformsSettlementOccupationDecision"},
		["condition"] =
			function(context)
				local building_keys = {
					"wh_main_nor_port_1",
					"wh_main_nor_port_2",
					"wh_main_nor_port_3",
					"wh2_main_special_lothern_port_norsca_1",
					"wh_dlc08_special_bordeleaux_port_norsca_1",
					"wh_dlc08_special_erengrad_port_norsca_1",
					"wh_dlc08_special_marienburg_port_norsca_1"
				}
				local faction = context:character():faction()
				local region_list = faction:region_list();
				local count = 0
				for i = 0, region_list:num_items() - 1 do
					local region = region_list:item_at(i)
					for j=1, #building_keys do
						if region:building_exists(building_keys[j]) then
							count = count + 1
						
							if count >= 10 then
								return true
							end
						end
					end
				end
			end,
		["grant_immediately"] = true
	},
	{
        ["initiative_key"] = "hkrul_goftur_ascend",
        ["event"] = {"CharacterInitiativeActivationChangedEvent"},
		["condition"] =
			function(context)
				if context:initiative():record_key():starts_with("hkrul_goftur_initiative_0") then
					local count = cm:get_saved_value("hkrul_goftur_ascend") or 0
					
					count = count + 1
					cm:set_saved_value("hkrul_goftur_ascend", count)
					
					if count >= 4 then
						return true
					end
				end
			end
	},
	{
        ["initiative_key"] = "hkrul_grydal_initiative_01",
		["event"] = {"CharacterCompletedBattle"},
        ["condition"] =
			function(context)
				if cm:character_won_battle_against_culture(context:character(), {"wh_main_emp_empire"}) then
					local count = cm:get_saved_value("hkrul_grydal_initiative_01") or 0
					
					count = count + 1
					cm:set_saved_value("hkrul_grydal_initiative_01", count)
					
					if count >= 10 then
						return true
					end
				end
			end,
		["grant_immediately"] = true
	},
	{
        ["initiative_key"] = "hkrul_grydal_initiative_02",
        ["event"] = {"CharacterRankUp", "CharacterRecruited"},
		["condition"] =
			function(context)
				return context:character():rank() >= 30
			end,
		["grant_immediately"] = true
	},
	{
        ["initiative_key"] = "hkrul_grydal_initiative_03",
        ["event"] = {"CharacterTurnEnd"},
		["condition"] =
			function(context)
				local character = context:character()
				if character:has_military_force() then
					local military_force = character:military_force()
					if military_force:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID"  then
						local count = cm:get_saved_value("hkrul_grydal_initiative_03") or 0
						
						count = count + 1
						cm:set_saved_value("hkrul_grydal_initiative_03", count)
						
						if count >= 35 then
							return true
						end
					end				
				end
			end,
		["grant_immediately"] = true
	},
	{
        ["initiative_key"] = "hkrul_grydal_initiative_04",
        ["event"] = {"CharacterTurnStart", "CharacterRecruited"},
		["condition"] =
			function(context)
				local faction = context:character():faction()
				local character_list = faction:character_list()
				local count = 0
				
				for _, character in model_pairs(character_list) do
					if character:character_subtype("wh_dlc08_nor_skin_wolf_werekin") then
						count = count + 1
						
						if count >= 5 then
							return true
						end
					end
				end
			end,
		["grant_immediately"] = true
	},
	{
        ["initiative_key"] = "hkrul_grydal_ascend",
        ["event"] = {"CharacterInitiativeActivationChangedEvent"},
		["condition"] =
			function(context)
				if context:initiative():record_key():starts_with("hkrul_grydal_initiative_0") then
					local count = cm:get_saved_value("hkrul_grydal_ascend") or 0
					
					count = count + 1
					cm:set_saved_value("hkrul_grydal_ascend", count)
					
					if count >= 4 then
						return true
					end
				end
			end
	},
}

for i=1, #totn_initiative_templates do
	table.insert(initiative_templates, totn_initiative_templates[i])
end

--Rhox
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
        campaign_traits.legendary_lord_defeated_traits["hkrul_yngve"] ="hkrul_defeated_trait_yngve"
        campaign_traits.legendary_lord_defeated_traits["hkrul_geimdall"] ="hkrul_defeated_trait_geimdall"
        campaign_traits.legendary_lord_defeated_traits["hkrul_olaf"] ="hkrul_defeated_trait_olaf"
        campaign_traits.legendary_lord_defeated_traits["hkrul_eyri"] ="hkrul_defeated_trait_eyri"        
        campaign_traits.legendary_lord_defeated_traits["hkrul_grydal"] ="hkrul_defeated_trait_grydal"
        campaign_traits.legendary_lord_defeated_traits["hkrul_goftur"] ="hkrul_defeated_trait_goftur"        
        campaign_traits.legendary_lord_defeated_traits["hkrul_ziege"] ="hkrul_defeated_trait_ziege"
        campaign_traits.legendary_lord_defeated_traits["hkrul_bjornling_ogg"] ="hkrul_defeated_trait_ogg" 
        campaign_traits.legendary_lord_defeated_traits["hkrul_bubos_boss"] ="hkrul_defeated_trait_bubos"
        campaign_traits.legendary_lord_defeated_traits["hkrul_skoroth_boss"] ="hkrul_defeated_trait_skoroth"
        campaign_traits.legendary_lord_defeated_traits["hkrul_kolsveinn"] ="hkrul_defeated_trait_kolsveinn"
	end
)