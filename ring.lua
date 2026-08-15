-- ==========================================
-- DELTA UI V2 - GIAO DIỆN SIÊU MƯỢT & CHỨC NĂNG THỰC TẾ
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Hàm lấy vùng an toàn cho Delta
local function GetSafeParent()
    local success, result = pcall(function() return gethui() end)
    if success and result then return result end
    return LocalPlayer:WaitForChild("PlayerGui")
end
local SafeParent = GetSafeParent()

-- Xóa UI cũ nếu có
local UI_NAME = "V2_DeltaUI_Pro"
if SafeParent:FindFirstChild(UI_NAME) then SafeParent[UI_NAME]:Destroy() end

-- Biến lưu cấu hình hệ thống
local _G_V1 = {
    SelectedMonsters = {},
    SelectedWeapon = nil,
    SelectedFruit = nil,
    AutoFarm = false,
    AutoEquip = false,
    AttackPosition = "Trên Đầu",
    AttackDistance = 15,
    FlySpeed = 50,
    MonstersList = {}, 
    WeaponsList = {},
    FruitsList = {}
}

-- Hàm tạo góc bo tròn (UICorner)
local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
end

-- ==========================================
-- 1. TẠO KHUNG GIAO DIỆN CHÍNH (Bo tròn, Nút X, -)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = SafeParent

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 580, 0, 360)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Active = true
MainFrame.Draggable = true
AddCorner(MainFrame, 8)
MainFrame.Parent = ScreenGui

-- UI Stroke (Viền ngoài)
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 200, 255)
Stroke.Thickness = 2
Stroke.Parent = MainFrame

-- PHẦN TRÊN: TIÊU ĐỀ & NÚT ĐIỀU KHIỂN
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
AddCorner(TopBar, 8)
TopBar.Parent = MainFrame

-- Sửa góc dưới của TopBar vuông lại để nối với thân menu
local FixCorner = Instance.new("Frame")
FixCorner.Size = UDim2.new(1, 0, 0, 10)
FixCorner.Position = UDim2.new(0, 0, 1, -10)
FixCorner.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
FixCorner.BorderSizePixel = 0
FixCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "AUTO FARM V2 (Delta)"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Nút Thu nhỏ (-)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 35, 0, 35)
MinBtn.Position = UDim2.new(1, -70, 0, 0)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 24
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = TopBar

-- Nút Tắt (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    MainFrame.Size = isMinimized and UDim2.new(0, 580, 0, 35) or UDim2.new(0, 580, 0, 360)
    for _, v in pairs(MainFrame:GetChildren()) do
        if v.Name == "TabsFrame" or v.Name == "ContentFrame" then v.Visible = not isMinimized end
    end
end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- PHẦN TRÁI: CỘT TABS
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(0.28, 0, 1, -35)
TabsFrame.Position = UDim2.new(0, 0, 0, 35)
TabsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TabsFrame.BorderSizePixel = 0
TabsFrame.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabsFrame
TabListLayout.Padding = UDim.new(0, 5)
local TabPadding = Instance.new("UIPadding")
TabPadding.Parent = TabsFrame
TabPadding.PaddingTop = UDim.new(0, 10)

-- PHẦN PHẢI: NỘI DUNG CHÍNH
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(0.72, 0, 1, -35)
ContentFrame.Position = UDim2.new(0.28, 0, 0, 35)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ContentFrame.BorderSizePixel = 0
AddCorner(ContentFrame, 8)
ContentFrame.Parent = MainFrame

-- ==========================================
-- 2. HỆ THỐNG TẠO TABS CÓ ICON
-- ==========================================
local Pages = {}
local function CreateTab(name, iconId)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -10, 0, 40)
    TabBtn.Position = UDim2.new(0, 5, 0, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Text = "    " .. name
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 14
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    AddCorner(TabBtn, 6)
    TabBtn.Parent = TabsFrame

    -- Icon
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 20, 0, 20)
    Icon.Position = UDim2.new(0, 10, 0.5, -10)
    Icon.BackgroundTransparency = 1
    Icon.Image = iconId
    Icon.Parent = TabBtn

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 3
    Page.Visible = false
    Page.Parent = ContentFrame
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.Padding = UDim.new(0, 10)
    local PagePadding = Instance.new("UIPadding")
    PagePadding.Parent = Page
    PagePadding.PaddingTop = UDim.new(0, 15)
    PagePadding.PaddingLeft = UDim.new(0, 15)
    PagePadding.PaddingRight = UDim.new(0, 15)
    PagePadding.PaddingBottom = UDim.new(0, 15)

    Pages[name] = {Btn = TabBtn, Frame = Page, Icon = Icon}

    TabBtn.MouseButton1Click:Connect(function()
        for tName, data in pairs(Pages) do
            local isSelected = (tName == name)
            data.Frame.Visible = isSelected
            data.Btn.BackgroundColor3 = isSelected and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(35, 35, 40)
            data.Btn.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        end
    end)
    return Page
end

-- ==========================================
-- 3. CÁC HÀM UI (Bo tròn, Dropdown, Toggle)
-- ==========================================
-- Nút bật tắt
local function CreateToggleRow(parent, name, globalVar)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 40)
    Row.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    AddCorner(Row, 6)
    Row.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.Parent = Row

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0.3, 0, 0, 30)
    ToggleBtn.Position = UDim2.new(0.68, 0, 0.5, -15)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Text = "TẮT"
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 12
    AddCorner(ToggleBtn, 4)
    ToggleBtn.Parent = Row

    ToggleBtn.MouseButton1Click:Connect(function()
        _G_V1[globalVar] = not _G_V1[globalVar]
        ToggleBtn.BackgroundColor3 = _G_V1[globalVar] and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        ToggleBtn.Text = _G_V1[globalVar] and "BẬT" or "TẮT"
    end)
end

-- Dropdown quét danh sách
local function CreateDropdown(parent, title, itemsList, globalVar, isMultiSelect)
    local Wrapper = Instance.new("Frame")
    Wrapper.Size = UDim2.new(1, 0, 0, 40)
    Wrapper.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Wrapper.ClipsDescendants = true
    AddCorner(Wrapper, 6)
    Wrapper.Parent = parent

    local MainBtn = Instance.new("TextButton")
    MainBtn.Size = UDim2.new(1, 0, 0, 40)
    MainBtn.BackgroundTransparency = 1
    MainBtn.Text = "  " .. title .. " ▼"
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainBtn.TextXAlignment = Enum.TextXAlignment.Left
    MainBtn.Font = Enum.Font.Gotham
    MainBtn.TextSize = 13
    MainBtn.Parent = Wrapper

    local DropFrame = Instance.new("ScrollingFrame")
    DropFrame.Size = UDim2.new(1, 0, 0, 120)
    DropFrame.Position = UDim2.new(0, 0, 0, 40)
    DropFrame.BackgroundTransparency = 1
    DropFrame.ScrollBarThickness = 2
    DropFrame.Parent = Wrapper

    local DropLayout = Instance.new("UIListLayout")
    DropLayout.Parent = DropFrame

    MainBtn.MouseButton1Click:Connect(function()
        local isOpen = Wrapper.Size.Y.Offset > 40
        Wrapper.Size = isOpen and UDim2.new(1, 0, 0, 40) or UDim2.new(1, 0, 0, 160)
    end)

    local function RefreshList(newList)
        if newList then itemsList = newList end
        for _, v in pairs(DropFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        
        for _, item in pairs(itemsList) do
            local ItemBtn = Instance.new("TextButton")
            ItemBtn.Size = UDim2.new(1, 0, 0, 30)
            ItemBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            ItemBtn.Text = item
            ItemBtn.Parent = DropFrame

            ItemBtn.MouseButton1Click:Connect(function()
                if isMultiSelect then
                    local idx = table.find(_G_V1[globalVar], item)
                    if idx then
                        table.remove(_G_V1[globalVar], idx)
                        ItemBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                    else
                        table.insert(_G_V1[globalVar], item)
                        ItemBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
                    end
                else
                    _G_V1[globalVar] = item
                    MainBtn.Text = "  " .. title .. ": " .. item
                    Wrapper.Size = UDim2.new(1, 0, 0, 40)
                end
            end)
        end
        DropFrame.CanvasSize = UDim2.new(0, 0, 0, #itemsList * 30)
    end
    RefreshList(itemsList)
    return RefreshList
end

local function CreateButton(parent, name, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Text = name
    Btn.Font = Enum.Font.GothamBold
    AddCorner(Btn, 6)
    Btn.Parent = parent
    Btn.MouseButton1Click:Connect(callback)
end

-- ==========================================
-- 4. TẠO CÁC TABS NỘI DUNG
-- ==========================================
-- Icons (ID Hình ảnh)
local PageMain = CreateTab("Main", "rbxassetid://6031280882")
local PageSetting = CreateTab("Setting", "rbxassetid://6031075931")
local PageFruit = CreateTab("Fruit", "rbxassetid://6031225818")

Pages["Main"].Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Pages["Main"].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
PageMain.Visible = true

-- THÊM HÀM BAY (TWEEN SERVICE)
local function TweenTo(targetCFrame)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local HRP = LocalPlayer.Character.HumanoidRootPart
    local distance = (HRP.Position - targetCFrame.Position).Magnitude
    local time = distance / _G_V1.FlySpeed

    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(HRP, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- --- TAB MAIN ---
local ReloadMonsters = CreateDropdown(PageMain, "Chọn Quái (Multi-Select)", {}, "SelectedMonsters", true)
CreateButton(PageMain, "🔍 Quét Quái Toàn Map", function()
    local mobs = {}
    -- Sửa 'workspace.Enemies' thành thư mục chứa quái trong game bạn đang chơi
    local enemyFolder = workspace:FindFirstChild("Enemies") or workspace
    for _, v in pairs(enemyFolder:GetChildren()) do
        if v:FindFirstChild("Humanoid") and not table.find(mobs, v.Name) then
            table.insert(mobs, v.Name)
        end
    end
    ReloadMonsters(mobs)
end)
CreateToggleRow(PageMain, "Bật Auto Farm", "AutoFarm")

-- --- TAB SETTING (KHOẢNG CÁCH, AUTO EQUIP) ---
CreateDropdown(PageSetting, "Kiểu Đánh", {"Trên Đầu", "Đằng Sau", "Dưới Chân"}, "AttackPosition", false)

local ReloadWeapons = CreateDropdown(PageSetting, "Chọn Vũ Khí Đánh", {}, "SelectedWeapon", false)
CreateButton(PageSetting, "🎒 Quét Túi Đồ & Nhân vật", function()
    local weps = {}
    -- Quét trong Balo
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") then table.insert(weps, v.Name) end
    end
    -- Quét cả trên tay nhân vật (fix lỗi Combat không hiện)
    if LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("Tool") and not table.find(weps, v.Name) then table.insert(weps, v.Name) end
        end
    end
    ReloadWeapons(weps)
end)
CreateToggleRow(PageSetting, "Bật Auto Equip", "AutoEquip")

-- --- TAB FRUIT ---
local ReloadFruits = CreateDropdown(PageFruit, "Chọn Trái Cây", {}, "SelectedFruit", false)
CreateButton(PageFruit, "🍎 Quét Trái Cây Toàn Server", function()
    local fruits = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Tool") or (v:IsA("Model") and string.find(string.lower(v.Name), "fruit")) then
            if not table.find(fruits, v.Name) then table.insert(fruits, v.Name) end
        end
    end
    ReloadFruits(fruits)
end)

CreateButton(PageFruit, "🚀 Bay Đến Trái Đã Chọn", function()
    if not _G_V1.SelectedFruit then return end
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == _G_V1.SelectedFruit and v:IsA("Tool") and v:FindFirstChild("Handle") then
            TweenTo(v.Handle.CFrame)
            break
        end
    end
end)

CreateButton(PageFruit, "📦 Nhặt Tất Cả Trái (Auto)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Tool") or string.find(string.lower(v.Name), "fruit")) and v:FindFirstChild("Handle") then
            local t = TweenTo(v.Handle.CFrame)
            if t then t.Completed:Wait() end
            task.wait(0.5)
        end
    end
end)

-- ==========================================
-- 5. ENGINE: LOGIC CHẠY NGẦM (FARM & EQUIP)
-- ==========================================
task.spawn(function()
    while task.wait(0.1) do
        -- 1. Auto Equip
        if _G_V1.AutoEquip and _G_V1.SelectedWeapon and LocalPlayer.Character then
            local weaponInBackpack = LocalPlayer.Backpack:FindFirstChild(_G_V1.SelectedWeapon)
            if weaponInBackpack then
                LocalPlayer.Character.Humanoid:EquipTool(weaponInBackpack)
            end
        end

        -- 2. Auto Farm (Logic Tính Toán Vị Trí & Bay)
        if _G_V1.AutoFarm and #_G_V1.SelectedMonsters > 0 then
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

            -- Tìm quái gần nhất có trong list
            local targetMob = nil
            local shortestDist = math.huge
            local enemyFolder = workspace:FindFirstChild("Enemies") or workspace

            for _, mob in pairs(enemyFolder:GetChildren()) do
                if table.find(_G_V1.SelectedMonsters, mob.Name) and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    local d = (char.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                    if d < shortestDist then
                        shortestDist = d
                        targetMob = mob
                    end
                end
            end

            -- Nếu tìm thấy quái, tính CFrame và bay tới
            if targetMob then
                local mobCFrame = targetMob.HumanoidRootPart.CFrame
                local offset = CFrame.new(0,0,0)
                local dist = _G_V1.AttackDistance

                if _G_V1.AttackPosition == "Trên Đầu" then
                    offset = CFrame.new(0, dist, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                elseif _G_V1.AttackPosition == "Đằng Sau" then
                    offset = CFrame.new(0, 0, dist)
                elseif _G_V1.AttackPosition == "Dưới Chân" then
                    offset = CFrame.new(0, -dist, 0)
                end
                
                -- Vô hiệu hóa rơi khi đang farm
                if char.HumanoidRootPart:FindFirstChild("BodyVelocity") == nil then
                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.Parent = char.HumanoidRootPart
                end

                char.HumanoidRootPart.CFrame = mobCFrame * offset
            end
        else
            -- Tắt Auto Farm thì xóa trạng thái lơ lửng
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local bv = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity")
                if bv then bv:Destroy() end
            end
        end
    end
end)
