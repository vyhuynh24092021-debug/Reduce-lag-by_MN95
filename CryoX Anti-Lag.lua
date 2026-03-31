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

-- =========================
-- 📊 MN95 FPS + PING (FIXED)
-- =========================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")

-- Xóa GUI cũ nếu có
pcall(function()
    if CoreGui:FindFirstChild("MN95_GUI") then
        CoreGui.MN95_GUI:Destroy()
    end
end)

-- Tạo GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MN95_GUI"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0, 220, 0, 20)
textLabel.Position = UDim2.new(0, 5, 0, 5)
textLabel.BackgroundTransparency = 1
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextSize = 14
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.Text = "CryoXHUB | FPS: 0 | PING: 0"
textLabel.Parent = gui

-- Rainbow color
local function rainbowColor(hue)
	return Color3.fromHSV(hue, 1, 1)
end

-- FPS
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

-- Update text + ping + rainbow
task.spawn(function()
	local hue = 0
	while true do
		task.wait(0.3)

		hue = (hue + 0.02) % 1
		textLabel.TextColor3 = rainbowColor(hue)

		local ping = 0
		pcall(function()
			ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		end)

		textLabel.Text = "CryoXHUB | FPS: " .. fps .. " | PING: " .. math.floor(ping) .. "ms"
	end
end)

print(" Added: MN95 FPS + Ping UI")

-- =========================
--  NOTIFICATION
-- =========================
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "CryoX",
        Text = "anti-lag is on",
        Duration = 5
    })
end)
