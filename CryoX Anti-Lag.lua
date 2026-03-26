-- =========================
-- ⚙️ SETTINGS
-- =========================
Remove_Grass = true
Remove_Trees = true
Remove_Walls = true

loadstring(game:HttpGet("https://raw.githubusercontent.com/louismich4el/ItsLouisPlayz-Scripts/refs/heads/main/Anti%20Lag%20V2.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/marianscriptKing/SUPER-MAX.lau/main/SUPER%20MAX%20PERFORMANCE"))()
-- 🔥 CryoX Rename UI (NO LAG - 1 block duy nhất)

task.delay(1, function()

    local function rename(v)
        if v:IsA("TextLabel") then
            
            if v.Text:find("Cleaner") then
                v.Text = "CryoX Cleaner"
            end
            
            if v.Text:find("Marian") then
                v.Text = "by MN95"
            end

            if v.Text:find("MAX PERFORMANCE") then
                v.Text = "CRYOX BOOST"
            end
        end
    end
    for _, v in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
        rename(v)
    end
    game.Players.LocalPlayer.PlayerGui.DescendantAdded:Connect(function(v)
        rename(v)
    end)

end)

-- =========================
-- 🧹 XÓA TEXTURE (TRỪ PLAYER)
-- =========================
-- 🔥 FLAT COLOR MODE (all white/gray except player)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- 🎨 màu cho từng loại
local COLORS = {
    Default = Color3.fromRGB(200,200,200), -- xám
    Ground = Color3.fromRGB(255,255,255),  -- trắng
    Dark = Color3.fromRGB(150,150,150)     -- xám đậm
}

-- check có phải player không
local function isPlayerCharacter(obj)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and obj:IsDescendantOf(plr.Character) then
            return true
        end
    end
    return false
end

-- xử lý object
local function flatColor(obj)
    if isPlayerCharacter(obj) then return end

    -- XÓA texture thật
    if obj:IsA("Decal") or obj:IsA("Texture") then
        obj:Destroy()
    end

    if obj:IsA("SurfaceAppearance") then
        obj:Destroy()
    end

    if obj:IsA("MeshPart") then
        obj.TextureID = ""
    end

    if obj:IsA("SpecialMesh") then
        obj.TextureId = ""
    end

    -- ĐỔI màu + material
    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.Plastic
        obj.Reflectance = 0

        -- phân loại đơn giản
        if obj.Name:lower():find("ground") or obj.Position.Y < 5 then
            obj.Color = COLORS.Ground
        elseif obj.Size.Magnitude > 50 then
            obj.Color = COLORS.Dark
        else
            obj.Color = COLORS.Default
        end
    end
end

-- 🔥 delay để đợi map load
task.delay(3, function()
    for _, v in pairs(Workspace:GetDescendants()) do
        flatColor(v)
    end
end)

-- 🔥 xử lý object spawn mới
Workspace.DescendantAdded:Connect(function(v)
    flatColor(v)
end)

print("Flat Color Mode On")

-- =========================
-- 📊 FPS + PING (GÓC TRÁI DƯỚI LOGO)
-- =========================
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "FPS_PING_UI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 180, 0, 40)
label.Position = UDim2.new(0, 10, 0, 36) -- dưới logo Roblox
label.BackgroundTransparency = 0.3
label.BackgroundColor3 = Color3.new(0,0,0)
label.TextColor3 = Color3.new(1,1,1)
label.TextScaled = true
label.Font = Enum.Font.SourceSansBold
label.Parent = gui

-- FPS
local fps = 0
RunService.RenderStepped:Connect(function(dt)
    fps = math.floor(1/dt)
end)

-- Update ping + fps
task.spawn(function()
    while true do
        task.wait(1)

        local ping = 0
        pcall(function()
            ping = StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)

        label.Text = "FPS: "..fps.." | Ping: "..math.floor(ping).." ms"
    end
end)

print("✅ Added: FPS + Ping UI & Removed textures (except player)")
-- =========================
-- 🔔 NOTIFICATION
-- =========================
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "CryoX",
        Text = "anti-lag is on",
        Duration = 5
    })
end)
