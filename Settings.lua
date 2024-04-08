local addonName, Addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local function TriggerSettingsMenuUpdate(event)
    Addon:TriggerEvent(event)
    Addon:TriggerEvent("SettingsMenuUpdate", event)
end

-- 创建子弹窗
function Addon:GetOrCreateSettingsDialog(type)
    self.SettingsDialogs = self.SettingsDialogs or {}

    local dialog = self.SettingsDialogs[type]
    if dialog then
        dialog:Show()
        return dialog
    end

    local UI = self:GetOrCreateUI()
    dialog = CreateFrame("Frame", nil, UI)
    self.SettingsDialogs[type] = dialog

    dialog:SetFrameStrata("DIALOG")
    dialog:SetPoint("CENTER")

    -- 框体外点击消失
    dialog:SetScript("OnShow", function(self)
        self:RegisterEvent("GLOBAL_MOUSE_DOWN")
    end)
    dialog:SetScript("OnHide", function(self)
        self:UnregisterEvent("GLOBAL_MOUSE_DOWN")
    end)

    dialog:RegisterEvent("GLOBAL_MOUSE_DOWN")
    dialog:SetScript("OnEvent", function(self, event)
        if event == "GLOBAL_MOUSE_DOWN" and not self:IsMouseOver() then
            self:Hide()
        end
    end)

    local border = CreateFrame("Frame", nil, dialog, "DialogBorderDarkTemplate")
    dialog.Border = border
    return dialog
end

-- 单选项
local SettingsSingleChoiceItemMixin = {}

function SettingsSingleChoiceItemMixin:OnLoad()
    self:SetHeight(30)

    local label = self:CreateFontString(nil, nil, "GameFontWhite")
    self.Label = label
    label:SetWordWrap(false)
    label:SetPoint("LEFT", 5, 0)

    local radioButton = self:CreateTexture()
    self.RadioButton = radioButton
    radioButton:SetSize(16, 16)
    radioButton:SetPoint("RIGHT", -5, 0)

    local hightlightOverlay = self:CreateTexture(nil, "HIGHLIGHT")
    hightlightOverlay:SetAtlas("Professions_Recipe_Hover", true)
    hightlightOverlay:SetAlpha(0.5)
    hightlightOverlay:SetAllPoints()

    self:SetScript("OnClick", function(self)
        self.SettingsItem:SetValue(self.Choice.Value)
        TriggerSettingsMenuUpdate(self.SettingsItem.Event)
    end)

    self:SetScript("OnHide", function(self)
        self.SettingsItem = nil
        self.Choice = nil
    end)

    local function onSettingsMenuUpdate(self, event)
        if self.SettingsItem and self.SettingsItem.Event == event then
            self:Update()
        end
    end

    Addon:RegisterCallback("SettingsMenuUpdate", onSettingsMenuUpdate, self)
end

-- 设置单选项
function SettingsSingleChoiceItemMixin:SetChoiceItem(settingsItem, choice)
    self.SettingsItem = settingsItem
    self.Choice = choice

    self:Update()
end

-- 刷新
function SettingsSingleChoiceItemMixin:Update()
    local choice = self.Choice
    if not choice then
        return
    end

    self.Label:SetText(choice.Text)
    local checked = self.SettingsItem:GetValue() == choice.Value
    local tex = "Interface\\AddOns\\ImprovedAddonList\\Media\\" ..
                    (checked and "radio_button_checked.png" or "radio_button.png")
    self.RadioButton:SetTexture(tex)
end

-- 创建单选项
local function CreateSingleChoiceItem(parent)
    local item = Mixin(CreateFrame("Button", nil, parent), SettingsSingleChoiceItemMixin)
    item:OnLoad()
    return item
end

-- 显示单选弹窗
function Addon:ShowSingleChoiceDialog(settingsItem)
    local Dialog = self:GetOrCreateSettingsDialog(settingsItem.Type)
    Dialog.ChoiceItems = Dialog.ChoiceItems or {}

    local choicesSize = #settingsItem.Choices

    for i, choice in ipairs(settingsItem.Choices) do
        local item = Dialog.ChoiceItems[i]
        if not item then
            item = CreateSingleChoiceItem(Dialog)
            Dialog.ChoiceItems[i] = item
        end

        item:SetChoiceItem(settingsItem, choice)
    end

    local paddingVertical = 15
    local marginVertical = 5
    for i, item in ipairs(Dialog.ChoiceItems) do
        item:ClearAllPoints()
        if i <= choicesSize then
            item:Show()
            item:SetPoint("TOPLEFT", 10, -(paddingVertical + (30 + marginVertical) * (i - 1)))
            item:SetPoint("RIGHT", -10, 0)
        else
            item:Hide()
        end
    end

    Dialog:SetWidth(250)
    Dialog:SetHeight(choicesSize * 30 + (choicesSize - 1) * marginVertical + paddingVertical * 2)
end

-- 设置项：组
ImprovedAddonListSettingsGroupItemMixin = {}

function ImprovedAddonListSettingsGroupItemMixin:Update()
    local data = self:GetElementData():GetData()
    self.Title:SetText(data.Title)
end

-- 设置项
ImprovedAddonListSettingsItemMixin = {}

function ImprovedAddonListSettingsItemMixin:OnLoad()
    local function onSettingsMenuUpdate(self, event)
        local item = self:GetElementData():GetData()
        if item and item.Event == event then
            self:OnBind(item)
        end
    end
    Addon:RegisterCallback("SettingsMenuUpdate", onSettingsMenuUpdate, self)
end

-- 设置项更新
function ImprovedAddonListSettingsItemMixin:Update()
    local item = self:GetElementData():GetData()
    self:SetTitle(item.Title, item.SubTitle)
    self:OnBind(item)
end

-- 设置项标题和副标题
function ImprovedAddonListSettingsItemMixin:SetTitle(title, subTitle)
    title = title or ""
    subTitle = subTitle or ""
    self.Title:SetText(title)
    self.SubTitle:SetText(subTitle)

    self.Title:ClearAllPoints()
    self.SubTitle:ClearAllPoints()

    if strlen(subTitle) > 0 then
        self.Title:SetPoint("TOPLEFT", 5, -3)
        self.SubTitle:SetPoint("TOPLEFT", self.Title, "BOTTOMLEFT", 0, -2)
        self.SubTitle:Show()
    else
        self.Title:SetPoint("LEFT", 5, 1)
        self.SubTitle:Hide()
    end
end

-- 单选项
ImprovedAddonListSettingsItemSingleChoiceMixin = CreateFromMixins(ImprovedAddonListSettingsItemMixin)

-- 单选项：获得当前值
function ImprovedAddonListSettingsItemSingleChoiceMixin:OnBind()
    local item = self:GetElementData():GetData()
    self.Value:SetText(item:Description())
end

-- 单选项：点击
function ImprovedAddonListSettingsItemSingleChoiceMixin:OnClick()
    local item = self:GetElementData():GetData()
    Addon:ShowSingleChoiceDialog(item)
end

-- 设置窗体
local SettingsFrameMixin = {}

-- 设置列表项节点更新
local function SettingListItemNodeUpdater(factory, node)
    local function Initializer(button, node)
        button:Update()
    end

    local data = node:GetData()
    if data.IsGroup then
        factory("ImprovedAddonListSettingsGroupItemTemplate", Initializer)
    elseif data.Type == "singleChoice" then
        factory("ImprovedAddonListSettingsItemSingleChoiceTemplate", Initializer)
    end
end

-- 列表长度
local function ElementExtentCalculator(index, node)
    local data = node:GetData()

    if data.IsGroup then
        return 24
    else
        local title = data.Title or ""
        local subTitle = data.SubTitle or ""
        if strlen(subTitle) > 0 then
            return 40
        else
            return 24
        end
    end
end

function SettingsFrameMixin:OnLoad()
    local ScrollBox = CreateFrame("Frame", nil, self, "WowScrollBoxList")
    self.ScrollBox = ScrollBox

    ScrollBox:SetPoint("TOPLEFT", 5, -7)
    ScrollBox:SetPoint("BOTTOMRIGHT", -5, 7)

    local Title = self:CreateFontString(nil, nil, "GameFontNormal")
    self.Title = Title
    Title:SetPoint("CENTER", self, "TOP", 0, 0)

    local ScrollView = CreateScrollBoxListTreeListView(6, 0, 0, 0, 0, 1)
    ScrollView:SetElementFactory(SettingListItemNodeUpdater)
    ScrollView:SetElementExtentCalculator(ElementExtentCalculator)
    ScrollBox:Init(ScrollView)
end

-- 显示设置信息
function SettingsFrameMixin:ShowSettings(settingsInfo)
    self.Title:SetText(settingsInfo.Title)

    self.SettingsDataProvider = self.SettingsDataProvider or CreateTreeDataProvider()
    local dataProvider = self.SettingsDataProvider
    dataProvider:Flush()

    local rootNode = dataProvider:GetRootNode()
    for _, groupInfo in ipairs(settingsInfo.Groups) do
        local categoryNode = rootNode:Insert({ IsGroup = true, Title = groupInfo.Title })
        for _, settingsItem in ipairs(groupInfo.Items) do
            categoryNode:Insert(settingsItem)
        end
    end

    self.ScrollBox:SetDataProvider(dataProvider, ScrollBoxConstants.DiscardScrollPosition)

    self:Show()
end

function SettingsFrameMixin:GetScrollBox()
    return self.ScrollBox
end

-- 创建设置窗体
function Addon:CreateSettingsFrame()
    local UI = self:GetOrCreateUI()

    local SettingsFrame = Mixin(self:CreateContainer(UI), SettingsFrameMixin)
    SettingsFrame:OnLoad()

    self.SettingsFrames = self.SettingsFrames or {}
    tinsert(self.SettingsFrames, SettingsFrame)

    return SettingsFrame
end