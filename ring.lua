-- ==========================================
-- SMART MINI REMOTE SPY V2 (ANTI-CRASH)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Xóa UI cũ nếu có
local SafeParent = pcall(gethui) and gethui() or LocalPlayer:WaitForChild("PlayerGui")
if SafeParent:FindFirstChild("MiniSpyUI_V2") then SafeParent["MiniSpyUI_V2"]:Destroy() end

-- Biến điều khiển
_G.IsSpying = false
_G.LoggedRemotes = {}

-- ================= Tạo UI =================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "MiniSpyUI_V2"; ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 280)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 150)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -60, 0, 30); Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = "🔍 MINI SPY V2 (ANTI-CRASH)"
Title.TextColor3 = Color3.fromRGB(0, 255, 150); Title.Font = Enum.Font.GothamBold
Title.TextSize = 13; Title.TextXAlignment = Enum.TextXAlignment.Left

local ClearBtn = Instance.new("TextButton", MainFrame)
ClearBtn.Size = UDim2.new(0, 50, 0, 24); ClearBtn.Position = UDim2.new(1, -55, 0, 3)
ClearBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50); ClearBtn.Text = "XÓA"
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255); ClearBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 4)

-- Nút Record
local RecordBtn = Instance.new("TextButton", MainFrame)
RecordBtn.Size = UDim2.new(1, -20, 0, 35); RecordBtn.Position = UDim2.new(0, 10, 0, 30)
RecordBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
RecordBtn.Text = "🔴 SPY ĐANG TẮT (BẤM ĐỂ BẬT)"
RecordBtn.TextColor3 = Color3.fromRGB(255, 255, 255); RecordBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", RecordBtn).CornerRadius = UDim.new(0, 6)

local ScrollList = Instance.new("ScrollingFrame", MainFrame)
ScrollList.Size = UDim2.new(1, -20, 1, -85); ScrollList.Position = UDim2.new(0, 10, 0, 75)
ScrollList.BackgroundTransparency = 1; ScrollList.ScrollBarThickness = 4
ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)

local UIListLayout = Instance.new("UIListLayout", ScrollList)
UIListLayout.Padding = UDim.new(0, 5)

-- ================= Chức Năng UI =================
RecordBtn.MouseButton1Click:Connect(function()
    _G.IsSpying = not _G.IsSpying
    if _G.IsSpying then
        RecordBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        RecordBtn.Text = "🟢 SPY ĐANG BẬT (BẤM LẠI ĐỂ TẮT)"
    else
        RecordBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        RecordBtn.Text = "🔴 SPY ĐANG TẮT (BẤM ĐỂ BẬT)"
    end
end)

ClearBtn.MouseButton1Click:Connect(function()
    for _, child in pairs(ScrollList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    _G.LoggedRemotes = {}
    ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)
end)

local function AddLogToUI(fullCode)
    local Btn = Instance.new("TextButton", ScrollList)
    Btn.Size = UDim2.new(1, 0, 0, 40); Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Btn.Text = fullCode; Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.Gotham; Btn.TextSize = 11
    Btn.TextWrapped = true; Btn.TextXAlignment = Enum.TextXAlignment.Left; Btn.TextYAlignment = Enum.TextYAlignment.Top
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    
    local pad = Instance.new("UIPadding", Btn)
    pad.PaddingLeft = UDim.new(0, 5); pad.PaddingTop = UDim.new(0, 5); pad.PaddingRight = UDim.new(0, 5)

    Btn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(fullCode)
            Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 100); Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            task.wait(0.3)
            Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45); Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
    ScrollList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end

-- ================= Hook An Toàn (Anti-Crash) =================
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    if not checkcaller() and _G.IsSpying and (method == "FireServer" or method == "InvokeServer") then
        local args = {...}
        
        -- Dùng task.spawn để TÁCH RỜI việc lưu log ra khỏi việc game chạy, đảm bảo không sập UI NPC
        task.spawn(function()
            local remoteName = "UnknownRemote"
            pcall(function() remoteName = self:GetFullName() end)
            
            local argsStr = ""
            local success = pcall(function()
                for i, v in ipairs(args) do
                    if type(v) == "string" then argsStr = argsStr .. '"' .. v .. '"'
                    elseif type(v) == "number" or type(v) == "boolean" then argsStr = argsStr .. tostring(v)
                    elseif typeof(v) == "Instance" then argsStr = argsStr .. v:GetFullName()
                    else argsStr = argsStr .. '"' .. tostring(v) .. '"' end
                    if i < #args then argsStr = argsStr .. ", " end
                end
            end)
            
            if not success then argsStr = '"Lỗi_Đọc_Dữ_Liệu"' end
            local fullCode = string.format('%s:%s(%s)', remoteName, method, argsStr)
            
            if not _G.LoggedRemotes[fullCode] then
                _G.LoggedRemotes[fullCode] = true
                AddLogToUI(fullCode)
            end
        end)
    end
    
    return oldNamecall(self, ...)
end)

-- Tạo nút Tắt Mở UI thu gọn
local ToggleBtn2 = Instance.new("TextButton", ScreenGui)
ToggleBtn2.Size = UDim2.new(0, 45, 0, 45); ToggleBtn2.Position = UDim2.new(0, 15, 0.5, 40)
ToggleBtn2.BackgroundColor3 = Color3.fromRGB(25, 25, 30); ToggleBtn2.Text = "👁️"
ToggleBtn2.TextColor3 = Color3.fromRGB(0, 255, 150); ToggleBtn2.Font = Enum.Font.GothamBold; ToggleBtn2.TextSize = 20
Instance.new("UICorner", ToggleBtn2).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", ToggleBtn2).Color = Color3.fromRGB(0, 255, 150)

ToggleBtn2.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
