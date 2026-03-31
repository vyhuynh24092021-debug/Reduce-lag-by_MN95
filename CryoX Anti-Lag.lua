-- =========================
-- ⚙️ SETTINGS
-- =========================
Remove_Grass = true
Remove_Trees = true
Remove_Walls = true

loadstring(game:HttpGet("https://raw.githubusercontent.com/louismich4el/ItsLouisPlayz-Scripts/refs/heads/main/Anti%20Lag%20V2.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/marianscriptKing/SUPER-MAX.lau/main/SUPER%20MAX%20PERFORMANCE"))()
-- 🔥 CryoX Rename UI (NO LAG - 1 block duy nhất)

task.delay(0.2, function()

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
