load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);
--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, play_taunt_at_start, message_on_start)
gc:add_element(nil, nil, "qb_louen_errantry_war_chaos_01", 6000, true, false, false);
gc:add_element("hkrul_adella__lustria_qb_pt_01","hkrul_adella__lustria_qb_pt_01", nil, 10000, true, false, false);
gc:add_element("hkrul_adella__lustria_qb_pt_02","hkrul_adella__lustria_qb_pt_01", "qb_louen_errantry_war_chaos_03", 6000, true, false, false);
gc:add_element("hkrul_adella__lustria_qb_pt_03","hkrul_adella__lustria_qb_pt_01", nil, 11000, true, true, false);
--gc:add_element(nil, nil, "qb_final_position", 3000, false, false, false);
gb:set_cutscene_during_deployment(true);



-------ARMY SETUP----------
ga_player_army = gb:get_army(gb:get_player_alliance_num(), 0, "");
ga_player_rein = gb:get_army(gb:get_player_alliance_num(), "hkrul_adella_qb_1_army_player_reinforcement");
ga_enemy_army = gb:get_army(gb:get_non_player_alliance_num(2),"hkrul_adella_qb_1_army_enemy");
ga_enemy_rein = gb:get_army(gb:get_non_player_alliance_num(2),"hkrul_adella_qb_1_army_enemy_reinforcement");

-------ORDERS----------
gb:message_on_time_offset("release", 30000,"01_intro_cutscene_end");
ga_player_rein:reinforce_on_message("release", 5000)
ga_player_rein:message_on_deployed("rein_attack", 1000);
ga_player_rein:rush_on_message("rein_attack");
gb:message_on_time_offset("enemy_army_attack", 10000);
ga_enemy_army:attack_on_message("enemy_army_attack");
ga_enemy_army:message_on_casualties("enemy_army_casulaties", 0.4);
ga_enemy_rein:reinforce_on_message("enemy_army_casulaties", 5000)
ga_enemy_rein:message_on_deployed("enemy_rein_arrived", 3000)
ga_enemy_rein:rush_on_message("enemy_rein_arrived");


-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "Hkrul_adella_player_objective");

-------HINTS------------
gb:queue_help_on_message("rein_attack", "Hkrul_player_ally_attack");
gb:queue_help_on_message("enemy_army_attack", "Hkrul_enemy_army_attack");
gb:queue_help_on_message("enemy_army_casulaties", "Hkrul_enemy_army_casulaties");
gb:queue_help_on_message("enemy_rein_arrived", "Hkrul_enemy_rein_arrived");

--------ADVICE----------
gb:get_army(gb:get_player_alliance_num(), 1):message_on_victory("player_wins");
gb:advice_on_message("player_wins", "wh2.battle.advice.final_battle_victory.002");