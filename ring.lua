-- ==========================================
-- MINI MENU: SMART AUTO HAKI & KEN (VIRTUAL KEY)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

-- Bảo vệ UI
local function GetSafeParent()
    local success, result = pcall(function() return gethui() end)
    if success and result then return result end
    return CoreGui
end
local SafeParent = GetSafeParent()
if SafeParent:FindFirstChild("MiniHakiMenu") then SafeParent.MiniHakiMenu:Destroy() end

-- ==========================================
-- TẠO GIAO DIỆN (UI) TỐI GIẢN
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "MiniHakiMenu"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 150)
MainFrame.Position = UDim2.new(0.5, -110, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 200, 255)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "⚡ SMART HAKI MENU"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

local Line = Instance.new("Frame", MainFrame)
Line.Size = UDim2.new(1, 0, 0, 1)
Line.Position = UDim2.new(0, 0, 0, 35)
Line.BackgroundColor3 = Color3.fromRGB(50, 50, 60)

-- Biến điều khiển
local AutoHaki = false
local AutoKen = false

-- Nút Auto Haki
local BtnHaki = Instance.new("TextButton", MainFrame)
BtnHaki.Size = UDim2.new(0.85, 0, 0, 35)
BtnHaki.Position = UDim2.new(0.075, 0, 0, 50)
BtnHaki.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
BtnHaki.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnHaki.Text = "Haki: ĐANG TẮT"
BtnHaki.Font = Enum.Font.GothamBold
BtnHaki.TextSize = 12
Instance.new("UICorner", BtnHaki).CornerRadius = UDim.new(0, 6)

BtnHaki.MouseButton1Click:Connect(function()
    AutoHaki = not AutoHaki
    if AutoHaki then
        BtnHaki.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        BtnHaki.Text = "Haki: ĐANG BẬT"
    else
        BtnHaki.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        BtnHaki.Text = "Haki: ĐANG TẮT"
    end
end)

-- Nút Auto Ken
local BtnKen = Instance.new("TextButton", MainFrame)
BtnKen.Size = UDim2.new(0.85, 0, 0, 35)
BtnKen.Position = UDim2.new(0.075, 0, 0, 95)
BtnKen.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
BtnKen.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnKen.Text = "Ken: ĐANG TẮT"
BtnKen.Font = Enum.Font.GothamBold
BtnKen.TextSize = 12
Instance.new("UICorner", BtnKen).CornerRadius = UDim.new(0, 6)

BtnKen.MouseButton1Click:Connect(function()
    AutoKen = not AutoKen
    if AutoKen then
        BtnKen.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        BtnKen.Text = "Ken: ĐANG BẬT"
    else
        BtnKen.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        BtnKen.Text = "Ken: ĐANG TẮT"
    end
end)

-- ==========================================
-- ENGINE LÕI: LOGIC CHECK THÔNG MINH
-- ==========================================
local function PressKey(key)
    VIM:SendKeyEvent(true, Enum.KeyCode[key], false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game)
end

task.spawn(function()
    while task.wait(1) do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            
            -- Logic Haki: Tự gõ phím nếu mất mục "Haki"
            if AutoHaki then
                if not char:FindFirstChild("Haki") then
                    PressKey("J") -- Phím J để bật Haki
                end
            end
            
            -- Logic Ken: Tự gõ phím nếu không có Ken HOẶC mục Ken hiện "Close"
            if AutoKen then
                local kenNode = char:FindFirstChild("Ken")
                if not kenNode or (kenNode and kenNode:FindFirstChild("Close")) then
                    PressKey("K") -- Phím K để bật Ken (Sửa chữ K thành phím khác nếu cần)
                end
            end
            
        end
    end
end)
