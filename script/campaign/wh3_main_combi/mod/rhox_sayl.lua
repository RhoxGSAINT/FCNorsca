local dolgan_faction = "wh3_dlc20_nor_dolgan"





local choice_index={
    {
        unit_pool ={"wh3_dlc20_chs_inf_chosen_mkho", "wh3_dlc20_chs_inf_chosen_mkho_dualweapons"},
        choice_string="FIRST",
        pooled_resource="nor_progress_hound",
    },
    {
        unit_pool ={"wh3_dlc20_chs_inf_chosen_mtze", "wh3_dlc20_chs_inf_chosen_mtze_halberds"},
        choice_string="SECOND",
        pooled_resource="nor_progress_eagle",
    },
    {
        unit_pool ={"wh3_dlc20_chs_inf_chosen_mnur", "wh3_dlc20_chs_inf_chosen_mnur_greatweapons"},
        choice_string="THIRD",
        pooled_resource="nor_progress_crow",
    },
    {
        unit_pool ={"wh3_dlc20_chs_inf_chosen_msla", "wh3_dlc20_chs_inf_chosen_msla_hellscourges"},
        choice_string="FOURTH",
        pooled_resource="nor_progress_serpent",
    },
}



local did_dilemma_requested_resource={
    false,
    false,
    false,
    false
}






local trickery_required_num={
    ["1"]="rhox_sayl_tricker_trait_1",
    ["5"]="rhox_sayl_tricker_trait_2",
    ["10"]="rhox_sayl_tricker_trait_3",
    ["20"]="rhox_sayl_tricker_trait_4",
    ["40"]="rhox_sayl_tricker_trait_5"
}





core:add_listener(
    "rhox_sayl_ritual_completed",
    "RitualCompletedEvent",
    function(context)
        local ritual = context:ritual()
        local faction = context:performing_faction();
        local faction_key = faction:name();
        return ritual:ritual_key() == "rhox_sayl_ritual" and faction:is_human()
    end,
    function(context)
        local faction = context:performing_faction()
        
        local dilemma_builder = cm:create_dilemma_builder("rhox_sayl_ritual_dilemma");
		local payload_builder = cm:create_payload();
		
		
		
        for i=1,#choice_index do
            local mercenary_pool = choice_index[i].unit_pool
            local pooled_resource = faction:pooled_resource_manager():resource(choice_index[i].pooled_resource):value() 
            if pooled_resource >= 10 then
                for j=1,#mercenary_pool do
                    payload_builder:add_mercenary_to_faction_pool(mercenary_pool[j], 3) --give each 3 
                end
                
                payload_builder:faction_pooled_resource_transaction(choice_index[i].pooled_resource, "events", -10, true)--but with resource minus
                did_dilemma_requested_resource[i]=true

                local trickery_check = cm:get_saved_value("rhox_sayl_choice_made")
                out("Rhox FC Norsca: Current trickery "..tostring(trickery_check))
                if not trickery_check then
                    --out("Rhox FC Norsca: There wasn't a trickery check")
                    payload_builder:character_trait_change(faction:faction_leader(),"rhox_sayl_tricker_trait_1",false)    
                elseif trickery_required_num[tostring(trickery_check+1)] then
                    out("Rhox FC Norsca: Trickery num: ".. trickery_check)
                    out("Rhox FC Norsca: Trait: ".. trickery_required_num[tostring(trickery_check+1)])
                    payload_builder:character_trait_change(faction:faction_leader(),trickery_required_num[tostring(trickery_check+1)],false)    
                end
            else
                payload_builder:add_mercenary_to_faction_pool(mercenary_pool[cm:random_number(#mercenary_pool)], 1)  --just one without resource minus
                did_dilemma_requested_resource[i]=false
            end

            dilemma_builder:add_choice_payload(choice_index[i].choice_string, payload_builder);
		    payload_builder:clear();
        end
        dilemma_builder:add_target("default", faction:faction_leader():family_member());
		cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
    end,
    true
)

core:add_listener(
    "rhox_sayl_choice_made_for_trait_check",
    "DilemmaChoiceMadeEvent",
    function(context)
        local dilemma_key = context:dilemma()
        return dilemma_key == "rhox_sayl_ritual_dilemma"
    end,
    function(context)
        local choice = context:choice()
        if did_dilemma_requested_resource[choice+1] then
            out("Rhox FC Norsca: Increasing count")
            if not cm:get_saved_value("rhox_sayl_choice_made") then
                cm:set_saved_value("rhox_sayl_choice_made", 0)
            end
            local previous_value = cm:get_saved_value("rhox_sayl_choice_made")
            cm:set_saved_value("rhox_sayl_choice_made", previous_value+1)
        end
    end,
    true
)






core:add_listener(
    "rhox_sayl_for_AI",
    "FactionTurnStart",
    function(context)
        local faction = context:faction()
        return faction:name() == dolgan_faction and not faction:is_human()
    end,
    function(context)
        local turn = cm:model():turn_number();
        local faction = context:faction()
        if turn % 5 == 1 then
            --out("Rhox FC Norsca adding units")
            local mercenary_pool = choice_index[cm:random_number(#choice_index)].unit_pool
            for j=1,#mercenary_pool do
                cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), mercenary_pool[j], 1) 
            end
           
        end
    end,
    true
);

cm:add_first_tick_callback(
    function()
    
        if cm:get_local_faction_name(true) == dolgan_faction then
            

            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            
            local result = core:get_or_create_component("rhox_sayl_ritual_button", "ui/campaign ui/rhox_sayl_ritual_button.twui.xml", parent_ui)
            result:SetContextObject(cco("CcoCampaignFaction", dolgan_faction))
            
        end
        
    end
)
