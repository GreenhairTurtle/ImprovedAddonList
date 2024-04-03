local addonName, Addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

-- 插件详情，组件
local ADDON_DETAILS = {
    {
        Name = "BasicInfo",
        Label = L["addon_detail_basic_info"],
        Details = {
            {
                Name = "Name",
                Label = L["addon_detail_name"]
            },
            {
                Name = "Title",
                Label = L["addon_detail_title"]
            },
            {
                Name = "Remark",
                Label = L["addon_detail_remark"],
                Color = LEGENDARY_ORANGE_COLOR
            },
            {
                Name = "Notes",
                Label = L["addon_detail_notes"]
            },
            {
                Name = "Author",
                Label = L["addon_detail_author"]
            },
            {
                Name = "Version",
                Label = L["addon_detail_version"]
            },
            {
                Name = "LoadOnDemand",
                Label = L["addon_detail_load_on_demand"]
            }
        }
    },
    {
        Name = "StatusInfo",
        Label = L["addon_detail_status_info"],
        Details = {
            {
                Name = "LoadStatus",
                Label = L["addon_detail_load_status"]
            },
            {
                Name = "UnloadReason",
                Label = L["addon_detail_unload_reason"],
                Color = RED_FONT_COLOR
            },
            {
                Name = "EnableStatus",
                Label = L["addon_detail_enable_status"]
            },
            {
                Name = "MemoryUsage",
                Label = L["addon_detail_memory_usage"]
            }
        }
    },
    {
        Name = "DepInfo",
        Label = L["addon_detail_dep_info"],
        Details = {
            {
                Name = "Dependencies",
                Label = L["addon_detail_dependencies"]
            },
            {
                Name = "OptionalDeps",
                Label = L["addon_detail_optional_deps"]
            }
        }
    }
}

-- 更新插件详情各框体的位置
function Addon:UpdateAddonDetailFramesPosition()
    local addonDetailFrame = self:GetAddonDetailScrollContainer()

    local categoryOffsetX, categoryOffsetY = 10, -10
    local addonDetailOffsetX, addonDetailFirstOffsetY, addonDetailOffsetY = 15, -10, -8

    local preFrame, usedHeight = nil, 0
    for categoryIndex, category in pairs(ADDON_DETAILS) do
        local categoryFrame = addonDetailFrame[category.Name]
        categoryFrame:ClearAllPoints()
        categoryFrame:SetPoint("TOPLEFT", categoryOffsetX, -usedHeight + categoryOffsetY)
        usedHeight = usedHeight + categoryFrame:GetHeight() - categoryOffsetY

        for detailIndex, detail in pairs(category.Details) do
            local detailLabel = addonDetailFrame[detail.Name .. "Label"]
            local detailBody = addonDetailFrame[detail.Name]
            local detailContent = detailBody:GetText() or ""
            if strlen(detailContent) <= 0 then
                detailLabel:SetShown(false)
                detailBody:SetShown(false)
            else
                detailLabel:SetShown(true)
                detailBody:SetShown(true)

                local detailHeight = math.max(detailLabel:GetStringHeight(), detailBody:GetStringHeight())
                local offsetY = detailIndex == 1 and addonDetailFirstOffsetY or addonDetailOffsetY
                detailLabel:SetPoint("TOPLEFT", addonDetailOffsetX, -usedHeight + offsetY)
                usedHeight = usedHeight + detailHeight - offsetY
            end
        end
    end

    -- 动态高度，方便滚动
    addonDetailFrame:SetHeight(usedHeight + 20)
    self:GetAddonDetailScrollBox():FullUpdate();
    self:GetAddonDetailScrollBox():ScrollToBegin(ScrollBoxConstants.NoScrollInterpolation)
end


local function CreateDetailButton(container)
    local button = CreateFrame("Button", nil, container)
    button:SetNormalFontObject(ImprovedAddonListButtonNormalFont)
    button:SetHighlightFontObject(ImprovedAddonListButtonHighlightFont)
    button:SetDisabledFontObject(ImprovedAddonListButtonDisabledFont)
    return button
end

local function onLoadButtonEnter(self)
    if self.tooltipText then
        GameTooltip:SetOwner(self)
        GameTooltip:AddLine(self.tooltipText, 1, 1, 1)
        GameTooltip:Show()
    end
end

local function onLoadButtonLeave(self)
    GameTooltip:Hide()
end

local function OnLoadButtonClick(self)
    local addonInfo = Addon:CurrentFocusAddonInfo()
    -- 加载按需加载的插件并修改其初始状态
    C_AddOns.LoadAddOn(addonInfo.Name)
    if C_AddOns.IsAddOnLoaded(addonInfo.Name) then
        Addon:UpdateAddonInitialEnableState(addonInfo.Name, true)
    end
    Addon:RefreshAddonInfo(addonInfo.Name)
end

-- 收藏按钮：鼠标划入
local function onFavoriteButtonEnter(self)
    if self.tooltipText then
        GameTooltip:SetOwner(self)
        GameTooltip:AddLine(self.tooltipText, 1, 1, 1)
        GameTooltip:Show()
    end
end

-- 收藏按钮：鼠标移出
local function onFavoriteButtonLeave(self)
    GameTooltip:Hide()
end

-- 收藏按钮：鼠标点击
local function onFavoriteButtonClick(self)
    local addonInfo = Addon:CurrentFocusAddonInfo()
    Addon:SetAddonFavorite(addonInfo.Name, not addonInfo.IsFavorite)
    PlaySound(SOUNDKIT.UI_PROFESSION_TRACK_RECIPE_CHECKBOX)
    Addon:RefreshAddonInfo(addonInfo.Name)

    if GameTooltip:IsOwned(self) then
        onFavoriteButtonEnter(self)
    end
end

-- 锁定按钮：鼠标划入
local function onLockButtonEnter(self)
    if self.tooltipText then
        GameTooltip:SetOwner(self)
        GameTooltip:AddLine(self.tooltipText, 1, 1, 1)
        GameTooltip:Show()
    end
end

-- 锁定按钮：鼠标移出
local function onLockButtonLeave(self)
    GameTooltip:Hide()
end

-- 锁定按钮：鼠标点击
local function onLockButtonClick(self)
    local addonInfo = Addon:CurrentFocusAddonInfo()
    if not addonInfo.Unlockable then return end

    Addon:SetAddonLock(addonInfo.Name, not addonInfo.IsLocked)
    PlaySound(SOUNDKIT.UI_PROFESSION_TRACK_RECIPE_CHECKBOX)
    Addon:RefreshAddonInfo(addonInfo.Name)

    if GameTooltip:IsOwned(self) then
        onLockButtonEnter(self)
    end
end

-- 编辑按钮：鼠标划入
local function onRemarkButtonEnter(self)
    GameTooltip:SetOwner(self)
    GameTooltip:AddLine(L["edit_remark"], 1, 1, 1)
    GameTooltip:Show()
end

-- 编辑按钮：鼠标移出
local function onRemarkButtonLeave(self)
    GameTooltip:Hide()
end

-- 编辑按钮：点击
local function onRemarkButtonClick(self)
    Addon:ShowEditRemarkDialog()
end

function Addon:OnAddonDetailContainerLoad()
    local AddonDetailContainer = self:GetAddonDetailContainer()
    -- 滚动框
    local AddonDetailScrollBox = CreateFrame("Frame", nil, AddonDetailContainer, "WowScrollBox")
    AddonDetailContainer.ScrollBox = AddonDetailScrollBox
    AddonDetailScrollBox:SetPoint("TOPLEFT", 5, -7)
    AddonDetailScrollBox:SetPoint("BOTTOMRIGHT", -5, 40)

    --插件详情框体
    local AddonDetailFrame = CreateFrame("Frame", nil, AddonDetailScrollBox)
    AddonDetailScrollBox.Container = AddonDetailFrame
    AddonDetailFrame.scrollable = true
    AddonDetailFrame:SetWidth(AddonDetailScrollBox:GetWidth())

    AddonDetailScrollBox:Init(CreateScrollBoxLinearView(1, 1, 1, 1))

    for _, category in pairs(ADDON_DETAILS) do
        local categoryFrame = AddonDetailFrame:CreateFontString(nil, nil, "GameFontNormal")
        AddonDetailFrame[category.Name] = categoryFrame
        categoryFrame:SetText(category.Label)

        for _, detail in pairs(category.Details) do
            local detailLabel = AddonDetailFrame:CreateFontString(nil, nil, "ImprovedAddonListLabelFont")
            AddonDetailFrame[detail.Name .. "Label"] = detailLabel
            -- 重要：如果Label不设置Point，则Body的定位无效，这会导致第一次获取Body的文本高度不正确
            detailLabel:SetPoint("TOPLEFT")
            detailLabel:SetText(detail.Label)

            local detailBody = AddonDetailFrame:CreateFontString(nil, nil, "ImprovedAddonListBodyFont")
            AddonDetailFrame[detail.Name] = detailBody
            detailBody:SetNonSpaceWrap(true)
            detailBody:SetPoint("TOPLEFT", detailLabel, "TOPRIGHT", 5, 0)
            detailBody:SetPoint("RIGHT", AddonDetailFrame, "RIGHT", -10, 0)

            if detail.Color then
                detailBody:SetTextColor(detail.Color:GetRGB())
            end
        end
    end

    -- 收藏按钮
    local favoriteButton = CreateDetailButton(AddonDetailFrame)
    AddonDetailContainer.FavoriteButton = favoriteButton
    favoriteButton:SetScript("OnEnter", onFavoriteButtonEnter)
    favoriteButton:SetScript("OnLeave", onFavoriteButtonLeave)
    favoriteButton:SetScript("OnClick", onFavoriteButtonClick)
    favoriteButton:SetSize(16, 16)
    favoriteButton:SetPoint("TOPRIGHT", -10, -10)

    -- 锁定按钮
    local lockButton = CreateDetailButton(AddonDetailFrame)
    AddonDetailContainer.LockButton = lockButton
    lockButton:SetScript("OnEnter", onLockButtonEnter)
    lockButton:SetScript("OnLeave", onLockButtonLeave)
    lockButton:SetScript("OnClick", onLockButtonClick)
    lockButton:SetSize(16, 16)
    lockButton:SetPoint("RIGHT", favoriteButton, "LEFT", -4, 0)

    -- 备注按钮
    local remarkButton = CreateDetailButton(AddonDetailFrame)
    AddonDetailContainer.RemarkButton = remarkButton
    remarkButton:SetScript("OnEnter", onRemarkButtonEnter)
    remarkButton:SetScript("OnLeave", onRemarkButtonLeave)
    remarkButton:SetScript("OnClick", onRemarkButtonClick)
    remarkButton:SetNormalTexture("Interface\\Addons\\ImprovedAddonList\\Media\\remark")
    remarkButton:SetHighlightTexture("Interface\\Addons\\ImprovedAddonList\\Media\\remark")
    remarkButton:GetHighlightTexture():SetAlpha(0.2)
    remarkButton:SetSize(16, 16)
    remarkButton:SetPoint("RIGHT", lockButton, "LEFT", -4, 0)
    
    -- 加载按钮
    local loadButton = CreateDetailButton(AddonDetailContainer)
    AddonDetailContainer.LoadButton = loadButton
    loadButton:SetScript("OnEnter", onLoadButtonEnter)
    loadButton:SetScript("OnLeave", onLoadButtonLeave)
    loadButton:SetScript("OnClick", OnLoadButtonClick)
    loadButton:SetText(L["load_addon"])
    loadButton:SetPoint("BOTTOMRIGHT", 0, 5)
    loadButton:SetSize(88, 22)

    self:UpdateAddonDetailFramesPosition()
end

function Addon:GetAddonDetailScrollBox()
    return self:GetAddonDetailContainer().ScrollBox
end

function Addon:GetAddonDetailScrollContainer()
    return self:GetAddonDetailContainer().ScrollBox.Container
end

local function getAddonVersion(version)
    if not version then return end
    
    if strmatch(version, ".*project.*version.*") then
        return WrapTextInColor(L["addon_detail_version_debug"], EPIC_PURPLE_COLOR)
    end

    return version
end

local function getStatusColor(loaded)
    if loaded then
        return WHITE_FONT_COLOR
    else
        return RED_FONT_COLOR
    end
end

local function GetEnableButtonColor(enabled)
    if enabled then
        return RED_FONT_COLOR
    else
        return NORMAL_FONT_COLOR        
    end
end

local function formatMemUsage(size)
    if size <= 0 then
        return ""
    elseif size > 1000 then
        size = size / 1000
        return format("%.2f MB", size)
    else
        return format("%.2f KB", size)
    end
end

local function getAddonDeps(deps)
    if not deps or #deps <= 0 then
        return L["addon_detail_no_dependency"]
    else
        return table.concat(deps, "\n")
    end
end

-- 同步收藏按钮状态
local function syncFavoriteButtonStatus(button, isFavorite)
    local tex = "Interface\\Addons\\ImprovedAddonList\\Media\\" .. (isFavorite and "favorite" or "unfavorite")
    button:SetNormalTexture(tex)
    button:SetHighlightTexture(tex, "ADD")
    button:GetHighlightTexture():SetAlpha(0.2)
    button.tooltipText = isFavorite and BATTLE_PET_UNFAVORITE or BATTLE_PET_FAVORITE
end

-- 同步锁定按钮状态
local function syncLockButtonStatus(button, isLocked, unlockable)
    local tex
    if not unlockable then
        tex = "Interface\\Addons\\ImprovedAddonList\\Media\\cannot_unlock.png"
    else
        tex = "Interface\\Addons\\ImprovedAddonList\\Media\\" .. (isLocked and "lock" or "unlock") .. ".png"
    end
    button:SetNormalTexture(tex)
    button:SetHighlightTexture(tex, "ADD")
    button:GetHighlightTexture():SetAlpha(0.2)
    if not unlockable then
        button.tooltipText = L["cannot_unlock_tips"]
    else
        button.tooltipText = isLocked and L["addon_detail_unlock_tips"] or L["addon_detail_lock_tips"]
    end
end

-- 刷新插件详情
function Addon:RefreshAddonDetailContainer()
    self:ShowAddonDetail(self:CurrentFocusAddonName())
end

-- 显示插件详情
function Addon:ShowAddonDetail(addonName)
    self:HideEditRemarkDialog()

    local addonDetailFrame = self:GetAddonDetailScrollContainer()
    local addonInfo = self:GetAddonInfoByName(addonName)
    self.FocusAddonInfo = addonInfo

    addonDetailFrame.Name:SetText(addonInfo.Name)
    addonDetailFrame.Title:SetText(addonInfo.Title)
    addonDetailFrame.Remark:SetText(addonInfo.Remark)
    addonDetailFrame.Notes:SetText(addonInfo.Notes)
    addonDetailFrame.Author:SetText(addonInfo.Author)
    addonDetailFrame.Version:SetText(getAddonVersion(addonInfo.Version))
    addonDetailFrame.LoadOnDemand:SetText(addonInfo.LoadOnDemand and L["true"] or L["false"])

    addonDetailFrame.Dependencies:SetText(getAddonDeps(addonInfo.Deps))
    addonDetailFrame.OptionalDeps:SetText(table.concat(addonInfo.OptionalDeps, "\n"))

    addonDetailFrame.LoadStatus:SetText(addonInfo.Loaded and L["addon_detail_loaded"] or L["addon_detail_unload"])
    addonDetailFrame.LoadStatus:SetTextColor(getStatusColor(addonInfo.Loaded):GetRGB())
    addonDetailFrame.UnloadReason:SetShown(not addonInfo.Loaded)
    addonDetailFrame.UnloadReason:SetText(addonInfo.UnloadableReason)
    addonDetailFrame.EnableStatus:SetText(addonInfo.Enabled and L["addon_detail_enabled"] or L["addon_detail_disabled"])
    addonDetailFrame.EnableStatus:SetTextColor(getStatusColor(addonInfo.Enabled):GetRGB())

    UpdateAddOnMemoryUsage()
    addonDetailFrame.MemoryUsage:SetText(formatMemUsage(GetAddOnMemoryUsage(addonInfo.Index)))

    self:UpdateAddonDetailFramesPosition()
    
    local AddonDetailContainer = self:GetAddonDetailContainer()
    
    -- 加载按钮
    AddonDetailContainer.LoadButton:SetShown(self:CanAddonLoadOnDemand(addonInfo.Name))
    -- 收藏按钮
    syncFavoriteButtonStatus(AddonDetailContainer.FavoriteButton, addonInfo.IsFavorite)
    -- 锁定按钮
    syncLockButtonStatus(AddonDetailContainer.LockButton, addonInfo.IsLocked, addonInfo.Unlockable)
end

-- 当前聚焦的插件
function Addon:CurrentFocusAddonName()
    return self.FocusAddonInfo and self.FocusAddonInfo.Name
end

function Addon:CurrentFocusAddonInfo()
    return self.FocusAddonInfo
end

-- 显示编辑备注窗口
function Addon:ShowEditRemarkDialog()
    local UI = self:GetOrCreateUI()
    local focusAddonInfo = self:CurrentFocusAddonInfo()

    if UI.EditRemarkDialog then
        UI.EditRemarkDialog:ShowAddonInfo(focusAddonInfo) 
        return 
    end

    local EditRemarkDialog = CreateFrame("Frame", nil, UI)
    UI.EditRemarkDialog = EditRemarkDialog
    EditRemarkDialog:SetSize(460, 150)
    EditRemarkDialog:SetPoint("CENTER")
    EditRemarkDialog:SetFrameStrata("DIALOG")
    
    function EditRemarkDialog:ShowAddonInfo(addonInfo)
        self.AddonInfo = addonInfo
        self.Label:SetText(addonInfo.Name)
        self.EditBox:SetText(addonInfo.Remark or "")
        self:Show()
    end

    local Border = CreateFrame("Frame", nil, EditRemarkDialog, "DialogBorderDarkTemplate")
    EditRemarkDialog.Border = Border

    local Title = EditRemarkDialog:CreateFontString(nil, nil, "GameFontHighlight")
    EditRemarkDialog.Title = Title
    Title:SetText(L["edit_remark"])
    Title:SetPoint("TOP", EditRemarkDialog, "Top",  0, -20)

    local ContentArea = CreateFrame("Frame", nil, EditRemarkDialog)
    EditRemarkDialog.ContentArea = ContentArea
    ContentArea:SetSize(250, 50)
    ContentArea:SetPoint("TOPLEFT", 40, -40)
    ContentArea:SetPoint("RIGHT", -40, 0)

    local Label = ContentArea:CreateFontString(nil, nil, "GameFontNormal")
    EditRemarkDialog.Label = Label
    Label:SetPoint("TOPLEFT")
    Label:SetText("测试")

    local EditBox = CreateFrame("EditBox", nil, ContentArea, "InputBoxTemplate")
    EditRemarkDialog.EditBox = EditBox
    EditBox:SetFontObject(ChatFontNormal)
    EditBox:SetSize(260, 32)
    EditBox:SetMaxLetters(self.REMARK_MAX_LENGTH)
    EditBox:SetPoint("TOPLEFT", Label, "BOTTOMLEFT", 0, 10)
    EditBox:SetPoint("RIGHT")
    EditBox:SetPoint("BOTTOM")

    local AcceptButton = CreateFrame("BUTTON", nil, EditRemarkDialog, "UIPanelButtonTemplate, UIButtonTemplate")
    EditRemarkDialog.AcceptButton = AcceptButton
    AcceptButton:SetText(SAVE)
    AcceptButton:SetSize(120, 22)
    AcceptButton:SetPoint("BOTTOMRIGHT", EditRemarkDialog, "BOTTOM", -5, 25)
    AcceptButton:SetScript("OnClick", function(btn)
        local addonInfo = btn:GetParent().AddonInfo
        local remark = btn:GetParent().EditBox:GetText()
        self:SetAddonRemark(addonInfo.Name, remark)
        self:HideEditRemarkDialog()
        self:RefreshAddonInfo(addonInfo.Name)
    end)

    local CancelButton = CreateFrame("BUTTON", nil, EditRemarkDialog, "UIPanelButtonTemplate, UIButtonTemplate")
    EditRemarkDialog.CancelButton = CancelButton
    CancelButton:SetText(CANCEL)
    CancelButton:SetSize(120, 22)
    CancelButton:SetPoint("BOTTOMLEFT", EditRemarkDialog, "BOTTOM", 5, 25)
    CancelButton:SetScript("OnClick", function() self:HideEditRemarkDialog() end)

    EditRemarkDialog:ShowAddonInfo(focusAddonInfo)
end

-- 隐藏编辑备注窗口
function Addon:HideEditRemarkDialog()
    local UI = self:GetOrCreateUI()

    if UI.EditRemarkDialog then
        UI.EditRemarkDialog:Hide()
        return 
    end
end