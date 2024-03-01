local sargath_faction = "wh3_dlc20_nor_yusak"


local function rhox_diktat_button_visibility()
    local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "script_hider_parent", "panel") 
    if parent_ui then
        local diktat_panel = find_child_uicomponent(parent_ui, "frame_devotees")
        if diktat_panel then
            diktat_panel:SetVisible(true)
        end
    end
end

local function rhox_sargath_set_diktat_listeners()
        
    --- Trigger check for visibility when settlement is selected
    core:add_listener(
        "rhox_sargath_diktat_trigger",
        "SettlementSelected",
        true,
        function(context)
            core:get_tm():real_callback(function()
                rhox_diktat_button_visibility()
            end, 1)
                
            
        end,
        true
    )
    
    core:add_listener(
        "rhox_sargath_performed_slave_diktats",
        "ComponentLClickUp",
        function(context)
            return string.find(context.string, "wh3_main_ritual_sla_pleasure_")
        end,
        function()
            core:get_tm():real_callback(function()
                rhox_diktat_button_visibility()
            end, 100)
        end,
        true
    )


    --- Trigger whenever vampire coven slot is pressed
    core:add_listener(
        "rhox_sargath_diktat_click_trigger_1",
        "ComponentLClickUp",
        function (context)
            return context.string == "button_expand_slot"
        end,
        function()
            core:get_tm():real_callback(function()
                rhox_diktat_button_visibility()
            end, 100)
        end,
        true
    )


    --- Trigger whenever vampire coven slot is pressed
    core:add_listener(
        "rhox_sargath_diktat_click_trigger_2",
        "ComponentLClickUp",
        function (context)
            return context.string == "square_building_button"
        end,
        function()
            core:get_tm():real_callback(function()
                rhox_diktat_button_visibility()
            end, 100)
        end,
        true
    )
    
    core:add_listener(
        "rhox_sargath_diktat_click_trigger_3",
        "ComponentLClickUp",
        function (context)
            return context.string == "button_raze"
        end,
        function()
            core:get_tm():real_callback(function()
                rhox_diktat_button_visibility()
            end, 100)
        end,
        true
    )
end

local function rhox_sargath_god_bar_ui()
    local norsca_gods_frame = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar", "norsca_favour", "norsca_gods_frame")
    if not norsca_gods_frame then
        return
    end
    norsca_gods_frame:SetImagePath("ui/skins/default/nor_gods_bg_sargath.png")
    for i = 0, norsca_gods_frame:ChildCount() - 1 do
        local current_list = UIComponent(norsca_gods_frame:Find(i))
        if not current_list then
            return
        end
        local current_id = current_list:Id()
        if current_id == "list_eagle" or current_id == "list_hound" or current_id == "list_crow" then
            for j = 0, current_list:ChildCount() - 1 do
                local current_tier = UIComponent(current_list:Find(j))
                if not current_tier then
                    return
                end
                current_tier:SetVisible(false)
            end
        end		
    end
    

end



cm:add_first_tick_callback(
	function()
		if cm:get_local_faction_name(true) == sargath_faction then
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            local result = core:get_or_create_component("rhox_sargath_devotee_holder", "ui/campaign ui/rhox_sargath_devotee_holder.twui.xml", parent_ui)
            rhox_sargath_set_diktat_listeners()
            
            
            core:add_listener(
                "rhox_sargath_disable_vanilla_occupation_options",
                "PanelOpenedCampaign",
                function(context)
                    return context.string == "settlement_captured"
                end,
                function(context)
                    local panel = find_uicomponent(core:get_ui_root(), "settlement_captured")
                    local kill = find_uicomponent(panel, "1292694896")
                    local maim = find_uicomponent(panel, "1369123792")
                    local burn = find_uicomponent(panel, "1963655228")
                            
                    if kill then 
                        kill:SetVisible(false)
                    end
                    if maim then
                        maim:SetVisible(false)
                    end
                    if burn then
                        burn:SetVisible(false)
                    end  
                end,
                true
            )
            


            rhox_sargath_god_bar_ui()
            
            

            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management");
            local result = UIComponent(parent_ui:CreateComponent("rhox_valbrand_chaos_gift", "ui/campaign ui/rhox_sargath_chaos_gift_button.twui.xml"))
            
            
            core:add_listener(
                "rhox_sargath_panel_open_button_leftclick",
                "ComponentLClickUp",
                function (context)
                    return context.string == "rhox_sargath_chaos_gift"
                end,
                function ()
                    
                    local panel = core:get_or_create_component("rhox_sargath_chaos_gift_panel", "ui/campaign ui/rhox_sargath_chaos_gift_panel.twui.xml", core:get_ui_root())
                end,
                true
            )
            
            
            core:add_listener(
                "rhox_sargath_panel_close_button_leftclick",
                "ComponentLClickUp",
                function (context)
                    return context.string == "rhox_sargath_button_ok"
                end,
                function ()
                    local panel = find_uicomponent(core:get_ui_root(), "rhox_sargath_chaos_gift_panel")
                    if panel then
                        panel:Destroy()
                    end
                end,
                true
            )
        end
	end
)
	