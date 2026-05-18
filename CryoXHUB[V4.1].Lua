-- ===== CRYOXHUB LOADER v3.1 MINI =====
local LOADING_TIME = 15

local TweenService = game:GetService("TweenService")
local CoreGui      = game:GetService("CoreGui")

local sg = Instance.new("ScreenGui")
sg.Name = "CryoX_Loading_Mini"
sg.DisplayOrder = 2147483647
sg.IgnoreGuiInset = true
sg.ResetOnSpawn = false
sg.Parent = CoreGui

local function Tween(obj, props, t, style, dir)
    local tw = TweenService:Create(
        obj,
        TweenInfo.new(
            t,
            style or Enum.EasingStyle.Quart,
            dir or Enum.EasingDirection.Out
        ),
        props
    )
    tw:Play()
    return tw
end

-- BACKGROUND
local Backdrop = Instance.new("Frame")
Backdrop.Size = UDim2.new(1,0,1,0)
Backdrop.BackgroundColor3 = Color3.fromRGB(3,6,16)
Backdrop.BorderSizePixel = 0
Backdrop.Parent = sg

local Grid = Instance.new("ImageLabel")
Grid.Size = UDim2.new(1,0,1,0)
Grid.BackgroundTransparency = 1
Grid.Image = "rbxassetid://3570695787"
Grid.ImageColor3 = Color3.fromRGB(0,180,255)
Grid.ImageTransparency = 0.97
Grid.ScaleType = Enum.ScaleType.Tile
Grid.TileSize = UDim2.new(0,64,0,64)
Grid.Parent = Backdrop

-- PANEL
local PW, PH = 340, 210

local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0,PW,0,PH)
Panel.Position = UDim2.new(0.5,-PW/2,0.5,-PH/2)
Panel.BackgroundColor3 = Color3.fromRGB(6,14,30)
Panel.BackgroundTransparency = 1
Panel.BorderSizePixel = 0
Panel.Parent = sg
Instance.new("UICorner",Panel).CornerRadius = UDim.new(0,12)

local Stroke = Instance.new("UIStroke")
Stroke.Parent = Panel
Stroke.Color = Color3.fromRGB(0,190,230)
Stroke.Thickness = 1.5
Stroke.Transparency = 1

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Parent = Panel
TopBar.Size = UDim2.new(1,0,0,2)
TopBar.BackgroundColor3 = Color3.fromRGB(0,210,255)
TopBar.BorderSizePixel = 0
Instance.new("UICorner",TopBar).CornerRadius = UDim.new(1,0)

-- ICON
local Icon = Instance.new("TextLabel")
Icon.Parent = Panel
Icon.Size = UDim2.new(0,44,0,44)
Icon.Position = UDim2.new(0.5,-22,0,10)
Icon.BackgroundTransparency = 1
Icon.Text = "❄"
Icon.TextColor3 = Color3.fromRGB(0,210,255)
Icon.TextSize = 30
Icon.Font = Enum.Font.GothamBold
Icon.TextTransparency = 1

-- TITLE
local Title = Instance.new("TextLabel")
Title.Parent = Panel
Title.Size = UDim2.new(1,-20,0,24)
Title.Position = UDim2.new(0,10,0,52)
Title.BackgroundTransparency = 1
Title.Text = "CryoXHUB"
Title.TextColor3 = Color3.fromRGB(210,235,255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextTransparency = 1

-- SUBTITLE
local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = Panel
Subtitle.Size = UDim2.new(1,-20,0,12)
Subtitle.Position = UDim2.new(0,10,0,74)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "ADVANCED PERFORMANCE SUITE"
Subtitle.TextColor3 = Color3.fromRGB(0,180,220)
Subtitle.TextSize = 7
Subtitle.Font = Enum.Font.GothamBold
Subtitle.TextTransparency = 1

-- STATUS
local Status = Instance.new("TextLabel")
Status.Parent = Panel
Status.Size = UDim2.new(1,-70,0,14)
Status.Position = UDim2.new(0,15,0,102)
Status.BackgroundTransparency = 1
Status.Text = "Starting..."
Status.TextColor3 = Color3.fromRGB(100,170,220)
Status.TextSize = 9
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.TextTransparency = 1

-- %
local Pct = Instance.new("TextLabel")
Pct.Parent = Panel
Pct.Size = UDim2.new(0,40,0,14)
Pct.Position = UDim2.new(1,-52,0,102)
Pct.BackgroundTransparency = 1
Pct.Text = "0%"
Pct.TextColor3 = Color3.fromRGB(0,220,255)
Pct.TextSize = 9
Pct.Font = Enum.Font.GothamBold
Pct.TextTransparency = 1

-- BAR
local Track = Instance.new("Frame")
Track.Parent = Panel
Track.Size = UDim2.new(0,300,0,6)
Track.Position = UDim2.new(0.5,-150,0,126)
Track.BackgroundColor3 = Color3.fromRGB(10,22,46)
Track.BorderSizePixel = 0
Track.ClipsDescendants = true
Instance.new("UICorner",Track).CornerRadius = UDim.new(1,0)

local Fill = Instance.new("Frame")
Fill.Parent = Track
Fill.Size = UDim2.new(0,0,1,0)
Fill.BackgroundColor3 = Color3.fromRGB(0,210,255)
Fill.BorderSizePixel = 0
Instance.new("UICorner",Fill).CornerRadius = UDim.new(1,0)

-- FOOTER
local Footer = Instance.new("TextLabel")
Footer.Parent = Panel
Footer.Size = UDim2.new(1,-20,0,12)
Footer.Position = UDim2.new(0,10,1,-22)
Footer.BackgroundTransparency = 1
Footer.Text = "CryoXHUB • Please wait..."
Footer.TextColor3 = Color3.fromRGB(45,80,120)
Footer.TextSize = 7
Footer.Font = Enum.Font.Gotham
Footer.TextTransparency = 1

-- SKIP BUTTON
local SkipBtn = Instance.new("TextButton")
SkipBtn.Parent = Panel
SkipBtn.Size = UDim2.new(0,70,0,20)
SkipBtn.Position = UDim2.new(0.5,-35,1,-48)
SkipBtn.BackgroundColor3 = Color3.fromRGB(8,22,42)
SkipBtn.BorderSizePixel = 0
SkipBtn.Text = "Skip"
SkipBtn.TextColor3 = Color3.fromRGB(0,200,245)
SkipBtn.TextSize = 9
SkipBtn.Font = Enum.Font.GothamBold
SkipBtn.TextTransparency = 1
SkipBtn.BackgroundTransparency = 1
Instance.new("UICorner",SkipBtn).CornerRadius = UDim.new(0,6)

local SkipStroke = Instance.new("UIStroke")
SkipStroke.Parent = SkipBtn
SkipStroke.Color = Color3.fromRGB(0,180,220)
SkipStroke.Thickness = 1
SkipStroke.Transparency = 1

-- LOAD SCRIPT
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/CryoXHUB.lua"
        ))()
    end)
end)

-- FADE IN
Tween(Panel,{BackgroundTransparency=0},0.45)
task.wait(0.1)

Tween(Stroke,{Transparency=0.35},0.3)
Tween(Icon,{TextTransparency=0},0.3)

task.wait(0.08)

Tween(Title,{TextTransparency=0},0.3)
Tween(Subtitle,{TextTransparency=0},0.3)

task.wait(0.08)

Tween(Status,{TextTransparency=0},0.3)
Tween(Pct,{TextTransparency=0},0.3)
Tween(Footer,{TextTransparency=0},0.3)

task.wait(0.08)

Tween(SkipBtn,{
    BackgroundTransparency=0,
    TextTransparency=0
},0.3)

Tween(SkipStroke,{
    Transparency=0.4
},0.3)

-- ICON PULSE
task.spawn(function()
    while sg.Parent do
        Tween(Icon,{TextSize=34},0.8,Enum.EasingStyle.Sine)
        task.wait(0.8)
        Tween(Icon,{TextSize=30},0.8,Enum.EasingStyle.Sine)
        task.wait(0.8)
    end
end)

-- HOVER
SkipBtn.MouseEnter:Connect(function()
    Tween(SkipBtn,{
        BackgroundColor3 = Color3.fromRGB(0,180,220),
        TextColor3 = Color3.fromRGB(3,6,16)
    },0.15)

    Tween(SkipStroke,{
        Transparency = 1
    },0.15)
end)

SkipBtn.MouseLeave:Connect(function()
    Tween(SkipBtn,{
        BackgroundColor3 = Color3.fromRGB(8,22,42),
        TextColor3 = Color3.fromRGB(0,200,245)
    },0.15)

    Tween(SkipStroke,{
        Transparency = 0.4
    },0.15)
end)

-- STEPS
local Steps = {
    "Initializing modules...",
    "Loading UI...",
    "Connecting services...",
    "Applying configs...",
    "Optimizing...",
    "Running diagnostics...",
    "Finalizing...",
    "Ready."
}

local fadeActive = false

local function FadeOut()
    if fadeActive then return end
    fadeActive = true

    Tween(Panel,{BackgroundTransparency=1},0.35)
    Tween(Stroke,{Transparency=1},0.35)

    for _,v in ipairs({
        Title,Subtitle,Status,Pct,Footer,Icon
    }) do
        Tween(v,{TextTransparency=1},0.3)
    end

    Tween(SkipBtn,{
        BackgroundTransparency=1,
        TextTransparency=1
    },0.3)

    Tween(Grid,{
        ImageTransparency=1
    },0.35)

    task.wait(0.4)

    Tween(Backdrop,{
        BackgroundTransparency=1
    },0.4)

    task.wait(0.45)

    sg:Destroy()
end

-- SKIP
SkipBtn.MouseButton1Click:Connect(function()
    FadeOut()
end)

-- LOADING
task.spawn(function()
    local total = #Steps
    local interval = LOADING_TIME / total

    for i,v in ipairs(Steps) do
        if fadeActive then return end

        Status.Text = v

        local pct = i / total

        Tween(
            Fill,
            {Size = UDim2.new(pct,0,1,0)},
            interval * 0.85
        )

        local start = math.floor(((i-1)/total)*100)
        local goal  = math.floor(pct*100)

        local t0 = tick()

        while tick()-t0 < interval*0.85 do
            local frac = (tick()-t0)/(interval*0.85)
            Pct.Text = math.floor(start + (goal-start)*frac).."%"
            task.wait()
        end

        Pct.Text = goal.."%"

        task.wait(interval)
    end

    Status.Text = "Loaded successfully"
    Pct.Text = "100%"

    task.wait(1)

    FadeOut()
end)
