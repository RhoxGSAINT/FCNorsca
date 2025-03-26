local function yingre_mission(faction_key)

    local mm = mission_manager:new(faction_key, "hkrul_nor_yngve1")

	mm:add_new_objective("HAVE_N_AGENTS_OF_TYPE")
	mm:add_condition("total 3")
	mm:add_condition("agent wizard")
	mm:add_payload("money 3000")
	mm:add_payload("text_display hkrul_fc_norsca_yngve_dummy")
	
	mm:set_should_whitelist(false)
    mm:trigger()

end

---------------------
-- spawn listeners --
---------------------
core:add_listener(
	"totn_yngve_missionsucceded",
	"MissionSucceeded",
	function(context)
		return context:mission():mission_record_key() == "hkrul_nor_yngve1"
	end,
	function(context)
		local faction = context:faction()
		if faction:has_faction_leader() then
			cm:spawn_unique_agent_at_character(faction:command_queue_index(), "hkrul_yngve", faction:faction_leader():command_queue_index(), true)
		end
	end,
	true
)

local function issue_mission()
	local norsca_human = cm:get_human_factions_of_culture("wh_dlc08_nor_norsca")
	
	for i=1, #norsca_human do
		yingre_mission(norsca_human[i])
	end
end

cm:add_first_tick_callback(
	function()
		if cm:is_new_game() then
			cm:callback(function()	issue_mission() end, 5)
		end
	end
)
