-- ==========================================
-- DELTA UI V3 - SUPER SMOOTH & FULL FEATURES
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

-- Vùng an toàn của Delta
local function GetSafeParent()
    local success, result = pcall(function() return gethui() end)
    if success and result then return result end
    return LocalPlayer:WaitForChild("PlayerGui")
end
local SafeParent = GetSafeParent()

if SafeParent:FindFirstChild("V3_DeltaUI_Max") then SafeParent["V3_DeltaUI_Max"]:Destroy() end

-- Cấu hình hệ thống
local _G_V3 = {
    AutoFarm = false, AutoEquip = false, AutoClick = false, AutoSkill = false,
    Skill_Z = false, Skill_X = false, Skill_C = false, Skill_V = false, Skill_F = false,
    SelectedMonsters = {}, SelectedWeapon = nil, SelectedFruit = nil,
    AttackPosition = "Trên Đầu", AttackDistance = 15, FlySpeed = 250,
    MonstersList = {}, WeaponsList = {}, FruitsList = {}
}

-- ==========================================
-- TẠO GIAO DIỆN (Bo tròn, Menu Trái, Nút X/-)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "V3_DeltaUI_Max"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = SafeParent

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
MainFrame.Parent = ScreenGui

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 150, 255)
Stroke.Thickness = 2

-- TOP BAR (Tiêu đề & Nút tắt)
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
local FixCorner = Instance.new("Frame", TopBar)
FixCorner.Size = UDim2.new(1, 0, 0, 10)
FixCorner.Position = UDim2.new(0, 0, 1, -10)
FixCorner.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
FixCorner.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "AUTO FARM V3 (Max Option)"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 40, 0, 35)
MinBtn.Position = UDim2.new(1, -80, 0, 0)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 24

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 40, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18

local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    MainFrame.Size = isMinimized and UDim2.new(0, 600, 0, 35) or UDim2.new(0, 600, 0, 400)
    MainFrame:FindFirstChild("TabsFrame").Visible = not isMinimized
    MainFrame:FindFirstChild("ContentFrame").Visible = not isMinimized
end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- CHIA CỘT (Tabs Trái, Nội dung Phải)
local TabsFrame = Instance.new("Frame", MainFrame)
TabsFrame.Name = "TabsFrame"
TabsFrame.Size = UDim2.new(0.25, 0, 1, -35)
TabsFrame.Position = UDim2.new(0, 0, 0, 35)
TabsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TabsFrame.BorderSizePixel = 0
Instance.new("UIListLayout", TabsFrame).Padding = UDim.new(0, 5)
Instance.new("UIPadding", TabsFrame).PaddingTop = UDim.new(0, 10)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(0.75, 0, 1, -35)
ContentFrame.Position = UDim2.new(0.25, 0, 0, 35)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ContentFrame.BorderSizePixel = 0
Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 8)

-- ==========================================
-- HÀM TẠO UI CƠ BẢN
-- ==========================================
local Pages = {}
local function CreateTab(name)
    local Btn = Instance.new("TextButton", TabsFrame)
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.Position = UDim2.new(0, 5, 0, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Text = name
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("ScrollingFrame", ContentFrame)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    Page.Visible = false
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    local pad = Instance.new("UIPadding", Page)
    pad.PaddingTop, pad.PaddingLeft, pad.PaddingRight, pad.PaddingBottom = UDim.new(0,10), UDim.new(0,10), UDim.new(0,10), UDim.new(0,10)

    Pages[name] = {Btn = Btn, Page = Page}
    Btn.MouseButton1Click:Connect(function()
        for n, p in pairs(Pages) do
            p.Page.Visible = (n == name)
            p.Btn.BackgroundColor3 = (n == name) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 45)
            p.Btn.TextColor3 = (n == name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        end
    end)
    return Page
end

local function CreateToggle(parent, text, varName)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(0.7, 0, 1, 0)
    Lbl.Position = UDim2.new(0, 10, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text
    Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 14
    Lbl.TextXAlignment = Enum.TextXAlignment.Left

    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(0.25, 0, 0, 25)
    Btn.Position = UDim2.new(0.7, 0, 0.5, -12.5)
    Btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Text = "TẮT"
    Btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    Btn.MouseButton1Click:Connect(function()
        _G_V3[varName] = not _G_V3[varName]
        Btn.BackgroundColor3 = _G_V3[varName] and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        Btn.Text = _G_V3[varName] and "BẬT" or "TẮT"
    end)
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Text = text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
end

local function CreateDropdown(parent, title, itemsList, globalVar, multiSelect)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Frame.ClipsDescendants = true
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local MainBtn = Instance.new("TextButton", Frame)
    MainBtn.Size = UDim2.new(1, 0, 0, 35)
    MainBtn.BackgroundTransparency = 1
    MainBtn.Text = "  " .. title .. " ▼"
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainBtn.Font = Enum.Font.Gotham
    MainBtn.TextSize = 14
    MainBtn.TextXAlignment = Enum.TextXAlignment.Left

    local Drop = Instance.new("ScrollingFrame", Frame)
    Drop.Size = UDim2.new(1, 0, 0, 115)
    Drop.Position = UDim2.new(0, 0, 0, 35)
    Drop.BackgroundTransparency = 1
    Drop.ScrollBarThickness = 2
    Instance.new("UIListLayout", Drop)

    MainBtn.MouseButton1Click:Connect(function()
        Frame.Size = Frame.Size.Y.Offset == 35 and UDim2.new(1, 0, 0, 150) or UDim2.new(1, 0, 0, 35)
    end)

    local function Refresh(newList)
        if newList then itemsList = newList end
        for _, v in pairs(Drop:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        for _, item in pairs(itemsList) do
            local Btn = Instance.new("TextButton", Drop)
            Btn.Size = UDim2.new(1, 0, 0, 30)
            Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            Btn.Text = item
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 13
            
            Btn.MouseButton1Click:Connect(function()
                if multiSelect then
                    local idx = table.find(_G_V3[globalVar], item)
                    if idx then table.remove(_G_V3[globalVar], idx); Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                    else table.insert(_G_V3[globalVar], item); Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 150) end
                else
                    _G_V3[globalVar] = item
                    MainBtn.Text = "  " .. title .. ": " .. item
                    Frame.Size = UDim2.new(1, 0, 0, 35)
                end
            end)
        end
        Drop.CanvasSize = UDim2.new(0, 0, 0, #itemsList * 30)
    end
    Refresh(itemsList)
    return Refresh
end

-- ==========================================
-- XÂY DỰNG TABS
-- ==========================================
local TabMain = CreateTab("⚔️ Main")
local TabSettings = CreateTab("⚙️ Settings")
local TabSkills = CreateTab("⚡ Skills")
local TabFruit = CreateTab("🍎 Fruits")
local TabStatus = CreateTab("📊 Status")

Pages["⚔️ Main"].Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Pages["⚔️ Main"].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabMain.Visible = true

-- --- TAB MAIN ---
local DropMonsters = CreateDropdown(TabMain, "Chọn Quái (Được chọn nhiều)", {}, "SelectedMonsters", true)
CreateButton(TabMain, "🔍 Quét Quái (Smart Scan)", function()
    local mobs = {}
    -- Quét toàn map, tìm model có Humanoid
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(v) then
            if not table.find(mobs, v.Name) then table.insert(mobs, v.Name) end
        end
    end
    table.sort(mobs)
    DropMonsters(mobs)
end)
CreateToggle(TabMain, "Bật Auto Farm (Bay Tới Quái)", "AutoFarm")
CreateToggle(TabMain, "Bật Tự Động Đánh (Auto Click)", "AutoClick")


-- --- TAB SETTINGS ---
CreateDropdown(TabSettings, "Kiểu Đánh", {"Trên Đầu", "Đằng Sau", "Dưới Chân"}, "AttackPosition", false)
CreateDropdown(TabSettings, "Khoảng Cách", {5, 10, 15, 20, 30}, "AttackDistance", false)
CreateDropdown(TabSettings, "Tốc Độ Bay", {100, 200, 300, 400}, "FlySpeed", false)

local DropWeapons = CreateDropdown(TabSettings, "Chọn Vũ Khí", {}, "SelectedWeapon", false)
CreateButton(TabSettings, "🎒 Quét Túi Đồ", function()
    local weps = {}
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(weps, v.Name) end end
    if LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("Tool") and not table.find(weps, v.Name) then table.insert(weps, v.Name) end end
    end
    DropWeapons(weps)
end)
CreateToggle(TabSettings, "Bật Tự Động Cầm Vũ Khí", "AutoEquip")


-- --- TAB SKILLS ---
CreateToggle(TabSkills, "Kích Hoạt Auto Skill", "AutoSkill")
CreateToggle(TabSkills, "Tự Động Bấm Phím Z", "Skill_Z")
CreateToggle(TabSkills, "Tự Động Bấm Phím X", "Skill_X")
CreateToggle(TabSkills, "Tự Động Bấm Phím C", "Skill_C")
CreateToggle(TabSkills, "Tự Động Bấm Phím V", "Skill_V")
CreateToggle(TabSkills, "Tự Động Bấm Phím F", "Skill_F")


-- --- TAB FRUITS ---
local DropFruits = CreateDropdown(TabFruit, "Chọn Trái Cây Đã Rơi", {}, "SelectedFruit", false)
CreateButton(TabFruit, "🍎 Quét Trái Cây (Smart Scan)", function()
    local fruits = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Model")) and (string.find(string.lower(v.Name), "fruit") or v:FindFirstChild("Handle")) then
            -- Bỏ qua trái cây đang trong tay người chơi khác
            if not v.Parent:FindFirstChild("Humanoid") then
                if not table.find(fruits, v.Name) then table.insert(fruits, v.Name) end
            end
        end
    end
    DropFruits(fruits)
end)

-- Hàm bay mượt (Có NoClip)
local function TweenToTarget(targetCFrame)
    local HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    
    local distance = (HRP.Position - targetCFrame.Position).Magnitude
    local time = distance / _G_V3.FlySpeed

    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(HRP, tweenInfo, {CFrame = targetCFrame})
    
    -- Chống rơi do trọng lực khi bay
    local BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.Parent = HRP

    tween:Play()
    tween.Completed:Wait()
    BV:Destroy()
end

CreateButton(TabFruit, "🚀 Bay Đến Trái Đã Chọn", function()
    if not _G_V3.SelectedFruit then return end
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == _G_V3.SelectedFruit then
            local targetPart = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
            if targetPart then TweenToTarget(targetPart.CFrame) break end
        end
    end
end)

CreateButton(TabFruit, "📦 Lụm Tất Cả Trái", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Model")) and string.find(string.lower(v.Name), "fruit") and not v.Parent:FindFirstChild("Humanoid") then
            local targetPart = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
            if targetPart then TweenToTarget(targetPart.CFrame); task.wait(0.5) end
        end
    end
end)


-- --- TAB STATUS ---
local LblTime = Instance.new("TextLabel", TabStatus)
LblTime.Size = UDim2.new(1, 0, 0, 30)
LblTime.BackgroundTransparency = 1
LblTime.TextColor3 = Color3.fromRGB(200, 255, 200)
LblTime.Font = Enum.Font.GothamBold
LblTime.TextSize = 14
LblTime.TextXAlignment = Enum.TextXAlignment.Left

local LblServer = LblTime:Clone()
LblServer.Parent = TabStatus
LblServer.TextColor3 = Color3.fromRGB(255, 200, 200)

task.spawn(function()
    while task.wait(1) do
        local d = os.date("*t")
        LblTime.Text = string.format("🕒 Thời gian: %02d:%02d:%02d", d.hour, d.min, d.sec)
        LblServer.Text = "👥 Số người chơi: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
    end
end)


-- ==========================================
-- ENGINE LÕI: BAY XUYÊN TƯỜNG & AUTO FARM
-- ==========================================

-- Bật NoClip (Xuyên tường) liên tục khi đang bật farm hoặc bay
RunService.Stepped:Connect(function()
    if _G_V3.AutoFarm and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

local function PressKey(key)
    VIM:SendKeyEvent(true, Enum.KeyCode[key], false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game)
end

task.spawn(function()
    while task.wait() do
        -- Auto Equip
        if _G_V3.AutoEquip and _G_V3.SelectedWeapon and LocalPlayer.Character then
            local wp = LocalPlayer.Backpack:FindFirstChild(_G_V3.SelectedWeapon)
            if wp then LocalPlayer.Character.Humanoid:EquipTool(wp) end
        end

        -- Auto Click
        if _G_V3.AutoClick and _G_V3.AutoFarm then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end

        -- Auto Skill
        if _G_V3.AutoSkill and _G_V3.AutoFarm then
            if _G_V3.Skill_Z then PressKey("Z") end
            if _G_V3.Skill_X then PressKey("X") end
            if _G_V3.Skill_C then PressKey("C") end
            if _G_V3.Skill_V then PressKey("V") end
            if _G_V3.Skill_F then PressKey("F") end
        end

        -- Auto Farm Logic
        if _G_V3.AutoFarm and #_G_V3.SelectedMonsters > 0 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local HRP = LocalPlayer.Character.HumanoidRootPart
            local targetMob, shortestDist = nil, math.huge

            -- Tìm quái gần nhất
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    if table.find(_G_V3.SelectedMonsters, v.Name) then
                        local dist = (HRP.Position - v.HumanoidRootPart.Position).Magnitude
                        if dist < shortestDist then shortestDist = dist; targetMob = v end
                    end
                end
            end

            -- Bay tới / Đứng trên đầu quái
            if targetMob then
                local mobPos = targetMob.HumanoidRootPart.CFrame
                local offset = CFrame.new(0, _G_V3.AttackDistance, 0) * CFrame.Angles(math.rad(-90),0,0)
                if _G_V3.AttackPosition == "Đằng Sau" then offset = CFrame.new(0, 0, _G_V3.AttackDistance)
                elseif _G_V3.AttackPosition == "Dưới Chân" then offset = CFrame.new(0, -_G_V3.AttackDistance, 0) end

                local targetCFrame = mobPos * offset

                if shortestDist > 100 then
                    -- Xa quá thì Tween cho mượt
                    TweenToTarget(targetCFrame)
                else
                    -- Gần thì dịch chuyển thẳng CFrame (Chống giật)
                    HRP.CFrame = targetCFrame
                end
            end
        end
    end
end)
