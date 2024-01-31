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


local function norsca_leader_lost_battle(character)
    local pb = cm:model():pending_battle()
    
    return pb:has_been_fought() and not character:won_battle() and character:faction():culture() == "wh_dlc08_nor_norsca" and character:is_faction_leader() and (not human_norsca_exist or character:faction():is_human()) 
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
            "CharacterCompletedBattle",
            function(context)
                return norsca_leader_lost_battle(context:character())
            end,
            function(context)
                rhox_fc_norsca_swyrd_cooltime = rhox_fc_norsca_default_swyrd_cooltime
                cm:spawn_unique_agent(faction:command_queue_index(), "hkrul_lokjar", false) --this will take care of duplicate problems
                
                local faction = context:character():faction()
                
                if faction:is_human() then
                    local incident_key = "rhox_fc_norsca_swyrd_incident"
                    local incident_builder = cm:create_incident_builder(incident_key)
                    cm:launch_custom_incident_from_builder(incident_builder, faction)
                end
            end,
            true
        )

	end
)