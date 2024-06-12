if not get_mct then return end
local mct = get_mct()
local mct_mod = mct:register_mod("scm_totn")
mct_mod:set_title("mct_scm_totn", true)
mct_mod:set_author("SCM")
mct_mod:set_description("mct_scm_totn_description", true)

local add_to_ll_pool = mct_mod:add_new_option("add_to_ll_pool", "checkbox")
add_to_ll_pool:set_default_value(true)
add_to_ll_pool:set_text("mct_scm_totn_add_to_ll_pool_text", true)
add_to_ll_pool:set_tooltip_text("mct_scm_totn_add_to_ll_pool_tooltip", true)


