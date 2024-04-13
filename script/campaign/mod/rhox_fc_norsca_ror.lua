
local rhox_fc_norsca_unlockable_ror_list={
    rhox_graeling_werekin_of_fijgard={
        culture="wh_dlc08_nor_norsca",
        init_faction="wh_main_nor_graeling",
        agent_subtype="hkrul_harald",
    },
    wolftribe_nor_inf_wolf_champions_ror_0={
        culture="wh_dlc08_nor_norsca",
        init_faction="wh_dlc08_nor_naglfarlings",
        agent_subtype="scm_norsca_huern",
    },
    rhox_bjornling_huscarl_ror={
        culture="wh_dlc08_nor_norsca",
        init_faction="wh_main_nor_bjornling",
        agent_subtype="hkrul_ulfric",
    },
    rhox_skeggi_dodvakt={
        culture="wh_dlc08_nor_norsca",
        init_faction="wh2_main_nor_skeggi",
        agent_subtype="hkrul_adella",
    },
    hkrul_skeggi_giant_ror={
        culture="wh_dlc08_nor_norsca",
        init_faction="wh2_main_nor_skeggi",
        agent_subtype="hkrul_adella",
        special_condition_for_init=true,--quest battle
    },
    hkrul_sarl_hunters_ror={
        culture="wh_dlc08_nor_norsca",
        init_faction="wh_main_nor_sarl",
        agent_subtype="hkrul_birna",
    },
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
                    --out("Rhox fc Norsca: Check: ".. unit_key)
                    local character = context:character()
                    local faction = character:faction()
                    
                    if faction:name() == info.init_faction and info.special_condition_for_init then
                        return false --don't do anything as it will unlock in other means
                    end
                    
                    --out("Rhox fc Norsca: unlocking for faction ".. faction:name())
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
                    if faction:name() ~= info.init_faction or info.special_condition_for_init then
                        cm:add_event_restricted_unit_record_for_faction(unit_key, faction:name(), unit_key.."_lock")
                    end
                end
            end;
        end
    end
)


------------------------------------------------------------Special one for Varg