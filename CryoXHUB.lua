-- CryoXHUB GUI v4.0 | Upgraded by Claude
-- Delta compatible | No getmetatable hook (removed for Delta compat)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CryoX_v4"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local RunService      = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService     = game:GetService("HttpService")
local LocalPlayer     = Players.LocalPlayer
local StatsService    = game:GetService("Stats")

local ID_ANH_NEN   = "rbxthumb://type=Asset&id=116367849760314&w=420&h=420"
local ID_LOGO_DONG = "rbxthumb://type=Asset&id=135753950157111&w=420&h=420"
local KEY_CHINH_XAC = "CryoXHUB"
local SAVE_FILE     = "CryoXHUB_v4_save.json"

-- ══════════════════════════════════════════
--   SAVE SYSTEM
-- ══════════════════════════════════════════
local DEFAULT_SAVE = {
	keyVerified       = false,
	keyTime           = 0,
	accentR           = 0,
	accentG           = 210,
	accentB           = 255,
	showFPS           = false,
	showPing          = false,
	showPlayers       = false,
	showDashCD        = false,
	showSkillDetector = false,
	favorites         = {},
	lastTab           = 1,
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
--   COLORS & SETTINGS
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

local Settings = {
	accentColor       = Color3.fromRGB(SaveData.accentR, SaveData.accentG, SaveData.accentB),
	showFPS           = SaveData.showFPS,
	showPing          = SaveData.showPing,
	showPlayers       = SaveData.showPlayers,
	showDashCD        = SaveData.showDashCD,
	showSkillDetector = SaveData.showSkillDetector,
}

-- Favorites: table of {name, code}
local Favorites = {}
if type(SaveData.favorites) == "table" then
	Favorites = SaveData.favorites
end

local function saveFavorites()
	SaveData.favorites = Favorites
	writeSave(SaveData)
end

local function saveSettings()
	SaveData.accentR           = math.floor(Settings.accentColor.R * 255)
	SaveData.accentG           = math.floor(Settings.accentColor.G * 255)
	SaveData.accentB           = math.floor(Settings.accentColor.B * 255)
	SaveData.showFPS           = Settings.showFPS
	SaveData.showPing          = Settings.showPing
	SaveData.showPlayers       = Settings.showPlayers
	SaveData.showDashCD        = Settings.showDashCD
	SaveData.showSkillDetector = Settings.showSkillDetector
	writeSave(SaveData)
end

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

local PAD=5; local GAP=5; local LEFT_W=148; local ROOT_H=370; local TAB_H=34
local ROOT_W=580; local RIGHT_W=ROOT_W-PAD*2-LEFT_W-GAP
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
	local tb=Instance.new("Frame"); tb.Size=UDim2.new(0,4,1,-16); tb.Position=UDim2.new(0,8,0,8)
	tb.BackgroundColor3=color; tb.BorderSizePixel=0; tb.ZIndex=51; tb.Parent=T; corner(tb,3)
	local tm=Instance.new("TextLabel"); tm.Size=UDim2.new(1,-20,1,0); tm.Position=UDim2.new(0,16,0,0)
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
local KeyIcon=Instance.new("TextLabel"); KeyIcon.Size=UDim2.new(1,0,0,40); KeyIcon.Position=UDim2.new(0,0,0.1,0)
KeyIcon.BackgroundTransparency=1; KeyIcon.Text="🔐"; KeyIcon.TextSize=28; KeyIcon.ZIndex=23; KeyIcon.Parent=KeyOverlay
local KeyTitle=Instance.new("TextLabel"); KeyTitle.Size=UDim2.new(1,-20,0,22); KeyTitle.Position=UDim2.new(0,10,0.1,44)
KeyTitle.BackgroundTransparency=1; KeyTitle.Text="Nhập key để mở CryoXHUB"; KeyTitle.TextColor3=C.CYAN
KeyTitle.Font=Enum.Font.GothamBold; KeyTitle.TextSize=15; KeyTitle.ZIndex=23; KeyTitle.Parent=KeyOverlay
local KeySub=Instance.new("TextLabel"); KeySub.Size=UDim2.new(1,-20,0,16); KeySub.Position=UDim2.new(0,10,0.1,68)
KeySub.BackgroundTransparency=1; KeySub.Text="Key hợp lệ 24 giờ  •  Key: CryoXHUB"
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
VerLbl.BackgroundTransparency=1; VerLbl.Text="CryoXHUB  v4.0"; VerLbl.TextColor3=C.CYAN
VerLbl.Font=Enum.Font.GothamBold; VerLbl.TextSize=9; VerLbl.TextXAlignment=Enum.TextXAlignment.Center
VerLbl.ZIndex=5; VerLbl.Parent=AvatarCard

-- ══════════════════════════════════════════
--   STAT OVERLAYS
-- ══════════════════════════════════════════
local StatFPSLbl=Instance.new("TextLabel"); StatFPSLbl.Size=UDim2.new(0,200,0,16)
StatFPSLbl.Position=UDim2.new(0,8,0,52); StatFPSLbl.BackgroundTransparency=1; StatFPSLbl.Text=""
StatFPSLbl.TextColor3=C.GREEN; StatFPSLbl.Font=Enum.Font.GothamBold; StatFPSLbl.TextSize=12
StatFPSLbl.TextXAlignment=Enum.TextXAlignment.Left; StatFPSLbl.ZIndex=10
StatFPSLbl.Visible=false; StatFPSLbl.Parent=ScreenGui

local StatPingLbl=Instance.new("TextLabel"); StatPingLbl.Size=UDim2.new(0,200,0,16)
StatPingLbl.Position=UDim2.new(0,8,0,70); StatPingLbl.BackgroundTransparency=1; StatPingLbl.Text=""
StatPingLbl.TextColor3=Color3.fromRGB(255,200,60); StatPingLbl.Font=Enum.Font.GothamBold; StatPingLbl.TextSize=12
StatPingLbl.TextXAlignment=Enum.TextXAlignment.Left; StatPingLbl.ZIndex=10
StatPingLbl.Visible=false; StatPingLbl.Parent=ScreenGui

local StatPlayersLbl=Instance.new("TextLabel"); StatPlayersLbl.Size=UDim2.new(0,200,0,16)
StatPlayersLbl.Position=UDim2.new(0,8,0,88); StatPlayersLbl.BackgroundTransparency=1; StatPlayersLbl.Text=""
StatPlayersLbl.TextColor3=Color3.fromRGB(0,210,255); StatPlayersLbl.Font=Enum.Font.GothamBold; StatPlayersLbl.TextSize=12
StatPlayersLbl.TextXAlignment=Enum.TextXAlignment.Left; StatPlayersLbl.ZIndex=10
StatPlayersLbl.Visible=false; StatPlayersLbl.Parent=ScreenGui

local DashCDLabel=Instance.new("TextLabel"); DashCDLabel.Size=UDim2.new(0,100,0,20)
DashCDLabel.AnchorPoint=Vector2.new(0.5,1); DashCDLabel.Position=UDim2.new(0.5,-60,1,-125)
DashCDLabel.BackgroundTransparency=1; DashCDLabel.Font=Enum.Font.GothamBold; DashCDLabel.TextSize=12
DashCDLabel.TextColor3=Color3.fromRGB(50,220,120); DashCDLabel.TextStrokeTransparency=0.5
DashCDLabel.Text="DASH: READY ✓"; DashCDLabel.Visible=false; DashCDLabel.ZIndex=10; DashCDLabel.Parent=ScreenGui

local SideCDLabel=Instance.new("TextLabel"); SideCDLabel.Size=UDim2.new(0,100,0,20)
SideCDLabel.AnchorPoint=Vector2.new(0.5,1); SideCDLabel.Position=UDim2.new(0.5,60,1,-125)
SideCDLabel.BackgroundTransparency=1; SideCDLabel.Font=Enum.Font.GothamBold; SideCDLabel.TextSize=12
SideCDLabel.TextColor3=Color3.fromRGB(50,220,120); SideCDLabel.TextStrokeTransparency=0.5
SideCDLabel.Text="SIDE: READY ✓"; SideCDLabel.Visible=false; SideCDLabel.ZIndex=10; SideCDLabel.Parent=ScreenGui

-- ══════════════════════════════════════════
--   SKILL DETECTOR
-- ══════════════════════════════════════════
local skillDetectorConn=nil; local skillDetectorState={}
local strongSkills={["Omni Directional Punch"]=true,["Death Counter"]=true,["Serious Punch"]=true,["Table Flip"]=true}
local weakSkills={["Consecutive Punches"]=true,["Normal Punch"]=true,["Shove"]=true,["Uppercut"]=true}

local function createBillboard(target,text)
	if not (target and target:FindFirstChild("Head")) then return end
	local head=target.Head; local bb=head:FindFirstChild("SkillTag")
	if not bb then
		bb=Instance.new("BillboardGui"); bb.Name="SkillTag"; bb.Size=UDim2.new(0,100,0,40)
		bb.StudsOffset=Vector3.new(0,2.5,0); bb.AlwaysOnTop=true; bb.Adornee=head; bb.Parent=head
		local lbl=Instance.new("TextLabel"); lbl.Name="Label"; lbl.Size=UDim2.new(1,0,1,0)
		lbl.BackgroundTransparency=1; lbl.Font=Enum.Font.GothamBold; lbl.TextScaled=true
		lbl.TextColor3=Color3.new(1,1,1); lbl.TextStrokeTransparency=0.5; lbl.Parent=bb
	end
	bb.Label.Text=text
end
local function removeBillboard(target)
	if target and target:FindFirstChild("Head") then
		local bb=target.Head:FindFirstChild("SkillTag"); if bb then bb:Destroy() end
	end
end
local function clearAllBillboards()
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr~=LocalPlayer and plr.Character then removeBillboard(plr.Character) end
	end
	skillDetectorState={}
end
local function startSkillDetector()
	if skillDetectorConn then return end
	skillDetectorConn=RunService.Heartbeat:Connect(function()
		for _,plr in ipairs(Players:GetPlayers()) do
			if plr~=LocalPlayer then
				local char=plr.Character; local bp=plr:FindFirstChildOfClass("Backpack")
				if char and bp then
					local st=nil
					for _,tool in ipairs(bp:GetChildren()) do
						if strongSkills[tool.Name] then st="strong" break end
						if weakSkills[tool.Name] then st="weak" break end
					end
					local last=skillDetectorState[plr]
					if st=="strong" then
						if last~="strong" then createBillboard(char,"💢") end
						skillDetectorState[plr]="strong"
					elseif st=="weak" then
						if last=="strong" then
							createBillboard(char,"☠")
							task.delay(math.random(8,9),function()
								if skillDetectorState[plr]=="weak" then removeBillboard(char) end
							end)
						else removeBillboard(char) end
						skillDetectorState[plr]="weak"
					else removeBillboard(char); skillDetectorState[plr]=nil end
				end
			end
		end
	end)
end
local function stopSkillDetector()
	if skillDetectorConn then skillDetectorConn:Disconnect(); skillDetectorConn=nil end
	clearAllBillboards()
end

-- ══════════════════════════════════════════
--   UPDATE STAT WIDGET
-- ══════════════════════════════════════════
local function updateStatWidget()
	StatFPSLbl.Visible     = Settings.showFPS
	StatPingLbl.Visible    = Settings.showPing
	StatPlayersLbl.Visible = Settings.showPlayers
	DashCDLabel.Visible    = Settings.showDashCD
	SideCDLabel.Visible    = Settings.showDashCD
	if Settings.showSkillDetector then startSkillDetector() else stopSkillDetector() end
end
updateStatWidget()

-- ══════════════════════════════════════════
--   UPDATE LOG CARD
-- ══════════════════════════════════════════
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
	{"v4.0","Search bar toàn bộ scripts"},
	{"v4.0","Tab YÊU THÍCH - lưu script fav"},
	{"v4.0","Server đông người (>=10 player)"},
	{"v4.0","Copy link script ra clipboard"},
	{"v4.0","Quick exec: paste URL và chạy"},
	{"v3.6","Tab MAP + 16 Teleport locations"},
	{"v3.6","Skill Detector toggle trong Setting"},
	{"v3.5","Tab Visual, Emote, Accessories"},
	{"v3.5","Tab SERVER + SETTING, Key 24H"},
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

-- ══════════════════════════════════════════
--   SEARCH BAR (phía trên tab)
-- ══════════════════════════════════════════
local SearchRow=Instance.new("Frame"); SearchRow.Size=UDim2.new(1,0,0,28)
SearchRow.BackgroundTransparency=1; SearchRow.BorderSizePixel=0; SearchRow.ZIndex=4; SearchRow.Parent=RightCol
local SearchBox=Instance.new("TextBox"); SearchBox.Size=UDim2.new(1,-(TAB_H+GAP),1,0)
SearchBox.BackgroundColor3=C.PANEL; SearchBox.PlaceholderText="🔍  Tìm kiếm script..."
SearchBox.Text=""; SearchBox.Font=Enum.Font.Gotham; SearchBox.TextSize=11
SearchBox.TextColor3=C.TEXT; SearchBox.PlaceholderColor3=C.SUB
SearchBox.ZIndex=5; SearchBox.Parent=SearchRow; corner(SearchBox,8); stroke(SearchBox,1.2,0.3)
local SearchPad=Instance.new("UIPadding",SearchBox)
SearchPad.PaddingLeft=UDim.new(0,8)

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

local CONTENT_H_NEW = ROOT_H - PAD*2 - TAB_H - GAP - 28 - GAP
local ContentBg=Instance.new("Frame"); ContentBg.Size=UDim2.new(1,0,0,CONTENT_H_NEW)
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

-- Search results panel (overlay trên ContentBg)
local SearchResultsBg=Instance.new("Frame"); SearchResultsBg.Size=UDim2.new(1,0,1,0)
SearchResultsBg.BackgroundColor3=C.BG; SearchResultsBg.BackgroundTransparency=0.05; SearchResultsBg.BorderSizePixel=0
SearchResultsBg.ZIndex=15; SearchResultsBg.Visible=false; SearchResultsBg.Parent=ContentBg; corner(SearchResultsBg,10)
local SearchResultsScroll=Instance.new("ScrollingFrame"); SearchResultsScroll.Size=UDim2.new(1,-8,1,-8)
SearchResultsScroll.Position=UDim2.new(0,4,0,4); SearchResultsScroll.BackgroundTransparency=1; SearchResultsScroll.ZIndex=16
SearchResultsScroll.CanvasSize=UDim2.new(0,0,0,0); SearchResultsScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
SearchResultsScroll.ScrollBarThickness=2; SearchResultsScroll.ScrollBarImageColor3=C.CYAN; SearchResultsScroll.Parent=SearchResultsBg
local SRL=Instance.new("UIListLayout"); SRL.Padding=UDim.new(0,5); SRL.Parent=SearchResultsScroll
local SRPAD=Instance.new("UIPadding"); SRPAD.PaddingTop=UDim.new(0,3); SRPAD.PaddingBottom=UDim.new(0,3); SRPAD.Parent=SearchResultsScroll

local OpenBtn=Instance.new("ImageButton"); OpenBtn.Size=UDim2.new(0,46,0,46); OpenBtn.Position=UDim2.new(0,12,0.5,-23)
OpenBtn.Image=ID_LOGO_DONG; OpenBtn.BackgroundColor3=C.PANEL; OpenBtn.Visible=false; OpenBtn.Draggable=true
OpenBtn.ZIndex=5; OpenBtn.Parent=ScreenGui; corner(OpenBtn,10); stroke(OpenBtn,1.5,0.15); glowOrb(OpenBtn,0.82)

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

local function clearContent()
	for _,v in pairs(ContentFrame:GetChildren()) do
		if v:IsA("TextButton") or v:IsA("Frame") or v:IsA("TextLabel") then v:Destroy() end
	end
end

-- ══════════════════════════════════════════
--   ALL SCRIPTS REGISTRY (for search)
-- ══════════════════════════════════════════
local AllScripts = {}

-- ══════════════════════════════════════════
--   UI BUILDERS
-- ══════════════════════════════════════════
local function isFavorited(name)
	for _,f in ipairs(Favorites) do if f.name==name then return true end end
	return false
end
local function addFavorite(name,code)
	if not isFavorited(name) then table.insert(Favorites,{name=name,code=code}); saveFavorites() end
end
local function removeFavorite(name)
	for i,f in ipairs(Favorites) do if f.name==name then table.remove(Favorites,i); saveFavorites(); return end end
end

-- Nút script chính (có nút yêu thích ★ và nút copy link)
local function makeScriptBtn(name, code, parent)
	parent = parent or ContentFrame
	-- Đăng ký vào registry cho search
	local found = false
	for _,s in ipairs(AllScripts) do if s.name==name then found=true break end end
	if not found then table.insert(AllScripts,{name=name,code=code}) end

	local btn=Instance.new("Frame"); btn.Size=UDim2.new(1,-4,0,36); btn.Text=""
	btn.BackgroundColor3=C.PANEL2; btn.ZIndex=7; btn.Parent=parent; corner(btn,8); stroke(btn,1.2,0.5)

	local runBtn=Instance.new("TextButton"); runBtn.Size=UDim2.new(1,-66,1,0); runBtn.Position=UDim2.new(0,0,0,0)
	runBtn.BackgroundTransparency=1; runBtn.Text=""; runBtn.ZIndex=9; runBtn.Parent=btn

	local ic=Instance.new("TextLabel"); ic.Size=UDim2.new(0,28,1,0); ic.Position=UDim2.new(0,5,0,0)
	ic.BackgroundTransparency=1; ic.Text="▶"; ic.TextColor3=C.CYAN; ic.Font=Enum.Font.GothamBold
	ic.TextSize=12; ic.ZIndex=8; ic.Parent=btn
	local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,-100,1,0); nl.Position=UDim2.new(0,30,0,0)
	nl.BackgroundTransparency=1; nl.Text=name; nl.TextColor3=C.TEXT; nl.Font=Enum.Font.GothamBold
	nl.TextSize=11; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.ZIndex=8; nl.Parent=btn

	-- Nút ★ yêu thích
	local favState = isFavorited(name)
	local favBtn=Instance.new("TextButton"); favBtn.Size=UDim2.new(0,28,0,28)
	favBtn.Position=UDim2.new(1,-62,0.5,-14)
	favBtn.BackgroundColor3=favState and Color3.fromRGB(255,200,30) or C.PANEL
	favBtn.Text=favState and "★" or "☆"; favBtn.Font=Enum.Font.GothamBold; favBtn.TextSize=14
	favBtn.TextColor3=favState and C.BG or C.SUB; favBtn.ZIndex=9; favBtn.Parent=btn; corner(favBtn,6)
	favBtn.MouseButton1Click:Connect(function()
		if isFavorited(name) then
			removeFavorite(name)
			favBtn.Text="☆"; favBtn.TextColor3=C.SUB; tw(favBtn,{BackgroundColor3=C.PANEL},0.15)
			task.spawn(function() showToast("💔  Đã xóa khỏi Yêu Thích: "..name,C.RED,2) end)
		else
			addFavorite(name,code)
			favBtn.Text="★"; favBtn.TextColor3=C.BG; tw(favBtn,{BackgroundColor3=Color3.fromRGB(255,200,30)},0.15)
			task.spawn(function() showToast("⭐  Đã thêm Yêu Thích: "..name,C.CYAN,2) end)
		end
	end)

	-- Nút copy
	local copyBtn=Instance.new("TextButton"); copyBtn.Size=UDim2.new(0,28,0,28)
	copyBtn.Position=UDim2.new(1,-30,0.5,-14)
	copyBtn.BackgroundColor3=C.PANEL; copyBtn.Text="⧉"; copyBtn.Font=Enum.Font.GothamBold; copyBtn.TextSize=13
	copyBtn.TextColor3=C.SUB; copyBtn.ZIndex=9; copyBtn.Parent=btn; corner(copyBtn,6)
	copyBtn.MouseButton1Click:Connect(function()
		pcall(function()
			if setclipboard then setclipboard(code); task.spawn(function() showToast("📋  Đã copy code: "..name,C.GREEN,2) end)
			else task.spawn(function() showToast("❌  Executor không hỗ trợ clipboard",C.RED,2) end) end
		end)
	end)

	runBtn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=Color3.fromRGB(0,38,68)},0.12); tw(nl,{TextColor3=C.CYAN},0.12) end)
	runBtn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=C.PANEL2},0.12); tw(nl,{TextColor3=C.TEXT},0.12) end)
	runBtn.MouseButton1Click:Connect(function()
		tw(btn,{BackgroundColor3=Color3.fromRGB(0,65,100)},0.08); task.wait(0.1); tw(btn,{BackgroundColor3=C.PANEL2},0.18)
		local f,e=loadstring(code); if f then task.spawn(f) else warn(e) end
	end)
	return btn
end

local function makeActionBtn(name, icon, callback, parent)
	parent = parent or ContentFrame
	local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,-4,0,36); btn.Text=""
	btn.BackgroundColor3=C.PANEL2; btn.ZIndex=7; btn.Parent=parent; corner(btn,8); stroke(btn,1.2,0.5)
	local ic=Instance.new("TextLabel"); ic.Size=UDim2.new(0,28,1,0); ic.Position=UDim2.new(0,5,0,0)
	ic.BackgroundTransparency=1; ic.Text=icon; ic.TextColor3=C.CYAN; ic.Font=Enum.Font.GothamBold
	ic.TextSize=14; ic.ZIndex=8; ic.Parent=btn
	local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,-36,1,0); nl.Position=UDim2.new(0,30,0,0)
	nl.BackgroundTransparency=1; nl.Text=name; nl.TextColor3=C.TEXT; nl.Font=Enum.Font.GothamBold
	nl.TextSize=12; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.ZIndex=8; nl.Parent=btn
	btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=Color3.fromRGB(0,38,68)},0.12); tw(nl,{TextColor3=C.CYAN},0.12) end)
	btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=C.PANEL2},0.12); tw(nl,{TextColor3=C.TEXT},0.12) end)
	btn.MouseButton1Click:Connect(function()
		tw(btn,{BackgroundColor3=Color3.fromRGB(0,65,100)},0.08); task.wait(0.1); tw(btn,{BackgroundColor3=C.PANEL2},0.18)
		callback()
	end)
	return btn
end

local function makeSectionLabel(text, parent)
	parent = parent or ContentFrame
	local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-4,0,18); lbl.BackgroundTransparency=1
	lbl.Text="── "..text.." ──"; lbl.TextColor3=C.CYAN; lbl.Font=Enum.Font.GothamBold
	lbl.TextSize=9; lbl.TextXAlignment=Enum.TextXAlignment.Center; lbl.ZIndex=7; lbl.Parent=parent
end

local function makeTab(name)
	local btn=Instance.new("TextButton"); btn.Size=UDim2.new(0,68,0,26); btn.Text=name
	btn.BackgroundColor3=C.PANEL2; btn.TextColor3=C.SUB; btn.Font=Enum.Font.GothamBold
	btn.TextSize=10; btn.ZIndex=6; btn.Parent=TabScroll; corner(btn,7); stroke(btn,1.2,0.6)
	btn.MouseEnter:Connect(function() if activeTab~=btn then tw(btn,{BackgroundColor3=Color3.fromRGB(0,26,50)},0.12) end end)
	btn.MouseLeave:Connect(function() if activeTab~=btn then tw(btn,{BackgroundColor3=C.PANEL2},0.12) end end)
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

local function makeColorBtn(label, color, onClick)
	local frame=Instance.new("Frame"); frame.Size=UDim2.new(1,-4,0,32); frame.BackgroundColor3=C.PANEL2
	frame.BorderSizePixel=0; frame.ZIndex=7; frame.Parent=ContentFrame; corner(frame,8); stroke(frame,1.2,0.5)
	local dot=Instance.new("Frame"); dot.Size=UDim2.new(0,14,0,14); dot.Position=UDim2.new(0,8,0.5,-7)
	dot.BackgroundColor3=color; dot.BorderSizePixel=0; dot.ZIndex=8; dot.Parent=frame; corner(dot,999)
	local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.7,0,1,0); lbl.Position=UDim2.new(0,28,0,0)
	lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C.TEXT; lbl.Font=Enum.Font.GothamBold
	lbl.TextSize=11; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=8; lbl.Parent=frame
	local al=Instance.new("TextLabel"); al.Size=UDim2.new(0.28,0,1,0); al.Position=UDim2.new(0.72,0,0,0)
	al.BackgroundTransparency=1; al.Text="Chọn ▸"; al.TextColor3=C.CYAN; al.Font=Enum.Font.GothamBold
	al.TextSize=9; al.ZIndex=8; al.Parent=frame
	local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1
	btn.Text=""; btn.ZIndex=9; btn.Parent=frame; btn.MouseButton1Click:Connect(onClick)
	btn.MouseEnter:Connect(function() tw(frame,{BackgroundColor3=Color3.fromRGB(0,38,68)},0.12) end)
	btn.MouseLeave:Connect(function() tw(frame,{BackgroundColor3=C.PANEL2},0.12) end)
end

-- ══════════════════════════════════════════
--   SEARCH LOGIC
-- ══════════════════════════════════════════
local function buildSearchResults(query)
	for _,v in pairs(SearchResultsScroll:GetChildren()) do
		if v:IsA("Frame") or v:IsA("TextLabel") then v:Destroy() end
	end
	query = query:lower()
	local count = 0
	for _,s in ipairs(AllScripts) do
		if s.name:lower():find(query,1,true) then
			makeScriptBtn(s.name, s.code, SearchResultsScroll)
			count = count + 1
		end
	end
	if count==0 then
		local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,-4,0,36); nl.BackgroundTransparency=1
		nl.Text="Không tìm thấy '"..query.."'"; nl.TextColor3=C.SUB; nl.Font=Enum.Font.GothamBold
		nl.TextSize=11; nl.TextXAlignment=Enum.TextXAlignment.Center; nl.ZIndex=17; nl.Parent=SearchResultsScroll
	end
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local q = SearchBox.Text
	if q and #q > 0 then
		SearchResultsBg.Visible = true
		buildSearchResults(q)
	else
		SearchResultsBg.Visible = false
	end
end)

-- ══════════════════════════════════════════
--   CONTENT LOADERS
-- ══════════════════════════════════════════
local function LoadFPS()
	makeScriptBtn("CryoX Anti-Lag",        [[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/CryoX%20Anti-Lag.lua"))()]])
	makeScriptBtn("Blox Strap",            [[loadstring(game:HttpGet("https://raw.githubusercontent.com/qwertyui-is-back/Bloxstrap/main/Initiate.lua"))()]])
	makeScriptBtn("Turbo Lite",            [[loadstring(game:HttpGet("https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua"))()]])
	makeScriptBtn("Flags",                 [[loadstring(game:HttpGet("https://raw.githubusercontent.com/ngoclinh02042011-stack/Flags-Smooth/refs/heads/main/Flags%20by%20ThanhDuy.lua"))()]])
	makeScriptBtn("Anti Lag Remove Effect",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV2/YQANTGV2/refs/heads/main/Protected_5743487458031851.lua.txt"))()]])
end

local function LoadTech()
	makeScriptBtn("Supa Tech",          [[loadstring(game:HttpGet("https://rawscripts.net/raw/The-Strongest-Battlegrounds-Supa-tech-v2-77454"))()]])
	makeScriptBtn("Kiba Tech",          [[loadstring(game:HttpGet("https://raw.githubusercontent.com/yqantg-pixel/Find/refs/heads/main/Protected_1593573630798166.lua.txt"))()]])
	makeScriptBtn("Oreo Tech",          [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/OreoTech/refs/heads/main/Protected_6856895483929371.lua"))()]])
	makeScriptBtn("Lethal Dash",        [[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/57a4d240a2440f0450986c966469092ccfb8d4797392cb8f469fa8b6e605e64d/download"))()]])
	makeScriptBtn("Back Dash Cancel",   [[loadstring(game:HttpGet("https://raw.githubusercontent.com/dinhthanhtuankiet1762009-sudo/Js/refs/heads/main/4418648b0e9b71ef.lua"))()]])
	makeScriptBtn("Instant Twisted v2", [[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/60a7a7c77395006ebd63fce0a17c13241f932bd414c9aba3158b716da00ade01/download"))()]])
	makeScriptBtn("Loop Dash",          [[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/28513f51c0ca2c03d4d7d94f59215d13ce1a2a470bf187f0a685b58ccb4dae98/download"))()]])
	makeScriptBtn("lix tech",           [[loadstring(game:HttpGet("https://raw.githubusercontent.com/MerebennieOfficial/ExoticJn/refs/heads/main/Protected_83737738.txt"))()]])
	makeScriptBtn("lethal kiba",        [[loadstring(game:HttpGet("https://raw.githubusercontent.com/MinhNhatHUB/MinhNhat/refs/heads/main/Lethal%20Kiba.lua"))()]])
	makeScriptBtn("Silent aim reworked",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/yqantg-pixel/Find/refs/heads/main/Protected_6124417452209241.lua.txt"))()]])
end

local function LoadVisual()
	makeSectionLabel("EFFECTS")
	makeScriptBtn("M1 Effect [Red+Blue]",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/ngoclinh02042011-stack/Fist-Blue-And-Red/refs/heads/main/HieuUngVuiNhon.lua"))()]])
	makeScriptBtn("Fake Animation",      [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Mautiku/ehh/main/strong%20guest.lua.txt"))()]])
	makeScriptBtn("Ping and CPU",        [[loadstring(game:HttpGet("https://raw.githubusercontent.com/ngoclinh02042011-stack/Ping-All-Game/refs/heads/main/Ping%20Player.lua"))()]])
	makeSectionLabel("SHADER")
	makeScriptBtn("Custom Shader",       [[loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Simple-Shader-37434"))()]])
	makeSectionLabel("AURA")
	makeScriptBtn("Blue Flame Aura",     [[loadstring(game:HttpGet("Link_Script_Aura_Tai_Day"))()]])
	makeScriptBtn("Ultra Instinct Aura", [[loadstring(game:HttpGet("Link_Script_Aura_2"))()]])
	makeScriptBtn("curse energy effect", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Curse%20energy%20effect%5Bsaitama%5D"))()]])
end

local function LoadScript()
	makeScriptBtn("Fly GuiV3",          [[loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()]])
	makeScriptBtn("Anti Death Counter", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Anti-Death-Counter.lua"))()]])
	makeScriptBtn("Avatar Changer",     [[loadstring(game:HttpGet("https://raw.githubusercontent.com/darkdexv2/universalavatarchanger/main/avatarchanger"))()]])
	makeScriptBtn("Dex Explorer",       [[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Dex_Explorer_v2.lua"))()]])
	makeScriptBtn("Shield",             [[Instance.new("ForceField",game.Players.LocalPlayer.Character)]])
	makeScriptBtn("TouchFling",         [[loadstring(game:HttpGet("https://raw.githubusercontent.com/long191910/all-my-roblox-script/refs/heads/main/touchfling.lua"))()]])
	makeScriptBtn("orbit farm",         [[loadstring(game:httpGet("https://raw.githubusercontent.com/minhnhatdepzai8-cloud/FARM-KILL/refs/heads/main/TSB"))()]])
	makeScriptBtn("farm kill",          [[loadstring(game:HttpGet("https://raw.githubusercontent.com/minhnhatdepzai8-cloud/Farm-Kill-V2/refs/heads/main/TSB"))()]])
end

local function LoadMoveset()
	makeScriptBtn("KAR [SAITAMA]",  [[loadstring(game:HttpGet("https://raw.githubusercontent.com/OfficialAposty/RBLX-Scripts/refs/heads/main/UltimateLifeForm.lua"))()]])
	makeScriptBtn("Gojo [SAITAMA]", [[getgenv().morph=false loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/BaldyToSorcerer/refs/heads/main/LatestV2.lua"))()]])
	makeScriptBtn("CHARA [SAITAMA]",[[loadstring(game:HttpGet("https://pastefy.app/gFRaeMGz/raw"))()]])
end

local function LoadEmote()
	makeScriptBtn("Divine Form",        [[loadstring(game:HttpGet("https://raw.githubusercontent.com/IdkRandomUsernameok/PublicAssets/refs/heads/main/Releases/MUI.lua"))()]])
	makeScriptBtn("MYKIO Limited Aura", [[loadstring(game:HttpGet("https://arch-http.vercel.app/files/LIMITED EMOTE HUB (75-100) BY MIYKO"))()]])
	makeScriptBtn("Basic Emote",        [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/EmoteGui/refs/heads/main/Protected_4900496055951847.lua"))()]])
	makeScriptBtn("Emerge Emote",       [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Yourfavoriteguy/HAHAHHA/refs/heads/main/EmergeButLow", true))()]])
	makeScriptBtn("Sukuna Emote",       [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Yourfavoriteguy/Sukunaslash/refs/heads/main/WorldCuttingSlash", true))()]])
	makeScriptBtn("MIUI",               [[loadstring(game:HttpGet("https://raw.githubusercontent.com/IdkRandomUsernameok/PublicAssets/refs/heads/main/Releases/MUI.lua"))()]])
end

local function LoadAccessories()
	makeScriptBtn("Oinan-Thickhoof-Axe",       [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Guestly-Scripts/Items-Scripts/refs/heads/main/Oinan-Thickhoof"))()]])
	makeScriptBtn("Erisyphia-Staff-by-Guestly", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/GuestlyTheGreatestGuest/Scripts/refs/heads/main/Erisyphia-Staff-made-by-Guestly"))()]])
	makeScriptBtn("Elemental-Crystal-Golem",    [[loadstring(game:HttpGet("https://raw.githubusercontent.com/GuestlyTheGreatestGuest/Scripts/refs/heads/main/Elemental-Crystal-Golem-made-by-Guestly"))()]])
end

-- ══════════════════════════════════════════
--   TAB YÊU THÍCH
-- ══════════════════════════════════════════
local function LoadFavorites()
	if #Favorites == 0 then
		local empty=Instance.new("TextLabel"); empty.Size=UDim2.new(1,-4,0,60); empty.BackgroundTransparency=1
		empty.Text="⭐  Chưa có script yêu thích\nNhấn ★ trên bất kỳ script nào để thêm"
		empty.TextColor3=C.SUB; empty.Font=Enum.Font.GothamBold; empty.TextSize=11
		empty.TextXAlignment=Enum.TextXAlignment.Center; empty.TextWrapped=true; empty.ZIndex=7; empty.Parent=ContentFrame
		return
	end
	makeSectionLabel("⭐ SCRIPTS YÊU THÍCH ("..#Favorites..")")
	for _,f in ipairs(Favorites) do
		makeScriptBtn(f.name, f.code)
	end
	-- Nút xóa tất cả
	local clearBtn=Instance.new("TextButton"); clearBtn.Size=UDim2.new(1,-4,0,30); clearBtn.Text="🗑  Xóa tất cả Yêu Thích"
	clearBtn.BackgroundColor3=Color3.fromRGB(60,12,12); clearBtn.TextColor3=C.RED; clearBtn.Font=Enum.Font.GothamBold
	clearBtn.TextSize=10; clearBtn.ZIndex=7; clearBtn.Parent=ContentFrame; corner(clearBtn,8); stroke(clearBtn,1.2,0.5)
	clearBtn.MouseButton1Click:Connect(function()
		Favorites={}; saveFavorites()
		task.spawn(function() showToast("🗑  Đã xóa tất cả Yêu Thích",C.RED,2) end)
		clearContent(); LoadFavorites()
	end)
end

-- ══════════════════════════════════════════
--   TAB MAP
-- ══════════════════════════════════════════
local Locations = {
	{name="Above Tunnel",     cf=CFrame.new(-301,594,-322)},
	{name="Arena",            cf=CFrame.new(-130,440,-373)},
	{name="Atomic Slash",     cf=CFrame.new(1064,131,23007)},
	{name="Baseplate",        cf=CFrame.new(1073,406,22984)},
	{name="Below Baseplate",  cf=CFrame.new(1073,20,22984)},
	{name="Bigger Jail",      cf=CFrame.new(290,440,465)},
	{name="Even Bigger Jail", cf=CFrame.new(378,439,457)},
	{name="Dark Domain",      cf=CFrame.new(-80,84,20395)},
	{name="Death Counter",    cf=CFrame.new(-66,29,20383)},
	{name="Jail",             cf=CFrame.new(440,440,-395)},
	{name="Jail But Smaller", cf=CFrame.new(20,439,-460)},
	{name="Middle",           cf=CFrame.new(150,441,32)},
	{name="Mountain 1",       cf=CFrame.new(9,653,-363)},
	{name="Mountain 2",       cf=CFrame.new(-1,653,-354)},
	{name="Mountain Edge",    cf=CFrame.new(-297,594,-336)},
	{name="Void",             cf=CFrame.new(0,-10000,0)},
}
local HEIGHT_OFFSET=2
local TP_OFFSET=CFrame.new(0,-0.5,0)*CFrame.Angles(math.rad(-90),0,0)

local function teleportTo(cf)
	local char=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hrp=char:WaitForChild("HumanoidRootPart")
	TweenService:Create(hrp,TweenInfo.new(0.5,Enum.EasingStyle.Quad),
		{CFrame=cf*CFrame.new(0,HEIGHT_OFFSET,0)*TP_OFFSET}):Play()
end

local locationIcons={
	["Void"]="☠",["Arena"]="⚔",["Jail"]="🔒",["Bigger Jail"]="🔒",
	["Even Bigger Jail"]="🔒",["Jail But Smaller"]="🔒",
	["Mountain 1"]="🏔",["Mountain 2"]="🏔",["Mountain Edge"]="🏔",
	["Above Tunnel"]="🌐",["Middle"]="🎯",["Dark Domain"]="🌑",
	["Death Counter"]="💀",["Atomic Slash"]="⚡",["Baseplate"]="🟦",["Below Baseplate"]="🟦",
}

local function LoadMap()
	makeSectionLabel("TELEPORT LOCATIONS")
	for _,loc in ipairs(Locations) do
		local icon=locationIcons[loc.name] or "📍"
		local capturedCF=loc.cf; local capturedName=loc.name
		local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,-4,0,36); btn.Text=""
		btn.BackgroundColor3=C.PANEL2; btn.ZIndex=7; btn.Parent=ContentFrame; corner(btn,8); stroke(btn,1.2,0.5)
		local ic=Instance.new("TextLabel"); ic.Size=UDim2.new(0,28,1,0); ic.Position=UDim2.new(0,5,0,0)
		ic.BackgroundTransparency=1; ic.Text=icon; ic.TextColor3=C.CYAN; ic.Font=Enum.Font.GothamBold
		ic.TextSize=14; ic.ZIndex=8; ic.Parent=btn
		local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,-80,1,0); nl.Position=UDim2.new(0,30,0,0)
		nl.BackgroundTransparency=1; nl.Text=capturedName; nl.TextColor3=C.TEXT; nl.Font=Enum.Font.GothamBold
		nl.TextSize=11; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.ZIndex=8; nl.Parent=btn
		local cl=Instance.new("TextLabel"); cl.Size=UDim2.new(0,72,1,0); cl.Position=UDim2.new(1,-74,0,0)
		cl.BackgroundTransparency=1; cl.Text=math.floor(capturedCF.X)..", "..math.floor(capturedCF.Y)
		cl.TextColor3=C.SUB; cl.Font=Enum.Font.Gotham; cl.TextSize=8
		cl.TextXAlignment=Enum.TextXAlignment.Right; cl.ZIndex=8; cl.Parent=btn
		btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=Color3.fromRGB(0,38,68)},0.12); tw(nl,{TextColor3=C.CYAN},0.12) end)
		btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=C.PANEL2},0.12); tw(nl,{TextColor3=C.TEXT},0.12) end)
		btn.MouseButton1Click:Connect(function()
			tw(btn,{BackgroundColor3=Color3.fromRGB(0,65,100)},0.08); task.wait(0.1); tw(btn,{BackgroundColor3=C.PANEL2},0.18)
			teleportTo(capturedCF)
			task.spawn(function() showToast("📍  Teleport → "..capturedName, C.CYAN, 2) end)
		end)
	end
end

-- ══════════════════════════════════════════
--   TAB SERVER (mở rộng)
-- ══════════════════════════════════════════
local function LoadServer()
	makeSectionLabel("SERVER HOP")
	makeActionBtn("Hop Server (Random)","🔀",function()
		local pid=game.PlaceId
		local ok,sv=pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..pid.."/servers/Public?sortOrder=Asc&limit=25")) end)
		if ok and sv and sv.data then
			local list={}
			for _,s in ipairs(sv.data) do if s.id~=game.JobId and s.playing<s.maxPlayers then table.insert(list,s.id) end end
			if #list>0 then task.spawn(function() showToast("🔀  Đang hop sang server mới...",C.CYAN,2) end); task.wait(1)
				TeleportService:TeleportToPlaceInstance(pid,list[math.random(1,#list)],LocalPlayer)
			else task.spawn(function() showToast("❌  Không tìm thấy server khác!",C.RED,3) end) end
		else task.spawn(function() showToast("❌  Lỗi khi lấy danh sách server!",C.RED,3) end) end
	end)

	makeActionBtn("Server Ít Người Nhất","👤",function()
		local pid=game.PlaceId
		local ok,sv=pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..pid.."/servers/Public?sortOrder=Asc&limit=25")) end)
		if ok and sv and sv.data and #sv.data>0 then
			local least,minP=nil,math.huge
			for _,s in ipairs(sv.data) do if s.id~=game.JobId and s.playing<minP then minP=s.playing; least=s.id end end
			if least then task.spawn(function() showToast("👤  Vào server ít người ("..minP.." players)...",C.CYAN,2) end); task.wait(1)
				TeleportService:TeleportToPlaceInstance(pid,least,LocalPlayer)
			else task.spawn(function() showToast("❌  Không tìm thấy!",C.RED,3) end) end
		else task.spawn(function() showToast("❌  Lỗi server list!",C.RED,3) end) end
	end)

	-- === MỚI: Server đông người >= 10 ===
	makeActionBtn("Server Đông Người (≥10)","👥",function()
		local pid=game.PlaceId
		local ok,sv=pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..pid.."/servers/Public?sortOrder=Desc&limit=100")) end)
		if ok and sv and sv.data then
			local list={}
			for _,s in ipairs(sv.data) do
				if s.id~=game.JobId and s.playing>=10 then table.insert(list,s) end
			end
			if #list>0 then
				-- Sắp xếp theo đông nhất
				table.sort(list,function(a,b) return a.playing > b.playing end)
				local best=list[1]
				task.spawn(function() showToast("👥  Server đông nhất: "..best.playing.." người\nĐang tham gia...",C.CYAN,3) end)
				task.wait(1.5)
				TeleportService:TeleportToPlaceInstance(pid,best.id,LocalPlayer)
			else task.spawn(function() showToast("❌  Không có server nào ≥10 người!",C.RED,3) end) end
		else task.spawn(function() showToast("❌  Lỗi khi lấy danh sách!",C.RED,3) end) end
	end)

	-- === MỚI: Chọn mức tối thiểu player ===
	makeSectionLabel("JOIN THEO SỐ NGƯỜI")
	local filterFrame=Instance.new("Frame"); filterFrame.Size=UDim2.new(1,-4,0,42); filterFrame.BackgroundColor3=C.PANEL2
	filterFrame.BorderSizePixel=0; filterFrame.ZIndex=7; filterFrame.Parent=ContentFrame; corner(filterFrame,8); stroke(filterFrame,1.2,0.5)
	local filterLbl=Instance.new("TextLabel"); filterLbl.Size=UDim2.new(0.55,0,1,0); filterLbl.Position=UDim2.new(0,10,0,0)
	filterLbl.BackgroundTransparency=1; filterLbl.Text="👥  Tối thiểu players:"; filterLbl.TextColor3=C.TEXT
	filterLbl.Font=Enum.Font.GothamBold; filterLbl.TextSize=10; filterLbl.TextXAlignment=Enum.TextXAlignment.Left; filterLbl.ZIndex=8; filterLbl.Parent=filterFrame
	local minBox=Instance.new("TextBox"); minBox.Size=UDim2.new(0.2,0,0,26); minBox.Position=UDim2.new(0.56,0,0.5,-13)
	minBox.BackgroundColor3=C.BG; minBox.Text="10"; minBox.Font=Enum.Font.GothamBold; minBox.TextSize=12
	minBox.TextColor3=C.CYAN; minBox.ZIndex=9; minBox.Parent=filterFrame; corner(minBox,6)
	local goBtn=Instance.new("TextButton"); goBtn.Size=UDim2.new(0.2,0,0,26); goBtn.Position=UDim2.new(0.78,0,0.5,-13)
	goBtn.BackgroundColor3=C.CYAN; goBtn.Text="JOIN"; goBtn.Font=Enum.Font.GothamBold; goBtn.TextSize=10
	goBtn.TextColor3=C.BG; goBtn.ZIndex=9; goBtn.Parent=filterFrame; corner(goBtn,6)
	goBtn.MouseButton1Click:Connect(function()
		local minP = tonumber(minBox.Text) or 10
		local pid=game.PlaceId
		local ok,sv=pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..pid.."/servers/Public?sortOrder=Desc&limit=100")) end)
		if ok and sv and sv.data then
			local list={}
			for _,s in ipairs(sv.data) do
				if s.id~=game.JobId and s.playing>=minP then table.insert(list,s) end
			end
			if #list>0 then
				table.sort(list,function(a,b) return a.playing > b.playing end)
				local best=list[1]
				task.spawn(function() showToast("👥  Tìm thấy server: "..best.playing.." người\nĐang tham gia...",C.CYAN,3) end)
				task.wait(1.5)
				TeleportService:TeleportToPlaceInstance(pid,best.id,LocalPlayer)
			else task.spawn(function() showToast("❌  Không có server nào ≥"..minP.." người!",C.RED,3) end) end
		else task.spawn(function() showToast("❌  Lỗi server list!",C.RED,3) end) end
	end)

	makeActionBtn("Rejoin (Server hiện tại)","🔄",function()
		task.spawn(function() showToast("🔄  Đang rejoin...",C.CYAN,2) end); task.wait(0.8)
		pcall(function() TeleportService:Teleport(game.PlaceId,LocalPlayer) end)
	end)
	makeActionBtn("Copy Server ID","📋",function()
		if setclipboard then setclipboard(game.JobId); task.spawn(function() showToast("📋  Đã copy Server ID!",C.GREEN,2) end)
		else task.spawn(function() showToast("❌  Executor không hỗ trợ clipboard!",C.RED,3) end) end
	end)

	makeSectionLabel("JOIN SERVER CỤ THỂ")
	local iF=Instance.new("Frame"); iF.Size=UDim2.new(1,-4,0,36); iF.BackgroundColor3=C.PANEL2
	iF.BorderSizePixel=0; iF.ZIndex=7; iF.Parent=ContentFrame; corner(iF,8); stroke(iF,1.2,0.5)
	local sBox=Instance.new("TextBox"); sBox.Size=UDim2.new(0.72,0,1,-8); sBox.Position=UDim2.new(0,6,0,4)
	sBox.BackgroundColor3=C.BG; sBox.PlaceholderText="Nhập Server ID..."; sBox.Text=""
	sBox.Font=Enum.Font.Gotham; sBox.TextSize=10; sBox.TextColor3=C.TEXT; sBox.PlaceholderColor3=C.SUB
	sBox.ZIndex=8; sBox.Parent=iF; corner(sBox,5)
	local jBtn=Instance.new("TextButton"); jBtn.Size=UDim2.new(0.25,0,1,-8); jBtn.Position=UDim2.new(0.74,0,0,4)
	jBtn.BackgroundColor3=C.CYAN; jBtn.Text="JOIN"; jBtn.Font=Enum.Font.GothamBold; jBtn.TextSize=10
	jBtn.TextColor3=C.BG; jBtn.ZIndex=8; jBtn.Parent=iF; corner(jBtn,5)
	jBtn.MouseButton1Click:Connect(function()
		local sid=sBox.Text
		if sid and #sid>5 then task.spawn(function() showToast("🚀  Đang join server...",C.CYAN,2) end); task.wait(0.8)
			pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,sid,LocalPlayer) end)
		else task.spawn(function() showToast("❌  Nhập Server ID hợp lệ!",C.RED,2) end) end
	end)

	makeSectionLabel("THÔNG TIN SERVER")
	local info=Instance.new("Frame"); info.Size=UDim2.new(1,-4,0,58); info.BackgroundColor3=C.PANEL2
	info.BorderSizePixel=0; info.ZIndex=7; info.Parent=ContentFrame; corner(info,8); stroke(info,1.2,0.5)
	local gameName="Unknown"
	pcall(function() gameName=game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
	local lines={"🎮  Game: "..gameName,"🆔  ID: "..string.sub(game.JobId,1,20).."...","👥  Players: "..#Players:GetPlayers().."/"..(game.Players.MaxPlayers or "?")}
	for i,line in ipairs(lines) do
		local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-8,0,17); l.Position=UDim2.new(0,5,0,(i-1)*18+2)
		l.BackgroundTransparency=1; l.Text=line; l.TextColor3=C.SUB; l.Font=Enum.Font.Gotham
		l.TextSize=9; l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=8; l.Parent=info
	end
end

-- ══════════════════════════════════════════
--   QUICK EXEC TAB (MỚI)
-- ══════════════════════════════════════════
local function LoadQuickExec()
	makeSectionLabel("QUICK EXECUTE — Paste URL hoặc Code")
	local descLbl=Instance.new("TextLabel"); descLbl.Size=UDim2.new(1,-4,0,28); descLbl.BackgroundTransparency=1
	descLbl.Text="Paste raw URL (https://...) hoặc Lua code trực tiếp rồi nhấn Run"
	descLbl.TextColor3=C.SUB; descLbl.Font=Enum.Font.Gotham; descLbl.TextSize=9
	descLbl.TextXAlignment=Enum.TextXAlignment.Center; descLbl.TextWrapped=true; descLbl.ZIndex=7; descLbl.Parent=ContentFrame

	local inputFrame=Instance.new("Frame"); inputFrame.Size=UDim2.new(1,-4,0,90); inputFrame.BackgroundColor3=C.PANEL2
	inputFrame.BorderSizePixel=0; inputFrame.ZIndex=7; inputFrame.Parent=ContentFrame; corner(inputFrame,8); stroke(inputFrame,1.2,0.4)
	local codeBox=Instance.new("TextBox"); codeBox.Size=UDim2.new(1,-8,1,-8); codeBox.Position=UDim2.new(0,4,0,4)
	codeBox.BackgroundTransparency=1; codeBox.PlaceholderText="https://raw.githubusercontent.com/... hoặc lua code..."
	codeBox.Text=""; codeBox.Font=Enum.Font.Code; codeBox.TextSize=9; codeBox.TextColor3=C.TEXT
	codeBox.PlaceholderColor3=C.SUB; codeBox.MultiLine=true; codeBox.TextXAlignment=Enum.TextXAlignment.Left
	codeBox.TextYAlignment=Enum.TextYAlignment.Top; codeBox.ClearTextOnFocus=false
	codeBox.ZIndex=8; codeBox.Parent=inputFrame

	local btnRow=Instance.new("Frame"); btnRow.Size=UDim2.new(1,-4,0,34); btnRow.BackgroundTransparency=1
	btnRow.ZIndex=7; btnRow.Parent=ContentFrame
	local btnLayout=Instance.new("UIListLayout"); btnLayout.FillDirection=Enum.FillDirection.Horizontal
	btnLayout.Padding=UDim.new(0,5); btnLayout.Parent=btnRow

	local runCode=Instance.new("TextButton"); runCode.Size=UDim2.new(0.48,0,1,0)
	runCode.BackgroundColor3=C.CYAN; runCode.Text="▶  RUN"; runCode.Font=Enum.Font.GothamBold; runCode.TextSize=12
	runCode.TextColor3=C.BG; runCode.ZIndex=8; runCode.Parent=btnRow; corner(runCode,8)
	runCode.MouseButton1Click:Connect(function()
		local input = codeBox.Text
		if not input or #input < 3 then task.spawn(function() showToast("❌  Chưa nhập gì!",C.RED,2) end) return end
		if input:sub(1,4)=="http" then
			-- Là URL
			local ok,code=pcall(function() return game:HttpGet(input) end)
			if ok and code then
				local f,e=loadstring(code)
				if f then task.spawn(f); task.spawn(function() showToast("✅  Đã chạy từ URL!",C.GREEN,2) end)
				else task.spawn(function() showToast("❌  Lỗi compile: "..(e or "?"),C.RED,3) end) end
			else task.spawn(function() showToast("❌  Không tải được URL!",C.RED,3) end) end
		else
			-- Là code trực tiếp
			local f,e=loadstring(input)
			if f then task.spawn(f); task.spawn(function() showToast("✅  Đã chạy code!",C.GREEN,2) end)
			else task.spawn(function() showToast("❌  Lỗi: "..(e or "?"),C.RED,3) end) end
		end
	end)

	local clearCode=Instance.new("TextButton"); clearCode.Size=UDim2.new(0.48,0,1,0)
	clearCode.BackgroundColor3=C.PANEL2; clearCode.Text="🗑  CLEAR"; clearCode.Font=Enum.Font.GothamBold; clearCode.TextSize=12
	clearCode.TextColor3=C.SUB; clearCode.ZIndex=8; clearCode.Parent=btnRow; corner(clearCode,8); stroke(clearCode,1.2,0.5)
	clearCode.MouseButton1Click:Connect(function() codeBox.Text="" end)

	-- Quick URL shortcuts
	makeSectionLabel("QUICK URLs")
	local quickURLs={
		{"Inf Yield",     "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
		{"Dex Explorer",  "https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Dex_Explorer_v2.lua"},
		{"SimpleAdmin",   "https://raw.githubusercontent.com/Tomi3gaming/SimpleAdmin/main/Source"},
	}
	for _,u in ipairs(quickURLs) do
		local capturedURL=u[2]; local capturedName=u[1]
		local qBtn=Instance.new("TextButton"); qBtn.Size=UDim2.new(1,-4,0,30); qBtn.Text=""
		qBtn.BackgroundColor3=C.PANEL2; qBtn.ZIndex=7; qBtn.Parent=ContentFrame; corner(qBtn,7); stroke(qBtn,1.2,0.5)
		local ql=Instance.new("TextLabel"); ql.Size=UDim2.new(0.4,0,1,0); ql.Position=UDim2.new(0,8,0,0)
		ql.BackgroundTransparency=1; ql.Text=capturedName; ql.TextColor3=C.CYAN; ql.Font=Enum.Font.GothamBold; ql.TextSize=10; ql.TextXAlignment=Enum.TextXAlignment.Left; ql.ZIndex=8; ql.Parent=qBtn
		local qu=Instance.new("TextLabel"); qu.Size=UDim2.new(0.55,0,1,0); qu.Position=UDim2.new(0.38,0,0,0)
		qu.BackgroundTransparency=1; qu.Text=capturedURL:sub(1,45).."..."; qu.TextColor3=C.SUB; qu.Font=Enum.Font.Code; qu.TextSize=7; qu.TextXAlignment=Enum.TextXAlignment.Left; qu.ZIndex=8; qu.Parent=qBtn
		qBtn.MouseButton1Click:Connect(function() codeBox.Text=capturedURL; task.spawn(function() showToast("📋  Đã điền URL: "..capturedName,C.CYAN,2) end) end)
	end
end

-- ══════════════════════════════════════════
--   SETTING TAB
-- ══════════════════════════════════════════
local function applyAccentColor(newColor)
	local old=Settings.accentColor; Settings.accentColor=newColor; C.CYAN=newColor
	for _,v in ipairs(Root:GetDescendants()) do
		if v:IsA("UIStroke") then v.Color=newColor end
		if v:IsA("TextLabel") and v.TextColor3==old then v.TextColor3=newColor end
		if v:IsA("ImageLabel") and v.ImageColor3==old then v.ImageColor3=newColor end
	end
	StatPlayersLbl.TextColor3=newColor; saveSettings()
	task.spawn(function() showToast("🎨  Đã đổi màu accent!",newColor,2) end)
end

local THEMES={
	{"🔵 Cyan  (Default)",Color3.fromRGB(0,210,255)},
	{"🟣 Purple",Color3.fromRGB(160,80,255)},
	{"🟢 Neon Green",Color3.fromRGB(50,255,120)},
	{"🔴 Red",Color3.fromRGB(255,60,60)},
	{"🟡 Gold",Color3.fromRGB(255,200,30)},
	{"🩷 Pink",Color3.fromRGB(255,100,200)},
	{"🟠 Orange",Color3.fromRGB(255,130,40)},
	{"⚪ White",Color3.fromRGB(220,230,255)},
}

local function LoadSetting()
	makeSectionLabel("ACCENT COLOR")
	for _,theme in ipairs(THEMES) do
		local col=theme[2]; makeColorBtn(theme[1],col,function() applyAccentColor(col) end)
	end
	makeSectionLabel("HIỂN THỊ THÔNG TIN")
	makeToggle("📊  Show FPS",Settings.showFPS,function(v) Settings.showFPS=v; updateStatWidget(); saveSettings() end)
	makeToggle("📶  Show Ping",Settings.showPing,function(v) Settings.showPing=v; updateStatWidget(); saveSettings() end)
	makeToggle("👥  Show Players",Settings.showPlayers,function(v) Settings.showPlayers=v; updateStatWidget(); saveSettings() end)
	makeToggle("⚔️  Show Dash CD",Settings.showDashCD,function(v) Settings.showDashCD=v; updateStatWidget(); saveSettings() end)
	makeSectionLabel("UTILITY")
	makeToggle("🔍  Skill Detector",Settings.showSkillDetector,function(v)
		Settings.showSkillDetector=v; updateStatWidget(); saveSettings()
		task.spawn(function() showToast(v and "🔍  Skill Detector đã bật!" or "🔍  Skill Detector đã tắt!",v and C.GREEN or C.RED,2) end)
	end)
	makeSectionLabel("NGUY HIỂM")
	local delSave=Instance.new("TextButton"); delSave.Size=UDim2.new(1,-4,0,30); delSave.Text="🗑  Xóa toàn bộ Save (Reset)"
	delSave.BackgroundColor3=Color3.fromRGB(60,12,12); delSave.TextColor3=C.RED; delSave.Font=Enum.Font.GothamBold
	delSave.TextSize=10; delSave.ZIndex=7; delSave.Parent=ContentFrame; corner(delSave,8); stroke(delSave,1.2,0.5)
	delSave.MouseButton1Click:Connect(function()
		SaveData=DEFAULT_SAVE; Favorites={}; writeSave(SaveData)
		task.spawn(function() showToast("🗑  Đã xóa save! Reload để áp dụng.",C.RED,3) end)
	end)
end

-- ══════════════════════════════════════════
--   REGISTER TABS
-- ══════════════════════════════════════════
local FPSTab      = makeTab("FPS")
local TechTab     = makeTab("TECH")
local VisualTab   = makeTab("VISUAL")
local ScriptTab   = makeTab("SCRIPT")
local MovesetTab  = makeTab("MOVESET")
local EmoteTab    = makeTab("EMOTE")
local AccessTab   = makeTab("ACCESS")
local MapTab      = makeTab("MAP")
local FavTab      = makeTab("⭐FAV")
local ServerTab   = makeTab("SERVER")
local ExecTab     = makeTab("EXEC")
local SettingTab  = makeTab("⚙")

FPSTab.MouseButton1Click:Connect(function()     setActive(FPSTab,1,LoadFPS) end)
TechTab.MouseButton1Click:Connect(function()    setActive(TechTab,2,LoadTech) end)
VisualTab.MouseButton1Click:Connect(function()  setActive(VisualTab,3,LoadVisual) end)
ScriptTab.MouseButton1Click:Connect(function()  setActive(ScriptTab,4,LoadScript) end)
MovesetTab.MouseButton1Click:Connect(function() setActive(MovesetTab,5,LoadMoveset) end)
EmoteTab.MouseButton1Click:Connect(function()   setActive(EmoteTab,6,LoadEmote) end)
AccessTab.MouseButton1Click:Connect(function()  setActive(AccessTab,7,LoadAccessories) end)
MapTab.MouseButton1Click:Connect(function()     setActive(MapTab,8,LoadMap) end)
FavTab.MouseButton1Click:Connect(function()     setActive(FavTab,9,LoadFavorites) end)
ServerTab.MouseButton1Click:Connect(function()  setActive(ServerTab,10,LoadServer) end)
ExecTab.MouseButton1Click:Connect(function()    setActive(ExecTab,11,LoadQuickExec) end)
SettingTab.MouseButton1Click:Connect(function() setActive(SettingTab,12,LoadSetting) end)

-- ══════════════════════════════════════════
--   KEY SUBMIT
-- ══════════════════════════════════════════
local function unlockGUI()
	KeyStatus.Text="✓  Key hợp lệ 24 giờ!"; KeyStatus.TextColor3=C.GREEN
	tw(KeySubmit,{BackgroundColor3=C.GREEN},0.2); task.wait(0.5)
	tw(KeyOverlay,{BackgroundTransparency=1},0.35)
	for _,v in pairs(KeyOverlay:GetChildren()) do
		if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then tw(v,{TextTransparency=1},0.3)
		elseif v:IsA("ImageLabel") then tw(v,{ImageTransparency=1},0.3)
		elseif v:IsA("Frame") then tw(v,{BackgroundTransparency=1},0.3) end
	end
	task.wait(0.38); KeyOverlay.Visible=false
	clearContent(); setActive(FPSTab,1,LoadFPS)
	task.spawn(function() task.wait(1); showToast("✅  CryoXHUB v4.0 mở khóa! 🎉",C.GREEN,3) end)
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
--   FPS / PING / PLAYERS / DASH CD LOOP
-- ══════════════════════════════════════════
local fpsCount=0; local lastFPSTime=tick()
RunService.RenderStepped:Connect(function()
	fpsCount+=1; local now=tick()
	if now-lastFPSTime>=0.5 then
		local fps=math.floor(fpsCount/(now-lastFPSTime)); fpsCount=0; lastFPSTime=now
		if Settings.showFPS then
			local col=fps>=55 and C.GREEN or fps>=30 and Color3.fromRGB(255,200,60) or C.RED
			StatFPSLbl.TextColor3=col; StatFPSLbl.Text="⚡ FPS: "..fps
		end
		if Settings.showPing then
			local ok,ping=pcall(function() return math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
			if ok then
				local pc=ping<=80 and C.GREEN or ping<=150 and Color3.fromRGB(255,200,60) or C.RED
				StatPingLbl.TextColor3=pc; StatPingLbl.Text="📶 Ping: "..ping.."ms"
			end
		end
		if Settings.showPlayers then StatPlayersLbl.Text="👥 Players: "..#Players:GetPlayers() end
	end
	if Settings.showDashCD then
		DashCDLabel.Text="DASH: READY ✓"; DashCDLabel.TextColor3=Color3.fromRGB(50,220,120)
		SideCDLabel.Text="SIDE: READY ✓"; SideCDLabel.TextColor3=Color3.fromRGB(50,220,120)
	end
end)

-- ══════════════════════════════════════════
--   TOAST 30 PHÚT
-- ══════════════════════════════════════════
task.spawn(function()
	while true do
		task.wait(1800)
		local msgs={
			"💙  Cảm ơn bạn đã dùng CryoXHUB v4.0!\nChúc bạn chơi vui vẻ~",
			"✨  CryoXHUB v4.0  —  Cảm ơn vì sự tin tưởng!",
			"🌊  Bạn đang dùng CryoXHUB 30 phút~\nThử tab ⭐FAV hoặc EXEC nhé! 💙",
		}
		task.spawn(function() showToast(msgs[math.random(1,#msgs)],C.CYAN,5) end)
	end
end)

-- ══════════════════════════════════════════
--   STARTUP
-- ══════════════════════════════════════════
task.wait(0.25)
animateOpen()
