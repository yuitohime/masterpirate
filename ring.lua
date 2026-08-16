-- ==========================================
-- 🌸 YUIHUB - THE ULTIMATE SCRIPT (BẢN VÁ CLICK, ẨN MẶC ĐỊNH & THÊM FARM TỌA ĐỘ AI)
-- (GIỮ NGUYÊN 100% TÍNH NĂNG CŨ, THÊM CƠ CHẾ ƯU TIÊN LEVEL QUÁI VÀ THỨ TỰ BOSS)
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
local TweenService = game:GetService("TweenService")

local SafeParent = pcall(gethui) and gethui() or LocalPlayer:WaitForChild("PlayerGui")
if SafeParent:FindFirstChild("YuiHub_UI") then SafeParent["YuiHub_UI"]:Destroy() end

-- ==========================================
-- 📚 DATABASE TỌA ĐỘ VÀ LEVEL (THEO YÊU CẦU MỚI)
-- ==========================================
local CoordDB = {
    Bosses = {
        ["God of Cold [Lv.50000]"] = {Level = 50000, Pos = Vector3.new(-370, 637, 9004)},
        ["Moria [Lv.1200]"] = {Level = 1200, Pos = Vector3.new(-10421, 62, -2497)},
        ["Shadow Master [Lv.1450]"] = {Level = 1450, Pos = Vector3.new(-10022, 75, -2991)},
        ["Hawkeye [Lv.999]"] = {Level = 999, Pos = Vector3.new(-1831, 77, 3674)}
    },
    Mobs = {
        ["Elf [Lv.1300]"] = {Level=1300, Pos=Vector3.new(1134, 49, 6107)},
        ["Seaman [Lv.50]"] = {Level=50, Pos=Vector3.new(1149, 69, -3504)},
        ["Ryuma [Lv.675]"] = {Level=675, Pos=Vector3.new(-10365, 63, -2891)},
        ["Section Chef [Lv.475]"] = {Level=475, Pos=Vector3.new(-3496, 43, -3253)},
        ["Chef de Cuisine [Lv.1350]"] = {Level=1350, Pos=Vector3.new(-15997, 131, 11956)},
        ["Head Jailer [Lv.1375]"] = {Level=1375, Pos=Vector3.new(-15928, 131, 11976)},
        ["Desert Bandit [Lv.150]"] = {Level=150, Pos=Vector3.new(-5577, 54, -1272)},
        ["Vampire [Lv.650]"] = {Level=650, Pos=Vector3.new(-10060, 62, -2206)},
        ["Axe Captain [Lv.75]"] = {Level=75, Pos=Vector3.new(1007, 88, -3725)},
        ["Vice Warden [Lv.1400]"] = {Level=1400, Pos=Vector3.new(-16182, 131, 12002)},
        ["Hydra Leader [Lv.1025]"] = {Level=1025, Pos=Vector3.new(7375, 411, -651)},
        ["Lieutenant Commander [Lv.1500]"] = {Level=1500, Pos=Vector3.new(-20505, 105, 1478)},
        ["Lieutenant [Lv.1450]"] = {Level=1450, Pos=Vector3.new(-20414, 105, 1398)},
        ["Rookie [Lv.700]"] = {Level=700, Pos=Vector3.new(4300, 96, 3017)},
        ["SkyAssaster [Lv.400]"] = {Level=400, Pos=Vector3.new(-7741, 462, 1154)},
        ["Hydra SwordsMan [Lv.900]"] = {Level=900, Pos=Vector3.new(8618, 189, -628)},
        ["Captain [Lv.1600]"] = {Level=1600, Pos=Vector3.new(-20087, 103, 726)},
        ["Apprentice [Lv.450]"] = {Level=450, Pos=Vector3.new(-3596, 36, -3254)},
        ["Gorilla [Lv.1150]"] = {Level=1150, Pos=Vector3.new(-1191, 61, -5812)},
        ["Guard [Lv.1]"] = {Level=1, Pos=Vector3.new(1063, 104, 441)},
        ["Baboon [Lv.1100]"] = {Level=1100, Pos=Vector3.new(-1270, 52, -5545)},
        ["Hydra Bandit [Lv.975]"] = {Level=975, Pos=Vector3.new(8856, 154, 122)},
        ["Gunner [Lv.1200]"] = {Level=1200, Pos=Vector3.new(-3596, 52, 7021)},
        ["Chimpanzee [Lv.1125]"] = {Level=1125, Pos=Vector3.new(-1421, 61, -5672)},
        ["Black Bandit [Lv.130]"] = {Level=130, Pos=Vector3.new(-1188, 78, 3400)},
        ["Black Elf [Lv.1325]"] = {Level=1325, Pos=Vector3.new(1026, 68, 6470)},
        ["Rear Admiral [Lv.725]"] = {Level=725, Pos=Vector3.new(3774, 54, 3315)},
        ["Marine [Lv.525]"] = {Level=525, Pos=Vector3.new(-5464, 55, 3982)},
        ["Desert Royal [Lv.200]"] = {Level=200, Pos=Vector3.new(-4907, 54, -1579)},
        ["Pirate Hydra [Lv.850]"] = {Level=850, Pos=Vector3.new(6792, 55, -816)},
        ["Smoky [Lv.25]"] = {Level=25, Pos=Vector3.new(966, 99, -438)},
        ["Second Chef [Lv.500]"] = {Level=500, Pos=Vector3.new(-3413, 74, -3201)},
        ["Robot [Lv.775]"] = {Level=775, Pos=Vector3.new(3565, 132, 3588)},
        ["ProSharkPirate [Lv.275]"] = {Level=275, Pos=Vector3.new(-5742, 43, -5765)},
        ["Zombie [Lv.625]"] = {Level=625, Pos=Vector3.new(-9745, 63, -2566)},
        ["Arlung [Lv.300]"] = {Level=300, Pos=Vector3.new(-5891, 48, -5192)},
        ["Hydra Protector [Lv.875]"] = {Level=875, Pos=Vector3.new(8860, 155, -620)},
        ["SharkPirate [Lv.250]"] = {Level=250, Pos=Vector3.new(-5461, 46, -5416)}
    }
}
local CoordBossNames = {}; for k, _ in pairs(CoordDB.Bosses) do table.insert(CoordBossNames, k) end
local CoordMobNames = {}; for k, _ in pairs(CoordDB.Mobs) do table.insert(CoordMobNames, k) end
table.sort(CoordBossNames); table.sort(CoordMobNames)

local QuestDB = {
    {Level = 1, QuestName = "Bandit [Lv. 1]", MobName = "Bandit"},
    {Level = 10, QuestName = "Naval Student [Lv. 10]", MobName = "Naval Rating Student"},
    {Level = 30, QuestName = "Pirate [Lv. 30]", MobName = "Pirate"},
}
local QuestListNames = {}
for i, v in ipairs(QuestDB) do table.insert(QuestListNames, v.QuestName) end

local DefaultConfig = {
    AutoFarmFree = false, FarmAll = false, SelectedMonsters = {}, ExcludedMobs = {"dummy", "test dmg", "testdmg"},
    AutoFarmLevel = false, ManualQuestFarm = false, SelectedManualQuest = nil, CurrentTargetMob = nil,
    AutoEquip = false, AutoClick = false, AutoSkill = false, AutoRepeatQuest = false,
    Skill_Z = false, Skill_X = false, Skill_C = false, Skill_V = false, Skill_F = false,
    AutoHaki = false, AutoKen = false, SelectedWeapon = nil, SelectedFruit = nil,
    AttackPosition = "Trên Đầu", AttackDistance = 15, FlySpeed = 250,
    PrimaryWeapon = nil, HoldTime1 = 3, W1_Z = false, W1_X = false, W1_C = false, W1_V = false, W1_B = false, W1_F = false,
    SecondaryWeapon = nil, HoldTime2 = 0.5, W2_Z = false, W2_X = false, W2_C = false, W2_V = false, W2_B = false, W2_F = false,
    AutoSwapWeapon = false, SkillSpamDelay = 0.1,
    AutoSea = false, HuntSeaMonster = true, HuntGhost = true, AutoSitBoat = true, 
    SeaZone = Vector3.new(-15610, 39, 37071), IsFightingSea = false, ArrivedAtZone = false,
    
    AutoBuyRaid = false, AutoStartRaid = false, AutoJoinGame = false, AutoFarmRaid = false,
    AutoTeleEntrance = false, AutoTeleReRaid = false, RaidEntranceDelay = 2, RaidReRaidDelay = 2, RaidBuyTeleportDelay = 2,
    RaidWaitC1 = "10", RaidWaitC2 = "10", RaidWaitC3 = "15",
    
    AutoBypassMenu = true, BypassDuration = 10,

    -- Biến mới cho Farm Tọa Độ
    AutoCoordMob = false, SelectedCoordMobs = {},
    AutoCoordBoss = false, SelectedCoordBosses = {}, BossCheckDelay = 60,

    AutoSpawnMihawk = false, MihawkAmount = "x1", AutoGiveShadow = false, ShadowItem = "Shadow Spirit", ShadowAmount = "x1",
    SelectedIsland = nil, SelectedSpawnPoint = nil,
    EnableSpeed = false, WalkSpeed = 50, EnableJump = false, JumpPower = 100, InfJump = false, DashNoCD = false, FreeFly = false, FreeFlySpeed = 50,
    
    AutoSaveConfig = false, AutoLoadConfig = false, SelectedConfig = "DefaultConfig", AutoScanMap = false,
    EnableBlackScreen = false, AntiAFK = false,
    
    ScannedMonstersList = {}, ScannerData = {Mobs = {}, Bosses = {}, NPCs = {}}
}

local _G_V10 = {}
for k, v in pairs(DefaultConfig) do _G_V10[k] = v end
local _G_UI_Updaters = {}

-- ==========================================
-- HỆ THỐNG LƯU CẤU HÌNH VĨNH VIỄN
-- ==========================================
local ConfigFolder = "YuiHub_Configs"
local MasterFile = ConfigFolder .. "/MasterSettings.json"
if isfolder and not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local txtLog

local function RenderScannerLog()
    if not txtLog then return end
    local logStr = "<b><font color='#ff5555' size='15'>=== 👹 DANH SÁCH BOSS ===</font></b>\n"
    if _G_V10.ScannerData and _G_V10.ScannerData.Bosses then
        for k, v in pairs(_G_V10.ScannerData.Bosses) do 
            logStr = logStr .. string.format("<b><font color='#ffff55'>[%s]</font></b> | <font color='#ffffff'>%s (HP: %s)</font> | <font color='#55ff55'>%s</font>\n", v.Island, k, v.Level, v.Pos) 
        end
    end
    logStr = logStr .. "\n<b><font color='#55aaff' size='15'>=== 👾 DANH SÁCH QUÁI THƯỜNG ===</font></b>\n"
    if _G_V10.ScannerData and _G_V10.ScannerData.Mobs then
        for k, v in pairs(_G_V10.ScannerData.Mobs) do 
            logStr = logStr .. string.format("<b><font color='#ffff55'>[%s]</font></b> | <font color='#ffffff'>%s</font> | <font color='#55ff55'>%s</font>\n", v.Island, k, v.Pos) 
        end
    end
    logStr = logStr .. "\n<b><font color='#ffaa00' size='15'>=== 🛒 DANH SÁCH NPC ===</font></b>\n"
    if _G_V10.ScannerData and _G_V10.ScannerData.NPCs then
        for k, v in pairs(_G_V10.ScannerData.NPCs) do 
            logStr = logStr .. string.format("<b><font color='#ffff55'>[%s]</font></b> | <font color='#ffffff'>%s</font> | <font color='#55ff55'>%s</font>\n", v.Island, k, v.Pos) 
        end
    end
    txtLog.Text = logStr
    if txtLog.Parent then txtLog.Parent.CanvasSize = UDim2.new(0, 0, 0, txtLog.TextBounds.Y + 50) end
end

local function SaveConfig(name)
    if not writefile then return end
    name = name or "DefaultConfig"; _G_V10.SelectedConfig = name
    writefile(ConfigFolder.."/"..name..".json", HttpService:JSONEncode(_G_V10))
    writefile(MasterFile, HttpService:JSONEncode({AutoLoadConfig = _G_V10.AutoLoadConfig, LastConfig = name}))
end

local function LoadConfig(name)
    if not readfile or not isfile(ConfigFolder.."/"..name..".json") then return end
    local s, decoded = pcall(function() return HttpService:JSONDecode(readfile(ConfigFolder.."/"..name..".json")) end)
    if s and type(decoded) == "table" then
        for k, v in pairs(decoded) do _G_V10[k] = v end
        if not _G_V10.ScannerData then _G_V10.ScannerData = {Mobs = {}, Bosses = {}, NPCs = {}} end
        for _, updater in pairs(_G_UI_Updaters) do pcall(updater) end
        RenderScannerLog()
    end
end

if readfile and isfile(MasterFile) then
    local s, masterData = pcall(function() return HttpService:JSONDecode(readfile(MasterFile)) end)
    if s and type(masterData) == "table" and masterData.AutoLoadConfig and masterData.LastConfig then
        _G_V10.AutoLoadConfig = true; LoadConfig(masterData.LastConfig)
    end
end

local function AutoSaveTrigger() if _G_V10.AutoSaveConfig then SaveConfig(_G_V10.SelectedConfig) end end

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
-- GIAO DIỆN CHÍNH (YUI HUB) - NÚT BẤT TỬ & CHỈ BẬT KHI BẤM
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "YuiHub_UI"; ScreenGui.ResetOnSpawn = false

-- NÚT BÔNG HOA BẤT TỬ (KHÔNG BAO GIỜ ẨN)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50); ToggleBtn.Position = UDim2.new(0, 15, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25); ToggleBtn.Text = "🌸"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 200); ToggleBtn.Font = Enum.Font.GothamBold; ToggleBtn.TextSize = 25
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(255, 100, 200)

-- KHUNG MENU CHÍNH
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 50, 0, 50) 
MainFrame.Position = UDim2.new(0.5, -25, 0.5, -25)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.ClipsDescendants = true
MainFrame.Visible = false -- CHỈ BẬT KHI BẤM VÀO BÔNG HOA
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 25) 
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 100, 200)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 50); TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15); TopBar.BackgroundTransparency = 1
TopBar.Visible = false
local DragPad = Instance.new("TextButton", TopBar)
DragPad.Size = UDim2.new(1, -150, 1, 0); DragPad.BackgroundTransparency = 1; DragPad.Text = ""

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.5, 0, 1, 0); Title.Position = UDim2.new(0, 20, 0, 0); Title.BackgroundTransparency = 1
Title.RichText = true
Title.Text = "🌸 YuiHub <font size='12' color='#aaaaaa'><i>- Chào mừng đến với hub của tôi</i></font>"
Title.TextColor3 = Color3.fromRGB(255, 100, 200); Title.Font = Enum.Font.GothamBold; Title.TextSize = 18; Title.TextXAlignment = Enum.TextXAlignment.Left

-- NÚT GHIM (PIN) CHỐNG TRÔI
_G.IsPinned = false
local PinBtn = Instance.new("TextButton", TopBar)
PinBtn.Size = UDim2.new(0, 35, 0, 35); PinBtn.Position = UDim2.new(1, -120, 0, 7.5); PinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
PinBtn.Text = "📌"; PinBtn.TextColor3 = Color3.fromRGB(255, 255, 255); PinBtn.Font = Enum.Font.GothamBold; PinBtn.TextSize = 18
Instance.new("UICorner", PinBtn).CornerRadius = UDim.new(1, 0)
PinBtn.MouseButton1Click:Connect(function()
    _G.IsPinned = not _G.IsPinned; MainFrame.Draggable = not _G.IsPinned
    PinBtn.BackgroundColor3 = _G.IsPinned and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 50, 55)
    PinBtn.Text = _G.IsPinned and "📍" or "📌"
end)

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 35, 0, 35); MinBtn.Position = UDim2.new(1, -75, 0, 7.5); MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
MinBtn.Text = "-"; MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 24
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(1, -35, 0, 7.5); CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 16
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

local TabsFrame = Instance.new("ScrollingFrame", MainFrame)
TabsFrame.Name = "TabsFrame"; TabsFrame.Size = UDim2.new(0.28, 0, 1, -50); TabsFrame.Position = UDim2.new(0, 0, 0, 50)
TabsFrame.BackgroundTransparency = 1; TabsFrame.ScrollBarThickness = 2; TabsFrame.CanvasSize = UDim2.new(0, 0, 0, 850)
Instance.new("UIListLayout", TabsFrame).Padding = UDim.new(0, 5); Instance.new("UIPadding", TabsFrame).PaddingTop = UDim.new(0, 5); Instance.new("UIPadding", TabsFrame).PaddingLeft = UDim.new(0, 10)
TabsFrame.Visible = false

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Name = "ContentFrame"; ContentFrame.Size = UDim2.new(0.72, -10, 1, -60); ContentFrame.Position = UDim2.new(0.28, 0, 0, 50)
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); ContentFrame.BackgroundTransparency = 0.5
Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 15)
ContentFrame.Visible = false

-- ================= CƠ CHẾ KÉO MENU MƯỢT MÀ =================
local dragging, dragInput, dragStart, startPos
DragPad.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not _G.IsPinned then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
DragPad.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging and not _G.IsPinned then
        local delta = input.Position - dragStart
        TweenService:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
    end
end)

-- ================= HOẠT ẢNH CUỘN MỞ/ĐÓNG =================
local function CloseMenuAnimation()
    TabsFrame.Visible = false; ContentFrame.Visible = false
    local tw1 = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 620, 0, 50), Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 0.5, -25)})
    tw1:Play(); tw1.Completed:Wait(); TopBar.Visible = false
    local tw2 = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0.5, -25, 0.5, -25)})
    tw2:Play(); tw2.Completed:Wait(); MainFrame.Visible = false
end

-- FIX: KHÔNG CÒN TỰ MỞ KHI VÀO GAME. CHỈ MỞ KHI BẤM HOA. NÚT HOA LUÔN HIỆN!
ToggleBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        CloseMenuAnimation()
    else
        MainFrame.Size = UDim2.new(0, 50, 0, 50); MainFrame.Position = UDim2.new(0.5, -25, 0.5, -25); MainFrame.Visible = true
        local tw1 = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 620, 0, 50), Position = UDim2.new(0.5, -310, 0.5, -25)})
        tw1:Play(); tw1.Completed:Wait(); TopBar.Visible = true
        local tw2 = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 620, 0, 420), Position = UDim2.new(0.5, -310, 0.5, -210)})
        tw2:Play(); tw2.Completed:Wait()
        TabsFrame.Visible = true; ContentFrame.Visible = true
    end
end)

CloseBtn.MouseButton1Click:Connect(CloseMenuAnimation)

MinBtn.MouseButton1Click:Connect(function()
    local isMin = MainFrame.Size.Y.Offset == 50
    if not isMin then TabsFrame.Visible = false; ContentFrame.Visible = false end
    local tw = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = isMin and UDim2.new(0, 620, 0, 420) or UDim2.new(0, 620, 0, 50),
        Position = isMin and UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 0.5, -210) or UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 0.5, -25)
    })
    tw:Play()
    if isMin then tw.Completed:Connect(function() TabsFrame.Visible = true; ContentFrame.Visible = true end) end
end)

-- ==========================================
-- HÀM TẠO UI COMPONENTS
-- ==========================================
local Pages = {}
local function CreateTab(name)
    local Btn = Instance.new("TextButton", TabsFrame)
    Btn.Size = UDim2.new(1, -10, 0, 40); Btn.Position = UDim2.new(0, 5, 0, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Text = "  " .. name; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12; Btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    local Page = Instance.new("ScrollingFrame", ContentFrame)
    Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.Visible = false
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    local pad = Instance.new("UIPadding", Page); pad.PaddingTop, pad.PaddingLeft, pad.PaddingRight, pad.PaddingBottom = UDim.new(0,10), UDim.new(0,10), UDim.new(0,10), UDim.new(0,10)
    Pages[name] = {Btn = Btn, Page = Page}
    Btn.MouseButton1Click:Connect(function()
        for n, p in pairs(Pages) do
            p.Page.Visible = (n == name)
            p.Btn.BackgroundColor3 = (n == name) and Color3.fromRGB(255, 100, 200) or Color3.fromRGB(30, 30, 35)
            p.Btn.TextColor3 = (n == name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        end
    end)
    return Page
end

local function CreateToggleSwitch(parent, text, varName, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 40); Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(0.7, 0, 1, 0); Lbl.Position = UDim2.new(0, 10, 0, 0); Lbl.BackgroundTransparency = 1
    Lbl.Text = text; Lbl.TextColor3 = Color3.fromRGB(255, 255, 255); Lbl.Font = Enum.Font.Gotham; Lbl.TextSize = 12; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    local SwitchBG = Instance.new("TextButton", Frame)
    SwitchBG.Size = UDim2.new(0, 40, 0, 20); SwitchBG.Position = UDim2.new(1, -50, 0.5, -10)
    SwitchBG.BackgroundColor3 = Color3.fromRGB(100, 100, 100); SwitchBG.Text = ""
    Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)
    local Knob = Instance.new("Frame", SwitchBG)
    Knob.Size = UDim2.new(0, 16, 0, 16); Knob.Position = UDim2.new(0, 2, 0.5, -8); Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local function UpdateVisuals()
        local state = _G_V10[varName]
        SwitchBG.BackgroundColor3 = state and Color3.fromRGB(255, 100, 200) or Color3.fromRGB(100, 100, 100)
        Knob:TweenPosition(state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.2, true)
    end
    _G_UI_Updaters[varName] = UpdateVisuals

    SwitchBG.MouseButton1Click:Connect(function()
        _G_V10[varName] = not _G_V10[varName]
        UpdateVisuals(); 
        if varName == "AutoLoadConfig" then SaveConfig(_G_V10.SelectedConfig) end
        if varName == "EnableBlackScreen" then BlackScreenUI.Enabled = _G_V10.EnableBlackScreen end
        AutoSaveTrigger()
        if callback then callback(_G_V10[varName]) end
    end)
    UpdateVisuals()
end

local function CreateDropdown(parent, title, itemsList, globalVar, multiSelect, showOrder)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 35); Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40); Frame.ClipsDescendants = true
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    local MainBtn = Instance.new("TextButton", Frame)
    MainBtn.Size = UDim2.new(1, 0, 0, 35); MainBtn.BackgroundTransparency = 1; MainBtn.Text = "  " .. title .. " ▼"
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MainBtn.Font = Enum.Font.Gotham; MainBtn.TextSize = 12; MainBtn.TextXAlignment = Enum.TextXAlignment.Left
    
    local Drop = Instance.new("ScrollingFrame", Frame)
    Drop.Size = UDim2.new(1, 0, 0, 115); Drop.Position = UDim2.new(0, 0, 0, 35); Drop.BackgroundTransparency = 1; Drop.ScrollBarThickness = 2
    local layout = Instance.new("UIListLayout", Drop)

    local function UpdateVisuals()
        if multiSelect then
            local val = _G_V10[globalVar] or {}
            MainBtn.Text = "  " .. title .. ": [" .. #val .. " Đã Chọn] ▼"
            for _, btn in pairs(Drop:GetChildren()) do
                if btn:IsA("TextButton") then 
                    local idx = table.find(val, btn.Name)
                    if idx then 
                        btn.BackgroundColor3 = Color3.fromRGB(255, 100, 200)
                        if showOrder then btn.Text = "[" .. idx .. "] " .. btn.Name else btn.Text = btn.Name end
                    else 
                        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                        btn.Text = btn.Name
                    end
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
            Btn.Name = item
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
        Drop.CanvasSize = UDim2.new(0, 0, 0, #itemsList * 30); UpdateVisuals()
    end
    Refresh(itemsList); UpdateVisuals()
    return Refresh
end

local function CreateButton(parent, text, callback, color)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, 0, 0, 35); Btn.BackgroundColor3 = color or Color3.fromRGB(255, 100, 200)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Text = text; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    Btn.MouseButton1Click:Connect(callback)
end

local function CreateSlider(parent, name, min, max, globalVar)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 45); Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(1, 0, 0, 20); Lbl.Position = UDim2.new(0, 5, 0, 0); Lbl.BackgroundTransparency = 1
    Lbl.Text = name .. ": " .. _G_V10[globalVar]; Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    Lbl.Font = Enum.Font.Gotham; Lbl.TextSize = 12; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderBG = Instance.new("TextButton", Frame)
    SliderBG.Size = UDim2.new(0.95, 0, 0, 10); SliderBG.Position = UDim2.new(0.025, 0, 0, 25); SliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 65); SliderBG.Text = ""
    Instance.new("UICorner", SliderBG).CornerRadius = UDim.new(1,0)
    local Fill = Instance.new("Frame", SliderBG)
    Fill.Size = UDim2.new(0, 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(255, 100, 200)
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)

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
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)
    
    local Lbl = Instance.new("TextLabel", Container)
    Lbl.Size = UDim2.new(1, -10, 0, 20); Lbl.Position = UDim2.new(0, 10, 0, 5)
    Lbl.BackgroundTransparency = 1; Lbl.Text = labelText; Lbl.TextColor3 = Color3.fromRGB(255, 255, 100); Lbl.Font = Enum.Font.GothamBold; Lbl.TextSize = 11; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local Grid = Instance.new("Frame", Container)
    Grid.Size = UDim2.new(1, -10, 0, 25); Grid.Position = UDim2.new(0, 10, 0, 25); Grid.BackgroundTransparency = 1
    local layout = Instance.new("UIListLayout", Grid); layout.FillDirection = Enum.FillDirection.Horizontal; layout.Padding = UDim.new(0, 5)
    
    local skills = {"Z", "X", "C", "V", "B", "F"}
    for _, key in ipairs(skills) do
        local Btn = Instance.new("TextButton", Grid)
        Btn.Size = UDim2.new(0, 35, 0, 22); Btn.Text = key; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
        
        local function UpdateVisuals() Btn.BackgroundColor3 = _G_V10[varPrefix..key] and Color3.fromRGB(255, 100, 200) or Color3.fromRGB(80, 80, 80) end
        _G_UI_Updaters[varPrefix..key] = UpdateVisuals
        
        Btn.MouseButton1Click:Connect(function() _G_V10[varPrefix..key] = not _G_V10[varPrefix..key]; UpdateVisuals(); AutoSaveTrigger() end)
        UpdateVisuals()
    end
end

local function CreateDivider(parent, text, color)
    local LblDivider = Instance.new("TextLabel", parent)
    LblDivider.Size = UDim2.new(1, 0, 0, 20); LblDivider.BackgroundTransparency = 1; LblDivider.TextColor3 = color or Color3.fromRGB(255, 100, 200)
    LblDivider.Font = Enum.Font.GothamBold; LblDivider.TextSize = 13; LblDivider.TextXAlignment = Enum.TextXAlignment.Center; LblDivider.Text = "--- " .. text .. " ---"
end

local function CreateTextBox(parent, placeholder, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 35); Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    local TextBox = Instance.new("TextBox", Frame)
    TextBox.Size = UDim2.new(1, -10, 1, 0); TextBox.Position = UDim2.new(0, 5, 0, 0); TextBox.BackgroundTransparency = 1
    TextBox.Text = ""; TextBox.PlaceholderText = placeholder; TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.Font = Enum.Font.Gotham; TextBox.TextSize = 12; TextBox.ClearTextOnFocus = false
    TextBox.FocusLost:Connect(function() callback(TextBox.Text) end)
end

-- ==========================================
-- XÂY DỰNG TABS
-- ==========================================
local TabConfig = CreateTab("💾 Config (Save/Load)")
local TabAutoLevel = CreateTab("🌟 Farm Level")
local TabFreeFarm = CreateTab("⚔️ Farm Tùy Chọn")
local TabCoordFarm = CreateTab("🗺️ Farm Tọa Độ") -- TAB MỚI
local TabSeaEvent = CreateTab("🌊 Sự Kiện Biển")
local TabRaid = CreateTab("🏰 Auto Raid")
local TabBoss = CreateTab("👹 Boss & Spawn")
local TabIsland = CreateTab("🏝️ Đảo & Bay")
local TabPlayer = CreateTab("🏃 Nhân Vật")
local TabSettings = CreateTab("⚙️ Đổi VK & Skill")
local TabSkills = CreateTab("⚡ Haki & Auto Khác")
local TabServer = CreateTab("🌐 Server System")
local TabScanner = CreateTab("📝 Note & Scan Map")

Pages["💾 Config (Save/Load)"].Btn.BackgroundColor3 = Color3.fromRGB(255, 100, 200)
Pages["💾 Config (Save/Load)"].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabConfig.Visible = true

-- --- TAB: CONFIG ---
local DropConfigs = CreateDropdown(TabConfig, "Chọn Bản Lưu", GetConfigsList(), "SelectedConfig", false)
local ConfigNameInput = "DefaultConfig"
CreateTextBox(TabConfig, "Nhập tên cấu hình để lưu (VD: BeliFarm)", function(text) ConfigNameInput = text end)
CreateButton(TabConfig, "💾 LƯU BẢN HIỆN TẠI (SAVE)", function() SaveConfig(ConfigNameInput ~= "" and ConfigNameInput or _G_V10.SelectedConfig); DropConfigs(GetConfigsList()); game.StarterGui:SetCore("SendNotification", {Title = "Lưu Thành Công", Text = "Đã lưu cấu hình!", Duration = 3}) end)
CreateButton(TabConfig, "📂 TẢI BẢN ĐÃ CHỌN (LOAD)", function() LoadConfig(_G_V10.SelectedConfig); game.StarterGui:SetCore("SendNotification", {Title = "Tải Thành Công", Text = "Đã tải cấu hình!", Duration = 3}) end)
CreateDivider(TabConfig, "CÔNG TẮC AUTO LƯU/TẢI & BYPASS", Color3.fromRGB(0, 200, 255))
CreateToggleSwitch(TabConfig, "Bật Auto Lưu (Lưu mỗi khi thay đổi)", "AutoSaveConfig")
CreateToggleSwitch(TabConfig, "Bật Auto Load (Khi vào lại game)", "AutoLoadConfig")
CreateToggleSwitch(TabConfig, "Bật Auto Bypass Load Data/Play Lúc Mới Mở", "AutoBypassMenu")
CreateSlider(TabConfig, "Thời Gian Chạy Bypass Lúc Đầu (Giây)", 1, 100, "BypassDuration")
CreateButton(TabConfig, "⚠️ RESET TOÀN BỘ MENU VỀ MẶC ĐỊNH", function()
    for k, v in pairs(DefaultConfig) do if k ~= "ScannedMonstersList" and k ~= "ScannerData" then _G_V10[k] = v end end
    for _, updater in pairs(_G_UI_Updaters) do pcall(updater) end
    SaveConfig(_G_V10.SelectedConfig); game.StarterGui:SetCore("SendNotification", {Title = "Reset", Text = "Đã làm mới toàn bộ Menu!", Duration = 3})
end, Color3.fromRGB(200, 50, 50))

-- --- TAB: FARM TỌA ĐỘ (MỚI THEO YÊU CẦU) ---
local LblCoordInfo = Instance.new("TextLabel", TabCoordFarm)
LblCoordInfo.Size = UDim2.new(1, 0, 0, 20); LblCoordInfo.BackgroundTransparency = 1; LblCoordInfo.TextColor3 = Color3.fromRGB(255, 255, 100); LblCoordInfo.Font = Enum.Font.Gotham; LblCoordInfo.TextSize = 13; LblCoordInfo.TextXAlignment = Enum.TextXAlignment.Left; LblCoordInfo.Text = "Trạng thái Farm Tọa Độ: Đang rảnh..."

CreateDivider(TabCoordFarm, "FARM QUÁI THEO TỌA ĐỘ (ƯU TIÊN LEVEL)", Color3.fromRGB(50, 255, 150))
CreateDropdown(TabCoordFarm, "Chọn Quái Trong List", CoordMobNames, "SelectedCoordMobs", true, false)
CreateToggleSwitch(TabCoordFarm, "Bật Tự Động Farm Quái Tọa Độ", "AutoCoordMob")

CreateDivider(TabCoordFarm, "FARM BOSS THEO TỌA ĐỘ (ƯU TIÊN THỨ TỰ)", Color3.fromRGB(255, 50, 150))
CreateDropdown(TabCoordFarm, "Chọn Boss Trong List", CoordBossNames, "SelectedCoordBosses", true, true) -- true để hiện [1] [2]
CreateToggleSwitch(TabCoordFarm, "Bật Tự Động Săn Boss Tọa Độ", "AutoCoordBoss")
CreateSlider(TabCoordFarm, "Delay Check Boss Spawns (Giây)", 10, 1000, "BossCheckDelay")

-- --- CÁC TAB CŨ GIỮ NGUYÊN 100% ---
local LblInfo = Instance.new("TextLabel", TabAutoLevel)
LblInfo.Size = UDim2.new(1, 0, 0, 20); LblInfo.BackgroundTransparency = 1; LblInfo.TextColor3 = Color3.fromRGB(255, 255, 100); LblInfo.Font = Enum.Font.Gotham; LblInfo.TextSize = 13; LblInfo.TextXAlignment = Enum.TextXAlignment.Left; LblInfo.Text = "Trạng thái: Đang chờ..."
CreateToggleSwitch(TabAutoLevel, "Bật Auto Farm Level (Tự Chuyển Bãi)", "AutoFarmLevel")
CreateDropdown(TabAutoLevel, "Chọn Quest Bằng Tay", QuestListNames, "SelectedManualQuest", false)
CreateToggleSwitch(TabAutoLevel, "Bật Đánh Quest Đã Chọn Trên", "ManualQuestFarm")
CreateToggleSwitch(TabAutoLevel, "Bật Tự Động Đánh (Click)", "AutoClick")

local DropMonsters = CreateDropdown(TabFreeFarm, "Chọn Quái Cần Đánh (Nhiều Con)", _G_V10.ScannedMonstersList, "SelectedMonsters", true)
CreateButton(TabFreeFarm, "🔍 Quét Quái Thêm Vào Danh Sách", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(v) then
            local isEx = false
            for _, ex in pairs(_G_V10.ExcludedMobs) do if string.find(string.lower(v.Name), ex) then isEx = true; break end end
            if not isEx and not table.find(_G_V10.ScannedMonstersList, v.Name) then table.insert(_G_V10.ScannedMonstersList, v.Name) end
        end
    end
    table.sort(_G_V10.ScannedMonstersList); DropMonsters(_G_V10.ScannedMonstersList); AutoSaveTrigger()
end)
CreateToggleSwitch(TabFreeFarm, "Bật Free Farm (Đánh danh sách trên)", "AutoFarmFree")
CreateToggleSwitch(TabFreeFarm, "Bật Farm ALL (Càn quét Map)", "FarmAll")

local LblSeaInfo = Instance.new("TextLabel", TabSeaEvent)
LblSeaInfo.Size = UDim2.new(1, 0, 0, 20); LblSeaInfo.BackgroundTransparency = 1; LblSeaInfo.TextColor3 = Color3.fromRGB(0, 255, 200); LblSeaInfo.Font = Enum.Font.Gotham; LblSeaInfo.TextSize = 13; LblSeaInfo.TextXAlignment = Enum.TextXAlignment.Left; LblSeaInfo.Text = "Trạng thái Biển: Đang rảnh..."
CreateToggleSwitch(TabSeaEvent, "Bật Auto Sea Event", "AutoSea")
CreateToggleSwitch(TabSeaEvent, "Săn Sea Monster (Bay Vòng Tròn)", "HuntSeaMonster")
CreateToggleSwitch(TabSeaEvent, "Săn Thuyền Ma (The Starving Ghost)", "HuntGhost")
CreateToggleSwitch(TabSeaEvent, "Tự Động Ngồi Lái Thuyền", "AutoSitBoat")

CreateDivider(TabRaid, "MUA RAID & JOIN GAME", Color3.fromRGB(255, 100, 100))
CreateToggleSwitch(TabRaid, "Bật Tự Động Mua Raid / Re-Raid", "AutoBuyRaid")
CreateSlider(TabRaid, "Delay Teleport Mua Raid (Giây)", 1, 10, "RaidBuyTeleportDelay")
CreateToggleSwitch(TabRaid, "Bật Tự Động Bấm Starto (Bắt đầu Raid)", "AutoStartRaid")
CreateToggleSwitch(TabRaid, "Tự Động Bấm Play/Join Game (Dùng Remote)", "AutoJoinGame")
CreateDivider(TabRaid, "AUTO FARM QUÁI TRONG RAID", Color3.fromRGB(255, 150, 50))
CreateToggleSwitch(TabRaid, "Bật Auto Farm Quái Raid (Tự dọn dẹp map)", "AutoFarmRaid")
CreateDivider(TabRaid, "CƠ CHẾ DI CHUYỂN KHI HẾT QUÁI RAID", Color3.fromRGB(255, 150, 50))
CreateDropdown(TabRaid, "Chờ ở Tọa độ 1 (Giây)", {"10", "20", "30"}, "RaidWaitC1", false)
CreateDropdown(TabRaid, "Chờ ở Tọa độ 2 (Giây)", {"10", "20", "30"}, "RaidWaitC2", false)
CreateDropdown(TabRaid, "Chờ ở Tọa độ 3 (Giây)", {"10", "20", "30"}, "RaidWaitC3", false)
CreateDivider(TabRaid, "TELEPORT RAID CŨ", Color3.fromRGB(255, 100, 100))
CreateToggleSwitch(TabRaid, "Teleport Đến Cửa Raid (Ngoài Map)", "AutoTeleEntrance")
CreateSlider(TabRaid, "Delay Teleport Ra Cửa Ngoài Map (Giây)", 1, 10, "RaidEntranceDelay")

CreateDivider(TabBoss, "AUTO SPAWN MIHAWK", Color3.fromRGB(150, 100, 255))
CreateToggleSwitch(TabBoss, "Bật Auto Spawn Mihawk", "AutoSpawnMihawk")
CreateDropdown(TabBoss, "Chọn Lượng Spawn Mihawk", {"x100", "x10", "x1"}, "MihawkAmount", false)
CreateDivider(TabBoss, "AUTO GIVE SHADOW BOSS", Color3.fromRGB(150, 100, 255))
CreateToggleSwitch(TabBoss, "Bật Auto Give Item Cho Shadow", "AutoGiveShadow")
CreateDropdown(TabBoss, "Chọn Vật Phẩm Give", {"Shadow Spirit", "Rotten Flesh", "Aqua Soul", "Bone", "Blood Bottle"}, "ShadowItem", false)
CreateDropdown(TabBoss, "Chọn Số Lượng Give", {"x1", "x5", "x10"}, "ShadowAmount", false)

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
    if _G_V10.SelectedIsland then
        local isl = workspace:FindFirstChild("All") and workspace.All:FindFirstChild("Island") and workspace.All.Island:FindFirstChild(_G_V10.SelectedIsland)
        if isl then InstantTeleport(isl:GetPivot() + Vector3.new(0, 50, 0)) end
    elseif _G_V10.SelectedSpawnPoint then
        local sp = workspace:FindFirstChild("SetSpawnPoints") and workspace.SetSpawnPoints:FindFirstChild(_G_V10.SelectedSpawnPoint)
        if sp then InstantTeleport(sp.CFrame + Vector3.new(0, 5, 0)) end
    end
end)

CreateToggleSwitch(TabPlayer, "Bật Hack Tốc Độ Chạy", "EnableSpeed")
CreateSlider(TabPlayer, "Tốc Độ Chạy (WalkSpeed)", 16, 250, "WalkSpeed")
CreateToggleSwitch(TabPlayer, "Bật Hack Nhảy Cao", "EnableJump")
CreateSlider(TabPlayer, "Lực Nhảy (JumpPower)", 50, 300, "JumpPower")
CreateToggleSwitch(TabPlayer, "Nhảy Vô Hạn (Infinity Jump)", "InfJump")
CreateToggleSwitch(TabPlayer, "Lướt Không Hồi Chiêu (Dash No CD)", "DashNoCD")
CreateToggleSwitch(TabPlayer, "🚀 Bay Tự Do (Dùng Cần Gạt Di Chuyển/W,A,S,D)", "FreeFly")
CreateSlider(TabPlayer, "Tốc Độ Bay Tự Do", 50, 500, "FreeFlySpeed")

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

CreateToggleSwitch(TabServer, "Bảo Vệ: Chống Văng (Anti-AFK 20 phút)", "AntiAFK")
CreateButton(TabServer, "♻️ Rejoin (Vào Lại Server Cũ)", function() TPS:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
CreateButton(TabServer, "🌐 Hop Server (Đổi Server Khác)", function()
    local req = request or http_request or syn.request
    if req then
        local res = req({Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"})
        local body = HttpService:JSONDecode(res.Body)
        if body and body.data then for _, v in ipairs(body.data) do if v.playing < v.maxPlayers and v.id ~= game.JobId then TPS:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer); break end end end
    end
end)
CreateButton(TabServer, "📉 Hop Server Ít Người", function()
    local req = request or http_request or syn.request
    if req then
        local res = req({Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"})
        local body = HttpService:JSONDecode(res.Body)
        if body and body.data then for _, v in ipairs(body.data) do if v.playing < v.maxPlayers and v.playing > 0 and v.id ~= game.JobId then TPS:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer); break end end end
    end
end)
CreateButton(TabServer, "🚀 Boost FPS (Xóa Đồ Họa Mượt Game)", function()
    game.Lighting.GlobalShadows = false; game.Lighting.FogEnd = 9e9
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.Plastic; v.Reflectance = 0 end
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
end)
CreateToggleSwitch(TabServer, "Màn Hình Đen (Giảm Lag Treo Máy)", "EnableBlackScreen")

CreateDivider(TabScanner, "HỆ THỐNG MÁY QUÉT TOÀN MAP", Color3.fromRGB(200, 100, 255))
CreateToggleSwitch(TabScanner, "Bật Máy Quét Map Thông Minh", "AutoScanMap")
local ScanLogFrame = Instance.new("ScrollingFrame", TabScanner)
ScanLogFrame.Size = UDim2.new(1, 0, 0, 280); ScanLogFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); ScanLogFrame.ScrollBarThickness = 3
txtLog = Instance.new("TextLabel", ScanLogFrame)
txtLog.Size = UDim2.new(1, -10, 1, 0); txtLog.BackgroundTransparency = 1; txtLog.RichText = true; txtLog.Text = "Đang chờ quét..."
txtLog.TextXAlignment = Enum.TextXAlignment.Left; txtLog.TextYAlignment = Enum.TextYAlignment.Top; txtLog.Font = Enum.Font.GothamBold; txtLog.TextSize = 12; txtLog.TextWrapped = true; txtLog.Position = UDim2.new(0, 5, 0, 5)
CreateButton(TabScanner, "📋 COPY TOÀN BỘ DATA MÁY QUÉT", function()
    if setclipboard then
        local cleanTxt = string.gsub(txtLog.Text, "<[^>]+>", "")
        setclipboard(cleanTxt); game.StarterGui:SetCore("SendNotification", {Title = "Đã Copy", Text = "Dữ liệu đã nằm trong bộ nhớ tạm!", Duration = 3})
    end
end)

RenderScannerLog()

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

-- 🚀 FIX MAX CẤP: Chỉ chạm sát mét phải Hide GUI (Chắc chắn an toàn 100%)
local function TapSafeEdge()
    local cam = workspace.CurrentCamera
    if cam then
        local safeX = cam.ViewportSize.X * 0.70 -- 70% bề ngang, lệch hẳn sang phải Hide GUI
        VIM:SendMouseButtonEvent(safeX, 20, 0, true, game, 0)
        task.wait(0.05); VIM:SendMouseButtonEvent(safeX, 20, 0, false, game, 0)
    end
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

local function PressKey(key)
    VIM:SendKeyEvent(true, Enum.KeyCode[key], false, game)
    task.spawn(function() task.wait(0.05); VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game) end)
end

-- ==========================================
-- ENGINE: MÁY QUÉT MAP THÔNG MINH (LƯU VĨNH VIỄN)
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
    while task.wait(3) do
        if not _G_V10.AutoScanMap then continue end
        local hasNewData = false
        
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(v) then
                local hrp = v:FindFirstChild("HumanoidRootPart"); local hum = v:FindFirstChild("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local nameStr = v.Name
                    local isEx = false
                    for _, ex in pairs(_G_V10.ExcludedMobs) do if string.find(string.lower(nameStr), ex) then isEx = true; break end end
                    
                    if not isEx and not _G_V10.ScannerData.Mobs[nameStr] and not _G_V10.ScannerData.Bosses[nameStr] then
                        local isl = GetClosestIsland(hrp.Position)
                        local pos = string.format("Vector3.new(%.0f, %.0f, %.0f)", hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
                        if hum.MaxHealth > 50000 then _G_V10.ScannerData.Bosses[nameStr] = {Island = isl, Pos = pos, Level = hum.MaxHealth}
                        else _G_V10.ScannerData.Mobs[nameStr] = {Island = isl, Pos = pos, Level = hum.MaxHealth} end
                        hasNewData = true
                    end
                end
            end
            if v:IsA("Model") and (v.Name == "NPC" or v.Parent and v.Parent.Name == "NPC") and v:FindFirstChild("HumanoidRootPart") then
                local nameStr = v.Name
                if not _G_V10.ScannerData.NPCs[nameStr] then
                    local isl = GetClosestIsland(v.HumanoidRootPart.Position)
                    local pos = string.format("Vector3.new(%.0f, %.0f, %.0f)", v.HumanoidRootPart.Position.X, v.HumanoidRootPart.Position.Y, v.HumanoidRootPart.Position.Z)
                    _G_V10.ScannerData.NPCs[nameStr] = {Island = isl, Pos = pos}
                    hasNewData = true
                end
            end
        end
        if hasNewData then AutoSaveTrigger(); RenderScannerLog() end
    end
end)

-- ==========================================
-- ENGINE: AUTO BYPASS MAIN MENU (THEO GIÂY & AN TOÀN)
-- ==========================================
task.spawn(function()
    if not _G_V10.AutoBypassMenu then return end
    local endTime = os.clock() + _G_V10.BypassDuration
    while os.clock() < endTime do
        task.wait(0.1)
        TapSafeEdge() -- Chỉ nháy siêu nhanh ở rìa trên phải màn hình
    end
end)

-- ==========================================
-- ENGINE: SPAM THOẠI CHO BOSS & SHADOW 
-- ==========================================
task.spawn(function()
    while task.wait(0.2) do
        if _G_V10.AutoSpawnMihawk or _G_V10.AutoGiveShadow or _G_V10.AutoBuyRaid then
            local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
            if talkingGui then TapSafeEdge() end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do 
        if not _G_V10.AutoSpawnMihawk then continue end
        local char = LocalPlayer.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        local target = Vector3.new(-1380, 77, 3904)
        if (hrp.Position - target).Magnitude > 50 then hrp.CFrame = CFrame.new(target); task.wait(1.5) end
        
        local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
        if not talkingGui then
            local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Stone Statue")
            if npc then task.spawn(function() pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end) end) end
        else
            local amtBtn = SmartFindButton(talkingGui, _G_V10.MihawkAmount)
            if amtBtn then PhysicalClick(amtBtn) end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if not _G_V10.AutoGiveShadow then continue end
        local char = LocalPlayer.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        local target = Vector3.new(-10371, 100, -3519)
        if (hrp.Position - target).Magnitude > 50 then hrp.CFrame = CFrame.new(target); task.wait(1.5) end
        
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
end)

-- ==========================================
-- ENGINE: MUA RAID & TUẦN TRA RAID (PATROL AI C1-C2-C3)
-- ==========================================
local raidPatrolState = "Wait_C1"
local raidPatrolTimer = os.clock()
local C1 = CFrame.new(-77, 119, -258)
local C2 = CFrame.new(-101, 114, 382)
local C3 = CFrame.new(-124, 114, 404)
local lastRaidTeleport = os.clock()

local function IsRaidClear()
    local monsterFolder = Workspace:FindFirstChild("Monster")
    if not monsterFolder then return true end
    for _, v in pairs(monsterFolder:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then return false end
    end
    return true
end

task.spawn(function()
    while task.wait(0.5) do
        if _G_V10.AutoJoinGame then
            pcall(function() ReplicatedStorage.Assets.Remote.RemoteEvent.Di:FireServer() end)
            pcall(function() ReplicatedStorage.Assets.Remote.RemoteEvent.Home:FireServer("Dark Castle", "Sea", true) end)
        end
        
        local char = LocalPlayer.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hrp or char.Humanoid.Health <= 0 then continue end
        
        local distToRaidMap = (hrp.Position - Vector3.new(-123, 114, 407)).Magnitude
        
        if distToRaidMap < 3000 then 
            if _G_V10.AutoStartRaid then pcall(function() ReplicatedStorage.Assets.Remote.RemoteEvent.Starto:FireServer() end) end
            
            if _G_V10.AutoBuyRaid then
                local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
                if not talkingGui then
                    if not _G_V10.AutoFarmRaid then
                        local targetPos = Vector3.new(-123, 114, 407)
                        if (hrp.Position - targetPos).Magnitude > 20 then
                            hrp.CFrame = CFrame.new(targetPos); task.wait(_G_V10.RaidBuyTeleportDelay)
                        end
                    end
                    local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Dazzl")
                    if npc and (hrp.Position - npc:GetPivot().Position).Magnitude < 30 then
                        task.spawn(function() pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end) end)
                    end
                else
                    local buyBtn = SmartFindButton(talkingGui, "Buy with Beli")
                    if buyBtn then PhysicalClick(buyBtn) end
                end
            end
        else
            if _G_V10.AutoBuyRaid then
                local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
                if not talkingGui then
                    local targetPos = Vector3.new(-1371, 79, 3982)
                    if (hrp.Position - targetPos).Magnitude > 20 then
                        hrp.CFrame = CFrame.new(targetPos); task.wait(_G_V10.RaidBuyTeleportDelay)
                    end
                    local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Dazzl")
                    if npc and (hrp.Position - npc:GetPivot().Position).Magnitude < 30 then
                        task.spawn(function() pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end) end)
                    end
                else
                    local buyBtn = SmartFindButton(talkingGui, "Buy with Beli")
                    if buyBtn then PhysicalClick(buyBtn) end
                end
            end
            
            if _G_V10.AutoTeleEntrance and os.clock() - lastRaidTeleport >= _G_V10.RaidEntranceDelay then
                hrp.CFrame = CFrame.new(-1346, 79, 3989); lastRaidTeleport = os.clock()
            end
        end
    end
end)

-- ==========================================
-- ENGINE: FARM TỌA ĐỘ AI & CÁC CHỨC NĂNG CŨ
-- ==========================================
task.spawn(function()
    while task.wait(1) do
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if char and hum and hum.Health > 0 then
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
    if _G_V10.DashNoCD and k.KeyCode == Enum.KeyCode.Q then
        local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            local bv = Instance.new("BodyVelocity"); bv.MaxForce = Vector3.new(100000, 0, 100000); bv.Velocity = HRP.CFrame.lookVector * 150; bv.Parent = HRP
            game.Debris:AddItem(bv, 0.2)
        end
    end
    if gp then return end
    if k.KeyCode == Enum.KeyCode.W then flyKeys.W = 1 elseif k.KeyCode == Enum.KeyCode.S then flyKeys.S = 1 elseif k.KeyCode == Enum.KeyCode.A then flyKeys.A = 1 elseif k.KeyCode == Enum.KeyCode.D then flyKeys.D = 1 elseif k.KeyCode == Enum.KeyCode.Space then flyKeys.Up = 1 elseif k.KeyCode == Enum.KeyCode.LeftControl then flyKeys.Down = 1 end
end)
UIS.InputEnded:Connect(function(k, gp)
    if gp then return end
    if k.KeyCode == Enum.KeyCode.W then flyKeys.W = 0 elseif k.KeyCode == Enum.KeyCode.S then flyKeys.S = 0 elseif k.KeyCode == Enum.KeyCode.A then flyKeys.A = 0 elseif k.KeyCode == Enum.KeyCode.D then flyKeys.D = 0 elseif k.KeyCode == Enum.KeyCode.Space then flyKeys.Up = 0 elseif k.KeyCode == Enum.KeyCode.LeftControl then flyKeys.Down = 0 end
end)

local function EnableAntiFall(HRP)
    if not HRP:FindFirstChild("FarmAntiFall") then
        local AntiFall = Instance.new("BodyVelocity"); AntiFall.Name = "FarmAntiFall"; AntiFall.MaxForce = Vector3.new(9e9, 9e9, 9e9); AntiFall.Velocity = Vector3.new(0, 0, 0); AntiFall.Parent = HRP
    end
end
local function DisableAntiFall(HRP) if HRP:FindFirstChild("FarmAntiFall") then HRP.FarmAntiFall:Destroy() end end

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        
        local isNormalFarming = _G_V10.AutoFarmLevel or _G_V10.ManualQuestFarm or _G_V10.AutoFarmFree or _G_V10.FarmAll or _G_V10.AutoFarmRaid or _G_V10.AutoCoordMob or _G_V10.AutoCoordBoss
        if isNormalFarming and not _G_V10.FreeFly then
            EnableAntiFall(hrp)
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0); hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            if hrp:FindFirstChild("FarmAntiFall") then hrp.FarmAntiFall.Velocity = Vector3.new(0, 0, 0) end
        end

        if isNormalFarming or (_G_V10.AutoSea and _G_V10.IsFightingSea) then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end

        if _G_V10.FreeFly then
            hum:ChangeState(Enum.HumanoidStateType.Physics)
            if not hrp:FindFirstChild("V10_FreeFlyBV") then
                local bv = Instance.new("BodyVelocity", hrp); bv.Name = "V10_FreeFlyBV"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            end
            local cam = workspace.CurrentCamera
            local moveDir = hum.MoveDirection
            local bv = hrp:FindFirstChild("V10_FreeFlyBV")
            if moveDir.Magnitude > 0 then bv.Velocity = cam.CFrame.LookVector * _G_V10.FreeFlySpeed else bv.Velocity = Vector3.new(0, 0, 0) end
            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
        else
            if hrp:FindFirstChild("V10_FreeFlyBV") then hrp["V10_FreeFlyBV"]:Destroy() end
            if hum:GetState() == Enum.HumanoidStateType.Physics then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        end
    end
end)

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

-- ==========================================
-- MAIN COMBAT ENGINE (BAO GỒM FARM TỌA ĐỘ)
-- ==========================================
local currentSwapState = 1
local lastSwapTime = os.clock()
local lastSkillSpamTime = os.clock()
local lastBossCheckTime = os.clock()

local function isValidMobByDatabase(mob)
    if not mob or not mob:IsA("Model") then return false end
    local hum = mob:FindFirstChild("Humanoid")
    local hrp = mob:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp or hum.Health <= 0 then return false end
    if mob.Name == LocalPlayer.Name or Players:GetPlayerFromCharacter(mob) then return false end
    return true
end

task.spawn(function()
    while task.wait() do
        local char = LocalPlayer.Character
        if not char then continue end
        local HRP = char:FindFirstChild("HumanoidRootPart")
        local Hum = char:FindFirstChild("Humanoid")
        
        if not HRP or not Hum or Hum.Health <= 0 then 
            if HRP and HRP:FindFirstChild("FarmAntiFall") then HRP.FarmAntiFall:Destroy() end
            task.wait(1); continue 
        end

        _G_V10.CurrentTargetMob = nil
        if _G_V10.AutoFarmLevel then
            local mob, qName = GetMobForCurrentLevel(); _G_V10.CurrentTargetMob = {mob}; Title.Text = "🌸 YuiHub (Farm: " .. qName .. ")"
        elseif _G_V10.ManualQuestFarm and _G_V10.SelectedManualQuest then
            for _, v in pairs(QuestDB) do if v.QuestName == _G_V10.SelectedManualQuest then _G_V10.CurrentTargetMob = {v.MobName}; Title.Text = "🌸 YuiHub (Farm: " .. v.QuestName .. ")" end end
        elseif _G_V10.AutoCoordBoss then LblCoordInfo.Text = "Tọa độ: Đang săn Boss..."
        elseif _G_V10.AutoCoordMob then LblCoordInfo.Text = "Tọa độ: Đang săn Mobs..."
        elseif _G_V10.AutoFarmFree and type(_G_V10.SelectedMonsters) == "table" and #_G_V10.SelectedMonsters > 0 then
            _G_V10.CurrentTargetMob = _G_V10.SelectedMonsters; Title.Text = "🌸 YuiHub (Đang Farm Tự Do)"
        elseif _G_V10.FarmAll then Title.Text = "🌸 YuiHub (Đang Càn Quét)"
        elseif _G_V10.AutoFarmRaid then Title.Text = "🌸 YuiHub (Đang Dọn Raid)"
        else Title.Text = "🌸 YuiHub <font size='12' color='#aaaaaa'><i>- Chào mừng đến với hub của tôi</i></font>" end

        if _G_V10.AutoRepeatQuest then RepeatQuestRemote() end

        local isNormalFarming = _G_V10.AutoFarmLevel or _G_V10.ManualQuestFarm or _G_V10.AutoFarmFree or _G_V10.FarmAll or _G_V10.AutoFarmRaid or _G_V10.AutoCoordBoss or _G_V10.AutoCoordMob
        local isFarmingAction = isNormalFarming or (_G_V10.AutoSea and _G_V10.IsFightingSea)
        
        if isFarmingAction and not _G_V10.FreeFly then
            local targetMobInstance = nil
            local highestLevel = -1
            local shortestDist = math.huge
            local targetWaitPos = nil
            
            -- ================= LÕI TÌM TARGET =================
            if not (_G_V10.AutoSea and _G_V10.IsFightingSea) then
                
                -- 1. Ưu Tiên Farm Tọa Độ Boss (Theo Thứ Tự List)
                if _G_V10.AutoCoordBoss and #_G_V10.SelectedCoordBosses > 0 then
                    for _, bossName in ipairs(_G_V10.SelectedCoordBosses) do
                        local foundBoss = nil
                        for _, v in pairs(workspace:GetDescendants()) do
                            if isValidMobByDatabase(v) and v.Name == bossName then
                                foundBoss = v; break
                            end
                        end
                        if foundBoss then
                            targetMobInstance = foundBoss
                            LblCoordInfo.Text = "Tọa độ: Đang đấm " .. bossName
                            break
                        end
                    end
                    
                    -- Nếu Boss chưa ra, chờ check Spawn
                    if not targetMobInstance then
                        if os.clock() - lastBossCheckTime >= _G_V10.BossCheckDelay then
                            LblCoordInfo.Text = "Tọa độ: Đang check vị trí Boss..."
                            local firstBoss = _G_V10.SelectedCoordBosses[1]
                            targetWaitPos = CoordDB.Bosses[firstBoss] and CoordDB.Bosses[firstBoss].Pos
                            lastBossCheckTime = os.clock()
                        else
                            LblCoordInfo.Text = string.format("Tọa độ: Đợi %d s để check Boss tiếp theo...", math.floor(_G_V10.BossCheckDelay - (os.clock() - lastBossCheckTime)))
                        end
                    end
                end
                
                -- 2. Nếu không đánh Boss, ưu tiên Farm Tọa Độ Mob (Ưu tiên max Level)
                if not targetMobInstance and _G_V10.AutoCoordMob and #_G_V10.SelectedCoordMobs > 0 then
                    local bestMob = nil; local maxLvlFound = -1
                    
                    for _, v in pairs(workspace:GetDescendants()) do
                        if isValidMobByDatabase(v) and table.find(_G_V10.SelectedCoordMobs, v.Name) then
                            local dbInfo = CoordDB.Mobs[v.Name]
                            local lvl = dbInfo and dbInfo.Level or 0
                            if lvl > maxLvlFound then
                                maxLvlFound = lvl; bestMob = v
                            end
                        end
                    end
                    
                    if bestMob then 
                        targetMobInstance = bestMob
                        LblCoordInfo.Text = "Tọa độ: Đang dọn " .. bestMob.Name .. " (Lv " .. maxLvlFound .. ")"
                    else
                        -- Không thấy -> Lấy tọa độ con cao nhất để đứng chờ
                        local waitLvl = -1
                        for _, mName in ipairs(_G_V10.SelectedCoordMobs) do
                            local dbInfo = CoordDB.Mobs[mName]
                            if dbInfo and dbInfo.Level > waitLvl then
                                waitLvl = dbInfo.Level; targetWaitPos = dbInfo.Pos
                            end
                        end
                        LblCoordInfo.Text = "Tọa độ: Đang chờ Mobs (Lv " .. waitLvl .. ") ra..."
                    end
                end

                -- 3. Farm Thường (Cũ)
                if not _G_V10.AutoCoordBoss and not _G_V10.AutoCoordMob then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if isValidMobByDatabase(v) then
                            local isValidTarget = false
                            local isEx = false
                            for _, ex in pairs(_G_V10.ExcludedMobs) do if string.find(string.lower(v.Name), ex) then isEx = true break end end
                            
                            if not isEx then
                                if _G_V10.AutoFarmRaid and v.Parent and v.Parent.Name == "Monster" then
                                    local distToRaidMap = (HRP.Position - Vector3.new(-123, 114, 407)).Magnitude
                                    if distToRaidMap < 3000 then isValidTarget = true end
                                elseif _G_V10.FarmAll then isValidTarget = true
                                elseif _G_V10.CurrentTargetMob and type(_G_V10.CurrentTargetMob) == "table" and table.find(_G_V10.CurrentTargetMob, v.Name) then 
                                    isValidTarget = true 
                                end
                            end
                            
                            if isValidTarget then
                                local dist = (HRP.Position - v.HumanoidRootPart.Position).Magnitude
                                local lvlMatch = string.match(v.Name, "%[%D*(%d+)%]")
                                local mobLvl = lvlMatch and tonumber(lvlMatch) or 0
                                
                                if mobLvl > highestLevel then
                                    highestLevel = mobLvl; shortestDist = dist; targetMobInstance = v
                                elseif mobLvl == highestLevel then
                                    if dist < shortestDist then shortestDist = dist; targetMobInstance = v end
                                end
                            end
                        end
                    end
                end
            end

            -- ================= XỬ LÝ HÀNH ĐỘNG =================
            if targetMobInstance or (_G_V10.AutoSea and _G_V10.IsFightingSea) then
                raidPatrolState = "Wait_C1"; raidPatrolTimer = os.clock()
                
                if _G_V10.AutoSwapWeapon and _G_V10.PrimaryWeapon and _G_V10.SecondaryWeapon then
                    if currentSwapState == 1 then
                        local wp = LocalPlayer.Backpack:FindFirstChild(_G_V10.PrimaryWeapon)
                        if wp then Hum:EquipTool(wp) end
                        if os.clock() - lastSwapTime >= _G_V10.HoldTime1 then currentSwapState = 2; lastSwapTime = os.clock() end
                    elseif currentSwapState == 2 then
                        local wp = LocalPlayer.Backpack:FindFirstChild(_G_V10.SecondaryWeapon)
                        if wp then Hum:EquipTool(wp) end
                        if os.clock() - lastSwapTime >= _G_V10.HoldTime2 then currentSwapState = 1; lastSwapTime = os.clock() end
                    end
                elseif _G_V10.AutoEquip and _G_V10.SelectedWeapon then
                    local wp = LocalPlayer.Backpack:FindFirstChild(_G_V10.SelectedWeapon)
                    if wp then Hum:EquipTool(wp) end
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
                
                if targetMobInstance then
                    local mobPos = targetMobInstance.HumanoidRootPart.CFrame
                    local offset = CFrame.new(0, _G_V10.AttackDistance, 0) * CFrame.Angles(math.rad(-90),0,0)
                    if _G_V10.AttackPosition == "Đằng Sau" then offset = CFrame.new(0, 0, _G_V10.AttackDistance)
                    elseif _G_V10.AttackPosition == "Dưới Chân" then offset = CFrame.new(0, -_G_V10.AttackDistance, 0) end
                    HRP.CFrame = mobPos * offset
                end
            else
                -- NẾU KHÔNG CÓ QUÁI
                if targetWaitPos then
                    -- TELEPORT CHỜ FARM TỌA ĐỘ
                    if (HRP.Position - targetWaitPos).Magnitude > 50 then HRP.CFrame = CFrame.new(targetWaitPos) end
                elseif _G_V10.AutoFarmRaid then
                    -- TUẦN TRA RAID (C1-C2-C3)
                    local distToRaidMap = (HRP.Position - Vector3.new(-123, 114, 407)).Magnitude
                    if distToRaidMap < 3000 then
                        Title.Text = "🌸 YuiHub (Tuần tra: " .. raidPatrolState .. ")"
                        if raidPatrolState == "Wait_C1" then
                            if (HRP.Position - C1.Position).Magnitude > 10 then HRP.CFrame = C1; raidPatrolTimer = os.clock()
                            elseif os.clock() - raidPatrolTimer >= tonumber(_G_V10.RaidWaitC1) then raidPatrolState = "Wait_C2"; raidPatrolTimer = os.clock() end
                        elseif raidPatrolState == "Wait_C2" then
                            if (HRP.Position - C2.Position).Magnitude > 10 then HRP.CFrame = C2; raidPatrolTimer = os.clock()
                            elseif os.clock() - raidPatrolTimer >= tonumber(_G_V10.RaidWaitC2) then raidPatrolState = "Wait_C3"; raidPatrolTimer = os.clock() end
                        elseif raidPatrolState == "Wait_C3" then
                            if (HRP.Position - C3.Position).Magnitude > 10 then HRP.CFrame = C3; raidPatrolTimer = os.clock()
                            elseif os.clock() - raidPatrolTimer >= tonumber(_G_V10.RaidWaitC3) then raidPatrolState = "Wait_C2"; raidPatrolTimer = os.clock() end
                        end
                    end
                end
                if HRP:FindFirstChild("FarmAntiFall") then HRP.FarmAntiFall.Velocity = Vector3.new(0,0,0) end
            end
        else
            if HRP and HRP:FindFirstChild("FarmAntiFall") then HRP.FarmAntiFall:Destroy() end
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
            _G_V10.ArrivedAtZone = false; continue 
        else wasAutoSeaOn = true end
        
        local char = LocalPlayer.Character; local HRP = char and char:FindFirstChild("HumanoidRootPart"); local Hum = char and char:FindFirstChild("Humanoid")
        if not char or not HRP or not Hum or Hum.Health <= 0 then continue end

        local targetMonster = GetTargetSeaEvent()
        local myBoatName = LocalPlayer.Name .. "Boat"; local boatFolder = workspace:FindFirstChild("Boats"); local myBoat = boatFolder and boatFolder:FindFirstChild(myBoatName)

        if targetMonster then
            _G_V10.IsFightingSea = true; VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game); if Hum.Sit then Hum.Sit = false end
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
                _G_V10.ArrivedAtZone = false;
                local spawner = workspace:FindFirstChild("NPC") and workspace.NPC:FindFirstChild("BoatSpawner")
                if spawner and spawner:FindFirstChild("LowerTorso") then
                    HRP.CFrame = spawner.LowerTorso.CFrame * CFrame.new(0, 0, 4); task.wait(0.5)
                    pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(workspace.NPC.BoatSpawner, workspace.NPC.BoatSpawner, workspace.NPC.BoatSpawner) end); task.wait(1.5)
                end
            else
                local seat = myBoat:FindFirstChild("VehicleSeat", true)
                if seat then
                    if not _G_V10.ArrivedAtZone then
                        if Hum.Sit then Hum.Sit = false; task.wait(0.2) end
                        if myBoat:IsA("Model") and myBoat.PrimaryPart then myBoat:PivotTo(CFrame.new(_G_V10.SeaZone)) else seat.CFrame = CFrame.new(_G_V10.SeaZone) end
                        task.wait(0.3)
                        if _G_V10.AutoSitBoat then HRP.CFrame = seat.CFrame + Vector3.new(0, 3, 0); task.wait(0.1); seat:Sit(Hum) end
                        _G_V10.ArrivedAtZone = true 
                    else
                        if _G_V10.AutoSitBoat and not Hum.Sit then HRP.CFrame = seat.CFrame; task.wait(0.1); seat:Sit(Hum) end
                        VIM:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                    end
                end
            end
        end
    end
end)
