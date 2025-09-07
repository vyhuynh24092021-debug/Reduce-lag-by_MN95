local Players = game:GetService("Players")
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Anti Lag V2",
    Text = " Reduce lag by MN95 đã Được bật (VỹMN95)",
    Duration = 10
})
Remove_Grass = true
Remove_Trees = true
Remove_Walls = true

loadstring(game:HttpGet("https://raw.githubusercontent.com/louismich4el/ItsLouisPlayz-Scripts/refs/heads/main/Anti%20Lag%20V2.lua"))()

local RunService   = game:GetService("RunService")
local Players      = game:GetService("Players")
local Lighting     = game:GetService("Lighting")
local Workspace    = game:GetService("Workspace")

local player = Players.LocalPlayer

local fpsGui = Instance.new("ScreenGui")
fpsGui.Name = "TSB_FPS_GUI"
fpsGui.ResetOnSpawn = false
fpsGui.IgnoreGuiInset = true
fpsGui.Parent = player:WaitForChild("PlayerGui")

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size              = UDim2.new(0, 80, 0, 20)
fpsLabel.Position          = UDim2.new(1, -90, 0, 10)
fpsLabel.BackgroundColor3  = Color3.fromRGB(0, 0, 0)
fpsLabel.BackgroundTransparency = 0.4
fpsLabel.TextColor3        = Color3.fromRGB(0, 0, 255)
fpsLabel.TextScaled        = true
fpsLabel.Font              = Enum.Font.Code
fpsLabel.Text              = "FPS: --"
fpsLabel.Parent            = fpsGui

do
    local lastTime = tick()
    local frameCt  = 0
    RunService.RenderStepped:Connect(function()
        frameCt += 1
        if tick() - lastTime >= 1 then
            fpsLabel.Text = "FPS: " .. frameCt

            if frameCt >= 50 then
                fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            elseif frameCt >= 30 then
                fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
            else
                fpsLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            end

            frameCt  = 0
            lastTime = tick()
        end
    end)
end

pcall(function()
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

Lighting.GlobalShadows  = false
Lighting.FogStart       = 0
Lighting.FogEnd         = 1e6
Lighting.Brightness     = 1.5
Lighting.ClockTime      = 14
Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
Lighting.Technology     = Enum.Technology.Compatibility
Lighting.ShadowSoftness = 0

for _, effect in pairs(Lighting:GetChildren()) do
	if effect:IsA("BloomEffect") or effect:IsA("ColorCorrectionEffect")
	or effect:IsA("SunRaysEffect") or effect:IsA("BlurEffect")
	or effect:IsA("DepthOfFieldEffect") then
		effect:Destroy()
	end
end
for _, obj in pairs(Workspace:GetDescendants()) do
    local skip = false
    local ancestor = obj
    while ancestor do
        if ancestor:IsA("Model") and Players:GetPlayerFromCharacter(ancestor) then
            skip = true
            break
        end
        ancestor = ancestor.Parent
    end
    if skip then continue end

	if obj:IsA("BasePart") then
		obj.Material    = Enum.Material.SmoothPlastic
		obj.Reflectance = 0
		obj.CastShadow  = false 
    	if obj:IsA("MeshPart") then
			obj.TextureID = ""
		end
	elseif obj:IsA("Decal") or obj:IsA("Texture") then
		obj:Destroy()
	elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail")
	or obj:IsA("Smoke") or obj:IsA("Fire")
	or obj:IsA("Beam") or obj:IsA("Sparkles")
	or obj:IsA("SelectionBox") or obj:IsA("Highlight")
	or obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
		obj:Destroy()
	end
end

print("REDUCE LAG BY MN95: FPS hiển thị, xóa bóng, fullbright, dọn hiệu ứng dư thừa (giữ nguyên Player).")
