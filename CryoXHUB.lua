local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CryoX_Furina_Final_v4"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer  = Players.LocalPlayer

local ID_ANH_NEN    = "rbxthumb://type=Asset&id=116367849760314&w=420&h=420"
local ID_LOGO_DONG  = "rbxthumb://type=Asset&id=135753950157111&w=420&h=420"
local KEY_CHINH_XAC = "CryoXHUB"

local TechUnlocked    = false
local ScriptUnlocked  = false
local CurrentKeyTarget = ""

local C = {
    BG     = Color3.fromRGB(4,   8,  18),
    PANEL  = Color3.fromRGB(8,  16,  32),
    PANEL2 = Color3.fromRGB(12, 22,  42),
    CYAN   = Color3.fromRGB(0,  210, 255),
    TEXT   = Color3.fromRGB(220,240, 255),
    SUB    = Color3.fromRGB(100,160, 200),
    RED    = Color3.fromRGB(200, 50,  50),
}

local function tw(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.2,
        Enum.EasingStyle.Quart, Enum.EasingDirection.Out
    ), props):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = p
end

local function stroke(p, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = C.CYAN
    s.Thickness = thickness or 1.5
    s.Transparency = transparency or 0.25
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local function glowOrb(p, tr)
    local g = Instance.new("ImageLabel")
    g.Size = UDim2.new(1,40,1,40)
    g.Position = UDim2.new(0,-20,0,-20)
    g.BackgroundTransparency = 1
    g.Image = "rbxassetid://5028857084"
    g.ImageColor3 = C.CYAN
    g.ImageTransparency = tr or 0.88
    g.ZIndex = (p.ZIndex or 1) - 1
    g.Parent = p
end

-- ══════════════════════════════════════════
--   ROOT — 1 viền duy nhất, không accentLine
-- ══════════════════════════════════════════
local Root = Instance.new("Frame")
Root.Size = UDim2.new(0, 520, 0, 340)
Root.Position = UDim2.new(0.5,-260,0.5,-170)
Root.BackgroundColor3 = C.BG
Root.BorderSizePixel = 0
Root.Active = true
Root.Draggable = true
Root.ZIndex = 2
Root.Parent = ScreenGui
corner(Root, 14)
stroke(Root, 1.8, 0.1) -- chỉ 1 viền ở đây

glowOrb(Root, 0.88)

local RootBg = Instance.new("ImageLabel")
RootBg.Size = UDim2.new(1,0,1,0)
RootBg.BackgroundTransparency = 1
RootBg.Image = ID_ANH_NEN
RootBg.ImageTransparency = 0.9
RootBg.ScaleType = Enum.ScaleType.Crop
RootBg.ZIndex = 1
RootBg.Parent = Root
corner(RootBg, 14)

-- Padding toàn Root
local RootPad = Instance.new("UIPadding")
RootPad.PaddingTop    = UDim.new(0, 6)
RootPad.PaddingBottom = UDim.new(0, 6)
RootPad.PaddingLeft   = UDim.new(0, 6)
RootPad.PaddingRight  = UDim.new(0, 6)
RootPad.Parent = Root

-- Layout ngang: trái + phải
local RootLayout = Instance.new("UIListLayout")
RootLayout.FillDirection = Enum.FillDirection.Horizontal
RootLayout.Padding = UDim.new(0, 6)
RootLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
RootLayout.VerticalAlignment = Enum.VerticalAlignment.Top
RootLayout.Parent = Root

-- ══════════════════════════════════════════
--   LEFT COLUMN — tổng = Root height - 12
-- ══════════════════════════════════════════
local LeftCol = Instance.new("Frame")
LeftCol.Size = UDim2.new(0,155,1,0) -- khớp chiều cao Root sau padding
LeftCol.BackgroundTransparency = 1
LeftCol.BorderSizePixel = 0
LeftCol.ZIndex = 3
LeftCol.Parent = Root

local LeftLayout = Instance.new("UIListLayout")
LeftLayout.FillDirection = Enum.FillDirection.Vertical
LeftLayout.Padding = UDim.new(0, 5)
LeftLayout.Parent = LeftCol

-- Avatar Card — chiều cao cố định
local AvatarCard = Instance.new("Frame")
AvatarCard.Size = UDim2.new(1,0,0,152)
AvatarCard.BackgroundColor3 = C.PANEL
AvatarCard.BorderSizePixel = 0
AvatarCard.ZIndex = 3
AvatarCard.Parent = LeftCol
corner(AvatarCard, 10)
stroke(AvatarCard, 1.2, 0.2)

local AvatarCardBg = Instance.new("ImageLabel")
AvatarCardBg.Size = UDim2.new(1,0,1,0)
AvatarCardBg.BackgroundTransparency = 1
AvatarCardBg.Image = ID_ANH_NEN
AvatarCardBg.ImageTransparency = 0.82
AvatarCardBg.ScaleType = Enum.ScaleType.Crop
AvatarCardBg.ZIndex = 3
AvatarCardBg.Parent = AvatarCard
corner(AvatarCardBg, 10)

local AvatarGlow = Instance.new("ImageLabel")
AvatarGlow.Size = UDim2.new(0,76,0,76)
AvatarGlow.Position = UDim2.new(0.5,-38,0,4)
AvatarGlow.BackgroundTransparency = 1
AvatarGlow.Image = "rbxassetid://5028857084"
AvatarGlow.ImageColor3 = C.CYAN
AvatarGlow.ImageTransparency = 0.72
AvatarGlow.ZIndex = 4
AvatarGlow.Parent = AvatarCard

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0,58,0,58)
AvatarImg.Position = UDim2.new(0.5,-29,0,12)
AvatarImg.BackgroundColor3 = C.PANEL2
AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150"
AvatarImg.ZIndex = 5
AvatarImg.Parent = AvatarCard
corner(AvatarImg, 999)
stroke(AvatarImg, 2, 0.05)

local DName = Instance.new("TextLabel")
DName.Size = UDim2.new(1,-8,0,20)
DName.Position = UDim2.new(0,4,0,74)
DName.BackgroundTransparency = 1
DName.Text = LocalPlayer.DisplayName
DName.TextColor3 = C.TEXT
DName.Font = Enum.Font.GothamBold
DName.TextSize = 13
DName.TextXAlignment = Enum.TextXAlignment.Center
DName.ZIndex = 5
DName.Parent = AvatarCard

local UName = Instance.new("TextLabel")
UName.Size = UDim2.new(1,-8,0,16)
UName.Position = UDim2.new(0,4,0,93)
UName.BackgroundTransparency = 1
UName.Text = "@"..LocalPlayer.Name
UName.TextColor3 = C.CYAN
UName.Font = Enum.Font.Gotham
UName.TextSize = 11
UName.TextXAlignment = Enum.TextXAlignment.Center
UName.ZIndex = 5
UName.Parent = AvatarCard

local ADiv = Instance.new("Frame")
ADiv.Size = UDim2.new(1,-20,0,1)
ADiv.Position = UDim2.new(0,10,0,113)
ADiv.BackgroundColor3 = C.CYAN
ADiv.BackgroundTransparency = 0.6
ADiv.BorderSizePixel = 0
ADiv.ZIndex = 4
ADiv.Parent = AvatarCard

local UIDLabel = Instance.new("TextLabel")
UIDLabel.Size = UDim2.new(1,-8,0,15)
UIDLabel.Position = UDim2.new(0,4,0,118)
UIDLabel.BackgroundTransparency = 1
UIDLabel.Text = "UID: "..LocalPlayer.UserId
UIDLabel.TextColor3 = C.SUB
UIDLabel.Font = Enum.Font.Gotham
UIDLabel.TextSize = 10
UIDLabel.TextXAlignment = Enum.TextXAlignment.Center
UIDLabel.ZIndex = 5
UIDLabel.Parent = AvatarCard

local VerLbl = Instance.new("TextLabel")
VerLbl.Size = UDim2.new(1,-8,0,15)
VerLbl.Position = UDim2.new(0,4,0,134)
VerLbl.BackgroundTransparency = 1
VerLbl.Text = "CryoXHUB  v2.0"
VerLbl.TextColor3 = C.CYAN
VerLbl.Font = Enum.Font.GothamBold
VerLbl.TextSize = 10
VerLbl.TextXAlignment = Enum.TextXAlignment.Center
VerLbl.ZIndex = 5
VerLbl.Parent = AvatarCard

-- Update Card — fill phần còn lại
-- Root = 340, padding top+bot = 12, AvatarCard = 152, gap = 5
-- UpdateCard height = 340 - 12 - 152 - 5 = 171
local UpdateCard = Instance.new("Frame")
UpdateCard.Size = UDim2.new(1,0,1,-157) -- 1,0 width; height = fill còn lại
UpdateCard.BackgroundColor3 = C.PANEL
UpdateCard.BorderSizePixel = 0
UpdateCard.ZIndex = 3
UpdateCard.Parent = LeftCol
corner(UpdateCard, 10)
stroke(UpdateCard, 1.2, 0.2)

local UpdateCardBg = Instance.new("ImageLabel")
UpdateCardBg.Size = UDim2.new(1,0,1,0)
UpdateCardBg.BackgroundTransparency = 1
UpdateCardBg.Image = ID_ANH_NEN
UpdateCardBg.ImageTransparency = 0.85
UpdateCardBg.ScaleType = Enum.ScaleType.Crop
UpdateCardBg.ZIndex = 3
UpdateCardBg.Parent = UpdateCard
corner(UpdateCardBg, 10)

local UpdateTitle = Instance.new("TextLabel")
UpdateTitle.Size = UDim2.new(1,-10,0,22)
UpdateTitle.Position = UDim2.new(0,8,0,5)
UpdateTitle.BackgroundTransparency = 1
UpdateTitle.Text = "🔔  Update Log"
UpdateTitle.TextColor3 = C.CYAN
UpdateTitle.Font = Enum.Font.GothamBold
UpdateTitle.TextSize = 11
UpdateTitle.TextXAlignment = Enum.TextXAlignment.Left
UpdateTitle.ZIndex = 5
UpdateTitle.Parent = UpdateCard

local UDiv = Instance.new("Frame")
UDiv.Size = UDim2.new(1,-14,0,1)
UDiv.Position = UDim2.new(0,7,0,27)
UDiv.BackgroundColor3 = C.CYAN
UDiv.BackgroundTransparency = 0.6
UDiv.BorderSizePixel = 0
UDiv.ZIndex = 4
UDiv.Parent = UpdateCard

local UpdateScroll = Instance.new("ScrollingFrame")
UpdateScroll.Size = UDim2.new(1,-8,1,-30)
UpdateScroll.Position = UDim2.new(0,4,0,28)
UpdateScroll.BackgroundTransparency = 1
UpdateScroll.BorderSizePixel = 0
UpdateScroll.ScrollBarThickness = 2
UpdateScroll.ScrollBarImageColor3 = C.CYAN
UpdateScroll.CanvasSize = UDim2.new(0,0,0,0)
UpdateScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
UpdateScroll.ZIndex = 5
UpdateScroll.Parent = UpdateCard

Instance.new("UIListLayout", UpdateScroll).Padding = UDim.new(0,3)

local UPad = Instance.new("UIPadding")
UPad.PaddingTop = UDim.new(0,2)
UPad.Parent = UpdateScroll

local updates = {
    {"v2.0","Redesign toàn bộ GUI"},
    {"v2.0","Thêm Info & Update panel"},
    {"v1.9","Thêm tab MOVESET"},
    {"v1.8","Thêm tab AURA"},
    {"v1.7","Fix key system"},
    {"v1.6","Thêm Loop Dash"},
    {"v1.5","Thêm Instant Twisted v2"},
}
for _, u in ipairs(updates) do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,-2,0,26)
    row.BackgroundColor3 = C.PANEL2
    row.BorderSizePixel = 0
    row.ZIndex = 6
    row.Parent = UpdateScroll
    corner(row, 6)

    local ver = Instance.new("TextLabel")
    ver.Size = UDim2.new(0,34,1,0)
    ver.Position = UDim2.new(0,4,0,0)
    ver.BackgroundTransparency = 1
    ver.Text = u[1]
    ver.TextColor3 = C.CYAN
    ver.Font = Enum.Font.GothamBold
    ver.TextSize = 9
    ver.ZIndex = 7
    ver.Parent = row

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1,-38,1,0)
    desc.Position = UDim2.new(0,36,0,0)
    desc.BackgroundTransparency = 1
    desc.Text = u[2]
    desc.TextColor3 = C.SUB
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 9
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextWrapped = true
    desc.ZIndex = 7
    desc.Parent = row
end

-- ══════════════════════════════════════════
--   RIGHT COLUMN
-- ══════════════════════════════════════════
local RightCol = Instance.new("Frame")
RightCol.Size = UDim2.new(1,-161,1,0)
RightCol.BackgroundTransparency = 1
RightCol.BorderSizePixel = 0
RightCol.ZIndex = 3
RightCol.Parent = Root

local RightLayout = Instance.new("UIListLayout")
RightLayout.FillDirection = Enum.FillDirection.Vertical
RightLayout.Padding = UDim.new(0,5)
RightLayout.Parent = RightCol

-- Tab bar
-- TabBar height = 36, ContentBg = 340-12-36-5 = 287
local TabRow = Instance.new("Frame")
TabRow.Size = UDim2.new(1,0,0,36)
TabRow.BackgroundTransparency = 1
TabRow.BorderSizePixel = 0
TabRow.ZIndex = 4
TabRow.Parent = RightCol

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1,-36,1,0)
TabBar.BackgroundColor3 = C.PANEL
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 4
TabBar.Parent = TabRow
corner(TabBar, 10)
stroke(TabBar, 1.2, 0.2)

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Size = UDim2.new(1,-8,1,-6)
TabScroll.Position = UDim2.new(0,4,0,3)
TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.ScrollBarThickness = 0
TabScroll.CanvasSize = UDim2.new(0,0,0,0)
TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
TabScroll.ScrollingDirection = Enum.ScrollingDirection.X
TabScroll.ZIndex = 5
TabScroll.Parent = TabBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0,5)
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Parent = TabScroll

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-30,0,3)
CloseBtn.BackgroundColor3 = C.RED
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = C.TEXT
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.ZIndex = 6
CloseBtn.Parent = TabRow
corner(CloseBtn, 8)

CloseBtn.MouseEnter:Connect(function()
    tw(CloseBtn, {BackgroundColor3 = Color3.fromRGB(240,70,70)})
end)
CloseBtn.MouseLeave:Connect(function()
    tw(CloseBtn, {BackgroundColor3 = C.RED})
end)

-- Content background
local ContentBg = Instance.new("Frame")
ContentBg.Size = UDim2.new(1,0,1,-41)
ContentBg.BackgroundColor3 = C.PANEL
ContentBg.BorderSizePixel = 0
ContentBg.ZIndex = 3
ContentBg.Parent = RightCol
corner(ContentBg, 10)
stroke(ContentBg, 1.2, 0.2)

local ContentBgImg = Instance.new("ImageLabel")
ContentBgImg.Size = UDim2.new(1,0,1,0)
ContentBgImg.BackgroundTransparency = 1
ContentBgImg.Image = ID_ANH_NEN
ContentBgImg.ImageTransparency = 0.72
ContentBgImg.ScaleType = Enum.ScaleType.Crop
ContentBgImg.ZIndex = 3
ContentBgImg.Parent = ContentBg
corner(ContentBgImg, 10)

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1,-10,1,-10)
ContentFrame.Position = UDim2.new(0,5,0,5)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ZIndex = 4
ContentFrame.CanvasSize = UDim2.new(0,0,0,0)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.ScrollBarThickness = 2
ContentFrame.ScrollBarImageColor3 = C.CYAN
ContentFrame.Parent = ContentBg

local CLayout = Instance.new("UIListLayout")
CLayout.Padding = UDim.new(0,6)
CLayout.Parent = ContentFrame

local CPad = Instance.new("UIPadding")
CPad.PaddingTop    = UDim.new(0,4)
CPad.PaddingBottom = UDim.new(0,4)
CPad.Parent = ContentFrame

-- Key Frame
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(1,-10,1,-10)
KeyFrame.Position = UDim2.new(0,5,0,5)
KeyFrame.BackgroundTransparency = 1
KeyFrame.ZIndex = 6
KeyFrame.Visible = false
KeyFrame.Parent = ContentBg

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1,0,0,28)
KeyTitle.Position = UDim2.new(0,0,0.1,0)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "🔐   Tab này yêu cầu Key"
KeyTitle.TextColor3 = C.CYAN
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 14
KeyTitle.ZIndex = 7
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0,230,0,36)
KeyInput.Position = UDim2.new(0.5,-115,0.35,0)
KeyInput.BackgroundColor3 = C.PANEL2
KeyInput.PlaceholderText = "Nhập Key tại đây..."
KeyInput.Text = ""
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 13
KeyInput.TextColor3 = C.TEXT
KeyInput.PlaceholderColor3 = C.SUB
KeyInput.ZIndex = 7
KeyInput.Parent = KeyFrame
corner(KeyInput, 9)
stroke(KeyInput, 1.5, 0.2)

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0,120,0,34)
SubmitBtn.Position = UDim2.new(0.5,-60,0.62,0)
SubmitBtn.BackgroundColor3 = C.CYAN
SubmitBtn.Text = "XÁC NHẬN"
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 13
SubmitBtn.TextColor3 = C.BG
SubmitBtn.ZIndex = 7
SubmitBtn.Parent = KeyFrame
corner(SubmitBtn, 9)

SubmitBtn.MouseEnter:Connect(function()
    tw(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(0,240,255)})
end)
SubmitBtn.MouseLeave:Connect(function()
    tw(SubmitBtn, {BackgroundColor3 = C.CYAN})
end)

-- ══════════════════════════════════════════
--   FACTORIES
-- ══════════════════════════════════════════
local activeTab = nil

local function setActive(btn)
    if activeTab then
        tw(activeTab, {BackgroundColor3 = C.PANEL2}, 0.2)
        activeTab.TextColor3 = C.SUB
        local s = activeTab:FindFirstChildOfClass("UIStroke")
        if s then tw(s, {Transparency = 0.6}, 0.2) end
    end
    activeTab = btn
    tw(btn, {BackgroundColor3 = Color3.fromRGB(0,48,85)}, 0.2)
    btn.TextColor3 = C.CYAN
    local s = btn:FindFirstChildOfClass("UIStroke")
    if s then tw(s, {Transparency = 0}, 0.2) end
end

local function clearContent()
    for _, v in pairs(ContentFrame:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("Frame") then v:Destroy() end
    end
end

local function makeScriptBtn(name, code)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-4,0,38)
    btn.Text = ""
    btn.BackgroundColor3 = C.PANEL2
    btn.ZIndex = 5
    btn.Parent = ContentFrame
    corner(btn, 9)
    stroke(btn, 1.2, 0.55)

    local iconL = Instance.new("TextLabel")
    iconL.Size = UDim2.new(0,30,1,0)
    iconL.Position = UDim2.new(0,4,0,0)
    iconL.BackgroundTransparency = 1
    iconL.Text = "▶"
    iconL.TextColor3 = C.CYAN
    iconL.Font = Enum.Font.GothamBold
    iconL.TextSize = 12
    iconL.ZIndex = 6
    iconL.Parent = btn

    local nameL = Instance.new("TextLabel")
    nameL.Size = UDim2.new(1,-38,1,0)
    nameL.Position = UDim2.new(0,32,0,0)
    nameL.BackgroundTransparency = 1
    nameL.Text = name
    nameL.TextColor3 = C.TEXT
    nameL.Font = Enum.Font.GothamBold
    nameL.TextSize = 13
    nameL.TextXAlignment = Enum.TextXAlignment.Left
    nameL.ZIndex = 6
    nameL.Parent = btn

    btn.MouseEnter:Connect(function()
        tw(btn, {BackgroundColor3 = Color3.fromRGB(0,38,68)})
        tw(nameL, {TextColor3 = C.CYAN})
    end)
    btn.MouseLeave:Connect(function()
        tw(btn, {BackgroundColor3 = C.PANEL2})
        tw(nameL, {TextColor3 = C.TEXT})
    end)
    btn.MouseButton1Click:Connect(function()
        tw(btn, {BackgroundColor3 = Color3.fromRGB(0,65,100)}, 0.1)
        task.wait(0.12)
        tw(btn, {BackgroundColor3 = C.PANEL2}, 0.2)
        local f, e = loadstring(code)
        if f then task.spawn(f) else warn(e) end
    end)
end

local function makeTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,78,0,24)
    btn.Text = name
    btn.BackgroundColor3 = C.PANEL2
    btn.TextColor3 = C.SUB
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.ZIndex = 6
    btn.Parent = TabScroll
    corner(btn, 7)
    stroke(btn, 1.2, 0.6)

    btn.MouseEnter:Connect(function()
        if activeTab ~= btn then
            tw(btn, {BackgroundColor3 = Color3.fromRGB(0,28,52)})
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= btn then
            tw(btn, {BackgroundColor3 = C.PANEL2})
        end
    end)
    return btn
end

-- ══════════════════════════════════════════
--   TAB CONTENTS
-- ══════════════════════════════════════════
local function LoadFPS()
    KeyFrame.Visible=false; ContentFrame.Visible=true; clearContent()
    makeScriptBtn("CryoX Anti-Lag",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/CryoX%20Anti-Lag.lua"))()]])
end

local function LoadTech()
    KeyFrame.Visible=false; ContentFrame.Visible=true; clearContent()
    makeScriptBtn("Supa Tech",[[loadstring(game:HttpGet("https://rawscripts.net/raw/The-Strongest-Battlegrounds-Supa-tech-v2-77454"))()]])
    makeScriptBtn("Kiba Tech",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/yqantg-pixel/Find/refs/heads/main/Protected_1593573630798166.lua.txt"))()]])
    makeScriptBtn("Oreo Tech",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/OreoTech/refs/heads/main/Protected_6856895483929371.lua"))()]])
    makeScriptBtn("Lethal Dash",[[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/57a4d240a2440f0450986c966469092ccfb8d4797392cb8f469fa8b6e605e64d/download"))()]])
    makeScriptBtn("Back Dash Cancel",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/dinhthanhtuankiet1762009-sudo/Js/refs/heads/main/4418648b0e9b71ef.lua"))()]])
    makeScriptBtn("Instant Twisted v2",[[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/60a7a7c77395006ebd63fce0a17c13241f932bd414c9aba3158b716da00ade01/download"))()]])
    makeScriptBtn("Loop Dash",[[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/28513f51c0ca2c03d4d7d94f59215d13ce1a2a470bf187f0a685b58ccb4dae98/download"))()]])
end

local function LoadShader()
    KeyFrame.Visible=false; ContentFrame.Visible=true; clearContent()
    makeScriptBtn("Custom Shader",[[loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Simple-Shader-37434"))()]])
end

local function LoadScript()
    KeyFrame.Visible=false; ContentFrame.Visible=true; clearContent()
    makeScriptBtn("Fly GuiV3",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()]])
    makeScriptBtn("Anti Death Counter",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Anti-Death-Counter.lua"))()]])
    makeScriptBtn("Avatar Changer",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/darkdexv2/universalavatarchanger/main/avatarchanger"))()]])
    makeScriptBtn("Dex Explorer",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Dex_Explorer_v2.lua"))()]])
    makeScriptBtn("Shield",[[Instance.new("ForceField",game.Players.LocalPlayer.Character)]])
    makeScriptBtn("TouchFling",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/long191910/all-my-roblox-script/refs/heads/main/touchfling.lua"))()]])
end

local function LoadAura()
    KeyFrame.Visible=false; ContentFrame.Visible=true; clearContent()
    makeScriptBtn("Blue Flame Aura",[[loadstring(game:HttpGet("Link_Script_Aura_Tai_Day"))()]])
    makeScriptBtn("Ultra Instinct Aura",[[loadstring(game:HttpGet("Link_Script_Aura_2"))()]])
end

local function LoadMoveset()
    KeyFrame.Visible=false; ContentFrame.Visible=true; clearContent()
    makeScriptBtn("KAR [SAITAMA]",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/OfficialAposty/RBLX-Scripts/refs/heads/main/UltimateLifeForm.lua"))()]])
    makeScriptBtn("Gojo [SAITAMA]",[[getgenv().morph=false
loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/BaldyToSorcerer/refs/heads/main/LatestV2.lua"))()]])
    makeScriptBtn("CHARA [SAITAMA]",[[loadstring(game:HttpGet("https://pastefy.app/gFRaeMGz/raw"))()]])
end

-- ══════════════════════════════════════════
--   REGISTER TABS
-- ══════════════════════════════════════════
local FPSTab = makeTab("FPS")
FPSTab.MouseButton1Click:Connect(function() setActive(FPSTab); LoadFPS() end)

local TechTab = makeTab("TECH")
TechTab.MouseButton1Click:Connect(function()
    setActive(TechTab)
    if TechUnlocked then LoadTech()
    else CurrentKeyTarget="TECH"; ContentFrame.Visible=false; KeyFrame.Visible=true end
end)

local ShaderTab = makeTab("SHADER")
ShaderTab.MouseButton1Click:Connect(function() setActive(ShaderTab); LoadShader() end)

local ScriptTab = makeTab("SCRIPT")
ScriptTab.MouseButton1Click:Connect(function()
    setActive(ScriptTab)
    if ScriptUnlocked then LoadScript()
    else CurrentKeyTarget="SCRIPT"; ContentFrame.Visible=false; KeyFrame.Visible=true end
end)

local AuraTab = makeTab("AURA")
AuraTab.MouseButton1Click:Connect(function() setActive(AuraTab); LoadAura() end)

local MovesetTab = makeTab("MOVESET")
MovesetTab.MouseButton1Click:Connect(function() setActive(MovesetTab); LoadMoveset() end)

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == KEY_CHINH_XAC then
        if CurrentKeyTarget=="TECH" then TechUnlocked=true; LoadTech()
        elseif CurrentKeyTarget=="SCRIPT" then ScriptUnlocked=true; LoadScript() end
        KeyFrame.Visible=false; ContentFrame.Visible=true
    else
        KeyInput.Text=""
        KeyInput.PlaceholderText="❌  Sai Key rồi!"
        KeyInput.PlaceholderColor3 = Color3.fromRGB(255,80,80)
        task.wait(1.2)
        KeyInput.PlaceholderText="Nhập Key tại đây..."
        KeyInput.PlaceholderColor3 = C.SUB
    end
end)

-- ══════════════════════════════════════════
--   OPEN BUTTON
-- ══════════════════════════════════════════
local OpenBtn = Instance.new("ImageButton")
OpenBtn.Size = UDim2.new(0,48,0,48)
OpenBtn.Position = UDim2.new(0,14,0.5,-24)
OpenBtn.Image = ID_LOGO_DONG
OpenBtn.BackgroundColor3 = C.PANEL
OpenBtn.Visible = false
OpenBtn.Draggable = true
OpenBtn.ZIndex = 5
OpenBtn.Parent = ScreenGui
corner(OpenBtn, 12)
stroke(OpenBtn, 1.5, 0.2)
glowOrb(OpenBtn, 0.85)

CloseBtn.MouseButton1Click:Connect(function()
    Root.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    Root.Visible = true
    OpenBtn.Visible = false
end)

setActive(FPSTab)
LoadFPS()
