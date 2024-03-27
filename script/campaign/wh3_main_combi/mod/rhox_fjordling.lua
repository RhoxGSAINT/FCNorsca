core:add_listener(
    "rhox_sfjordling_ritual_completed",
    "RitualCompletedEvent",
    function(context)
        local ritual = context:ritual()
        local faction = context:performing_faction();
        local faction_key = faction:name();
        return ritual:ritual_key() == "rhox_fjordling_fish_sale" and faction:is_human()
    end,
    function(context)
        local faction = context:performing_faction()
        
        local dilemma_builder = cm:create_dilemma_builder("rhox_fjordling_fish_sale");
		local payload_builder = cm:create_payload();

        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
		cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
    end,
    true
)




--[[

core:add_listener(
    "rhox_fjordling_show_resource",
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