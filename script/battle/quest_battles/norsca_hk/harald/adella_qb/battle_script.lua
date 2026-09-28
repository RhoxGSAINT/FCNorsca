
load_script_libraries();

bm = battle_manager:new(empire_battle:new());

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                       -- prevent deployment for ai
	nil,                                        -- intro cutscene function (none in 0.001)
	false                                       -- debug mode
);

print("[ADELLA_QB_0001] script loaded successfully");
print("[ADELLA_QB_0005] 0.005 phase 3 (Adella reveal) layer loaded.");

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);            -- Harald Whyrlas / Graeling Host (ambushed defender)
ga_ai_skeggi_host = gb:get_army(gb:get_non_player_alliance_num(), 1);   -- Initial Skeggi Host (native ambush force)


ga_ai_force2 = gb:get_army(gb:get_non_player_alliance_num(), "second_skeggi_host");
ga_ai_force2:get_army():suppress_reinforcement_adc(1);


ga_ai_adella = gb:get_army(gb:get_non_player_alliance_num(), "adella_host");
ga_ai_adella:get_army():suppress_reinforcement_adc(1);

local MONOLITH_UNIT_KEY = "hkrul_skeggi_giant_ror";
local monolith_sunit = nil;


function adella_qb_get_monolith_sunit()
	if monolith_sunit then
		return monolith_sunit;
	end;

	local found = ga_ai_force2.sunits:get_sunit_by_type(MONOLITH_UNIT_KEY);

	if found then
		monolith_sunit = found;
		print("[ADELLA_QB_0004] Fishbrain's Monolith resolved by unit type " .. MONOLITH_UNIT_KEY);
	else
		print("[ADELLA_QB_0004] WARNING: could not resolve a script unit of type " .. MONOLITH_UNIT_KEY .. " in the Second Skeggi Host.");
	end;

	return monolith_sunit;
end;


local adella_sunit = nil;

function adella_qb_get_adella_sunit()
	if adella_sunit then
		return adella_sunit;
	end;

	local found = ga_ai_adella.sunits:get_general_sunit();

	if found and is_scriptunit(found) then
		adella_sunit = found;
		print("[ADELLA_QB_0005] Adella commander script unit resolved via get_general_sunit().");
	else
		print("[ADELLA_QB_0005] WARNING: could not resolve a commanding script unit in Adella's host.");
	end;

	return adella_sunit;
end;

-------OBJECTIVES-------

gb:set_objective_on_message("battle_started", "hkrul_adella_qb_0004_phase1_objective");


gb:complete_objective_on_message("adella_qb_0004_force1_broken", "hkrul_adella_qb_0004_phase1_objective", 2500);



-------HINTS-------

gb:queue_help_on_message("adella_qb_0001_march_ended", "hkrul_adella_qb_0003_hint_betrayal");

-- Hint 1 lands with the reinforcement itself; hint 2 (plus the objective) ~10s later.
gb:queue_help_on_message("adella_qb_0004_phase2_reveal", "hkrul_adella_qb_0004_hint_beasts");
gb:queue_help_on_message("adella_qb_0004_monolith_reveal", "hkrul_adella_qb_0004_hint_monolith");

-- 0.005: the final hint fires only once the cutscene has ended and control is back with the player.
gb:queue_help_on_message("adella_qb_0005_control_restored", "hkrul_adella_qb_0005_hint_adella");

-------ORDERS-------

-- The native ambush force receives no other script order; its reveal is engine-driven by battle_type="ambush".
ga_ai_skeggi_host:attack_on_message("adella_qb_0001_march_ended");
print("[ADELLA_QB_0001] Initial Skeggi Host attack_on_message registered against adella_qb_0001_march_ended");

-- 0.004: Phase 2 transition -- 6s pause after the Initial Skeggi Host is broken (75% casualties).
gb:message_on_time_offset("adella_qb_0004_phase2_reveal", 6000, "adella_qb_0004_force1_broken");


gb:message_on_time_offset("adella_qb_0004_monolith_reveal", 10000, "adella_qb_0004_phase2_reveal");


-- matching Kemmler's ga_ai_02:reinforce_on_message("summon_wave_01", 0)).
ga_ai_force2:reinforce_on_message("adella_qb_0004_phase2_reveal", 0);
ga_ai_force2:attack_on_message("adella_qb_0004_phase2_reveal", 10000);

-------PHASE 2 OBJECTIVE: SLAY THE FISHBRAIN'S MONOLITH-------

gb:set_locatable_objective_callback_on_message(
	"adella_qb_0004_monolith_reveal",
	"hkrul_adella_qb_0004_phase2_objective",
	0,
	function()
		local sunit = adella_qb_get_monolith_sunit();
		if sunit then
			local cam_targ = sunit.unit:position();
			local cam_pos = v_offset_by_bearing(
				cam_targ,
				get_bearing(cam_targ, bm:camera():position()),		-- horizontal bearing from camera target to current camera position
				100,												-- distance from camera position to camera target
				d_to_r(30)											-- vertical bearing from horizon to cam-targ/cam-pos line
			);
			return cam_pos, cam_targ;
		end;
	end,
	2
);


gb:add_listener(
	"adella_qb_0004_phase2_reveal",
	function()
		local sunit = adella_qb_get_monolith_sunit();

		if not sunit then
			print("[ADELLA_QB_0004] ERROR: Monolith death watch NOT armed -- script unit could not be resolved.");
			return;
		end;

		local monolith_seen_on_field = false;

		bm:watch(
			function()
				if not monolith_seen_on_field then
					if sunit.unit:is_valid_target() then
						monolith_seen_on_field = true;
						print("[ADELLA_QB_0004] Fishbrain's Monolith is on the battlefield -- death watch is now live.");
					end;
					return false;
				end;

				return sunit.unit:number_of_men_alive() < 1;
			end,
			0,
			function()
				print("[ADELLA_QB_0004] Fishbrain's Monolith is DEAD. Firing adella_qb_0004_monolith_slain.");
				gb:message_on_time_offset("adella_qb_0004_monolith_slain", 100, true);
			end,
			"adella_qb_0004_monolith_death_watch"
		);

		print("[ADELLA_QB_0004] Monolith death watch armed.");
	end,
	true
);

-------VICTORY / DEFEAT-------

ga_ai_skeggi_host:message_on_casualties("adella_qb_0004_force1_broken", 0.75);


gb:complete_objective_on_message("adella_qb_0004_monolith_slain", "hkrul_adella_qb_0004_phase2_objective", 2500);

ga_player_01:message_on_commander_dead_or_shattered("adella_qb_0001_harald_dead_or_shattered");
ga_ai_skeggi_host:force_victory_on_message("adella_qb_0001_harald_dead_or_shattered", 5000);

-------NATIVE AMBUSH DIAGNOSTICS-------
local cam = bm:camera();
local ambush_poll_count = 0;
local last_known_ambush_state = nil;

gb:add_listener(
	"battle_started",
	function()
		cam:allow_user_to_skip_ambush_intro(true);
		cam:teleport_defender_when_ambush_intro_skipped(true);

		local initial_state = cam:is_ambush_controller_executing();
		last_known_ambush_state = initial_state;
		print("[ADELLA_QB_0001] battle_started fired. is_ambush_controller_executing() = " .. tostring(initial_state));

		gb:message_on_time_offset("adella_qb_0001_ambush_poll", 500, true);
	end,
	true
);

gb:add_listener(
	"adella_qb_0001_ambush_poll",
	function()
		local current_state = cam:is_ambush_controller_executing();
		ambush_poll_count = ambush_poll_count + 1;

		if current_state ~= last_known_ambush_state then
			print("[ADELLA_QB_0001] ambush controller state changed to " .. tostring(current_state) .. " (poll #" .. tostring(ambush_poll_count) .. ")");
			last_known_ambush_state = current_state;
		end;

		if not current_state then
			print("[ADELLA_QB_0001] ambush controller no longer executing -- native march/ambush concluded at poll #" .. tostring(ambush_poll_count) .. ". Firing adella_qb_0001_march_ended.");
			gb:remove_listener("adella_qb_0001_ambush_poll");
			gb:message_on_time_offset("adella_qb_0001_march_ended", 100, true);
		else
			gb:message_on_time_offset("adella_qb_0001_ambush_poll", 500, true);
		end;
	end,
	true
);

gb:add_listener(
	"adella_qb_0001_march_ended",
	function()
		print("[ADELLA_QB_0001] adella_qb_0001_march_ended message received successfully.");
	end,
	true
);

gb:add_listener(
	"adella_qb_0004_phase2_reveal",
	function()
		print("[ADELLA_QB_0004] adella_qb_0004_phase2_reveal received. Second Skeggi Host reinforcing.");
	end,
	true
);

gb:add_listener(
	"adella_qb_0004_monolith_reveal",
	function()
		print("[ADELLA_QB_0004] adella_qb_0004_monolith_reveal received. Monolith hint and objective going up.");
	end,
	true
);

-------------------------------------------------------------------------------------------------
------------------------------- 0.005 PHASE 3: ADELLA OF THE THOUSAND MOUTHS ----------------------
-------------------------------------------------------------------------------------------------

ga_ai_adella:reinforce_on_message("adella_qb_0004_monolith_slain", 0);


gb:message_on_time_offset("adella_qb_0005_hold_1", 1500, "adella_qb_0004_monolith_slain");
gb:message_on_time_offset("adella_qb_0005_hold_2", 4200, "adella_qb_0004_monolith_slain");

gb:add_listener(
	"adella_qb_0005_hold_1",
	function()
		ga_ai_adella:halt();
		print("[ADELLA_QB_0005] Adella's host halted (hold 1).");
	end,
	true
);

gb:add_listener(
	"adella_qb_0005_hold_2",
	function()
		ga_ai_adella:halt();
		print("[ADELLA_QB_0005] Adella's host halted (hold 2 -- re-asserted during the cutscene).");
	end,
	true
);

gb:message_on_time_offset("adella_qb_0005_cutscene_start", 4000, "adella_qb_0004_monolith_slain");

gb:add_listener(
	"adella_qb_0004_monolith_slain",
	function()
		print("[ADELLA_QB_0005] Fishbrain phase complete. Adella's host reinforcing (silent). False-victory delay started (4000ms).");
		if ga_ai_adella then
			print("[ADELLA_QB_0005] Adella army handle resolved: " .. tostring(ga_ai_adella:get_script_name()));
		else
			print("[ADELLA_QB_0005] ERROR: Adella army handle is nil.");
		end;
		adella_qb_get_adella_sunit();
	end,
	true
);

-------THE MID-BATTLE GENERATED CUTSCENE-------

gc_adella = generated_cutscene:new(true, true);


gc_adella:force_on_subtitles();

-- SHOT 1 -- the false victory. Ground-anchored wide orbit over the aftermath. No subtitle.
gc_adella:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 4500, false, false, false);

-- SHOT 2 -- the hidden host revealed. Enemy-army pan across Adella's elite force.
gc_adella:add_element(nil, "hkrul_adella_qb_0005_adella_line_01", "gc_slow_enemy_army_pan_front_left_to_front_right_far_high_01", 5000, false, false, false);

-- SHOT 3 -- Adella herself. Tight orbit on the commander.
gc_adella:add_element(nil, "hkrul_adella_qb_0005_adella_line_02", "gc_orbit_90_medium_commander_front_close_low_01", 5000, false, false, false);

gb:add_listener(
	"adella_qb_0005_cutscene_start",
	function()
		print("[ADELLA_QB_0005] False-victory delay elapsed. Adella phase trigger. Generated cutscene constructed with " .. tostring(#gc_adella.elements) .. " elements.");
		gb:start_generated_cutscene(gc_adella);
		print("[ADELLA_QB_0005] Generated cutscene started (mid-battle).");
	end,
	true
);

-------RETURN TO GAMEPLAY-------

--
-- A single-shot guard means the failsafe below can never double-fire the gameplay resumption.
local adella_control_restored = false;

function adella_qb_restore_control(reason)
	if adella_control_restored then
		return;
	end;

	adella_control_restored = true;
	print("[ADELLA_QB_0005] Cutscene ended (" .. tostring(reason) .. "). Control returned. Firing adella_qb_0005_control_restored.");
	gb:message_on_time_offset("adella_qb_0005_control_restored", 500, true);
end;

gb:add_listener(
	"generated_custscene_ended",
	function()
		adella_qb_restore_control("generated_custscene_ended received");
	end,
	true
);


gb:message_on_time_offset("adella_qb_0005_cutscene_failsafe", 22000, "adella_qb_0005_cutscene_start");

gb:add_listener(
	"adella_qb_0005_cutscene_failsafe",
	function()
		adella_qb_restore_control("FAILSAFE duration elapsed -- no generated_custscene_ended was seen");
	end,
	true
);

-- Adella's host is released only once gameplay has resumed.
ga_ai_adella:attack_on_message("adella_qb_0005_control_restored", 500);

gb:add_listener(
	"adella_qb_0005_control_restored",
	function()
		print("[ADELLA_QB_0005] Final hint fired. Final objective activating. Adella attack order released (+500ms).");
	end,
	true
);

-------PHASE 3 OBJECTIVE: SLAY ADELLA OF THE THOUSAND MOUTHS-------

gb:set_locatable_objective_callback_on_message(
	"adella_qb_0005_control_restored",
	"hkrul_adella_qb_0005_phase3_objective",
	0,
	function()
		local sunit = adella_qb_get_adella_sunit();
		if sunit then
			local cam_targ = sunit.unit:position();
			local cam_pos = v_offset_by_bearing(
				cam_targ,
				get_bearing(cam_targ, bm:camera():position()),
				75,
				d_to_r(30)
			);
			return cam_pos, cam_targ;
		end;
	end,
	2
);

-- ADELLA'S DEFEAT WATCH.

gb:add_listener(
	"adella_qb_0004_monolith_slain",
	function()
		local sunit = adella_qb_get_adella_sunit();

		if not sunit then
			print("[ADELLA_QB_0005] ERROR: Adella defeat watch NOT armed -- commander script unit could not be resolved.");
			return;
		end;

		print("[ADELLA_QB_0005] Adella character/commander handle resolved. Arming defeat watch.");

		local adella_seen_on_field = false;

		bm:watch(
			function()
				if not adella_seen_on_field then
					if sunit.unit:is_valid_target() then
						adella_seen_on_field = true;
						print("[ADELLA_QB_0005] Adella is on the battlefield -- defeat watch is now live.");
					end;
					return false;
				end;

				return sunit.unit:number_of_men_alive() < 1 or sunit.unit:is_shattered();
			end,
			0,
			function()
				if sunit.unit:number_of_men_alive() < 1 then
					print("[ADELLA_QB_0005] Adella is DEAD (number_of_men_alive < 1). Firing adella_qb_0005_adella_slain.");
				else
					print("[ADELLA_QB_0005] Adella is SHATTERED (not dead). Firing adella_qb_0005_adella_slain.");
				end;
				gb:message_on_time_offset("adella_qb_0005_adella_slain", 100, true);
			end,
			"adella_qb_0005_adella_defeat_watch"
		);

		print("[ADELLA_QB_0005] Adella defeat watch armed.");
	end,
	true
);

-------PHASE 3 VICTORY-------
-- Victory depends on Adella alone. Surviving Initial Skeggi Host remnants and surviving
-- Second Skeggi Host units are left exactly as they are -- nothing is deleted, despawned,
-- force-killed, or waited on.
gb:complete_objective_on_message("adella_qb_0005_adella_slain", "hkrul_adella_qb_0005_phase3_objective", 2500);
ga_player_01:force_victory_on_message("adella_qb_0005_adella_slain", 5000);

gb:add_listener(
	"adella_qb_0005_adella_slain",
	function()
		print("[ADELLA_QB_0005] Adella defeated. Final objective completing (+2500ms). Victory triggered (+5000ms).");
	end,
	true
);

-------HARALD MARCH SPEECH -------

local subtitles = bm:subtitles();
local harald_speech_index = 0;
local harald_speech_elements = {
	"hkrul_adella_qb_0002_speech_01",
	"hkrul_adella_qb_0002_speech_02",
	"hkrul_adella_qb_0002_speech_03",
	"hkrul_adella_qb_0002_speech_04",
	"hkrul_adella_qb_0002_speech_05",
	"hkrul_adella_qb_0003_speech_06",
};
local HARALD_SPEECH_LINE_DURATION_MS = 7000;
local HARALD_SPEECH_START_DELAY_MS = 2000;

gb:add_listener(
	"battle_started",
	function()
		print("[ADELLA_QB_0002] Harald march speech sequence armed.");
		gb:message_on_time_offset("adella_qb_0002_speech_update", HARALD_SPEECH_START_DELAY_MS, true);
	end,
	true
);

gb:add_listener(
	"adella_qb_0002_speech_update",
	function()
		if not cam:is_ambush_controller_executing() then
			print("[ADELLA_QB_0002] Ambush controller already ended -- ending speech early at line " .. tostring(harald_speech_index) .. " of " .. tostring(#harald_speech_elements));
			gb:remove_listener("adella_qb_0002_speech_update");
			subtitles:clear();
			return;
		end;

		if harald_speech_index >= #harald_speech_elements then
			print("[ADELLA_QB_0002] Harald speech sequence finished naturally after " .. tostring(#harald_speech_elements) .. " lines. Silence begins; native march continues.");
			gb:remove_listener("adella_qb_0002_speech_update");
			subtitles:clear();
			return;
		end;

		harald_speech_index = harald_speech_index + 1;
		local line_key = harald_speech_elements[harald_speech_index];
		print("[ADELLA_QB_0002] Displaying speech line " .. tostring(harald_speech_index) .. ": " .. line_key);
		subtitles:set_alignment("bottom_centre");
		subtitles:begin("bottom_centre");
		subtitles:set_text(line_key);

		gb:message_on_time_offset("adella_qb_0002_speech_update", HARALD_SPEECH_LINE_DURATION_MS, true);
	end,
	true
);
