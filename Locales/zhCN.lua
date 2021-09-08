local addonName, Addon = ...

local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "zhCN")

if not L then return end

L["save"] = "左键点击将当前启用插件保存到当前插件加载方案\n右键点击重新设置当前插件加载方案"
L["save_as"] = "将当前启用插件另存为一个新的插件加载方案"
L["delete"] = "删除当前插件加载方案"
L["tips"] = "当前启用插件与当前插件加载方案不一致！\n双击按钮可加载当前选中方案"
L["remark"] = "为插件添加备注"
L["save_as_input_dialog_title"] = "另存为"
L["save_input_dialog_title"] = "重新设定"
L["remark_input_dialog_title"] = "添加备注（按回车确定）"
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

L["cmd_help_reset"] = "/imapl reset：重置角色配置"
L["cmd_help_reset_all"] = "/impal reset all：重置通用配置"
L["cmd_help_switch_configuration"] = "/impal switch 配置名：切换通用配置"
L["cmd_help_switch_char_configuration"] = "/impal switch 配置名：切换角色配置"

L["save_to_global"] = "所有角色通用"
L["save_to_global_tips"] = "新建的插件加载方案默认属于当前角色，勾选按钮后会使其对所有角色可见"
L["show_static_pop"] = "弹窗提示"
L["show_static_pop_tips"] = "默认情况下，满足加载条件时会在右下角显示提示窗，如果勾选此选项，则会显示系统提示弹窗，并且会显著提高此项方案的优先级"
L["load_condition_title"] = "载入条件"
L["load_condition_tips"] = "此插件并不能自动切换方案\n而是用较醒目的方式提示您切换"
L["input_configuration_name"] ="输入配置名："
L["configuration_switch_text"] = "检测到当前场景下更适合的插件加载方案\n|cff00ff00%s|r\n是否切换？"
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