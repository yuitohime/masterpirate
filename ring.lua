-- Tải thư viện Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexsoftware/Orion/main/source')))()

-- Tạo bảng menu hình chữ nhật
local Window = OrionLib:MakeWindow({
    Name = "Auto Farm Pro Hub", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "AutoFarmConfig"
})

-- ==========================================
-- TAB 1: AUTO FARM & QUEST (Cày cuốc & Nhiệm vụ)
-- ==========================================
local FarmTab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Biến lưu trữ cấu hình
local _G.SelectedMonsters = {}
local _G.AutoFarm = false
local _G.AutoQuest = false

-- Nút Quét quái và Chọn nhiều quái (Multi-select)
FarmTab:AddDropdown({
    Name = "Chọn Quái (Hỗ trợ chọn nhiều)",
    Default = {},
    Options = {"Quái vật 1", "Quái vật 2", "Boss A", "Boss B"}, -- Ở đây bạn sẽ code logic quét Workspace để lấy tên quái
    MultipleOptions = true,
    Callback = function(Selected)
        _G.SelectedMonsters = Selected
        print("Đã chọn quái: ")
        for _, v in pairs(Selected) do print(v) end
    end
})

FarmTab:AddToggle({
    Name = "Bật/Tắt Auto Farm",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        -- Nơi đặt vòng lặp While _G.AutoFarm do ... end để di chuyển đến quái
    end
})

FarmTab:AddToggle({
    Name = "Tự động Đánh (Auto Attack)",
    Default = false,
    Callback = function(Value)
        _G.AutoAttack = Value
    end
})

FarmTab:AddToggle({
    Name = "Auto Nhận/Trả Quest",
    Default = false,
    Callback = function(Value)
        _G.AutoQuest = Value
        -- Nơi xử lý logic click Accept/Decline trong Quest UI của game
    end
})

-- ==========================================
-- TAB 2: COMBAT & VỊ TRÍ ĐÁNH (Chiến đấu)
-- ==========================================
local CombatTab = Window:MakeTab({
    Name = "Combat & Vị Trí",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

CombatTab:AddToggle({
    Name = "Auto Skill",
    Default = false,
    Callback = function(Value)
        _G.AutoSkill = Value
    end
})

-- Tính năng quét túi đồ (Backpack) để Auto Equip
CombatTab:AddDropdown({
    Name = "Auto Equip (Kiểu Chiến Đấu/Vũ Khí)",
    Default = "",
    Options = {"Melee", "Sword", "Fruit", "Gun"}, -- Logic quét Backpack người chơi sẽ đưa vào đây
    MultipleOptions = false,
    Callback = function(Value)
        _G.EquipType = Value
        -- Code trang bị vũ khí từ Backpack vào Character
    end
})

-- Chọn kiểu đánh (vị trí so với quái)
CombatTab:AddDropdown({
    Name = "Vị trí Đánh",
    Default = "Trên Đầu",
    Options = {"Trên Đầu", "Đằng Sau", "Dưới Chân"},
    MultipleOptions = false,
    Callback = function(Value)
        _G.AttackPosition = Value
    end
})

-- Thanh trượt khoảng cách
CombatTab:AddSlider({
    Name = "Khoảng cách đánh (Distance)",
    Min = 0,
    Max = 50,
    Default = 10,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Studs",
    Callback = function(Value)
        _G.AttackDistance = Value
    end
})

-- Khởi tạo UI
OrionLib:Init()
