local function rhox_is_gutrot_blocked(faction_key)
    local special_tables = {RHOX_TOTN_SPECIAL_FACTIONS, RHOX_LCCP_SPECIAL_FACTIONS}
    for i = 1, 2 do --not ipairs, it stops at the first nil
        local special_factions = special_tables[i]
        if type(special_factions) == "table" and special_factions[faction_key] and special_factions[faction_key] ~= "nurgle" then
            return true
        end
    end
    return false
end

cm:add_first_tick_callback(
    function()
        local gutrot = character_unlocking.character_data["gutrot_spume"]
        local allowed_factions = gutrot.allowed_factions or character_unlocking:get_allowed_factions_list(gutrot)

        local blocked_human_found = false
        for _, faction_key in ipairs(allowed_factions) do
            local faction = cm:get_faction(faction_key)
            if faction and faction:is_human() then
                if rhox_is_gutrot_blocked(faction_key) then
                    blocked_human_found = true
                else
                    return --this human can get Gutrot
                end
            end
        end
        if not blocked_human_found then --no human at all, vanilla gives it to AI already
            return
        end

        core:add_listener(
            "rhox_gutrot_ai_unlock_WorldStartRound",
            "WorldStartRound",
            function(context)
                return gutrot.has_spawned == false and cm:turn_number() >= gutrot.ai_unlock_turn
            end,
            function(context)
                local ai_faction = character_unlocking:get_strongest_ai_faction_available_to_character("gutrot_spume")
                local priority_ai_faction = cm:get_faction(gutrot.priority_ai_faction)
                if priority_ai_faction and not priority_ai_faction:is_dead() then
                    ai_faction = gutrot.priority_ai_faction
                end
                if ai_faction then
                    character_unlocking:spawn_hero(ai_faction, "gutrot_spume")
                end
            end,
            false
        )
    end
)
