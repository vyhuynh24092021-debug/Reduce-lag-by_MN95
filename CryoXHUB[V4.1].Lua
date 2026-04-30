-- ===== CRYOXHUB LOADER v3.0 =====
local LOADING_TIME = 15

local TweenService    = game:GetService("TweenService")
local CoreGui         = game:GetService("CoreGui")
local RunService      = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ══════════════════════════════════════════
--   SCREEN GUI
-- ══════════════════════════════════════════
local sg = Instance.new("ScreenGui")
sg.Name = "CryoX_Loading"
sg.DisplayOrder = 2147483647
sg.IgnoreGuiInset = true
sg.ResetOnSpawn = false
sg.Parent = CoreGui

local function Tween(obj, props, t, style, dir)
    local ti = TweenInfo.new(t, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, ti, props)
    tw:Play()
    return tw
end

-- ══════════════════════════════════════════
--   BACKDROP
-- ══════════════════════════════════════════
local Backdrop = Instance.new("Frame")
Backdrop.Size = UDim2.new(1,0,1,0)
Backdrop.BackgroundColor3 = Color3.fromRGB(3,6,16)
Backdrop.BorderSizePixel = 0
Backdrop.ZIndex = 1
Backdrop.Parent = sg

-- Grid overlay (scanlines feel)
local Grid = Instance.new("ImageLabel")
Grid.Size = UDim2.new(1,0,1,0)
Grid.BackgroundTransparency = 1
Grid.Image = "rbxassetid://3570695787"
Grid.ImageColor3 = Color3.fromRGB(0,180,255)
Grid.ImageTransparency = 0.96
Grid.ScaleType = Enum.ScaleType.Tile
Grid.TileSize = UDim2.new(0,64,0,64)
Grid.ZIndex = 2
Grid.Parent = Backdrop

-- ══════════════════════════════════════════
--   PARTICLES (floating dots)
-- ══════════════════════════════════════════
local ParticleHolder = Instance.new("Frame")
ParticleHolder.Size = UDim2.new(1,0,1,0)
ParticleHolder.BackgroundTransparency = 1
ParticleHolder.ZIndex = 2
ParticleHolder.ClipsDescendants = true
ParticleHolder.Parent = Backdrop

local particles = {}
for i = 1, 18 do
    local p = Instance.new("Frame")
    local sz = math.random(2, 5)
    p.Size = UDim2.new(0, sz, 0, sz)
    p.Position = UDim2.new(math.random(), 0, math.random(), 0)
    p.BackgroundColor3 = Color3.fromRGB(0, math.random(160,255), 255)
    p.BackgroundTransparency = math.random(40,75)/100
    p.BorderSizePixel = 0
    p.ZIndex = 3
    Instance.new("UICorner", p).CornerRadius = UDim.new(1,0)
    p.Parent = ParticleHolder
    particles[i] = { frame = p, speed = math.random(15,40)/1000, drift = (math.random()-0.5)*0.0003 }
end

-- ══════════════════════════════════════════
--   AMBIENT ORBS
-- ══════════════════════════════════════════
local function makeOrb(x, y, size, color, trans)
    local o = Instance.new("ImageLabel")
    o.Size = UDim2.new(0,size,0,size)
    o.Position = UDim2.new(x,-size/2,y,-size/2)
    o.BackgroundTransparency = 1
    o.Image = "rbxassetid://5028857084"
    o.ImageColor3 = color
    o.ImageTransparency = trans
    o.ZIndex = 2
    o.Parent = Backdrop
    return o
end

local Orb1 = makeOrb(0.3, 0.4, 600, Color3.fromRGB(0,180,255), 0.82)
local Orb2 = makeOrb(0.75, 0.65, 450, Color3.fromRGB(0,80,200), 0.85)
local Orb3 = makeOrb(0.5, 0.5, 900, Color3.fromRGB(0,120,220), 0.91)

-- ══════════════════════════════════════════
--   MAIN PANEL
-- ══════════════════════════════════════════
local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0,500,0,340)
Panel.Position = UDim2.new(0.5,-250,0.65,-170)
Panel.BackgroundColor3 = Color3.fromRGB(6,14,30)
Panel.BackgroundTransparency = 1
Panel.BorderSizePixel = 0
Panel.ZIndex = 5
Panel.Parent = sg
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0,16)

local PanelStroke = Instance.new("UIStroke", Panel)
PanelStroke.Color = Color3.fromRGB(0,190,230)
PanelStroke.Thickness = 1.5
PanelStroke.Transparency = 1

-- Inner glow on panel
local PanelGlow = Instance.new("ImageLabel", Panel)
PanelGlow.Size = UDim2.new(1,60,1,60)
PanelGlow.Position = UDim2.new(0,-30,0,-30)
PanelGlow.BackgroundTransparency = 1
PanelGlow.Image = "rbxassetid://5028857084"
PanelGlow.ImageColor3 = Color3.fromRGB(0,160,220)
PanelGlow.ImageTransparency = 0.88
PanelGlow.ZIndex = 4

-- ── Accent top bar ──
local TopBar = Instance.new("Frame", Panel)
TopBar.Size = UDim2.new(1,0,0,3)
TopBar.BackgroundColor3 = Color3.fromRGB(0,210,255)
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 6
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0,16)

-- Gradient on topbar
local TBGrad = Instance.new("UIGradient", TopBar)
TBGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,100,200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,220,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,100,200)),
})

-- ── Snowflake icon ──
local Icon = Instance.new("TextLabel", Panel)
Icon.Size = UDim2.new(0,64,0,64)
Icon.Position = UDim2.new(0.5,-32,0,22)
Icon.BackgroundTransparency = 1
Icon.Text = "❄"
Icon.TextColor3 = Color3.fromRGB(0,210,255)
Icon.TextSize = 46
Icon.Font = Enum.Font.GothamBold
Icon.TextTransparency = 1
Icon.ZIndex = 7

-- Icon shadow
local IconShadow = Instance.new("TextLabel", Panel)
IconShadow.Size = UDim2.new(0,64,0,64)
IconShadow.Position = UDim2.new(0.5,-30,0,24)
IconShadow.BackgroundTransparency = 1
IconShadow.Text = "❄"
IconShadow.TextColor3 = Color3.fromRGB(0,100,180)
IconShadow.TextSize = 46
IconShadow.Font = Enum.Font.GothamBold
IconShadow.TextTransparency = 0.7
IconShadow.ZIndex = 6

-- ── Title ──
local Title = Instance.new("TextLabel", Panel)
Title.Size = UDim2.new(1,-40,0,38)
Title.Position = UDim2.new(0,20,0,92)
Title.BackgroundTransparency = 1
Title.Text = "CryoXHUB"
Title.TextColor3 = Color3.fromRGB(210,235,255)
Title.TextSize = 30
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.TextTransparency = 1
Title.ZIndex = 7

-- ── Subtitle ──
local Subtitle = Instance.new("TextLabel", Panel)
Subtitle.Size = UDim2.new(1,-40,0,18)
Subtitle.Position = UDim2.new(0,20,0,130)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "ADVANCED PERFORMANCE SUITE"
Subtitle.TextColor3 = Color3.fromRGB(0,180,220)
Subtitle.TextSize = 10
Subtitle.Font = Enum.Font.GothamBold
Subtitle.TextXAlignment = Enum.TextXAlignment.Center
Subtitle.TextTransparency = 1
Subtitle.ZIndex = 7
Subtitle.TextScaled = false

-- ── Version badge ──
local Badge = Instance.new("Frame", Panel)
Badge.Size = UDim2.new(0,58,0,22)
Badge.Position = UDim2.new(0.5,-29,0,152)
Badge.BackgroundColor3 = Color3.fromRGB(0,200,255)
Badge.BackgroundTransparency = 1
Badge.BorderSizePixel = 0
Badge.ZIndex = 7
Instance.new("UICorner", Badge).CornerRadius = UDim.new(0,5)
local BadgeGrad = Instance.new("UIGradient", Badge)
BadgeGrad.Color = ColorSequence.new(Color3.fromRGB(0,140,220), Color3.fromRGB(0,220,255))
BadgeGrad.Rotation = 90

local VerLabel = Instance.new("TextLabel", Badge)
VerLabel.Size = UDim2.new(1,0,1,0)
VerLabel.BackgroundTransparency = 1
VerLabel.Text = "v 3.0"
VerLabel.TextColor3 = Color3.fromRGB(3,6,16)
VerLabel.TextSize = 11
VerLabel.Font = Enum.Font.GothamBold
VerLabel.TextTransparency = 1
VerLabel.ZIndex = 8

-- ── Divider ──
local Div = Instance.new("Frame", Panel)
Div.Size = UDim2.new(0,440,0,1)
Div.Position = UDim2.new(0.5,-220,0,186)
Div.BackgroundColor3 = Color3.fromRGB(0,190,230)
Div.BackgroundTransparency = 0.65
Div.BorderSizePixel = 0
Div.ZIndex = 6

-- ── Status ──
local Status = Instance.new("TextLabel", Panel)
Status.Size = UDim2.new(1,-100,0,20)
Status.Position = UDim2.new(0,20,0,197)
Status.BackgroundTransparency = 1
Status.Text = "Starting..."
Status.TextColor3 = Color3.fromRGB(90,150,200)
Status.TextSize = 12
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.TextTransparency = 1
Status.ZIndex = 7

-- ── Percentage ──
local Pct = Instance.new("TextLabel", Panel)
Pct.Size = UDim2.new(0,70,0,20)
Pct.Position = UDim2.new(1,-86,0,197)
Pct.BackgroundTransparency = 1
Pct.Text = "0%"
Pct.TextColor3 = Color3.fromRGB(0,220,255)
Pct.TextSize = 13
Pct.Font = Enum.Font.GothamBold
Pct.TextXAlignment = Enum.TextXAlignment.Right
Pct.TextTransparency = 1
Pct.ZIndex = 7

-- ── Progress track ──
local Track = Instance.new("Frame", Panel)
Track.Size = UDim2.new(0,440,0,8)
Track.Position = UDim2.new(0.5,-220,0,226)
Track.BackgroundColor3 = Color3.fromRGB(10,22,46)
Track.BorderSizePixel = 0
Track.ZIndex = 7
Instance.new("UICorner", Track).CornerRadius = UDim.new(1,0)

-- ── Progress fill ──
local Fill = Instance.new("Frame", Track)
Fill.Size = UDim2.new(0,0,1,0)
Fill.BackgroundColor3 = Color3.fromRGB(0,210,255)
Fill.BorderSizePixel = 0
Fill.ZIndex = 8
Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)
local FillGrad = Instance.new("UIGradient", Fill)
FillGrad.Color = ColorSequence.new(Color3.fromRGB(0,120,220), Color3.fromRGB(120,240,255))

-- ── Bar glow ──
local BarGlow = Instance.new("ImageLabel", Fill)
BarGlow.Size = UDim2.new(1,30,6,0)
BarGlow.Position = UDim2.new(0,-15,-2.5,0)
BarGlow.BackgroundTransparency = 1
BarGlow.Image = "rbxassetid://5028857084"
BarGlow.ImageColor3 = Color3.fromRGB(0,210,255)
BarGlow.ImageTransparency = 0.5
BarGlow.ZIndex = 8

-- ── Segment tick marks on track ──
for i = 1, 8 do
    local tick_ = Instance.new("Frame", Track)
    tick_.Size = UDim2.new(0,1,1,-2)
    tick_.Position = UDim2.new(i/9,0,0,1)
    tick_.BackgroundColor3 = Color3.fromRGB(0,120,180)
    tick_.BackgroundTransparency = 0.5
    tick_.BorderSizePixel = 0
    tick_.ZIndex = 9
end

-- ── Step dots ──
local DotHolder = Instance.new("Frame", Panel)
DotHolder.Size = UDim2.new(0,180,0,12)
DotHolder.Position = UDim2.new(0.5,-90,0,244)
DotHolder.BackgroundTransparency = 1
DotHolder.ZIndex = 7

local stepDots = {}
for i = 1, 9 do
    local d = Instance.new("Frame", DotHolder)
    d.Size = UDim2.new(0,8,0,8)
    d.Position = UDim2.new((i-1)/9 + 0.03, 0, 0.5, -4)
    d.BackgroundColor3 = Color3.fromRGB(20,45,80)
    d.BorderSizePixel = 0
    d.ZIndex = 8
    Instance.new("UICorner", d).CornerRadius = UDim.new(1,0)
    stepDots[i] = d
end

-- ── Info row (game name + time) ──
local InfoLeft = Instance.new("TextLabel", Panel)
InfoLeft.Size = UDim2.new(0.5,-10,0,18)
InfoLeft.Position = UDim2.new(0,20,0,270)
InfoLeft.BackgroundTransparency = 1
InfoLeft.Text = "🎮  " .. game.Name
InfoLeft.TextColor3 = Color3.fromRGB(55,90,130)
InfoLeft.TextSize = 11
InfoLeft.Font = Enum.Font.Gotham
InfoLeft.TextXAlignment = Enum.TextXAlignment.Left
InfoLeft.TextTransparency = 1
InfoLeft.ZIndex = 7

local InfoRight = Instance.new("TextLabel", Panel)
InfoRight.Size = UDim2.new(0.5,-10,0,18)
InfoRight.Position = UDim2.new(0.5,0,0,270)
InfoRight.BackgroundTransparency = 1
InfoRight.Text = "⏱  " .. LOADING_TIME .. "s est."
InfoRight.TextColor3 = Color3.fromRGB(55,90,130)
InfoRight.TextSize = 11
InfoRight.Font = Enum.Font.Gotham
InfoRight.TextXAlignment = Enum.TextXAlignment.Right
InfoRight.TextTransparency = 1
InfoRight.ZIndex = 7

-- ── Footer ──
local Footer = Instance.new("TextLabel", Panel)
Footer.Size = UDim2.new(1,-40,0,18)
Footer.Position = UDim2.new(0,20,1,-28)
Footer.BackgroundTransparency = 1
Footer.Text = "CryoXHUB  •  Please wait..."
Footer.TextColor3 = Color3.fromRGB(35,65,100)
Footer.TextSize = 11
Footer.Font = Enum.Font.Gotham
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.TextTransparency = 1
Footer.ZIndex = 7

-- ══════════════════════════════════════════
--   SKIP BUTTON
-- ══════════════════════════════════════════
local SkipBtn = Instance.new("TextButton")
SkipBtn.Size = UDim2.new(0,110,0,32)
SkipBtn.Position = UDim2.new(0.5,-55,0,0)
SkipBtn.BackgroundColor3 = Color3.fromRGB(6,18,40)
SkipBtn.BackgroundTransparency = 1
SkipBtn.BorderSizePixel = 0
SkipBtn.Text = "⏭  Skip"
SkipBtn.TextColor3 = Color3.fromRGB(0,200,245)
SkipBtn.TextSize = 13
SkipBtn.Font = Enum.Font.GothamBold
SkipBtn.ZIndex = 10
SkipBtn.AutoButtonColor = false
SkipBtn.Parent = sg
Instance.new("UICorner", SkipBtn).CornerRadius = UDim.new(0,8)

local SkipStroke = Instance.new("UIStroke", SkipBtn)
SkipStroke.Color = Color3.fromRGB(0,180,220)
SkipStroke.Thickness = 1.2
SkipStroke.Transparency = 1

-- ══════════════════════════════════════════
--   SKIP CONFIRM DIALOG
-- ══════════════════════════════════════════
local Dialog = Instance.new("Frame")
Dialog.Size = UDim2.new(0,320,0,130)
Dialog.Position = UDim2.new(0.5,-160,0.5,-65)
Dialog.BackgroundColor3 = Color3.fromRGB(6,14,30)
Dialog.BorderSizePixel = 0
Dialog.ZIndex = 20
Dialog.Visible = false
Dialog.Parent = sg
Instance.new("UICorner", Dialog).CornerRadius = UDim.new(0,14)
local DStroke = Instance.new("UIStroke", Dialog)
DStroke.Color = Color3.fromRGB(0,200,240)
DStroke.Thickness = 1.5

local DTitle = Instance.new("TextLabel", Dialog)
DTitle.Size = UDim2.new(1,-30,0,30)
DTitle.Position = UDim2.new(0,15,0,14)
DTitle.BackgroundTransparency = 1
DTitle.Text = "Skip loading?"
DTitle.TextColor3 = Color3.fromRGB(200,230,255)
DTitle.TextSize = 16
DTitle.Font = Enum.Font.GothamBold
DTitle.ZIndex = 21

local DSub = Instance.new("TextLabel", Dialog)
DSub.Size = UDim2.new(1,-30,0,24)
DSub.Position = UDim2.new(0,15,0,42)
DSub.BackgroundTransparency = 1
DSub.Text = "Some features may not work correctly."
DSub.TextColor3 = Color3.fromRGB(80,120,165)
DSub.TextSize = 12
DSub.Font = Enum.Font.Gotham
DSub.ZIndex = 21

local function makeDialogBtn(text, x, bgColor, txtColor)
    local b = Instance.new("TextButton", Dialog)
    b.Size = UDim2.new(0,130,0,34)
    b.Position = UDim2.new(0,x,1,-50)
    b.BackgroundColor3 = bgColor
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = txtColor
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.ZIndex = 22
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local DConfirm = makeDialogBtn("Yes, skip", 20, Color3.fromRGB(0,180,220), Color3.fromRGB(3,6,16))
local DCancel  = makeDialogBtn("Keep loading", 170, Color3.fromRGB(12,28,55), Color3.fromRGB(0,180,220))
local DCancelStroke = Instance.new("UIStroke", DCancel)
DCancelStroke.Color = Color3.fromRGB(0,150,200)
DCancelStroke.Thickness = 1

-- ══════════════════════════════════════════
--   NOTIFICATION TOAST
-- ══════════════════════════════════════════
local function showToast(msg, color)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0,280,0,40)
    toast.Position = UDim2.new(0.5,-140,0,-50)
    toast.BackgroundColor3 = Color3.fromRGB(6,16,34)
    toast.BorderSizePixel = 0
    toast.ZIndex = 30
    toast.Parent = sg
    Instance.new("UICorner", toast).CornerRadius = UDim.new(0,10)
    local ts = Instance.new("UIStroke", toast)
    ts.Color = color or Color3.fromRGB(0,200,240)
    ts.Thickness = 1.2
    local tl = Instance.new("TextLabel", toast)
    tl.Size = UDim2.new(1,-20,1,0)
    tl.Position = UDim2.new(0,10,0,0)
    tl.BackgroundTransparency = 1
    tl.Text = msg
    tl.TextColor3 = color or Color3.fromRGB(0,210,255)
    tl.TextSize = 12
    tl.Font = Enum.Font.GothamBold
    tl.ZIndex = 31
    Tween(toast, { Position = UDim2.new(0.5,-140,0,16) }, 0.4, Enum.EasingStyle.Back)
    task.delay(2.5, function()
        Tween(toast, { Position = UDim2.new(0.5,-140,0,-50) }, 0.4)
        task.wait(0.45)
        toast:Destroy()
    end)
end

-- ══════════════════════════════════════════
--   LOAD MAIN SCRIPT IN PARALLEL
-- ══════════════════════════════════════════
local scriptDone = false
task.spawn(function()
    local ok, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/CryoXHUB.lua"))()
    end)
    scriptDone = true
    if not ok then
        warn("[CryoXHUB] Error: " .. tostring(err))
    end
end)

-- ══════════════════════════════════════════
--   ENTRY ANIMATION
-- ══════════════════════════════════════════
task.wait(0.1)

-- Orb breathe
task.spawn(function()
    while sg.Parent do
        Tween(Orb1, { ImageTransparency = 0.87 }, 3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        Tween(Orb2, { ImageTransparency = 0.80 }, 3.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(3)
        Tween(Orb1, { ImageTransparency = 0.78 }, 3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        Tween(Orb2, { ImageTransparency = 0.88 }, 3.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(3)
    end
end)

-- Panel slide in
Tween(Panel, { Position = UDim2.new(0.5,-250,0.5,-170), BackgroundTransparency = 0 }, 0.7, Enum.EasingStyle.Back)
task.wait(0.3)
Tween(PanelStroke, { Transparency = 0.3 }, 0.5)
Tween(Icon, { TextTransparency = 0 }, 0.4)
Tween(IconShadow, { TextTransparency = 0.7 }, 0.4)
task.wait(0.15)
Tween(Title, { TextTransparency = 0 }, 0.4)
task.wait(0.1)
Tween(Subtitle, { TextTransparency = 0 }, 0.35)
Tween(Badge, { BackgroundTransparency = 0 }, 0.3)
Tween(VerLabel, { TextTransparency = 0 }, 0.3)
task.wait(0.15)
Tween(Status, { TextTransparency = 0 }, 0.3)
Tween(Pct, { TextTransparency = 0 }, 0.3)
Tween(Footer, { TextTransparency = 0 }, 0.3)
Tween(InfoLeft, { TextTransparency = 0 }, 0.3)
Tween(InfoRight, { TextTransparency = 0 }, 0.3)
task.wait(0.2)
-- Show skip button
SkipBtn.Position = UDim2.new(0.5,-55,0.5,195)
Tween(SkipBtn, { BackgroundTransparency = 0, TextTransparency = 0 }, 0.4)
Tween(SkipStroke, { Transparency = 0.4 }, 0.4)

-- ══════════════════════════════════════════
--   ICON PULSE LOOP
-- ══════════════════════════════════════════
task.spawn(function()
    while sg.Parent do
        Tween(Icon, { TextTransparency = 0.4, TextSize = 50 }, 0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(0.85)
        Tween(Icon, { TextTransparency = 0, TextSize = 46 }, 0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(0.85)
    end
end)

-- ══════════════════════════════════════════
--   PARTICLE ANIMATION LOOP
-- ══════════════════════════════════════════
task.spawn(function()
    while sg.Parent do
        for _, p in ipairs(particles) do
            local pos = p.frame.Position
            local newY = pos.Y.Scale - p.speed
            local newX = pos.X.Scale + p.drift
            if newY < -0.05 then newY = 1.05 end
            if newX < 0 then newX = 1 elseif newX > 1 then newX = 0 end
            p.frame.Position = UDim2.new(newX, 0, newY, 0)
        end
        task.wait()
    end
end)

-- ══════════════════════════════════════════
--   SKIP BUTTON HOVER
-- ══════════════════════════════════════════
SkipBtn.MouseEnter:Connect(function()
    Tween(SkipBtn, { BackgroundColor3 = Color3.fromRGB(0,180,220), TextColor3 = Color3.fromRGB(3,6,16) }, 0.2)
    Tween(SkipStroke, { Transparency = 1 }, 0.2)
end)
SkipBtn.MouseLeave:Connect(function()
    Tween(SkipBtn, { BackgroundColor3 = Color3.fromRGB(6,18,40), TextColor3 = Color3.fromRGB(0,200,245) }, 0.2)
    Tween(SkipStroke, { Transparency = 0.4 }, 0.2)
end)

-- ══════════════════════════════════════════
--   SKIP LOGIC
-- ══════════════════════════════════════════
local skipRequested = false
local function doFadeOut()
    for _, obj in ipairs({ Title, Status, Pct, Footer, Icon, IconShadow, VerLabel, Subtitle, InfoLeft, InfoRight }) do
        Tween(obj, { TextTransparency = 1 }, 0.45)
    end
    for _, obj in ipairs({ Badge, Track, Fill, PanelGlow }) do
        Tween(obj, { BackgroundTransparency = 1 }, 0.45)
    end
    Tween(DotHolder, { GroupTransparency = 1 }, 0.45)
    Tween(Orb1, { ImageTransparency = 1 }, 0.45)
    Tween(Orb2, { ImageTransparency = 1 }, 0.45)
    Tween(Orb3, { ImageTransparency = 1 }, 0.45)
    Tween(BarGlow, { ImageTransparency = 1 }, 0.45)
    Tween(PanelStroke, { Transparency = 1 }, 0.45)
    Tween(Panel, { BackgroundTransparency = 1 }, 0.45)
    Tween(SkipBtn, { BackgroundTransparency = 1, TextTransparency = 1 }, 0.3)
    Tween(Backdrop, { BackgroundTransparency = 1 }, 0.5)
    Tween(Grid, { ImageTransparency = 1 }, 0.4)
    task.wait(0.55)
    sg:Destroy()
end

SkipBtn.MouseButton1Click:Connect(function()
    Dialog.Visible = true
    Tween(Dialog, { BackgroundTransparency = 0 }, 0.25)
end)

DCancel.MouseButton1Click:Connect(function()
    Dialog.Visible = false
end)

DConfirm.MouseButton1Click:Connect(function()
    skipRequested = true
    Dialog.Visible = false
    showToast("⚡  Skipped — loading in background", Color3.fromRGB(0,210,255))
    task.wait(0.5)
    doFadeOut()
end)

-- ══════════════════════════════════════════
--   PROGRESS BAR SEQUENCE
-- ══════════════════════════════════════════
local Steps = {
    { text = "Initializing core modules...",    icon = "🔧" },
    { text = "Loading UI components...",         icon = "🖥" },
    { text = "Connecting to services...",        icon = "🌐" },
    { text = "Fetching configuration...",        icon = "📦" },
    { text = "Applying patches...",              icon = "🩹" },
    { text = "Optimizing performance...",        icon = "⚡" },
    { text = "Running diagnostics...",           icon = "🔍" },
    { text = "Finalizing environment...",        icon = "🛠" },
    { text = "Ready.",                           icon = "✓" },
}

task.spawn(function()
    local stepCount = #Steps
    local interval  = LOADING_TIME / stepCount

    for i, step in ipairs(Steps) do
        if skipRequested then break end

        -- Update step dot
        if stepDots[i] then
            Tween(stepDots[i], { BackgroundColor3 = Color3.fromRGB(0,210,255) }, 0.3)
        end

        Status.Text = step.icon .. "  " .. step.text
        local pct     = i / stepCount
        local prevPct = (i - 1) / stepCount
        Tween(Fill, { Size = UDim2.new(pct,0,1,0) }, interval * 0.85, Enum.EasingStyle.Quart)

        -- Animated percent counter
        local startN = math.floor(prevPct * 100)
        local endN   = math.floor(pct * 100)
        local t0     = tick()
        local dur    = interval * 0.85
        task.spawn(function()
            while not skipRequested do
                local frac = math.min((tick()-t0)/dur, 1)
                Pct.Text = math.floor(startN+(endN-startN)*frac).."%"
                if frac >= 1 then break end
                task.wait()
            end
        end)

        task.wait(interval)
    end

    if skipRequested then return end

    Status.Text       = "✓   Loaded successfully"
    Status.TextColor3 = Color3.fromRGB(0,220,255)
    Pct.Text          = "100%"
    showToast("✅  CryoXHUB loaded!", Color3.fromRGB(0,220,120))
    task.wait(1.2)
    doFadeOut()
end)
