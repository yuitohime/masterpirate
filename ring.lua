-- ==========================================
-- MENU SIMPLE DÀNH RIÊNG CHO DELTA EXECUTOR
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. TÌM LỚP PHỦ GIAO DIỆN CỦA DELTA
-- Lệnh gethui() giúp UI hiển thị chuẩn trên Delta mà không bị lỗi
local function GetSafeParent()
    local success, result = pcall(function() return gethui() end)
    if success and result then return result end
    
    success, result = pcall(function() return game:GetService("CoreGui") end)
    if success and result then return result end
    
    return LocalPlayer:WaitForChild("PlayerGui")
end

local SafeParent = GetSafeParent()

-- 2. XÓA MENU CŨ ĐỂ TRÁNH TRÙNG LẶP
local UI_NAME = "DeltaAutoFarmUI_V1"
if SafeParent:FindFirstChild(UI_NAME) then
    SafeParent[UI_NAME]:Destroy()
end

-- 3. TẠO MÀN HÌNH MENU
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false -- Rất quan trọng: Giúp menu không bị mất khi nhân vật chết
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = SafeParent

-- 4. TẠO KHUNG CHÍNH (FRAME)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 360)
MainFrame.Position = UDim2.new(0.5, -130, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true -- Có thể dùng tay/chuột kéo menu đi chỗ khác
MainFrame.Parent = ScreenGui

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Text = "DELTA AUTO FARM"
Title.Parent = MainFrame

-- Tự động sắp xếp các nút bấm
local Layout = Instance.new("UIListLayout")
Layout.Parent = MainFrame
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 6)

local Padding = Instance.new("UIPadding")
Padding.Parent = MainFrame
Padding.PaddingTop = UDim.new(0, 45)
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)

-- ==========================================
-- 5. CÁC BIẾN HỆ THỐNG VÀ TẠO NÚT BẤM
-- ==========================================
_G.Config = {
    AutoFarm = false,
    AutoQuest = false,
    AutoAttack = false,
    Distance = 10,
    Position = "Trên Đầu",
    Equip = "Melee"
}

-- Hàm tạo Nút Bật/Tắt (Màu Đỏ -> Xanh)
local function CreateToggle(name, settingKey)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.Text = name .. " [TẮT]"
    Btn.Parent = MainFrame

    Btn.MouseButton1Click:Connect(function()
        _G.Config[settingKey] = not _G.Config[settingKey]
        if _G.Config[settingKey] then
            Btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            Btn.Text = name .. " [BẬT]"
        else
            Btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            Btn.Text = name .. " [TẮT]"
        end
    end)
end

-- Hàm tạo Nút Chuyển Đổi Vòng Lặp (Dùng cho Vị trí, Vũ khí)
local function CreateCycle(name, settingKey, optionsList, suffix)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    
    local currentIndex = 1
    Btn.Text = name .. ": " .. tostring(optionsList[currentIndex]) .. (suffix or "")
    Btn.Parent = MainFrame

    Btn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #optionsList then currentIndex = 1 end
        _G.Config[settingKey] = optionsList[currentIndex]
        Btn.Text = name .. ": " .. tostring(optionsList[currentIndex]) .. (suffix or "")
    end)
end

-- ==========================================
-- 6. THÊM CÁC TÍNH NĂNG VÀO MENU
-- ==========================================
CreateToggle("Bật Auto Farm", "AutoFarm")
CreateToggle("Bật Auto Quest", "AutoQuest")
CreateToggle("Auto Đánh & Skill", "AutoAttack")

CreateCycle("Vị trí", "Position", {"Trên Đầu", "Đằng Sau", "Dưới Chân"})
CreateCycle("Khoảng cách", "Distance", {10, 20, 30, 40, 50}, " Studs")
CreateCycle("Tự động cầm", "Equip", {"Melee", "Sword", "Fruit"})
