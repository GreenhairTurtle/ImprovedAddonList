local AddonName, Addon = ...

-- 插件初始启用状态
local AddonInfoInitialStates = {}
for i = 1, GetNumAddOns() do
    local name, title, notes, loadable, reason, security = GetAddOnInfo(i)
    local enabled = GetAddOnEnableState(UnitName("player"), i) > 0
    AddonInfoInitialStates[name] = { Enabled = enabled, Expired = (reason == "INTERFACE_VERSION") }
end

-- 更新插件初始启用状态
function Addon:UpdateAddonInitialEnableState(addonName, enabled)
    AddonInfoInitialStates[addonName].Enabled = enabled
end

-- 应当一直被启用的插件，默认只有此插件
local ShouldAlwaysEnabledAddons = {
    [AddonName] = true
}
-- 插件是否应当被一直启用
function Addon:IsAddonShouldEnableAlways(addonName)
    return ShouldAlwaysEnabledAddons[addonName]
end

-- 插件是否被收藏
function Addon:IsAddonFavorite(name)
    if type(name) ~= "string" then return end
    return self.Saved.FavoriteAddons[name]
end

-- 设置插件收藏状态
function Addon:SetAddonFavorite(name, favorite)
    self.Saved.FavoriteAddons[name] = favorite
end

-- 插件备注
function Addon:GetAddonRemark(name)
    if type(name) ~= "string" then return end
    return self.Saved.AddonRemarks[name]
end

-- 设置插件备注
function Addon:SetAddonRemark(name, remark)
    if type(name) ~= "string" then return end
    self.Saved.AddonRemarks[name] = remark
end

-- 获取插件信息，返回值可能为nil
-- query:要么为index:与GetNumAddOns对应的插件位置；要么为name：插件名
function Addon:GetAddonInfoOrNil(query)
    if not query then return end
    if type(query) ~= "string" and type(query) ~= "number" then return end

    local name, title, notes, loadable, reason, security = GetAddOnInfo(query)
    if reason == "MISSING" then
        return
    end
    
    local addonInfo = {}
    
    if type(query) == "number" then
        addonInfo.Index = query
    end

    addonInfo.Name = name
    addonInfo.Title = title
    addonInfo.Notes = notes
    addonInfo.Author = GetAddOnMetadata(query, "Author")
    addonInfo.Version = GetAddOnMetadata(query, "Version")
    -- 是否可加载（或已加载）
    addonInfo.Loadable = loadable
    -- 是否已加载
    addonInfo.Loaded = IsAddOnLoaded(query)
    -- 是否按需加载
    addonInfo.LoadOnDemand = IsAddOnLoadOnDemand(query)
    -- 是否启用
    addonInfo.Enabled = GetAddOnEnableState(UnitName("player"), query) > 0
    -- 初始启用状态
    addonInfo.InitialEnabled = AddonInfoInitialStates[name].Enabled
    -- 初始过期状态
    addonInfo.InitialExpired = AddonInfoInitialStates[name].Expired
    -- 不可加载原因
    addonInfo.UnloadableReason = not loadable and reason and _G["ADDON_" .. reason] or ""
    -- 可能值：不安全，安全，非法
    addonInfo.Security = security
    -- 插件依赖
    addonInfo.Deps = { GetAddOnDependencies(query) }
    -- 可选依赖
    addonInfo.OptionalDeps = { GetAddOnOptionalDependencies(query) }
    -- 备注
    addonInfo.Remark = self:GetAddonRemark(name)
    -- 是否收藏
    addonInfo.IsFavorite = self:IsAddonFavorite(name)

    return addonInfo
end

-- 获取插件信息，返回值不为nil
function Addon:GetAddonInfo(query)
    local info = self:GetAddonInfoOrNil(query)
    if not info then error("You cannot get a unexists addon's info by " .. query) end

    return info
end

-- 根据插件名获取插件信息，可能为nil
-- @param update:是否先刷新，再获取
function Addon:GetAddonInfoByNameOrNil(name, update)
    if update then
        self:UpdateAddonInfoByName(name)
    end

    if not self.AddonInfos then return end

    local addonIndex = self.AddonInfos[name]
    if not addonIndex then return end

    return self.AddonInfos[addonIndex]
end

-- 根据插件名获取插件信息，返回值不为nil
function Addon:GetAddonInfoByName(name, update)
    local addonInfo = self:GetAddonInfoByNameOrNil(name, update)
    if not addonInfo then error("You cannot get a unexists addon's info by " .. name) end

    return addonInfo
end

-- 根据插件index获取插件信息，可能为nil
-- @param update:是否先刷新，再获取
function Addon:GetAddonInfoByIndexOrNil(index, update)
    if update then
        self:UpdateAddonInfoByIndex(index)
    end

    if not self.AddonInfos then return end

    return self.AddonInfos[index]
end

-- 根据插件index获取插件信息，返回值不为nil
function Addon:GetAddonInfoByIndex(index, update)
    local addonInfo = self:GetAddonInfoByIndexOrNil(index, update)
    if not addonInfo then error("You cannot get a unexists addon's info by " .. index) end

    return addonInfo
end

-- 根据插件index更新插件信息
-- 返回对应插件信息
function Addon:UpdateAddonInfoByIndex(index)
    local addonInfo = self:GetAddonInfo(index)
    self.AddonInfos = self.AddonInfos or {}
    -- 按插件index存储
    self.AddonInfos[index] = addonInfo
    -- 插件名和index映射
    self.AddonInfos[addonInfo.Name] = index

    return addonInfo
end

-- 根据插件名更新插件信息
function Addon:UpdateAddonInfoByName(name)
    self.AddonInfos = self.AddonInfos or {}
    local addonIndex = self.AddonInfos[name]
    
    -- 获取不到插件索引，就没有必要存了
    if not addonIndex then return end

    return self:UpdateAddonInfoByIndex(addonIndex)
end

-- 获取插件信息
-- @param query:如果为nil，则更新所有插件信息吗，否则只更新指定插件信息
function Addon:UpdateAddonInfos(query)
    if query then
        if type(query) == "number" then
            self:UpdateAddonInfoByIndex(query)
        elseif type(query) == "string" then
            self:UpdateAddonInfoByName(query)
        end
    else
        if self.AddonInfos then wipe(self.AddonInfos) end
        
        local addonLoaded = 0
        local addonEnabled = 0
        for i = 1, GetNumAddOns() do
            local addonInfo = self:UpdateAddonInfoByIndex(i)
            if addonInfo then
                if addonInfo.Loaded then
                    addonLoaded = addonLoaded + 1
                end

                if addonInfo.Enabled then
                    addonEnabled = addonEnabled + 1
                end
            end
        end

        -- 已加载数量
        self.AddonInfos.LoadedNumber = addonLoaded
        -- 已启用数量
        self.AddonInfos.EnabledNumber = addonEnabled
    end
end

-- 获取所有插件信息
function Addon:GetAddonInfos()
    return self.AddonInfos
end

-- 获取插件列表数据提供者
function Addon:GetAddonDataProvider()
    local dataProvider = CreateLinearizedTreeListDataProvider()
    local node = dataProvider:GetRootNode()
    local addonInfos = self:GetAddonInfos()
    for _, addonInfo in ipairs(addonInfos) do
        node:Insert({ AddonInfo = addonInfo })
    end

    return dataProvider
end

-- 插件是否可以按需加载
function Addon:CanAddonLoadOnDemand(query)
    local addonInfo = self:GetAddonInfo(query)
    
    if not addonInfo.Enabled or not addonInfo.LoadOnDemand or addonInfo.Loaded then return false end

    for _, dep in pairs(addonInfo.Deps) do
        if dep and not IsAddOnLoaded(dep) then
            return false
        end
    end

    return true
end

-- 启用所有插件
function Addon:EnableAllAddons()
    EnableAllAddOns()
end

-- 禁用所有插件
function Addon:DisableAllAddons()
    local addonInfos = self:GetAddonInfos()
    for _, addonInfo in ipairs(addonInfos) do
        if self:IsAddonShouldEnableAlways(addonInfo.Name) then
            EnableAddOn(addonInfo.Name)
        else
            DisableAddOn(addonInfo.Name)
        end
    end
end

-- 所有插件是否都已启用
function Addon:IsAllAddonsEnabled()
    local addonInfos = self:GetAddonInfos()
    for _, addonInfo in ipairs(addonInfos) do
        if not addonInfo.Enabled then
            return false
        end
    end

    return true
end

-- 所有插件是否都已禁用
function Addon:IsAllAddonsDisabled()
    local addonInfos = self:GetAddonInfos()
    for _, addonInfo in ipairs(addonInfos) do
        if not self:IsAddonShouldEnableAlways(addonInfo.Name) and addonInfo.Enabled then
            return false
        end
    end

    return true
end

-- 插件排序

-- 按索引排序
Addon.SORT_BY_INDEX = 0
-- 按名称排序
Addon.SORT_BY_NAME = 1

-- 升序
Addon.ORDER_ASCENDING = 0
-- 降序
Addon.ORDER_DESCENDING = 1


-- 插件分组

-- 不分组
Addon.GROUP_BY_NONE = 0
-- 按名字分组
Addon.GROUP_BY_NAME = 1
-- 按依赖分组
Addon.GROUP_BY_DEP = 2
-- 按作者分组
Addon.GROUP_BY_AUTHOR = 3