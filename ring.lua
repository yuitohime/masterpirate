-- ==========================================
-- 🛠️ TEST MENU V3: PHYSICAL CLICK & FLAT LOOP (CHỐNG ĐƠ TUYỆT ĐỐI)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VIM = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

local SafeParent = pcall(gethui) and gethui() or LocalPlayer:WaitForChild("PlayerGui")
if SafeParent:FindFirstChild("TestSmart_Menu") then SafeParent["TestSmart_Menu"]:Destroy() end

_G.Test_Mihawk = false; _G.MihawkAmt = "x1"
_G.Test_Shadow = false; _G.ShadowItem = "Shadow Spirit"; _G.ShadowAmt = "x1"
_G.Test_Raid = false

-- ================= TẠO GIAO DIỆN =================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "TestSmart_Menu"; ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 360, 0, 380); MainFrame.Position = UDim2.new(0.5, -180, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 150)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30); Title.BackgroundTransparency = 1
Title.Text = "🛠️ TEST V3: PHYSICAL CLICK BYPASS"; Title.TextColor3 = Color3.fromRGB(0, 255, 150)
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
    Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 55); Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.GothamBold
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
    
    MainBtn.MouseButton1Click:Connect(function() Frame.Size = Frame.Size.Y.Offset == 25 and UDim2.new(1, -20, 0, 105) or UDim2.new(1, -20, 0, 25) end)
    
    for _, item in pairs(items) do
        local Btn = Instance.new("TextButton", Drop)
        Btn.Size = UDim2.new(1, 0, 0, 20); Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        Btn.Text = item; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.Gotham; Btn.TextSize = 11
        Btn.MouseButton1Click:Connect(function()
            _G[globalVar] = item
            MainBtn.Text = "  " .. title .. ": " .. item .. " ▼"; Frame.Size = UDim2.new(1, -20, 0, 25)
        end)
    end
    Drop.CanvasSize = UDim2.new(0, 0, 0, #items * 20)
end

CreateDivider(50, "SPAWN MIHAWK")
CreateDropdown(70, "Lượng Spawn", {"x1", "x10", "x100"}, "MihawkAmt")
CreateToggle(100, "Bật Auto Mihawk", "Mihawk")

CreateDivider(140, "GIVE SHADOW")
CreateDropdown(160, "Vật Phẩm", {"Shadow Spirit", "Rotten Flesh", "Aqua Soul", "Bone", "Blood Bottle"}, "ShadowItem")
CreateDropdown(190, "Số Lượng", {"x1", "x5", "x10"}, "ShadowAmt")
CreateToggle(220, "Bật Auto Give Shadow", "Shadow")

CreateDivider(260, "MUA RAID")
CreateToggle(280, "Bật Auto Mua Raid (Buy with Beli)", "Raid")

-- ================= HÀM HỖ TRỢ LÕI ĐỈNH CAO =================

-- 1. Bấm Vật Lý Bằng Tọa Độ (Không sợ LocalScript chặn)
local function PhysicalClick(guiObj)
    if not guiObj then return end
    
    -- Lấy Inset của điện thoại (Tai thỏ, viền) để bù trừ tọa độ cho chuẩn xác 100%
    local inset = GuiService:GetGuiInset()
    local center = guiObj.AbsolutePosition + (guiObj.AbsoluteSize / 2)
    
    local finalX = center.X
    local finalY = center.Y + inset.Y

    -- Giả lập chạm tay vào đúng tọa độ của nút
    VIM:SendMouseButtonEvent(finalX, finalY, 0, true, game, 0)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(finalX, finalY, 0, false, game, 0)
end

-- 2. Chạm vào sát Mép màn hình (Skip thoại không xung đột)
local function TapScreenEdge()
    VIM:SendMouseButtonEvent(5, 50, 0, true, game, 0)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(5, 50, 0, false, game, 0)
end

-- 3. Tìm nút thông minh
local function SmartFindButton(gui, searchText)
    for _, obj in pairs(gui:GetDescendants()) do
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            -- Check chính nó
            if obj:IsA("TextButton") and obj.Text and string.find(string.lower(obj.Text), string.lower(searchText)) then return obj end
            -- Check TextLabel con của nó
            local txtChild = obj:FindFirstChildWhichIsA("TextLabel")
            if txtChild and txtChild.Text and string.find(string.lower(txtChild.Text), string.lower(searchText)) then return obj end
        end
    end
    return nil
end

-- 4. Teleport Thông minh
local function SmartTeleport(targetPos)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local dist = (hrp.Position - targetPos).Magnitude
    if dist > 50 then
        StatusLbl.Text = "Trạng thái: Đang Teleport để load map..."
        hrp.CFrame = CFrame.new(targetPos)
        task.wait(1.5) 
    end
    return true
end

-- ================= LOGIC VÒNG LẶP PHẲNG (KHÔNG BAO GIỜ ĐƠ) =================

-- 🟢 1. LOGIC MIHAWK
task.spawn(function()
    while task.wait(0.1) do -- Chạy siêu tốc
        if not _G.Test_Mihawk then continue end
        
        if SmartTeleport(Vector3.new(-1380, 77, 3904)) then
            local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
            
            if not talkingGui then
                -- NẾU KHÔNG CÓ BẢNG THOẠI -> GỌI NPC
                local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Stone Statue")
                if npc then
                    StatusLbl.Text = "Trạng thái: Đang gọi Mihawk..."
                    task.spawn(function() pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end) end)
                    task.wait(0.5) -- Đợi bảng thoại nảy lên
                end
            else
                -- NẾU CÓ BẢNG THOẠI -> QUÉT TÌM NÚT
                local amtBtn = SmartFindButton(talkingGui, _G.MihawkAmt)
                if amtBtn then
                    StatusLbl.Text = "Trạng thái: Đang bấm Physical Click vào " .. _G.MihawkAmt
                    PhysicalClick(amtBtn)
                    task.wait(1) -- Tránh spam bấm 1 lựa chọn
                else
                    -- Không thấy nút chọn -> Đang bị kẹt ở phần chữ -> Nháy mép màn hình
                    TapScreenEdge()
                    
                    -- Tìm thử xem có nút tàng hình Click ko, nếu có thì ép bấm luôn
                    local clickBtn = talkingGui:FindFirstChild("Click", true)
                    if clickBtn then PhysicalClick(clickBtn) end
                end
            end
        end
    end
end)

-- 🟢 2. LOGIC SHADOW
task.spawn(function()
    while task.wait(0.1) do
        if not _G.Test_Shadow then continue end
        
        if SmartTeleport(Vector3.new(-10371, 100, -3519)) then
            local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
            
            if not talkingGui then
                -- GỌI NPC
                local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Shadow 1")
                if npc then
                    StatusLbl.Text = "Trạng thái: Đang gọi Shadow..."
                    task.spawn(function() pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end) end)
                    task.wait(0.5)
                end
            else
                -- TÌM NÚT VẬT PHẨM VÀ SỐ LƯỢNG (Không cần chia phase, cứ thấy là bấm)
                local itemBtn = SmartFindButton(talkingGui, _G.ShadowItem)
                local amtBtn = SmartFindButton(talkingGui, _G.ShadowAmt)
                
                if itemBtn then
                    StatusLbl.Text = "Trạng thái: Đang chọn Vật Phẩm..."
                    PhysicalClick(itemBtn)
                    task.wait(1)
                elseif amtBtn then
                    StatusLbl.Text = "Trạng thái: Đang chọn Số Lượng..."
                    PhysicalClick(amtBtn)
                    task.wait(1)
                else
                    -- Không thấy lựa chọn nào -> Đang kẹt ở đoạn lảm nhảm -> Skip!
                    TapScreenEdge()
                    local clickBtn = talkingGui:FindFirstChild("Click", true)
                    if clickBtn then PhysicalClick(clickBtn) end
                end
            end
        end
    end
end)

-- 🟢 3. LOGIC MUA RAID
task.spawn(function()
    while task.wait(0.1) do
        if not _G.Test_Raid then continue end
        
        if SmartTeleport(Vector3.new(-1371, 79, 3982)) then
            local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
            
            if not talkingGui then
                -- GỌI NPC
                local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Dazzl")
                if npc then
                    StatusLbl.Text = "Trạng thái: Đang gọi Dazzl..."
                    task.spawn(function() pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end) end)
                    task.wait(0.5)
                end
            else
                -- TÌM LỰA CHỌN
                local buyBtn = SmartFindButton(talkingGui, "Buy with Beli")
                if buyBtn then
                    StatusLbl.Text = "Trạng thái: Đang bấm Physical Click Mua Raid!"
                    PhysicalClick(buyBtn)
                    task.wait(2) -- Mua xong đợi 2s để game tải
                else
                    -- Đang kẹt ở chữ -> Skip
                    TapScreenEdge()
                    local clickBtn = talkingGui:FindFirstChild("Click", true)
                    if clickBtn then PhysicalClick(clickBtn) end
                end
            end
        end
    end
end)
