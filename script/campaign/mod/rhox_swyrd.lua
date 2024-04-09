rhox_fc_norsca_swyrd_cooltime=0

local rhox_fc_norsca_default_swyrd_cooltime=10
local min_turn = 10
--hkrul_swyrd

local human_norsca_exist = false

core:add_listener(
    "turn_countdown_round_start_listener",
    "WorldStartRound",
    true,
    function()
        if rhox_fc_norsca_swyrd_cooltime >0 then
            rhox_fc_norsca_swyrd_cooltime = rhox_fc_norsca_swyrd_cooltime-1
        end
    end,
    true
);

core:add_listener(
    "rhox_swyrd_inform",
    "FactionTurnStart",
    function(context)
        local faction = context:faction()
        return faction:culture() == "wh_dlc08_nor_norsca" and faction:is_human() and cm:model():turn_number() == 10
    end,
    function(context)
        local faction = context:faction()
        local incident_builder = cm:create_incident_builder("rhox_fc_norsca_swyrd_available")
        cm:launch_custom_incident_from_builder(incident_builder, faction)
    end,
    true
);


local function norsca_leader_lost_battle(character)
    local pb = cm:model():pending_battle()
    --[[
    out("rhox fc norsca")
    out("Have you fought? ".. tostring(pb:has_been_fought()))
    out("Did you win? ".. tostring(character:won_battle()))
    out("cultue " ..character:faction():culture())
    out("Is it faction leader? " .. tostring(character:is_faction_leader()))
    out("Human Norsca exists? " .. tostring(human_norsca_exist))
    out("Is faction human ".. tostring(character:faction():is_human()))
    out("Turn number ".. cm:model():turn_number())
    out("Min turn ".. min_turn)
    out("Cool time ".. rhox_fc_norsca_swyrd_cooltime)
    --]]
    
    if not character or character:is_null_interface() then 
        return false
    end
    
    --not character:won_battle()   not putting this since it's causing error, and since it's checking destroyed, it would be safe
    return pb:has_been_fought() and character:faction():culture() == "wh_dlc08_nor_norsca" and character:is_faction_leader() and (not human_norsca_exist or character:faction():is_human()) 
    and cm:model():turn_number() >= min_turn and rhox_fc_norsca_swyrd_cooltime <=0
end


cm:add_first_tick_callback(
	function()
        local norsca_factions = cm:get_human_factions_of_culture("wh_dlc08_nor_norsca")
        if norsca_factions then
            for _, faction_key in ipairs(norsca_factions) do
                human_norsca_exist = true
            end
        end

        if human_norsca_exist then
            --out("Rhox FC Norsca: Human Norsca exist")
        else
            --out("Rhox FC Norsca: Human Norsca does not exist")
        end
        
        core:add_listener(
            "rhox_swyrd_norsca_leader_lost_battle",
            "CharacterDestroyed",
            function(context)
                local character = context:family_member():character();
                if not character then 
                    return false
                end
                return norsca_leader_lost_battle(character)
            end,
            function(context)
                out("Rhox FC Norsca: Trying to summon swyrd")
                local character = context:family_member():character();
                cm:spawn_unique_agent(character:faction():command_queue_index(), "hkrul_swyrd", false) --this will take care of duplicate problems
            end,
            true
        )
        core:add_listener(
            "rhox_swyrd_UniqueAgentSpawned",
            "UniqueAgentSpawned",
            function(context)
                local character = context:unique_agent_details():character()
                
                return not character:is_null_interface() and character:character_subtype("hkrul_swyrd")
            end,
            function(context)
                local character = context:unique_agent_details():character()
                local faction = character:faction()
                rhox_fc_norsca_swyrd_cooltime = rhox_fc_norsca_default_swyrd_cooltime
                
                if faction:is_human() then
                    local incident_key = "rhox_fc_norsca_swyrd_incident"
                    local incident_builder = cm:create_incident_builder(incident_key)
                    cm:launch_custom_incident_from_builder(incident_builder, faction)
                    if cm:get_local_faction(true) == faction then --ui thing and should be local
                        -- fly camera to Green Knight
                        cm:scroll_camera_from_current(false, 1, {character:display_position_x(), character:display_position_y(), 14.7, 0.0, 12.0})
                    end
                end
            end,
            true
        )
        core:add_listener(
            "rhox_swyrd_dies",
            "CharacterDestroyed",
            function(context)
                local character = context:family_member():character();
                return not character:is_null_interface() and character:character_subtype("hkrul_swyrd")
            end,
            function(context)
                local character = context:family_member():character();
                local faction = character:faction()
                
                if faction:is_human() then
                    local incident_key = "rhox_fc_norsca_swyrd_leaves"
                    local incident_builder = cm:create_incident_builder(incident_key)
                    cm:launch_custom_incident_from_builder(incident_builder, faction)
                    if cm:get_local_faction(true) == faction then
                        -- fly camera to Green Knight
                        cm:scroll_camera_from_current(false, 1, {character:display_position_x(), character:display_position_y(), 14.7, 0.0, 12.0})
                    end
                end
            end,
            true
        );
	end
)