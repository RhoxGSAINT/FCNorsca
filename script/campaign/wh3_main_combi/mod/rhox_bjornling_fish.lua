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
        payload_builder:treasury_adjustment(1200+cm:random_number(600,0));
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        local candidate_num =#trade_candidate
        if candidate_num >3 then
            candidate_num =3
        end
        for i=1,candidate_num do
            payload_builder:treasury_adjustment(2000+cm:random_number(1000,0));
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





--[[

core:add_listener(
    "rhox_bjornling_show_resource",
    "ForceAdoptsStance",
    function(context)
        local faction = context:military_force():faction()
        
        return faction:is_human() and faction:name() == "mixer_nor_fjordlings"
    end,
    function(context)
        local mf = context:military_force()
        if mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_PATROL" then
            common.set_context_value("raiding_slaves_value_" .. mf:command_queue_index(), 10)
            --out("Rhox Fjordling: Check")
        else
            common.set_context_value("raiding_slaves_value_" .. mf:command_queue_index(), 0)
        end
    end,
    true
)
--]] --it does not work on MILITARY_FORCE_ACTIVE_STANCE_TYPE_PATROL as it has some TWUI issue