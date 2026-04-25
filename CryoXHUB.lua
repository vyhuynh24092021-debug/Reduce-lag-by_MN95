-- CryoXHUB GUI v3.4
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

local C = {
	BG     = Color3.fromRGB(4,   8,  18),
	PANEL  = Color3.fromRGB(8,  16,  32),
	PANEL2 = Color3.fromRGB(12, 22,  42),
	CYAN   = Color3.fromRGB(0,  210, 255),
	TEXT   = Color3.fromRGB(220,240, 255),
	SUB    = Color3.fromRGB(100,160, 200),
	RED    = Color3.fromRGB(200, 50,  50),
	GREEN  = Color3.fromRGB(50,  220, 120),
}

local function tw(obj, props, t, style, dir)
	TweenService:Create(obj, TweenInfo.new(
		t or 0.25,
		style or Enum.EasingStyle.Quint,
		dir   or Enum.EasingDirection.Out
	), props):Play()
end
local function corner(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 10)
	c.Parent = p
end
local function stroke(p, t, tr)
	local s = Instance.new("UIStroke")
	s.Color = C.CYAN
	s.Thickness = t or 1.5
	s.Transparency = tr or 0.2
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = p
	return s
end
local function glowOrb(p, tr)
	local g = Instance.new("ImageLabel")
	g.Size = UDim2.new(1,50,1,50)
	g.Position = UDim2.new(0,-25,0,-25)
	g.BackgroundTransparency = 1
	g.Image = "rbxassetid://5028857084"
	g.ImageColor3 = C.CYAN
	g.ImageTransparency = tr or 0.88
	g.ZIndex = (p.ZIndex or 1) - 1
	g.Parent = p
end

-- KÍCH THƯỚC
local PAD       = 5
local GAP       = 5
local LEFT_W    = 148
local ROOT_H    = 340
local TAB_H     = 34
local ROOT_W    = 560
local RIGHT_W   = ROOT_W - PAD*2 - LEFT_W - GAP
local AVATAR_H  = 148
local UPDATE_H  = ROOT_H - PAD*2 - AVATAR_H - GAP
local CONTENT_H = ROOT_H - PAD*2 - TAB_H - GAP

-- ══════════════════════════════════════════
--   ROOT
-- ══════════════════════════════════════════
local Root = Instance.new("Frame")
Root.Size = UDim2.new(0,ROOT_W,0,ROOT_H)
Root.Position = UDim2.new(0.5,-ROOT_W/2,0.5,-ROOT_H/2)
Root.BackgroundColor3 = C.BG
Root.BorderSizePixel = 0
Root.Active = true
Root.Draggable = true
Root.ZIndex = 2
Root.ClipsDescendants = true
Root.Visible = false
Root.Parent = ScreenGui
corner(Root, 14)
stroke(Root, 1.8, 0.08)
glowOrb(Root, 0.88)

local RootBg = Instance.new("ImageLabel")
RootBg.Size = UDim2.new(1,0,1,0)
RootBg.BackgroundTransparency = 1
RootBg.Image = ID_ANH_NEN
RootBg.ImageTransparency = 0.93
RootBg.ScaleType = Enum.ScaleType.Crop
RootBg.ZIndex = 1
RootBg.Parent = Root
corner(RootBg, 14)

local RootPad = Instance.new("UIPadding")
RootPad.PaddingTop    = UDim.new(0,PAD)
RootPad.PaddingBottom = UDim.new(0,PAD)
RootPad.PaddingLeft   = UDim.new(0,PAD)
RootPad.PaddingRight  = UDim.new(0,PAD)
RootPad.Parent = Root

local RootLayout = Instance.new("UIListLayout")
RootLayout.FillDirection = Enum.FillDirection.Horizontal
RootLayout.Padding = UDim.new(0,GAP)
RootLayout.Parent = Root

-- ══════════════════════════════════════════
--   KEY OVERLAY
-- ══════════════════════════════════════════
local KeyOverlay = Instance.new("Frame")
KeyOverlay.Size = UDim2.new(1,0,1,0)
KeyOverlay.Position = UDim2.new(0,0,0,0)
KeyOverlay.BackgroundColor3 = C.BG
KeyOverlay.BackgroundTransparency = 0.05
KeyOverlay.BorderSizePixel = 0
KeyOverlay.ZIndex = 20
KeyOverlay.Visible = true
KeyOverlay.Parent = Root
corner(KeyOverlay, 14)

local KeyOverlayBg = Instance.new("ImageLabel")
KeyOverlayBg.Size = UDim2.new(1,0,1,0)
KeyOverlayBg.BackgroundTransparency = 1
KeyOverlayBg.Image = ID_ANH_NEN
KeyOverlayBg.ImageTransparency = 0.55
KeyOverlayBg.ScaleType = Enum.ScaleType.Stretch
KeyOverlayBg.ZIndex = 20
KeyOverlayBg.Parent = KeyOverlay
corner(KeyOverlayBg, 14)

local KeyDark = Instance.new("Frame")
KeyDark.Size = UDim2.new(1,0,1,0)
KeyDark.BackgroundColor3 = C.BG
KeyDark.BackgroundTransparency = 0.45
KeyDark.BorderSizePixel = 0
KeyDark.ZIndex = 21
KeyDark.Parent = KeyOverlay
corner(KeyDark, 14)

local KeyGlow = Instance.new("ImageLabel")
KeyGlow.Size = UDim2.new(0,300,0,300)
KeyGlow.Position = UDim2.new(0.5,-150,0.5,-150)
KeyGlow.BackgroundTransparency = 1
KeyGlow.Image = "rbxassetid://5028857084"
KeyGlow.ImageColor3 = C.CYAN
KeyGlow.ImageTransparency = 0.72
KeyGlow.ZIndex = 22
KeyGlow.Parent = KeyOverlay

local KeyIcon = Instance.new("TextLabel")
KeyIcon.Size = UDim2.new(1,0,0,40)
KeyIcon.Position = UDim2.new(0,0,0.1,0)
KeyIcon.BackgroundTransparency = 1
KeyIcon.Text = "🔐"
KeyIcon.TextSize = 28
KeyIcon.ZIndex = 23
KeyIcon.Parent = KeyOverlay

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1,-20,0,22)
KeyTitle.Position = UDim2.new(0,10,0.1,44)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "Nhập key đi"
KeyTitle.TextColor3 = C.CYAN
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 15
KeyTitle.ZIndex = 23
KeyTitle.Parent = KeyOverlay

local KeySub = Instance.new("TextLabel")
KeySub.Size = UDim2.new(1,-20,0,16)
KeySub.Position = UDim2.new(0,10,0.1,68)
KeySub.BackgroundTransparency = 1
KeySub.Text = "Key: CryoXHUB"
KeySub.TextColor3 = C.SUB
KeySub.Font = Enum.Font.Gotham
KeySub.TextSize = 11
KeySub.ZIndex = 23
KeySub.Parent = KeyOverlay

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.75,0,0,38)
KeyInput.Position = UDim2.new(0.125,0,0.48,0)
KeyInput.BackgroundColor3 = C.PANEL2
KeyInput.PlaceholderText = "Nhập Key tại đây..."
KeyInput.Text = ""
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 13
KeyInput.TextColor3 = C.TEXT
KeyInput.PlaceholderColor3 = C.SUB
KeyInput.ZIndex = 24
KeyInput.Parent = KeyOverlay
corner(KeyInput, 9)
stroke(KeyInput, 1.5, 0.2)

local KeyStatus = Instance.new("TextLabel")
KeyStatus.Size = UDim2.new(1,-20,0,16)
KeyStatus.Position = UDim2.new(0,10,0.48,42)
KeyStatus.BackgroundTransparency = 1
KeyStatus.Text = ""
KeyStatus.TextColor3 = C.RED
KeyStatus.Font = Enum.Font.Gotham
KeyStatus.TextSize = 11
KeyStatus.ZIndex = 23
KeyStatus.Parent = KeyOverlay

local KeySubmit = Instance.new("TextButton")
KeySubmit.Size = UDim2.new(0.75,0,0,36)
KeySubmit.Position = UDim2.new(0.125,0,0.48,62)
KeySubmit.BackgroundColor3 = C.CYAN
KeySubmit.Text = "XÁC NHẬN"
KeySubmit.Font = Enum.Font.GothamBold
KeySubmit.TextSize = 13
KeySubmit.TextColor3 = C.BG
KeySubmit.ZIndex = 24
KeySubmit.Parent = KeyOverlay
corner(KeySubmit, 9)

KeySubmit.MouseEnter:Connect(function()
	tw(KeySubmit, {BackgroundColor3 = Color3.fromRGB(0,240,255)}, 0.12)
end)
KeySubmit.MouseLeave:Connect(function()
	tw(KeySubmit, {BackgroundColor3 = C.CYAN}, 0.12)
end)

-- ══════════════════════════════════════════
--   LEFT COLUMN
-- ══════════════════════════════════════════
local LeftCol = Instance.new("Frame")
LeftCol.Size = UDim2.new(0,LEFT_W,1,0)
LeftCol.BackgroundTransparency = 1
LeftCol.BorderSizePixel = 0
LeftCol.ZIndex = 3
LeftCol.Parent = Root

local LeftLayout = Instance.new("UIListLayout")
LeftLayout.FillDirection = Enum.FillDirection.Vertical
LeftLayout.Padding = UDim.new(0,GAP)
LeftLayout.Parent = LeftCol

local AvatarCard = Instance.new("Frame")
AvatarCard.Size = UDim2.new(1,0,0,AVATAR_H)
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
AvatarCardBg.ImageTransparency = 0.78
AvatarCardBg.ScaleType = Enum.ScaleType.Crop
AvatarCardBg.ZIndex = 3
AvatarCardBg.Parent = AvatarCard
corner(AvatarCardBg, 10)

local AvatarGlow = Instance.new("ImageLabel")
AvatarGlow.Size = UDim2.new(0,70,0,70)
AvatarGlow.Position = UDim2.new(0.5,-35,0,2)
AvatarGlow.BackgroundTransparency = 1
AvatarGlow.Image = "rbxassetid://5028857084"
AvatarGlow.ImageColor3 = C.CYAN
AvatarGlow.ImageTransparency = 0.70
AvatarGlow.ZIndex = 4
AvatarGlow.Parent = AvatarCard

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0,54,0,54)
AvatarImg.Position = UDim2.new(0.5,-27,0,10)
AvatarImg.BackgroundColor3 = C.PANEL2
AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150"
AvatarImg.ZIndex = 5
AvatarImg.Parent = AvatarCard
corner(AvatarImg, 999)
stroke(AvatarImg, 2, 0.05)

local DName = Instance.new("TextLabel")
DName.Size = UDim2.new(1,-6,0,18)
DName.Position = UDim2.new(0,3,0,68)
DName.BackgroundTransparency = 1
DName.Text = LocalPlayer.DisplayName
DName.TextColor3 = C.TEXT
DName.Font = Enum.Font.GothamBold
DName.TextSize = 12
DName.TextXAlignment = Enum.TextXAlignment.Center
DName.ZIndex = 5
DName.Parent = AvatarCard

local UName = Instance.new("TextLabel")
UName.Size = UDim2.new(1,-6,0,14)
UName.Position = UDim2.new(0,3,0,85)
UName.BackgroundTransparency = 1
UName.Text = "@"..LocalPlayer.Name
UName.TextColor3 = C.CYAN
UName.Font = Enum.Font.Gotham
UName.TextSize = 10
UName.TextXAlignment = Enum.TextXAlignment.Center
UName.ZIndex = 5
UName.Parent = AvatarCard

local ADiv = Instance.new("Frame")
ADiv.Size = UDim2.new(1,-16,0,1)
ADiv.Position = UDim2.new(0,8,0,103)
ADiv.BackgroundColor3 = C.CYAN
ADiv.BackgroundTransparency = 0.55
ADiv.BorderSizePixel = 0
ADiv.ZIndex = 4
ADiv.Parent = AvatarCard

local UIDLabel = Instance.new("TextLabel")
UIDLabel.Size = UDim2.new(1,-6,0,13)
UIDLabel.Position = UDim2.new(0,3,0,107)
UIDLabel.BackgroundTransparency = 1
UIDLabel.Text = "UID: "..LocalPlayer.UserId
UIDLabel.TextColor3 = C.SUB
UIDLabel.Font = Enum.Font.Gotham
UIDLabel.TextSize = 9
UIDLabel.TextXAlignment = Enum.TextXAlignment.Center
UIDLabel.ZIndex = 5
UIDLabel.Parent = AvatarCard

local VerLbl = Instance.new("TextLabel")
VerLbl.Size = UDim2.new(1,-6,0,13)
VerLbl.Position = UDim2.new(0,3,0,128)
VerLbl.BackgroundTransparency = 1
VerLbl.Text = "CryoXHUB  v3.4"
VerLbl.TextColor3 = C.CYAN
VerLbl.Font = Enum.Font.GothamBold
VerLbl.TextSize = 9
VerLbl.TextXAlignment = Enum.TextXAlignment.Center
VerLbl.ZIndex = 5
VerLbl.Parent = AvatarCard

local UpdateCard = Instance.new("Frame")
UpdateCard.Size = UDim2.new(1,0,0,UPDATE_H)
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
UpdateTitle.Size = UDim2.new(1,-10,0,20)
UpdateTitle.Position = UDim2.new(0,7,0,5)
UpdateTitle.BackgroundTransparency = 1
UpdateTitle.Text = "  Update Log"
UpdateTitle.TextColor3 = C.CYAN
UpdateTitle.Font = Enum.Font.GothamBold
UpdateTitle.TextSize = 10
UpdateTitle.TextXAlignment = Enum.TextXAlignment.Left
UpdateTitle.ZIndex = 5
UpdateTitle.Parent = UpdateCard

local UDiv = Instance.new("Frame")
UDiv.Size = UDim2.new(1,-12,0,1)
UDiv.Position = UDim2.new(0,6,0,25)
UDiv.BackgroundColor3 = C.CYAN
UDiv.BackgroundTransparency = 0.55
UDiv.BorderSizePixel = 0
UDiv.ZIndex = 4
UDiv.Parent = UpdateCard

local UpdateScroll = Instance.new("ScrollingFrame")
UpdateScroll.Size = UDim2.new(1,-6,1,-28)
UpdateScroll.Position = UDim2.new(0,3,0,27)
UpdateScroll.BackgroundTransparency = 1
UpdateScroll.BorderSizePixel = 0
UpdateScroll.ScrollBarThickness = 2
UpdateScroll.ScrollBarImageColor3 = C.CYAN
UpdateScroll.CanvasSize = UDim2.new(0,0,0,0)
UpdateScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
UpdateScroll.ZIndex = 5
UpdateScroll.Parent = UpdateCard

local UL = Instance.new("UIListLayout", UpdateScroll)
UL.Padding = UDim.new(0,3)
local UP2 = Instance.new("UIPadding", UpdateScroll)
UP2.PaddingTop = UDim.new(0,2)

local updates = {
	{"v3.4","Key overlay che GUI, 1 lần"},
	{"v3.3","Key mỗi lần vào, đơn giản"},
	{"v3.2","Key trong content, ẩn tab"},
	{"v3.0","Tăng kích thước right panel"},
	{"v3.0","Xóa viền accent thừa"},
	{"v2.1","Fix animation + kích thước"},
	{"v2.0","Redesign toàn bộ GUI"},
	{"v2.0","Thêm Info & Update panel"},
}
for _, u in ipairs(updates) do
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1,-2,0,22)
	row.BackgroundColor3 = C.PANEL2
	row.BorderSizePixel = 0
	row.ZIndex = 6
	row.Parent = UpdateScroll
	corner(row, 5)
	local ver = Instance.new("TextLabel")
	ver.Size = UDim2.new(0,30,1,0)
	ver.Position = UDim2.new(0,3,0,0)
	ver.BackgroundTransparency = 1
	ver.Text = u[1]
	ver.TextColor3 = C.CYAN
	ver.Font = Enum.Font.GothamBold
	ver.TextSize = 8
	ver.ZIndex = 7
	ver.Parent = row
	local desc = Instance.new("TextLabel")
	desc.Size = UDim2.new(1,-34,1,0)
	desc.Position = UDim2.new(0,32,0,0)
	desc.BackgroundTransparency = 1
	desc.Text = u[2]
	desc.TextColor3 = C.SUB
	desc.Font = Enum.Font.Gotham
	desc.TextSize = 8
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.TextWrapped = true
	desc.ZIndex = 7
	desc.Parent = row
end

-- ══════════════════════════════════════════
--   RIGHT COLUMN
-- ══════════════════════════════════════════
local RightCol = Instance.new("Frame")
RightCol.Size = UDim2.new(0,RIGHT_W,1,0)
RightCol.BackgroundTransparency = 1
RightCol.BorderSizePixel = 0
RightCol.ZIndex = 3
RightCol.Parent = Root

local RightLayout = Instance.new("UIListLayout")
RightLayout.FillDirection = Enum.FillDirection.Vertical
RightLayout.Padding = UDim.new(0,GAP)
RightLayout.Parent = RightCol

local TabRow = Instance.new("Frame")
TabRow.Size = UDim2.new(1,0,0,TAB_H)
TabRow.BackgroundTransparency = 1
TabRow.BorderSizePixel = 0
TabRow.ZIndex = 4
TabRow.Parent = RightCol

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1,-(TAB_H+GAP),1,0)
TabBar.BackgroundColor3 = C.PANEL
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 4
TabBar.Parent = TabRow
corner(TabBar, 9)
stroke(TabBar, 1.2, 0.2)

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Size = UDim2.new(1,-6,1,-2)
TabScroll.Position = UDim2.new(0,3,0,1)
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
TabLayout.Padding = UDim.new(0,4)
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Parent = TabScroll

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,TAB_H,0,TAB_H)
CloseBtn.Position = UDim2.new(1,-TAB_H,0,0)
CloseBtn.BackgroundColor3 = C.RED
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = C.TEXT
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.ZIndex = 6
CloseBtn.Parent = TabRow
corner(CloseBtn, 9)
CloseBtn.MouseEnter:Connect(function()
	tw(CloseBtn, {BackgroundColor3 = Color3.fromRGB(240,70,70)}, 0.12)
end)
CloseBtn.MouseLeave:Connect(function()
	tw(CloseBtn, {BackgroundColor3 = C.RED}, 0.12)
end)

local ContentBg = Instance.new("Frame")
ContentBg.Size = UDim2.new(1,0,0,CONTENT_H)
ContentBg.BackgroundColor3 = C.PANEL
ContentBg.BorderSizePixel = 0
ContentBg.ClipsDescendants = true
ContentBg.ZIndex = 3
ContentBg.Parent = RightCol
corner(ContentBg, 10)
stroke(ContentBg, 1.2, 0.2)

local ContentBgImg = Instance.new("ImageLabel")
ContentBgImg.Size = UDim2.new(1,0,1,0)
ContentBgImg.BackgroundTransparency = 1
ContentBgImg.Image = ID_ANH_NEN
ContentBgImg.ImageTransparency = 0.42
ContentBgImg.ScaleType = Enum.ScaleType.Stretch
ContentBgImg.ZIndex = 3
ContentBgImg.Parent = ContentBg
corner(ContentBgImg, 10)

local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1,0,1,0)
Overlay.BackgroundColor3 = C.BG
Overlay.BackgroundTransparency = 0.48
Overlay.BorderSizePixel = 0
Overlay.ZIndex = 4
Overlay.Parent = ContentBg
corner(Overlay, 10)

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1,-8,1,-8)
ContentFrame.Position = UDim2.new(0,4,0,4)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ZIndex = 6
ContentFrame.CanvasSize = UDim2.new(0,0,0,0)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.ScrollBarThickness = 2
ContentFrame.ScrollBarImageColor3 = C.CYAN
ContentFrame.Parent = ContentBg

local CLayout = Instance.new("UIListLayout")
CLayout.Padding = UDim.new(0,5)
CLayout.Parent = ContentFrame

local CPad = Instance.new("UIPadding")
CPad.PaddingTop    = UDim.new(0,3)
CPad.PaddingBottom = UDim.new(0,3)
CPad.Parent = ContentFrame

-- ══════════════════════════════════════════
--   OPEN BUTTON
-- ══════════════════════════════════════════
local OpenBtn = Instance.new("ImageButton")
OpenBtn.Size = UDim2.new(0,46,0,46)
OpenBtn.Position = UDim2.new(0,12,0.5,-23)
OpenBtn.Image = ID_LOGO_DONG
OpenBtn.BackgroundColor3 = C.PANEL
OpenBtn.Visible = false
OpenBtn.Draggable = true
OpenBtn.ZIndex = 5
OpenBtn.Parent = ScreenGui
corner(OpenBtn, 10)
stroke(OpenBtn, 1.5, 0.15)
glowOrb(OpenBtn, 0.82)

-- ══════════════════════════════════════════
--   ANIMATIONS
-- ══════════════════════════════════════════
local function animateOpen()
	Root.Visible = true
	Root.Size = UDim2.new(0, ROOT_W * 0.9, 0, ROOT_H * 0.9)
	Root.Position = UDim2.new(0.5, -(ROOT_W * 0.9) / 2, 0.5, -(ROOT_H * 0.9) / 2)
	Root.BackgroundTransparency = 1
	tw(Root, {
		Size = UDim2.new(0, ROOT_W, 0, ROOT_H),
		Position = UDim2.new(0.5, -ROOT_W / 2, 0.5, -ROOT_H / 2),
		BackgroundTransparency = 0,
	}, 0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
end

local function animateClose(cb)
	tw(Root, {
		Size = UDim2.new(0, ROOT_W * 0.9, 0, ROOT_H * 0.9),
		Position = UDim2.new(0.5, -(ROOT_W * 0.9) / 2, 0.5, -(ROOT_H * 0.9) / 2),
		BackgroundTransparency = 1,
	}, 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	task.wait(0.26)
	Root.Visible = false
	if cb then cb() end
end

-- ══════════════════════════════════════════
--   TAB SLIDE
-- ══════════════════════════════════════════
local currentTabIndex = 1
local isSliding = false

local function slideContent(newIndex, loadFunc)
	if isSliding then return end
	isSliding = true
	local W = ContentBg.AbsoluteSize.X
	local goRight = newIndex > currentTabIndex
	currentTabIndex = newIndex
	local exitX  = goRight and -W or W
	local enterX = goRight and  W or -W
	tw(ContentFrame, {Position = UDim2.new(0, exitX, 0, 4)},
		0.18, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
	task.wait(0.19)
	for _, v in pairs(ContentFrame:GetChildren()) do
		if v:IsA("TextButton") or v:IsA("Frame") then v:Destroy() end
	end
	ContentFrame.CanvasPosition = Vector2.new(0, 0)
	loadFunc()
	ContentFrame.Position = UDim2.new(0, enterX, 0, 4)
	tw(ContentFrame, {Position = UDim2.new(0, 4, 0, 4)},
		0.22, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
	task.wait(0.23)
	isSliding = false
end

-- ══════════════════════════════════════════
--   TAB FACTORIES
-- ══════════════════════════════════════════
local activeTab = nil

local function setActive(btn, index, loadFunc)
	if activeTab == btn or isSliding then return end
	if activeTab then
		tw(activeTab, {BackgroundColor3 = C.PANEL2}, 0.2)
		activeTab.TextColor3 = C.SUB
		local s = activeTab:FindFirstChildOfClass("UIStroke")
		if s then tw(s, {Transparency = 0.6}, 0.2) end
	end
	activeTab = btn
	tw(btn, {BackgroundColor3 = Color3.fromRGB(0, 50, 90)}, 0.2)
	btn.TextColor3 = C.CYAN
	local s = btn:FindFirstChildOfClass("UIStroke")
	if s then tw(s, {Transparency = 0}, 0.2) end
	if loadFunc then
		task.spawn(function() slideContent(index, loadFunc) end)
	end
end

local function clearContent()
	for _, v in pairs(ContentFrame:GetChildren()) do
		if v:IsA("TextButton") or v:IsA("Frame") then v:Destroy() end
	end
end

local function makeScriptBtn(name, code)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,-4,0,36)
	btn.Text = ""
	btn.BackgroundColor3 = C.PANEL2
	btn.ZIndex = 7
	btn.Parent = ContentFrame
	corner(btn, 8)
	stroke(btn, 1.2, 0.5)
	local iconL = Instance.new("TextLabel")
	iconL.Size = UDim2.new(0,28,1,0)
	iconL.Position = UDim2.new(0,5,0,0)
	iconL.BackgroundTransparency = 1
	iconL.Text = "▶"
	iconL.TextColor3 = C.CYAN
	iconL.Font = Enum.Font.GothamBold
	iconL.TextSize = 12
	iconL.ZIndex = 8
	iconL.Parent = btn
	local nameL = Instance.new("TextLabel")
	nameL.Size = UDim2.new(1,-36,1,0)
	nameL.Position = UDim2.new(0,30,0,0)
	nameL.BackgroundTransparency = 1
	nameL.Text = name
	nameL.TextColor3 = C.TEXT
	nameL.Font = Enum.Font.GothamBold
	nameL.TextSize = 12
	nameL.TextXAlignment = Enum.TextXAlignment.Left
	nameL.ZIndex = 8
	nameL.Parent = btn
	btn.MouseEnter:Connect(function()
		tw(btn, {BackgroundColor3 = Color3.fromRGB(0,38,68)}, 0.12)
		tw(nameL, {TextColor3 = C.CYAN}, 0.12)
	end)
	btn.MouseLeave:Connect(function()
		tw(btn, {BackgroundColor3 = C.PANEL2}, 0.12)
		tw(nameL, {TextColor3 = C.TEXT}, 0.12)
	end)
	btn.MouseButton1Click:Connect(function()
		tw(btn, {BackgroundColor3 = Color3.fromRGB(0,65,100)}, 0.08)
		task.wait(0.1)
		tw(btn, {BackgroundColor3 = C.PANEL2}, 0.18)
		local f, e = loadstring(code)
		if f then task.spawn(f) else warn(e) end
	end)
end

local function makeTab(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0,74,0,26)
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
		if activeTab ~= btn then tw(btn, {BackgroundColor3 = Color3.fromRGB(0,26,50)}, 0.12) end
	end)
	btn.MouseLeave:Connect(function()
		if activeTab ~= btn then tw(btn, {BackgroundColor3 = C.PANEL2}, 0.12) end
	end)
	return btn
end

-- CONTENT LOADERS
local function LoadFPS()
	makeScriptBtn("CryoX Anti-Lag",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/CryoX%20Anti-Lag.lua"))()]])
end
local function LoadTech()
	makeScriptBtn("Supa Tech",         [[loadstring(game:HttpGet("https://rawscripts.net/raw/The-Strongest-Battlegrounds-Supa-tech-v2-77454"))()]])
	makeScriptBtn("Kiba Tech",         [[loadstring(game:HttpGet("https://raw.githubusercontent.com/yqantg-pixel/Find/refs/heads/main/Protected_1593573630798166.lua.txt"))()]])
	makeScriptBtn("Oreo Tech",         [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/OreoTech/refs/heads/main/Protected_6856895483929371.lua"))()]])
	makeScriptBtn("Lethal Dash",       [[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/57a4d240a2440f0450986c966469092ccfb8d4797392cb8f469fa8b6e605e64d/download"))()]])
	makeScriptBtn("Back Dash Cancel",  [[loadstring(game:HttpGet("https://raw.githubusercontent.com/dinhthanhtuankiet1762009-sudo/Js/refs/heads/main/4418648b0e9b71ef.lua"))()]])
	makeScriptBtn("Instant Twisted v2",[[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/60a7a7c77395006ebd63fce0a17c13241f932bd414c9aba3158b716da00ade01/download"))()]])
	makeScriptBtn("Loop Dash",         [[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/28513f51c0ca2c03d4d7d94f59215d13ce1a2a470bf187f0a685b58ccb4dae98/download"))()]])
end
local function LoadShader()
	makeScriptBtn("Custom Shader",[[loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Simple-Shader-37434"))()]])
end
local function LoadScript()
	makeScriptBtn("Fly GuiV3",         [[loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()]])
	makeScriptBtn("Anti Death Counter",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Anti-Death-Counter.lua"))()]])
	makeScriptBtn("Avatar Changer",    [[loadstring(game:HttpGet("https://raw.githubusercontent.com/darkdexv2/universalavatarchanger/main/avatarchanger"))()]])
	makeScriptBtn("Dex Explorer",      [[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Dex_Explorer_v2.lua"))()]])
	makeScriptBtn("Shield",            [[Instance.new("ForceField",game.Players.LocalPlayer.Character)]])
	makeScriptBtn("TouchFling",        [[loadstring(game:HttpGet("https://raw.githubusercontent.com/long191910/all-my-roblox-script/refs/heads/main/touchfling.lua"))()]])
end
local function LoadAura()
	makeScriptBtn("Blue Flame Aura",    [[loadstring(game:HttpGet("Link_Script_Aura_Tai_Day"))()]])
	makeScriptBtn("Ultra Instinct Aura",[[loadstring(game:HttpGet("Link_Script_Aura_2"))()]])
end
local function LoadMoveset()
	makeScriptBtn("KAR [SAITAMA]",  [[loadstring(game:HttpGet("https://raw.githubusercontent.com/OfficialAposty/RBLX-Scripts/refs/heads/main/UltimateLifeForm.lua"))()]])
	makeScriptBtn("Gojo [SAITAMA]", [[getgenv().morph=false
loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/BaldyToSorcerer/refs/heads/main/LatestV2.lua"))()]])
	makeScriptBtn("CHARA [SAITAMA]",[[loadstring(game:HttpGet("https://pastefy.app/gFRaeMGz/raw"))()]])
end

-- REGISTER TABS
local FPSTab     = makeTab("FPS")
local TechTab    = makeTab("TECH")
local ShaderTab  = makeTab("SHADER")
local ScriptTab  = makeTab("SCRIPT")
local AuraTab    = makeTab("AURA")
local MovesetTab = makeTab("MOVESET")

FPSTab.MouseButton1Click:Connect(function()     setActive(FPSTab,1,LoadFPS) end)
TechTab.MouseButton1Click:Connect(function()    setActive(TechTab,2,LoadTech) end)
ShaderTab.MouseButton1Click:Connect(function()  setActive(ShaderTab,3,LoadShader) end)
ScriptTab.MouseButton1Click:Connect(function()  setActive(ScriptTab,4,LoadScript) end)
AuraTab.MouseButton1Click:Connect(function()    setActive(AuraTab,5,LoadAura) end)
MovesetTab.MouseButton1Click:Connect(function() setActive(MovesetTab,6,LoadMoveset) end)

-- ══════════════════════════════════════════
--   KEY SUBMIT — FIX: dùng task.spawn để
--   không block, và ẩn overlay trước khi
--   load tab
-- ══════════════════════════════════════════
KeySubmit.MouseButton1Click:Connect(function()
	if KeyInput.Text == KEY_CHINH_XAC then
		KeyStatus.Text = "✓  Đúng! Đang mở..."
		KeyStatus.TextColor3 = C.GREEN
		tw(KeySubmit, {BackgroundColor3 = C.GREEN}, 0.2)
		task.wait(0.5)

		-- Fade overlay ra
		tw(KeyOverlay, {BackgroundTransparency = 1}, 0.35)
		for _, v in pairs(KeyOverlay:GetChildren()) do
			if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
				tw(v, {TextTransparency = 1}, 0.3)
			elseif v:IsA("ImageLabel") then
				tw(v, {ImageTransparency = 1}, 0.3)
			elseif v:IsA("Frame") then
				tw(v, {BackgroundTransparency = 1}, 0.3)
			end
		end
		task.wait(0.38)
		KeyOverlay.Visible = false

		-- Load tab mặc định sau khi ẩn overlay
		clearContent()
		setActive(FPSTab, 1, LoadFPS)
	else
		KeyInput.Text = ""
		KeyStatus.Text = "❌  Sai Key! Thử lại."
		KeyStatus.TextColor3 = C.RED
		local orig = KeyInput.Position
		for i = 1, 5 do
			tw(KeyInput, {Position = orig + UDim2.new(0, i%2==0 and 7 or -7, 0, 0)}, 0.04)
			task.wait(0.045)
		end
		tw(KeyInput, {Position = orig}, 0.07)
		task.wait(1.5)
		KeyStatus.Text = ""
	end
end)

-- CLOSE / OPEN
CloseBtn.MouseButton1Click:Connect(function()
	animateClose(function()
		OpenBtn.Visible = true
		OpenBtn.Size = UDim2.new(0,26,0,26)
		tw(OpenBtn, {Size = UDim2.new(0,46,0,46)}, 0.3,
			Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	end)
end)

OpenBtn.MouseButton1Click:Connect(function()
	OpenBtn.Visible = false
	animateOpen()
end)

-- STARTUP
task.wait(0.25)
animateOpen()
