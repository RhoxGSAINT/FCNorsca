rhox_fc_norsca_swyrd_cooltime=0

local cooltime=10
--hkrul_swyrd

local human_norsca_exist = false

core:add_listener(
    "turn_countdown_round_start_listener",
    "WorldStartRound",
    true,
    function()
        if rhox_fc_norsca_swyrd_cooltime >1 then
            rhox_fc_norsca_swyrd_cooltime = rhox_fc_norsca_swyrd_cooltime-1
        end
    end,
    true
);



cm:add_first_tick_callback(
	function()
        local norsca_factions = cm:get_human_factions_of_culture("wh_dlc08_nor_norsca")
        if not norsca_factions then
            out("Rhox FC Norsca: human norsca does not exist")
        else
            out("Rhox FC Norsca: human norsca exists")
        end
        
        
	end
)