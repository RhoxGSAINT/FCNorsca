

load_script_libraries()

gb = generated_battle:new(
	false,                                      		-- screen starts black (0.010: false - see NOTE above)
	false,                                      		-- prevent deployment for player
	true,                                      			-- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
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

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Intro: a camera-only CindyScene composed around Geimdall where he stands in the deployed army


-- .ktr trigger id -> scripted_subtitles key
local intro_speech = {
	{"hkrul_geimdall_intro_line_01", "hkrul_geimdall_lost_island_cindy_01"},	-- Look upon them, Huscarls! Dead men dragged from the sea to bar our path.
	{"hkrul_geimdall_intro_line_02", "hkrul_geimdall_lost_island_cindy_02"},	-- They think this island theirs because they died upon it.
	{"hkrul_geimdall_intro_line_03", "hkrul_geimdall_lost_island_cindy_03"},	-- Let the dead remember what living men can do.
	{"hkrul_geimdall_intro_line_04", "hkrul_geimdall_lost_island_cindy_04"},	-- Lock shields. Ready your axes.
	{"hkrul_geimdall_intro_line_05", "hkrul_geimdall_lost_island_cindy_05"}	-- Today, we take this island - or heap it high with their bones!
}

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called")

	local cam = bm:camera()
	cam:fade(true, 0)

	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro",													-- unique string name for cutscene
		ga_player.sunits,													-- unitcontroller over player's army
		function() intro_cutscene_end() end,								-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/hkrul_geimdall_lost_island_intro.CindySceneManager",	-- path to cindyscene
		0,																	-- blend in time (s)
		0																	-- blend out time (s)
	)

	local player_units_hidden = false;

	local subtitles = cutscene_intro:subtitles()
	subtitles:set_alignment("bottom_centre")
	subtitles:clear()

	cutscene_intro:set_skippable(
		true,
		function()
			local cam = bm:camera()
			cam:fade(true, 0)
			bm:stop_cindy_playback(true)

			if player_units_hidden then
				ga_player:set_enabled(true)
			end;

			bm:callback(function() cam:fade(false, 0.5) end, 500)
			bm:hide_subtitles()
		end
	)

	cutscene_intro:action(function() cam:fade(false, 1) end, 1000)

	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_player:set_enabled(true)
		end,
		200
	)

	-- Geimdall's speech: "<trigger id>" shows the line, "<trigger id>_hide" clears it
	for i = 1, #intro_speech do
		local trigger_id = intro_speech[i][1]
		local subtitle_key = intro_speech[i][2]

		cutscene_intro:add_cinematic_trigger_listener(
			trigger_id,
			function()
				bm:show_subtitle(subtitle_key, false, true)
			end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			trigger_id .. "_hide",
			function()
				bm:hide_subtitles()
			end
		)
	end

	cutscene_intro:start()
end

function intro_cutscene_end()
	bm:hide_subtitles()
	ga_player:set_enabled(true)
end

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
