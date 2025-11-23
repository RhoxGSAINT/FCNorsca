local nonchaos_factions = {
	mixer_nor_eyristaad  = true
}
cm:add_first_tick_callback(
    function()
        if nonchaos_factions[cm:get_local_faction_name(true)] then   
            core:add_listener(
                "rhox_nonchaos_disable_occupation_options",
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
        end
    end
)