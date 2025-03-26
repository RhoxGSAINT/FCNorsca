local bjornling_faction = "wh_main_nor_bjornling"

local choice_string ={
    "FIRST",
    "SECOND",
    "THIRD",
    "FOURTH",
    "FIFTH"
}

local trade_candidate={

}

core:add_listener(
    "rhox_bjornling_ritual_completed",
    "RitualCompletedEvent",
    function(context)
        local ritual = context:ritual()
        local faction = context:performing_faction();
        local faction_key = faction:name();
        return ritual:ritual_key() == "rhox_bjornling_fish_sale" and faction:is_human()
    end,
    function(context)
        local faction = cm:get_faction(bjornling_faction)
        
        trade_candidate={}--reset

        local all_factions = cm:model():world():faction_list();
        for i = 0, all_factions:num_items()-1 do
            local current_faction = all_factions:item_at(i);
            if faction:trade_agreement_with(current_faction) then
                --out("Rhox Fjordling: This faction has trade agreement with Fjordling".. current_faction:name())
                table.insert(trade_candidate,current_faction)
            end
        end;
        
        trade_candidate=cm:random_sort(trade_candidate)
        
        --out("Rhox Fjordling: Trade candidate Number: ".. #trade_candidate)

        local dilemma_builder = cm:create_dilemma_builder("rhox_bjornling_fish_sale");
		local payload_builder = cm:create_payload();
		payload_builder:faction_pooled_resource_transaction("wh3_main_ksl_followers", "events", 10, false)
        payload_builder:treasury_adjustment(1600+cm:random_number(900,0));
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        local candidate_num =#trade_candidate
        if candidate_num >3 then
            candidate_num =3
        end
        for i=1,candidate_num do
            payload_builder:treasury_adjustment(2250+cm:random_number(1400,0));
            payload_builder:diplomatic_attitude_adjustment(trade_candidate[i], cm:random_number(3,1))
            dilemma_builder:add_choice_payload(choice_string[i+1], payload_builder);--1 is local
            payload_builder:clear();
        end
        
        
		cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
    end,
    true
)

core:add_listener(
    "rhox_bjornling_settlements_fish_sale_dilemma_issued",
    "DilemmaIssuedEvent",
    function(context)
        return context:dilemma() == "rhox_bjornling_fish_sale"
    end,
    function(context)
        core:add_listener(
        "rhox_bjornling_dilemma_panel_listener",
        "PanelOpenedCampaign",
        function(context)
            return (context.string == "events")

        end,
        function(context)

            cm:callback(function()
                local dilemma_choice_count=3
                if #trade_candidate < 3 then
                    dilemma_choice_count= #trade_candidate
                end
                
                
                for i=1,dilemma_choice_count do 
                    local target_faction= trade_candidate[i]
                    
                    local flag_path = target_faction:flag_path()
                    local faction_name_string = ("[[img:"..flag_path.."/mon_24.png]][[//img]] "..common.get_localised_string("factions_screen_name_".. trade_candidate[i]:name()))
                    

                    local dilemma_location = find_uicomponent(core:get_ui_root(),"events", "event_layouts", "dilemma_active", "dilemma", "background","dilemma_list", "CcoCdirEventsDilemmaChoiceDetailRecordrhox_bjornling_fish_sale"..choice_string[i+1], "choice_button", "button_txt")
                    if dilemma_location then
                        dilemma_location:SetText(faction_name_string)
                    end
                end

            end,
            0.3
            )

        end,
        false --see you next time
    )
    end,
    true
)

local fish_ancillaries={
    "hkrul_norsca_fish_01",
    "hkrul_norsca_fish_02",
    "hkrul_norsca_fish_03",
    "hkrul_norsca_fish_04",
    "hkrul_norsca_fish_05",
    "hkrul_norsca_fish_06",
    "hkrul_norsca_fish_07",
    "hkrul_norsca_fish_08",
    "hkrul_norsca_fish_09",
    "hkrul_norsca_fish_10",
    "hkrul_norsca_fish_11",
    "hkrul_norsca_fish_12",
    "hkrul_norsca_fish_13",
    "hkrul_norsca_fish_14",
    "hkrul_norsca_fish_15",
    "hkrul_norsca_fish_16",
    "hkrul_norsca_fish_17",
    "hkrul_norsca_fish_18",
    "hkrul_norsca_fish_19",
    "hkrul_norsca_fish_20",
}


core:add_listener(
    "rhox_bjornling_item",
    "CharacterTurnStart",
    function(context)
        local character = context:character()
        local faction = character:faction()
        if not character:has_military_force() then
            return false
        end
        local military_force = character:military_force()
        local base_chance = 11
        return faction:name() == bjornling_faction and military_force:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_DOUBLE_TIME" and cm:random_number(100,1) <= base_chance
    end,
    function(context)
        local character = context:character()
        cm:force_add_ancillary(character, fish_ancillaries[cm:random_number(#fish_ancillaries,1)], false, false)
    end,
    true
)


local norse_god_allegiances={
    nor_progress_crow=true,
    nor_progress_eagle=true,
    nor_progress_hound=true,
    nor_progress_serpent=true,
}




core:add_listener(
    "rhox_bjornling_nor_progress_changed",
    "PooledResourceChanged",
    function(context)
        return norse_god_allegiances[context:resource():key()] and context:faction():name() == bjornling_faction
    end,
    function(context)
        local faction_key = context:faction():name()
        local resource_key = context:resource():key()
        cm:faction_add_pooled_resource(faction_key, resource_key, "events", -100)
    end,
    true
)

