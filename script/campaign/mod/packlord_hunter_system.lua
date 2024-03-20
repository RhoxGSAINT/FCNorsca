local hunting_trait_info = require("script/packlord_hunter/hunting_trait_info")

-- set this to false if you want more log stuff
local is_this_test_run = false


local function hunting_trait_system()


	local function check_for_hunting_traits(character, enemy_is_defending)
		local prefix = "packlord_hunter_trait_"
		
		for i = 1, #packlord_hunting_traits do
			local current_trait = packlord_hunting_traits[i]
			local trait_unit_list = packlord_hunting_trait_info[current_trait]
				
			if trait_unit_list ~= nil and #trait_unit_list ~= 0 then
				for j = 1, #packlord_hunting_trait_info[current_trait] do
					local trait_unit = packlord_hunting_trait_info[current_trait][j]
					if enemy_is_defending == true then
						if cm:pending_battle_cache_unit_key_exists_in_defenders(trait_unit) then	
							for k, initiative_set in model_pairs(character:character_details():character_initiative_sets()) do
								if not initiative_set:lookup_initiative_by_key(prefix..current_trait):is_null_interface() then
									if initiative_set:lookup_initiative_by_key(prefix..current_trait):is_script_locked() == true then
										cm:toggle_initiative_script_locked(initiative_set, prefix..current_trait, false)
										cm:toggle_initiative_active(initiative_set, prefix..current_trait, true)
									end
								end
							end	
						else

						end
					else
						if cm:pending_battle_cache_unit_key_exists_in_attackers(trait_unit) then
							for k, initiative_set in model_pairs(character:character_details():character_initiative_sets()) do
								if not initiative_set:lookup_initiative_by_key(prefix..current_trait):is_null_interface() then
									if initiative_set:lookup_initiative_by_key(prefix..current_trait):is_script_locked() == true then
										cm:toggle_initiative_script_locked(initiative_set, prefix..current_trait, false)
										cm:toggle_initiative_active(initiative_set, prefix..current_trait, true)
									end
								end
							end
						end
					end
				end
			end
		end
	end


	core:add_listener(
		"packlord_hunter_CharacterCompletedBattle",
		"CharacterCompletedBattle",
		function(context)
			local character = context:character()
			return cm:model():pending_battle():has_been_fought() and character:character_subtype("nor_skin_wolf_lord") and character:won_battle()
		end,
		function(context)			
			local character = context:character()		
			if character:won_battle() then		
				if character == context:pending_battle():attacker() then
					check_for_hunting_traits(character, true)
				else
					check_for_hunting_traits(character, false)
				end
			end
		end,
		true
	)	

	core:add_listener(
		"packlord_hunter_CharacterCompletedBattle",
		"CharacterParticipatedAsSecondaryGeneralInBattle",
		function(context)
			local character = context:character()
			return cm:model():pending_battle():has_been_fought() and character:character_subtype("nor_skin_wolf_lord") and character:won_battle()
		end,
		function(context)		
			local character = context:character()		
			if character:won_battle() then		
				local pb = cm:model():pending_battle()
				local attackers = pb:secondary_attackers()
				local was_attacker = false
				
				for i = 0, attackers:num_items() - 1 do
					local attacker = attackers:item_at(i)				
					if character == attacker then
						was_attacker = true
					end
				end
				
				if was_attacker == true then
					check_for_hunting_traits(character, true)
				else	
					check_for_hunting_traits(character, false)
				end					
			end
		end,
		true
	)	
    
    	core:add_listener(
		"scm_norsca_huern_CharacterCompletedBattle",
		"CharacterCompletedBattle",
		function(context)
			local character = context:character()
			return cm:model():pending_battle():has_been_fought() and character:character_subtype("scm_norsca_huern") and character:won_battle()
		end,
		function(context)					
			local character = context:character()		
			if character:won_battle() then		
				if character == context:pending_battle():attacker() then	
					check_for_hunting_traits(character, true)
				else
					check_for_hunting_traits(character, false)
				end
			end
		end,
		true
	)	

	core:add_listener(
		"scm_norsca_huern_CharacterCompletedBattle",
		"CharacterParticipatedAsSecondaryGeneralInBattle",
		function(context)
			local character = context:character()
			return cm:model():pending_battle():has_been_fought() and character:character_subtype("scm_norsca_huern") and character:won_battle()
		end,
		function(context)				
			local character = context:character()		
			if character:won_battle() then		
				local pb = cm:model():pending_battle()
				local attackers = pb:secondary_attackers()
				local was_attacker = false
				
				for i = 0, attackers:num_items() - 1 do
					local attacker = attackers:item_at(i)				
					if character == attacker then
						was_attacker = true
					end
				end
				
				if was_attacker == true then
					check_for_hunting_traits(character, true)
				else
					check_for_hunting_traits(character, false)
				end					
			end
		end,
		true
	)	
end


local function init()
    local character_context_parent = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent")
	local character = character_context_parent:GetContextObject("CcoCampaignCharacter")
	local character_cqi = character:Call("CQI")
	local AgentSubtypeRecordContext = character:Call("AgentSubtypeRecordContext")
	local subtype = AgentSubtypeRecordContext:Call("Key")

	if subtype == "nor_skin_wolf_lord" or subtype == "scm_norsca_huern" then
		local big_names_holder = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "tab_panels", "character_initiatives_holder", "big_names_holder")
		local killed = core:get_or_create_component("new_killed", "ui/templates/listview.twui.xml", big_names_holder)
		local list_box = find_uicomponent(big_names_holder, "list_clip", "list_box")
		local killed_list_box = find_uicomponent(killed, "list_clip", "list_box")

		local prefix = "CcoCampaignInitiative"..tostring(character_cqi).."packlord_hunter_traitspacklord_hunter_trait_"

		local character_interface = cm:get_character_by_cqi(character_cqi)		
		for i = 1, #packlord_hunting_traits do  
			local current_trait = find_uicomponent(list_box, prefix..packlord_hunting_traits[i])
			if current_trait then
				killed_list_box:Adopt(current_trait:Address())

				local set = character_interface:character_details():lookup_character_initiative_set_by_key("packlord_hunter_traits")
				if not set:is_null_interface() then 
					local active_traits = set:active_initiatives()
					if active_traits:num_items() > 0 then
						for j = 0, active_traits:num_items() - 1 do
							local trait_key = active_traits:item_at(j):record_key()
							if trait_key == "packlord_hunter_trait_"..packlord_hunting_traits[i] then
								local tx_requirements = find_uicomponent(current_trait, "tx_requirements")
								current_trait:SetState("active")
								tx_requirements:SetState("unlocked")
							end
						end
					end
				end		
			end
		end

		-- set the bounds and position to match the Bloodline panel
		local x, y = big_names_holder:Position()
		local w, h = big_names_holder:Dimensions()

		killed:SetCanResizeWidth(true) killed:SetCanResizeHeight(true)
		killed:Resize(w -150, h -35)
		killed:SetCanResizeWidth(false) killed:SetCanResizeHeight(false)

		killed:SetDockingPoint(1)
		list_box:SetVisible(false)
	end
end

local function scroll_bars_for_the_hunter()
	core:add_listener(
		"packlord_hunter_character_details_panel_opened_wh_dlc08_nor_naglfarlings",
		"PanelOpenedCampaign",
		function(context) 
			return context.string == "character_details_panel" and cm:get_local_faction_subculture(true) == "wh_dlc08_sc_nor_norsca"
		end,
		function(context)
			local character_initiatives = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "TabGroup", "character_initiatives")
			core:add_listener(
				"packlord_hunter_register_character_initiatives_button",
				"ComponentLClickUp",
				function(context)
					return character_initiatives == UIComponent(context.component)
				end,
				function()
					cm:callback(function()			
						init()
					end, 0.1)					
				end,
				true
			)		
		end,
		true
	)
end


cm:add_first_tick_callback(function()
	hunting_trait_system()
	scroll_bars_for_the_hunter()
end)