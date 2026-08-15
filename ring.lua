local player = game.Players.LocalPlayer
local guiName = "MobScannerLoggerGUI"

-- 1. XÓA GUI CŨ NẾU CÓ
local existingGui = game.CoreGui:FindFirstChild(guiName) or player.PlayerGui:FindFirstChild(guiName)
if existingGui then existingGui:Destroy() end

-- 2. TẠO GIAO DIỆN CƠ BẢN
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
-- Sử dụng CoreGui nếu dùng Executor (để tránh bị xóa khi chết), hoặc PlayerGui nếu test trong Studio
local success, _ = pcall(function() screenGui.Parent = game.CoreGui end)
if not success then screenGui.Parent = player.PlayerGui end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = " Mob Scanner & Logger"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.BorderSizePixel = 0
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Khu vực hiển thị trạng thái
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 50)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Text = "Trạng thái: Đang chờ quét..."
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Parent = mainFrame

-- 3. CÁC NÚT BẤM (Scan, Save, Copy)
local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(1, -20, 0, 40)
btnContainer.Position = UDim2.new(0, 10, 0, 90)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = mainFrame

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.32, 0, 1, 0)
scanBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.Text = "1. Quét"
scanBtn.Font = Enum.Font.SourceSansBold
scanBtn.TextSize = 16
scanBtn.Parent = btnContainer

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.32, 0, 1, 0)
saveBtn.Position = UDim2.new(0.34, 0, 0, 0)
saveBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.Text = "2. Lưu"
saveBtn.Font = Enum.Font.SourceSansBold
saveBtn.TextSize = 16
saveBtn.Parent = btnContainer

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.32, 0, 1, 0)
copyBtn.Position = UDim2.new(0.68, 0, 0, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Text = "3. Copy Code"
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 16
copyBtn.Parent = btnContainer

-- 4. KHU VỰC HIỂN THỊ NOTE (Sổ ghi chú)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -150)
scrollFrame.Position = UDim2.new(0, 10, 0, 140)
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end)

-- ==========================================
-- LOGIC HOẠT ĐỘNG
-- ==========================================

local globalDatabase = {} -- Lưu trữ toàn bộ dữ liệu đã Save
local tempScannedMobs = {} -- Lưu tạm dữ liệu vừa quét
local currentIslandName = "Unknown"

-- Hàm tìm đảo gần nhất dựa vào cấu trúc workspace.All.Island
local function getClosestIsland()
    local islandFolder = workspace:FindFirstChild("All") and workspace.All:FindFirstChild("Island")
    if not islandFolder then return "Unknown_Island" end
    
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return "Unknown_Island" end

    local closestIsland = nil
    local shortestDistance = math.huge

    for _, island in ipairs(islandFolder:GetChildren()) do
        local pivot = island:GetPivot()
        local dist = (pivot.Position - hrp.Position).Magnitude
        if dist < shortestDistance then
            shortestDistance = dist
            closestIsland = island.Name
        end
    end
    
    return closestIsland or "Unknown_Island"
end

-- Hàm Quét (Scan)
scanBtn.MouseButton1Click:Connect(function()
    tempScannedMobs = {}
    currentIslandName = getClosestIsland()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    if not hrp then
        statusLabel.Text = "Lỗi: Không tìm thấy nhân vật!"
        return
    end

    local count = 0
    -- Quét toàn bộ model trong game (có thể điều chỉnh thư mục chứa quái nếu game cấu trúc khác)
    -- Thường quái nằm trong workspace hoặc workspace.Enemies
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            -- Bỏ qua người chơi thực
            if not game.Players:GetPlayerFromCharacter(obj) then
                local mobHrp = obj:FindFirstChild("HumanoidRootPart")
                if mobHrp then
                    -- Chỉ lấy quái trong bán kính 1000 stud (coi như trên cùng 1 đảo)
                    if (mobHrp.Position - hrp.Position).Magnitude < 1000 then
                        if not tempScannedMobs[obj.Name] then
                            tempScannedMobs[obj.Name] = mobHrp.CFrame
                            count = count + 1
                        end
                    end
                end
            end
        end
    end

    if count > 0 then
        statusLabel.Text = string.format("Đã quét thấy %d loại quái tại [%s]. Bấm 'Lưu'!", count, currentIslandName)
    else
        statusLabel.Text = string.format("Không thấy quái nào tại [%s]! Thử bay vòng quanh cho nó load.", currentIslandName)
    end
end)

-- Hàm Lưu (Save)
saveBtn.MouseButton1Click:Connect(function()
    local count = 0
    for mobName, cframe in pairs(tempScannedMobs) do
        -- Tránh trùng lặp trong database
        if not globalDatabase[mobName] then
            globalDatabase[mobName] = {CFrame = cframe, Island = currentIslandName}
            
            -- Tạo Note hiển thị trên GUI
            local note = Instance.new("TextLabel")
            note.Size = UDim2.new(1, 0, 0, 25)
            note.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            note.TextColor3 = Color3.fromRGB(255, 255, 255)
            note.Font = Enum.Font.SourceSans
            note.TextSize = 14
            note.Text = string.format(" %s | %s", currentIslandName, mobName)
            note.TextXAlignment = Enum.TextXAlignment.Left
            note.Parent = scrollFrame
            
            count = count + 1
        end
    end
    
    if count > 0 then
        statusLabel.Text = "Đã lưu " .. count .. " quái vào danh sách!"
    else
        statusLabel.Text = "Không có quái mới nào để lưu!"
    end
    -- Reset temp để tránh lưu đè
    tempScannedMobs = {} 
end)

-- Hàm Sao chép Code (Copy)
copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        local codeString = "local MobSpawnLocations = {\n"
        
        for mobName, data in pairs(globalDatabase) do
            local cf = data.CFrame
            -- Format CFrame thành chuỗi code Lua
            local cfString = string.format("CFrame.new(%f, %f, %f)", cf.X, cf.Y, cf.Z)
            -- Thêm comment tên đảo cho dễ quản lý
            codeString = codeString .. string.format('    ["%s"] = %s, -- Đảo: %s\n', mobName, cfString, data.Island)
        end
        
        codeString = codeString .. "}\n"
        
        setclipboard(codeString)
        statusLabel.Text = "Đã copy Code vào Clipboard! Hãy Ctrl+V"
    else
        statusLabel.Text = "Executor của bạn không hỗ trợ setclipboard!"
    end
end)
