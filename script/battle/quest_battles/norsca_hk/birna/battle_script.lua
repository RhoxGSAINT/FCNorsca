load_script_libraries();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                     			-- prevent deployment for player
	false,                                     			-- prevent deployment for ai
	nil, 												-- intro cutscene function
	false                                      			-- debug mode
);

-------ARMY SETUP-------

ga_boartusk_1 = gb:get_army(gb:get_non_player_alliance_num(),"boartusk_army");
ga_boartusk_boss = gb:get_army(gb:get_non_player_alliance_num(),"boartusk_army_boss");
ga_boartusk_rein_1 = gb:get_army(gb:get_non_player_alliance_num(),"boartusk_rein_1");
ga_boartusk_rein_2 = gb:get_army(gb:get_non_player_alliance_num(),"boartusk_rein_2");

-------ORDERS-------
gb:message_on_time_offset("dragon_attack", 5000);
ga_boartusk_boss:move_to_position(v(165,272,164));
gb:message_on_time_offset("dragon_boss_attack", 60000);
gb:message_on_time_offset("rein_hint", 60000);
gb:message_on_time_offset("rein_arrive", 120000);
ga_boartusk_1:attack_on_message("dragon_attack");
ga_boartusk_boss:attack_on_message("dragon_boss_attack");
ga_boartusk_rein_1:reinforce_on_message("rein_arrive", 1000);
ga_boartusk_rein_2:reinforce_on_message("rein_arrive", 1000);
ga_boartusk_rein_1:message_on_deployed("rein1_attack");
ga_boartusk_rein_2:message_on_deployed("rein2_attack");
ga_boartusk_rein_1:attack_on_message("rein1_attack");
ga_boartusk_rein_2:attack_on_message("rein2_attack");

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "hkrul_sarl_birna_bogtusk_final_battle_objective");

-------HINTS------------
gb:queue_help_on_message("battle_started", "hkrul_sarl_birna_bogtusk_final_battle_ai_hint_objective");
gb:queue_help_on_message("rein_hint", "hkrul_sarl_birna_bogtusk_final_battle_reinforcements_hint");
gb:queue_help_on_message("rein1_attack", "hkrul_sarl_birna_bogtusk_final_battle_reinforcements_arrive");
gb:queue_help_on_message("dragon_boss_attack", "hkrul_sarl_birna_bogtusk_final_battle_reinforcements_hurt");


--------ADVICE----------
gb:get_army(gb:get_player_alliance_num(), 1):message_on_victory("player_wins");
gb:advice_on_message("player_wins", "wh2.battle.advice.final_battle_victory.002");
