
-- Mobile ESP + Aim Assist
-- For NPC training targets in your own Roblox experience.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local targetFolder = workspace:WaitForChild("TrainingTargets")

local enabled = false
local highlights = {}

-- Create mobile interface
local gui = Instance.new("ScreenGui")
gui.Name = "MobileAimESP"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Name = "AimButton"
button.Size = UDim2.fromOffset(155, 48)
button.AnchorPoint = Vector2.new(1, 0.5)
button.Position = UDim2.new(1, -20, 0.7, 0)
button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "AIM ASSIST: OFF"
button.TextSize = 15
button.Font = Enum.Font.GothamBold
button.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = button

-- Toggle aim assist
button.Activated:Connect(function()
    enabled = not enabled

    button.Text = enabled
        and "AIM ASSIST: ON"
        or "AIM ASSIST: OFF"

    button.BackgroundColor3 = enabled
        and Color3.fromRGB(30, 130, 70)
        or Color3.fromRGB(45, 45, 45)
end)

-- Find NPC aiming part
local function getAimPart(model)
    if not model:IsA("Model") then
        return nil
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local part = model:FindFirstChild("Head")
        or model:FindFirstChild("HumanoidRootPart")

    if humanoid and humanoid.Health > 0
        and part and part:IsA("BasePart") then
        return part
    end

    return nil
end

-- ESP
local function addESP(model)
    if not model:IsA("Model") or highlights[model] then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "TrainingESP"
    highlight.Adornee = model
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(0, 255, 100)
    highlight.Parent = model

    highlights[model] = highlight
end

for _, model in ipairs(targetFolder:GetChildren()) do
    addESP(model)
end

targetFolder.ChildAdded:Connect(function(model)
    task.wait(0.2)
    addESP(model)
end)

targetFolder.ChildRemoved:Connect(function(model)
    if highlights[model] then
        highlights[model]:Destroy()
        highlights[model] = nil
    end
end)

-- Check visibility
local function isVisible(camera, model, part)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    params.FilterDescendantsInstances = {
        player.Character,
        model
    }

    local origin = camera.CFrame.Position
    local direction = part.Position - origin

    return workspace:Raycast(origin, direction, params) == nil
end

-- Find closest target to screen center
local function getBestTarget(camera)
    local center = camera.ViewportSize / 2

    local bestTarget = nil
    local bestScore = 170

    for _, model in ipairs(targetFolder:GetChildren()) do
        local part = getAimPart(model)

        if part then
            local screenPosition, onScreen =
                camera:WorldToViewportPoint(part.Position)

            if onScreen then
                local screenPoint = Vector2.new(
                    screenPosition.X,
                    screenPosition.Y
                )

                local distance = (screenPoint - center).Magnitude

                if distance < bestScore
                    and isVisible(camera, model, part) then

                    bestScore = distance
                    bestTarget = part
                end
            end
        end
    end

    return bestTarget
end

-- Smooth camera aim assist
RunService:BindToRenderStep(
    "TrainingAimAssist",
    Enum.RenderPriority.Camera.Value + 1,
    function(deltaTime)

        if not enabled then
            return
        end

        local camera = workspace.CurrentCamera

        if not camera then
            return
        end

        local target = getBestTarget(camera)

        if target then
            local desiredCFrame = CFrame.lookAt(
                camera.CFrame.Position,
                target.Position
            )

            local smoothness = math.clamp(deltaTime * 8, 0, 1)

            camera.CFrame = camera.CFrame:Lerp(
                desiredCFrame,
                smoothness
            )
        end
    end
)
