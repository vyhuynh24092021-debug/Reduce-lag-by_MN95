local Players = game:GetService("Players")
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

StarterGui:SetCore("SendNotification", {
    Title = "ANTI LAG BUT LAG",
    Text = "Reduce lag by MN95 đã được bật (VỹMN95)",
    Duration = 10
})
Remove_Grass = true
Remove_Trees = true
Remove_Walls = true

pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/louismich4el/ItsLouisPlayz-Scripts/refs/heads/main/Anti%20Lag%20V2.lua"))()
end)

local playerGui = player:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("MN95_GUI") then
    playerGui.MN95_GUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "MN95_GUI"
gui.Parent = playerGui

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0, 220, 0, 20)
textLabel.Position = UDim2.new(0, 5, 0, 5)
textLabel.BackgroundTransparency = 1
textLabel.TextScaled = false
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextSize = 14
textLabel.Text = "MN95 ANTI LAG | FPS: 0 | PING: 0"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.Parent = gui

local function rainbowColor(hue)
	return Color3.fromHSV(hue, 1, 1)
end

spawn(function()
	local fps = 0
	local frames = 0
	local lastTime = tick()

	RunService.RenderStepped:Connect(function()
		frames += 1
		local now = tick()
		if now - lastTime >= 1 then
			fps = frames
			frames = 0
			lastTime = now
		end
	end)

	spawn(function()
		local hue = 0
		while task.wait(0.3) do
			hue = (hue + 0.02) % 1
			textLabel.TextColor3 = rainbowColor(hue)

			local success, ping = pcall(function()
				return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
			end)
			if not success then ping = 0 end

			textLabel.Text = "MN95 ANTI LAG | FPS: " .. fps .. " | PING: " .. math.floor(ping) .. "ms"
		end
	end)
end)

pcall(function()
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

Lighting.GlobalShadows = false
Lighting.FogStart = 0
Lighting.FogEnd = 1e6
Lighting.Brightness = 1.5
Lighting.ClockTime = 14
Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
Lighting.Technology = Enum.Technology.Compatibility
Lighting.ShadowSoftness = 0

for _, effect in pairs(Lighting:GetChildren()) do
    if effect:IsA("BloomEffect") or effect:IsA("ColorCorrectionEffect")
    or effect:IsA("SunRaysEffect") or effect:IsA("BlurEffect")
    or effect:IsA("DepthOfFieldEffect") then
        pcall(function() effect:Destroy() end)
    end
end

for _, obj in ipairs(Workspace:GetDescendants()) do
    local skip = false
    local ancestor = obj
    while ancestor do
        if ancestor:IsA("Model") and Players:GetPlayerFromCharacter(ancestor) then
            skip = true
            break
        end
        ancestor = ancestor.Parent
    end
    if not skip then
        if obj:IsA("BasePart") then
            pcall(function()
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                obj.CastShadow = false
                if obj:IsA("MeshPart") then
                    obj.TextureID = ""
                end
            end)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function() obj:Destroy() end)
        end
    end
end

local EFFECT_CLASSES = {
    ParticleEmitter = true,
    Trail = true,
    Smoke = true,
    Fire = true,
    Beam = true,
    Sparkles = true,
    Highlight = true,
    SelectionBox = true,
    SurfaceGui = true,
    BillboardGui = true,
    PointLight = true,
    SpotLight = true,
    SurfaceLight = true,
    Explosion = true,
    ProximityPrompt = true,
}

local function tryRemove(obj)
    if EFFECT_CLASSES[obj.ClassName] then
        pcall(function() obj:Destroy() end)
    end
end

for _, obj in ipairs(Workspace:GetDescendants()) do
    tryRemove(obj)
end

Workspace.DescendantAdded:Connect(tryRemove)
