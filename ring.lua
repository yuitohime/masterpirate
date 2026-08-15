-- ==========================================
-- DELTA UI V8 - AUTO FARM LEVEL & QUEST LIST
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

local function GetSafeParent()
    local success, result = pcall(function() return gethui() end)
    if success and result then return result end
    return LocalPlayer:WaitForChild("PlayerGui")
end
local SafeParent = GetSafeParent()

if SafeParent:FindFirstChild("V8_DeltaUI_Max") then SafeParent["V8_DeltaUI_Max"]:Destroy() end

-- ==========================================
-- 📚 DATABASE NHIỆM VỤ (BẠN CÓ THỂ TỰ THÊM VÀO ĐÂY)
-- ==========================================
local QuestDB = {
    {Level = 1, QuestName = "Bandit [Lv. 1]", MobName = "Bandit", NPC = "Quest Giver"},
    {Level = 10, QuestName = "Naval Student [Lv. 10]", MobName = "Naval Rating Student", NPC = "Quest Giver"},
    {Level = 30, QuestName = "Pirate [Lv. 30]", MobName = "Pirate", NPC = "Quest Giver"},
    -- Mẫu để thêm: {Level = Cấp độ yêu cầu, QuestName = "Tên hiển thị", MobName = "Tên Quái vật", NPC = "Tên con NPC"},
}

-- Lấy danh sách tên Quest để đưa vào UI
local QuestListNames = {}
for i, v in ipairs(QuestDB) do table.insert(QuestListNames, v.QuestName) end

local _G_V8 = {
    -- Free Farm (Farm tự do)
    AutoFarmFree = false, FarmAll = false, SelectedMonsters = {}, ExcludedMobs = {"dummy", "test dmg", "testdmg"},
    -- Auto Level & Quest
    AutoFarmLevel = false, ManualQuestFarm = false, SelectedManualQuest = nil,
    CurrentTargetMob = nil, -- Biến linh hoạt để thay đổi mục tiêu theo level
    -- Setting chung
    AutoEquip = false, AutoClick = false, AutoSkill = false, AutoRepeatQuest = false,
    Skill_Z = false, Skill_X = false, Skill_C = false, Skill_V = false, Skill_F = false,
    SelectedWeapon = nil, SelectedFruit = nil,
    AttackPosition = "Trên Đầu", AttackDistance = 15, FlySpeed = 250,
}

-- ==========================================
-- GIAO DIỆN CHÍNH
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "V8_DeltaUI_Max"
ScreenGui.ResetOnSpawn = false

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
Title.BackgroundTransparency = 1; Title.Text = "AUTO FARM V8 (Level & Quest List)"
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

local TabsFrame = Instance.new("Frame", MainFrame)
TabsFrame.Name = "TabsFrame"; TabsFrame.Size = UDim2.new(0.28, 0, 1, -35); TabsFrame.Position = UDim2.new(0, 0, 0, 35)
TabsFrame.BackgroundTransparency = 1
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
        _G_V8[varName] = not _G_V8[varName]
        if _G_V8[varName] then
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
                    local idx = table.find(_G_V8[globalVar], item)
                    if idx then table.remove(_G_V8[globalVar], idx); Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                    else table.insert(_G_V8[globalVar], item); Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 150) end
                else
                    _G_V8[globalVar] = item
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

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, 0, 0, 35); Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Text = text
    Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 14
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
end

-- ==========================================
-- XÂY DỰNG TABS
-- ==========================================
local TabAutoLevel = CreateTab("🌟 Farm Level")
local TabFreeFarm = CreateTab("⚔️ Farm Tự Do")
local TabSettings = CreateTab("⚙️ Cài Đặt")
local TabSkills = CreateTab("⚡ Kỹ Năng")

Pages["🌟 Farm Level"].Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Pages["🌟 Farm Level"].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabAutoLevel.Visible = true

-- --- TAB: FARM LEVEL (MỚI) ---
local LblInfo = Instance.new("TextLabel", TabAutoLevel)
LblInfo.Size = UDim2.new(1, 0, 0, 20); LblInfo.BackgroundTransparency = 1
LblInfo.TextColor3 = Color3.fromRGB(255, 255, 100); LblInfo.Font = Enum.Font.Gotham; LblInfo.TextSize = 13
LblInfo.TextXAlignment = Enum.TextXAlignment.Left
LblInfo.Text = "Mục tiêu hiện tại: Đang lấy thông tin..."

CreateToggleSwitch(TabAutoLevel, "Bật Auto Farm Level (Tự Chuyển Bãi)", "AutoFarmLevel")
CreateDropdown(TabAutoLevel, "Chọn Quest Bằng Tay", QuestListNames, "SelectedManualQuest", false)
CreateToggleSwitch(TabAutoLevel, "Bật Đánh Quest Đã Chọn Trên", "ManualQuestFarm")
CreateToggleSwitch(TabAutoLevel, "Bật Lặp Lại Quest (Hoàn Hảo)", "AutoRepeatQuest")
CreateToggleSwitch(TabAutoLevel, "Bật Tự Động Đánh (Click)", "AutoClick")

-- --- TAB: FARM TỰ DO (MŨ CŨ) ---
local DropMonsters = CreateDropdown(TabFreeFarm, "Chọn Quái Tùy Ý (Multi-Select)", {}, "SelectedMonsters", true)
CreateButton(TabFreeFarm, "🔍 Quét Tất Cả Quái Trên Map", function()
    local mobs = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(v) then
            local isExcluded = false
            for _, ex in pairs(_G_V8.ExcludedMobs) do if string.find(string.lower(v.Name), ex) then isExcluded = true; break end end
            if not isExcluded and not table.find(mobs, v.Name) then table.insert(mobs, v.Name) end
        end
    end
    table.sort(mobs); DropMonsters(mobs)
end)
CreateToggleSwitch(TabFreeFarm, "Bật Farm Quái Tự Do (Free Farm)", "AutoFarmFree")
CreateToggleSwitch(TabFreeFarm, "Bật Farm ALL (Càn quét Map)", "FarmAll")

-- --- TAB: SETTINGS & SKILLS ---
CreateDropdown(TabSettings, "Kiểu Đánh", {"Trên Đầu", "Đằng Sau", "Dưới Chân"}, "AttackPosition", false)
CreateDropdown(TabSettings, "Tốc Độ Bay", {100, 200, 300, 400}, "FlySpeed", false)
local DropWeapons = CreateDropdown(TabSettings, "Chọn Vũ Khí", {}, "SelectedWeapon", false)
CreateButton(TabSettings, "🎒 Quét Vũ Khí", function()
    local weps = {}
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(weps, v.Name) end end
    if LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("Tool") and not table.find(weps, v.Name) then table.insert(weps, v.Name) end end
    end
    DropWeapons(weps)
end)
CreateToggleSwitch(TabSettings, "Tự Động Cầm Vũ Khí", "AutoEquip")

CreateToggleSwitch(TabSkills, "Kích Hoạt Auto Skill", "AutoSkill")
CreateToggleSwitch(TabSkills, "Phím Z", "Skill_Z")
CreateToggleSwitch(TabSkills, "Phím X", "Skill_X")
CreateToggleSwitch(TabSkills, "Phím C", "Skill_C")
CreateToggleSwitch(TabSkills, "Phím V", "Skill_V")
CreateToggleSwitch(TabSkills, "Phím F", "Skill_F")


-- ==========================================
-- ENGINE LÕI
-- ==========================================
RunService.Stepped:Connect(function()
    if (_G_V8.AutoFarmLevel or _G_V8.ManualQuestFarm or _G_V8.AutoFarmFree or _G_V8.FarmAll) and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
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
local function DisableAntiFall(HRP)
    if HRP:FindFirstChild("FarmAntiFall") then HRP.FarmAntiFall:Destroy() end
end

local function PressKey(key)
    VIM:SendKeyEvent(true, Enum.KeyCode[key], false, game); task.wait(0.1)
    VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game)
end

-- Lấy Level người chơi (Thích ứng nhiều cấu trúc game)
local function GetPlayerLevel()
    local lvl = 1
    pcall(function()
        if LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Level") then
            lvl = tonumber(LocalPlayer.leaderstats.Level.Value) or 1
        elseif LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level") then
            lvl = tonumber(LocalPlayer.Data.Level.Value) or 1
        end
    end)
    return lvl
end

-- Tìm Quái Vật Phù Hợp Cho Auto Level
local function GetMobForCurrentLevel()
    local myLevel = GetPlayerLevel()
    local targetMob = QuestDB[1].MobName
    local targetQuest = QuestDB[1].QuestName
    
    for i = 1, #QuestDB do
        if myLevel >= QuestDB[i].Level then
            targetMob = QuestDB[i].MobName
            targetQuest = QuestDB[i].QuestName
        end
    end
    return targetMob, targetQuest
end

-- Lặp Lại Nhiệm Vụ (Cơ chế cũ siêu việt)
local lastQuestTime = 0
local function RepeatQuestRemote()
    if os.clock() - lastQuestTime > 1 then
        lastQuestTime = os.clock()
        pcall(function()
            for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if v:IsA("RemoteEvent") and v.Name == "Qu" then v:FireServer("Yes") end
            end
        end)
    end
end

-- VÒNG LẶP CHÍNH
task.spawn(function()
    while task.wait() do
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        local HRP = char.HumanoidRootPart

        -- 1. Xác định Mục Tiêu (Target Mob) dựa trên các chế độ bật
        _G_V8.CurrentTargetMob = nil
        
        if _G_V8.AutoFarmLevel then
            local mob, qName = GetMobForCurrentLevel()
            _G_V8.CurrentTargetMob = {mob}
            LblInfo.Text = "Đang Farm theo Level: " .. qName
        elseif _G_V8.ManualQuestFarm and _G_V8.SelectedManualQuest then
            for _, v in pairs(QuestDB) do
                if v.QuestName == _G_V8.SelectedManualQuest then 
                    _G_V8.CurrentTargetMob = {v.MobName}
                    LblInfo.Text = "Đang Farm (Thủ Công): " .. v.QuestName
                end
            end
        elseif _G_V8.AutoFarmFree and #_G_V8.SelectedMonsters > 0 then
            _G_V8.CurrentTargetMob = _G_V8.SelectedMonsters
            LblInfo.Text = "Đang Farm Tự Do"
        elseif _G_V8.FarmAll then
            LblInfo.Text = "Đang Càn Quét (Farm All)"
        else
            LblInfo.Text = "Đang rảnh rỗi..."
        end

        -- 2. Hành động phụ trợ
        if _G_V8.AutoRepeatQuest then RepeatQuestRemote() end

        if _G_V8.AutoEquip and _G_V8.SelectedWeapon then
            local wp = LocalPlayer.Backpack:FindFirstChild(_G_V8.SelectedWeapon)
            if wp then char.Humanoid:EquipTool(wp) end
        end

        local isFarming = _G_V8.AutoFarmLevel or _G_V8.ManualQuestFarm or _G_V8.AutoFarmFree or _G_V8.FarmAll

        if isFarming then
            if _G_V8.AutoClick then
                local equippedTool = char:FindFirstChildWhichIsA("Tool")
                if equippedTool then equippedTool:Activate() end
            end
            if _G_V8.AutoSkill then
                if _G_V8.Skill_Z then PressKey("Z") end; if _G_V8.Skill_X then PressKey("X") end
                if _G_V8.Skill_C then PressKey("C") end; if _G_V8.Skill_V then PressKey("V") end
                if _G_V8.Skill_F then PressKey("F") end
            end
            
            EnableAntiFall(HRP)
            local targetMobInstance, shortestDist = nil, math.huge
            
            -- Tìm quái vật
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(v) then
                    
                    local isValidTarget = false
                    
                    if _G_V8.FarmAll then
                        local isEx = false
                        for _, ex in pairs(_G_V8.ExcludedMobs) do if string.find(string.lower(v.Name), ex) then isEx = true break end end
                        if not isEx then isValidTarget = true end
                    elseif _G_V8.CurrentTargetMob and table.find(_G_V8.CurrentTargetMob, v.Name) then
                        isValidTarget = true
                    end

                    if isValidTarget then
                        local dist = (HRP.Position - v.HumanoidRootPart.Position).Magnitude
                        if dist < shortestDist then shortestDist = dist; targetMobInstance = v end
                    end
                end
            end

            -- Di chuyển đến quái
            if targetMobInstance then
                local mobPos = targetMobInstance.HumanoidRootPart.CFrame
                local offset = CFrame.new(0, _G_V8.AttackDistance, 0) * CFrame.Angles(math.rad(-90),0,0)
                if _G_V8.AttackPosition == "Đằng Sau" then offset = CFrame.new(0, 0, _G_V8.AttackDistance)
                elseif _G_V8.AttackPosition == "Dưới Chân" then offset = CFrame.new(0, -_G_V8.AttackDistance, 0) end
                
                HRP.CFrame = mobPos * offset
            end
        else
            DisableAntiFall(HRP)
        end
    end
end)
