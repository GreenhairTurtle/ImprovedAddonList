local AddonName, Addon = ...

-- 待实现需求：
-- 一：插件分组
--   1. 支持创建/编辑分组，设置分组名称、权重
--   2. 支持编辑分组规则，允许以一定规则将插件自行放入分组
-- 二：插件方案
--   1. 支持创建/编辑插件方案，设置方案名称和加载规则
--   2. 支持添加/删除插件到插件方案中
-- 三：插件历史记录
--   1. 保存插件加载历史记录，按插件列表变化保存
-- 四：lua错误获取及保存
-- 五：导出插件列表
-- 六：导出配置字符串

local function OnInitialize()
    ImprovedAddonListSaved = ImprovedAddonListSaved or {}
    local saved = ImprovedAddonListSaved
    Addon.Saved = saved

    -- 插件偏好
    saved.FavoriteAddons = saved.FavoriteAddons or {}
    -- 锁定的插件
    saved.LockedAddons = saved.LockedAddons or {}
    -- 插件分组
    saved.AddonCategories = saved.AddonCategories or {}
    -- 插件备注
    saved.AddonRemarks = saved.AddonRemarks or {}
    -- 插件方案列表
    saved.AddonSchemes = saved.AddonSchemes or {}

    -- 配置
    saved.Config = saved.Config or {}

    -- 更新插件信息
    Addon:UpdateAddonInfos()
end

Addon:RegisterEvent("PLAYER_LOGIN", OnInitialize)