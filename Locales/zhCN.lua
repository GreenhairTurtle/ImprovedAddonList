local addonName, Addon = ...

local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "zhCN")

if not L then return end

L["save"] = "左键点击将当前启用插件保存到当前插件加载方案\n右键点击重新设置当前插件加载方案"
L["save_as"] = "将当前启用插件另存为一个新的插件加载方案"
L["delete"] = "删除当前插件加载方案"
L["tips"] = "当前启用插件与当前插件加载方案不一致！\n双击按钮可加载当前选中方案"
L["remark"] = "为插件添加备注"
L["export"] = "导出当前插件列表\n\n导出内容含有NGA论坛格式代码，可直接在论坛发送。"
L["save_as_input_dialog_title"] = "另存为"
L["save_input_dialog_title"] = "重新设定"
L["remark_input_dialog_title"] = "添加备注（按回车确定）"
L["export_title"] = "导出插件列表"
L["error_input_empty"] = "你不能创建一个无名的插件加载方案！"
L["error_input_distinct"] = "已有同名的插件加载方案！"
L["error_must_save_to_global"] = "你必须勾选所有角色通用选项，因你选择了部分当前角色无法满足的条件"
L["disable_me_tips"] = "你保存的插件加载方案中没有本插件！"
L["max_configuration_num_limit"] = "你最多只能拥有%d个插件加载方案"
L["delete_confirm"] = "确定删除插件加载方案\n|cff00ff00%s|r"
L["remark_confirm"] = "确定为插件|cff00ff00%s|r添加备注：\n|cffffd200%s|r"
L["remark_delete_confirm"] = "确定删除插件|cff00ff00%s|r的备注？"
L["save_error"] = "当前没有选中任意插件加载方案"
L["save_success"] = "保存成功"
L["reset_error"] = "当前没有选中任意插件加载方案"
L["delete_error"] = "当前没有选中任意插件加载方案"
L["unselect_configuration"] = "取消选择"
L["version"] = "版本：%s"
L["author"] = "作者：%s"
L["credit"] = "鸣谢：%s"
L["website"] = "发布页：%s"
L["dependencies"] = "依赖项：%s"
L["addon_tooltip_remark"] = "备注：%s"
L["addon_list"] = "插件列表"
L["enabled_addons"] = "已启用插件列表"
L["disabled_addons"] = "未启用插件列表"
L["addon_name"] = "插件名：%s"

L["cmd_help_reset"] = "/imapl reset：重置角色配置"
L["cmd_help_reset_all"] = "/impal reset all：重置通用配置"
L["cmd_help_switch_configuration"] = "/impal switch 配置名：切换通用配置"
L["cmd_help_switch_char_configuration"] = "/impal switch 配置名：切换角色配置"

L["save_to_global"] = "所有角色通用"
L["save_to_global_tips"] = "新建的插件加载方案默认属于当前角色，勾选按钮后会使其对所有角色可见"
L["show_static_pop"] = "弹窗提示"
L["show_static_pop_tips"] = "默认情况下，满足加载条件时会在右下角显示提示窗，如果勾选此选项，则会显示系统提示弹窗，并且会显著提高此项方案的优先级"
L["auto_dismiss"] = "自动消失"
L["auto_dismiss_tooltip"] = "默认情况下，系统提示弹窗会在一段时间后自动消失，取消勾选此选项，则提示窗将一直显示直到手动取消。"
L["load_condition_title"] = "载入条件"
L["load_condition_tips"] = "此插件并不能自动切换方案\n而是用较醒目的方式提示您切换"
L["input_configuration_name"] ="输入配置名："
L["configuration_switch_text"] = "检测到当前场景下更适合的插件加载方案\n|cff00ff00%s|r\n是否切换？"
L["configuration_active_reset"] = "当前插件加载方案|cff00ff00%s|r和当前启用插件没有完全匹配，是否启用？"
L["configuration_switch_prompt_dialog_title"] = "切换插件"
L["configuration_switch_prompt_dialog_item_tooltip"] = "点击更换此插件加载方案"

L["condition_check_button_tooltip"] = "点击可以切换单选、多选和不选，不选情况下默认为全部启用！"
L["condition_player_name_label"] = "角色-服务器"
L["condition_instance_type_label"] = "场景类型"
L["condition_class_and_spec_label"] = "职业和专精"
L["instance_type_none"] = "野外"
L["instance_type_pvp"] = "战场"
L["instance_type_arena"] = "竞技场"
L["instance_type_party"] = "地下城"
L["instance_type_raid"] = "团队副本"
L["instance_type_scenario"] = "场景战役"

L["true"] = "是"
L["false"] = "否"

L["addon_set"] = "插件集"
L["settings_tips"] = "设置"
L["enable_all_tips"] = "启用所有插件"
L["disable_all_tips"] = "禁用所有插件"
L["addon_set_op_tips"] = "将当前启用的插件列表加入/移出插件集"
L["reset_tips"] = "重置"
L["lock_tips"] = "已锁定"
L["cannot_unlock_tips"] = "该插件无法被解除锁定"
L["edit_remark_error_too_long"] = "备注过长"
L["edit_remark_error_name_duplicate"] = "与插件“%s”名称重复"
L["edit_remark_error_title_duplicate"] = "与插件“%s”标题重复"
L["edit_remark_error_remark_duplicate"] = "与插件“%s”备注重复"
L["reload_ui_tips_title"] = "需要重载的插件"

L["settings_dynamic_edit_box_delete_tips"] = "删除"

L["settings_group_load_indicator"] = "插件加载指示器"
L["settings_load_indicator_display_mode"] = "显示方式"
L["settings_load_indicator_display_mode_tooltip"] = "部分插件名称附带颜色（比如：DBM），这影响了插件加载染色的可读性，此选项用于配置加载指示器的显示方式。"
L["settings_load_indicator_dislay_invisble"] = "不显示"
L["settings_load_indicator_dislay_invisble_tooltip"] = "不显示插件指示器，同时移除插件名称附带的颜色"
L["settings_load_indicator_display_only_colorful"] = "仅对彩色插件名显示"
L["settings_load_indicator_display_only_colorful_tooltip"] = "仅对名称附带颜色的插件显示"
L["settings_Load_indicator_display_always"] = "总是显示"
L["settings_Load_indicator_display_always_tooltip"] = "所有插件都显示加载指示器，无论其名称是否附带颜色"
L["settings_load_indicator_color_reload"] = "重载颜色"
L["settings_load_indicator_color_reload_description"] = "需重载的插件的色值"
L["settings_load_indicator_color_unloaded"] = "未加载颜色"
L["settings_load_indicator_color_unloaded_description"] = "未加载的插件的色值"
L["settings_load_indicator_color_unloadable"] = "无法加载颜色"
L["settings_load_indicator_color_unloadable_description"] = "无法加载的插件的色值"
L["settings_load_indicator_color_loaded"] = "已加载颜色"
L["settings_load_indicator_color_loaded_description"] = "已加载的插件的色值"
L["settings_load_indicator_color_disabled"] = "未启用颜色"
L["settings_load_indicator_color_disabled_description"] = "未启用的插件的色值"

L["addon_detail_basic_info"] = "基本信息"
L["addon_detail_name"] = "名称："
L["addon_detail_title"] = "标题："
L["addon_detail_remark"] = "备注："
L["addon_detail_notes"] = "说明："
L["addon_detail_author"] = "作者："
L["addon_detail_version"] = "版本："
L["addon_detail_dep_info"] = "依赖信息"
L["addon_detail_dependencies"] = "依赖项："
L["addon_detail_optional_deps"] = "可选依赖："
L["addon_detail_status_info"] = "状态信息"
L["addon_detail_load_status"] = "加载状态："
L["addon_detail_unload_reason"] = "未加载原因："
L["addon_detail_enable_status"] = "启用状态："
L["addon_detail_load_on_demand"] = "按需加载："
L["addon_detail_memory_usage"] = "内存占用："
L["addon_detail_no_dependency"] = "此插件不依赖任何插件"
L["addon_detail_in_addon_set"] = "在插件集内："
L["addon_detail_does_not_in_addon_set"] = "否"
L["addon_detail_loaded"] = "已加载"
L["addon_detail_unload"] = "未加载"
L["addon_detail_enabled"] = "已启用"
L["addon_detail_disabled"] = "未启用"
L["addon_detail_version_debug"] = "调试版本"
L["addon_detail_lock_tips_title"] = "插件锁定"
L["addon_detail_lock_tips"] = "插件会保持现在的启用状态，其将无法被启用或禁用。\n启用全部、禁用全部及应用插件集时，会将其忽略，除非解除锁定。\n\n如果你在角色选择界面将该插件启用或禁用，则启用状态会以你设置的为准。"
L["addon_detail_unlock_tips"] = "解除锁定"
L["addon_detail_addon_set_op_tips"] = "加入/移出插件集"

L["addon_set_active_label"] = "当前插件集"
L["addon_set_inactive_tip"] = "未选择插件集"
L["addon_set_list"] = "插件集列表"
L["addon_set_clear_tips"] = "停止使用插件集"
L["addon_set_apply_tips"] = "应用当前选中插件集“%s”"
L["addon_set_apply_alert"] = "插件集“%s”已启用"
L["addon_set_apply_later"] = "稍后"
L["addon_set_apply_error_unsave"] = "插件集“%s”有未保存的改动，请保存后再应用"
L["addon_set_add_tips"] = "添加插件集"
L["addon_set_remove_tips"] = "删除当前选中插件集“%s”"
L["addon_set_new"] = "新建插件集"
L["addon_set_new_label"] = "插件集是一个或多个插件的组合，请为其取名，并确保其名称唯一。"
L["addon_set_name_error_too_long"] = "插件集名称过长"
L["addon_set_name_error_duplicate"] = "插件集名称重复"
L["addon_set_delete_confirm"] = "确认删除插件集\n%s"
L["addon_set_addon_switch"] = "加入/移出插件集"
L["addon_set_save_addon_list_tips"] = "保存当前选中插件到“%s”"
L["addon_set_replace_addons_tips"] = "将当前已启用的插件加入到插件集“%s”，未启用的插件会被移出。"
L["addon_set_enable_all_tips"] = "将所有插件加入“%s”"
L["addon_set_disable_all_tips"] = "将所有插件移出“%s”"
L["addon_set_can_not_find"] = "未找到名为“%s”的插件集"
L["addon_set_not_full_load_tips"] = "插件集“%s”未完全启用，点击完全启用此插件集。\n\n该操作不会禁用目前已启用但不属于当前插件集的插件，也不会修改被锁定的插件的启用状态，无论其是否属于当前插件集"
L["addon_set_addon_list"] = "插件列表"

L["addon_set_choice_enable_all_tips"] = "选择所有插件集"
L["addon_set_choice_disable_all_tips"] = "取消选择所有插件集"
L["addon_set_choice_merge_tips"] = "合并到所选插件集"
L["addon_set_choice_replace_tips"] = "替换所选插件集"
L["addon_set_choice_delete_tips"] = "从所选插件集中删除"

L["addon_set_settings_group_basic"] = "基础信息"
L["addon_set_settings_name"] = "名称"
L["addon_set_settings_enabled"] = "启用"
L["addon_set_settings_enabled_tooltip"] = "启用或禁用插件集决定其是否参与载入条件检查"
L["addon_set_settings_group_load_condition"] = "载入条件"
L["addon_set_settings_condition_name_and_realm"] = "玩家名称/服务器"
L["addon_set_settings_condition_name_and_realm_any"] = "(*)任何"
L["addon_set_settings_condition_name_and_realm_tooltip"] = "角色名：%s\n服务器：%s"
L["addon_set_settings_condition_name_and_realm_tips"] = "过滤格式：“名称”，“名称-服务器”，“-服务器”，可以使用“\\”转义“-”"
L["addon_set_settings_condition_name_and_realm_error_too_much_dash"] = "%s内含有过多的“-”，你可能需要使用\\转义"
L["addon_set_settings_condition_name_and_realm_error_duplicate"] = "已存在相同的角色名称/服务器过滤格式：%s"
L["addon_set_settings_condition_name_and_realm_error_empty"] = "未获取到有效的角色名或服务器"
L["addon_set_settings_condition_warmode"] = "战争模式"
L["addon_set_settings_condition_warmode_tips"] = "选择是否在战争模式下载入插件集"
L["addon_set_settings_condition_warmode_none"] = "无"
L["addon_set_settings_condition_warmode_enabled"] = "开启"
L["addon_set_settings_condition_warmode_disabled"] = "关闭"
L["addon_set_settings_condition_warmode_choice_none"] = "不参与条件检查"
L["addon_set_settings_condition_warmode_choice_enabled"] = "开启战争模式时"
L["addon_set_settings_condition_warmode_choice_disabled"] = "关闭战争模式时"
L["addon_set_settings_condition_faction"] = "玩家阵营"
L["addon_set_settings_condition_faction_tips"] = "选择载入插件集时的阵营"
L["addon_set_settings_condition_faction_none"] = "无"
L["addon_set_settings_condition_faction_choice_none"] = "不参与条件检查"

L["load_addon"] = "加载此插件"
L["enable_addon"] = "启用插件"
L["disable_addon"] = "禁用插件"
L["edit_remark"] = "编辑备注"
L["enable_switch"] = "启用/禁用插件"