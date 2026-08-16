-- ==========================================
-- SMART REMOTE SPY V4 (QUEUE SYSTEM + COPY ICON UI)
-- DÀNH RIÊNG CHO MOBILE EXECUTOR
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Xóa bảng cũ nếu có
local SafeParent = pcall(gethui) and gethui() or LocalPlayer:WaitForChild("PlayerGui")
if SafeParent:FindFirstChild("SpyV4_Menu") then SafeParent["SpyV4_Menu"]:Destroy() end

_G.IsSpying = false
_G.CapturedRemotes = {} -- Hàng đợi để xử lý an toàn
_G.LoggedKeys = {} -- Chống spam trùng lặp

-- ================= TẠO GIAO DIỆN =================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "SpyV4_Menu"; ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 380, 0, 300)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 200)

-- Thanh tiêu đề
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -90, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = "📡 REMOTE SPY V4"
Title.TextColor3 = Color3.fromRGB(0, 255, 200); Title.Font = Enum.Font.GothamBold
Title.TextSize = 14; Title.TextXAlignment = Enum.TextXAlignment.Left

-- Nút Xóa
local ClearBtn = Instance.new("TextButton", TopBar)
ClearBtn.Size = UDim2.new(0, 50, 0, 25); ClearBtn.Position = UDim2.new(1, -85, 0, 5)
ClearBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ClearBtn.Text = "XÓA"; ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.Font = Enum.Font.GothamBold; ClearBtn.TextSize = 12
Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 4)

-- Nút Ẩn Menu
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 25, 0, 25); CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 12
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

-- Nút Bật/Tắt Spy
local ToggleSpyBtn = Instance.new("TextButton", MainFrame)
ToggleSpyBtn.Size = UDim2.new(1, -20, 0, 35); ToggleSpyBtn.Position = UDim2.new(0, 10, 0, 45)
ToggleSpyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleSpyBtn.Text = "🔴 ĐANG TẮT SPY (BẤM ĐỂ BẬT)"
ToggleSpyBtn.TextColor3 = Color3.fromRGB(255, 255, 255); ToggleSpyBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ToggleSpyBtn).CornerRadius = UDim.new(0, 6)

-- Vùng chứa List Code
local ScrollList = Instance.new("ScrollingFrame", MainFrame)
ScrollList.Size = UDim2.new(1, -20, 1, -95); ScrollList.Position = UDim2.new(0, 10, 0, 85)
ScrollList.BackgroundTransparency = 1; ScrollList.ScrollBarThickness = 4
ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)

local UIListLayout = Instance.new("UIListLayout", ScrollList)
UIListLayout.Padding = UDim.new(0, 6)

-- Nút mở lại Menu khi đã ẩn
local OpenMenuBtn = Instance.new("TextButton", ScreenGui)
OpenMenuBtn.Size = UDim2.new(0, 45, 0, 45); OpenMenuBtn.Position = UDim2.new(0, 15, 0.5, 80)
OpenMenuBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
OpenMenuBtn.Text = "📡"; OpenMenuBtn.TextColor3 = Color3.fromRGB(0, 255, 200)
OpenMenuBtn.Font = Enum.Font.GothamBold; OpenMenuBtn.TextSize = 22
Instance.new("UICorner", OpenMenuBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", OpenMenuBtn).Color = Color3.fromRGB(0, 255, 200)

-- ================= CHỨC NĂNG NÚT =================
ToggleSpyBtn.MouseButton1Click:Connect(function()
    _G.IsSpying = not _G.IsSpying
    if _G.IsSpying then
        ToggleSpyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        ToggleSpyBtn.Text = "🟢 ĐANG BẬT SPY (BẤM ĐỂ TẮT)"
    else
        ToggleSpyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ToggleSpyBtn.Text = "🔴 ĐANG TẮT SPY (BẤM ĐỂ BẬT)"
    end
end)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
OpenMenuBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true end)

ClearBtn.MouseButton1Click:Connect(function()
    for _, child in pairs(ScrollList:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    _G.LoggedKeys = {}; ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)
end)

-- Hàm Thêm Khung Chứa Code Có Nút Copy Vảo UI
local function CreateCodeEntry(fullCode)
    local EntryFrame = Instance.new("Frame", ScrollList)
    EntryFrame.Size = UDim2.new(1, 0, 0, 45)
    EntryFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Instance.new("UICorner", EntryFrame).CornerRadius = UDim.new(0, 6)
    
    -- TextBox để hiển thị code (có thể lướt tay qua lại nếu code dài)
    local CodeText = Instance.new("TextBox", EntryFrame)
    CodeText.Size = UDim2.new(1, -45, 1, 0); CodeText.Position = UDim2.new(0, 5, 0, 0)
    CodeText.BackgroundTransparency = 1
    CodeText.Text = fullCode; CodeText.TextColor3 = Color3.fromRGB(220, 220, 220)
    CodeText.Font = Enum.Font.Code; CodeText.TextSize = 11
    CodeText.TextWrapped = true; CodeText.TextXAlignment = Enum.TextXAlignment.Left
    CodeText.ClearTextOnFocus = false; CodeText.TextEditable = false
    
    -- Nút Copy (Hình cái bảng)
    local CopyBtn = Instance.new("TextButton", EntryFrame)
    CopyBtn.Size = UDim2.new(0, 35, 0, 35); CopyBtn.Position = UDim2.new(1, -40, 0.5, -17.5)
    CopyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    CopyBtn.Text = "📋"; CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyBtn.Font = Enum.Font.GothamBold; CopyBtn.TextSize = 16
    Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 6)
    
    CopyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(fullCode)
            CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            CopyBtn.Text = "✅"
            task.wait(1)
            CopyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
            CopyBtn.Text = "📋"
        end
    end)
    
    ScrollList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end

-- ================= HOOK & QUEUE SYSTEM (CHỐNG DROP) =================
local function ProcessArguments(args)
    local argsStr = ""
    for i, v in ipairs(args) do
        local valType = typeof(v)
        if valType == "string" then argsStr = argsStr .. '"' .. v .. '"'
        elseif valType == "number" or valType == "boolean" then argsStr = argsStr .. tostring(v)
        elseif valType == "Instance" then 
            local s, name = pcall(function() return v:GetFullName() end)
            argsStr = argsStr .. (s and name or 'nil')
        else 
            argsStr = argsStr .. "nil" 
        end
        if i < #args then argsStr = argsStr .. ", " end
    end
    return argsStr
end

-- Vòng lặp ngầm: Xử lý giỏ hàng chứa code (Chống lag executor)
task.spawn(function()
    while task.wait(0.1) do
        if #_G.CapturedRemotes > 0 then
            local data = table.remove(_G.CapturedRemotes, 1) -- Rút code ra khỏi giỏ
            
            local s, path = pcall(function() return data.obj:GetFullName() end)
            if not s then path = "Unknown" end
            
            -- Chặn rác hiển thị (nhưng không làm lỗi hook)
            local isSpam = false
            local lowerPath = string.lower(path)
            local badWords = {"mouse", "move", "camera", "walk", "update", "ping", "step", "dash", "jump", "anim"}
            for _, bad in ipairs(badWords) do
                if string.find(lowerPath, bad) then isSpam = true; break end
            end
            
            if not isSpam then
                local argsStr = ProcessArguments(data.args)
                local fullCode = string.format('game:GetService("ReplicatedStorage").%s:%s(%s)', data.obj.Name, data.method, argsStr)
                
                -- Nếu lấy được path chuẩn thì dùng path chuẩn
                if path ~= "Unknown" and path ~= data.obj.Name then
                    fullCode = string.format('%s:%s(%s)', path, data.method, argsStr)
                end
                
                if not _G.LoggedKeys[fullCode] then
                    _G.LoggedKeys[fullCode] = true
                    CreateCodeEntry(fullCode)
                end
            end
        end
    end
end)

-- Bắt Namecall cực nhẹ: Chỉ ném dữ liệu vào Queue, không làm gì thêm
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    if _G.IsSpying and not checkcaller() then
        local method = getnamecallmethod()
        if method == "FireServer" or method == "InvokeServer" then
            -- Ném vào giỏ hàng ngay lập tức rồi trả game lại bình thường
            table.insert(_G.CapturedRemotes, {obj = self, method = method, args = {...}})
        end
    end
    return oldNamecall(self, ...)
end)
