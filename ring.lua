-- ==========================================
-- DELTA UI V14 - THE ABSOLUTE FINAL EDITION
-- (Giao diện hộp 2 cột + Nút Ẩn + Lõi V10 Full Chức Năng)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")

local function GetSafeParent()
    local success, result = pcall(function() return gethui() end)
    if success and result then return result end
    return LocalPlayer:WaitForChild("PlayerGui")
end
local SafeParent = GetSafeParent()
if SafeParent:FindFirstChild("V14_DeltaUI_Max") then SafeParent["V14_DeltaUI_Max"]:Destroy() end

-- ==========================================
-- 📚 DATABASE & BIẾN HỆ THỐNG
-- ==========================================
local QuestDB = {
    {Level = 1, QuestName = "Bandit [Lv. 1]", MobName = "Bandit", NPC = "Quest Giver"},
    {Level = 10, QuestName = "Naval Student [Lv. 10]", MobName = "Naval Rating Student", NPC = "Quest Giver"},
    {Level = 30, QuestName = "Pirate [Lv. 30]", MobName = "Pirate", NPC = "Quest Giver"},
}
local QuestListNames = {}
for i, v in ipairs(QuestDB) do table.insert(QuestListNames, v.QuestName) end

local IslandList = {
    "Amazonia", "Dark Castle", "Desert Island", "Enies Lobby", "Haunted Mansion", 
    "Island Of Greenery", "Island Of Darkness", "Mangroveland", "Marineford", 
    "Marksmanship Village", "Monkey Island", "Ocean Feast", "Orange Village", 
    "Red Centipede", "Rovaniemi Town", "Sakura Island", "SharkPark", "Shell Island", 
    "Shopland", "SkyPark", "Snow Island", "Snowy Mountain", "Starter Island", 
    "Territory", "Thriller Bark", "Tundra", "UnderWater Jail"
}

local _G_V14 = {
    -- Farm
    AutoFarmFree = false, FarmAll = false, SelectedMonsters = {}, ExcludedMobs = {"dummy", "test dmg", "testdmg"},
    AutoFarmLevel = false, ManualQuestFarm = false, SelectedManualQuest = nil, CurrentTargetMob = nil,
    AutoEquip = false, AutoClick = false, AutoSkill = false, AutoRepeatQuest = false,
    Skill_Z = false, Skill_X = false, Skill_C = false, Skill_V = false, Skill_F = false,
    SelectedWeapon = nil, SelectedFruit = nil, SelectedSpawnPoint = nil,
    AttackPosition = "Trên Đầu", AttackDistance = 15, FlySpeed = 250,
    -- Player & Server
    EnableSpeed = false, WalkSpeed = 50, EnableJump = false, JumpPower = 100, InfJump = false, DashNoCD = false,
    AutoSaveConfig = false, AntiAFK = false
}

-- ==========================================
-- HỆ THỐNG LƯU CẤU HÌNH (SAVE / LOAD)
-- ==========================================
local ConfigFolder = "DeltaV14_Configs"
if isfolder and not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local function SaveConfig(name)
    if not writefile then return end
    writefile(ConfigFolder.."/"..name..".json", HttpService:JSONEncode(_G_V14))
end
local function LoadConfig(name)
    if not readfile or not isfile(ConfigFolder.."/"..name..".json") then return end
    local decoded = HttpService:JSONDecode(readfile(ConfigFolder.."/"..name..".json"))
    for k, v in pairs(decoded) do _G_V14[k] = v end
end
local function GetConfigsList()
    local list = {}
    if listfiles and isfolder(ConfigFolder) then
        for _, file in pairs(listfiles(ConfigFolder)) do table.insert(list, file:match("([^/%\\]+)%.json$") or file) end
    end
    return list
end

-- ==========================================
-- GIAO DIỆN CHÍNH & NÚT ẨN BÊN NGOÀI
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "V14_DeltaUI_Max"; ScreenGui.ResetOnSpawn = false

-- NÚT BẬT TẮT MENU (HÌNH VUÔNG BÊN TRÁI)
local ToggleMenuBtn = Instance.new("TextButton", ScreenGui)
ToggleMenuBtn.Size = UDim2.new(0, 45, 0, 45); ToggleMenuBtn.Position = UDim2.new(0, 10, 0.5, -22)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255); ToggleMenuBtn.Text = "Mở"
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255); ToggleMenuBtn.Font = Enum.Font.GothamBold; ToggleMenuBtn.TextSize = 14
ToggleMenuBtn.Draggable = true; ToggleMenuBtn.Active = true
Instance.new("UICorner", ToggleMenuBtn).CornerRadius = UDim.new(0, 8)

-- BẢNG MENU CHÍNH
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 680, 0, 450); MainFrame.Position = UDim2.new(0.5, -340, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); MainFrame.BackgroundTransparency = 0.05
MainFrame.Active = true; MainFrame.Draggable = true; MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 200, 255)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35); TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
local FixCorner = Instance.new("Frame", TopBar)
FixCorner.Size = UDim2.new(1, 0, 0, 10); FixCorner.Position = UDim2.new(0, 0, 1, -10); FixCorner.BackgroundColor3 = Color3.fromRGB(10, 10, 15); FixCorner.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.5, 0, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = "AUTO FARM V14 (Ultimate Full Fix)"
Title.TextColor3 = Color3.fromRGB(0, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 16; Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 40, 0, 35); MinBtn.Position = UDim2.new(1, -80, 0, 0); MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"; MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 24

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 40, 0, 35); CloseBtn.Position = UDim2.new(1, -40, 0, 0); CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 18

-- Logic Nút Ẩn Hiện
ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleMenuBtn.Text = MainFrame.Visible and "Ẩn" or "Mở"
end)
MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleMenuBtn.Text = "Mở"
end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- CHIA 2 CỘT TABS
local TabsFrame = Instance.new("ScrollingFrame", MainFrame)
TabsFrame.Name = "TabsFrame"; TabsFrame.Size = UDim2.new(0.22, 0, 1, -35); TabsFrame.Position = UDim2.new(0, 0, 0, 35)
TabsFrame.BackgroundTransparency = 1; TabsFrame.ScrollBarThickness = 2; TabsFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
Instance.new("UIListLayout", TabsFrame).Padding = UDim.new(0, 5)
Instance.new("UIPadding", TabsFrame).PaddingTop = UDim.new(0, 10)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Name = "ContentFrame"; ContentFrame.Size = UDim2.new(0.78, 0, 1, -35); ContentFrame.Position = UDim2.new(0.22, 0, 0, 35)
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); ContentFrame.BackgroundTransparency = 0.5
Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 8)

-- ==========================================
-- HÀM TẠO UI BỐ CỤC HỘP
-- ==========================================
local Pages = {}
local function CreateTab(name)
    local Btn = Instance.new("TextButton", TabsFrame)
    Btn.Size = UDim2.new(1, -10, 0, 40); Btn.Position = UDim2.new(0, 5, 0, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Text = "  " .. name; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 13; Btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("Frame", ContentFrame)
    Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false

    local LeftCol = Instance.new("ScrollingFrame", Page)
    LeftCol.Size = UDim2.new(0.49, 0, 1, -20); LeftCol.Position = UDim2.new(0, 10, 0, 10)
    LeftCol.BackgroundTransparency = 1; LeftCol.ScrollBarThickness = 2
    Instance.new("UIListLayout", LeftCol).Padding = UDim.new(0, 10)

    local RightCol = Instance.new("ScrollingFrame", Page)
    RightCol.Size = UDim2.new(0.49, 0, 1, -20); RightCol.Position = UDim2.new(0.51, -10, 0, 10)
    RightCol.BackgroundTransparency = 1; RightCol.ScrollBarThickness = 2
    Instance.new("UIListLayout", RightCol).Padding = UDim.new(0, 10)

    Pages[name] = {Btn = Btn, Page = Page, Left = LeftCol, Right = RightCol}
    Btn.MouseButton1Click:Connect(function()
        for n, p in pairs(Pages) do
            p.Page.Visible = (n == name)
            p.Btn.BackgroundColor3 = (n == name) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(30, 30, 35)
            p.Btn.TextColor3 = (n == name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        end
    end)
    return LeftCol, RightCol
end

local function CreateGroupBox(parent, title)
    local Group = Instance.new("Frame", parent)
    Group.Size = UDim2.new(1, -5, 0, 200); Group.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Instance.new("UICorner", Group).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", Group).Color = Color3.fromRGB(50, 50, 60)
    local TitleLbl = Instance.new("TextLabel", Group)
    TitleLbl.Size = UDim2.new(1, 0, 0, 25); TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = "  " .. title; TitleLbl.TextColor3 = Color3.fromRGB(0, 200, 255); TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 13; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    local Container = Instance.new("Frame", Group)
    Container.Size = UDim2.new(1, 0, 1, -25); Container.Position = UDim2.new(0, 0, 0, 25); Container.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 5); Instance.new("UIPadding", Container).PaddingTop = UDim.new(0, 5)
    Layout.GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Group.Size = UDim2.new(1, -5, 0, Layout.AbsoluteContentSize.Y + 35) end)
    return Container
end

local function CreateToggleSwitch(parent, text, varName)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 35); Frame.Position = UDim2.new(0, 5, 0, 0); Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(0.7, 0, 1, 0); Lbl.Position = UDim2.new(0, 10, 0, 0); Lbl.BackgroundTransparency = 1
    Lbl.Text = text; Lbl.TextColor3 = Color3.fromRGB(255, 255, 255); Lbl.Font = Enum.Font.Gotham; Lbl.TextSize = 12; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    local SwitchBG = Instance.new("TextButton", Frame)
    SwitchBG.Size = UDim2.new(0, 36, 0, 18); SwitchBG.Position = UDim2.new(1, -45, 0.5, -9)
    SwitchBG.BackgroundColor3 = _G_V14[varName] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100); SwitchBG.Text = ""
    Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)
    local Knob = Instance.new("Frame", SwitchBG)
    Knob.Size = UDim2.new(0, 14, 0, 14); Knob.Position = _G_V14[varName] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    SwitchBG.MouseButton1Click:Connect(function()
        _G_V14[varName] = not _G_V14[varName]
        if _G_V14[varName] then
            SwitchBG.BackgroundColor3 = Color3.fromRGB(0, 200, 100); Knob:TweenPosition(UDim2.new(1, -16, 0.5, -7), "Out", "Quad", 0.2, true)
        else
            SwitchBG.BackgroundColor3 = Color3.fromRGB(100, 100, 100); Knob:TweenPosition(UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.2, true)
        end
    end)
end

local function CreateDropdown(parent, title, itemsList, globalVar, multiSelect)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 35); Frame.Position = UDim2.new(0, 5, 0, 0); Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40); Frame.ClipsDescendants = true
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local MainBtn = Instance.new("TextButton", Frame)
    MainBtn.Size = UDim2.new(1, 0, 0, 35); MainBtn.BackgroundTransparency = 1; MainBtn.Text = "  " .. title .. " ▼"
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MainBtn.Font = Enum.Font.Gotham; MainBtn.TextSize = 12; MainBtn.TextXAlignment = Enum.TextXAlignment.Left
    local Drop = Instance.new("ScrollingFrame", Frame)
    Drop.Size = UDim2.new(1, 0, 0, 100); Drop.Position = UDim2.new(0, 0, 0, 35); Drop.BackgroundTransparency = 1; Drop.ScrollBarThickness = 2
    Instance.new("UIListLayout", Drop)

    MainBtn.MouseButton1Click:Connect(function() Frame.Size = Frame.Size.Y.Offset == 35 and UDim2.new(1, -10, 0, 135) or UDim2.new(1, -10, 0, 35) end)

    local function Refresh(newList)
        if newList then itemsList = newList end
        for _, v in pairs(Drop:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        for _, item in pairs(itemsList) do
            local Btn = Instance.new("TextButton", Drop)
            Btn.Size = UDim2.new(1, 0, 0, 25); Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50); Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            Btn.Text = item; Btn.Font = Enum.Font.Gotham; Btn.TextSize = 11
            Btn.MouseButton1Click:Connect(function()
                if multiSelect then
                    local idx = table.find(_G_V14[globalVar], item)
                    if idx then table.remove(_G_V14[globalVar], idx); Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                    else table.insert(_G_V14[globalVar], item); Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 150) end
                else
                    _G_V14[globalVar] = item; MainBtn.Text = "  " .. title .. ": " .. item; Frame.Size = UDim2.new(1, -10, 0, 35)
                end
            end)
        end
        Drop.CanvasSize = UDim2.new(0, 0, 0, #itemsList * 25)
    end
    Refresh(itemsList); return Refresh
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -10, 0, 35); Btn.Position = UDim2.new(0, 5, 0, 0); Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Text = text; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
end

local function CreateSlider(parent, name, min, max, globalVar)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 45); Frame.Position = UDim2.new(0, 5, 0, 0); Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(1, 0, 0, 20); Lbl.Position = UDim2.new(0, 5, 0, 0); Lbl.BackgroundTransparency = 1
    Lbl.Text = name .. ": " .. _G_V14[globalVar]; Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    Lbl.Font = Enum.Font.Gotham; Lbl.TextSize = 12; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderBG = Instance.new("TextButton", Frame)
    SliderBG.Size = UDim2.new(0.95, 0, 0, 8); SliderBG.Position = UDim2.new(0.025, 0, 0, 25); SliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 65); SliderBG.Text = ""
    Instance.new("UICorner", SliderBG)
    local Fill = Instance.new("Frame", SliderBG)
    Fill.Size = UDim2.new((_G_V14[globalVar] - min)/(max - min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    Instance.new("UICorner", Fill)

    local Dragging = false
    SliderBG.MouseButton1Down:Connect(function() Dragging = true end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = false end end)
    UIS.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(min + (max - min) * pos)
            _G_V14[globalVar] = val; Lbl.Text = name .. ": " .. val
        end
    end)
end

local function CreateTextBox(parent, placeholder, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 35); Frame.Position = UDim2.new(0, 5, 0, 0); Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local TextBox = Instance.new("TextBox", Frame)
    TextBox.Size = UDim2.new(1, -10, 1, 0); TextBox.Position = UDim2.new(0, 5, 0, 0); TextBox.BackgroundTransparency = 1
    TextBox.Text = ""; TextBox.PlaceholderText = placeholder; TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.Font = Enum.Font.Gotham; TextBox.TextSize = 12; TextBox.ClearTextOnFocus = false
    TextBox.FocusLost:Connect(function() callback(TextBox.Text) end)
end

-- ==========================================
-- XÂY DỰNG TABS GOM NHÓM
-- ==========================================
local TabFarmL, TabFarmR = CreateTab("⚔️ Auto Farm")
local TabControlL, TabControlR = CreateTab("⚙️ Skill & Vũ Khí")
local TabPlayerL, TabPlayerR = CreateTab("🏃 Nhân Vật & Server")
local TabIslandL, TabIslandR = CreateTab("🏝️ Đảo & Trái Cây")

Pages["⚔️ Auto Farm"].Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Pages["⚔️ Auto Farm"].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Pages["⚔️ Auto Farm"].Page.Visible = true

-- --- TAB 1: AUTO FARM ---
local GrpFree = CreateGroupBox(TabFarmL, "Farm Tùy Chọn (Free Farm)")
local DropMonsters = CreateDropdown(GrpFree, "Chọn Quái (Multi)", {}, "SelectedMonsters", true)
CreateButton(GrpFree, "🔍 Quét Toàn Bộ Quái Map", function()
    local mobs = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(v) then
            local isEx = false
            for _, ex in pairs(_G_V14.ExcludedMobs) do if string.find(string.lower(v.Name), ex) then isEx = true; break end end
            if not isEx and not table.find(mobs, v.Name) then table.insert(mobs, v.Name) end
        end
    end
    table.sort(mobs); DropMonsters(mobs)
end)
CreateToggleSwitch(GrpFree, "Bật Farm Quái Đã Chọn", "AutoFarmFree")
CreateToggleSwitch(GrpFree, "Bật Farm ALL (Càn quét)", "FarmAll")

local GrpLevel = CreateGroupBox(TabFarmR, "Farm Theo Level & Quest")
local LblInfo = Instance.new("TextLabel", GrpLevel)
LblInfo.Size = UDim2.new(1, -10, 0, 20); LblInfo.Position = UDim2.new(0, 5, 0, 0); LblInfo.BackgroundTransparency = 1
LblInfo.TextColor3 = Color3.fromRGB(255, 255, 100); LblInfo.Font = Enum.Font.Gotham; LblInfo.TextSize = 12; LblInfo.TextXAlignment = Enum.TextXAlignment.Left
LblInfo.Text = "Mục tiêu: Đang chờ..."
CreateToggleSwitch(GrpLevel, "Bật Auto Farm Level", "AutoFarmLevel")
CreateDropdown(GrpLevel, "Chọn Quest Thủ Công", QuestListNames, "SelectedManualQuest", false)
CreateToggleSwitch(GrpLevel, "Bật Đánh Quest Đã Chọn", "ManualQuestFarm")

-- --- TAB 2: SKILL & VŨ KHÍ ---
local GrpSkill = CreateGroupBox(TabControlL, "Kỹ Năng (Auto Skill)")
CreateToggleSwitch(GrpSkill, "Kích Hoạt Dùng Skill", "AutoSkill")
CreateToggleSwitch(GrpSkill, "Phím Z", "Skill_Z"); CreateToggleSwitch(GrpSkill, "Phím X", "Skill_X")
CreateToggleSwitch(GrpSkill, "Phím C", "Skill_C"); CreateToggleSwitch(GrpSkill, "Phím V", "Skill_V"); CreateToggleSwitch(GrpSkill, "Phím F", "Skill_F")

local GrpSet = CreateGroupBox(TabControlR, "Cài Đặt Đánh & Trang Bị")
CreateToggleSwitch(GrpSet, "Tự Động Đánh (Auto Click)", "AutoClick")
CreateToggleSwitch(GrpSet, "Tự Nhận Quest (Remote Qu)", "AutoRepeatQuest")
CreateDropdown(GrpSet, "Kiểu Đánh", {"Trên Đầu", "Đằng Sau", "Dưới Chân"}, "AttackPosition", false)
CreateSlider(GrpSet, "Khoảng Cách Đánh", 5, 40, "AttackDistance")
local DropWeapons = CreateDropdown(GrpSet, "Chọn Vũ Khí", {}, "SelectedWeapon", false)
CreateButton(GrpSet, "🎒 Quét Vũ Khí", function()
    local weps = {}
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(weps, v.Name) end end
    if LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("Tool") and not table.find(weps, v.Name) then table.insert(weps, v.Name) end end end
    DropWeapons(weps)
end)
CreateToggleSwitch(GrpSet, "Tự Động Cầm Vũ Khí", "AutoEquip")

-- --- TAB 3: NHÂN VẬT & SERVER ---
local GrpSpeed = CreateGroupBox(TabPlayerL, "Di Chuyển Của Bạn")
CreateToggleSwitch(GrpSpeed, "Hack Tốc Độ Chạy (Speed)", "EnableSpeed")
CreateSlider(GrpSpeed, "Chỉnh Speed", 16, 250, "WalkSpeed")
CreateToggleSwitch(GrpSpeed, "Lướt Không Hồi Chiêu (Dash Q)", "DashNoCD")
CreateToggleSwitch(GrpSpeed, "Hack Nhảy Cao", "EnableJump")
CreateSlider(GrpSpeed, "Chỉnh Lực Nhảy", 50, 300, "JumpPower")
CreateToggleSwitch(GrpSpeed, "Nhảy Vô Hạn (Inf Jump)", "InfJump")

local GrpServer = CreateGroupBox(TabPlayerR, "Hệ Thống Server & Lưu Cấu Hình")
CreateToggleSwitch(GrpServer, "Bảo Vệ Chống Văng (Anti-AFK)", "AntiAFK")
CreateButton(GrpServer, "♻️ Rejoin (Vào Lại Server Cũ)", function() TPS:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
CreateButton(GrpServer, "🌐 Hop Server Ngẫu Nhiên", function()
    local req = request or http_request or syn.request
    if req then
        local res = req({Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"})
        local body = HttpService:JSONDecode(res.Body)
        if body and body.data then for _, v in ipairs(body.data) do if v.playing < v.maxPlayers and v.id ~= game.JobId then TPS:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer); break end end end
    end
end)
CreateButton(GrpServer, "📉 Hop Server Ít Người Nhất", function()
    local req = request or http_request or syn.request
    if req then
        local res = req({Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"})
        local body = HttpService:JSONDecode(res.Body)
        if body and body.data then for _, v in ipairs(body.data) do if v.playing < v.maxPlayers and v.playing > 0 and v.id ~= game.JobId then TPS:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer); break end end end
    end
end)
CreateButton(GrpServer, "🚀 Tối Ưu Hóa (Xóa Đồ Họa)", function()
    game.Lighting.GlobalShadows = false; game.Lighting.FogEnd = 9e9
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.Plastic; v.Reflectance = 0 end
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
end)
local ConfigNameInput = "Config_1"
local DropConfigs = CreateDropdown(GrpServer, "Chọn Bản Lưu", GetConfigsList(), "SelectedConfig", false)
CreateTextBox(GrpServer, "Nhập tên bản lưu mới", function(text) ConfigNameInput = text end)
CreateButton(GrpServer, "💾 Lưu Cấu Hình", function() SaveConfig(ConfigNameInput); DropConfigs(GetConfigsList()) end)
CreateButton(GrpServer, "📂 Tải Cấu Hình Đã Chọn", function() if _G_V14.SelectedConfig then LoadConfig(_G_V14.SelectedConfig) end end)

-- --- TAB 4: ĐẢO & TRÁI CÂY ---
local function TweenToSafe(targetCFrame)
    local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    local BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9); BV.Velocity = Vector3.new(0, 0, 0); BV.Parent = HRP
    local time = (HRP.Position - targetCFrame.Position).Magnitude / _G_V14.FlySpeed
    local tween = TweenService:Create(HRP, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = targetCFrame + Vector3.new(0, 5, 0)})
    tween:Play(); tween.Completed:Wait()
    HRP.Anchored = true; task.wait(0.5); HRP.Anchored = false; BV:Destroy()
end

local GrpIsland = CreateGroupBox(TabIslandL, "Đảo & Điểm Hồi Sinh")
CreateSlider(GrpIsland, "Tốc Độ Bay Dịch Chuyển", 100, 500, "FlySpeed")
for _, islandName in ipairs(IslandList) do
    CreateButton(GrpIsland, "🏝️ " .. islandName, function()
        local islandModel = workspace:FindFirstChild("Island") and workspace.Island:FindFirstChild(islandName)
        if islandModel then
            local part = islandModel:IsA("Model") and (islandModel.PrimaryPart or islandModel:FindFirstChildWhichIsA("BasePart")) or islandModel
            if part then TweenToSafe(part.CFrame) end
        end
    end)
end
CreateButton(GrpIsland, "=== ĐIỂM HỒI SINH (SPAWN) ===", function() end)
local function LoadSpawnPoints()
    if workspace:FindFirstChild("SetSpawnPoints") then
        for _, sp in pairs(workspace.SetSpawnPoints:GetChildren()) do CreateButton(GrpIsland, "📍 " .. sp.Name, function() TweenToSafe(sp.CFrame) end) end
    end
end
LoadSpawnPoints()

local GrpFruit = CreateGroupBox(TabIslandR, "Trái Cây Rơi Tự Do (Fruits)")
local DropFruits = CreateDropdown(GrpFruit, "Chọn Trái Cây", {}, "SelectedFruit", false)
CreateButton(GrpFruit, "🍎 Quét Trái Cây Toàn Map", function()
    local fruits = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Model")) and string.find(string.lower(v.Name), "fruit") and not v.Parent:FindFirstChild("Humanoid") then
            if not table.find(fruits, v.Name) then table.insert(fruits, v.Name) end
        end
    end
    DropFruits(fruits)
end)
CreateButton(GrpFruit, "🚀 Bay Đến Trái Đã Chọn", function()
    if not _G_V14.SelectedFruit then return end
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == _G_V14.SelectedFruit then
            local targetPart = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
            if targetPart then TweenToSafe(targetPart.CFrame) break end
        end
    end
end)
CreateButton(GrpFruit, "📦 Lụm Tất Cả Trái (Auto)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Model")) and string.find(string.lower(v.Name), "fruit") and not v.Parent:FindFirstChild("Humanoid") then
            local targetPart = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
            if targetPart then TweenToSafe(targetPart.CFrame); task.wait(0.5) end
        end
    end
end)

local StatusFruitList = Instance.new("TextLabel", GrpFruit)
StatusFruitList.Size = UDim2.new(1, -10, 0, 100); StatusFruitList.Position = UDim2.new(0, 5, 0, 0); StatusFruitList.BackgroundTransparency = 1
StatusFruitList.TextColor3 = Color3.fromRGB(0, 255, 100); StatusFruitList.Font = Enum.Font.Gotham; StatusFruitList.TextSize = 12
StatusFruitList.TextXAlignment = Enum.TextXAlignment.Left; StatusFruitList.TextYAlignment = Enum.TextYAlignment.Top; StatusFruitList.TextWrapped = true
task.spawn(function()
    while task.wait(3) do
        local foundFruits = {}
        for _, v in pairs(workspace:GetDescendants()) do
            if (v:IsA("Tool") or v:IsA("Model")) and string.find(string.lower(v.Name), "fruit") and not v.Parent:FindFirstChild("Humanoid") then table.insert(foundFruits, "🍎 " .. v.Name) end
        end
        if #foundFruits == 0 then StatusFruitList.Text = "Trạng thái Server:\nChưa tìm thấy trái nào rơi." else StatusFruitList.Text = "TRÁI ĐANG RƠI TRÊN MAP:\n" .. table.concat(foundFruits, "\n") end
    end
end)


-- ==========================================
-- ENGINE LÕI (HOẠT ĐỘNG CHUẨN 100% CỦA V10)
-- ==========================================
LocalPlayer.Idled:Connect(function()
    if _G_V14.AntiAFK then VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game); task.wait(0.5); VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game) end
end)

UIS.JumpRequest:Connect(function()
    if _G_V14.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if _G_V14.DashNoCD and input.KeyCode == Enum.KeyCode.Q then
        local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(100000, 0, 100000); bv.Velocity = HRP.CFrame.lookVector * 150; bv.Parent = HRP
            game.Debris:AddItem(bv, 0.2)
        end
    end
end)

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            if _G_V14.EnableSpeed then hum.WalkSpeed = _G_V14.WalkSpeed end
            if _G_V14.EnableJump then hum.UseJumpPower = true; hum.JumpPower = _G_V14.JumpPower end
        end
        if _G_V14.AutoFarmLevel or _G_V14.ManualQuestFarm or _G_V14.AutoFarmFree or _G_V14.FarmAll then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
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
local function PressKey(key) VIM:SendKeyEvent(true, Enum.KeyCode[key], false, game); task.wait(0.1); VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game) end

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

-- VÒNG LẶP AUTO FARM CHÍNH
task.spawn(function()
    while task.wait() do
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        local HRP = char.HumanoidRootPart

        _G_V14.CurrentTargetMob = nil
        if _G_V14.AutoFarmLevel then
            local mob, qName = GetMobForCurrentLevel(); _G_V14.CurrentTargetMob = {mob}; LblInfo.Text = "Farm Level: " .. qName
        elseif _G_V14.ManualQuestFarm and _G_V14.SelectedManualQuest then
            for _, v in pairs(QuestDB) do if v.QuestName == _G_V14.SelectedManualQuest then _G_V14.CurrentTargetMob = {v.MobName}; LblInfo.Text = "Farm Thủ Công: " .. v.QuestName end end
        elseif _G_V14.AutoFarmFree and #_G_V14.SelectedMonsters > 0 then
            _G_V14.CurrentTargetMob = _G_V14.SelectedMonsters; LblInfo.Text = "Đang Farm Tự Do"
        elseif _G_V14.FarmAll then LblInfo.Text = "Đang Càn Quét (Farm All)"
        else LblInfo.Text = "Đang rảnh rỗi..." end

        if _G_V14.AutoRepeatQuest then RepeatQuestRemote() end
        if _G_V14.AutoEquip and _G_V14.SelectedWeapon then
            local wp = LocalPlayer.Backpack:FindFirstChild(_G_V14.SelectedWeapon)
            if wp then char.Humanoid:EquipTool(wp) end
        end

        local isFarming = _G_V14.AutoFarmLevel or _G_V14.ManualQuestFarm or _G_V14.AutoFarmFree or _G_V14.FarmAll
        if isFarming then
            if _G_V14.AutoClick then
                local equippedTool = char:FindFirstChildWhichIsA("Tool")
                if equippedTool then equippedTool:Activate() end
            end
            if _G_V14.AutoSkill then
                if _G_V14.Skill_Z then PressKey("Z") end; if _G_V14.Skill_X then PressKey("X") end
                if _G_V14.Skill_C then PressKey("C") end; if _G_V14.Skill_V then PressKey("V") end
                if _G_V14.Skill_F then PressKey("F") end
            end
            
            EnableAntiFall(HRP)
            local targetMobInstance, shortestDist = nil, math.huge
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(v) then
                    local isValidTarget = false
                    if _G_V14.FarmAll then
                        local isEx = false
                        for _, ex in pairs(_G_V14.ExcludedMobs) do if string.find(string.lower(v.Name), ex) then isEx = true break end end
                        if not isEx then isValidTarget = true end
                    elseif _G_V14.CurrentTargetMob and table.find(_G_V14.CurrentTargetMob, v.Name) then
                        isValidTarget = true
                    end
                    if isValidTarget then
                        local dist = (HRP.Position - v.HumanoidRootPart.Position).Magnitude
                        if dist < shortestDist then shortestDist = dist; targetMobInstance = v end
                    end
                end
            end

            if targetMobInstance then
                local mobPos = targetMobInstance.HumanoidRootPart.CFrame
                local offset = CFrame.new(0, _G_V14.AttackDistance, 0) * CFrame.Angles(math.rad(-90),0,0)
                if _G_V14.AttackPosition == "Đằng Sau" then offset = CFrame.new(0, 0, _G_V14.AttackDistance)
                elseif _G_V14.AttackPosition == "Dưới Chân" then offset = CFrame.new(0, -_G_V14.AttackDistance, 0) end
                
                if shortestDist > 200 then
                    local BV = Instance.new("BodyVelocity")
                    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9); BV.Velocity = Vector3.new(0, 0, 0); BV.Parent = HRP
                    local time = shortestDist / _G_V14.FlySpeed
                    local tween = TweenService:Create(HRP, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = (mobPos * offset) + Vector3.new(0, 5, 0)})
                    tween:Play(); tween.Completed:Wait(); BV:Destroy()
                else 
                    HRP.CFrame = mobPos * offset 
                end
            end
        else
            DisableAntiFall(HRP)
        end
    end
end)
