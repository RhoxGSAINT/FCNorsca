local aesling_faction ="wh_main_nor_aesling"

core:add_listener(
    "rhox_aesling_CharacterPerformsSettlementOccupationDecisionSummonArmy",
    "CharacterPerformsSettlementOccupationDecision",
    function(context)
        return context:occupation_decision() == "1963655228" and context:character():faction():name() == aesling_faction
    end,
    function(context)
        local region = context:garrison_residence():settlement_interface():region()
        local character = context:character()

        khorne_spawned_armies:spawn_army(region, character)
        
    end,
    true
);
