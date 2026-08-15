-- ==========================================
-- DELTA UI V4 - MAX OPTIMIZATION & ANTI-FALL
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

if SafeParent:FindFirstChild("V4_DeltaUI_Max") then SafeParent["V4_DeltaUI_Max"]:Destroy() end

-- Cấu hình hệ thống
local _G_V4 = {
    AutoFarm = false, FarmAll = false, AutoEquip = false, AutoClick = false, AutoSkill = false, AutoQuest = false,
    Skill_Z = false, Skill_X = false, Skill_C = false, Skill_V = false, Skill_F = false,
    SelectedMonsters = {}, SelectedWeapon = nil, SelectedFruit = nil,
    AttackPosition = "Trên Đầu", AttackDistance = 15, FlySpeed = 250,
    MonstersList = {}, WeaponsList = {}, FruitsList = {},
    ExcludedMobs = {"dummy", "test dmg", "testdmg"} -- Từ khóa loại trừ
}

-- ==========================================
-- TẠO GIAO DIỆN CHÍNH
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "V4_DeltaUI_Max"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 620, 0, 420)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BackgroundTransparency = 0.1 -- Trong suốt nhẹ
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 200, 255)

-- TOP BAR
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
local FixCorner = Instance.new("Frame", TopBar)
FixCorner.Size = UDim2.new(1, 0, 0, 10)
FixCorner.Position = UDim2.new(0, 0, 1, -10)
FixCorner.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
FixCorner.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "AUTO FARM V4 (Delta Pro)"
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
MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 24

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 40, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 18

local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    MainFrame.Size = isMinimized and UDim2.new(0, 620, 0, 35) or UDim2.new(0, 620, 0, 420)
    MainFrame:FindFirstChild("TabsFrame").Visible = not isMinimized
    MainFrame:FindFirstChild("ContentFrame").Visible = not isMinimized
end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- CHIA CỘT
local TabsFrame = Instance.new("Frame", MainFrame)
TabsFrame.Name = "TabsFrame"
TabsFrame.Size = UDim2.new(0.25, 0, 1, -35)
TabsFrame.Position = UDim2.new(0, 0, 0, 35)
TabsFrame.BackgroundTransparency = 1
Instance.new("UIListLayout", TabsFrame).Padding = UDim.new(0, 5)
Instance.new("UIPadding", TabsFrame).PaddingTop = UDim.new(0, 10)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(0.75, 0, 1, -35)
ContentFrame.Position = UDim2.new(0.25, 0, 0, 35)
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ContentFrame.BackgroundTransparency = 0.5
Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 8)

-- ==========================================
-- HÀM TẠO UI COMPONENTS
-- ==========================================
local Pages = {}
local function CreateTab(name)
    local Btn = Instance.new("TextButton", TabsFrame)
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.Position = UDim2.new(0, 5, 0, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Text = name
    Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 14
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("ScrollingFrame", ContentFrame)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
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

-- CÔNG TẮC GẠT (Nút Toggle Mới)
local function CreateToggleSwitch(parent, text, varName)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(0.7, 0, 1, 0)
    Lbl.Position = UDim2.new(0, 10, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text
    Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    Lbl.Font = Enum.Font.Gotham; Lbl.TextSize = 14; Lbl.TextXAlignment = Enum.TextXAlignment.Left

    local SwitchBG = Instance.new("TextButton", Frame)
    SwitchBG.Size = UDim2.new(0, 40, 0, 20)
    SwitchBG.Position = UDim2.new(1, -50, 0.5, -10)
    SwitchBG.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    SwitchBG.Text = ""
    Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame", SwitchBG)
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(0, 2, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    SwitchBG.MouseButton1Click:Connect(function()
        _G_V4[varName] = not _G_V4[varName]
        if _G_V4[varName] then
            SwitchBG.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            Knob:TweenPosition(UDim2.new(1, -18, 0.5, -8), "Out", "Quad", 0.2, true)
        else
            SwitchBG.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            Knob:TweenPosition(UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.2, true)
        end
    end)
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Text = text
    Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 14
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
end

local function CreateDropdown(parent, title, itemsList, globalVar, multiSelect)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Frame.ClipsDescendants = true
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local MainBtn = Instance.new("TextButton", Frame)
    MainBtn.Size = UDim2.new(1, 0, 0, 35)
    MainBtn.BackgroundTransparency = 1
    MainBtn.Text = "  " .. title .. " ▼"
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainBtn.Font = Enum.Font.Gotham; MainBtn.TextSize = 13; MainBtn.TextXAlignment = Enum.TextXAlignment.Left

    local Drop = Instance.new("ScrollingFrame", Frame)
    Drop.Size = UDim2.new(1, 0, 0, 115)
    Drop.Position = UDim2.new(0, 0, 0, 35)
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
            Btn.Size = UDim2.new(1, 0, 0, 30)
            Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            Btn.Text = item; Btn.Font = Enum.Font.Gotham; Btn.TextSize = 12
            
            Btn.MouseButton1Click:Connect(function()
                if multiSelect then
                    local idx = table.find(_G_V4[globalVar], item)
                    if idx then table.remove(_G_V4[globalVar], idx); Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                    else table.insert(_G_V4[globalVar], item); Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 150) end
                else
                    _G_V4[globalVar] = item
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
local DropMonsters = CreateDropdown(TabMain, "Chọn Quái (Multi-Select)", {}, "SelectedMonsters", true)
CreateButton(TabMain, "🔍 Quét Quái (Toàn bộ các Đảo)", function()
    local mobs = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(v) then
            local isExcluded = false
            for _, ex in pairs(_G_V4.ExcludedMobs) do
                if string.find(string.lower(v.Name), ex) then isExcluded = true; break end
            end
            if not isExcluded and not table.find(mobs, v.Name) then table.insert(mobs, v.Name) end
        end
    end
    table.sort(mobs)
    DropMonsters(mobs)
end)

CreateToggleSwitch(TabMain, "Bật Auto Farm (Bay Tới Quái Đã Chọn)", "AutoFarm")
CreateToggleSwitch(TabMain, "Bật Farm ALL (Đánh tất cả quái quét được)", "FarmAll")
CreateToggleSwitch(TabMain, "Bật Auto Request (Nhận nhiệm vụ)", "AutoQuest")
CreateToggleSwitch(TabMain, "Bật Auto Click", "AutoClick")

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
CreateToggleSwitch(TabSettings, "Bật Tự Động Cầm Vũ Khí", "AutoEquip")

-- --- TAB SKILLS ---
CreateToggleSwitch(TabSkills, "Kích Hoạt Auto Skill", "AutoSkill")
CreateToggleSwitch(TabSkills, "Tự Động Bấm Phím Z", "Skill_Z")
CreateToggleSwitch(TabSkills, "Tự Động Bấm Phím X", "Skill_X")
CreateToggleSwitch(TabSkills, "Tự Động Bấm Phím C", "Skill_C")
CreateToggleSwitch(TabSkills, "Tự Động Bấm Phím V", "Skill_V")
CreateToggleSwitch(TabSkills, "Tự Động Bấm Phím F", "Skill_F")

-- --- TAB FRUITS ---
local DropFruits = CreateDropdown(TabFruit, "Chọn Trái Cây Đã Rơi", {}, "SelectedFruit", false)
CreateButton(TabFruit, "🍎 Quét Trái Cây (Toàn Bản Đồ)", function()
    local fruits = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Model")) and (string.find(string.lower(v.Name), "fruit") or v:FindFirstChild("Handle")) then
            if not v.Parent:FindFirstChild("Humanoid") then
                if not table.find(fruits, v.Name) then table.insert(fruits, v.Name) end
            end
        end
    end
    DropFruits(fruits)
end)

local function TweenToTarget(targetCFrame)
    local HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    
    local distance = (HRP.Position - targetCFrame.Position).Magnitude
    local time = distance / _G_V4.FlySpeed
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(HRP, tweenInfo, {CFrame = targetCFrame})
    
    -- Chống rơi rớt / Đứng im trên không
    local BV = Instance.new("BodyVelocity", HRP)
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9); BV.Velocity = Vector3.new(0, 0, 0)
    
    tween:Play()
    tween.Completed:Wait()
    BV:Destroy()
end

CreateButton(TabFruit, "🚀 Bay Đến Trái Đã Chọn", function()
    if not _G_V4.SelectedFruit then return end
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == _G_V4.SelectedFruit then
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
local StatusFruitList = Instance.new("TextLabel", TabStatus)
StatusFruitList.Size = UDim2.new(1, 0, 1, 0)
StatusFruitList.BackgroundTransparency = 1
StatusFruitList.TextColor3 = Color3.fromRGB(0, 255, 100)
StatusFruitList.Font = Enum.Font.Gotham
StatusFruitList.TextSize = 13
StatusFruitList.TextXAlignment = Enum.TextXAlignment.Left
StatusFruitList.TextYAlignment = Enum.TextYAlignment.Top

task.spawn(function()
    while task.wait(2) do
        local foundFruits = {}
        for _, v in pairs(workspace:GetDescendants()) do
            if (v:IsA("Tool") or v:IsA("Model")) and string.find(string.lower(v.Name), "fruit") and not v.Parent:FindFirstChild("Humanoid") then
                table.insert(foundFruits, "🍎 " .. v.Name)
            end
        end
        if #foundFruits == 0 then StatusFruitList.Text = "Chưa tìm thấy trái nào trên map."
        else StatusFruitList.Text = "TRÁI CÂY ĐANG RƠI:\n\n" .. table.concat(foundFruits, "\n") end
    end
end)

-- ==========================================
-- ENGINE LÕI: NOCLIP & AUTO ACTIONS
-- ==========================================
-- NoClip Xuyên tường liên tục
RunService.Stepped:Connect(function()
    if (_G_V4.AutoFarm or _G_V4.FarmAll) and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Hàm Bấm Phím
local function PressKey(key)
    VIM:SendKeyEvent(true, Enum.KeyCode[key], false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game)
end

-- Chống Rơi (Anti-Fall) khi đánh quái
local function EnableAntiFall(HRP)
    if not HRP:FindFirstChild("FarmAntiFall") then
        local AntiFall = Instance.new("BodyVelocity")
        AntiFall.Name = "FarmAntiFall"
        AntiFall.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        AntiFall.Velocity = Vector3.new(0, 0, 0)
        AntiFall.Parent = HRP
    end
end

local function DisableAntiFall(HRP)
    if HRP:FindFirstChild("FarmAntiFall") then HRP.FarmAntiFall:Destroy() end
end

-- Auto Quest Logic
local function AcceptQuest()
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if pGui then
        -- Tìm UI nhận Quest (Ví dụ thường có chữ Yes hoặc Accept)
        for _, ui in pairs(pGui:GetDescendants()) do
            if ui:IsA("TextButton") and (string.lower(ui.Text) == "yes" or string.lower(ui.Text) == "accept") then
                -- Mô phỏng Click vào nút đó
                local absPos = ui.AbsolutePosition
                VIM:SendMouseButtonEvent(absPos.X + ui.AbsoluteSize.X/2, absPos.Y + ui.AbsoluteSize.Y/2 + 36, 0, true, game, 1)
                task.wait(0.1)
                VIM:SendMouseButtonEvent(absPos.X + ui.AbsoluteSize.X/2, absPos.Y + ui.AbsoluteSize.Y/2 + 36, 0, false, game, 1)
            end
        end
    end
end

-- Vòng lặp chính
task.spawn(function()
    while task.wait() do
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        local HRP = char.HumanoidRootPart

        -- Auto Quest
        if _G_V4.AutoQuest then AcceptQuest() end

        -- Auto Equip
        if _G_V4.AutoEquip and _G_V4.SelectedWeapon then
            local wp = LocalPlayer.Backpack:FindFirstChild(_G_V4.SelectedWeapon)
            if wp then char.Humanoid:EquipTool(wp) end
        end

        -- Auto Actions (Click & Skill)
        if (_G_V4.AutoFarm or _G_V4.FarmAll) then
            if _G_V4.AutoClick then
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
            if _G_V4.AutoSkill then
                if _G_V4.Skill_Z then PressKey("Z") end
                if _G_V4.Skill_X then PressKey("X") end
                if _G_V4.Skill_C then PressKey("C") end
                if _G_V4.Skill_V then PressKey("V") end
                if _G_V4.Skill_F then PressKey("F") end
            end
        end

        -- Logic Tìm & Farm Quái
        if _G_V4.AutoFarm or _G_V4.FarmAll then
            EnableAntiFall(HRP) -- Giữ nhân vật lơ lửng, không bị rơi
            
            local targetMob, shortestDist = nil, math.huge
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(v) then
                    
                    local isValidTarget = false
                    -- Nếu bật Farm All thì lấy hết quái không bị loại trừ
                    if _G_V4.FarmAll then
                        local isExcluded = false
                        for _, ex in pairs(_G_V4.ExcludedMobs) do if string.find(string.lower(v.Name), ex) then isExcluded = true; break end end
                        if not isExcluded then isValidTarget = true end
                    -- Nếu không thì chỉ lấy quái trong list đã chọn
                    elseif table.find(_G_V4.SelectedMonsters, v.Name) then
                        isValidTarget = true
                    end

                    if isValidTarget then
                        local dist = (HRP.Position - v.HumanoidRootPart.Position).Magnitude
                        if dist < shortestDist then shortestDist = dist; targetMob = v end
                    end
                end
            end

            -- Di chuyển tới quái
            if targetMob then
                local mobPos = targetMob.HumanoidRootPart.CFrame
                local offset = CFrame.new(0, _G_V4.AttackDistance, 0) * CFrame.Angles(math.rad(-90),0,0)
                if _G_V4.AttackPosition == "Đằng Sau" then offset = CFrame.new(0, 0, _G_V4.AttackDistance)
                elseif _G_V4.AttackPosition == "Dưới Chân" then offset = CFrame.new(0, -_G_V4.AttackDistance, 0) end
                
                local targetCFrame = mobPos * offset
                
                if shortestDist > 150 then TweenToTarget(targetCFrame)
                else HRP.CFrame = targetCFrame end
            end
        else
            DisableAntiFall(HRP)
        end
    end
end)
