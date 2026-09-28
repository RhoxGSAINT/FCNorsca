

load_script_libraries()

gb = generated_battle:new(
	false,                                      		-- screen starts black (0.010: false - see NOTE above)
	false,                                      		-- prevent deployment for player
	true,                                      			-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end,          	-- intro cutscene function
	false                                      			-- debug mode
)

gb:set_cutscene_during_deployment(true)

-------------------------------------------------------------------------------------------------
------------------------------------------- ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num())
ga_ulfric_reinforcement = gb:get_army(gb:get_player_alliance_num(), "ulfric_reinforcements")

ga_ai_undead_main = gb:get_army(gb:get_non_player_alliance_num(), "undead_main")
ga_ai_undead_reinforcement_1 = gb:get_army(gb:get_non_player_alliance_num(), "undead_reinforcement_1")
ga_ai_undead_reinforcement_2 = gb:get_army(gb:get_non_player_alliance_num(), "undead_reinforcement_2")



gc = generated_cutscene:new(true, true)	-- is_debug=true, disable_outro_camera=true (unchanged since 0.010 - our final camera IS the intended end framing, so no extra CA outro camera should cut in after it)


gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 4500, false, false, false)

gc:add_element(nil, "hkrul_geimdall_lost_island_shot_2", "gc_slow_enemy_army_pan_front_left_to_front_right_far_high_01", 4500, false, false, false)


gc:add_element(nil, "hkrul_geimdall_lost_island_shot_3", "gc_slow_army_pan_front_left_to_front_right_far_high_01", 4500, false, false, false)


gc:add_element(nil, "hkrul_geimdall_lost_island_shot_4", "gc_medium_commander_front_medium_medium_to_close_low_01", 4000, false, false, false)


gc:add_element(nil, "hkrul_geimdall_lost_island_shot_5", "gc_orbit_90_medium_commander_front_close_low_01", 3500, false, false, false)


gc:add_element(nil, "hkrul_geimdall_lost_island_shot_6", "qb_final_position_short", 3500, false, true, false)

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

ga_ulfric_reinforcement:reinforce_on_message("ulfric_arrives", 0)
ga_ulfric_reinforcement:get_army():suppress_reinforcement_adc(1)

ga_ai_undead_reinforcement_1:reinforce_on_message("undead_reinforce", 0)
ga_ai_undead_reinforcement_1:get_army():suppress_reinforcement_adc(1)

ga_ai_undead_reinforcement_2:reinforce_on_message("undead_reinforce", 0)
ga_ai_undead_reinforcement_2:get_army():suppress_reinforcement_adc(1)

-------------------------------------------------------------------------------------------------
----------------------------------------- BATTLE SETUP ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("start", 100)
gb:message_on_time_offset("objective_01", 200)
gb:message_on_time_offset("hint_01", 2700)
gb:message_on_time_offset("ulfric_arrives", 8000, "undead_wounded")
gb:message_on_time_offset("undead_reinforce", 5000, "undead_reinforce_started")
gb:message_on_time_offset("undead_rush", 120000, "start")

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------


ga_ai_undead_main:set_visible_to_all(true)

ga_ai_undead_main:halt()
ga_ai_undead_main:rush_on_message("undead_rush")

ga_ai_undead_main:message_on_casualties("undead_wounded", 0.25)
ga_ai_undead_main:message_on_casualties("undead_reinforce_started", 0.5)
ga_ai_undead_main:message_on_casualties("undead_main_defeated", 0.95)

ga_ai_undead_reinforcement_1:deploy_at_random_intervals_on_message(
	"undead_reinforce", 		-- message
	1, 					-- min units
	1, 					-- max units
	3000, 					-- min period
	3000, 					-- max period
	nil,					-- cancel message
	nil,					-- spawn first wave immediately
	false,					-- allow respawning
	nil,					-- survival battle wave index
	nil,					-- is final survival wave
	false					-- show debug output
)
ga_ai_undead_reinforcement_1:message_on_any_deployed("undead_reinforcements_01_in")
ga_ai_undead_reinforcement_1:set_always_visible_on_message("undead_reinforcements_01_in", false, true)
ga_ai_undead_reinforcement_1:rush_on_message("undead_reinforcements_01_in")
ga_ai_undead_reinforcement_1:message_on_casualties("undead_reinforcements_01_defeated", 0.95)

ga_ai_undead_reinforcement_2:deploy_at_random_intervals_on_message(
	"undead_reinforce",
	1,
	1,
	3000,
	3000,
	nil,
	nil,
	false,
	nil,
	nil,
	false
)
ga_ai_undead_reinforcement_2:message_on_any_deployed("undead_reinforcements_02_in")
ga_ai_undead_reinforcement_2:set_always_visible_on_message("undead_reinforcements_02_in", false, true)
ga_ai_undead_reinforcement_2:rush_on_message("undead_reinforcements_02_in")
ga_ai_undead_reinforcement_2:message_on_casualties("undead_reinforcements_02_defeated", 0.95)

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_all_messages_received("undead_reinforcements_defeated", "undead_reinforcements_01_defeated", "undead_reinforcements_02_defeated")

gb:set_objective_with_leader_on_message("objective_01", "hkrul_geimdall_lost_island_objective_1")
gb:complete_objective_on_message("undead_main_defeated", "hkrul_geimdall_lost_island_objective_1", 2500)

gb:set_locatable_objective_callback_on_message(
	"start",
	"hkrul_geimdall_lost_island_objective_2",
	0,
	function()
		local sunit = ga_player.sunits:get_general_sunit()
		if sunit then
			local cam_targ = sunit.unit:position()
			local cam_pos = v_offset_by_bearing(
				cam_targ,
				get_bearing(cam_targ, bm:camera():position()),
				75,
				d_to_r(30)
			)
			return cam_pos, cam_targ
		end
	end,
	2
)
gb:fail_objective_on_message("geimdall_dead_or_shattered", "hkrul_geimdall_lost_island_objective_2", 2500)
gb:complete_objective_on_message("player_wins", "hkrul_geimdall_lost_island_objective_2", 2500)


gb:set_objective_with_leader_on_message("start", "hkrul_geimdall_lost_island_objective_3")
gb:complete_objective_on_message("ulfric_arrives", "hkrul_geimdall_lost_island_objective_3", 2500)

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("hint_01", "hkrul_geimdall_lost_island_hint_1")
gb:queue_help_on_message("undead_wounded", "hkrul_geimdall_lost_island_hint_2")
gb:queue_help_on_message("undead_reinforce_started", "hkrul_geimdall_lost_island_hint_3")
gb:queue_help_on_message("undead_main_defeated", "hkrul_geimdall_lost_island_hint_4")


gb:queue_help_on_message("ulfric_arrives", "hkrul_geimdall_lost_island_hint_5")

-------------------------------------------------------------------------------------------------
--------------------------------------------- DEFEAT -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player:message_on_commander_dead_or_shattered("geimdall_dead_or_shattered")
ga_ai_undead_main:force_victory_on_message("geimdall_dead_or_shattered", 5000)

-------------------------------------------------------------------------------------------------
------------------------------------------- VICTORY ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_all_messages_received("player_wins", "undead_main_defeated", "undead_reinforcements_defeated")
ga_player:force_victory_on_message("player_wins", 5000)
