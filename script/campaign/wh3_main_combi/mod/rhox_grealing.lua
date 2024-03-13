local graeling_faction ="wh_main_nor_graeling"
local graeling_mission_key = "rhox_graeling_mission_"


local confederation_target_factions={
    wh_dlc08_nor_norsca={objective="SCRIPTED",custom_function=function(mm) cm:set_saved_value("rhox_graeling_ll", 0) end, condition={"script_key rhox_graeling_ll","override_text mission_text_text_rhox_graeling_ll_0"}},
    wh_dlc08_nor_wintertooth={db_type=true},
    wh3_dlc20_nor_dolgan={objective="ENGAGE_FORCE",custom_function=function(mm) mm:add_condition("cqi "..cm:get_faction("wh_main_chs_chaos"):faction_leader():military_force():command_queue_index()) end,condition={"requires_victory"}},
    wh3_dlc20_nor_kul={objective="DEFEAT_N_ARMIES_OF_FACTION",condition={"subculture wh_main_sc_chs_chaos","total 10"}},
    wh_dlc08_nor_vanaheimlings={db_type=true},
    wh_main_nor_aesling={objective="DESTROY_FACTION",condition={"faction wh3_main_kho_exiles_of_khorne"}},
    wh_main_nor_baersonling={objective="DESTROY_FACTION",condition={"faction wh3_main_tze_oracles_of_tzeentch"}},
    wh_main_nor_bjornling={objective="DEFEAT_N_ARMIES_OF_FACTION",condition={"subculture wh_main_sc_emp_empire","total 5"}},
    wh_main_nor_sarl={objective="SCRIPTED",condition={"script_key rhox_graeling_hunt","override_text mission_text_text_rhox_graeling_hunt"}},
    wh_main_nor_varg={db_type=true},
    wh_main_nor_skaeling={db_type=true},
    wh2_main_nor_skeggi={objective="DEFEAT_N_ARMIES_OF_FACTION",condition={"faction wh2_main_lzd_hexoatl","total 1"}},
    wh3_dlc20_nor_yusak={objective="DEFEAT_N_ARMIES_OF_FACTION",condition={"subculture wh3_main_sc_cth_cathay","total 3"}},
    wh_dlc08_nor_naglfarlings={db_type=true},
    --mixer_nor_fjordlings
    --
}

local lccp_confederation_target_factions={
    cr_nor_tokmars={db_type=true},
    rhox_nor_firebrand_slavers={objective="INCOME_AT_LEAST_X",condition={"income 8000"}},
    rhox_nor_ravenblessed={objective="RECRUIT_AGENT",condition={"total 8",}},
    rhox_nor_khazags={objective="ACHIEVE_CHARACTER_RANK",condition={"total 1", "total2 35", "include_generals"}},
    mixer_nur_rotbloods={objective="DEFEAT_N_ARMIES_OF_FACTION",condition={"subculture wh3_main_sc_ksl_kislev","total 5"}},--this is beorg
}






local function rhox_graeling_trigger_missions()

    
    for faction_key, details in  pairs(confederation_target_factions) do
        if details.db_type then
            cm:trigger_mission(graeling_faction,graeling_mission_key..faction_key,true)
        else
            local mm = mission_manager:new(graeling_faction, graeling_mission_key..faction_key)
            if not mm then
                return
            end
            mm:add_new_objective(details.objective);

            if details.custom_function then
                details.custom_function(mm)
            end
            for i=1,#details.condition do
                mm:add_condition(details.condition[i]);
            end
            mm:add_payload("text_display ".."rhox_graeling_payload_"..faction_key);
            mm:add_payload("money 5000");
            mm:trigger()
        end
    end
    

    if cm:model():campaign_name_key() == "cr_combi_expanded" and vfs.exists("script/frontend/mod/rhox_iee_lccp_frontend.lua") then --have to make initial enemy for him then
        for faction_key, details in  pairs(lccp_confederation_target_factions) do
            if details.db_type then
                cm:trigger_mission(graeling_faction,graeling_mission_key..faction_key,true)
            else
                local mm = mission_manager:new(graeling_faction, graeling_mission_key..faction_key)
                if not mm then
                    return
                end
                mm:add_new_objective(details.objective);
                if details.custom_function then
                    details.custom_function(mm)
                end

                for i=1,#details.condition do
                    mm:add_condition(details.condition[i]);
                end
                mm:add_payload("text_display ".."rhox_graeling_payload_"..faction_key);
                mm:add_payload("money 5000");
                mm:trigger()
            end
        end
    end
end





core:add_listener(
    "rhox_graeling_mission_completed",
    "MissionSucceeded",
    function(context)    
        local mission_key = context:mission():mission_record_key();
        local faction_key = context:faction():name()
        return faction_key == graeling_faction and mission_key:starts_with(graeling_mission_key)
    end,
    function(context)
        local mission_key = context:mission():mission_record_key();
        local faction = context:faction()
        local faction_key = context:faction():name()
        local target_faction_key = string.gsub(mission_key,graeling_mission_key,"")
        cm:force_confederation(faction_key, target_faction_key)
        
        local target_faction = cm:get_faction(target_faction_key)
        if target_faction and not target_faction:is_dead() then
            local incident_builder = cm:create_incident_builder(mission_key)
            cm:launch_custom_incident_from_builder(incident_builder, faction)
        end
    end,
    true
)


local function rhox_graeling_get_enemy_subtypes()--changeling one except for the heroes one and the agent_subtype
	local pb = cm:model():pending_battle()
	local attacker_subtypes = {}
	local defender_subtypes = {}
	local was_attacker = false

	local num_attackers = cm:pending_battle_cache_num_attackers()
	local num_defenders = cm:pending_battle_cache_num_defenders()

	if pb:night_battle() == true or pb:ambush_battle() == true then
		num_attackers = 1
		num_defenders = 1
	end
	
	for i = 1, num_attackers do
		local char_subtype = cm:pending_battle_cache_get_attacker_subtype(i)
		
		if char_subtype == "hkrul_harald" then
			was_attacker = true
			break
		end

		if not was_attacker then
			table.insert(attacker_subtypes, char_subtype)
		
		--[[
			local embedded_attacker_subtypes = cm:pending_battle_cache_get_attacker_embedded_character_subtypes(i)
			
			for j = 1, #embedded_attacker_subtypes do
				table.insert(attacker_subtypes, embedded_attacker_subtypes[j])
			end
			]]
		end
	end
	
	if was_attacker == false then
		return attacker_subtypes
	end
	
	for i = 1, num_defenders do
		local char_subtype = cm:pending_battle_cache_get_defender_subtype(i)
		
		table.insert(defender_subtypes, char_subtype)
		
		--[[
		local embedded_defender_subtypes = cm:pending_battle_cache_get_defender_embedded_character_subtypes(i)
		
		for j = 1, #embedded_defender_subtypes do
			table.insert(defender_subtypes, embedded_defender_subtypes[j])
		end
		]]
	end

	return defender_subtypes
end


core:add_listener(
    "rhox_graeling_LL_defeated",
    "CharacterCompletedBattle",
    function(context)    
        local character = context:character();
        if not character:won_battle() then
            return false
        end

        if not character:faction():is_human() then --as it's a mission don't have to do for AI
            return false
        end

        if character:faction():name() ~= graeling_faction or character:character_subtype_key() ~= "hkrul_harald" then
            return false
        end

        if cm:get_saved_value("rhox_graeling_ll_mission_completed") then
            return false
        end
        
        local enemy_agent_subtype = rhox_graeling_get_enemy_subtypes()
        for i = 1, #enemy_agent_subtype do
            --out("Rhox Thorgar: Looking at: ".. enemy_agent_subtype[i])
            if cm:is_agent_transformation_available(enemy_agent_subtype[i]) then
                --out("Rhox Thorgar: It's a LL")
                if not cm:get_saved_value("rhox_graeling_ll") then
                    cm:set_saved_value("rhox_graeling_ll", 0)
                end
                cm:set_saved_value("rhox_graeling_ll", cm:get_saved_value("rhox_graeling_ll")+1)
                if cm:get_saved_value("rhox_graeling_ll") <=5 then
                    cm:set_scripted_mission_text("rhox_graeling_mission_wh_dlc08_nor_norsca", "rhox_graeling_ll", "mission_text_text_rhox_graeling_ll_"..cm:get_saved_value("rhox_graeling_ll"))
                end
            end
        end
        
        return cm:get_saved_value("rhox_graeling_ll") and cm:get_saved_value("rhox_graeling_ll")>=5;
    end,
    function(context)
        cm:set_saved_value("rhox_graeling_ll_mission_completed", true)
        cm:complete_scripted_mission_objective(graeling_faction, "rhox_graeling_mission_wh_dlc08_nor_norsca", "rhox_graeling_ll", true)
    end,
    true
)

-------Monster hunts will be done in the Birna's script!

cm:add_first_tick_callback(
	function()
        if cm:is_new_game() and cm:get_faction(graeling_faction):is_human() then
            rhox_graeling_trigger_missions()
        end
	end
)







----------------------------------------------------------UI thing
cm:add_first_tick_callback(
    function()
        if cm:get_local_faction_name(true) == graeling_faction then
            local resources_bar = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            if resources_bar then
                core:get_or_create_component("rhox_graeling_norsca_unit_panel_button", "ui/campaign ui/rhox_graeling_button.twui.xml", resources_bar)
            end
            core:add_listener(
                "rhox_graeling_panel_open_button_leftclick",
                "ComponentLClickUp",
                function (context)
                    return context.string == "rhox_graeling_button_narrative_panel"
                end,
                function ()
                    local panel = core:get_or_create_component("rhox_graeling_panel", "ui/campaign ui/rhox_graeling_panel.twui.xml", core:get_ui_root())
                end,
                true
            )
            core:add_listener(
                "rhox_graeling_panel_close_button_leftclick",
                "ComponentLClickUp",
                function (context)
                    return context.string == "rhox_graeling_narrative_panel_close_button"
                end,
                function ()
                    local panel = find_uicomponent(core:get_ui_root(), "rhox_graeling_panel")
                    if panel then
                        panel:Destroy()
                    end
                end,
                true
            )
        end
    end
);

