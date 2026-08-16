-- ==========================================
-- SMART MINI REMOTE SPY FOR MOBILE
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Xóa UI cũ nếu có
local SafeParent = pcall(gethui) and gethui() or LocalPlayer:WaitForChild("PlayerGui")
if SafeParent:FindFirstChild("MiniSpyUI") then SafeParent["MiniSpyUI"]:Destroy() end

-- Tạo UI
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "MiniSpyUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 150)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -60, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔍 MINI SPY (BẤM ĐỂ COPY)"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local ClearBtn = Instance.new("TextButton", MainFrame)
ClearBtn.Size = UDim2.new(0, 50, 0, 24)
ClearBtn.Position = UDim2.new(1, -55, 0, 3)
ClearBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ClearBtn.Text = "XÓA"
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 4)

local ScrollList = Instance.new("ScrollingFrame", MainFrame)
ScrollList.Size = UDim2.new(1, -20, 1, -45)
ScrollList.Position = UDim2.new(0, 10, 0, 35)
ScrollList.BackgroundTransparency = 1
ScrollList.ScrollBarThickness = 4
ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)

local UIListLayout = Instance.new("UIListLayout", ScrollList)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Bảng chống spam
local loggedRemotes = {}

ClearBtn.MouseButton1Click:Connect(function()
    for _, child in pairs(ScrollList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    loggedRemotes = {}
    ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)
end)

-- Danh sách rác cần chặn
local blacklisted = {"mouse", "move", "camera", "walk", "update", "ping", "input", "step", "dash", "jump", "anim", "attack", "damage", "hit", "skill"}

-- Hook Namecall
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        local remoteName = string.lower(self.Name)
        local isSpam = false
        
        for _, badWord in pairs(blacklisted) do
            if string.find(remoteName, badWord) then
                isSpam = true; break
            end
        end
        
        if not isSpam then
            local args = {...}
            local argsStr = ""
            for i, v in ipairs(args) do
                if type(v) == "string" then argsStr = argsStr .. '"' .. v .. '"'
                elseif type(v) == "number" or type(v) == "boolean" then argsStr = argsStr .. tostring(v)
                elseif typeof(v) == "Instance" then argsStr = argsStr .. v:GetFullName()
                else argsStr = argsStr .. "nil" end
                if i < #args then argsStr = argsStr .. ", " end
            end
            
            local fullCode = string.format('%s:%s(%s)', self:GetFullName(), method, argsStr)
            
            if not loggedRemotes[fullCode] then
                loggedRemotes[fullCode] = true
                
                -- Đẩy UI lên màn hình
                task.spawn(function()
                    local Btn = Instance.new("TextButton", ScrollList)
                    Btn.Size = UDim2.new(1, 0, 0, 40)
                    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                    Btn.Text = fullCode
                    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    Btn.Font = Enum.Font.Gotham
                    Btn.TextSize = 11
                    Btn.TextWrapped = true
                    Btn.TextXAlignment = Enum.TextXAlignment.Left
                    Btn.TextYAlignment = Enum.TextYAlignment.Top
                    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
                    
                    local pad = Instance.new("UIPadding", Btn)
                    pad.PaddingLeft = UDim.new(0, 5); pad.PaddingTop = UDim.new(0, 5); pad.PaddingRight = UDim.new(0, 5)

                    Btn.MouseButton1Click:Connect(function()
                        if setclipboard then
                            setclipboard(fullCode)
                            Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
                            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                            task.wait(0.5)
                            Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                            Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                        end
                    end)
                    
                    ScrollList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
                end)
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

-- Tạo nút Tắt Mở UI (Hình con mắt)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, 40)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ToggleBtn.Text = "👁️"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(0, 255, 150)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
