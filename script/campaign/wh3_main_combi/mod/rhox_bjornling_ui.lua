local bjornling_faction ="wh_main_nor_bjornling"




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
        end
    end
)


