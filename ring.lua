-- ==========================================
-- MENU SIMPLE - AUTO FARM NATIVE UI
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Xóa UI cũ nếu đã bật trước đó để tránh đè lên nhau
local uiName = "SimpleAutoFarmUI"
local parentTarget = pcall(function() return CoreGui end) and CoreGui or Player.PlayerGui
if parentTarget:FindFirstChild(uiName) then
    parentTarget[uiName]:Destroy()
end

-- Biến lưu cấu hình
local _G = {
    AutoFarm = false,
    AutoQuest = false,
    AutoAttack = false,
    AutoSkill = false,
    PositionIndex = 1,
    Positions = {"Trên Đầu", "Đằng Sau", "Dưới Chân"},
    DistanceIndex = 1,
    Distances = {10, 20, 30, 40, 50},
    EquipIndex = 1,
    Equips = {"Melee", "Sword", "Fruit"}
}

-- 1. TẠO GIAO DIỆN CHÍNH (SCREEN GUI & FRAME)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = uiName
ScreenGui.Parent = parentTarget

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 400)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Tính năng kéo thả menu
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Auto Farm (Simple Menu)"
Title.Parent = MainFrame

-- Sắp xếp các nút tự động
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Đẩy Layout xuống dưới tiêu đề
local Padding = Instance.new("UIPadding")
Padding.Parent = MainFrame
Padding.PaddingTop = UDim.new(0, 40)
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)

-- ==========================================
-- 2. CÁC HÀM TẠO NÚT (TOGGLE & CYCLE)
-- ==========================================

-- Hàm tạo nút Bật/Tắt (Toggle)
local function CreateToggle(name, globalVar)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- Đỏ (Tắt)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Text = name .. " [TẮT]"
    btn.Parent = MainFrame

    btn.MouseButton1Click:Connect(function()
        _G[globalVar] = not _G[globalVar]
        if _G[globalVar] then
            btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Xanh (Bật)
            btn.Text = name .. " [BẬT]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- Đỏ
            btn.Text = name .. " [TẮT]"
        end
    end)
end

-- Hàm tạo nút bấm để chuyển đổi nhiều lựa chọn (Thay cho Dropdown phức tạp)
local function CreateCycle(name, indexVar, listVar, suffix)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 150)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Text = name .. ": " .. tostring(_G[listVar][_G[indexVar]]) .. (suffix or "")
    btn.Parent = MainFrame

    btn.MouseButton1Click:Connect(function()
        _G[indexVar] = _G[indexVar] + 1
        if _G[indexVar] > #_G[listVar] then
            _G[indexVar] = 1
        end
        btn.Text = name .. ": " .. tostring(_G[listVar][_G[indexVar]]) .. (suffix or "")
    end)
end

-- ==========================================
-- 3. THÊM CÁC NÚT VÀO MENU
-- ==========================================
CreateToggle("Auto Farm", "AutoFarm")
CreateToggle("Tự động Đánh", "AutoAttack")
CreateToggle("Auto Nhận/Trả Quest", "AutoQuest")
CreateToggle("Auto Skill", "AutoSkill")

-- Thay vì thanh kéo/dropdown, ta dùng nút bấm chuyển đổi tuần hoàn cho nhẹ
CreateCycle("Vị trí Đánh", "PositionIndex", "Positions")
CreateCycle("Khoảng cách", "DistanceIndex", "Distances", " Studs")
CreateCycle("Trang Bị (Equip)", "EquipIndex", "Equips")

-- Nút thu gọn Menu
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 2)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Text = "-"
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 20
MinimizeBtn.Parent = Title

local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 250, 0, 35) -- Thu nhỏ lại bằng tiêu đề
        MainFrame.BackgroundTransparency = 1
        for _, child in pairs(MainFrame:GetChildren()) do
            if child:IsA("TextButton") and child.Name ~= "MinimizeBtn" then
                child.Visible = false
            end
        end
    else
        MainFrame.Size = UDim2.new(0, 250, 0, 400) -- Mở rộng ra
        MainFrame.BackgroundTransparency = 0
        for _, child in pairs(MainFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child.Visible = true
            end
        end
    end
end)
