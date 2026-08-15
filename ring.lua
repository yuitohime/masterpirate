-- ==========================================
-- DELTA UI V9 - TÍCH HỢP PLAYER, TELEPORT, MUSIC
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

local function GetSafeParent()
    local success, result = pcall(function() return gethui() end)
    if success and result then return result end
    return LocalPlayer:WaitForChild("PlayerGui")
end
local SafeParent = GetSafeParent()

if SafeParent:FindFirstChild("V9_DeltaUI_Max") then SafeParent["V9_DeltaUI_Max"]:Destroy() end

-- ==========================================
-- 📚 DATABASE NHIỆM VỤ
-- ==========================================
local QuestDB = {
    {Level = 1, QuestName = "Bandit [Lv. 1]", MobName = "Bandit", NPC = "Quest Giver"},
    {Level = 10, QuestName = "Naval Student [Lv. 10]", MobName = "Naval Rating Student", NPC = "Quest Giver"},
    {Level = 30, QuestName = "Pirate [Lv. 30]", MobName = "Pirate", NPC = "Quest Giver"},
}
local QuestListNames = {}
for i, v in ipairs(QuestDB) do table.insert(QuestListNames, v.QuestName) end

local _G_V9 = {
    -- Farm
    AutoFarmFree = false, FarmAll = false, SelectedMonsters = {}, ExcludedMobs = {"dummy", "test dmg", "testdmg"},
    AutoFarmLevel = false, ManualQuestFarm = false, SelectedManualQuest = nil, CurrentTargetMob = nil,
    AutoEquip = false, AutoClick = false, AutoSkill = false, AutoRepeatQuest = false,
    Skill_Z = false, Skill_X = false, Skill_C = false, Skill_V = false, Skill_F = false,
    SelectedWeapon = nil, SelectedFruit = nil,
    AttackPosition = "Trên Đầu", AttackDistance = 15, FlySpeed = 250,
    
    -- Player & World
    SelectedIsland = nil, IslandsList = {},
    EnableSpeed = false, WalkSpeed = 50,
    EnableJump = false, JumpPower = 100,
    InfJump = false, DashNoCD = false
}

-- ==========================================
-- GIAO DIỆN CHÍNH
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "V9_DeltaUI_Max"; ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 620, 0, 420); MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 200, 255)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35); TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
local FixCorner = Instance.new("Frame", TopBar)
FixCorner.Size = UDim2.new(1, 0, 0, 10); FixCorner.Position = UDim2.new(0, 0, 1, -10)
FixCorner.BackgroundColor3 = Color3.fromRGB(10, 10, 15); FixCorner.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.5, 0, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = "AUTO FARM V9 (Mega Update)"
Title.TextColor3 = Color3.fromRGB(0, 255, 255); Title.Font = Enum.Font.GothamBold
Title.TextSize = 16; Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 40, 0, 35); MinBtn.Position = UDim2.new(1, -80, 0, 0)
MinBtn.BackgroundTransparency = 1; MinBtn.Text = "-"; MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 24

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 40, 0, 35); CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 18

local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    MainFrame.Size = isMinimized and UDim2.new(0, 620, 0, 35) or UDim2.new(0, 620, 0, 420)
    for _, v in pairs(MainFrame:GetChildren()) do
        if v.Name == "TabsFrame" or v.Name == "ContentFrame" then v.Visible = not isMinimized end
    end
end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- CHUYỂN TABSFRAME THÀNH SCROLLING FRAME ĐỂ CHỨA NHIỀU TAB
local TabsFrame = Instance.new("ScrollingFrame", MainFrame)
TabsFrame.Name = "TabsFrame"; TabsFrame.Size = UDim2.new(0.28, 0, 1, -35); TabsFrame.Position = UDim2.new(0, 0, 0, 35)
TabsFrame.BackgroundTransparency = 1; TabsFrame.ScrollBarThickness = 2
TabsFrame.CanvasSize = UDim2.new(0, 0, 0, 400) -- Kéo dài để vuốt
Instance.new("UIListLayout", TabsFrame).Padding = UDim.new(0, 5)
Instance.new("UIPadding", TabsFrame).PaddingTop = UDim.new(0, 10)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Name = "ContentFrame"; ContentFrame.Size = UDim2.new(0.72, 0, 1, -35); ContentFrame.Position = UDim2.new(0.28, 0, 0, 35)
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); ContentFrame.BackgroundTransparency = 0.5
Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 8)

-- ==========================================
-- HÀM TẠO COMPONENTS UI
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
    Lbl.Size = UDim2.new(0.7, 0, 1, 0); Lbl.Position = UDim2.new(0, 10, 0, 0)
    Lbl.BackgroundTransparency = 1; Lbl.Text = text; Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    Lbl.Font = Enum.Font.Gotham; Lbl.TextSize = 13; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    local SwitchBG = Instance.new("TextButton", Frame)
    SwitchBG.Size = UDim2.new(0, 40, 0, 20); SwitchBG.Position = UDim2.new(1, -50, 0.5, -10)
    SwitchBG.BackgroundColor3 = Color3.fromRGB(100, 100, 100); SwitchBG.Text = ""
    Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)
    local Knob = Instance.new("Frame", SwitchBG)
    Knob.Size = UDim2.new(0, 16, 0, 16); Knob.Position = UDim2.new(0, 2, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    SwitchBG.MouseButton1Click:Connect(function()
        _G_V9[varName] = not _G_V9[varName]
        if _G_V9[varName] then
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
    Frame.Size = UDim2.new(1, 0, 0, 35); Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Frame.ClipsDescendants = true; Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local MainBtn = Instance.new("TextButton", Frame)
    MainBtn.Size = UDim2.new(1, 0, 0, 35); MainBtn.BackgroundTransparency = 1
    MainBtn.Text = "  " .. title .. " ▼"; MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainBtn.Font = Enum.Font.Gotham; MainBtn.TextSize = 13; MainBtn.TextXAlignment = Enum.TextXAlignment.Left
    local Drop = Instance.new("ScrollingFrame", Frame)
    Drop.Size = UDim2.new(1, 0, 0, 115); Drop.Position = UDim2.new(0, 0, 0, 35)
    Drop.BackgroundTransparency = 1; Drop.ScrollBarThickness = 2
    Instance.new("UIListLayout", Drop)

    MainBtn.MouseButton1Click:Connect(function()
        Frame.Size = Frame.Size.Y.Offset == 35 and UDim2.new(1, 0, 0, 150) or UDim2.new(1, 0, 0, 35)
    end)

    local function Refresh(newList)
        if newList then itemsList = newList end
        for _, v in pairs(Drop:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        for _, item in pairs(itemsList) do
            local Btn = Instance.new("TextButton", Drop)
            Btn.Size = UDim2.new(1, 0, 0, 30); Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            Btn.TextColor3 = Color3.fromRGB(200, 200, 200); Btn.Text = item
            Btn.Font = Enum.Font.Gotham; Btn.TextSize = 12
            Btn.MouseButton1Click:Connect(function()
                if multiSelect then
                    local idx = table.find(_G_V9[globalVar], item)
                    if idx then table.remove(_G_V9[globalVar], idx); Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                    else table.insert(_G_V9[globalVar], item); Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 150) end
                else
                    _G_V9[globalVar] = item
                    MainBtn.Text = "  " .. title .. ": " .. item
                    Frame.Size = UDim2.new(1, 0, 0, 35)
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
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Text = text
    Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 13
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
end

local function CreateSlider(parent, name, min, max, globalVar)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 45); Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(1, 0, 0, 20); Lbl.Position = UDim2.new(0, 5, 0, 0)
    Lbl.BackgroundTransparency = 1; Lbl.Text = name .. ": " .. _G_V9[globalVar]
    Lbl.TextColor3 = Color3.fromRGB(255, 255, 255); Lbl.Font = Enum.Font.Gotham; Lbl.TextSize = 13; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderBG = Instance.new("TextButton", Frame)
    SliderBG.Size = UDim2.new(0.95, 0, 0, 10); SliderBG.Position = UDim2.new(0.025, 0, 0, 25)
    SliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 65); SliderBG.Text = ""
    Instance.new("UICorner", SliderBG)
    local Fill = Instance.new("Frame", SliderBG)
    Fill.Size = UDim2.new((_G_V9[globalVar] - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    Instance.new("UICorner", Fill)

    local Dragging = false
    SliderBG.MouseButton1Down:Connect(function() Dragging = true end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = false end end)
    UIS.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(min + (max - min) * pos)
            _G_V9[globalVar] = val; Lbl.Text = name .. ": " .. val
        end
    end)
end

local function CreateTextBox(parent, placeholder, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 35); Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local TextBox = Instance.new("TextBox", Frame)
    TextBox.Size = UDim2.new(1, -10, 1, 0); TextBox.Position = UDim2.new(0, 5, 0, 0)
    TextBox.BackgroundTransparency = 1; TextBox.Text = ""
    TextBox.PlaceholderText = placeholder; TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
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
local TabSettings = CreateTab("⚙️ Cài Đặt")
local TabSkills = CreateTab("⚡ Kỹ Năng")
local TabFruit = CreateTab("🍎 Trái Cây")
local TabMusic = CreateTab("🎵 Âm Nhạc")
local TabStatus = CreateTab("📊 Trạng Thái")

Pages["🌟 Farm Level"].Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Pages["🌟 Farm Level"].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabAutoLevel.Visible = true

-- --- TAB: FARM LEVEL ---
local LblInfo = Instance.new("TextLabel", TabAutoLevel)
LblInfo.Size = UDim2.new(1, 0, 0, 20); LblInfo.BackgroundTransparency = 1
LblInfo.TextColor3 = Color3.fromRGB(255, 255, 100); LblInfo.Font = Enum.Font.Gotham; LblInfo.TextSize = 13; LblInfo.TextXAlignment = Enum.TextXAlignment.Left
LblInfo.Text = "Trạng thái: Đang chờ..."
CreateToggleSwitch(TabAutoLevel, "Bật Auto Farm Level (Tự Chuyển Bãi)", "AutoFarmLevel")
CreateDropdown(TabAutoLevel, "Chọn Quest Bằng Tay", QuestListNames, "SelectedManualQuest", false)
CreateToggleSwitch(TabAutoLevel, "Bật Đánh Quest Đã Chọn Trên", "ManualQuestFarm")
CreateToggleSwitch(TabAutoLevel, "Bật Lặp Lại Quest (Remote Qu)", "AutoRepeatQuest")
CreateToggleSwitch(TabAutoLevel, "Bật Tự Động Đánh (Click)", "AutoClick")

-- --- TAB: FARM TỰ DO ---
local DropMonsters = CreateDropdown(TabFreeFarm, "Chọn Quái (Multi-Select)", {}, "SelectedMonsters", true)
CreateButton(TabFreeFarm, "🔍 Quét Quái (Toàn bộ Map)", function()
    local mobs = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(v) then
            local isEx = false
            for _, ex in pairs(_G_V9.ExcludedMobs) do if string.find(string.lower(v.Name), ex) then isEx = true; break end end
            if not isEx and not table.find(mobs, v.Name) then table.insert(mobs, v.Name) end
        end
    end
    table.sort(mobs); DropMonsters(mobs)
end)
CreateToggleSwitch(TabFreeFarm, "Bật Free Farm (Quái đã chọn)", "AutoFarmFree")
CreateToggleSwitch(TabFreeFarm, "Bật Farm ALL (Càn quét Map)", "FarmAll")

-- --- TAB: ĐẢO & BAY (MỚI) ---
local DropIslands = CreateDropdown(TabIsland, "Chọn Đảo Để Bay", {}, "SelectedIsland", false)
CreateButton(TabIsland, "🔍 Quét Các Đảo Trên Map", function()
    local islands = {}
    -- Tìm các thư mục hoặc model chứa chữ Island/Town/Spawn
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") or v:IsA("Folder") or v:IsA("SpawnLocation") then
            local name = string.lower(v.Name)
            if string.find(name, "island") or string.find(name, "town") or string.find(name, "spawn") then
                if not table.find(islands, v.Name) then table.insert(islands, v.Name) end
            end
        end
    end
    table.sort(islands); DropIslands(islands)
end)
CreateButton(TabIsland, "🚀 Dịch Chuyển Tới Đảo", function()
    if not _G_V9.SelectedIsland then return end
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == _G_V9.SelectedIsland then
            local targetPart = v:IsA("Model") and v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart") or v
            if targetPart and targetPart:IsA("BasePart") then
                local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if HRP then HRP.CFrame = targetPart.CFrame + Vector3.new(0, 50, 0) end
            end
            break
        end
    end
end)
CreateSlider(TabIsland, "Tốc Độ Bay (Khi Auto Farm/Fruit)", 100, 500, "FlySpeed")

-- --- TAB: NHÂN VẬT (MỚI) ---
CreateToggleSwitch(TabPlayer, "Bật Hack Tốc Độ Chạy", "EnableSpeed")
CreateSlider(TabPlayer, "Tốc Độ Chạy (WalkSpeed)", 16, 250, "WalkSpeed")
CreateToggleSwitch(TabPlayer, "Bật Hack Nhảy Cao", "EnableJump")
CreateSlider(TabPlayer, "Lực Nhảy (JumpPower)", 50, 300, "JumpPower")
CreateToggleSwitch(TabPlayer, "Nhảy Vô Hạn (Infinity Jump)", "InfJump")
CreateToggleSwitch(TabPlayer, "Lướt Không Hồi Chiêu (Dash No CD)", "DashNoCD")

-- --- TAB: ÂM NHẠC (MỚI) ---
local MusicPlayer = Instance.new("Sound", game:GetService("CoreGui"))
MusicPlayer.Looped = true; MusicPlayer.Volume = 1
local inputMusicID = ""
CreateTextBox(TabMusic, "Nhập ID Nhạc (VD: 142376088)", function(text) inputMusicID = text end)
CreateButton(TabMusic, "▶️ Phát Nhạc", function()
    local id = string.match(inputMusicID, "%d+")
    if id then MusicPlayer.SoundId = "rbxassetid://" .. id; MusicPlayer:Play() end
end)
CreateButton(TabMusic, "⏸️ Dừng Nhạc", function() MusicPlayer:Stop() end)

-- --- TAB: SETTINGS & SKILLS ---
CreateDropdown(TabSettings, "Kiểu Đánh", {"Trên Đầu", "Đằng Sau", "Dưới Chân"}, "AttackPosition", false)
CreateSlider(TabSettings, "Khoảng Cách Đánh", 5, 40, "AttackDistance")
local DropWeapons = CreateDropdown(TabSettings, "Chọn Vũ Khí", {}, "SelectedWeapon", false)
CreateButton(TabSettings, "🎒 Quét Vũ Khí", function()
    local weps = {}
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(weps, v.Name) end end
    if LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("Tool") and not table.find(weps, v.Name) then table.insert(weps, v.Name) end end end
    DropWeapons(weps)
end)
CreateToggleSwitch(TabSettings, "Tự Động Cầm Vũ Khí", "AutoEquip")

CreateToggleSwitch(TabSkills, "Kích Hoạt Auto Skill", "AutoSkill")
CreateToggleSwitch(TabSkills, "Phím Z", "Skill_Z")
CreateToggleSwitch(TabSkills, "Phím X", "Skill_X")
CreateToggleSwitch(TabSkills, "Phím C", "Skill_C")
CreateToggleSwitch(TabSkills, "Phím V", "Skill_V")
CreateToggleSwitch(TabSkills, "Phím F", "Skill_F")

-- --- TAB: TRÁI CÂY & STATUS ---
local DropFruits = CreateDropdown(TabFruit, "Chọn Trái Cây", {}, "SelectedFruit", false)
CreateButton(TabFruit, "🍎 Quét Trái Cây", function()
    local fruits = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Model")) and (string.find(string.lower(v.Name), "fruit") or v:FindFirstChild("Handle")) then
            if not v.Parent:FindFirstChild("Humanoid") then if not table.find(fruits, v.Name) then table.insert(fruits, v.Name) end end
        end
    end
    DropFruits(fruits)
end)

local function TweenToTarget(targetCFrame)
    local HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    local time = (HRP.Position - targetCFrame.Position).Magnitude / _G_V9.FlySpeed
    local tween = TweenService:Create(HRP, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    local BV = Instance.new("BodyVelocity", HRP)
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9); BV.Velocity = Vector3.new(0, 0, 0)
    tween:Play(); tween.Completed:Wait(); BV:Destroy()
end
CreateButton(TabFruit, "🚀 Bay Đến Trái Đã Chọn", function()
    if not _G_V9.SelectedFruit then return end
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == _G_V9.SelectedFruit then
            local targetPart = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
            if targetPart then TweenToTarget(targetPart.CFrame) break end
        end
    end
end)
CreateButton(TabFruit, "📦 Lụm Tất Cả Trái (Auto)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Model")) and string.find(string.lower(v.Name), "fruit") and not v.Parent:FindFirstChild("Humanoid") then
            local targetPart = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
            if targetPart then TweenToTarget(targetPart.CFrame); task.wait(0.5) end
        end
    end
end)

local StatusFruitList = Instance.new("TextLabel", TabStatus)
StatusFruitList.Size = UDim2.new(1, 0, 1, 0); StatusFruitList.BackgroundTransparency = 1
StatusFruitList.TextColor3 = Color3.fromRGB(0, 255, 100); StatusFruitList.Font = Enum.Font.Gotham; StatusFruitList.TextSize = 13
StatusFruitList.TextXAlignment = Enum.TextXAlignment.Left; StatusFruitList.TextYAlignment = Enum.TextYAlignment.Top

task.spawn(function()
    while task.wait(3) do
        local foundFruits = {}
        for _, v in pairs(workspace:GetDescendants()) do
            if (v:IsA("Tool") or v:IsA("Model")) and string.find(string.lower(v.Name), "fruit") and not v.Parent:FindFirstChild("Humanoid") then
                table.insert(foundFruits, "🍎 " .. v.Name)
            end
        end
        if #foundFruits == 0 then StatusFruitList.Text = "Trạng thái Server:\nChưa tìm thấy trái nào trên map."
        else StatusFruitList.Text = "CÁC TRÁI CÂY ĐANG RƠI TRÊN MAP:\n\n" .. table.concat(foundFruits, "\n") end
    end
end)

-- ==========================================
-- ENGINE LÕI (PLAYER HACKS & AUTO FARM)
-- ==========================================

-- Infinity Jump (Nhảy vô hạn)
UIS.JumpRequest:Connect(function()
    if _G_V9.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Dash No CD (Lướt liên tục khi bấm phím Q)
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if _G_V9.DashNoCD and input.KeyCode == Enum.KeyCode.Q then
        local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(100000, 0, 100000)
            bv.Velocity = HRP.CFrame.lookVector * 150 -- Đẩy nhân vật lao mạnh về phía trước
            bv.Parent = HRP
            game.Debris:AddItem(bv, 0.2)
        end
    end
end)

-- Vòng lặp Hack Tốc độ / Nhảy / NoClip
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            if _G_V9.EnableSpeed then hum.WalkSpeed = _G_V9.WalkSpeed end
            if _G_V9.EnableJump then hum.UseJumpPower = true; hum.JumpPower = _G_V9.JumpPower end
        end
        if _G_V9.AutoFarmLevel or _G_V9.ManualQuestFarm or _G_V9.AutoFarmFree or _G_V9.FarmAll then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
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

local function PressKey(key)
    VIM:SendKeyEvent(true, Enum.KeyCode[key], false, game); task.wait(0.1)
    VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game)
end

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

        _G_V9.CurrentTargetMob = nil
        if _G_V9.AutoFarmLevel then
            local mob, qName = GetMobForCurrentLevel(); _G_V9.CurrentTargetMob = {mob}; LblInfo.Text = "Farm Level: " .. qName
        elseif _G_V9.ManualQuestFarm and _G_V9.SelectedManualQuest then
            for _, v in pairs(QuestDB) do if v.QuestName == _G_V9.SelectedManualQuest then _G_V9.CurrentTargetMob = {v.MobName}; LblInfo.Text = "Farm Thủ Công: " .. v.QuestName end end
        elseif _G_V9.AutoFarmFree and #_G_V9.SelectedMonsters > 0 then
            _G_V9.CurrentTargetMob = _G_V9.SelectedMonsters; LblInfo.Text = "Đang Farm Tự Do"
        elseif _G_V9.FarmAll then LblInfo.Text = "Đang Càn Quét (Farm All)"
        else LblInfo.Text = "Đang rảnh rỗi..." end

        if _G_V9.AutoRepeatQuest then RepeatQuestRemote() end
        if _G_V9.AutoEquip and _G_V9.SelectedWeapon then
            local wp = LocalPlayer.Backpack:FindFirstChild(_G_V9.SelectedWeapon)
            if wp then char.Humanoid:EquipTool(wp) end
        end

        local isFarming = _G_V9.AutoFarmLevel or _G_V9.ManualQuestFarm or _G_V9.AutoFarmFree or _G_V9.FarmAll
        if isFarming then
            if _G_V9.AutoClick then
                local equippedTool = char:FindFirstChildWhichIsA("Tool")
                if equippedTool then equippedTool:Activate() end
            end
            if _G_V9.AutoSkill then
                if _G_V9.Skill_Z then PressKey("Z") end; if _G_V9.Skill_X then PressKey("X") end
                if _G_V9.Skill_C then PressKey("C") end; if _G_V9.Skill_V then PressKey("V") end
                if _G_V9.Skill_F then PressKey("F") end
            end
            
            EnableAntiFall(HRP)
            local targetMobInstance, shortestDist = nil, math.huge
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(v) then
                    local isValidTarget = false
                    if _G_V9.FarmAll then
                        local isEx = false
                        for _, ex in pairs(_G_V9.ExcludedMobs) do if string.find(string.lower(v.Name), ex) then isEx = true break end end
                        if not isEx then isValidTarget = true end
                    elseif _G_V9.CurrentTargetMob and table.find(_G_V9.CurrentTargetMob, v.Name) then
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
                local offset = CFrame.new(0, _G_V9.AttackDistance, 0) * CFrame.Angles(math.rad(-90),0,0)
                if _G_V9.AttackPosition == "Đằng Sau" then offset = CFrame.new(0, 0, _G_V9.AttackDistance)
                elseif _G_V9.AttackPosition == "Dưới Chân" then offset = CFrame.new(0, -_G_V9.AttackDistance, 0) end
                HRP.CFrame = mobPos * offset
            end
        else
            DisableAntiFall(HRP)
        end
    end
end)
