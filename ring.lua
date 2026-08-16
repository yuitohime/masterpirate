-- ==========================================
-- 🛠️ TEST MENU: SMART AUTO BOSS & RAID (DỰA TRÊN LOG F9 CỦA USER)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local SafeParent = pcall(gethui) and gethui() or LocalPlayer:WaitForChild("PlayerGui")
if SafeParent:FindFirstChild("TestSmart_Menu") then SafeParent["TestSmart_Menu"]:Destroy() end

-- Biến lưu trữ cài đặt
_G.Test_Mihawk = false
_G.MihawkAmt = "x1"

_G.Test_Shadow = false
_G.ShadowItem = "Shadow Spirit"
_G.ShadowAmt = "x1"

_G.Test_Raid = false

-- ================= TẠO GIAO DIỆN =================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "TestSmart_Menu"; ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 360, 0, 380); MainFrame.Position = UDim2.new(0.5, -180, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 150)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30); Title.BackgroundTransparency = 1
Title.Text = "🛠️ SMART TEST: BOSS & RAID"; Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold; Title.TextSize = 14

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 16
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local StatusLbl = Instance.new("TextLabel", MainFrame)
StatusLbl.Size = UDim2.new(1, -20, 0, 20); StatusLbl.Position = UDim2.new(0, 10, 0, 30)
StatusLbl.BackgroundTransparency = 1; StatusLbl.TextColor3 = Color3.fromRGB(255, 255, 100)
StatusLbl.Text = "Trạng thái: Đang chờ..."; StatusLbl.TextXAlignment = Enum.TextXAlignment.Left
StatusLbl.Font = Enum.Font.Gotham; StatusLbl.TextSize = 11

local function CreateDivider(yPos, text)
    local Lbl = Instance.new("TextLabel", MainFrame)
    Lbl.Size = UDim2.new(1, 0, 0, 20); Lbl.Position = UDim2.new(0, 0, 0, yPos)
    Lbl.BackgroundTransparency = 1; Lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    Lbl.Text = "--- " .. text .. " ---"; Lbl.Font = Enum.Font.GothamBold; Lbl.TextSize = 12
end

local function CreateToggle(yPos, text, varName)
    local Btn = Instance.new("TextButton", MainFrame)
    Btn.Size = UDim2.new(1, -20, 0, 30); Btn.Position = UDim2.new(0, 10, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    Btn.Text = text; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    Btn.MouseButton1Click:Connect(function()
        if varName == "Mihawk" then _G.Test_Mihawk = not _G.Test_Mihawk
        elseif varName == "Shadow" then _G.Test_Shadow = not _G.Test_Shadow
        elseif varName == "Raid" then _G.Test_Raid = not _G.Test_Raid end
        
        local state = (varName == "Mihawk" and _G.Test_Mihawk) or (varName == "Shadow" and _G.Test_Shadow) or (varName == "Raid" and _G.Test_Raid)
        Btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(50, 50, 55)
    end)
end

local function CreateDropdown(yPos, title, items, globalVar)
    local Frame = Instance.new("Frame", MainFrame)
    Frame.Size = UDim2.new(1, -20, 0, 25); Frame.Position = UDim2.new(0, 10, 0, yPos)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40); Frame.ClipsDescendants = true
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
    
    local MainBtn = Instance.new("TextButton", Frame)
    MainBtn.Size = UDim2.new(1, 0, 0, 25); MainBtn.BackgroundTransparency = 1
    MainBtn.Text = "  " .. title .. ": " .. _G[globalVar] .. " ▼"
    MainBtn.TextColor3 = Color3.fromRGB(200, 200, 200); MainBtn.Font = Enum.Font.Gotham; MainBtn.TextSize = 11; MainBtn.TextXAlignment = Enum.TextXAlignment.Left
    
    local Drop = Instance.new("ScrollingFrame", Frame)
    Drop.Size = UDim2.new(1, 0, 0, 80); Drop.Position = UDim2.new(0, 0, 0, 25)
    Drop.BackgroundTransparency = 1; Drop.ScrollBarThickness = 2
    local layout = Instance.new("UIListLayout", Drop)
    
    MainBtn.MouseButton1Click:Connect(function()
        Frame.Size = Frame.Size.Y.Offset == 25 and UDim2.new(1, -20, 0, 105) or UDim2.new(1, -20, 0, 25)
    end)
    
    for _, item in pairs(items) do
        local Btn = Instance.new("TextButton", Drop)
        Btn.Size = UDim2.new(1, 0, 0, 20); Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        Btn.Text = item; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.Gotham; Btn.TextSize = 11
        Btn.MouseButton1Click:Connect(function()
            if globalVar == "MihawkAmt" then _G.MihawkAmt = item
            elseif globalVar == "ShadowItem" then _G.ShadowItem = item
            elseif globalVar == "ShadowAmt" then _G.ShadowAmt = item end
            MainBtn.Text = "  " .. title .. ": " .. item .. " ▼"
            Frame.Size = UDim2.new(1, -20, 0, 25)
        end)
    end
    Drop.CanvasSize = UDim2.new(0, 0, 0, #items * 20)
end

-- Bố cục Menu
CreateDivider(50, "SPAWN MIHAWK")
CreateDropdown(70, "Lượng Spawn", {"x1", "x10", "x100"}, "MihawkAmt")
CreateToggle(100, "Bật Auto Mihawk", "Mihawk")

CreateDivider(140, "GIVE SHADOW")
CreateDropdown(160, "Vật Phẩm", {"Shadow Spirit", "Rotten Flesh", "Aqua Soul", "Bone", "Blood Bottle"}, "ShadowItem")
CreateDropdown(190, "Số Lượng", {"x1", "x5", "x10"}, "ShadowAmt")
CreateToggle(220, "Bật Auto Give Shadow", "Shadow")

CreateDivider(260, "MUA RAID")
CreateToggle(280, "Bật Auto Mua Raid (Buy with Beli)", "Raid")

-- ================= HÀM HỖ TRỢ LÕI THÔNG MINH =================

local function FireVirtualButton(btn)
    if getconnections then
        for _, c in pairs(getconnections(btn.MouseButton1Click)) do c:Fire() end
        for _, c in pairs(getconnections(btn.MouseButton1Down)) do c:Fire() end
    elseif firesignal then firesignal(btn.MouseButton1Click) end
end

-- Hàm tìm nút siêu chuẩn (Quét cả Button lẫn TextLabel con của nó)
local function SmartFindButton(gui, searchText)
    for i = 1, 6 do
        local btn = gui:FindFirstChild("Button" .. tostring(i), true)
        if btn then
            if btn.Text and string.find(string.lower(btn.Text), string.lower(searchText)) then return btn end
            local txtChild = btn:FindFirstChildWhichIsA("TextLabel")
            if txtChild and txtChild.Text and string.find(string.lower(txtChild.Text), string.lower(searchText)) then return btn end
        end
    end
    return nil
end

local function SmartTeleport(targetPos)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local dist = (hrp.Position - targetPos).Magnitude
    if dist > 50 then
        StatusLbl.Text = "Trạng thái: Đang Teleport để load map..."
        hrp.CFrame = CFrame.new(targetPos)
        task.wait(1.5) -- Bắt buộc phải đợi để map và NPC kịp load
    end
    return true
end

-- ================= LOGIC XỬ LÝ CHÍNH =================

-- 🟢 1. LOGIC MIHAWK
task.spawn(function()
    while task.wait(1) do
        if not _G.Test_Mihawk then continue end
        
        if SmartTeleport(Vector3.new(-1380, 77, 3904)) then
            local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Stone Statue")
            if not npc then StatusLbl.Text = "Trạng thái: Chưa tìm thấy Stone Statue!"; continue end
            
            StatusLbl.Text = "Trạng thái: Đang gọi Mihawk..."
            pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end)
            
            local timeout = 20
            while timeout > 0 and _G.Test_Mihawk do
                task.wait(0.2); timeout = timeout - 1
                local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
                if talkingGui then
                    -- Kiểm tra xem có nút "Hey" không
                    local heyBtn = SmartFindButton(talkingGui, "Hey")
                    if heyBtn then FireVirtualButton(heyBtn); task.wait(0.3); continue end
                    
                    -- Tìm nút số lượng bạn đã set
                    local amtBtn = SmartFindButton(talkingGui, _G.MihawkAmt)
                    if amtBtn then
                        StatusLbl.Text = "Trạng thái: Đã bấm chọn " .. _G.MihawkAmt .. "!"
                        FireVirtualButton(amtBtn)
                        task.wait(2)
                        break
                    end
                    
                    -- Nếu không có Hey, không có lựa chọn thì bấm Click để skip chữ
                    local clickBtn = talkingGui:FindFirstChild("Click", true)
                    if clickBtn then FireVirtualButton(clickBtn) end
                end
            end
        end
    end
end)

-- 🟢 2. LOGIC SHADOW
task.spawn(function()
    while task.wait(1) do
        if not _G.Test_Shadow then continue end
        
        if SmartTeleport(Vector3.new(-10371, 100, -3519)) then
            local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Shadow 1")
            if not npc then StatusLbl.Text = "Trạng thái: Chưa tìm thấy Shadow 1!"; continue end
            
            StatusLbl.Text = "Trạng thái: Đang nói chuyện với Shadow..."
            pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end)
            
            local phase = 1
            local timeout = 40
            
            while timeout > 0 and _G.Test_Shadow do
                task.wait(0.2); timeout = timeout - 1
                local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
                if talkingGui then
                    if phase == 1 then
                        local itemBtn = SmartFindButton(talkingGui, _G.ShadowItem)
                        if itemBtn then
                            StatusLbl.Text = "Trạng thái: Đã chọn " .. _G.ShadowItem
                            FireVirtualButton(itemBtn)
                            phase = 2
                            task.wait(0.5)
                            continue
                        end
                    elseif phase == 2 then
                        local amtBtn = SmartFindButton(talkingGui, _G.ShadowAmt)
                        if amtBtn then
                            StatusLbl.Text = "Trạng thái: Đã give " .. _G.ShadowAmt .. " cái!"
                            FireVirtualButton(amtBtn)
                            task.wait(2)
                            break
                        end
                    end
                    
                    local clickBtn = talkingGui:FindFirstChild("Click", true)
                    if clickBtn then FireVirtualButton(clickBtn) end
                end
            end
        end
    end
end)

-- 🟢 3. LOGIC MUA RAID
task.spawn(function()
    while task.wait(1) do
        if not _G.Test_Raid then continue end
        
        if SmartTeleport(Vector3.new(-1371, 79, 3982)) then
            local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Dazzl")
            if not npc then StatusLbl.Text = "Trạng thái: Chưa tìm thấy Dazzl!"; continue end
            
            StatusLbl.Text = "Trạng thái: Đang gọi Dazzl..."
            pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end)
            
            local timeout = 20
            while timeout > 0 and _G.Test_Raid do
                task.wait(0.2); timeout = timeout - 1
                local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
                if talkingGui then
                    local buyBtn = SmartFindButton(talkingGui, "Buy with Beli")
                    if buyBtn then
                        StatusLbl.Text = "Trạng thái: Đã Mua Raid Bằng Beli!"
                        FireVirtualButton(buyBtn)
                        task.wait(2)
                        break
                    end
                    
                    local clickBtn = talkingGui:FindFirstChild("Click", true)
                    if clickBtn then FireVirtualButton(clickBtn) end
                end
            end
        end
    end
end)
