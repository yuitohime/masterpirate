-- ==========================================
-- 🛠️ TEST MENU: AUTO BOSS & RAID (FIX LỖI THOẠI & TELEPORT)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local SafeParent = pcall(gethui) and gethui() or LocalPlayer:WaitForChild("PlayerGui")
if SafeParent:FindFirstChild("TestBoss_Menu") then SafeParent["TestBoss_Menu"]:Destroy() end

_G.Test_Mihawk = false
_G.Test_Shadow = false
_G.Test_Raid = false

-- ================= TẠO GIAO DIỆN =================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "TestBoss_Menu"; ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 220); MainFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 200, 0)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30); Title.BackgroundTransparency = 1
Title.Text = "🛠️ TEST AUTO BOSS & RAID"; Title.TextColor3 = Color3.fromRGB(255, 200, 0)
Title.Font = Enum.Font.GothamBold; Title.TextSize = 14

local StatusLbl = Instance.new("TextLabel", MainFrame)
StatusLbl.Size = UDim2.new(1, -20, 0, 20); StatusLbl.Position = UDim2.new(0, 10, 0, 30)
StatusLbl.BackgroundTransparency = 1; StatusLbl.TextColor3 = Color3.fromRGB(150, 255, 150)
StatusLbl.Text = "Trạng thái: Đang chờ..."; StatusLbl.TextXAlignment = Enum.TextXAlignment.Left
StatusLbl.Font = Enum.Font.Gotham; StatusLbl.TextSize = 12

local function CreateBtn(yPos, text, varName)
    local Btn = Instance.new("TextButton", MainFrame)
    Btn.Size = UDim2.new(1, -20, 0, 35); Btn.Position = UDim2.new(0, 10, 0, yPos)
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

CreateBtn(60, "Bật Auto Spawn Mihawk (Lấy x1)", "Mihawk")
CreateBtn(105, "Bật Auto Shadow (Lấy Shadow Spirit - x1)", "Shadow")
CreateBtn(150, "Bật Auto Mua Raid (Buy with Beli)", "Raid")

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 14
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- ================= HÀM HỖ TRỢ LÕI (CỰC KỲ QUAN TRỌNG) =================

-- 1. Hàm Bấm Nút Ảo An Toàn
local function FireVirtualButton(btn)
    if not btn then return end
    if getconnections then
        for _, c in pairs(getconnections(btn.MouseButton1Click)) do c:Fire() end
        for _, c in pairs(getconnections(btn.MouseButton1Down)) do c:Fire() end
    elseif firesignal then
        firesignal(btn.MouseButton1Click)
    end
end

-- 2. Hàm Tự Tìm Nút Bằng Chữ (Dù game đổi tên Button1 thành Button10 vẫn tìm ra)
local function FindButtonByText(gui, searchText)
    for _, obj in pairs(gui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            if string.find(string.lower(obj.Text), string.lower(searchText)) then
                if obj:IsA("TextButton") then return obj end
                if obj.Parent:IsA("TextButton") then return obj.Parent end
            end
        end
    end
    return nil
end

-- 3. Hàm Dịch Chuyển Mồi (Pre-Teleport)
local function SmartTeleport(targetPos)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local dist = (hrp.Position - targetPos).Magnitude
    if dist > 50 then -- Nếu ở xa hơn 50 stud
        StatusLbl.Text = "Trạng thái: Đang Teleport để load map..."
        hrp.CFrame = CFrame.new(targetPos)
        task.wait(1.5) -- Đợi 1.5 giây cho map và NPC hiện ra đầy đủ
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
            if not npc then StatusLbl.Text = "Trạng thái: Chưa tìm thấy NPC Mihawk!"; continue end
            
            StatusLbl.Text = "Trạng thái: Đang gọi Mihawk..."
            pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end)
            
            -- Vòng lặp Spam chữ và Lựa chọn
            local timeout = 20 -- Thử tối đa 20 lần (2 giây)
            while timeout > 0 and _G.Test_Mihawk do
                task.wait(0.1); timeout = timeout - 1
                
                local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
                if talkingGui then
                    -- Ưu tiên tìm nút có chữ "x1" (Lựa chọn cuối cùng)
                    local btnOption = FindButtonByText(talkingGui, "x1")
                    if btnOption then
                        StatusLbl.Text = "Trạng thái: Đã bấm chọn x1!"
                        FireVirtualButton(btnOption)
                        task.wait(2) -- Delay để chống kẹt
                        break
                    end
                    
                    -- Nếu chưa thấy nút x1, thì đi tìm nút Click để Skip thoại
                    local clickBtn = talkingGui:FindFirstChild("Click", true)
                    if clickBtn then FireVirtualButton(clickBtn) end
                end
            end
        end
    end
end)

-- 🟢 2. LOGIC SHADOW (2 Giai Đoạn Chọn)
task.spawn(function()
    while task.wait(1) do
        if not _G.Test_Shadow then continue end
        
        if SmartTeleport(Vector3.new(-10371, 100, -3519)) then
            local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Shadow 1")
            if not npc then StatusLbl.Text = "Trạng thái: Chưa tìm thấy NPC Shadow!"; continue end
            
            StatusLbl.Text = "Trạng thái: Đang gọi Shadow..."
            pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end)
            
            local phase = 1 -- Giai đoạn 1: Chọn Đồ, Giai đoạn 2: Chọn Số lượng
            local timeout = 40
            
            while timeout > 0 and _G.Test_Shadow do
                task.wait(0.1); timeout = timeout - 1
                local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
                if talkingGui then
                    if phase == 1 then
                        local btnItem = FindButtonByText(talkingGui, "Shadow Spirit")
                        if btnItem then
                            StatusLbl.Text = "Trạng thái: Đã chọn Shadow Spirit!"
                            FireVirtualButton(btnItem)
                            phase = 2
                            task.wait(0.5) -- Đợi giao diện chuyển sang hỏi số lượng
                            continue
                        end
                    elseif phase == 2 then
                        local btnAmt = FindButtonByText(talkingGui, "x1")
                        if btnAmt then
                            StatusLbl.Text = "Trạng thái: Đã chọn x1 Shadow!"
                            FireVirtualButton(btnAmt)
                            task.wait(2)
                            break
                        end
                    end
                    
                    -- Nã nút Skip chữ liên tục nếu không thấy lựa chọn
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
            if not npc then StatusLbl.Text = "Trạng thái: Chưa tìm thấy NPC Dazzl!"; continue end
            
            StatusLbl.Text = "Trạng thái: Đang mua Raid..."
            pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end)
            
            local timeout = 20
            while timeout > 0 and _G.Test_Raid do
                task.wait(0.1); timeout = timeout - 1
                local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
                if talkingGui then
                    local btnOption = FindButtonByText(talkingGui, "Buy with Beli")
                    if btnOption then
                        StatusLbl.Text = "Trạng thái: Đã Mua Raid Bằng Beli!"
                        FireVirtualButton(btnOption)
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
