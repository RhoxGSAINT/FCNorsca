load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
    false,                                      -- screen starts black
    false,                                      -- prevent deployment for player
    true,                                          -- prevent deployment for ai
    function() gb:start_generated_cutscene(gc) end,     -- intro cutscene function
    false                                          -- debug mode
);
--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, play taunt)
gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_east_extreme_high_02", 8000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_90_medium_commander_back_right_close_low_01", 8000, true, false, true);
gc:add_element(nil, nil, "gc_slow_absolute_high_pass_statues_01_to_absolute_high_pass_statues_02", 4000, true, false, false);
gc:add_element(nil, nil, nil, 4000, true, false, false);
gc:add_element(nil, nil, "gc_medium_army_pan_front_right_to_front_left_far_high_01", 6000, true, false, false);



------------------------------------------------------
--------------------- ARMY SETUP ---------------------
------------------------------------------------------

ga_player_01   = gb:get_army(gb:get_player_alliance_num(), 1); -- Einarr
ga_player_ally = gb:get_army(gb:get_player_alliance_num(), "ga_player_ally"); -- Asta
ga_ai_01       = gb:get_army(gb:get_non_player_alliance_num(), "ga_ai_01"); -- Aesling


------------------------------------------------------
-------------------- OBJECTIVES ----------------------
------------------------------------------------------

-- Hint on battle start (e.g. "The snow is red again...")
gb:queue_help_on_message("battle_started", "hkrul_einarr_nightmare_hint_intro");

-- Trigger next phase after 20s
gb:message_on_time_offset("save_the_wife", 20000);
gb:queue_help_on_message("save_the_wife", "hkrul_einarr_nightmare_hint_save_her");

-- Advisor + objective when dream intensifies
gb:set_objective_on_message("save_the_wife", "wh_main_qb_objective_attack_defeat_army");
------------------------------------------------------
--------------------- AI ORDERS ----------------------
------------------------------------------------------

ga_player_ally:defend_on_message("battle_started", -88, 40, 40); 
ga_player_ally:message_on_commander_death("asta_dead", 1);
ga_ai_01:attack_on_message("battle_started");
ga_ai_01:message_on_casualties("enemy_hurt",0.5);
------------------------------------------------------
------------------ VICTORY LOGIC ---------------------
------------------------------------------------------

-- Enemy rout detection
gb:queue_help_on_message("asta_dead", "asta_dead_hint", 4000, nil, 1000);
gb:queue_help_on_message("enemy_hurt", "enemy_hurt_hint");

-- Complete objective
gb:remove_objective_on_message("enemy_defeated", "wh_main_qb_objective_attack_defeat_army");
gb:complete_objective_on_message("enemy_defeated", "wh_main_qb_objective_attack_defeat_army");