local sarl_faction ="wh_main_nor_sarl"

local rhox_birna_monster_hunter_counts={}

local monster_hunts_index = {
	"monster_hunt_0",
	"monster_hunt_1",
	"monster_hunt_2",
	"monster_hunt_3",
	"monster_hunt_4",
	"monster_hunt_5",
	"monster_hunt_6",
	"monster_hunt_7",
	"monster_hunt_8",
	"monster_hunt_9",
	"monster_hunt_10",
	"monster_hunt_11"
};

local rhox_birna_completed_hunt={}





local function rhox_birna_recalculate_ws_effect(character)
	local faction = character:faction()
	local faction_key = faction:name()
	
	--out("Rhox fc Norsca: I'm here")

	local birna_effect_bundle_key= "rhox_birna_ws_hunt"
	cm:remove_effect_bundle_from_character(birna_effect_bundle_key, character)

	if not rhox_birna_monster_hunter_counts[faction_key] or rhox_birna_monster_hunter_counts[faction_key] ==0 then
        --out("Rhox fc Norsca: There wasn't appropriate value to give to her")
		return --if it's 0 or does not exist, you don't have to do anything	
	end
	

	
	local birna_effect_bundle = cm:create_new_custom_effect_bundle(birna_effect_bundle_key)

	birna_effect_bundle:add_effect("wh_main_effect_character_stat_missile_damage", "character_to_character_own", rhox_birna_monster_hunter_counts[faction_key]*5)
	birna_effect_bundle:set_duration(0)

	
	
	cm:apply_custom_effect_bundle_to_character(birna_effect_bundle, character)

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
	"rhox_birna_MonsterHuntMissionSucceeded",
	"MissionSucceeded",
	true,--do it for everybody, yeah bad performance wise but to support confederation (maybe even cross-culture)
	function(context)
		local faction = context:faction()
		local faction_key = context:faction():name();
		local key = context:mission():mission_record_key();
		
		
		local monster_hunt_data_for_faction = monster_hunts[faction_key]
		if monster_hunt_data_for_faction == nil then
			monster_hunt_data_for_faction = monster_hunts["wh_dlc08_nor_norsca"]
		end	
		
		for i = 1, #monster_hunts_index do
			if key == monster_hunt_data_for_faction[monster_hunts_index[i]]["qb"] then
				if not rhox_birna_monster_hunter_counts[faction_key] then
					rhox_birna_monster_hunter_counts[faction_key]=0
				end
				
				if faction_key == sarl_faction then --for her faction feature
                    rhox_birna_completed_hunt[key]=true
				end
				
				if faction_key == "wh_main_nor_graeling" and not cm:get_saved_value("rhox_graeling_hunt_mission_completed") then
                    cm:set_saved_value("rhox_graeling_hunt_mission_completed", true)
                    cm:complete_scripted_mission_objective("wh_main_nor_graeling", "rhox_graeling_mission_wh_main_nor_sarl", "rhox_graeling_hunt", true)
				end
				
				rhox_birna_monster_hunter_counts[faction_key]=rhox_birna_monster_hunter_counts[faction_key]+1 
				local character = get_character_by_subtype("hkrul_birna", faction)
				if character then
					rhox_birna_recalculate_ws_effect(character)
				end
			end
		end
	end,
	true
);


core:add_listener(
    "rhox_birna_bundle_backup",
    "CharacterTurnStart",
    function(context)
        local character = context:character()
        return character:character_subtype("hkrul_birna")--doesn't need a skill check because it's an innate
    end,
    function(context)
        local character = context:character()    
        
        rhox_birna_recalculate_ws_effect(character)
        
    end,
    true
)

core:add_listener(
    "rhox_birna_confederation",
    "FactionJoinsConfederation",
    true,
    function(context)
        local faction = context:confederation()
		local character = get_character_by_subtype("hkrul_birna", faction)

		if character then
			rhox_birna_recalculate_ws_effect(character)
		end
    end,
    true
)


-----------------------------------------------------------REDO monster hunts
rhox_birna_culture_to_monster_hunt={ --some mod might want to add it. I doubt it though
    wh_dlc08_nor_norsca={
        "wh_dlc08_qb_nor_monster_hunt_0",
        "wh_dlc08_qb_nor_monster_hunt_6"
    },
    wh_dlc03_bst_beastmen={
        "wh_dlc08_qb_nor_monster_hunt_1"
    },
    wh_main_chs_chaos={
        "wh_dlc08_qb_nor_monster_hunt_2",
    },
    wh_main_grn_greenskins={
        "wh_dlc08_qb_nor_monster_hunt_3",
        "wh_dlc08_qb_nor_monster_hunt_4"
    },
    wh_dlc05_wef_wood_elves={
        "wh_dlc08_qb_nor_monster_hunt_5"
    },
    wh_main_vmp_vampire_counts={
        "wh_dlc08_qb_nor_monster_hunt_7"
    },
    wh2_main_hef_high_elves={
        "wh2_dlc10_qb_nor_monster_hunt_8"
    },
    wh2_main_lzd_lizardmen={
        "wh2_dlc10_qb_nor_monster_hunt_9"
    },
    wh2_main_def_dark_elves={
        "wh2_dlc10_qb_nor_monster_hunt_10"
    },
    wh2_main_skv_skaven={
        "wh2_dlc10_qb_nor_monster_hunt_11"
    }
}


core:add_listener(
    "rhox_birna_character_completed_battle",
    "CharacterCompletedBattle",
    function(context)
        local character = context:character()
        return character:won_battle() and character:faction():name() == sarl_faction and character:is_faction_leader()
    end,
    function(context)
        local character = context:character()
        local faction = character:faction()
        local bonus_value = faction:bonus_values():scripted_value("rhox_birna_hunting_bonus", "value")
        for culture, quests in pairs(rhox_birna_culture_to_monster_hunt) do
            if cm:character_won_battle_against_culture(character, culture) then
                local target_quest = quests[cm:random_number(#quests)]
                if rhox_birna_completed_hunt[target_quest] and cm:model():random_percent(bonus_value) then
                    cm:trigger_mission(faction:name(), target_quest, true)
                    break
                end
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
		cm:save_named_value("rhox_birna_monster_hunter_counts", rhox_birna_monster_hunter_counts, context);
		cm:save_named_value("rhox_birna_completed_hunt", rhox_birna_completed_hunt, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			rhox_birna_monster_hunter_counts = cm:load_named_value("rhox_birna_monster_hunter_counts", rhox_birna_monster_hunter_counts, context);
			rhox_birna_completed_hunt = cm:load_named_value("rhox_birna_completed_hunt", rhox_birna_completed_hunt, context);
		end;
	end
);