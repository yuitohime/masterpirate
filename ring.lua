-- ==========================================
-- DELTA UI V10 - ULTIMATE (ORIGINAL UI + AUTO HAKI/KEN + FLY FIX)
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
if SafeParent:FindFirstChild("V10_DeltaUI_Max") then SafeParent["V10_DeltaUI_Max"]:Destroy() end

-- ==========================================
-- 📚 DATABASE
-- ==========================================
local QuestDB = {
    {Level = 1, QuestName = "Bandit [Lv. 1]", MobName = "Bandit", NPC = "Quest Giver"},
    {Level = 10, QuestName = "Naval Student [Lv. 10]", MobName = "Naval Rating Student", NPC = "Quest Giver"},
    {Level = 30, QuestName = "Pirate [Lv. 30]", MobName = "Pirate", NPC = "Quest Giver"},
}
local QuestListNames = {}
for i, v in ipairs(QuestDB) do table.insert(QuestListNames, v.QuestName) end

-- Danh sách đảo cố định từ ảnh
local IslandList = {
    "Amazonia", "Dark Castle", "Desert Island", "Enies Lobby", "Haunted Mansion", 
    "Island Of Greenery", "Island Of Darkness", "Mangroveland", "Marineford", 
    "Marksmanship Village", "Monkey Island", "Ocean Feast", "Orange Village", 
    "Red Centipede", "Rovaniemi Town", "Sakura Island", "SharkPark", "Shell Island", 
    "Shopland", "SkyPark", "Snow Island", "Snowy Mountain", "Starter Island", 
    "Territory", "Thriller Bark", "Tundra", "UnderWater Jail"
}

-- Biến toàn cục
local _G_V10 = {
    AutoFarmFree = false, FarmAll = false, SelectedMonsters = {}, ExcludedMobs = {"dummy", "test dmg", "testdmg"},
    AutoFarmLevel = false, ManualQuestFarm = false, SelectedManualQuest = nil, CurrentTargetMob = nil,
    AutoEquip = false, AutoClick = false, AutoSkill = false, AutoRepeatQuest = false,
    Skill_Z = false, Skill_X = false, Skill_C = false, Skill_V = false, Skill_F = false,
    AutoHaki = false, AutoKen = false,
    SelectedWeapon = nil, SelectedFruit = nil,
    AttackPosition = "Trên Đầu", AttackDistance = 15, FlySpeed = 250,
    SelectedIsland = nil, SelectedSpawnPoint = nil,
    EnableSpeed = false, WalkSpeed = 50, EnableJump = false, JumpPower = 100, InfJump = false, DashNoCD = false,
    FreeFly = false, FreeFlySpeed = 50,
    AutoSaveConfig = false, AntiAFK = false, SelectedConfig = nil
}

-- ==========================================
-- HỆ THỐNG LƯU CẤU HÌNH (SAVE / LOAD)
-- ==========================================
local ConfigFolder = "DeltaV10_Configs"
if isfolder and not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local function SaveConfig(name)
    if not writefile then return end
    local json = HttpService:JSONEncode(_G_V10)
    writefile(ConfigFolder.."/"..name..".json", json)
end

local function LoadConfig(name)
    if not readfile or not isfile(ConfigFolder.."/"..name..".json") then return end
    local decoded = HttpService:JSONDecode(readfile(ConfigFolder.."/"..name..".json"))
    for k, v in pairs(decoded) do _G_V10[k] = v end
end

local function GetConfigsList()
    local list = {}
    if listfiles and isfolder(ConfigFolder) then
        for _, file in pairs(listfiles(ConfigFolder)) do
            local name = file:match("([^/%\\]+)%.json$") or file
            table.insert(list, name)
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

-- NÚT VUÔNG BÊN TRÁI ĐỂ ẨN/HIỆN MENU
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -22)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.Text = "⚙️"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 22
ToggleBtn.Active = true
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(0, 200, 255)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
------------------------------------------------

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35); TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
local FixCorner = Instance.new("Frame", TopBar)
FixCorner.Size = UDim2.new(1, 0, 0, 10); FixCorner.Position = UDim2.new(0, 0, 1, -10); FixCorner.BackgroundColor3 = Color3.fromRGB(10, 10, 15); FixCorner.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.5, 0, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = "AUTO FARM V10 (Ultimate Edition)"
Title.TextColor3 = Color3.fromRGB(0, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 16; Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 40, 0, 35); MinBtn.Position = UDim2.new(1, -80, 0, 0); MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"; MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 24

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 40, 0, 35); CloseBtn.Position = UDim2.new(1, -40, 0, 0); CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 18

local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    MainFrame.Size = isMinimized and UDim2.new(0, 620, 0, 35) or UDim2.new(0, 620, 0, 420)
    for _, v in pairs(MainFrame:GetChildren()) do if v.Name == "TabsFrame" or v.Name == "ContentFrame" then v.Visible = not isMinimized end end
end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local TabsFrame = Instance.new("ScrollingFrame", MainFrame)
TabsFrame.Name = "TabsFrame"; TabsFrame.Size = UDim2.new(0.28, 0, 1, -35); TabsFrame.Position = UDim2.new(0, 0, 0, 35)
TabsFrame.BackgroundTransparency = 1; TabsFrame.ScrollBarThickness = 2; TabsFrame.CanvasSize = UDim2.new(0, 0, 0, 450)
Instance.new("UIListLayout", TabsFrame).Padding = UDim.new(0, 5)
Instance.new("UIPadding", TabsFrame).PaddingTop = UDim.new(0, 10)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Name = "ContentFrame"; ContentFrame.Size = UDim2.new(0.72, 0, 1, -35); ContentFrame.Position = UDim2.new(0.28, 0, 0, 35)
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); ContentFrame.BackgroundTransparency = 0.5
Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 8)

-- ==========================================
-- HÀM TẠO UI COMPONENTS
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

local function CreateToggleSwitch(parent, text, varName)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 40); Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(0.7, 0, 1, 0); Lbl.Position = UDim2.new(0, 10, 0, 0); Lbl.BackgroundTransparency = 1
    Lbl.Text = text; Lbl.TextColor3 = Color3.fromRGB(255, 255, 255); Lbl.Font = Enum.Font.Gotham; Lbl.TextSize = 13; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local SwitchBG = Instance.new("TextButton", Frame)
    SwitchBG.Size = UDim2.new(0, 40, 0, 20); SwitchBG.Position = UDim2.new(1, -50, 0.5, -10)
    SwitchBG.BackgroundColor3 = _G_V10[varName] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100); SwitchBG.Text = ""
    Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)
    local Knob = Instance.new("Frame", SwitchBG)
    Knob.Size = UDim2.new(0, 16, 0, 16); Knob.Position = _G_V10[varName] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    SwitchBG.MouseButton1Click:Connect(function()
        _G_V10[varName] = not _G_V10[varName]
        if _G_V10[varName] then
            SwitchBG.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            Knob:TweenPosition(UDim2.new(1, -18, 0.5, -8), "Out", "Quad", 0.2, true)
        else
            SwitchBG.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            Knob:TweenPosition(UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.2, true)
        end
    end)
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
    Instance.new("UIListLayout", Drop)

    MainBtn.MouseButton1Click:Connect(function() Frame.Size = Frame.Size.Y.Offset == 35 and UDim2.new(1, 0, 0, 150) or UDim2.new(1, 0, 0, 35) end)

    local function Refresh(newList)
        if newList then itemsList = newList end
        for _, v in pairs(Drop:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        for _, item in pairs(itemsList) do
            local Btn = Instance.new("TextButton", Drop)
            Btn.Size = UDim2.new(1, 0, 0, 30); Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50); Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            Btn.Text = item; Btn.Font = Enum.Font.Gotham; Btn.TextSize = 12
            Btn.MouseButton1Click:Connect(function()
                if multiSelect then
                    local idx = table.find(_G_V10[globalVar], item)
                    if idx then table.remove(_G_V10[globalVar], idx); Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                    else table.insert(_G_V10[globalVar], item); Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 150) end
                else
                    _G_V10[globalVar] = item; MainBtn.Text = "  " .. title .. ": " .. item; Frame.Size = UDim2.new(1, 0, 0, 35)
                end
            end)
        end
        Drop.CanvasSize = UDim2.new(0, 0, 0, #itemsList * 30)
    end
    Refresh(itemsList); return Refresh
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
    Fill.Size = UDim2.new((_G_V10[globalVar] - min)/(max - min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    Instance.new("UICorner", Fill)

    local Dragging = false
    SliderBG.MouseButton1Down:Connect(function() Dragging = true end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = false end end)
    UIS.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(min + (max - min) * pos)
            _G_V10[globalVar] = val; Lbl.Text = name .. ": " .. val
        end
    end)
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
local TabAutoLevel = CreateTab("🌟 Farm Level")
local TabFreeFarm = CreateTab("⚔️ Farm Tùy Chọn")
local TabIsland = CreateTab("🏝️ Đảo & Bay")
local TabPlayer = CreateTab("🏃 Nhân Vật")
local TabSettings = CreateTab("⚙️ Cài Đặt Chung")
local TabSkills = CreateTab("⚡ Kỹ Năng")
local TabFruit = CreateTab("🍎 Trái Cây")
local TabMusic = CreateTab("🎵 Âm Nhạc")
local TabServer = CreateTab("🌐 Server System")
local TabConfig = CreateTab("💾 Config (Save/Load)")

Pages["🌟 Farm Level"].Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Pages["🌟 Farm Level"].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabAutoLevel.Visible = true

-- --- TAB: FARM LEVEL ---
local LblInfo = Instance.new("TextLabel", TabAutoLevel)
LblInfo.Size = UDim2.new(1, 0, 0, 20); LblInfo.BackgroundTransparency = 1; LblInfo.TextColor3 = Color3.fromRGB(255, 255, 100)
LblInfo.Font = Enum.Font.Gotham; LblInfo.TextSize = 13; LblInfo.TextXAlignment = Enum.TextXAlignment.Left; LblInfo.Text = "Trạng thái: Đang chờ..."
CreateToggleSwitch(TabAutoLevel, "Bật Auto Farm Level (Tự Chuyển Bãi)", "AutoFarmLevel")
CreateDropdown(TabAutoLevel, "Chọn Quest Bằng Tay", QuestListNames, "SelectedManualQuest", false)
CreateToggleSwitch(TabAutoLevel, "Bật Đánh Quest Đã Chọn Trên", "ManualQuestFarm")
CreateToggleSwitch(TabAutoLevel, "Bật Tự Động Đánh (Click)", "AutoClick")

-- --- TAB: FARM TỰ DO ---
local DropMonsters = CreateDropdown(TabFreeFarm, "Chọn Quái (Multi-Select)", {}, "SelectedMonsters", true)
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
CreateToggleSwitch(TabFreeFarm, "Bật Free Farm (Quái đã chọn)", "AutoFarmFree")
CreateToggleSwitch(TabFreeFarm, "Bật Farm ALL (Càn quét Map)", "FarmAll")

-- --- TAB: ĐẢO & BAY ---
CreateDropdown(TabIsland, "Chọn Đảo (Island)", IslandList, "SelectedIsland", false)
local DropSpawnPoints = CreateDropdown(TabIsland, "Chọn Điểm Hồi Sinh (SetSpawnPoints)", {}, "SelectedSpawnPoint", false)
CreateButton(TabIsland, "🔄 Cập nhật danh sách Điểm Hồi Sinh", function()
    local sp = {}
    if workspace:FindFirstChild("SetSpawnPoints") then
        for _, v in pairs(workspace.SetSpawnPoints:GetChildren()) do table.insert(sp, v.Name) end
    end
    table.sort(sp); DropSpawnPoints(sp)
end)

-- Hàm Bay Fix Lỗi Rơi Nước (Bảo vệ tuyệt đối)
local function TweenToSafe(targetCFrame)
    local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    
    local safeY = math.max(targetCFrame.Y + 20, 100) 
    local BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9); BV.Velocity = Vector3.new(0, 0, 0); BV.Parent = HRP

    local time = (HRP.Position - targetCFrame.Position).Magnitude / _G_V10.FlySpeed
    local tween = TweenService:Create(HRP, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = targetCFrame + Vector3.new(0, 5, 0)})
    tween:Play(); tween.Completed:Wait()
    
    HRP.Anchored = true
    task.wait(0.5)
    HRP.Anchored = false
    BV:Destroy()
end

CreateButton(TabIsland, "🚀 Bay Đến Đảo / Điểm Hồi Sinh", function()
    if _G_V10.SelectedIsland then
        local island = workspace:FindFirstChild("Island") and workspace.Island:FindFirstChild(_G_V10.SelectedIsland)
        if island then
            local part = island:IsA("Model") and (island.PrimaryPart or island:FindFirstChildWhichIsA("BasePart")) or island
            if part then TweenToSafe(part.CFrame) end
        end
    elseif _G_V10.SelectedSpawnPoint then
        local sp = workspace:FindFirstChild("SetSpawnPoints") and workspace.SetSpawnPoints:FindFirstChild(_G_V10.SelectedSpawnPoint)
        if sp then TweenToSafe(sp.CFrame) end
    end
end)

-- --- TAB: NHÂN VẬT ---
CreateToggleSwitch(TabPlayer, "Bật Hack Tốc Độ Chạy", "EnableSpeed")
CreateSlider(TabPlayer, "Tốc Độ Chạy (WalkSpeed)", 16, 250, "WalkSpeed")
CreateToggleSwitch(TabPlayer, "Bật Hack Nhảy Cao", "EnableJump")
CreateSlider(TabPlayer, "Lực Nhảy (JumpPower)", 50, 300, "JumpPower")
CreateToggleSwitch(TabPlayer, "Nhảy Vô Hạn (Infinity Jump)", "InfJump")
CreateToggleSwitch(TabPlayer, "Lướt Không Hồi Chiêu (Dash No CD)", "DashNoCD")
-- (Thêm chức năng Free Fly)
CreateToggleSwitch(TabPlayer, "🚀 Bay Tự Do (W,A,S,D + Space/Ctrl)", "FreeFly")
CreateSlider(TabPlayer, "Tốc Độ Bay Tự Do", 50, 500, "FreeFlySpeed")

-- --- TAB: SETTINGS & SKILLS ---
CreateToggleSwitch(TabSettings, "Bật Lặp Lại Quest (Tự Nhận Remote Qu)", "AutoRepeatQuest")
CreateDropdown(TabSettings, "Kiểu Đánh", {"Trên Đầu", "Đằng Sau", "Dưới Chân"}, "AttackPosition", false)
CreateSlider(TabSettings, "Khoảng Cách Đánh", 5, 40, "AttackDistance")
CreateSlider(TabSettings, "Tốc Độ Bay Chung", 100, 500, "FlySpeed")
local DropWeapons = CreateDropdown(TabSettings, "Chọn Vũ Khí", {}, "SelectedWeapon", false)
CreateButton(TabSettings, "🎒 Quét Vũ Khí", function()
    local weps = {}
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(weps, v.Name) end end
    if LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("Tool") and not table.find(weps, v.Name) then table.insert(weps, v.Name) end end end
    DropWeapons(weps)
end)
CreateToggleSwitch(TabSettings, "Tự Động Cầm Vũ Khí", "AutoEquip")

-- (Thêm chức năng Auto Haki / Ken vào TabSkills)
CreateToggleSwitch(TabSkills, "🔥 Bật Tự Động Haki (Luôn Bật)", "AutoHaki")
CreateToggleSwitch(TabSkills, "👁️ Bật Tự Động Ken (Luôn Bật)", "AutoKen")

CreateToggleSwitch(TabSkills, "Kích Hoạt Auto Skill", "AutoSkill")
CreateToggleSwitch(TabSkills, "Phím Z", "Skill_Z"); CreateToggleSwitch(TabSkills, "Phím X", "Skill_X")
CreateToggleSwitch(TabSkills, "Phím C", "Skill_C"); CreateToggleSwitch(TabSkills, "Phím V", "Skill_V")
CreateToggleSwitch(TabSkills, "Phím F", "Skill_F")

-- --- TAB: CONFIG (LƯU CẤU HÌNH) ---
local ConfigNameInput = "Config_1"
local DropConfigs = CreateDropdown(TabConfig, "Chọn Bản Lưu", GetConfigsList(), "SelectedConfig", false)
CreateTextBox(TabConfig, "Nhập tên bản lưu (VD: Setup1)", function(text) ConfigNameInput = text end)
CreateButton(TabConfig, "💾 Lưu Bản Hiện Tại", function()
    SaveConfig(ConfigNameInput)
    DropConfigs(GetConfigsList())
end)
CreateButton(TabConfig, "📂 Tải (Load) Bản Đã Chọn", function()
    if _G_V10.SelectedConfig then LoadConfig(_G_V10.SelectedConfig) end
end)
CreateToggleSwitch(TabConfig, "Auto Lưu/Tải (Chưa khả dụng tùy thiết bị)", "AutoSaveConfig")

-- --- TAB: SERVER SYSTEM ---
CreateToggleSwitch(TabServer, "Bảo Vệ: Chống Văng (Anti-AFK 20 phút)", "AntiAFK")
CreateButton(TabServer, "♻️ Rejoin (Vào Lại Server Cũ)", function()
    TPS:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)
CreateButton(TabServer, "🌐 Hop Server (Đổi Server Khác)", function()
    local req = request or http_request or syn.request
    if req then
        local res = req({Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"})
        local body = HttpService:JSONDecode(res.Body)
        if body and body.data then
            for _, v in ipairs(body.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    TPS:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer); break
                end
            end
        end
    end
end)
CreateButton(TabServer, "📉 Hop Server Ít Người", function()
    local req = request or http_request or syn.request
    if req then
        local res = req({Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"})
        local body = HttpService:JSONDecode(res.Body)
        if body and body.data then
            for _, v in ipairs(body.data) do
                if v.playing < v.maxPlayers and v.playing > 0 and v.id ~= game.JobId then
                    TPS:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer); break
                end
            end
        end
    end
end)
CreateButton(TabServer, "🚀 Boost FPS (Xóa Đồ Họa Mượt Game)", function()
    game.Lighting.GlobalShadows = false
    game.Lighting.FogEnd = 9e9
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.Plastic; v.Reflectance = 0 end
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
end)

-- --- TAB: TRÁI CÂY, MUSIC ---
local DropFruits = CreateDropdown(TabFruit, "Chọn Trái Cây", {}, "SelectedFruit", false)
CreateButton(TabFruit, "🍎 Quét Trái Cây", function()
    local fruits = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Model")) and string.find(string.lower(v.Name), "fruit") and not v.Parent:FindFirstChild("Humanoid") then
            if not table.find(fruits, v.Name) then table.insert(fruits, v.Name) end
        end
    end
    DropFruits(fruits)
end)
CreateButton(TabFruit, "🚀 Bay Đến Trái Đã Chọn", function()
    if not _G_V10.SelectedFruit then return end
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == _G_V10.SelectedFruit then
            local targetPart = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
            if targetPart then TweenToSafe(targetPart.CFrame) break end
        end
    end
end)
CreateButton(TabFruit, "📦 Lụm Tất Cả Trái", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Model")) and string.find(string.lower(v.Name), "fruit") and not v.Parent:FindFirstChild("Humanoid") then
            local targetPart = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
            if targetPart then TweenToSafe(targetPart.CFrame); task.wait(0.5) end
        end
    end
end)

local MusicPlayer = Instance.new("Sound", game:GetService("CoreGui"))
MusicPlayer.Looped = true; MusicPlayer.Volume = 1
local inputMusicID = ""
CreateTextBox(TabMusic, "Nhập ID Nhạc (VD: 142376088)", function(text) inputMusicID = text end)
CreateButton(TabMusic, "▶️ Phát Nhạc", function() local id = string.match(inputMusicID, "%d+"); if id then MusicPlayer.SoundId = "rbxassetid://"..id; MusicPlayer:Play() end end)
CreateButton(TabMusic, "⏸️ Dừng Nhạc", function() MusicPlayer:Stop() end)

-- ==========================================
-- ENGINE LÕI
-- ==========================================

-- AUTO HAKI / KEN (Gửi Remote liên tục mỗi 2s để luôn giữ trạng thái BẬT, quét sâu vào ReplicatedStorage)
task.spawn(function()
    while task.wait(2) do
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("Humanoid") then continue end
        if char.Humanoid.Health <= 0 then continue end
        
        pcall(function()
            if _G_V10.AutoHaki then
                for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                    if v:IsA("RemoteEvent") and v.Name == "Haki" then
                        v:FireServer("GTS", true, nil, true)
                    end
                end
            end
            
            if _G_V10.AutoKen then
                for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                    if v:IsA("RemoteEvent") then
                        if v.Name == "Ken" then
                            v:FireServer("GTS", true, nil, true)
                        elseif v.Name == "MainRemote" then
                            v:FireServer("Ken", true)
                        end
                    end
                end
            end
        end)
    end
end)

-- ANTI AFK MẠNH MẼ (Chống văng 20 phút)
LocalPlayer.Idled:Connect(function()
    if _G_V10.AntiAFK then
        VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.5)
        VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end
end)

-- FIX TỐC ĐỘ VÀ NHẢY CAO (Bypass chống Game Override)
task.spawn(function()
    while task.wait(0.5) do
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum and not hum:GetAttribute("HooksAdded") then
                hum:SetAttribute("HooksAdded", true)
                hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                    if _G_V10.EnableSpeed then hum.WalkSpeed = _G_V10.WalkSpeed end
                end)
                hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
                    if _G_V10.EnableJump then hum.JumpPower = _G_V10.JumpPower end
                end)
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

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if _G_V10.DashNoCD and input.KeyCode == Enum.KeyCode.Q then
        local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(100000, 0, 100000); bv.Velocity = HRP.CFrame.lookVector * 150; bv.Parent = HRP
            game.Debris:AddItem(bv, 0.2)
        end
    end
end)

-- LÕI BAY TỰ DO (ĐÃ FIX LỖI ĐỨNG ĐƠ SAU KHI TẮT BAY BẰNG GETTINGUP STATE)
local flyKeys = {W = 0, A = 0, S = 0, D = 0, Up = 0, Down = 0}
UIS.InputBegan:Connect(function(k, gp)
    if gp then return end
    if k.KeyCode == Enum.KeyCode.W then flyKeys.W = 1
    elseif k.KeyCode == Enum.KeyCode.S then flyKeys.S = 1
    elseif k.KeyCode == Enum.KeyCode.A then flyKeys.A = 1
    elseif k.KeyCode == Enum.KeyCode.D then flyKeys.D = 1
    elseif k.KeyCode == Enum.KeyCode.Space then flyKeys.Up = 1
    elseif k.KeyCode == Enum.KeyCode.LeftControl then flyKeys.Down = 1 end
end)
UIS.InputEnded:Connect(function(k, gp)
    if gp then return end
    if k.KeyCode == Enum.KeyCode.W then flyKeys.W = 0
    elseif k.KeyCode == Enum.KeyCode.S then flyKeys.S = 0
    elseif k.KeyCode == Enum.KeyCode.A then flyKeys.A = 0
    elseif k.KeyCode == Enum.KeyCode.D then flyKeys.D = 0
    elseif k.KeyCode == Enum.KeyCode.Space then flyKeys.Up = 0
    elseif k.KeyCode == Enum.KeyCode.LeftControl then flyKeys.Down = 0 end
end)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        
        if _G_V10.AutoFarmLevel or _G_V10.ManualQuestFarm or _G_V10.AutoFarmFree or _G_V10.FarmAll then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end

        if _G_V10.FreeFly then
            hum:ChangeState(Enum.HumanoidStateType.Physics) -- Dùng State vật lý thả nổi
            if not hrp:FindFirstChild("V10_FreeFlyBV") then
                local bv = Instance.new("BodyVelocity", hrp)
                bv.Name = "V10_FreeFlyBV"
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            end
            if not hrp:FindFirstChild("V10_FreeFlyBG") then
                local bg = Instance.new("BodyGyro", hrp)
                bg.Name = "V10_FreeFlyBG"
                bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.P = 15000
            end
            
            local cam = workspace.CurrentCamera
            local moveVec = Vector3.new()
            moveVec = moveVec + cam.CFrame.LookVector * (flyKeys.W - flyKeys.S)
            moveVec = moveVec + cam.CFrame.RightVector * (flyKeys.D - flyKeys.A)
            moveVec = moveVec + Vector3.new(0, 1, 0) * (flyKeys.Up - flyKeys.Down)
            
            if moveVec.Magnitude > 0 then moveVec = moveVec.Unit end
            hrp["V10_FreeFlyBV"].Velocity = moveVec * _G_V10.FreeFlySpeed
            hrp["V10_FreeFlyBG"].CFrame = cam.CFrame
        else
            if hrp:FindFirstChild("V10_FreeFlyBV") then hrp["V10_FreeFlyBV"]:Destroy() end
            if hrp:FindFirstChild("V10_FreeFlyBG") then hrp["V10_FreeFlyBG"]:Destroy() end
            if hum:GetState() == Enum.HumanoidStateType.Physics then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp) -- Chuyển lại trạng thái bình thường để ko bị đơ
            end
        end
    end
end)

local function EnableAntiFall(HRP)
    if not HRP:FindFirstChild("FarmAntiFall") then
        local AntiFall = Instance.new("BodyVelocity")
        AntiFall.Name = "FarmAntiFall"; AntiFall.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        AntiFall.Velocity = Vector3.new(0, 0, 0); AntiFall.Parent = HRP
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

        _G_V10.CurrentTargetMob = nil
        if _G_V10.AutoFarmLevel then
            local mob, qName = GetMobForCurrentLevel(); _G_V10.CurrentTargetMob = {mob}; LblInfo.Text = "Farm Level: " .. qName
        elseif _G_V10.ManualQuestFarm and _G_V10.SelectedManualQuest then
            for _, v in pairs(QuestDB) do if v.QuestName == _G_V10.SelectedManualQuest then _G_V10.CurrentTargetMob = {v.MobName}; LblInfo.Text = "Farm Thủ Công: " .. v.QuestName end end
        elseif _G_V10.AutoFarmFree and #_G_V10.SelectedMonsters > 0 then
            _G_V10.CurrentTargetMob = _G_V10.SelectedMonsters; LblInfo.Text = "Đang Farm Tự Do"
        elseif _G_V10.FarmAll then LblInfo.Text = "Đang Càn Quét (Farm All)"
        else LblInfo.Text = "Đang rảnh rỗi..." end

        if _G_V10.AutoRepeatQuest then RepeatQuestRemote() end
        if _G_V10.AutoEquip and _G_V10.SelectedWeapon then
            local wp = LocalPlayer.Backpack:FindFirstChild(_G_V10.SelectedWeapon)
            if wp then char.Humanoid:EquipTool(wp) end
        end

        local isFarming = _G_V10.AutoFarmLevel or _G_V10.ManualQuestFarm or _G_V10.AutoFarmFree or _G_V10.FarmAll
        if isFarming and not _G_V10.FreeFly then
            if _G_V10.AutoClick then
                local equippedTool = char:FindFirstChildWhichIsA("Tool")
                if equippedTool then equippedTool:Activate() end
            end
            if _G_V10.AutoSkill then
                if _G_V10.Skill_Z then PressKey("Z") end; if _G_V10.Skill_X then PressKey("X") end
                if _G_V10.Skill_C then PressKey("C") end; if _G_V10.Skill_V then PressKey("V") end
                if _G_V10.Skill_F then PressKey("F") end
            end
            
            EnableAntiFall(HRP)
            local targetMobInstance, shortestDist = nil, math.huge
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(v) then
                    local isValidTarget = false
                    if _G_V10.FarmAll then
                        local isEx = false
                        for _, ex in pairs(_G_V10.ExcludedMobs) do if string.find(string.lower(v.Name), ex) then isEx = true break end end
                        if not isEx then isValidTarget = true end
                    elseif _G_V10.CurrentTargetMob and table.find(_G_V10.CurrentTargetMob, v.Name) then
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
                local offset = CFrame.new(0, _G_V10.AttackDistance, 0) * CFrame.Angles(math.rad(-90),0,0)
                if _G_V10.AttackPosition == "Đằng Sau" then offset = CFrame.new(0, 0, _G_V10.AttackDistance)
                elseif _G_V10.AttackPosition == "Dưới Chân" then offset = CFrame.new(0, -_G_V10.AttackDistance, 0) end
                
                if shortestDist > 200 then TweenToSafe(mobPos * offset)
                else HRP.CFrame = mobPos * offset end
            end
        else
            DisableAntiFall(HRP)
        end
    end
end)
