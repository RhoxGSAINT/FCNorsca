RHOX_BJORNLING_FISHING_GUYS={
}


local bjornling_faction ="wh_main_nor_bjornling"

function rhox_fc_norsca_find_and_turn_on_raid_icon()
    local parent_ui = find_uicomponent(core:get_ui_root(), "3d_ui_parent");
    if not parent_ui then
        return
    end
    for key,value in pairs(RHOX_BJORNLING_FISHING_GUYS) do
        if value then
            local character_tag = find_uicomponent(parent_ui, "label_".. tostring(key))
            if character_tag then
                local raid_holder = find_uicomponent(character_tag, "raid_holder")
                if raid_holder then
                    raid_holder:SetVisible(true)
                    local result =core:get_or_create_component("rhox_bjornling_fishing_value_holder", "ui/campaign ui/rhox_bjornling_army_stance_resource_holder.twui.xml", raid_holder)
                    result:SetContextObject(cco("CcoCampaignCharacter", tostring(key)))
                end
            end
        end
    end
end


cm:add_first_tick_callback(
    function()
        if cm:get_local_faction_name(true) == bjornling_faction then
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            local result = core:get_or_create_component("rhox_bjornling_winter_button", "ui/campaign ui/rhox_bjornling_button_frame.twui.xml", parent_ui)
            result:SetContextObject(cco("CcoCampaignFaction", bjornling_faction))
            local result2 = core:get_or_create_component("rhox_bjornling_devotion_holder", "ui/campaign ui/rhox_bjornling_devotion_holder.twui.xml", parent_ui)
            local result3 = core:get_or_create_component("rhox_bjornling_ritual_button", "ui/campaign ui/rhox_bjornling_fish_ritual_button.twui.xml", parent_ui)
            result3:SetContextObject(cco("CcoCampaignFaction", bjornling_faction))
            local result4 = core:get_or_create_component("rhox_bjornling_resource_holder", "ui/campaign ui/rhox_bjornling_fish_resource_holder.twui.xml", parent_ui)
            rhox_fc_norsca_find_and_turn_on_raid_icon()
            core:add_listener(
                "rhox_bjornling_disable_occupation_options",
                "PanelOpenedCampaign",
                function(context)
                    return context.string == "settlement_captured"
                end,
                function(context)
                    local panel = find_uicomponent(core:get_ui_root(), "settlement_captured")
					if not panel then
						return
					end
                    local kill = find_uicomponent(panel, "1963655228")
                    local maim = find_uicomponent(panel, "1369123792")
                    local burn = find_uicomponent(panel, "1824195232")
                    local shovel = find_uicomponent(panel, "1292694896")
                            
                    if kill then 
                        kill:SetVisible(false)
                    end
                    if maim then
                        maim:SetVisible(false)
                    end
                    if burn then
                        burn:SetVisible(false)
                    end  
                    if shovel then
                        shovel:SetVisible(false)
                    end  
                end,
                true
            )
            
            local norsca_gods_frame = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar", "norsca_favour")
            if norsca_gods_frame then
                norsca_gods_frame:SetVisible(false)
            end
            
            
            --[[
            core:remove_listener("rhox_bjornling_fish_listener")
            core:add_listener(
                "rhox_bjornling_fish_listener",
                "RealTimeTrigger",
                function(context)
                    return context.string == "rhox_bjornling_fishing_real_time"
                end,
                function()
                    rhox_nagash_setup_settlement_label()    
                end,
                true
            )
            real_timer.unregister("rhox_bjornling_fishing_real_time")
            real_timer.register_repeating("rhox_bjornling_fishing_real_time", 1000)
            --]]
        end
    end
)





core:add_listener(
    "rhox_bjornling_show_resource",
    "ForceAdoptsStance",
    function(context)
        local faction = context:military_force():faction()
        
        return faction:is_human() and faction:name() == bjornling_faction
    end,
    function(context)
        local mf = context:military_force()
        local character = mf:general_character()
        if mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_DOUBLE_TIME" then
            common.set_context_value("rhox_bjornling_fish_value_" .. mf:command_queue_index(), 10)
            RHOX_BJORNLING_FISHING_GUYS[character:command_queue_index()]=true
        else
            common.set_context_value("rhox_bjornling_fish_value_" .. mf:command_queue_index(), 0)
            RHOX_BJORNLING_FISHING_GUYS[character:command_queue_index()]=false
        end
        if cm:get_local_faction_name(true) == bjornling_faction then
            rhox_fc_norsca_find_and_turn_on_raid_icon()
        end
    end,
    true
)


----save/load

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("RHOX_BJORNLING_FISHING_GUYS", RHOX_BJORNLING_FISHING_GUYS, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			RHOX_BJORNLING_FISHING_GUYS = cm:load_named_value("RHOX_BJORNLING_FISHING_GUYS", RHOX_BJORNLING_FISHING_GUYS, context)
		end
	end
)


