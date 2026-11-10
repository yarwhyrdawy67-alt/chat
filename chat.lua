-- // One Shot PC Elite Script: Aimbot & Drawing ESP
-- // Supports Drawing Library & Minimize/Hide UI Feature

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- إزالة الواجهة القديمة إن وجدت
if CoreGui:FindFirstChild("OneShotPCGUI") then
    CoreGui.OneShotPCGUI:Destroy()
end

-- إنشاء واجهة التحكم الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OneShotPCGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 210)
MainFrame.Position = UDim2.new(0.02, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 215, 0) -- لمسة ذهبية
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- عنوان القائمة
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "One Shot | PC Elite"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- زر التصغير / الإخفاء (-)
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -35, 0, 3)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeButton

-- حاوية الأزرار الداخلية لسهولة الإخفاء عند التصغير
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, 0, 1, -40)
ContentContainer.Position = UDim2.new(0, 0, 0, 40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- زر ESP
local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(0.9, 0, 0, 45)
ESPButton.Position = UDim2.new(0.05, 0, 0.05, 0)
ESPButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ESPButton.Text = "ESP Boxes: OFF"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.TextSize = 13
ESPButton.Font = Enum.Font.SourceSansBold
ESPButton.Parent = ContentContainer

local ESPCorner = Instance.new("UICorner")
ESPCorner.CornerRadius = UDim.new(0, 6)
ESPCorner.Parent = ESPButton

-- زر Aimbot
local AimbotButton = Instance.new("TextButton")
AimbotButton.Size = UDim2.new(0.9, 0, 0, 45)
AimbotButton.Position = UDim2.new(0.05, 0, 0.4, 0)
AimbotButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
AimbotButton.Text = "Aimbot (Hold RightClick): OFF"
AimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotButton.TextSize = 12
AimbotButton.Font = Enum.Font.SourceSansBold
AimbotButton.Parent = ContentContainer

local AimbotCorner = Instance.new("UICorner")
AimbotCorner.CornerRadius = UDim.new(0, 6)
AimbotCorner.Parent = AimbotButton

-- تلميح تحكم
local HintText = Instance.new("TextLabel")
HintText.Size = UDim2.new(0.9, 0, 0, 30)
HintText.Position = UDim2.new(0.05, 0, 0.78, 0)
HintText.BackgroundTransparency = 1
HintText.Text = "Hide/Show Menu: [RightShift]"
HintText.TextColor3 = Color3.fromRGB(150, 150, 150)
HintText.TextSize = 11
HintText.Font = Enum.Font.SourceSansItalic
HintText.Parent = ContentContainer

-- المتغيرات والحالات
local ESPEnabled = false
local AimbotEnabled = false
local isMinimized = false
local drawings = {}

-- وظيفة زر التصغير/الإخفاء
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 220, 0, 40)
        ContentContainer.Visible = false
        MinimizeButton.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 220, 0, 210)
        ContentContainer.Visible = true
        MinimizeButton.Text = "-"
    end
end)

-- إخفاء/إظهار القائمة بكبسة زر RightShift من الكيبورد
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- تفعيل / تعطيل ESP
ESPButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        ESPButton.Text = "ESP Boxes: ON"
        ESPButton.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
    else
        ESPButton.Text = "ESP Boxes: OFF"
        ESPButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        -- مسح الرسومات عند الإيقاف
        for _, box in pairs(drawings) do
            if box then box:Remove() end
        end
        drawings = {}
    end
end)

-- تفعيل / تعطيل Aimbot
AimbotButton.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    if AimbotEnabled then
        AimbotButton.Text = "Aimbot: ON"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
    else
        AimbotButton.Text = "Aimbot: OFF"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end
end)

-- إنشاء مربعات الـ Drawing ESP للاعبين
local function createESP(player)
    if drawings[player] then return end
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 1.5
    box.Filled = false
    drawings[player] = box
end

local function removeESP(player)
    if drawings[player] then
        drawings[player]:Remove()
        drawings[player] = nil
    end
end

Players.PlayerRemoving:Connect(removeESP)

-- البحث عن أقرب هدف للـ Aimbot
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mouse = LocalPlayer:GetMouse()
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - centerScreen).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- حلقة التحديث المستمرة (RenderStepped)
RunService.RenderStepped:Connect(function()
    -- تحديث الـ ESP
    if ESPEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    if not drawings[player] then
                        createESP(player)
                    end
                    local box = drawings[player]
                    local rootPart = char.HumanoidRootPart
                    
                    local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                    if onScreen then
                        local size = Factor or (Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 3, 0)).Y)
                        local h = math.abs(size)
                        local w = h / 2
                        
                        box.Size = Vector2.new(w, h)
                        box.Position = Vector2.new(pos.X - w / 2, pos.Y - h / 2)
                        box.Visible = true
                    else
                        box.Visible = false
                    end
                else
                    if drawings[player] then
                        drawings[player].Visible = false
                    end
                end
            end
        end
    else
        for _, box in pairs(drawings) do
            box.Visible = false
        end
    end

    -- تحديث الـ Aimbot (يعمل عند تفعيله وضغط زر الماوس الأيمن)
    if AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
        end
    end
end)
