-- ===== CRYOXHUB LOADER =====
local LOADING_TIME = 15

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- ══════════════════════════════════════════
--   BƯỚC 1: TẠO LOADER TRONG COREGUI
--   (CoreGui đè lên TẤT CẢ kể cả script GUI)
-- ══════════════════════════════════════════
local sg = Instance.new("ScreenGui")
sg.Name = "CryoX_Loading"
sg.DisplayOrder = 2147483647
sg.IgnoreGuiInset = true
sg.ResetOnSpawn = false
sg.Parent = CoreGui

-- Backdrop đen che toàn màn hình
local Backdrop = Instance.new("Frame")
Backdrop.Size = UDim2.new(1,0,1,0)
Backdrop.Position = UDim2.new(0,0,0,0)
Backdrop.BackgroundColor3 = Color3.fromRGB(4,8,18)
Backdrop.BorderSizePixel = 0
Backdrop.ZIndex = 1
Backdrop.Parent = sg

-- Glow orb
local Orb = Instance.new("ImageLabel")
Orb.Size = UDim2.new(0,700,0,700)
Orb.Position = UDim2.new(0.5,-350,0.5,-350)
Orb.BackgroundTransparency = 1
Orb.Image = "rbxassetid://5028857084"
Orb.ImageColor3 = Color3.fromRGB(0,210,255)
Orb.ImageTransparency = 0.78
Orb.ZIndex = 2
Orb.Parent = Backdrop

-- Panel chính
local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0,480,0,300)
Panel.Position = UDim2.new(0.5,-240,0.6,-150)
Panel.BackgroundColor3 = Color3.fromRGB(8,16,32)
Panel.BackgroundTransparency = 1
Panel.BorderSizePixel = 0
Panel.ZIndex = 3
Panel.Parent = sg
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0,12)

local Stroke = Instance.new("UIStroke", Panel)
Stroke.Color = Color3.fromRGB(0,180,220)
Stroke.Thickness = 1.5
Stroke.Transparency = 1

-- Top accent bar
local TopBar = Instance.new("Frame", Panel)
TopBar.Size = UDim2.new(1,0,0,3)
TopBar.BackgroundColor3 = Color3.fromRGB(0,210,255)
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 4
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0,12)

-- Icon tuyết
local Icon = Instance.new("TextLabel", Panel)
Icon.Size = UDim2.new(0,60,0,60)
Icon.Position = UDim2.new(0.5,-30,0,24)
Icon.BackgroundTransparency = 1
Icon.Text = "❄"
Icon.TextColor3 = Color3.fromRGB(0,210,255)
Icon.TextSize = 42
Icon.Font = Enum.Font.GothamBold
Icon.TextTransparency = 1
Icon.ZIndex = 4

-- Tên script
local Title = Instance.new("TextLabel", Panel)
Title.Size = UDim2.new(1,-40,0,36)
Title.Position = UDim2.new(0,20,0,88)
Title.BackgroundTransparency = 1
Title.Text = "CryoXHUB"
Title.TextColor3 = Color3.fromRGB(220,240,255)
Title.TextSize = 28
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.TextTransparency = 1
Title.ZIndex = 4

-- Version badge
local Badge = Instance.new("Frame", Panel)
Badge.Size = UDim2.new(0,52,0,20)
Badge.Position = UDim2.new(0.5,-26,0,128)
Badge.BackgroundColor3 = Color3.fromRGB(0,210,255)
Badge.BackgroundTransparency = 1
Badge.BorderSizePixel = 0
Badge.ZIndex = 4
Instance.new("UICorner", Badge).CornerRadius = UDim.new(0,4)

local VerLabel = Instance.new("TextLabel", Badge)
VerLabel.Size = UDim2.new(1,0,1,0)
VerLabel.BackgroundTransparency = 1
VerLabel.Text = "v2.0"
VerLabel.TextColor3 = Color3.fromRGB(4,8,18)
VerLabel.TextSize = 11
VerLabel.Font = Enum.Font.GothamBold
VerLabel.TextTransparency = 1
VerLabel.ZIndex = 5

-- Divider
local Div = Instance.new("Frame", Panel)
Div.Size = UDim2.new(0,400,0,1)
Div.Position = UDim2.new(0.5,-200,0,162)
Div.BackgroundColor3 = Color3.fromRGB(0,180,220)
Div.BackgroundTransparency = 0.6
Div.BorderSizePixel = 0
Div.ZIndex = 4

-- Status text
local Status = Instance.new("TextLabel", Panel)
Status.Size = UDim2.new(1,-80,0,20)
Status.Position = UDim2.new(0,30,0,174)
Status.BackgroundTransparency = 1
Status.Text = "Starting..."
Status.TextColor3 = Color3.fromRGB(100,160,200)
Status.TextSize = 12
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.TextTransparency = 1
Status.ZIndex = 4

-- Phần trăm
local Pct = Instance.new("TextLabel", Panel)
Pct.Size = UDim2.new(0,60,0,20)
Pct.Position = UDim2.new(1,-76,0,174)
Pct.BackgroundTransparency = 1
Pct.Text = "0%"
Pct.TextColor3 = Color3.fromRGB(0,210,255)
Pct.TextSize = 12
Pct.Font = Enum.Font.GothamBold
Pct.TextXAlignment = Enum.TextXAlignment.Right
Pct.TextTransparency = 1
Pct.ZIndex = 4

-- Progress track
local Track = Instance.new("Frame", Panel)
Track.Size = UDim2.new(0,420,0,6)
Track.Position = UDim2.new(0.5,-210,0,202)
Track.BackgroundColor3 = Color3.fromRGB(15,30,55)
Track.BorderSizePixel = 0
Track.ZIndex = 4
Instance.new("UICorner", Track).CornerRadius = UDim.new(1,0)

-- Progress fill
local Fill = Instance.new("Frame", Track)
Fill.Size = UDim2.new(0,0,1,0)
Fill.BackgroundColor3 = Color3.fromRGB(0,210,255)
Fill.BorderSizePixel = 0
Fill.ZIndex = 5
Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)

-- Bar glow
local BarGlow = Instance.new("ImageLabel", Fill)
BarGlow.Size = UDim2.new(1,20,4,0)
BarGlow.Position = UDim2.new(0,-10,-1.5,0)
BarGlow.BackgroundTransparency = 1
BarGlow.Image = "rbxassetid://5028857084"
BarGlow.ImageColor3 = Color3.fromRGB(0,210,255)
BarGlow.ImageTransparency = 0.6
BarGlow.ZIndex = 5

-- Footer
local Footer = Instance.new("TextLabel", Panel)
Footer.Size = UDim2.new(1,-40,0,20)
Footer.Position = UDim2.new(0,20,1,-28)
Footer.BackgroundTransparency = 1
Footer.Text = "Please wait while CryoXHUB loads..."
Footer.TextColor3 = Color3.fromRGB(50,90,130)
Footer.TextSize = 11
Footer.Font = Enum.Font.Gotham
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.TextTransparency = 1
Footer.ZIndex = 4

-- ══════════════════════════════════════════
--   BƯỚC 2: CHẠY MAIN SCRIPT SONG SONG
-- ══════════════════════════════════════════
task.spawn(function()
    local ok, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/CryoXHUB.lua"))()
    end)
    if not ok then
        warn("[CryoXHUB] Error: " .. tostring(err))
    end
end)

-- ══════════════════════════════════════════
--   ENTRY ANIMATION
-- ══════════════════════════════════════════
local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj, TweenInfo.new(
        t,
        style or Enum.EasingStyle.Quart,
        dir   or Enum.EasingDirection.Out
    ), props):Play()
end

task.wait(0.1)
Tween(Panel,    { Position = UDim2.new(0.5,-240,0.5,-150), BackgroundTransparency = 0 }, 0.6)
task.wait(0.25)
Tween(Stroke,   { Transparency = 0.3 }, 0.4)
Tween(Icon,     { TextTransparency = 0 }, 0.5)
task.wait(0.2)
Tween(Title,    { TextTransparency = 0 }, 0.4)
Tween(Badge,    { BackgroundTransparency = 0 }, 0.3)
Tween(VerLabel, { TextTransparency = 0 }, 0.3)
task.wait(0.2)
Tween(Status,   { TextTransparency = 0 }, 0.3)
Tween(Pct,      { TextTransparency = 0 }, 0.3)
Tween(Footer,   { TextTransparency = 0 }, 0.3)

-- Icon pulse
task.spawn(function()
    while sg.Parent do
        Tween(Icon, { TextTransparency = 0.5 }, 0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(0.9)
        Tween(Icon, { TextTransparency = 0 }, 0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(0.9)
    end
end)

-- ══════════════════════════════════════════
--   PROGRESS BAR 15 GIÂY
-- ══════════════════════════════════════════
local Steps = {
    "Initializing core modules...",
    "Loading UI components...",
    "Connecting to services...",
    "Fetching configuration...",
    "Applying patches...",
    "Optimizing performance...",
    "Finalizing environment...",
    "Almost there...",
    "Ready.",
}

task.spawn(function()
    local stepCount = #Steps
    local interval  = LOADING_TIME / stepCount

    for i, text in ipairs(Steps) do
        local pct     = i / stepCount
        local prevPct = (i - 1) / stepCount
        Status.Text   = text
        Tween(Fill, { Size = UDim2.new(pct,0,1,0) }, interval * 0.9, Enum.EasingStyle.Quart)

        local startN = math.floor(prevPct * 100)
        local endN   = math.floor(pct * 100)
        local t0     = tick()
        local dur    = interval * 0.9
        task.spawn(function()
            while true do
                local frac = math.min((tick() - t0) / dur, 1)
                Pct.Text   = math.floor(startN + (endN - startN) * frac) .. "%"
                if frac >= 1 then break end
                task.wait()
            end
        end)

        task.wait(interval)
    end

    Status.Text       = "✓  Loaded successfully"
    Status.TextColor3 = Color3.fromRGB(0,210,255)
    Pct.Text          = "100%"
    task.wait(0.6)

    -- Fade out tất cả cùng lúc
    for _, obj in ipairs({ Title, Status, Pct, Footer, Icon, VerLabel }) do
        Tween(obj, { TextTransparency = 1 }, 0.5)
    end
    Tween(Badge,    { BackgroundTransparency = 1 }, 0.5)
    Tween(Track,    { BackgroundTransparency = 1 }, 0.5)
    Tween(Fill,     { BackgroundTransparency = 1 }, 0.5)
    Tween(Orb,      { ImageTransparency = 1 },      0.5)
    Tween(Stroke,   { Transparency = 1 },           0.5)
    Tween(Panel,    { BackgroundTransparency = 1 }, 0.5)
    Tween(Backdrop, { BackgroundTransparency = 1 }, 0.5)

    task.wait(0.55)
    sg:Destroy()
end)
