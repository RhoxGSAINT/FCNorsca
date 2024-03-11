
local rhox_fc_norsca_unlockable_ror_list={
    rhox_graeling_werekin_of_fijgard={
        culture="wh_dlc08_nor_norsca",
        init_faction="wh_main_nor_graeling",
        agent_subtype="hkrul_harald",
    }
}

cm:add_first_tick_callback(
    function()
        for unit_key, info in pairs(rhox_fc_norsca_unlockable_ror_list) do
            core:add_listener(
                "rhox_fc_norsca_makes_alliance_"..unit_key,
                "PositiveDiplomaticEvent",
                function(context)
                    return ((context:recipient():name() == info.init_faction and context:proposer():culture() == info.culture) 
                    or (context:proposer():name() ==info.init_faction and context:recipient():culture() == info.culture)) 
                    and (context:is_military_alliance() or context:is_defensive_alliance() or context:is_vassalage())
                end,
                function(context)
                    if context:recipient():name() ==info.init_faction then
                        cm:remove_event_restricted_unit_record_for_faction(unit_key, context:proposer():name())
                    else
                        cm:remove_event_restricted_unit_record_for_faction(unit_key, context:recipient():name())
                    end
                    
                    
                end,
                true
            )
            core:add_listener(
                "rhox_fc_norsca_confederation_"..unit_key,
                "FactionJoinsConfederation",
                function(context)
                    return context:confederation():culture() == info.culture and context:faction():name() == info.init_faction
                end,
                function(context)
                    cm:remove_event_restricted_unit_record_for_faction(unit_key, context:confederation():name())
                end,
                true
            )
            core:add_listener(
                "rhox_fc_norsca_agent_turn_start_"..unit_key,
                "CharacterTurnStart",
                function(context)
                    local character = context:character()
                    return character:character_subtype(info.agent_subtype)
                end,
                function(context)
                    local character = context:character()
                    local faction = character:faction()
                    cm:remove_event_restricted_unit_record_for_faction(unit_key, faction:name())
                end,
                true
            )            
        end
    end
)


cm:add_first_tick_callback_new(
    function()
        for unit_key, info in pairs(rhox_fc_norsca_unlockable_ror_list) do
            local all_factions = cm:model():world():faction_list();
            for i = 0, all_factions:num_items()-1 do
                local faction = all_factions:item_at(i);
                if faction:culture() == info.culture then
                    cm:add_unit_to_faction_mercenary_pool(faction, unit_key, "renown", 1, 20, 1, 0.1, "", "", "", true, unit_key)
                    if faction:name() ~= info.init_faction then
                        cm:add_event_restricted_unit_record_for_faction(unit_key, faction:name(), unit_key.."_lock")
                    end
                end
            end;
        end
    end
)