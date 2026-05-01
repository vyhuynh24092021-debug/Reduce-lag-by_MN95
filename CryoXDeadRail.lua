-- CryoXHUB x Dead Rails - Integrated
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CryoX_Furina_Final_v6"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local RunService      = game:GetService("RunService")
local HttpService     = game:GetService("HttpService")
local UserInputService= game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer     = Players.LocalPlayer

local ID_ANH_NEN    = "rbxthumb://type=Asset&id=116367849760314&w=420&h=420"
local ID_LOGO_DONG  = "rbxthumb://type=Asset&id=135753950157111&w=420&h=420"
local KEY_CHINH_XAC = "CryoXHUB"
local SAVE_FILE     = "CryoXHUB_save.json"

-- ══════════════════════════════════════════
--   SAVE SYSTEM
-- ══════════════════════════════════════════
local DEFAULT_SAVE = {
	keyVerified = false,
	keyTime     = 0,
	accentR     = 0,
	accentG     = 210,
	accentB     = 255,
}

local function loadSave()
	local ok, result = pcall(function()
		if isfile and isfile(SAVE_FILE) then
			return HttpService:JSONDecode(readfile(SAVE_FILE))
		end
	end)
	if ok and result then
		for k, v in pairs(DEFAULT_SAVE) do
			if result[k] == nil then result[k] = v end
		end
		return result
	end
	return DEFAULT_SAVE
end

local function writeSave(data)
	pcall(function() writefile(SAVE_FILE, HttpService:JSONEncode(data)) end)
end

local SaveData = loadSave()

-- ══════════════════════════════════════════
--   KEY CHECK
-- ══════════════════════════════════════════
local keyVerified = false

local function checkKeyValid()
	if SaveData.keyVerified then
		local diff = os.time() - (SaveData.keyTime or 0)
		if diff < 86400 then return true end
		SaveData.keyVerified = false; SaveData.keyTime = 0; writeSave(SaveData)
	end
	return false
end

local function saveKeyTime()
	SaveData.keyVerified = true; SaveData.keyTime = os.time(); writeSave(SaveData)
end

keyVerified = checkKeyValid()

-- ══════════════════════════════════════════
--   COLORS
-- ══════════════════════════════════════════
local C = {
	BG     = Color3.fromRGB(4,   8,  18),
	PANEL  = Color3.fromRGB(8,  16,  32),
	PANEL2 = Color3.fromRGB(12, 22,  42),
	CYAN   = Color3.fromRGB(SaveData.accentR, SaveData.accentG, SaveData.accentB),
	TEXT   = Color3.fromRGB(220,240,255),
	SUB    = Color3.fromRGB(100,160,200),
	RED    = Color3.fromRGB(200, 50, 50),
	GREEN  = Color3.fromRGB(50, 220,120),
}

-- ══════════════════════════════════════════
--   GLOBALS (Dead Rails)
-- ══════════════════════════════════════════
_G.Gun             = false
_G.Collect         = false
_G.Items           = false
_G.Mobs            = false
_G.UnicornESP      = false
_G.Speed           = false
_G.FullBrightEnabled  = false
_G.FullBrightExecuted = false

-- ══════════════════════════════════════════
--   HELPERS
-- ══════════════════════════════════════════
local function tw(obj, props, t, style, dir)
	TweenService:Create(obj, TweenInfo.new(
		t or 0.25, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out
	), props):Play()
end

local function corner(p, r)
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 10); c.Parent = p
end

local function stroke(p, t, tr)
	local s = Instance.new("UIStroke")
	s.Color = C.CYAN; s.Thickness = t or 1.5; s.Transparency = tr or 0.2
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = p; return s
end

local function glowOrb(p, tr)
	local g = Instance.new("ImageLabel")
	g.Size = UDim2.new(1,50,1,50); g.Position = UDim2.new(0,-25,0,-25)
	g.BackgroundTransparency = 1; g.Image = "rbxassetid://5028857084"
	g.ImageColor3 = C.CYAN; g.ImageTransparency = tr or 0.88
	g.ZIndex = (p.ZIndex or 1) - 1; g.Parent = p
end

local PAD=5; local GAP=5; local LEFT_W=148; local ROOT_H=340; local TAB_H=34
local ROOT_W=560; local RIGHT_W=ROOT_W-PAD*2-LEFT_W-GAP
local AVATAR_H=148; local UPDATE_H=ROOT_H-PAD*2-AVATAR_H-GAP
local CONTENT_H=ROOT_H-PAD*2-TAB_H-GAP

-- ══════════════════════════════════════════
--   TOAST
-- ══════════════════════════════════════════
local function showToast(msg, color, duration)
	color = color or C.CYAN; duration = duration or 3
	local T = Instance.new("Frame")
	T.Size=UDim2.new(0,300,0,52); T.Position=UDim2.new(0.5,-150,1,70)
	T.BackgroundColor3=Color3.fromRGB(4,14,28); T.BorderSizePixel=0; T.ZIndex=50; T.Parent=ScreenGui; corner(T,12)
	local ts=Instance.new("UIStroke"); ts.Color=color; ts.Thickness=1.8; ts.Transparency=0.05
	ts.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; ts.Parent=T
	local tg=Instance.new("ImageLabel"); tg.Size=UDim2.new(1,40,1,40); tg.Position=UDim2.new(0,-20,0,-20)
	tg.BackgroundTransparency=1; tg.Image="rbxassetid://5028857084"; tg.ImageColor3=color
	tg.ImageTransparency=0.78; tg.ZIndex=49; tg.Parent=T
	local tb=Instance.new("Frame"); tb.Size=UDim2.new(0,4,1,-16); tb.Position=UDim2.new(0,8,0,8)
	tb.BackgroundColor3=color; tb.BorderSizePixel=0; tb.ZIndex=51; tb.Parent=T; corner(tb,3)
	local ti=Instance.new("TextLabel"); ti.Size=UDim2.new(0,28,1,0); ti.Position=UDim2.new(0,16,0,0)
	ti.BackgroundTransparency=1; ti.Text="🔵"; ti.TextSize=16; ti.ZIndex=51; ti.Parent=T
	local tm=Instance.new("TextLabel"); tm.Size=UDim2.new(1,-52,1,0); tm.Position=UDim2.new(0,46,0,0)
	tm.BackgroundTransparency=1; tm.Text=msg; tm.TextColor3=C.TEXT; tm.Font=Enum.Font.GothamBold
	tm.TextSize=11; tm.TextXAlignment=Enum.TextXAlignment.Left; tm.TextWrapped=true; tm.ZIndex=51; tm.Parent=T
	tw(T,{Position=UDim2.new(0.5,-150,1,-70)},0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
	task.wait(duration)
	tw(T,{Position=UDim2.new(0.5,-150,1,70)},0.28,Enum.EasingStyle.Quint,Enum.EasingDirection.In)
	task.wait(0.3); T:Destroy()
end

-- ══════════════════════════════════════════
--   ROOT FRAME
-- ══════════════════════════════════════════
local Root=Instance.new("Frame")
Root.Size=UDim2.new(0,ROOT_W,0,ROOT_H); Root.Position=UDim2.new(0.5,-ROOT_W/2,0.5,-ROOT_H/2)
Root.BackgroundColor3=C.BG; Root.BorderSizePixel=0; Root.Active=true; Root.Draggable=true
Root.ZIndex=2; Root.ClipsDescendants=true; Root.Visible=false; Root.Parent=ScreenGui
corner(Root,14); stroke(Root,1.8,0.08); glowOrb(Root,0.88)
local RootBg=Instance.new("ImageLabel"); RootBg.Size=UDim2.new(1,0,1,0); RootBg.BackgroundTransparency=1
RootBg.Image=ID_ANH_NEN; RootBg.ImageTransparency=0.93; RootBg.ScaleType=Enum.ScaleType.Crop
RootBg.ZIndex=1; RootBg.Parent=Root; corner(RootBg,14)
local RootPad=Instance.new("UIPadding"); RootPad.PaddingTop=UDim.new(0,PAD); RootPad.PaddingBottom=UDim.new(0,PAD)
RootPad.PaddingLeft=UDim.new(0,PAD); RootPad.PaddingRight=UDim.new(0,PAD); RootPad.Parent=Root
local RootLayout=Instance.new("UIListLayout"); RootLayout.FillDirection=Enum.FillDirection.Horizontal
RootLayout.Padding=UDim.new(0,GAP); RootLayout.Parent=Root

-- ══════════════════════════════════════════
--   KEY OVERLAY
-- ══════════════════════════════════════════
local KeyOverlay=Instance.new("Frame"); KeyOverlay.Size=UDim2.new(1,0,1,0)
KeyOverlay.BackgroundColor3=C.BG; KeyOverlay.BackgroundTransparency=0.05; KeyOverlay.BorderSizePixel=0
KeyOverlay.ZIndex=20; KeyOverlay.Visible=not keyVerified; KeyOverlay.Parent=Root; corner(KeyOverlay,14)
local KeyOverlayBg=Instance.new("ImageLabel"); KeyOverlayBg.Size=UDim2.new(1,0,1,0)
KeyOverlayBg.BackgroundTransparency=1; KeyOverlayBg.Image=ID_ANH_NEN; KeyOverlayBg.ImageTransparency=0.55
KeyOverlayBg.ScaleType=Enum.ScaleType.Stretch; KeyOverlayBg.ZIndex=20; KeyOverlayBg.Parent=KeyOverlay; corner(KeyOverlayBg,14)
local KeyDark=Instance.new("Frame"); KeyDark.Size=UDim2.new(1,0,1,0); KeyDark.BackgroundColor3=C.BG
KeyDark.BackgroundTransparency=0.45; KeyDark.BorderSizePixel=0; KeyDark.ZIndex=21; KeyDark.Parent=KeyOverlay; corner(KeyDark,14)
local KeyGlow=Instance.new("ImageLabel"); KeyGlow.Size=UDim2.new(0,300,0,300); KeyGlow.Position=UDim2.new(0.5,-150,0.5,-150)
KeyGlow.BackgroundTransparency=1; KeyGlow.Image="rbxassetid://5028857084"; KeyGlow.ImageColor3=C.CYAN
KeyGlow.ImageTransparency=0.72; KeyGlow.ZIndex=22; KeyGlow.Parent=KeyOverlay
local KeyIcon=Instance.new("TextLabel"); KeyIcon.Size=UDim2.new(1,0,0,40); KeyIcon.Position=UDim2.new(0,0,0.1,0)
KeyIcon.BackgroundTransparency=1; KeyIcon.Text="🔐"; KeyIcon.TextSize=28; KeyIcon.ZIndex=23; KeyIcon.Parent=KeyOverlay
local KeyTitle=Instance.new("TextLabel"); KeyTitle.Size=UDim2.new(1,-20,0,22); KeyTitle.Position=UDim2.new(0,10,0.1,44)
KeyTitle.BackgroundTransparency=1; KeyTitle.Text="Nhập key để mở CryoXHUB"; KeyTitle.TextColor3=C.CYAN
KeyTitle.Font=Enum.Font.GothamBold; KeyTitle.TextSize=15; KeyTitle.ZIndex=23; KeyTitle.Parent=KeyOverlay
local KeySub=Instance.new("TextLabel"); KeySub.Size=UDim2.new(1,-20,0,16); KeySub.Position=UDim2.new(0,10,0.1,68)
KeySub.BackgroundTransparency=1; KeySub.Text="Key hợp lệ trong 24 giờ  •  Key: CryoXHUB"
KeySub.TextColor3=C.SUB; KeySub.Font=Enum.Font.Gotham; KeySub.TextSize=11; KeySub.ZIndex=23; KeySub.Parent=KeyOverlay
local KeyInput=Instance.new("TextBox"); KeyInput.Size=UDim2.new(0.75,0,0,38); KeyInput.Position=UDim2.new(0.125,0,0.48,0)
KeyInput.BackgroundColor3=C.PANEL2; KeyInput.PlaceholderText="Nhập Key tại đây..."; KeyInput.Text=""
KeyInput.Font=Enum.Font.Gotham; KeyInput.TextSize=13; KeyInput.TextColor3=C.TEXT
KeyInput.PlaceholderColor3=C.SUB; KeyInput.ZIndex=24; KeyInput.Parent=KeyOverlay; corner(KeyInput,9); stroke(KeyInput,1.5,0.2)
local KeyStatus=Instance.new("TextLabel"); KeyStatus.Size=UDim2.new(1,-20,0,16); KeyStatus.Position=UDim2.new(0,10,0.48,42)
KeyStatus.BackgroundTransparency=1; KeyStatus.Text=""; KeyStatus.TextColor3=C.RED
KeyStatus.Font=Enum.Font.Gotham; KeyStatus.TextSize=11; KeyStatus.ZIndex=23; KeyStatus.Parent=KeyOverlay
local KeySubmit=Instance.new("TextButton"); KeySubmit.Size=UDim2.new(0.75,0,0,36); KeySubmit.Position=UDim2.new(0.125,0,0.48,62)
KeySubmit.BackgroundColor3=C.CYAN; KeySubmit.Text="XÁC NHẬN  (24H)"; KeySubmit.Font=Enum.Font.GothamBold
KeySubmit.TextSize=13; KeySubmit.TextColor3=C.BG; KeySubmit.ZIndex=24; KeySubmit.Parent=KeyOverlay; corner(KeySubmit,9)
KeySubmit.MouseEnter:Connect(function() tw(KeySubmit,{BackgroundColor3=Color3.fromRGB(0,240,255)},0.12) end)
KeySubmit.MouseLeave:Connect(function() tw(KeySubmit,{BackgroundColor3=C.CYAN},0.12) end)

-- ══════════════════════════════════════════
--   LEFT COLUMN
-- ══════════════════════════════════════════
local LeftCol=Instance.new("Frame"); LeftCol.Size=UDim2.new(0,LEFT_W,1,0); LeftCol.BackgroundTransparency=1
LeftCol.BorderSizePixel=0; LeftCol.ZIndex=3; LeftCol.Parent=Root
local LeftLayout=Instance.new("UIListLayout"); LeftLayout.FillDirection=Enum.FillDirection.Vertical
LeftLayout.Padding=UDim.new(0,GAP); LeftLayout.Parent=LeftCol

local AvatarCard=Instance.new("Frame"); AvatarCard.Size=UDim2.new(1,0,0,AVATAR_H)
AvatarCard.BackgroundColor3=C.PANEL; AvatarCard.BorderSizePixel=0; AvatarCard.ZIndex=3; AvatarCard.Parent=LeftCol
corner(AvatarCard,10); stroke(AvatarCard,1.2,0.2)
local AvatarCardBg=Instance.new("ImageLabel"); AvatarCardBg.Size=UDim2.new(1,0,1,0); AvatarCardBg.BackgroundTransparency=1
AvatarCardBg.Image=ID_ANH_NEN; AvatarCardBg.ImageTransparency=0.78; AvatarCardBg.ScaleType=Enum.ScaleType.Crop
AvatarCardBg.ZIndex=3; AvatarCardBg.Parent=AvatarCard; corner(AvatarCardBg,10)
local AvatarGlow=Instance.new("ImageLabel"); AvatarGlow.Size=UDim2.new(0,70,0,70); AvatarGlow.Position=UDim2.new(0.5,-35,0,2)
AvatarGlow.BackgroundTransparency=1; AvatarGlow.Image="rbxassetid://5028857084"; AvatarGlow.ImageColor3=C.CYAN
AvatarGlow.ImageTransparency=0.70; AvatarGlow.ZIndex=4; AvatarGlow.Parent=AvatarCard
local AvatarImg=Instance.new("ImageLabel"); AvatarImg.Size=UDim2.new(0,54,0,54); AvatarImg.Position=UDim2.new(0.5,-27,0,10)
AvatarImg.BackgroundColor3=C.PANEL2; AvatarImg.Image="rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150"
AvatarImg.ZIndex=5; AvatarImg.Parent=AvatarCard; corner(AvatarImg,999); stroke(AvatarImg,2,0.05)
local DName=Instance.new("TextLabel"); DName.Size=UDim2.new(1,-6,0,18); DName.Position=UDim2.new(0,3,0,68)
DName.BackgroundTransparency=1; DName.Text=LocalPlayer.DisplayName; DName.TextColor3=C.TEXT
DName.Font=Enum.Font.GothamBold; DName.TextSize=12; DName.TextXAlignment=Enum.TextXAlignment.Center
DName.ZIndex=5; DName.Parent=AvatarCard
local UName=Instance.new("TextLabel"); UName.Size=UDim2.new(1,-6,0,14); UName.Position=UDim2.new(0,3,0,85)
UName.BackgroundTransparency=1; UName.Text="@"..LocalPlayer.Name; UName.TextColor3=C.CYAN
UName.Font=Enum.Font.Gotham; UName.TextSize=10; UName.TextXAlignment=Enum.TextXAlignment.Center
UName.ZIndex=5; UName.Parent=AvatarCard
local ADiv=Instance.new("Frame"); ADiv.Size=UDim2.new(1,-16,0,1); ADiv.Position=UDim2.new(0,8,0,103)
ADiv.BackgroundColor3=C.CYAN; ADiv.BackgroundTransparency=0.55; ADiv.BorderSizePixel=0; ADiv.ZIndex=4; ADiv.Parent=AvatarCard
local UIDLabel=Instance.new("TextLabel"); UIDLabel.Size=UDim2.new(1,-6,0,13); UIDLabel.Position=UDim2.new(0,3,0,107)
UIDLabel.BackgroundTransparency=1; UIDLabel.Text="UID: "..LocalPlayer.UserId; UIDLabel.TextColor3=C.SUB
UIDLabel.Font=Enum.Font.Gotham; UIDLabel.TextSize=9; UIDLabel.TextXAlignment=Enum.TextXAlignment.Center
UIDLabel.ZIndex=5; UIDLabel.Parent=AvatarCard
local VerLbl=Instance.new("TextLabel"); VerLbl.Size=UDim2.new(1,-6,0,13); VerLbl.Position=UDim2.new(0,3,0,128)
VerLbl.BackgroundTransparency=1; VerLbl.Text="CryoXHUB  v3.6"; VerLbl.TextColor3=C.CYAN
VerLbl.Font=Enum.Font.GothamBold; VerLbl.TextSize=9; VerLbl.TextXAlignment=Enum.TextXAlignment.Center
VerLbl.ZIndex=5; VerLbl.Parent=AvatarCard

-- Update Log Card
local UpdateCard=Instance.new("Frame"); UpdateCard.Size=UDim2.new(1,0,0,UPDATE_H)
UpdateCard.BackgroundColor3=C.PANEL; UpdateCard.BorderSizePixel=0; UpdateCard.ZIndex=3; UpdateCard.Parent=LeftCol
corner(UpdateCard,10); stroke(UpdateCard,1.2,0.2)
local UpdateCardBg=Instance.new("ImageLabel"); UpdateCardBg.Size=UDim2.new(1,0,1,0)
UpdateCardBg.BackgroundTransparency=1; UpdateCardBg.Image=ID_ANH_NEN; UpdateCardBg.ImageTransparency=0.85
UpdateCardBg.ScaleType=Enum.ScaleType.Crop; UpdateCardBg.ZIndex=3; UpdateCardBg.Parent=UpdateCard; corner(UpdateCardBg,10)
local UpdateTitle=Instance.new("TextLabel"); UpdateTitle.Size=UDim2.new(1,-10,0,20); UpdateTitle.Position=UDim2.new(0,7,0,5)
UpdateTitle.BackgroundTransparency=1; UpdateTitle.Text="  Update Log"; UpdateTitle.TextColor3=C.CYAN
UpdateTitle.Font=Enum.Font.GothamBold; UpdateTitle.TextSize=10; UpdateTitle.TextXAlignment=Enum.TextXAlignment.Left
UpdateTitle.ZIndex=5; UpdateTitle.Parent=UpdateCard
local UDiv=Instance.new("Frame"); UDiv.Size=UDim2.new(1,-12,0,1); UDiv.Position=UDim2.new(0,6,0,25)
UDiv.BackgroundColor3=C.CYAN; UDiv.BackgroundTransparency=0.55; UDiv.BorderSizePixel=0; UDiv.ZIndex=4; UDiv.Parent=UpdateCard
local UpdateScroll=Instance.new("ScrollingFrame"); UpdateScroll.Size=UDim2.new(1,-6,1,-28)
UpdateScroll.Position=UDim2.new(0,3,0,27); UpdateScroll.BackgroundTransparency=1; UpdateScroll.BorderSizePixel=0
UpdateScroll.ScrollBarThickness=2; UpdateScroll.ScrollBarImageColor3=C.CYAN; UpdateScroll.CanvasSize=UDim2.new(0,0,0,0)
UpdateScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; UpdateScroll.ZIndex=5; UpdateScroll.Parent=UpdateCard
local UL=Instance.new("UIListLayout",UpdateScroll); UL.Padding=UDim.new(0,3)
local UP2=Instance.new("UIPadding",UpdateScroll); UP2.PaddingTop=UDim.new(0,2)

local updates={
	{"v3.6","Dead Rails tích hợp vào GUI"},
	{"v3.6","Tab Teleport, Combat, Visual, Misc"},
	{"v3.6","Gun Aura, Collect, ESP, Noclip"},
	{"v3.5","Tab SERVER + SETTING, Key 24H"},
	{"v3.4","Key overlay che GUI, 1 lần"},
	{"v3.0","Redesign toàn bộ GUI"},
}
for _,u in ipairs(updates) do
	local row=Instance.new("Frame"); row.Size=UDim2.new(1,-2,0,22); row.BackgroundColor3=C.PANEL2
	row.BorderSizePixel=0; row.ZIndex=6; row.Parent=UpdateScroll; corner(row,5)
	local ver=Instance.new("TextLabel"); ver.Size=UDim2.new(0,30,1,0); ver.Position=UDim2.new(0,3,0,0)
	ver.BackgroundTransparency=1; ver.Text=u[1]; ver.TextColor3=C.CYAN; ver.Font=Enum.Font.GothamBold
	ver.TextSize=8; ver.ZIndex=7; ver.Parent=row
	local desc=Instance.new("TextLabel"); desc.Size=UDim2.new(1,-34,1,0); desc.Position=UDim2.new(0,32,0,0)
	desc.BackgroundTransparency=1; desc.Text=u[2]; desc.TextColor3=C.SUB; desc.Font=Enum.Font.Gotham
	desc.TextSize=8; desc.TextXAlignment=Enum.TextXAlignment.Left; desc.TextWrapped=true; desc.ZIndex=7; desc.Parent=row
end

-- ══════════════════════════════════════════
--   RIGHT COLUMN
-- ══════════════════════════════════════════
local RightCol=Instance.new("Frame"); RightCol.Size=UDim2.new(0,RIGHT_W,1,0); RightCol.BackgroundTransparency=1
RightCol.BorderSizePixel=0; RightCol.ZIndex=3; RightCol.Parent=Root
local RightLayout=Instance.new("UIListLayout"); RightLayout.FillDirection=Enum.FillDirection.Vertical
RightLayout.Padding=UDim.new(0,GAP); RightLayout.Parent=RightCol

local TabRow=Instance.new("Frame"); TabRow.Size=UDim2.new(1,0,0,TAB_H); TabRow.BackgroundTransparency=1
TabRow.BorderSizePixel=0; TabRow.ZIndex=4; TabRow.Parent=RightCol
local TabBar=Instance.new("Frame"); TabBar.Size=UDim2.new(1,-(TAB_H+GAP),1,0)
TabBar.BackgroundColor3=C.PANEL; TabBar.BorderSizePixel=0; TabBar.ZIndex=4; TabBar.Parent=TabRow
corner(TabBar,9); stroke(TabBar,1.2,0.2)
local TabScroll=Instance.new("ScrollingFrame"); TabScroll.Size=UDim2.new(1,-6,1,-2); TabScroll.Position=UDim2.new(0,3,0,1)
TabScroll.BackgroundTransparency=1; TabScroll.BorderSizePixel=0; TabScroll.ScrollBarThickness=0
TabScroll.CanvasSize=UDim2.new(0,0,0,0); TabScroll.AutomaticCanvasSize=Enum.AutomaticSize.X
TabScroll.ScrollingDirection=Enum.ScrollingDirection.X; TabScroll.ZIndex=5; TabScroll.Parent=TabBar
local TabLayout=Instance.new("UIListLayout"); TabLayout.FillDirection=Enum.FillDirection.Horizontal
TabLayout.Padding=UDim.new(0,4); TabLayout.VerticalAlignment=Enum.VerticalAlignment.Center; TabLayout.Parent=TabScroll

local CloseBtn=Instance.new("TextButton"); CloseBtn.Size=UDim2.new(0,TAB_H,0,TAB_H); CloseBtn.Position=UDim2.new(1,-TAB_H,0,0)
CloseBtn.BackgroundColor3=C.RED; CloseBtn.Text="✕"; CloseBtn.TextColor3=C.TEXT; CloseBtn.Font=Enum.Font.GothamBold
CloseBtn.TextSize=13; CloseBtn.ZIndex=6; CloseBtn.Parent=TabRow; corner(CloseBtn,9)
CloseBtn.MouseEnter:Connect(function() tw(CloseBtn,{BackgroundColor3=Color3.fromRGB(240,70,70)},0.12) end)
CloseBtn.MouseLeave:Connect(function() tw(CloseBtn,{BackgroundColor3=C.RED},0.12) end)

local ContentBg=Instance.new("Frame"); ContentBg.Size=UDim2.new(1,0,0,CONTENT_H)
ContentBg.BackgroundColor3=C.PANEL; ContentBg.BorderSizePixel=0; ContentBg.ClipsDescendants=true
ContentBg.ZIndex=3; ContentBg.Parent=RightCol; corner(ContentBg,10); stroke(ContentBg,1.2,0.2)
local ContentBgImg=Instance.new("ImageLabel"); ContentBgImg.Size=UDim2.new(1,0,1,0); ContentBgImg.BackgroundTransparency=1
ContentBgImg.Image=ID_ANH_NEN; ContentBgImg.ImageTransparency=0.42; ContentBgImg.ScaleType=Enum.ScaleType.Stretch
ContentBgImg.ZIndex=3; ContentBgImg.Parent=ContentBg; corner(ContentBgImg,10)
local Overlay=Instance.new("Frame"); Overlay.Size=UDim2.new(1,0,1,0); Overlay.BackgroundColor3=C.BG
Overlay.BackgroundTransparency=0.48; Overlay.BorderSizePixel=0; Overlay.ZIndex=4; Overlay.Parent=ContentBg; corner(Overlay,10)

local ContentFrame=Instance.new("ScrollingFrame"); ContentFrame.Size=UDim2.new(1,-8,1,-8)
ContentFrame.Position=UDim2.new(0,4,0,4); ContentFrame.BackgroundTransparency=1; ContentFrame.ZIndex=6
ContentFrame.CanvasSize=UDim2.new(0,0,0,0); ContentFrame.AutomaticCanvasSize=Enum.AutomaticSize.Y
ContentFrame.ScrollBarThickness=2; ContentFrame.ScrollBarImageColor3=C.CYAN; ContentFrame.Parent=ContentBg
local CLayout=Instance.new("UIListLayout"); CLayout.Padding=UDim.new(0,5); CLayout.Parent=ContentFrame
local CPad=Instance.new("UIPadding"); CPad.PaddingTop=UDim.new(0,3); CPad.PaddingBottom=UDim.new(0,3); CPad.Parent=ContentFrame

local OpenBtn=Instance.new("ImageButton"); OpenBtn.Size=UDim2.new(0,46,0,46); OpenBtn.Position=UDim2.new(0,12,0.5,-23)
OpenBtn.Image=ID_LOGO_DONG; OpenBtn.BackgroundColor3=C.PANEL; OpenBtn.Visible=false; OpenBtn.Draggable=true
OpenBtn.ZIndex=5; OpenBtn.Parent=ScreenGui; corner(OpenBtn,10); stroke(OpenBtn,1.5,0.15); glowOrb(OpenBtn,0.82)

-- ══════════════════════════════════════════
--   TAB SYSTEM
-- ══════════════════════════════════════════
local currentTabIndex=1; local isSliding=false

local function slideContent(newIndex, loadFunc)
	if isSliding then return end; isSliding=true
	local W=ContentBg.AbsoluteSize.X; local goRight=newIndex>currentTabIndex; currentTabIndex=newIndex
	local exitX=goRight and -W or W; local enterX=goRight and W or -W
	tw(ContentFrame,{Position=UDim2.new(0,exitX,0,4)},0.18,Enum.EasingStyle.Cubic,Enum.EasingDirection.In)
	task.wait(0.19)
	for _,v in pairs(ContentFrame:GetChildren()) do
		if v:IsA("TextButton") or v:IsA("Frame") or v:IsA("TextLabel") then v:Destroy() end
	end
	ContentFrame.CanvasPosition=Vector2.new(0,0); loadFunc()
	ContentFrame.Position=UDim2.new(0,enterX,0,4)
	tw(ContentFrame,{Position=UDim2.new(0,4,0,4)},0.22,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out)
	task.wait(0.23); isSliding=false
end

local activeTab=nil
local function setActive(btn, index, loadFunc)
	if activeTab==btn or isSliding then return end
	if activeTab then
		tw(activeTab,{BackgroundColor3=C.PANEL2},0.2); activeTab.TextColor3=C.SUB
		local s=activeTab:FindFirstChildOfClass("UIStroke"); if s then tw(s,{Transparency=0.6},0.2) end
	end
	activeTab=btn; tw(btn,{BackgroundColor3=Color3.fromRGB(0,50,90)},0.2); btn.TextColor3=C.CYAN
	local s=btn:FindFirstChildOfClass("UIStroke"); if s then tw(s,{Transparency=0},0.2) end
	if loadFunc then task.spawn(function() slideContent(index,loadFunc) end) end
end

local function makeTab(name)
	local btn=Instance.new("TextButton"); btn.Size=UDim2.new(0,68,0,26); btn.Text=name
	btn.BackgroundColor3=C.PANEL2; btn.TextColor3=C.SUB; btn.Font=Enum.Font.GothamBold
	btn.TextSize=10; btn.ZIndex=6; btn.Parent=TabScroll; corner(btn,7); stroke(btn,1.2,0.6)
	btn.MouseEnter:Connect(function() if activeTab~=btn then tw(btn,{BackgroundColor3=Color3.fromRGB(0,26,50)},0.12) end end)
	btn.MouseLeave:Connect(function() if activeTab~=btn then tw(btn,{BackgroundColor3=C.PANEL2},0.12) end end)
	return btn
end

-- ══════════════════════════════════════════
--   UI BUILDERS
-- ══════════════════════════════════════════
local function makeSectionLabel(text)
	local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-4,0,18); lbl.BackgroundTransparency=1
	lbl.Text="── "..text.." ──"; lbl.TextColor3=C.CYAN; lbl.Font=Enum.Font.GothamBold
	lbl.TextSize=9; lbl.TextXAlignment=Enum.TextXAlignment.Center; lbl.ZIndex=7; lbl.Parent=ContentFrame
end

local function makeActionBtn(name, icon, callback)
	local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,-4,0,36); btn.Text=""
	btn.BackgroundColor3=C.PANEL2; btn.ZIndex=7; btn.Parent=ContentFrame; corner(btn,8); stroke(btn,1.2,0.5)
	local ic=Instance.new("TextLabel"); ic.Size=UDim2.new(0,28,1,0); ic.Position=UDim2.new(0,5,0,0)
	ic.BackgroundTransparency=1; ic.Text=icon; ic.TextColor3=C.CYAN; ic.Font=Enum.Font.GothamBold
	ic.TextSize=14; ic.ZIndex=8; ic.Parent=btn
	local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,-36,1,0); nl.Position=UDim2.new(0,30,0,0)
	nl.BackgroundTransparency=1; nl.Text=name; nl.TextColor3=C.TEXT; nl.Font=Enum.Font.GothamBold
	nl.TextSize=11; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.ZIndex=8; nl.Parent=btn
	btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=Color3.fromRGB(0,38,68)},0.12); tw(nl,{TextColor3=C.CYAN},0.12) end)
	btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=C.PANEL2},0.12); tw(nl,{TextColor3=C.TEXT},0.12) end)
	btn.MouseButton1Click:Connect(function()
		tw(btn,{BackgroundColor3=Color3.fromRGB(0,65,100)},0.08); task.wait(0.1); tw(btn,{BackgroundColor3=C.PANEL2},0.18)
		callback()
	end)
	return btn
end

local function makeToggle(labelText, state, onChange)
	local frame=Instance.new("Frame"); frame.Size=UDim2.new(1,-4,0,34); frame.BackgroundColor3=C.PANEL2
	frame.BorderSizePixel=0; frame.ZIndex=7; frame.Parent=ContentFrame; corner(frame,8); stroke(frame,1.2,0.5)
	local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.7,0,1,0); lbl.Position=UDim2.new(0,10,0,0)
	lbl.BackgroundTransparency=1; lbl.Text=labelText; lbl.TextColor3=C.TEXT; lbl.Font=Enum.Font.GothamBold
	lbl.TextSize=11; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=8; lbl.Parent=frame
	local pill=Instance.new("Frame"); pill.Size=UDim2.new(0,38,0,18); pill.Position=UDim2.new(1,-46,0.5,-9)
	pill.BackgroundColor3=state and C.CYAN or C.PANEL; pill.BorderSizePixel=0; pill.ZIndex=8; pill.Parent=frame
	corner(pill,999); stroke(pill,1.2,state and 0.4 or 0.2)
	local dot=Instance.new("Frame"); dot.Size=UDim2.new(0,13,0,13)
	dot.Position=state and UDim2.new(1,-16,0.5,-6.5) or UDim2.new(0,3,0.5,-6.5)
	dot.BackgroundColor3=state and C.BG or C.SUB; dot.BorderSizePixel=0; dot.ZIndex=9; dot.Parent=pill; corner(dot,999)
	local isOn=state
	local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1
	btn.Text=""; btn.ZIndex=10; btn.Parent=frame
	btn.MouseButton1Click:Connect(function()
		isOn=not isOn
		tw(pill,{BackgroundColor3=isOn and C.CYAN or C.PANEL},0.18)
		tw(dot,{Position=isOn and UDim2.new(1,-16,0.5,-6.5) or UDim2.new(0,3,0.5,-6.5),BackgroundColor3=isOn and C.BG or C.SUB},0.18)
		onChange(isOn)
	end)
end

-- ══════════════════════════════════════════
--   DEAD RAILS LOGIC
-- ══════════════════════════════════════════

-- Gun Aura
local function GunAura()
	spawn(function()
		while _G.Gun do
			pcall(function()
				local Tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
				if not Tool then return end
				local closest, shortestDistance = nil, math.huge
				for _, desc in ipairs(workspace:GetDescendants()) do
					if desc.Name == "HumanoidRootPart" then
						local par = desc.Parent
						if par and (par:GetAttribute("EntityName") or par:GetAttribute("Bounty")) then
							local hum = par:FindFirstChild("Humanoid")
							if hum and hum.Health > 0 then
								local dist = LocalPlayer:DistanceFromCharacter(desc.Position)
								if dist < shortestDistance then shortestDistance=dist; closest=desc end
							end
						end
					end
				end
				if closest then
					ReplicatedStorage.Remotes.Weapon.Shoot:FireServer(
						workspace:GetServerTimeNow(), Tool,
						closest.CFrame * CFrame.Angles(-1.794655442237854, 0.22748638689517975, 2.360928773880005),
						{["4"]=closest.Parent:FindFirstChild("Humanoid"),["2"]=closest.Parent:FindFirstChild("Humanoid")}
					)
					ReplicatedStorage.Remotes.Weapon.Reload:FireServer(workspace:GetServerTimeNow(), Tool)
				end
			end)
			task.wait(0.2)
		end
	end)
end

-- Collect Bond & Ammo
local function CollectItems()
	spawn(function()
		while _G.Collect do
			pcall(function()
				for _, item in ipairs(workspace.RuntimeItems:GetChildren()) do
					local txt = item:GetAttribute("ActivateText")
					if txt == "Collect Bond" or txt == "Collect" then
						ReplicatedStorage.Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(item)
					end
				end
			end)
			task.wait(1)
		end
	end)
end

-- Items ESP
local ItemESPTable = {}
local function CreateItemESP(part, name)
	if ItemESPTable[part] then return end
	local bb = Instance.new("BillboardGui"); bb.Name="ItemESP"; bb.Adornee=part
	bb.Size=UDim2.new(0,100,0,30); bb.StudsOffset=Vector3.new(0,2,0); bb.AlwaysOnTop=true
	local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
	lbl.Text=name; lbl.TextColor3=Color3.fromRGB(204,255,204); lbl.TextStrokeTransparency=0
	lbl.Font=Enum.Font.SourceSansBold; lbl.TextSize=16; lbl.Parent=bb
	bb.Parent=game:GetService("CoreGui"); ItemESPTable[part]=bb
end

task.spawn(function()
	while task.wait(1) do
		if _G.Items then
			pcall(function()
				for _, item in ipairs(workspace.RuntimeItems:GetChildren()) do
					if item:IsA("Model") and item.PrimaryPart then CreateItemESP(item.PrimaryPart, item.Name)
					elseif item:IsA("BasePart") then CreateItemESP(item, item.Name) end
				end
			end)
		end
	end
end)

-- Mobs ESP
local MobsESPTable = {}
local function UpdateMobsESP()
	for _, desc in ipairs(workspace:GetDescendants()) do
		if desc:IsA("BasePart") and desc.Name == "HumanoidRootPart" then
			local par = desc.Parent
			if par and (par:GetAttribute("EntityName") or par:GetAttribute("Bounty")) and not MobsESPTable[par] then
				local hl=Instance.new("Highlight"); hl.FillColor=Color3.fromRGB(255,0,0); hl.FillTransparency=0.3
				hl.Parent=par; MobsESPTable[par]=hl
			end
		end
	end
end

-- Unicorn ESP
local UnicornDrawings = {}
local UnicornConnection = nil
local function UpdateUnicorns()
	for _, d in pairs(UnicornDrawings) do
		if d.circle then d.circle:Remove() end
		if d.text then d.text:Remove() end
	end
	table.clear(UnicornDrawings)
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj.Name == "Unicorn" and obj:FindFirstChild("HumanoidRootPart") then
			local circle=Drawing.new("Circle"); circle.Color=Color3.fromRGB(255,0,0); circle.Radius=10
			circle.Thickness=2; circle.Filled=false; circle.Visible=true
			local text=Drawing.new("Text"); text.Text="Unicorn"; text.Size=16
			text.Color=Color3.fromRGB(255,255,255); text.Center=true; text.Outline=true
			text.OutlineColor=Color3.fromRGB(0,0,0); text.Font=2; text.Visible=true
			table.insert(UnicornDrawings,{model=obj,circle=circle,text=text})
		end
	end
end

-- Noclip
local noclipConn = nil

-- ══════════════════════════════════════════
--   CONTENT LOADERS
-- ══════════════════════════════════════════

local function LoadTeleport()
	makeSectionLabel("TELEPORT")
	makeActionBtn("TP to End","🏁",function()
		local char=LocalPlayer.Character; if not char then return end
		local hum=char:WaitForChild("Humanoid"); local hrp=char:WaitForChild("HumanoidRootPart")
		local target=CFrame.new(-428.745911,28.0728378,-49040.9062)
		while not hum.Sit do hrp.CFrame=target; task.wait() end
		showToast("🏁  Teleported to End!",C.CYAN,2)
	end)
	makeActionBtn("TP to Train","🚂",function()
		local char=LocalPlayer.Character; if not char then return end
		local hum=char:WaitForChild("Humanoid"); local hrp=char:WaitForChild("HumanoidRootPart")
		for _,model in ipairs(workspace:GetChildren()) do
			if model:IsA("Model") and model:GetAttribute("serverEntityId") then
				for _,v in ipairs(model:GetDescendants()) do
					if v.Name=="VehicleSeat" then
						while not hum.Sit do hrp.CFrame=CFrame.new(v.Position); task.wait() end
					end
				end
			end
		end
		showToast("🚂  Teleported to Train!",C.CYAN,2)
	end)
	makeActionBtn("TP to Castle","🏰",function()
		local char=LocalPlayer.Character; if not char then return end
		local root=char:WaitForChild("HumanoidRootPart")
		local pos1=CFrame.new(248,24,-9059)
		for i=1,10 do root.CFrame=pos1; task.wait() end
		pcall(function()
			local pos2=workspace.RuntimeItems.MaximGun.VehicleSeat.Position
			for i=1,30 do root.CFrame=CFrame.new(pos2); workspace.RuntimeItems.MaximGun.VehicleSeat.Disabled=false; task.wait() end
		end)
		showToast("🏰  Teleported to Castle!",C.CYAN,2)
	end)
	makeActionBtn("TP to TeslaLab","⚡",function()
		pcall(function()
			local root=LocalPlayer.Character:WaitForChild("HumanoidRootPart")
			local genPos=workspace.TeslaLab.Generator.Generator.Position
			for i=1,10 do root.CFrame=CFrame.new(genPos); task.wait() end
			local closestSeat,minDist=nil,math.huge
			for _,v in pairs(workspace:GetDescendants()) do
				if v:IsA("Seat") then
					local dist=(v.Position-genPos).Magnitude
					if dist<minDist then minDist=dist; closestSeat=v end
				end
			end
			if closestSeat then
				for i=1,30 do root.CFrame=closestSeat.CFrame; closestSeat.Disabled=false; task.wait() end
			end
		end)
		showToast("⚡  Teleported to TeslaLab!",C.CYAN,2)
	end)
	makeActionBtn("TP to Sterling","🏙️",function()
		local root=LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		local tween=TweenService:Create(root,TweenInfo.new(40,Enum.EasingStyle.Linear),{CFrame=CFrame.new(-424,30,-49041)})
		root.CFrame=CFrame.new(56,3,29760); tween:Play()
		task.spawn(function()
			while task.wait(0.2) do
				local st=workspace:FindFirstChild("Sterling")
				if st and st:FindFirstChild("Town") and st.Town:FindFirstChild("Road") then
					tween:Cancel()
					local roadCF=st.Town.Road.CFrame*CFrame.new(0,5,0)
					for i=1,20 do root.CFrame=roadCF; pcall(function() workspace.RuntimeItems.Chair.Seat.Disabled=false end); task.wait() end
					break
				end
			end
		end)
		showToast("🏙️  Heading to Sterling...",C.CYAN,2)
	end)
	makeActionBtn("TP to Fort","🔫",function()
		local root=LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		local tween=TweenService:Create(root,TweenInfo.new(50,Enum.EasingStyle.Linear),{CFrame=CFrame.new(-424,30,-49041)})
		root.CFrame=CFrame.new(56,3,29760); tween:Play()
		task.spawn(function()
			while task.wait(0.2) do
				local cannon=workspace.RuntimeItems:FindFirstChild("Cannon")
				if cannon and cannon:FindFirstChild("VehicleSeat") then
					tween:Cancel()
					local seat=cannon.VehicleSeat
					for i=1,30 do root.CFrame=CFrame.new(seat.Position); seat.Disabled=false; task.wait() end
					break
				end
			end
		end)
		showToast("🔫  Heading to Fort...",C.CYAN,2)
	end)
end

local function LoadCombat()
	makeSectionLabel("COMBAT")
	makeToggle("⚔️  Gun Aura (Kill Mobs)", _G.Gun, function(v)
		_G.Gun=v
		if v then GunAura(); showToast("⚔️  Gun Aura bật!",C.GREEN,2)
		else showToast("⚔️  Gun Aura tắt!",C.RED,2) end
	end)
	makeToggle("💰  Collect Bond & Ammo", _G.Collect, function(v)
		_G.Collect=v
		if v then CollectItems(); showToast("💰  Auto Collect bật!",C.GREEN,2)
		else showToast("💰  Auto Collect tắt!",C.RED,2) end
	end)
	makeSectionLabel("MOVEMENT")
	makeActionBtn("Inf Jump","🦘",function()
		UserInputService.JumpRequest:Connect(function()
			local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
		end)
		showToast("🦘  Inf Jump bật!",C.GREEN,2)
	end)
	makeToggle("👟  Walk Speed Boost", _G.Speed, function(v)
		_G.Speed=v
		local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
		if v then
			task.spawn(function()
				while _G.Speed do
					if hum then hum.WalkSpeed=18.5; workspace.CurrentCamera.FieldOfView=100 end
					task.wait(3)
					if hum then hum.WalkSpeed=16 end
					task.wait(1)
				end
			end)
			showToast("👟  Speed Boost bật!",C.GREEN,2)
		else
			if hum then hum.WalkSpeed=16; workspace.CurrentCamera.FieldOfView=70 end
			showToast("👟  Speed Boost tắt!",C.RED,2)
		end
	end)
	makeToggle("👻  Noclip", false, function(v)
		if v then
			if not noclipConn then
				noclipConn=RunService.Stepped:Connect(function()
					pcall(function()
						if LocalPlayer.Character then
							for _,p in ipairs(LocalPlayer.Character:GetDescendants()) do
								if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end
							end
						end
					end)
				end)
			end
			showToast("👻  Noclip bật!",C.GREEN,2)
		else
			if noclipConn then noclipConn:Disconnect(); noclipConn=nil end
			showToast("👻  Noclip tắt!",C.RED,2)
		end
	end)
end

local function LoadVisual()
	makeSectionLabel("ESP")
	makeToggle("📦  Items ESP", _G.Items, function(v)
		_G.Items=v
		if not v then
			for _,b in pairs(ItemESPTable) do if b then b:Destroy() end end
			ItemESPTable={}
			showToast("📦  Items ESP tắt!",C.RED,2)
		else showToast("📦  Items ESP bật!",C.GREEN,2) end
	end)
	makeToggle("👹  Mobs ESP", _G.Mobs, function(v)
		_G.Mobs=v
		if v then
			task.spawn(function()
				while _G.Mobs do UpdateMobsESP(); task.wait(1) end
			end)
			showToast("👹  Mobs ESP bật!",C.GREEN,2)
		else
			for _,h in pairs(MobsESPTable) do if h then h:Destroy() end end
			MobsESPTable={}
			showToast("👹  Mobs ESP tắt!",C.RED,2)
		end
	end)
	makeToggle("🦄  Unicorn ESP", _G.UnicornESP, function(v)
		_G.UnicornESP=v
		if v then
			UpdateUnicorns()
			UnicornConnection=RunService.RenderStepped:Connect(function()
				for _,data in ipairs(UnicornDrawings) do
					local hrp=data.model:FindFirstChild("HumanoidRootPart")
					if hrp and data.circle and data.text then
						local sp,onScreen=workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
						if onScreen then
							local p2=Vector2.new(sp.X,sp.Y)
							data.circle.Position=p2; data.circle.Visible=true
							data.text.Position=p2+Vector2.new(0,15); data.text.Visible=true
						else data.circle.Visible=false; data.text.Visible=false end
					end
				end
			end)
			task.spawn(function()
				while _G.UnicornESP do UpdateUnicorns(); task.wait(2) end
			end)
			showToast("🦄  Unicorn ESP bật!",C.GREEN,2)
		else
			if UnicornConnection then UnicornConnection:Disconnect(); UnicornConnection=nil end
			for _,d in pairs(UnicornDrawings) do
				if d.circle then d.circle:Remove() end; if d.text then d.text:Remove() end
			end
			table.clear(UnicornDrawings)
			showToast("🦄  Unicorn ESP tắt!",C.RED,2)
		end
	end)
	makeSectionLabel("MISC VISUAL")
	makeActionBtn("Full Bright","💡",function()
		local Lighting=game:GetService("Lighting")
		if not _G.FullBrightExecuted then
			_G.FullBrightExecuted=true; _G.FullBrightEnabled=true
			Lighting.Brightness=1; Lighting.ClockTime=12; Lighting.FogEnd=786543
			Lighting.GlobalShadows=false; Lighting.Ambient=Color3.fromRGB(178,178,178)
			showToast("💡  Full Bright bật!",C.GREEN,2)
		else
			_G.FullBrightEnabled=not _G.FullBrightEnabled
			showToast("💡  Full Bright "..((_G.FullBrightEnabled and "bật") or "tắt").."!",_G.FullBrightEnabled and C.GREEN or C.RED,2)
		end
	end)
	makeActionBtn("Unlock Camera","📷",function()
		LocalPlayer.CameraMode=Enum.CameraMode.Classic
		LocalPlayer.CameraMinZoomDistance=0; LocalPlayer.CameraMaxZoomDistance=150
		workspace.CurrentCamera.CameraSubject=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
		showToast("📷  Camera đã mở khóa!",C.CYAN,2)
	end)
end

-- ══════════════════════════════════════════
--   REGISTER TABS
-- ══════════════════════════════════════════
local TpTab      = makeTab("TELEPORT")
local CombatTab  = makeTab("COMBAT")
local VisualTab  = makeTab("VISUAL")

TpTab.MouseButton1Click:Connect(function()     setActive(TpTab,1,LoadTeleport) end)
CombatTab.MouseButton1Click:Connect(function() setActive(CombatTab,2,LoadCombat) end)
VisualTab.MouseButton1Click:Connect(function() setActive(VisualTab,3,LoadVisual) end)

-- ══════════════════════════════════════════
--   ANIMATE
-- ══════════════════════════════════════════
local function animateOpen()
	Root.Visible=true; Root.Size=UDim2.new(0,ROOT_W*0.9,0,ROOT_H*0.9)
	Root.Position=UDim2.new(0.5,-(ROOT_W*0.9)/2,0.5,-(ROOT_H*0.9)/2); Root.BackgroundTransparency=1
	tw(Root,{Size=UDim2.new(0,ROOT_W,0,ROOT_H),Position=UDim2.new(0.5,-ROOT_W/2,0.5,-ROOT_H/2),BackgroundTransparency=0},0.35,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
end

local function animateClose(cb)
	tw(Root,{Size=UDim2.new(0,ROOT_W*0.9,0,ROOT_H*0.9),Position=UDim2.new(0.5,-(ROOT_W*0.9)/2,0.5,-(ROOT_H*0.9)/2),BackgroundTransparency=1},0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.In)
	task.wait(0.26); Root.Visible=false; if cb then cb() end
end

-- ══════════════════════════════════════════
--   KEY SUBMIT
-- ══════════════════════════════════════════
local function unlockGUI()
	KeyStatus.Text="✓  Đúng! Key hợp lệ 24 giờ..."; KeyStatus.TextColor3=C.GREEN
	tw(KeySubmit,{BackgroundColor3=C.GREEN},0.2); task.wait(0.5)
	tw(KeyOverlay,{BackgroundTransparency=1},0.35)
	for _,v in pairs(KeyOverlay:GetChildren()) do
		if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then tw(v,{TextTransparency=1},0.3)
		elseif v:IsA("ImageLabel") then tw(v,{ImageTransparency=1},0.3)
		elseif v:IsA("Frame") then tw(v,{BackgroundTransparency=1},0.3) end
	end
	task.wait(0.38); KeyOverlay.Visible=false
	setActive(TpTab,1,LoadTeleport)
	task.spawn(function() task.wait(1); showToast("✅  CryoXHUB x Dead Rails mở khóa!",C.GREEN,3) end)
end

KeySubmit.MouseButton1Click:Connect(function()
	if KeyInput.Text==KEY_CHINH_XAC then saveKeyTime(); unlockGUI()
	else
		KeyInput.Text=""; KeyStatus.Text="❌  Sai Key! Thử lại."; KeyStatus.TextColor3=C.RED
		local orig=KeyInput.Position
		for i=1,5 do tw(KeyInput,{Position=orig+UDim2.new(0,i%2==0 and 7 or -7,0,0)},0.04); task.wait(0.045) end
		tw(KeyInput,{Position=orig},0.07); task.wait(1.5); KeyStatus.Text=""
	end
end)

if keyVerified then task.spawn(function() task.wait(0.5); unlockGUI() end) end

CloseBtn.MouseButton1Click:Connect(function()
	animateClose(function()
		OpenBtn.Visible=true; OpenBtn.Size=UDim2.new(0,26,0,26)
		tw(OpenBtn,{Size=UDim2.new(0,46,0,46)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
	end)
end)

OpenBtn.MouseButton1Click:Connect(function() OpenBtn.Visible=false; animateOpen() end)

-- ══════════════════════════════════════════
--   STARTUP
-- ══════════════════════════════════════════
task.wait(0.25)
animateOpen()
