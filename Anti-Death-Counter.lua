-- "anti death counter" Button Script with Camera Fix and Notification for Delta Executor

-- Configuration
local teleportPosition = Vector3.new(240.31468200683594, -491.9150390625, -183.96755981445312)
local platformSize = Vector3.new(10, 1, 10)
local loopDuration = 5 -- Seconds to loop teleport
local teleportInterval = 0.05 -- Time between teleports (faster than 0.1 seconds)

-- Variables
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera
local savedPosition = nil
local looping = false

-- Function to create a platform
local function createPlatform(position)
    local platform = Instance.new("Part")
    platform.Name = "TemporaryPlatform"
    platform.Size = platformSize
    platform.Position = position
    platform.Anchored = true
    platform.Color = Color3.new(1, 0, 0) -- Red platform
    platform.Parent = workspace
    return platform
end

-- Function to reset the camera
local function resetCamera()
    camera.CameraSubject = player.Character:WaitForChild("Humanoid")
    camera.CameraType = Enum.CameraType.Custom
end

-- Function to loop teleport
local function loopTeleport()
    if not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart
    looping = true
    local platform = createPlatform(teleportPosition + Vector3.new(0, -3, 0))

    local startTime = tick()
    while tick() - startTime < loopDuration and looping do
        rootPart.CFrame = CFrame.new(teleportPosition)
        wait(teleportInterval)
    end

    platform:Destroy()
    if savedPosition then
        rootPart.CFrame = savedPosition
    end
    looping = false

    resetCamera()
end

-- Create GUI Button
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "anti_death_counter"

local button = Instance.new("TextButton", screenGui)
button.Size = UDim2.new(0, 120, 0, 35) -- nhỏ hơn
button.Position = UDim2.new(0.5, -60, 0) 
button.BackgroundColor3 = Color3.new(0, 0, 0)
button.TextColor3 = Color3.new(0, 1, 0)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 16 -- nhỏ hơn
button.Text = "anti death"
button.AutoButtonColor = false
button.BorderSizePixel = 2

-- DRAG (di chuyển button)
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = button.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        button.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "Script Loaded";
    Text = "Made by Hecker";
    Duration = 5;
})

-- Button Click Event
button.MouseButton1Click:Connect(function()
    if looping then return end
    if character:FindFirstChild("HumanoidRootPart") then
        savedPosition = character.HumanoidRootPart.CFrame
        loopTeleport()
    end
end)
