local Players = game:GetService("Players")
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Anti Lag V2",
    Text = "✅ Reduce lag by MN95 đã đc bật [Vỹ(MN95)+ChatGPT]",
    Duration = 10 -- hiện trong 10 giây
})
-- 🌟 MN95 + ChatGPT Anti Lag V2 + FPS/Ping UI
Remove_Grass = true
Remove_Trees = true
Remove_Walls = true

-- chạy script Anti Lag V2 gốc
loadstring(game:HttpGet("https://raw.githubusercontent.com/louismich4el/ItsLouisPlayz-Scripts/refs/heads/main/Anti%20Lag%20V2.lua"))()

-- ================== UI HIỂN THỊ FPS + PING ==================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local fpsGui = Instance.new("ScreenGui")
fpsGui.Name = "AntiLagUI"
fpsGui.ResetOnSpawn = false
fpsGui.IgnoreGuiInset = true
fpsGui.Parent = player:WaitForChild("PlayerGui")

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0, 150, 0, 35) -- chữ rõ hơn
infoLabel.Position = UDim2.new(1, -160, 0, 10) -- góc phải trên
infoLabel.BackgroundTransparency = 0.5
infoLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
infoLabel.TextColor3 = Color3.new(1,1,1)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.SourceSansBold
infoLabel.Text = "FPS: -- | Ping: --"
infoLabel.Active = true -- cho phép drag
infoLabel.Draggable = true -- kéo thả
infoLabel.Parent = fpsGui

-- rainbow color update
task.spawn(function()
    local t = 0
    while task.wait(0.05) do
        t = t + 0.05
        infoLabel.TextColor3 = Color3.fromHSV((t/5) % 1, 1, 1)
    end
end)

-- update FPS/Ping
local lastTime, frames = tick(), 0
RunService.RenderStepped:Connect(function()
    frames += 1
    if tick() - lastTime >= 1 then
        local fps = frames
        local ping = math.floor(Players.LocalPlayer:GetNetworkPing() * 1000)
        infoLabel.Text = "FPS: " .. fps .. " | Ping: " .. ping .. "ms"
        frames = 0
        lastTime = tick()
    end
end)

-- ================== CLEAR HIỆU ỨNG 5 PHÚT ==================

local Lighting = game:GetService("Lighting")

local function clearEffects()
    -- giữ nguyên cách clear như script cũ
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("BloomEffect") or effect:IsA("ColorCorrectionEffect")
        or effect:IsA("SunRaysEffect") or effect:IsA("BlurEffect")
        or effect:IsA("DepthOfFieldEffect") then
            effect:Destroy()
        end
    end

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail")
        or obj:IsA("Smoke") or obj:IsA("Fire")
        or obj:IsA("Beam") or obj:IsA("Sparkles") then
            obj:Destroy()
        end
    end

    print("✅ Cleared lag at " .. os.date("%X"))
end

-- clear mỗi 5 phút
task.spawn(function()
    while task.wait(300) do
        clearEffects()
    end
end)

-- chạy 1 lần lúc đầu
clearEffects()
