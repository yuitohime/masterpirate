-- ==========================================
-- MENU V1 DÀNH CHO DELTA (NATIVE UI TỐI ƯU)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Lấy vùng an toàn để UI không bị Delta ẩn
local function GetSafeParent()
    local success, result = pcall(function() return gethui() end)
    if success and result then return result end
    return LocalPlayer:WaitForChild("PlayerGui")
end
local SafeParent = GetSafeParent()

-- Xóa UI cũ
local UI_NAME = "V1_DeltaUI"
if SafeParent:FindFirstChild(UI_NAME) then SafeParent[UI_NAME]:Destroy() end

-- Biến lưu dữ liệu
local _G_V1 = {
    SelectedMonsters = {},
    SelectedWeapon = nil,
    AutoFarm = false,
    AutoEquip = false,
    AttackPosition = "Trên Đầu",
    AttackDistance = 10,
    FlySpeed = 50,
    MonstersList = {"Bandit", "Monkey", "Gorilla", "Boss Yeti"}, -- Mặc định giả lập
    WeaponsList = {}
}

-- ==========================================
-- 1. TẠO KHUNG GIAO DIỆN CHÍNH (BỐ CỤC 3 PHẦN)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = SafeParent

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 380)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- PHẦN TRÊN: TIÊU ĐỀ "v1"
local TopBar = Instance.new("TextLabel")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TopBar.TextColor3 = Color3.fromRGB(0, 255, 255)
TopBar.Text = " v1"
TopBar.TextSize = 18
TopBar.Font = Enum.Font.GothamBold
TopBar.TextXAlignment = Enum.TextXAlignment.Left
TopBar.Parent = MainFrame

-- PHẦN DƯỚI BÊN PHẢI: TABS MENU (Nhỏ hơn)
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(0.25, 0, 1, -35)
TabsFrame.Position = UDim2.new(0.75, 0, 0, 35)
TabsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabsFrame.BorderSizePixel = 1
TabsFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
TabsFrame.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabsFrame
TabListLayout.Padding = UDim.new(0, 2)

-- PHẦN DƯỚI BÊN TRÁI: NỘI DUNG CHÍNH (Lớn hơn)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(0.75, 0, 1, -35)
ContentFrame.Position = UDim2.new(0, 0, 0, 35)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- ==========================================
-- 2. HỆ THỐNG TABS & HÀM TIỆN ÍCH
-- ==========================================
local Pages = {}

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 40)
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 14
    TabBtn.Parent = TabsFrame

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 4
    Page.Visible = false
    Page.Parent = ContentFrame
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.Padding = UDim.new(0, 8)
    
    local PagePadding = Instance.new("UIPadding")
    PagePadding.Parent = Page
    PagePadding.PaddingTop = UDim.new(0, 10)
    PagePadding.PaddingLeft = UDim.new(0, 10)
    PagePadding.PaddingRight = UDim.new(0, 10)
    PagePadding.PaddingBottom = UDim.new(0, 10)

    Pages[name] = {Btn = TabBtn, Frame = Page}

    TabBtn.MouseButton1Click:Connect(function()
        for tName, data in pairs(Pages) do
            if tName == name then
                data.Frame.Visible = true
                data.Btn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
                data.Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                data.Frame.Visible = false
                data.Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                data.Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
    end)
    return Page
end

-- ==========================================
-- 3. HÀM TẠO CÁC NÚT TÍNH NĂNG ĐẶC BIỆT
-- ==========================================
-- Bố cục 2 phần: Tên bên trái, Nút bật/tắt bên phải
local function CreateToggleRow(parent, name, globalVar)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 35)
    Row.BackgroundTransparency = 1
    Row.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.Parent = Row

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0.35, -5, 1, 0)
    ToggleBtn.Position = UDim2.new(0.65, 5, 0, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Text = "TẮT"
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 12
    ToggleBtn.Parent = Row

    ToggleBtn.MouseButton1Click:Connect(function()
        _G_V1[globalVar] = not _G_V1[globalVar]
        if _G_V1[globalVar] then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            ToggleBtn.Text = "BẬT"
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            ToggleBtn.Text = "TẮT"
        end
    end)
end

-- Ô kéo ra danh sách (Dropdown)
local function CreateDropdown(parent, title, itemsList, globalVar, isMultiSelect)
    local Wrapper = Instance.new("Frame")
    Wrapper.Size = UDim2.new(1, 0, 0, 35)
    Wrapper.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Wrapper.Parent = parent

    local MainBtn = Instance.new("TextButton")
    MainBtn.Size = UDim2.new(1, 0, 1, 0)
    MainBtn.BackgroundTransparency = 1
    MainBtn.Text = "  " .. title .. " (Bấm để chọn ▼)"
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainBtn.TextXAlignment = Enum.TextXAlignment.Left
    MainBtn.Font = Enum.Font.Gotham
    MainBtn.TextSize = 13
    MainBtn.Parent = Wrapper

    local DropFrame = Instance.new("ScrollingFrame")
    DropFrame.Size = UDim2.new(1, 0, 0, 120)
    DropFrame.Position = UDim2.new(0, 0, 1, 0)
    DropFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    DropFrame.Visible = false
    DropFrame.ZIndex = 5
    DropFrame.ScrollBarThickness = 4
    DropFrame.Parent = Wrapper

    local DropLayout = Instance.new("UIListLayout")
    DropLayout.Parent = DropFrame

    MainBtn.MouseButton1Click:Connect(function()
        DropFrame.Visible = not DropFrame.Visible
        Wrapper.Size = DropFrame.Visible and UDim2.new(1, 0, 0, 155) or UDim2.new(1, 0, 0, 35)
    end)

    -- Hàm nạp lại danh sách
    local function LoadItems()
        for _, v in pairs(DropFrame:GetChildren()) do
            if v:IsA("TextButton") then v:Destroy() end
        end
        for _, item in pairs(itemsList) do
            local ItemBtn = Instance.new("TextButton")
            ItemBtn.Size = UDim2.new(1, 0, 0, 30)
            ItemBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            ItemBtn.Text = item
            ItemBtn.ZIndex = 6
            ItemBtn.Parent = DropFrame

            ItemBtn.MouseButton1Click:Connect(function()
                if isMultiSelect then
                    if table.find(_G_V1[globalVar], item) then
                        table.remove(_G_V1[globalVar], table.find(_G_V1[globalVar], item))
                        ItemBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    else
                        table.insert(_G_V1[globalVar], item)
                        ItemBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
                    end
                else
                    _G_V1[globalVar] = item
                    MainBtn.Text = "  " .. title .. ": " .. item
                    DropFrame.Visible = false
                    Wrapper.Size = UDim2.new(1, 0, 0, 35)
                end
            end)
        end
        DropFrame.CanvasSize = UDim2.new(0, 0, 0, #itemsList * 30)
    end
    LoadItems()
    return LoadItems -- Trả về hàm để gọi làm nút Quét lại
end

-- Thanh kéo Slider
local function CreateSlider(parent, name, min, max, globalVar)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 45)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. _G_V1[globalVar]
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.Parent = SliderFrame

    local BG = Instance.new("TextButton")
    BG.Size = UDim2.new(1, 0, 0, 15)
    BG.Position = UDim2.new(0, 0, 0, 25)
    BG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    BG.Text = ""
    BG.Parent = SliderFrame

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((_G_V1[globalVar] - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    Fill.Parent = BG

    local Dragging = false
    BG.MouseButton1Down:Connect(function() Dragging = true end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - BG.AbsolutePosition.X) / BG.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(min + (max - min) * pos)
            _G_V1[globalVar] = val
            Label.Text = name .. ": " .. val
        end
    end)
end

-- Nút Quét lại thông thường
local function CreateButton(parent, name, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Text = name
    Btn.Font = Enum.Font.GothamBold
    Btn.Parent = parent
    Btn.MouseButton1Click:Connect(callback)
end

-- ==========================================
-- 4. XÂY DỰNG NỘI DUNG CÁC TAB
-- ==========================================
local PageMain = CreateTab("Main")
local PageSkill = CreateTab("Skill")
local PageSetting = CreateTab("Setting")
local PageTeleport = CreateTab("Teleport")
local PageStatus = CreateTab("Status")

-- Mở Tab Main mặc định
Pages["Main"].Btn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
Pages["Main"].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
PageMain.Visible = true

--- **TAB MAIN: DANH SÁCH & AUTO FARM**
local ReloadMonsters = CreateDropdown(PageMain, "Chọn Quái (Hỗ trợ nhiều)", _G_V1.MonstersList, "SelectedMonsters", true)
CreateButton(PageMain, "🔄 Quét Lại Map", function()
    -- Giả lập quét quái mới
    _G_V1.MonstersList = {"Bandit", "Monkey", "Gorilla", "Boss Yeti", "New Monster " .. math.random(1,99)}
    ReloadMonsters() 
end)
CreateToggleRow(PageMain, "Bay đến & Farm Quái", "AutoFarm")


--- **TAB SETTING: TÙY CHỈNH & BACKPACK**
CreateDropdown(PageSetting, "Kiểu Đánh", {"Trên Đầu", "Đằng Sau", "Dưới Chân"}, "AttackPosition", false)
CreateSlider(PageSetting, "Khoảng Cách Đánh (Studs)", 0, 50, "AttackDistance")
CreateSlider(PageSetting, "Tốc Độ Bay", 10, 300, "FlySpeed")

local ReloadWeapons = CreateDropdown(PageSetting, "Vũ Khí (Từ Túi Đồ)", _G_V1.WeaponsList, "SelectedWeapon", false)
CreateButton(PageSetting, "🎒 Quét Túi Đồ", function()
    _G_V1.WeaponsList = {}
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") then table.insert(_G_V1.WeaponsList, v.Name) end
    end
    ReloadWeapons()
end)
CreateToggleRow(PageSetting, "Auto Equip Vũ Khí", "AutoEquip")


--- **TAB STATUS: TRẠNG THÁI & HIỂN THỊ MAP**
local function CreateStatusLabel(parent, text)
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, 0, 0, 25)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text
    Lbl.TextColor3 = Color3.fromRGB(200, 255, 255)
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 13
    Lbl.Parent = parent
    return Lbl
end

local StatusTime = CreateStatusLabel(PageStatus, "🕒 Thời gian server: Đang lấy...")
local StatusFruit = CreateStatusLabel(PageStatus, "🍎 Fruit đang rơi: 0")
local StatusItems = CreateStatusLabel(PageStatus, "🗡️ Đồ rơi khác: 0")
local StatusBoss = CreateStatusLabel(PageStatus, "👹 Boss đang sống: Đang quét...")

-- Cập nhật thời gian thực (Status loop)
task.spawn(function()
    while task.wait(1) do
        local date = os.date("*t")
        StatusTime.Text = string.format("🕒 Thời gian: %02d:%02d:%02d", date.hour, date.min, date.sec)
        
        -- Nơi chèn logic quét Fruit / Item / Boss thực tế của game bạn chơi
        -- Ví dụ giả lập:
        StatusFruit.Text = "🍎 Fruit đang rơi: " .. math.random(0,3)
    end
end)
