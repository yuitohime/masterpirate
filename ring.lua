local player = game.Players.LocalPlayer
local guiName = "IslandTeleportMenu"

-- 1. Xóa menu cũ nếu đã tồn tại để tránh việc tạo trùng lặp
local existingGui = player.PlayerGui:FindFirstChild(guiName)
-- Nếu dùng Executor, bạn có thể đổi player.PlayerGui thành game.CoreGui
if existingGui then
    existingGui:Destroy()
end

-- 2. Tạo ScreenGui (Giao diện màn hình)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false

-- 3. Tạo Frame chính (Khung của Menu)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 350)
mainFrame.Position = UDim2.new(0, 20, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Cho phép dùng chuột kéo thả menu trên màn hình
mainFrame.Parent = screenGui

-- 4. Tạo Tiêu đề
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "Teleport Menu"
titleLabel.BorderSizePixel = 0
titleLabel.Parent = mainFrame

-- Nút đóng Menu (Dấu X góc phải)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- 5. Tạo Khung cuộn (ScrollingFrame) để chứa danh sách đảo
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.SortOrder = Enum.SortOrder.Name
listLayout.Padding = UDim.new(0, 2)

-- 6. Hàm Dịch chuyển (Teleport)
local function teleportToIsland(islandModel)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart and islandModel then
        -- Sử dụng GetPivot() để lấy CFrame gốc của Model (hoặc Folder)
        local targetCFrame = islandModel:GetPivot()
        
        -- Dịch chuyển nhân vật đến vị trí đó + cộng thêm 50 stud chiều cao (trục Y)
        -- Điều này giúp tránh việc nhân vật bị kẹt dưới lòng đất hoặc rơi xuống biển
        humanoidRootPart.CFrame = targetCFrame + Vector3.new(0, 50, 0)
    end
end

-- 7. Tự động lấy danh sách đảo từ Workspace.All.Island
local islandsFolder = workspace:FindFirstChild("All") and workspace.All:FindFirstChild("Island")

if islandsFolder then
    for _, island in ipairs(islandsFolder:GetChildren()) do
        -- Tạo nút bấm cho từng hòn đảo
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 16
        btn.Text = island.Name
        btn.BorderSizePixel = 0
        btn.Parent = scrollFrame
        
        -- Gán sự kiện click cho nút bấm
        btn.MouseButton1Click:Connect(function()
            teleportToIsland(island)
        end)
    end
    
    -- Tự động điều chỉnh độ dài của thanh cuộn dựa trên số lượng nút bấm
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
else
    warn("Không tìm thấy đường dẫn Workspace.All.Island! Vui lòng kiểm tra lại cấu trúc.")
end
