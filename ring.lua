-- ==========================================
-- DELTA UI V12 - ULTIMATE MAX (UPDATE TỐI THƯỢNG)
-- (SMART HAKI + SEA + RAID CLEAR CHECK + AUTO SAVE/LOAD + AUTO MENU + SCANNER MAP + INFINITE SKIP)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")

local SafeParent = pcall(gethui) and gethui() or LocalPlayer:WaitForChild("PlayerGui")
if SafeParent:FindFirstChild("V10_DeltaUI_Max") then SafeParent["V10_DeltaUI_Max"]:Destroy() end

-- ==========================================
-- 📚 DATABASE & BIẾN GLOBAL
-- ==========================================
local QuestDB = {
    {Level = 1, QuestName = "Bandit [Lv. 1]", MobName = "Bandit", NPC = "Quest Giver"},
    {Level = 10, QuestName = "Naval Student [Lv. 10]", MobName = "Naval Rating Student", NPC = "Quest Giver"},
    {Level = 30, QuestName = "Pirate [Lv. 30]", MobName = "Pirate", NPC = "Quest Giver"},
}
local QuestListNames = {}
for i, v in ipairs(QuestDB) do table.insert(QuestListNames, v.QuestName) end

local _G_V10 = {
    AutoFarmFree = false, FarmAll = false, SelectedMonsters = {}, ExcludedMobs = {"dummy", "test dmg", "testdmg"},
    AutoFarmLevel = false, ManualQuestFarm = false, SelectedManualQuest = nil, CurrentTargetMob = nil,
    AutoEquip = false, AutoClick = false, AutoSkill = false, AutoRepeatQuest = false,
    
    Skill_Z = false, Skill_X = false, Skill_C = false, Skill_V = false, Skill_F = false,
    AutoHaki = false, AutoKen = false,
    SelectedWeapon = nil, SelectedFruit = nil,
    AttackPosition = "Trên Đầu", AttackDistance = 15, FlySpeed = 250,
    
    PrimaryWeapon = nil, HoldTime1 = 3,
    W1_Z = false, W1_X = false, W1_C = false, W1_V = false, W1_B = false, W1_F = false,
    SecondaryWeapon = nil, HoldTime2 = 0.5,
    W2_Z = false, W2_X = false, W2_C = false, W2_V = false, W2_B = false, W2_F = false,
    AutoSwapWeapon = false, SkillSpamDelay = 0.1,
    
    AutoSea = false, HuntSeaMonster = true, HuntGhost = true, AutoSitBoat = true, 
    SeaZone = Vector3.new(-15610, 39, 37071), IsFightingSea = false, ArrivedAtZone = false,

    AutoBuyRaid = false, AutoStartRaid = false, AutoJoinGame = false, AutoBypassMenu = false,
    AutoTeleEntrance = false, AutoTeleReRaid = false, RaidTeleportDelay = 2,

    AutoSpawnMihawk = false, MihawkAmount = "x1",
    AutoGiveShadow = false, ShadowItem = "Shadow Spirit", ShadowAmount = "x1",

    SelectedIsland = nil, SelectedSpawnPoint = nil,
    EnableSpeed = false, WalkSpeed = 50, EnableJump = false, JumpPower = 100, InfJump = false, DashNoCD = false,
    FreeFly = false, FreeFlySpeed = 50,
    
    AutoSaveConfig = false, AutoLoadConfig = false, SelectedConfig = "DefaultConfig",
    
    AutoScanMap = false
}

local _G_UI_Updaters = {}
local _G_ScannerData = {Mobs = {}, Bosses = {}}

-- ==========================================
-- HỆ THỐNG LƯU CẤU HÌNH (MASTER AUTO SAVE/LOAD)
-- ==========================================
local ConfigFolder = "DeltaV12_Configs"
local MasterFile = ConfigFolder .. "/MasterSettings.json"

if isfolder and not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local function SaveConfig(name)
    if not writefile then return end
    name = name or "DefaultConfig"
    _G_V10.SelectedConfig = name
    writefile(ConfigFolder.."/"..name..".json", HttpService:JSONEncode(_G_V10))
    local masterData = {AutoLoadConfig = _G_V10.AutoLoadConfig, LastConfig = name}
    writefile(MasterFile, HttpService:JSONEncode(masterData))
end

local function LoadConfig(name)
    if not readfile or not isfile(ConfigFolder.."/"..name..".json") then return end
    local s, decoded = pcall(function() return HttpService:JSONDecode(readfile(ConfigFolder.."/"..name..".json")) end)
    if s and type(decoded) == "table" then
        for k, v in pairs(decoded) do _G_V10[k] = v end
        for _, updater in pairs(_G_UI_Updaters) do pcall(updater) end
    end
end

if readfile and isfile(MasterFile) then
    local s, masterData = pcall(function() return HttpService:JSONDecode(readfile(MasterFile)) end)
    if s and type(masterData) == "table" then
        if masterData.AutoLoadConfig and masterData.LastConfig then
            _G_V10.AutoLoadConfig = true
            LoadConfig(masterData.LastConfig)
        end
    end
end

local function AutoSaveTrigger()
    if _G_V10.AutoSaveConfig then SaveConfig(_G_V10.SelectedConfig) end
end

local function GetConfigsList()
    local list = {}
    if listfiles and isfolder(ConfigFolder) then
        for _, file in pairs(listfiles(ConfigFolder)) do
            local name = file:match("([^/%\\]+)%.json$") or file
            if name ~= "MasterSettings" then table.insert(list, name) end
        end
    end
    return list
end

-- ==========================================
-- GIAO DIỆN CHÍNH
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "V10_DeltaUI_Max"; ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 620, 0, 420); MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 200, 255)

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45); ToggleBtn.Position = UDim2.new(0, 15, 0.5, -22)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20); ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.Text = "⚙️"; ToggleBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
ToggleBtn.Font = Enum.Font.GothamBold; ToggleBtn.TextSize = 22
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(0, 200, 255)
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35); TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
local FixCorner = Instance.new("Frame", TopBar)
FixCorner.Size = UDim2.new(1, 0, 0, 10); FixCorner.Position = UDim2.new(0, 0, 1, -10); FixCorner.BackgroundColor3 = Color3.fromRGB(10, 10, 15); FixCorner.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.5, 0, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = "AUTO FARM V12 (Ultimate Max)"
Title.TextColor3 = Color3.fromRGB(0, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 16; Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 40, 0, 35); MinBtn.Position = UDim2.new(1, -80, 0, 0); MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"; MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 24
MinBtn.MouseButton1Click:Connect(function()
    local isMinimized = MainFrame.Size.Y.Offset == 35
    MainFrame.Size = isMinimized and UDim2.new(0, 620, 0, 420) or UDim2.new(0, 620, 0, 35)
    for _, v in pairs(MainFrame:GetChildren()) do if v.Name == "TabsFrame" or v.Name == "ContentFrame" then v.Visible = isMinimized end end
end)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 40, 0, 35); CloseBtn.Position = UDim2.new(1, -40, 0, 0); CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 18
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local TabsFrame = Instance.new("ScrollingFrame", MainFrame)
TabsFrame.Name = "TabsFrame"; TabsFrame.Size = UDim2.new(0.28, 0, 1, -35); TabsFrame.Position = UDim2.new(0, 0, 0, 35)
TabsFrame.BackgroundTransparency = 1; TabsFrame.ScrollBarThickness = 2; TabsFrame.CanvasSize = UDim2.new(0, 0, 0, 650)
Instance.new("UIListLayout", TabsFrame).Padding = UDim.new(0, 5)
Instance.new("UIPadding", TabsFrame).PaddingTop = UDim.new(0, 10)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Name = "ContentFrame"; ContentFrame.Size = UDim2.new(0.72, 0, 1, -35); ContentFrame.Position = UDim2.new(0.28, 0, 0, 35)
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); ContentFrame.BackgroundTransparency = 0.5
Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 8)

-- ==========================================
-- HÀM TẠO UI COMPONENTS TÍCH HỢP AUTO LOAD
-- ==========================================
local Pages = {}
local function CreateTab(name)
    local Btn = Instance.new("TextButton", TabsFrame)
    Btn.Size = UDim2.new(1, -10, 0, 40); Btn.Position = UDim2.new(0, 5, 0, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Text = "  " .. name; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 13; Btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("ScrollingFrame", ContentFrame)
    Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2; Page.Visible = false
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    local pad = Instance.new("UIPadding", Page)
    pad.PaddingTop, pad.PaddingLeft, pad.PaddingRight, pad.PaddingBottom = UDim.new(0,10), UDim.new(0,10), UDim.new(0,10), UDim.new(0,10)

    Pages[name] = {Btn = Btn, Page = Page}
    Btn.MouseButton1Click:Connect(function()
        for n, p in pairs(Pages) do
            p.Page.Visible = (n == name)
            p.Btn.BackgroundColor3 = (n == name) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(30, 30, 35)
            p.Btn.TextColor3 = (n == name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        end
    end)
    return Page
end

local function CreateToggleSwitch(parent, text, varName, isMasterLoad)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 40); Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(0.7, 0, 1, 0); Lbl.Position = UDim2.new(0, 10, 0, 0); Lbl.BackgroundTransparency = 1
    Lbl.Text = text; Lbl.TextColor3 = Color3.fromRGB(255, 255, 255); Lbl.Font = Enum.Font.Gotham; Lbl.TextSize = 13; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local SwitchBG = Instance.new("TextButton", Frame)
    SwitchBG.Size = UDim2.new(0, 40, 0, 20); SwitchBG.Position = UDim2.new(1, -50, 0.5, -10)
    SwitchBG.BackgroundColor3 = Color3.fromRGB(100, 100, 100); SwitchBG.Text = ""
    Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)
    local Knob = Instance.new("Frame", SwitchBG)
    Knob.Size = UDim2.new(0, 16, 0, 16); Knob.Position = UDim2.new(0, 2, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local function UpdateVisuals()
        local state = _G_V10[varName]
        SwitchBG.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
        Knob:TweenPosition(state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.2, true)
        if isMasterLoad then Lbl.Text = state and "Đang Auto Load: " .. (_G_V10.SelectedConfig or "Unknown") or text end
    end
    _G_UI_Updaters[varName] = UpdateVisuals

    SwitchBG.MouseButton1Click:Connect(function()
        _G_V10[varName] = not _G_V10[varName]
        UpdateVisuals(); if varName == "AutoLoadConfig" then SaveConfig(_G_V10.SelectedConfig) end; AutoSaveTrigger()
    end)
    UpdateVisuals()
end

local function CreateDropdown(parent, title, itemsList, globalVar, multiSelect)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 35); Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40); Frame.ClipsDescendants = true
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local MainBtn = Instance.new("TextButton", Frame)
    MainBtn.Size = UDim2.new(1, 0, 0, 35); MainBtn.BackgroundTransparency = 1; MainBtn.Text = "  " .. title .. " ▼"
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MainBtn.Font = Enum.Font.Gotham; MainBtn.TextSize = 13; MainBtn.TextXAlignment = Enum.TextXAlignment.Left
    
    local Drop = Instance.new("ScrollingFrame", Frame)
    Drop.Size = UDim2.new(1, 0, 0, 115); Drop.Position = UDim2.new(0, 0, 0, 35); Drop.BackgroundTransparency = 1; Drop.ScrollBarThickness = 2
    local layout = Instance.new("UIListLayout", Drop)

    local function UpdateVisuals()
        if multiSelect then
            local val = _G_V10[globalVar] or {}
            MainBtn.Text = "  " .. title .. ": [" .. #val .. " Đã Chọn] ▼"
            for _, btn in pairs(Drop:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = table.find(val, btn.Text) and Color3.fromRGB(0, 150, 150) or Color3.fromRGB(45, 45, 50)
                end
            end
        else
            local val = _G_V10[globalVar]
            MainBtn.Text = "  " .. title .. ": " .. (val and tostring(val) or "Chưa chọn") .. " ▼"
        end
    end
    _G_UI_Updaters[globalVar] = UpdateVisuals

    MainBtn.MouseButton1Click:Connect(function() Frame.Size = Frame.Size.Y.Offset == 35 and UDim2.new(1, 0, 0, 150) or UDim2.new(1, 0, 0, 35) end)

    local function Refresh(newList)
        if newList then itemsList = newList end
        for _, v in pairs(Drop:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        for _, item in pairs(itemsList) do
            local Btn = Instance.new("TextButton", Drop)
            Btn.Size = UDim2.new(1, 0, 0, 30); Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50); Btn.Text = item; Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham; Btn.TextSize = 11
            Btn.MouseButton1Click:Connect(function()
                if multiSelect then
                    _G_V10[globalVar] = _G_V10[globalVar] or {}
                    local idx = table.find(_G_V10[globalVar], item)
                    if idx then table.remove(_G_V10[globalVar], idx) else table.insert(_G_V10[globalVar], item) end
                else
                    _G_V10[globalVar] = item; Frame.Size = UDim2.new(1, 0, 0, 35)
                end
                UpdateVisuals(); AutoSaveTrigger()
            end)
        end
        Drop.CanvasSize = UDim2.new(0, 0, 0, #itemsList * 30)
        UpdateVisuals()
    end
    Refresh(itemsList); UpdateVisuals()
    return Refresh
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, 0, 0, 35); Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Text = text; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 13
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
end

local function CreateSlider(parent, name, min, max, globalVar)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 45); Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(1, 0, 0, 20); Lbl.Position = UDim2.new(0, 5, 0, 0); Lbl.BackgroundTransparency = 1
    Lbl.Text = name .. ": " .. _G_V10[globalVar]; Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    Lbl.Font = Enum.Font.Gotham; Lbl.TextSize = 13; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderBG = Instance.new("TextButton", Frame)
    SliderBG.Size = UDim2.new(0.95, 0, 0, 10); SliderBG.Position = UDim2.new(0.025, 0, 0, 25); SliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 65); SliderBG.Text = ""
    Instance.new("UICorner", SliderBG)
    local Fill = Instance.new("Frame", SliderBG)
    Fill.Size = UDim2.new(0, 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    Instance.new("UICorner", Fill)

    local function UpdateVisuals()
        local val = _G_V10[globalVar]; local percent = (val - min) / (max - min)
        Fill.Size = UDim2.new(percent, 0, 1, 0); Lbl.Text = name .. ": " .. val
    end
    _G_UI_Updaters[globalVar] = UpdateVisuals

    local Dragging = false
    SliderBG.MouseButton1Down:Connect(function() Dragging = true end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then if Dragging then Dragging = false; AutoSaveTrigger() end end end)
    UIS.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
            _G_V10[globalVar] = math.floor((min + (max - min) * pos) * 10) / 10; UpdateVisuals()
        end
    end)
    UpdateVisuals()
end

local function CreateSkillGrid(parent, labelText, varPrefix)
    local Container = Instance.new("Frame", parent)
    Container.Size = UDim2.new(1, 0, 0, 55); Container.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)
    
    local Lbl = Instance.new("TextLabel", Container)
    Lbl.Size = UDim2.new(1, -10, 0, 20); Lbl.Position = UDim2.new(0, 10, 0, 5)
    Lbl.BackgroundTransparency = 1; Lbl.Text = labelText; Lbl.TextColor3 = Color3.fromRGB(255, 255, 100); Lbl.Font = Enum.Font.GothamBold; Lbl.TextSize = 12; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local Grid = Instance.new("Frame", Container)
    Grid.Size = UDim2.new(1, -10, 0, 25); Grid.Position = UDim2.new(0, 10, 0, 25); Grid.BackgroundTransparency = 1
    local layout = Instance.new("UIListLayout", Grid); layout.FillDirection = Enum.FillDirection.Horizontal; layout.Padding = UDim.new(0, 5)
    
    local skills = {"Z", "X", "C", "V", "B", "F"}
    for _, key in ipairs(skills) do
        local Btn = Instance.new("TextButton", Grid)
        Btn.Size = UDim2.new(0, 35, 0, 22); Btn.Text = key; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
        
        local function UpdateVisuals() Btn.BackgroundColor3 = _G_V10[varPrefix..key] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(80, 80, 80) end
        _G_UI_Updaters[varPrefix..key] = UpdateVisuals
        
        Btn.MouseButton1Click:Connect(function() _G_V10[varPrefix..key] = not _G_V10[varPrefix..key]; UpdateVisuals(); AutoSaveTrigger() end)
        UpdateVisuals()
    end
end

local function CreateDivider(parent, text, color)
    local LblDivider = Instance.new("TextLabel", parent)
    LblDivider.Size = UDim2.new(1, 0, 0, 20); LblDivider.BackgroundTransparency = 1; LblDivider.TextColor3 = color or Color3.fromRGB(255, 100, 100)
    LblDivider.Font = Enum.Font.GothamBold; LblDivider.TextSize = 13; LblDivider.TextXAlignment = Enum.TextXAlignment.Center; LblDivider.Text = "--- " .. text .. " ---"
end

local function CreateTextBox(parent, placeholder, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 35); Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local TextBox = Instance.new("TextBox", Frame)
    TextBox.Size = UDim2.new(1, -10, 1, 0); TextBox.Position = UDim2.new(0, 5, 0, 0); TextBox.BackgroundTransparency = 1
    TextBox.Text = ""; TextBox.PlaceholderText = placeholder; TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.Font = Enum.Font.Gotham; TextBox.TextSize = 13; TextBox.ClearTextOnFocus = false
    TextBox.FocusLost:Connect(function() callback(TextBox.Text) end)
end

-- ==========================================
-- XÂY DỰNG TABS
-- ==========================================
local TabConfig = CreateTab("💾 Config (Save/Load)")
local TabAutoLevel = CreateTab("🌟 Farm Level")
local TabFreeFarm = CreateTab("⚔️ Farm Tùy Chọn")
local TabSeaEvent = CreateTab("🌊 Sự Kiện Biển")
local TabRaid = CreateTab("🏰 Auto Raid")
local TabBoss = CreateTab("👹 Boss & Spawn")
local TabIsland = CreateTab("🏝️ Đảo & Bay")
local TabPlayer = CreateTab("🏃 Nhân Vật")
local TabSettings = CreateTab("⚙️ Đổi VK & Skill")
local TabSkills = CreateTab("⚡ Haki & Auto Khác")
local TabScanner = CreateTab("📝 Note & Scan Map")

Pages["💾 Config (Save/Load)"].Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Pages["💾 Config (Save/Load)"].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabConfig.Visible = true

-- --- TAB: CONFIG (SAVE/LOAD) ---
local DropConfigs = CreateDropdown(TabConfig, "Chọn Bản Lưu", GetConfigsList(), "SelectedConfig", false)
local ConfigNameInput = "DefaultConfig"
CreateTextBox(TabConfig, "Nhập tên cấu hình để lưu mới (VD: BeliFarm)", function(text) ConfigNameInput = text end)
CreateButton(TabConfig, "💾 LƯU BẢN HIỆN TẠI (SAVE)", function() SaveConfig(ConfigNameInput ~= "" and ConfigNameInput or _G_V10.SelectedConfig); DropConfigs(GetConfigsList()); game.StarterGui:SetCore("SendNotification", {Title = "Lưu Thành Công", Text = "Đã lưu cấu hình hiện tại!", Duration = 3}) end)
CreateButton(TabConfig, "📂 TẢI BẢN ĐÃ CHỌN (LOAD)", function() LoadConfig(_G_V10.SelectedConfig); game.StarterGui:SetCore("SendNotification", {Title = "Tải Thành Công", Text = "Đã tải cấu hình " .. _G_V10.SelectedConfig, Duration = 3}) end)
CreateDivider(TabConfig, "CÔNG TẮC AUTO LƯU/TẢI", Color3.fromRGB(0, 200, 255))
CreateToggleSwitch(TabConfig, "Bật Auto Lưu (Lưu mỗi khi thay đổi)", "AutoSaveConfig")
CreateToggleSwitch(TabConfig, "Bật Auto Load (Khi vào lại game)", "AutoLoadConfig", true)

-- --- TAB: FARM LEVEL ---
local LblInfo = Instance.new("TextLabel", TabAutoLevel)
LblInfo.Size = UDim2.new(1, 0, 0, 20); LblInfo.BackgroundTransparency = 1; LblInfo.TextColor3 = Color3.fromRGB(255, 255, 100); LblInfo.Font = Enum.Font.Gotham; LblInfo.TextSize = 13; LblInfo.TextXAlignment = Enum.TextXAlignment.Left; LblInfo.Text = "Trạng thái: Đang chờ..."
CreateToggleSwitch(TabAutoLevel, "Bật Auto Farm Level (Tự Chuyển Bãi)", "AutoFarmLevel")
CreateDropdown(TabAutoLevel, "Chọn Quest Bằng Tay", QuestListNames, "SelectedManualQuest", false)
CreateToggleSwitch(TabAutoLevel, "Bật Đánh Quest Đã Chọn Trên", "ManualQuestFarm")
CreateToggleSwitch(TabAutoLevel, "Bật Tự Động Đánh (Click)", "AutoClick")

-- --- TAB: FARM TÙY CHỌN (MULTI-SELECT) ---
local DropMonsters = CreateDropdown(TabFreeFarm, "Chọn Quái Cần Đánh (Nhiều Con)", {}, "SelectedMonsters", true)
CreateButton(TabFreeFarm, "🔍 Quét Quái (Toàn bộ Map)", function()
    local mobs = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(v) then
            local isEx = false
            for _, ex in pairs(_G_V10.ExcludedMobs) do if string.find(string.lower(v.Name), ex) then isEx = true; break end end
            if not isEx and not table.find(mobs, v.Name) then table.insert(mobs, v.Name) end
        end
    end
    table.sort(mobs); DropMonsters(mobs)
end)
CreateToggleSwitch(TabFreeFarm, "Bật Free Farm (Đánh danh sách trên)", "AutoFarmFree")
CreateToggleSwitch(TabFreeFarm, "Bật Farm ALL (Càn quét Map)", "FarmAll")

-- --- TAB: SEA EVENT ---
local LblSeaInfo = Instance.new("TextLabel", TabSeaEvent)
LblSeaInfo.Size = UDim2.new(1, 0, 0, 20); LblSeaInfo.BackgroundTransparency = 1; LblSeaInfo.TextColor3 = Color3.fromRGB(0, 255, 200); LblSeaInfo.Font = Enum.Font.Gotham; LblSeaInfo.TextSize = 13; LblSeaInfo.TextXAlignment = Enum.TextXAlignment.Left; LblSeaInfo.Text = "Trạng thái Biển: Đang rảnh..."
CreateToggleSwitch(TabSeaEvent, "Bật Auto Sea Event", "AutoSea")
CreateToggleSwitch(TabSeaEvent, "Săn Sea Monster (Bay Vòng Tròn)", "HuntSeaMonster")
CreateToggleSwitch(TabSeaEvent, "Săn Thuyền Ma (The Starving Ghost)", "HuntGhost")
CreateToggleSwitch(TabSeaEvent, "Tự Động Ngồi Lái Thuyền", "AutoSitBoat")

-- --- TAB: RAID ---
CreateDivider(TabRaid, "MUA RAID & JOIN GAME", Color3.fromRGB(255, 100, 100))
CreateToggleSwitch(TabRaid, "Bật Tự Động Bypass Main Menu (Click Play/Load)", "AutoBypassMenu")
CreateToggleSwitch(TabRaid, "Bật Tự Động Mua Raid / Re-Raid", "AutoBuyRaid")
CreateToggleSwitch(TabRaid, "Bật Tự Động Bấm Starto (Bắt đầu Raid)", "AutoStartRaid")
CreateToggleSwitch(TabRaid, "Tự Động Bấm Play/Join Game (Dùng Remote)", "AutoJoinGame")
CreateDivider(TabRaid, "TELEPORT RAID", Color3.fromRGB(255, 100, 100))
CreateToggleSwitch(TabRaid, "Teleport Đến Cửa Raid (Ngoài Map)", "AutoTeleEntrance")
CreateToggleSwitch(TabRaid, "Teleport Vào Phòng Re-Raid (Chỉ khi HẾT QUÁI)", "AutoTeleReRaid")
CreateSlider(TabRaid, "Delay Teleport Raid Sau Khi Xong (Giây)", 1, 10, "RaidTeleportDelay")

-- --- TAB: BOSS & SPAWN ---
CreateDivider(TabBoss, "AUTO SPAWN MIHAWK", Color3.fromRGB(150, 100, 255))
CreateToggleSwitch(TabBoss, "Bật Auto Spawn Mihawk", "AutoSpawnMihawk")
CreateDropdown(TabBoss, "Chọn Lượng Spawn Mihawk", {"x100", "x10", "x1"}, "MihawkAmount", false)
CreateDivider(TabBoss, "AUTO GIVE SHADOW BOSS", Color3.fromRGB(150, 100, 255))
CreateToggleSwitch(TabBoss, "Bật Auto Give Item Cho Shadow", "AutoGiveShadow")
CreateDropdown(TabBoss, "Chọn Vật Phẩm Give", {"Shadow Spirit", "Rotten Flesh", "Aqua Soul", "Bone", "Blood Bottle"}, "ShadowItem", false)
CreateDropdown(TabBoss, "Chọn Số Lượng Give", {"x1", "x5", "x10"}, "ShadowAmount", false)

-- --- TAB: ĐẢO & BAY ---
local DropIslands = CreateDropdown(TabIsland, "Chọn Đảo (Island)", {}, "SelectedIsland", false)
CreateButton(TabIsland, "🏝️ Quét Danh Sách Đảo", function()
    local islands = {}
    local islandsFolder = workspace:FindFirstChild("All") and workspace.All:FindFirstChild("Island")
    if islandsFolder then for _, island in ipairs(islandsFolder:GetChildren()) do table.insert(islands, island.Name) end end
    table.sort(islands); DropIslands(islands)
end)
local DropSpawnPoints = CreateDropdown(TabIsland, "Chọn Điểm Hồi Sinh (SetSpawnPoints)", {}, "SelectedSpawnPoint", false)
CreateButton(TabIsland, "🔄 Cập nhật danh sách Điểm Hồi Sinh", function()
    local sp = {}
    if workspace:FindFirstChild("SetSpawnPoints") then for _, v in pairs(workspace.SetSpawnPoints:GetChildren()) do table.insert(sp, v.Name) end end
    table.sort(sp); DropSpawnPoints(sp)
end)
local function InstantTeleport(targetCFrame)
    local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if HRP then HRP.CFrame = targetCFrame end
end
CreateButton(TabIsland, "🚀 Dịch Chuyển (Teleport Tức Thời)", function()
    local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    if _G_V10.SelectedIsland then
        local isl = workspace:FindFirstChild("All") and workspace.All:FindFirstChild("Island") and workspace.All.Island:FindFirstChild(_G_V10.SelectedIsland)
        if isl then InstantTeleport(isl:GetPivot() + Vector3.new(0, 50, 0)) end
    elseif _G_V10.SelectedSpawnPoint then
        local sp = workspace:FindFirstChild("SetSpawnPoints") and workspace.SetSpawnPoints:FindFirstChild(_G_V10.SelectedSpawnPoint)
        if sp then InstantTeleport(sp.CFrame + Vector3.new(0, 5, 0)) end
    end
end)

-- --- TAB: SETTINGS & SKILL ---
CreateDivider(TabSettings, "AUTO ĐỔI VŨ KHÍ & XẢ SKILL SIÊU TỐC", Color3.fromRGB(0, 200, 255))
CreateToggleSwitch(TabSettings, "Bật Tự Động Đổi Vũ Khí (1 <-> 2)", "AutoSwapWeapon")
CreateSlider(TabSettings, "Min Delay Xả Skill (Giây)", 0.1, 5, "SkillSpamDelay")
local DropPriWeapon = CreateDropdown(TabSettings, "Vũ Khí 1 (Vũ Khí Chính)", {}, "PrimaryWeapon", false)
CreateSlider(TabSettings, "Thời Gian Cầm VK 1 (Giây)", 0.1, 10, "HoldTime1")
CreateSkillGrid(TabSettings, "Các Skill Tự Động Bấm Khi Cầm Vũ Khí 1:", "W1_")
local DropSecWeapon = CreateDropdown(TabSettings, "Vũ Khí 2 (Vũ Khí Phụ)", {}, "SecondaryWeapon", false)
CreateSlider(TabSettings, "Thời Gian Cầm VK 2 (Giây)", 0.1, 10, "HoldTime2")
CreateSkillGrid(TabSettings, "Các Skill Tự Động Bấm Khi Cầm Vũ Khí 2:", "W2_")
local DropWeapons = CreateDropdown(TabSettings, "Hoặc Chọn 1 Vũ Khí Cố Định", {}, "SelectedWeapon", false)
CreateToggleSwitch(TabSettings, "Tự Động Cầm 1 Vũ Khí Trên", "AutoEquip")
CreateButton(TabSettings, "🎒 Quét Vũ Khí (Làm Mới Danh Sách)", function()
    local weps = {}
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(weps, v.Name) end end
    if LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("Tool") and not table.find(weps, v.Name) then table.insert(weps, v.Name) end end end
    DropWeapons(weps); DropPriWeapon(weps); DropSecWeapon(weps)
end)
CreateToggleSwitch(TabSettings, "Bật Lặp Lại Quest (Tự Nhận Remote Qu)", "AutoRepeatQuest")
CreateDropdown(TabSettings, "Kiểu Đánh", {"Trên Đầu", "Đằng Sau", "Dưới Chân"}, "AttackPosition", false)
CreateSlider(TabSettings, "Khoảng Cách Đánh", 5, 40, "AttackDistance")
CreateSlider(TabSettings, "Tốc Độ Bay Chung", 100, 500, "FlySpeed")

CreateToggleSwitch(TabSkills, "🔥 Bật Tự Động Haki (Thông Minh)", "AutoHaki")
CreateToggleSwitch(TabSkills, "👁️ Bật Tự Động Ken (Thông Minh)", "AutoKen")
CreateToggleSwitch(TabSkills, "Kích Hoạt Auto Skill Global", "AutoSkill")
CreateToggleSwitch(TabSkills, "Phím Z", "Skill_Z"); CreateToggleSwitch(TabSkills, "Phím X", "Skill_X")
CreateToggleSwitch(TabSkills, "Phím C", "Skill_C"); CreateToggleSwitch(TabSkills, "Phím V", "Skill_V")
CreateToggleSwitch(TabSkills, "Phím F", "Skill_F")

CreateToggleSwitch(TabPlayer, "Bật Hack Tốc Độ Chạy", "EnableSpeed")
CreateSlider(TabPlayer, "Tốc Độ Chạy (WalkSpeed)", 16, 250, "WalkSpeed")
CreateToggleSwitch(TabPlayer, "Bật Hack Nhảy Cao", "EnableJump")
CreateSlider(TabPlayer, "Lực Nhảy (JumpPower)", 50, 300, "JumpPower")
CreateToggleSwitch(TabPlayer, "Nhảy Vô Hạn (Infinity Jump)", "InfJump")
CreateToggleSwitch(TabPlayer, "Lướt Không Hồi Chiêu (Dash No CD)", "DashNoCD")
CreateToggleSwitch(TabPlayer, "🚀 Bay Tự Do (W,A,S,D + Space/Ctrl)", "FreeFly")
CreateSlider(TabPlayer, "Tốc Độ Bay Tự Do", 50, 500, "FreeFlySpeed")

-- --- TAB: MÁY QUÉT (NOTE & SCAN) ---
CreateDivider(TabScanner, "HỆ THỐNG MÁY QUÉT TOÀN MAP", Color3.fromRGB(200, 100, 255))
CreateToggleSwitch(TabScanner, "Bật Máy Quét Map Thông Minh", "AutoScanMap")

local ScanLogFrame = Instance.new("ScrollingFrame", TabScanner)
ScanLogFrame.Size = UDim2.new(1, 0, 0, 150); ScanLogFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ScanLogFrame.ScrollBarThickness = 3
local txtLog = Instance.new("TextLabel", ScanLogFrame)
txtLog.Size = UDim2.new(1, -10, 1, 0); txtLog.BackgroundTransparency = 1
txtLog.Text = "Dữ liệu trống..."; txtLog.TextColor3 = Color3.fromRGB(0, 255, 150)
txtLog.TextXAlignment = Enum.TextXAlignment.Left; txtLog.TextYAlignment = Enum.TextYAlignment.Top
txtLog.Font = Enum.Font.Code; txtLog.TextSize = 11; txtLog.TextWrapped = true
txtLog.Position = UDim2.new(0, 5, 0, 5)

CreateButton(TabScanner, "📋 COPY TOÀN BỘ DATA MÁY QUÉT", function()
    if setclipboard then
        setclipboard(txtLog.Text)
        game.StarterGui:SetCore("SendNotification", {Title = "Đã Copy", Text = "Dữ liệu đã nằm trong bộ nhớ tạm!", Duration = 3})
    end
end)

-- ==========================================
-- ENGINE LÕI (BẤM VẬT LÝ, TÌM KIẾM, TELEPORT)
-- ==========================================
local function PhysicalClick(guiObj)
    if not guiObj then return end
    local inset = GuiService:GetGuiInset()
    local center = guiObj.AbsolutePosition + (guiObj.AbsoluteSize / 2)
    VIM:SendMouseButtonEvent(center.X, center.Y + inset.Y, 0, true, game, 0)
    task.wait(0.05); VIM:SendMouseButtonEvent(center.X, center.Y + inset.Y, 0, false, game, 0)
end

local function TapScreenEdge()
    VIM:SendMouseButtonEvent(5, 50, 0, true, game, 0)
    task.wait(0.05); VIM:SendMouseButtonEvent(5, 50, 0, false, game, 0)
end

local function SmartFindButton(gui, searchText)
    for _, obj in pairs(gui:GetDescendants()) do
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            if obj:IsA("TextButton") and obj.Text and string.find(string.lower(obj.Text), string.lower(searchText)) then return obj end
            local txtChild = obj:FindFirstChildWhichIsA("TextLabel")
            if txtChild and txtChild.Text and string.find(string.lower(txtChild.Text), string.lower(searchText)) then return obj end
        end
    end
    return nil
end

local function SmartTeleport(targetPos)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    if (hrp.Position - targetPos).Magnitude > 50 then hrp.CFrame = CFrame.new(targetPos); task.wait(1.5) end
    return true
end

local function PressKey(key)
    VIM:SendKeyEvent(true, Enum.KeyCode[key], false, game)
    task.spawn(function() task.wait(0.05); VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game) end)
end

-- ==========================================
-- ENGINE: MÁY QUÉT MAP
-- ==========================================
local function GetClosestIsland(pos)
    local islandsFolder = Workspace:FindFirstChild("All") and Workspace.All:FindFirstChild("Island")
    if not islandsFolder then return "Unknown Island" end
    local closest = "Unknown Island"; local minDist = math.huge
    for _, isl in pairs(islandsFolder:GetChildren()) do
        local dist = (isl:GetPivot().Position - pos).Magnitude
        if dist < minDist then minDist = dist; closest = isl.Name end
    end
    return closest
end

task.spawn(function()
    while task.wait(2) do
        if not _G_V10.AutoScanMap then continue end
        local logString = "=== DANH SÁCH BOSS ===\n"
        
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(v) then
                local hrp = v:FindFirstChild("HumanoidRootPart")
                local hum = v:FindFirstChild("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local nameStr = v.Name
                    if not _G_ScannerData.Mobs[nameStr] then
                        local isl = GetClosestIsland(hrp.Position)
                        local pos = string.format("Vector3.new(%.0f, %.0f, %.0f)", hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
                        
                        -- Phân biệt Boss (Máu trên 50k là boss)
                        if hum.MaxHealth > 50000 then
                            _G_ScannerData.Bosses[nameStr] = {Island = isl, Pos = pos}
                        else
                            _G_ScannerData.Mobs[nameStr] = {Island = isl, Pos = pos}
                        end
                    end
                end
            end
        end
        
        for k, v in pairs(_G_ScannerData.Bosses) do logString = logString .. string.format("[ĐẢO: %s] | TÊN: %s | TỌA ĐỘ: %s\n", v.Island, k, v.Pos) end
        logString = logString .. "\n=== DANH SÁCH QUÁI THƯỜNG ===\n"
        for k, v in pairs(_G_ScannerData.Mobs) do logString = logString .. string.format("[ĐẢO: %s] | TÊN: %s | TỌA ĐỘ: %s\n", v.Island, k, v.Pos) end
        
        txtLog.Text = logString
        ScanLogFrame.CanvasSize = UDim2.new(0, 0, 0, txtLog.TextBounds.Y + 20)
    end
end)

-- ==========================================
-- ENGINE: AUTO BYPASS MAIN MENU
-- ==========================================
task.spawn(function()
    while task.wait(0.5) do
        if _G_V10.AutoBypassMenu then
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                local loadBtn = SmartFindButton(pg, "Load Data") or SmartFindButton(pg, "Load") or SmartFindButton(pg, "Accept")
                local playBtn = SmartFindButton(pg, "Play") or SmartFindButton(pg, "Join")
                
                if loadBtn then PhysicalClick(loadBtn) end
                if playBtn then PhysicalClick(playBtn) end
            end
        end
    end
end)

-- ==========================================
-- ENGINE: SPAM THOẠI CHO BOSS & SHADOW 
-- (LUÔN CHẠY KHI BẬT ĐỂ CHỐNG KẸT)
-- ==========================================
task.spawn(function()
    while task.wait(0.2) do
        if _G_V10.AutoSpawnMihawk or _G_V10.AutoGiveShadow then
            local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
            if talkingGui then TapScreenEdge() end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do 
        if not _G_V10.AutoSpawnMihawk then continue end
        if SmartTeleport(Vector3.new(-1380, 77, 3904)) then
            local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
            if not talkingGui then
                local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Stone Statue")
                if npc then task.spawn(function() pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end) end) end
            else
                local amtBtn = SmartFindButton(talkingGui, _G_V10.MihawkAmount)
                if amtBtn then PhysicalClick(amtBtn) end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if not _G_V10.AutoGiveShadow then continue end
        if SmartTeleport(Vector3.new(-10371, 100, -3519)) then
            local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
            if not talkingGui then
                local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Shadow 1")
                if npc then task.spawn(function() pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end) end) end
            else
                local itemBtn = SmartFindButton(talkingGui, _G_V10.ShadowItem)
                local amtBtn = SmartFindButton(talkingGui, _G_V10.ShadowAmount)
                if itemBtn then PhysicalClick(itemBtn) elseif amtBtn then PhysicalClick(amtBtn) end
            end
        end
    end
end)

-- ==========================================
-- ENGINE: MUA RAID & RE-RAID THÔNG MINH
-- ==========================================
local function IsRaidClear()
    local monsterFolder = Workspace:FindFirstChild("Monster")
    if not monsterFolder then return true end
    for _, v in pairs(monsterFolder:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then return false end
    end
    return true
end

local lastRaidTeleport = os.clock()
task.spawn(function()
    while task.wait(0.2) do
        if _G_V10.AutoJoinGame then
            pcall(function() ReplicatedStorage.Assets.Remote.RemoteEvent.Di:FireServer() end)
            pcall(function() ReplicatedStorage.Assets.Remote.RemoteEvent.Home:FireServer("Dark Castle", "Sea", true) end)
        end
        
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hrp or char.Humanoid.Health <= 0 then continue end
        
        local distToReRaid = (hrp.Position - Vector3.new(-123, 114, 407)).Magnitude
        
        if distToReRaid < 3000 then 
            if _G_V10.AutoStartRaid then pcall(function() ReplicatedStorage.Assets.Remote.RemoteEvent.Starto:FireServer() end) end
            if _G_V10.AutoBuyRaid then
                local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
                if not talkingGui then
                    local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Dazzl")
                    if npc then task.spawn(function() pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end) end) end
                else
                    local buyBtn = SmartFindButton(talkingGui, "Buy with Beli")
                    if buyBtn then PhysicalClick(buyBtn) else TapScreenEdge() end
                end
            end
            
            -- CHỈ TELEPORT KHI ĐÃ QUÉT SẠCH QUÁI TRONG RAID
            if _G_V10.AutoTeleReRaid and IsRaidClear() then
                if os.clock() - lastRaidTeleport >= _G_V10.RaidTeleportDelay then
                    hrp.CFrame = CFrame.new(-123, 114, 407); lastRaidTeleport = os.clock()
                end
            end
        else
            if _G_V10.AutoBuyRaid then
                local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
                if not talkingGui then
                    local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Dazzl")
                    if npc then task.spawn(function() pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end) end) end
                else
                    local buyBtn = SmartFindButton(talkingGui, "Buy with Beli")
                    if buyBtn then PhysicalClick(buyBtn) else TapScreenEdge() end
                end
            end
            
            if _G_V10.AutoTeleEntrance and os.clock() - lastRaidTeleport >= _G_V10.RaidTeleportDelay then
                hrp.CFrame = CFrame.new(-1346, 79, 3989); lastRaidTeleport = os.clock()
            end
        end
    end
end)

-- ==========================================
-- ENGINE: FARM LEVEL & WEAPON SWAP & SKILL
-- ==========================================
task.spawn(function()
    while task.wait(1) do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            if _G_V10.AutoHaki and not char:FindFirstChild("Haki") then PressKey("J") end
            if _G_V10.AutoKen then
                local kenNode = char:FindFirstChild("Ken")
                if not kenNode or (kenNode and kenNode:FindFirstChild("Close")) then PressKey("K") end
            end
        end
    end
end)

LocalPlayer.Idled:Connect(function()
    if _G_V10.AntiAFK then VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game); task.wait(0.5); VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game) end
end)

task.spawn(function()
    while task.wait(0.5) do
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum and not hum:GetAttribute("HooksAdded") then
                hum:SetAttribute("HooksAdded", true)
                hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function() if _G_V10.EnableSpeed then hum.WalkSpeed = _G_V10.WalkSpeed end end)
                hum:GetPropertyChangedSignal("JumpPower"):Connect(function() if _G_V10.EnableJump then hum.JumpPower = _G_V10.JumpPower end end)
            end
            if hum then
                if _G_V10.EnableSpeed then hum.WalkSpeed = _G_V10.WalkSpeed end
                if _G_V10.EnableJump then hum.UseJumpPower = true; hum.JumpPower = _G_V10.JumpPower end
            end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if _G_V10.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

local flyKeys = {W = 0, A = 0, S = 0, D = 0, Up = 0, Down = 0}
UIS.InputBegan:Connect(function(k, gp)
    if gp then return end
    if _G_V10.DashNoCD and k.KeyCode == Enum.KeyCode.Q then
        local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            local bv = Instance.new("BodyVelocity"); bv.MaxForce = Vector3.new(100000, 0, 100000); bv.Velocity = HRP.CFrame.lookVector * 150; bv.Parent = HRP
            game.Debris:AddItem(bv, 0.2)
        end
    end
    if k.KeyCode == Enum.KeyCode.W then flyKeys.W = 1 elseif k.KeyCode == Enum.KeyCode.S then flyKeys.S = 1 elseif k.KeyCode == Enum.KeyCode.A then flyKeys.A = 1 elseif k.KeyCode == Enum.KeyCode.D then flyKeys.D = 1 elseif k.KeyCode == Enum.KeyCode.Space then flyKeys.Up = 1 elseif k.KeyCode == Enum.KeyCode.LeftControl then flyKeys.Down = 1 end
end)
UIS.InputEnded:Connect(function(k, gp)
    if gp then return end
    if k.KeyCode == Enum.KeyCode.W then flyKeys.W = 0 elseif k.KeyCode == Enum.KeyCode.S then flyKeys.S = 0 elseif k.KeyCode == Enum.KeyCode.A then flyKeys.A = 0 elseif k.KeyCode == Enum.KeyCode.D then flyKeys.D = 0 elseif k.KeyCode == Enum.KeyCode.Space then flyKeys.Up = 0 elseif k.KeyCode == Enum.KeyCode.LeftControl then flyKeys.Down = 0 end
end)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        
        if _G_V10.AutoFarmLevel or _G_V10.ManualQuestFarm or _G_V10.AutoFarmFree or _G_V10.FarmAll or (_G_V10.AutoSea and _G_V10.IsFightingSea) or _G_V10.AutoStartRaid or _G_V10.AutoBuyRaid or _G_V10.AutoSpawnMihawk or _G_V10.AutoGiveShadow then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end

        if _G_V10.FreeFly then
            hum:ChangeState(Enum.HumanoidStateType.Physics)
            if not hrp:FindFirstChild("V10_FreeFlyBV") then
                local bv = Instance.new("BodyVelocity", hrp); bv.Name = "V10_FreeFlyBV"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            end
            if not hrp:FindFirstChild("V10_FreeFlyBG") then
                local bg = Instance.new("BodyGyro", hrp); bg.Name = "V10_FreeFlyBG"; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.P = 15000
            end
            local cam = workspace.CurrentCamera
            local moveVec = Vector3.new()
            moveVec = moveVec + cam.CFrame.LookVector * (flyKeys.W - flyKeys.S) + cam.CFrame.RightVector * (flyKeys.D - flyKeys.A) + Vector3.new(0, 1, 0) * (flyKeys.Up - flyKeys.Down)
            if moveVec.Magnitude > 0 then moveVec = moveVec.Unit end
            hrp["V10_FreeFlyBV"].Velocity = moveVec * _G_V10.FreeFlySpeed; hrp["V10_FreeFlyBG"].CFrame = cam.CFrame
        else
            if hrp:FindFirstChild("V10_FreeFlyBV") then hrp["V10_FreeFlyBV"]:Destroy() end
            if hrp:FindFirstChild("V10_FreeFlyBG") then hrp["V10_FreeFlyBG"]:Destroy() end
            if hum:GetState() == Enum.HumanoidStateType.Physics then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        end
    end
end)

local function EnableAntiFall(HRP)
    if not HRP:FindFirstChild("FarmAntiFall") then
        local AntiFall = Instance.new("BodyVelocity")
        AntiFall.Name = "FarmAntiFall"; AntiFall.MaxForce = Vector3.new(9e9, 9e9, 9e9); AntiFall.Velocity = Vector3.new(0, 0, 0); AntiFall.Parent = HRP
    end
end
local function DisableAntiFall(HRP) if HRP:FindFirstChild("FarmAntiFall") then HRP.FarmAntiFall:Destroy() end end

local function GetPlayerLevel()
    local lvl = 1
    pcall(function()
        if LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Level") then lvl = tonumber(LocalPlayer.leaderstats.Level.Value)
        elseif LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level") then lvl = tonumber(LocalPlayer.Data.Level.Value) end
    end)
    return lvl or 1
end

local function GetMobForCurrentLevel()
    local myLevel = GetPlayerLevel(); local targetMob = QuestDB[1].MobName; local targetQuest = QuestDB[1].QuestName
    for i = 1, #QuestDB do if myLevel >= QuestDB[i].Level then targetMob = QuestDB[i].MobName; targetQuest = QuestDB[i].QuestName end end
    return targetMob, targetQuest
end

local lastQuestTime = 0
local function RepeatQuestRemote()
    if os.clock() - lastQuestTime > 1 then
        lastQuestTime = os.clock()
        pcall(function() for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do if v:IsA("RemoteEvent") and v.Name == "Qu" then v:FireServer("Yes") end end end)
    end
end

local currentSwapState = 1
local lastSwapTime = os.clock()
local lastSkillSpamTime = os.clock()

task.spawn(function()
    while task.wait() do
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        local HRP = char.HumanoidRootPart

        _G_V10.CurrentTargetMob = nil
        if _G_V10.AutoFarmLevel then
            local mob, qName = GetMobForCurrentLevel(); _G_V10.CurrentTargetMob = {mob}; LblInfo.Text = "Farm Level: " .. qName
        elseif _G_V10.ManualQuestFarm and _G_V10.SelectedManualQuest then
            for _, v in pairs(QuestDB) do if v.QuestName == _G_V10.SelectedManualQuest then _G_V10.CurrentTargetMob = {v.MobName}; LblInfo.Text = "Farm Thủ Công: " .. v.QuestName end end
        elseif _G_V10.AutoFarmFree and type(_G_V10.SelectedMonsters) == "table" and #_G_V10.SelectedMonsters > 0 then
            _G_V10.CurrentTargetMob = _G_V10.SelectedMonsters; LblInfo.Text = "Đang Farm Tự Do"
        elseif _G_V10.FarmAll then LblInfo.Text = "Đang Càn Quét (Farm All)"
        else LblInfo.Text = "Đang rảnh rỗi..." end

        if _G_V10.AutoRepeatQuest then RepeatQuestRemote() end

        local isNormalFarming = _G_V10.AutoFarmLevel or _G_V10.ManualQuestFarm or _G_V10.AutoFarmFree or _G_V10.FarmAll
        local isFarmingAction = isNormalFarming or (_G_V10.AutoSea and _G_V10.IsFightingSea) or _G_V10.AutoStartRaid or _G_V10.AutoBuyRaid or _G_V10.AutoSpawnMihawk or _G_V10.AutoGiveShadow

        if isFarmingAction and not _G_V10.FreeFly then
            -- VŨ KHÍ CHỈ HOẠT ĐỘNG KHI ĐANG FARM
            if _G_V10.AutoSwapWeapon and _G_V10.PrimaryWeapon and _G_V10.SecondaryWeapon then
                if currentSwapState == 1 then
                    local wp = LocalPlayer.Backpack:FindFirstChild(_G_V10.PrimaryWeapon)
                    if wp then char.Humanoid:EquipTool(wp) end
                    if os.clock() - lastSwapTime >= _G_V10.HoldTime1 then currentSwapState = 2; lastSwapTime = os.clock() end
                elseif currentSwapState == 2 then
                    local wp = LocalPlayer.Backpack:FindFirstChild(_G_V10.SecondaryWeapon)
                    if wp then char.Humanoid:EquipTool(wp) end
                    if os.clock() - lastSwapTime >= _G_V10.HoldTime2 then currentSwapState = 1; lastSwapTime = os.clock() end
                end
            elseif _G_V10.AutoEquip and _G_V10.SelectedWeapon then
                local wp = LocalPlayer.Backpack:FindFirstChild(_G_V10.SelectedWeapon)
                if wp then char.Humanoid:EquipTool(wp) end
            end

            if _G_V10.AutoClick then
                local equippedTool = char:FindFirstChildWhichIsA("Tool")
                if equippedTool then equippedTool:Activate() end
            end
            
            if os.clock() - lastSkillSpamTime >= _G_V10.SkillSpamDelay then
                lastSkillSpamTime = os.clock()
                if _G_V10.AutoSwapWeapon then
                    local prefix = (currentSwapState == 1) and "W1_" or "W2_"
                    if _G_V10[prefix.."Z"] then PressKey("Z") end; if _G_V10[prefix.."X"] then PressKey("X") end
                    if _G_V10[prefix.."C"] then PressKey("C") end; if _G_V10[prefix.."V"] then PressKey("V") end
                    if _G_V10[prefix.."B"] then PressKey("B") end; if _G_V10[prefix.."F"] then PressKey("F") end
                elseif _G_V10.AutoSkill then
                    if _G_V10.Skill_Z then PressKey("Z") end; if _G_V10.Skill_X then PressKey("X") end
                    if _G_V10.Skill_C then PressKey("C") end; if _G_V10.Skill_V then PressKey("V") end
                    if _G_V10.Skill_F then PressKey("F") end
                end
            end
            
            EnableAntiFall(HRP)
            
            if isNormalFarming and not (_G_V10.AutoSea and _G_V10.IsFightingSea) then
                local targetMobInstance = nil
                local highestLevel = -1
                local shortestDist = math.huge
                
                -- ƯU TIÊN LEVEL CAO TRƯỚC
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(v) then
                        local isValidTarget = false
                        if _G_V10.FarmAll then
                            local isEx = false
                            for _, ex in pairs(_G_V10.ExcludedMobs) do if string.find(string.lower(v.Name), ex) then isEx = true break end end
                            if not isEx then isValidTarget = true end
                        elseif _G_V10.CurrentTargetMob and type(_G_V10.CurrentTargetMob) == "table" and table.find(_G_V10.CurrentTargetMob, v.Name) then 
                            isValidTarget = true 
                        end
                        
                        if isValidTarget then
                            local dist = (HRP.Position - v.HumanoidRootPart.Position).Magnitude
                            local lvlMatch = string.match(v.Name, "%[%D*(%d+)%]")
                            local mobLvl = lvlMatch and tonumber(lvlMatch) or 0
                            
                            if mobLvl > highestLevel then
                                highestLevel = mobLvl
                                shortestDist = dist
                                targetMobInstance = v
                            elseif mobLvl == highestLevel then
                                if dist < shortestDist then
                                    shortestDist = dist
                                    targetMobInstance = v
                                end
                            end
                        end
                    end
                end

                if targetMobInstance then
                    local mobPos = targetMobInstance.HumanoidRootPart.CFrame
                    local offset = CFrame.new(0, _G_V10.AttackDistance, 0) * CFrame.Angles(math.rad(-90),0,0)
                    if _G_V10.AttackPosition == "Đằng Sau" then offset = CFrame.new(0, 0, _G_V10.AttackDistance)
                    elseif _G_V10.AttackPosition == "Dưới Chân" then offset = CFrame.new(0, -_G_V10.AttackDistance, 0) end
                    
                    if shortestDist > 200 then InstantTeleport(mobPos * offset) else HRP.CFrame = mobPos * offset end
                end
            end
        else
            DisableAntiFall(HRP)
        end
    end
end)

-- ==========================================
-- ENGINE: SEA EVENT ĐỘC LẬP
-- ==========================================
local function GetTargetSeaEvent()
    local monsterFolder = workspace:FindFirstChild("Monster")
    if not monsterFolder then return nil end
    for _, v in pairs(monsterFolder:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local isSeaMonster = (v.Name == "Sea Monster")
            local isGhost = string.find(v.Name, "The Starving Ghost")
            if (isSeaMonster and _G_V10.HuntSeaMonster) or (isGhost and _G_V10.HuntGhost) then return v end
        end
    end
    return nil
end

local wasAutoSeaOn = false
task.spawn(function()
    while task.wait() do 
        if not _G_V10.AutoSea then 
            if wasAutoSeaOn then VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game); wasAutoSeaOn = false end
            LblSeaInfo.Text = "Trạng thái Biển: Đã tắt."; _G_V10.ArrivedAtZone = false; continue 
        else wasAutoSeaOn = true end
        
        local char = LocalPlayer.Character
        local HRP = char and char:FindFirstChild("HumanoidRootPart")
        local Hum = char and char:FindFirstChild("Humanoid")
        if not char or not HRP or not Hum or Hum.Health <= 0 then continue end

        local targetMonster = GetTargetSeaEvent()
        local myBoatName = LocalPlayer.Name .. "Boat"
        local boatFolder = workspace:FindFirstChild("Boats")
        local myBoat = boatFolder and boatFolder:FindFirstChild(myBoatName)

        if targetMonster then
            _G_V10.IsFightingSea = true; LblSeaInfo.Text = "Trạng thái Biển: Đang tiêu diệt " .. targetMonster.Name
            VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game)
            if Hum.Sit then Hum.Sit = false end
            
            if targetMonster.Name == "Sea Monster" then
                local radius = 25; local angle = tick() * 2
                local rootPos = targetMonster.HumanoidRootPart.Position
                HRP.CFrame = CFrame.new(rootPos + Vector3.new(math.cos(angle) * radius, 20, math.sin(angle) * radius), rootPos)
            else
                HRP.CFrame = targetMonster.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0) * CFrame.Angles(math.rad(-90),0,0)
            end
        else
            if _G_V10.IsFightingSea then _G_V10.IsFightingSea = false; VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game) end
            if not myBoat then
                _G_V10.ArrivedAtZone = false; LblSeaInfo.Text = "Trạng thái Biển: Đang mua thuyền mới..."
                local spawner = workspace:FindFirstChild("NPC") and workspace.NPC:FindFirstChild("BoatSpawner")
                if spawner and spawner:FindFirstChild("LowerTorso") then
                    HRP.CFrame = spawner.LowerTorso.CFrame * CFrame.new(0, 0, 4); task.wait(0.5)
                    pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(workspace.NPC.BoatSpawner, workspace.NPC.BoatSpawner, workspace.NPC.BoatSpawner) end); task.wait(1.5)
                end
            else
                local seat = myBoat:FindFirstChild("VehicleSeat", true)
                if seat then
                    if not _G_V10.ArrivedAtZone then
                        LblSeaInfo.Text = "Trạng thái Biển: Teleport thuyền ra biển 4 (1 Lần)..."
                        if Hum.Sit then Hum.Sit = false; task.wait(0.2) end
                        if myBoat:IsA("Model") and myBoat.PrimaryPart then myBoat:PivotTo(CFrame.new(_G_V10.SeaZone)) else seat.CFrame = CFrame.new(_G_V10.SeaZone) end
                        task.wait(0.3)
                        if _G_V10.AutoSitBoat then HRP.CFrame = seat.CFrame + Vector3.new(0, 3, 0); task.wait(0.1); seat:Sit(Hum) end
                        _G_V10.ArrivedAtZone = true 
                    else
                        LblSeaInfo.Text = "Trạng thái Biển: Đang Auto Drive vô tận..."
                        if _G_V10.AutoSitBoat and not Hum.Sit then HRP.CFrame = seat.CFrame; task.wait(0.1); seat:Sit(Hum) end
                        VIM:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                    end
                end
            end
        end
    end
end)
