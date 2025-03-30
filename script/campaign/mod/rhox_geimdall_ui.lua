
local geimdall_faction ="mixer_nor_geimdall_huscarls"



cm:add_first_tick_callback(
    function()
        if cm:get_local_faction_name(true) == geimdall_faction then   

        
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            local result = core:get_or_create_component("rhox_geimdall_winter_button", "ui/campaign ui/rhox_geimdall_button_frame.twui.xml", parent_ui)
            result:SetContextObject(cco("CcoCampaignFaction", geimdall_faction))
            result:SetVisible(true)
            local result2 = core:get_or_create_component("rhox_geimdall_devotion_holder", "ui/campaign ui/rhox_geimdall_devotion_holder.twui.xml", parent_ui)
            
            
            
            core:add_listener(
                "rhox_geimdall_disable_occupation_options",
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
            core:add_listener(
                'rhox_totn_geimdall_clicked_winter_button',
                'ComponentLClickUp',
                function(context)
                    return context.string == "winter_button" 
                    
                end,
                function(context)
                    local panel = core:get_or_create_component("rhox_geimdall_winter_panel", "ui/campaign ui/kislev_winter.twui.xml", core:get_ui_root())
                    local supporter = find_uicomponent(panel, "devotion_action_holder", "dy_supporters")
                    if supporter then
                        supporter:SetVisible(true)
                    end
                    
                    local final_threshold = find_uicomponent(panel, "devotion_bar", "devotion_follower_icon")
                    if final_threshold then
                        final_threshold:SetContextObject(cco("CcoCampaignGroupRecord", "rhox_geimdall_bundle_ksl_followers_5"))
                    end
                end,
                true
            )
            
            core:add_listener(
                'rhox_totn_geimdall_clicked_winter_panel_close_button',
                'ComponentLClickUp',
                function(context)
                    return context.string == "button_minimise" 
                    
                end,
                function(context)
                    local panel = find_uicomponent(core:get_ui_root(), "rhox_geimdall_winter_panel")
                    if panel then
                        panel:Destroy()
                    end
                    
                end,
                true
            )
            
            local norsca_gods_frame = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar", "norsca_favour")
            if norsca_gods_frame then
                norsca_gods_frame:SetVisible(false)
            end
            
   
        end
    end
)





