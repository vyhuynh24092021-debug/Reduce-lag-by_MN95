-- CryoXHUB GUI v3.6
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CryoX_Furina_Final_v6"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local RunService      = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService     = game:GetService("HttpService")
local LocalPlayer     = Players.LocalPlayer
local StatsService    = game:GetService("Stats")

local ID_ANH_NEN    = "rbxthumb://type=Asset&id=116367849760314&w=420&h=420"
local ID_LOGO_DONG  = "rbxthumb://type=Asset&id=135753950157111&w=420&h=420"
local KEY_CHINH_XAC = "CryoXHUB"
local SAVE_FILE     = "CryoXHUB_save.json"

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

-- Stat overlays (ScreenGui level)
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
--   DASH CD SYSTEM
-- ══════════════════════════════════════════
local cdCooldowns={Dash=5.5,Side=2.3}; local activeCD={Dash=0,Side=0}
local pendingDash=false; local savedDir=Vector3.new(0,0,0)
local cdChar,cdHumanoid,cdRoot=nil,nil,nil

local function setupCDChar(c)
	cdChar=c; cdHumanoid=c:WaitForChild("Humanoid"); cdRoot=c:WaitForChild("HumanoidRootPart")
end
setupCDChar(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
LocalPlayer.CharacterAdded:Connect(function(nc) setupCDChar(nc); activeCD.Dash=0; activeCD.Side=0 end)

local function getDashTypeFromDir(dir)
	if dir.Magnitude<0.1 then return "Dash" end
	if not cdRoot then return "Dash" end
	local dot=dir.Unit:Dot(cdRoot.CFrame.LookVector)
	return (dot>0.5 or dot<-0.5) and "Dash" or "Side"
end

local cdMT=getrawmetatable(game); setreadonly(cdMT,false)
local cdOld=cdMT.__namecall
cdMT.__namecall=newcclosure(function(self,...)
	local method=getnamecallmethod()
	if method=="FireServer" and self.Name=="Communicate" then
		local data=({...})[1]
		if data and data.Key==Enum.KeyCode.Q then
			if cdHumanoid then savedDir=cdHumanoid.MoveDirection end; pendingDash=true
		end
	end
	return cdOld(self,...)
end)
setreadonly(cdMT,true)

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
--   FIX: gọi ngay khi load để áp dụng save
-- ══════════════════════════════════════════
local function updateStatWidget()
	StatFPSLbl.Visible     = Settings.showFPS
	StatPingLbl.Visible    = Settings.showPing
	StatPlayersLbl.Visible = Settings.showPlayers
	DashCDLabel.Visible    = Settings.showDashCD
	SideCDLabel.Visible    = Settings.showDashCD
	if Settings.showSkillDetector then startSkillDetector() else stopSkillDetector() end
end

updateStatWidget() -- áp dụng ngay lúc khởi động

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
	{"v3.6","Tab MAP + 16 Teleport locations"},
	{"v3.6","Skill Detector toggle trong Setting"},
	{"v3.6","Fix save: auto load khi khởi động"},
	{"v3.5","Tab Visual, Emote, Accessories mới"},
	{"v3.5","Tab SERVER + SETTING, Key 24H"},
	{"v3.5","Toast 30 phút, FPS/Ping live"},
	{"v3.4","Key overlay che GUI, 1 lần"},
	{"v3.0","Tăng kích thước right panel"},
	{"v2.0","Redesign toàn bộ GUI"},
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
--   UI BUILDERS
-- ══════════════════════════════════════════
local function makeScriptBtn(name, code)
	local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,-4,0,36); btn.Text=""
	btn.BackgroundColor3=C.PANEL2; btn.ZIndex=7; btn.Parent=ContentFrame; corner(btn,8); stroke(btn,1.2,0.5)
	local ic=Instance.new("TextLabel"); ic.Size=UDim2.new(0,28,1,0); ic.Position=UDim2.new(0,5,0,0)
	ic.BackgroundTransparency=1; ic.Text="▶"; ic.TextColor3=C.CYAN; ic.Font=Enum.Font.GothamBold
	ic.TextSize=12; ic.ZIndex=8; ic.Parent=btn
	local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,-36,1,0); nl.Position=UDim2.new(0,30,0,0)
	nl.BackgroundTransparency=1; nl.Text=name; nl.TextColor3=C.TEXT; nl.Font=Enum.Font.GothamBold
	nl.TextSize=12; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.ZIndex=8; nl.Parent=btn
	btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=Color3.fromRGB(0,38,68)},0.12); tw(nl,{TextColor3=C.CYAN},0.12) end)
	btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=C.PANEL2},0.12); tw(nl,{TextColor3=C.TEXT},0.12) end)
	btn.MouseButton1Click:Connect(function()
		tw(btn,{BackgroundColor3=Color3.fromRGB(0,65,100)},0.08); task.wait(0.1); tw(btn,{BackgroundColor3=C.PANEL2},0.18)
		local f,e=loadstring(code); if f then task.spawn(f) else warn(e) end
	end)
end

local function makeActionBtn(name, icon, callback)
	local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,-4,0,36); btn.Text=""
	btn.BackgroundColor3=C.PANEL2; btn.ZIndex=7; btn.Parent=ContentFrame; corner(btn,8); stroke(btn,1.2,0.5)
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

local function makeSectionLabel(text)
	local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-4,0,18); lbl.BackgroundTransparency=1
	lbl.Text="── "..text.." ──"; lbl.TextColor3=C.CYAN; lbl.Font=Enum.Font.GothamBold
	lbl.TextSize=9; lbl.TextXAlignment=Enum.TextXAlignment.Center; lbl.ZIndex=7; lbl.Parent=ContentFrame
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
	makeScriptBtn("Supa Tech",         [[loadstring(game:HttpGet("https://rawscripts.net/raw/The-Strongest-Battlegrounds-Supa-tech-v2-77454"))()]])
	makeScriptBtn("Kiba Tech",         [[loadstring(game:HttpGet("https://raw.githubusercontent.com/yqantg-pixel/Find/refs/heads/main/Protected_1593573630798166.lua.txt"))()]])
	makeScriptBtn("Oreo Tech",         [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/OreoTech/refs/heads/main/Protected_6856895483929371.lua"))()]])
	makeScriptBtn("Lethal Dash",       [[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/57a4d240a2440f0450986c966469092ccfb8d4797392cb8f469fa8b6e605e64d/download"))()]])
	makeScriptBtn("Back Dash Cancel",  [[loadstring(game:HttpGet("https://raw.githubusercontent.com/dinhthanhtuankiet1762009-sudo/Js/refs/heads/main/4418648b0e9b71ef.lua"))()]])
	makeScriptBtn("Instant Twisted v2",[[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/60a7a7c77395006ebd63fce0a17c13241f932bd414c9aba3158b716da00ade01/download"))()]])
	makeScriptBtn("Loop Dash",         [[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/28513f51c0ca2c03d4d7d94f59215d13ce1a2a470bf187f0a685b58ccb4dae98/download"))()]])
	makeScriptBtn("lix tech",          [[loadstring(game:HttpGet("https://raw.githubusercontent.com/MerebennieOfficial/ExoticJn/refs/heads/main/Protected_83737738.txt"))()]])
	makeScriptBtn("lethal kiba",       [[loadstring(game:HttpGet("https://raw.githubusercontent.com/MinhNhatHUB/MinhNhat/refs/heads/main/Lethal%20Kiba.lua"))()]])
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
end

local function LoadScript()
	makeScriptBtn("Fly GuiV3",         [[loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()]])
	makeScriptBtn("Anti Death Counter",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Anti-Death-Counter.lua"))()]])
	makeScriptBtn("Avatar Changer",    [[loadstring(game:HttpGet("https://raw.githubusercontent.com/darkdexv2/universalavatarchanger/main/avatarchanger"))()]])
	makeScriptBtn("Dex Explorer",      [[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Dex_Explorer_v2.lua"))()]])
	makeScriptBtn("Shield",            [[Instance.new("ForceField",game.Players.LocalPlayer.Character)]])
	makeScriptBtn("TouchFling",        [[loadstring(game:HttpGet("https://raw.githubusercontent.com/long191910/all-my-roblox-script/refs/heads/main/touchfling.lua"))()]])
	makeScriptBtn("orbit farm",        [[loadstring(game:httpGet("https://raw.githubusercontent.com/minhnhatdepzai8-cloud/FARM-KILL/refs/heads/main/TSB"))()]])
	makeScriptBtn("farm kill",         [[loadstring(game:HttpGet("https://raw.githubusercontent.com/minhnhatdepzai8-cloud/Farm-Kill-V2/refs/heads/main/TSB"))()]])
end

local function LoadMoveset()
	makeScriptBtn("KAR [SAITAMA]",  [[loadstring(game:HttpGet("https://raw.githubusercontent.com/OfficialAposty/RBLX-Scripts/refs/heads/main/UltimateLifeForm.lua"))()]])
	makeScriptBtn("Gojo [SAITAMA]", [[getgenv().morph=false
loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/BaldyToSorcerer/refs/heads/main/LatestV2.lua"))()]])
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
--   MAP TAB
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
--   SERVER TAB
-- ══════════════════════════════════════════
local function LoadServer()
	makeSectionLabel("SERVER HOP")
	makeActionBtn("Hop Server (Random)","🔀",function()
		local pid=game.PlaceId
		local ok,sv=pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..pid.."/servers/Public?sortOrder=Asc&limit=25")) end)
		if ok and sv and sv.data then
			local list={}
			for _,s in ipairs(sv.data) do if s.id~=game.JobId and s.playing<s.maxPlayers then table.insert(list,s.id) end end
			if #list>0 then showToast("🔀  Đang hop sang server mới...",C.CYAN,2); task.wait(1)
				TeleportService:TeleportToPlaceInstance(pid,list[math.random(1,#list)],LocalPlayer)
			else showToast("❌  Không tìm thấy server khác!",C.RED,3) end
		else showToast("❌  Lỗi khi lấy danh sách server!",C.RED,3) end
	end)
	makeActionBtn("Server Ít Người Nhất","👥",function()
		local pid=game.PlaceId
		local ok,sv=pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..pid.."/servers/Public?sortOrder=Asc&limit=25")) end)
		if ok and sv and sv.data and #sv.data>0 then
			local least,minP=nil,math.huge
			for _,s in ipairs(sv.data) do if s.id~=game.JobId and s.playing<minP then minP=s.playing; least=s.id end end
			if least then showToast("👥  Vào server ít người ("..minP.." players)...",C.CYAN,2); task.wait(1)
				TeleportService:TeleportToPlaceInstance(pid,least,LocalPlayer)
			else showToast("❌  Không tìm thấy server phù hợp!",C.RED,3) end
		else showToast("❌  Lỗi khi lấy danh sách server!",C.RED,3) end
	end)
	makeActionBtn("Rejoin (Server hiện tại)","🔄",function()
		showToast("🔄  Đang rejoin...",C.CYAN,2); task.wait(0.8)
		pcall(function() TeleportService:Teleport(game.PlaceId,LocalPlayer) end)
	end)
	makeActionBtn("Copy Server ID","📋",function()
		if setclipboard then setclipboard(game.JobId); showToast("📋  Đã copy Server ID!",C.GREEN,2)
		else showToast("❌  Executor không hỗ trợ clipboard!",C.RED,3) end
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
		if sid and #sid>5 then showToast("🚀  Đang join server...",C.CYAN,2); task.wait(0.8)
			pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,sid,LocalPlayer) end)
		else showToast("❌  Nhập Server ID hợp lệ!",C.RED,2) end
	end)
	makeSectionLabel("THÔNG TIN SERVER")
	local info=Instance.new("Frame"); info.Size=UDim2.new(1,-4,0,58); info.BackgroundColor3=C.PANEL2
	info.BorderSizePixel=0; info.ZIndex=7; info.Parent=ContentFrame; corner(info,8); stroke(info,1.2,0.5)
	local lines={"🎮  Game: "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
		"🆔  Server ID: "..string.sub(game.JobId,1,18).."...","👥  Players: "..#Players:GetPlayers().."  in server"}
	for i,line in ipairs(lines) do
		local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-8,0,17); l.Position=UDim2.new(0,5,0,(i-1)*18+2)
		l.BackgroundTransparency=1; l.Text=line; l.TextColor3=C.SUB; l.Font=Enum.Font.Gotham
		l.TextSize=9; l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=8; l.Parent=info
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
	showToast("🎨  Đã đổi màu accent!",newColor,2)
end

local THEMES={
	{"🔵 Cyan  (Default)",Color3.fromRGB(0,210,255)},
	{"🟣 Purple",Color3.fromRGB(160,80,255)},
	{"🟢 Neon Green",Color3.fromRGB(50,255,120)},
	{"🔴 Red",Color3.fromRGB(255,60,60)},
	{"🟡 Gold",Color3.fromRGB(255,200,30)},
	{"🩷 Pink",Color3.fromRGB(255,100,200)},
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
		showToast(v and "🔍  Skill Detector đã bật!" or "🔍  Skill Detector đã tắt!",v and C.GREEN or C.RED,2)
	end)
end

-- ══════════════════════════════════════════
--   REGISTER TABS
-- ══════════════════════════════════════════
local FPSTab=makeTab("FPS"); local TechTab=makeTab("TECH"); local VisualTab=makeTab("VISUAL")
local ScriptTab=makeTab("SCRIPT"); local MovesetTab=makeTab("MOVESET"); local EmoteTab=makeTab("EMOTE")
local AccessoriesTab=makeTab("ACCESS"); local MapTab=makeTab("MAP"); local ServerTab=makeTab("SERVER"); local SettingTab=makeTab("⚙")

FPSTab.MouseButton1Click:Connect(function()         setActive(FPSTab,1,LoadFPS) end)
TechTab.MouseButton1Click:Connect(function()        setActive(TechTab,2,LoadTech) end)
VisualTab.MouseButton1Click:Connect(function()      setActive(VisualTab,3,LoadVisual) end)
ScriptTab.MouseButton1Click:Connect(function()      setActive(ScriptTab,4,LoadScript) end)
MovesetTab.MouseButton1Click:Connect(function()     setActive(MovesetTab,5,LoadMoveset) end)
EmoteTab.MouseButton1Click:Connect(function()       setActive(EmoteTab,6,LoadEmote) end)
AccessoriesTab.MouseButton1Click:Connect(function() setActive(AccessoriesTab,7,LoadAccessories) end)
MapTab.MouseButton1Click:Connect(function()         setActive(MapTab,8,LoadMap) end)
ServerTab.MouseButton1Click:Connect(function()      setActive(ServerTab,9,LoadServer) end)
SettingTab.MouseButton1Click:Connect(function()     setActive(SettingTab,10,LoadSetting) end)

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
	clearContent(); setActive(FPSTab,1,LoadFPS)
	task.spawn(function() task.wait(1); showToast("✅  CryoXHUB mở khóa 24 giờ!",C.GREEN,3) end)
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
	if pendingDash then pendingDash=false; local dt=getDashTypeFromDir(savedDir); activeCD[dt]=cdCooldowns[dt] end
	if Settings.showDashCD then
		for k,v in pairs(activeCD) do if v>0 then activeCD[k]=math.max(0,v-0.016) end end
		DashCDLabel.Text=activeCD.Dash>0 and "DASH: "..string.format("%.1f",math.floor(activeCD.Dash*10)/10).."s" or "DASH: READY ✓"
		DashCDLabel.TextColor3=activeCD.Dash>0 and Color3.fromRGB(220,60,60) or Color3.fromRGB(50,220,120)
		SideCDLabel.Text=activeCD.Side>0 and "SIDE: "..string.format("%.1f",math.floor(activeCD.Side*10)/10).."s" or "SIDE: READY ✓"
		SideCDLabel.TextColor3=activeCD.Side>0 and Color3.fromRGB(220,60,60) or Color3.fromRGB(50,220,120)
	end
end)

-- ══════════════════════════════════════════
--   TOAST 30 PHÚT
-- ══════════════════════════════════════════
task.spawn(function()
	while true do
		task.wait(1800)
		local msgs={"💙  Cảm ơn bạn đã dùng CryoXHUB!\nChúc bạn chơi game vui vẻ~",
			"✨  CryoXHUB v3.6  —  Cảm ơn vì sự tin tưởng!",
			"🌊  Bạn đang dùng CryoXHUB được 30 phút~\nCảm ơn bạn rất nhiều! 💙"}
		local msg=msgs[math.random(1,#msgs)]
		local BT=Instance.new("Frame"); BT.Size=UDim2.new(0,320,0,68); BT.Position=UDim2.new(0.5,-160,1,80)
		BT.BackgroundColor3=Color3.fromRGB(2,12,24); BT.BorderSizePixel=0; BT.ZIndex=50; BT.Parent=ScreenGui; corner(BT,14)
		local bts=Instance.new("UIStroke"); bts.Color=Color3.fromRGB(0,210,255); bts.Thickness=2
		bts.Transparency=0; bts.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; bts.Parent=BT
		local btg=Instance.new("ImageLabel"); btg.Size=UDim2.new(1,60,1,60); btg.Position=UDim2.new(0,-30,0,-30)
		btg.BackgroundTransparency=1; btg.Image="rbxassetid://5028857084"; btg.ImageColor3=Color3.fromRGB(0,210,255)
		btg.ImageTransparency=0.65; btg.ZIndex=49; btg.Parent=BT
		local bb=Instance.new("Frame"); bb.Size=UDim2.new(1,0,0,3); bb.BackgroundColor3=Color3.fromRGB(0,210,255)
		bb.BorderSizePixel=0; bb.ZIndex=51; bb.Parent=BT; corner(bb,3)
		local bi=Instance.new("TextLabel"); bi.Size=UDim2.new(0,40,1,0); bi.Position=UDim2.new(0,6,0,0)
		bi.BackgroundTransparency=1; bi.Text="💙"; bi.TextSize=22; bi.ZIndex=51; bi.Parent=BT
		local bt=Instance.new("TextLabel"); bt.Size=UDim2.new(1,-52,0,22); bt.Position=UDim2.new(0,46,0,6)
		bt.BackgroundTransparency=1; bt.Text="CryoXHUB"; bt.TextColor3=Color3.fromRGB(0,210,255)
		bt.Font=Enum.Font.GothamBold; bt.TextSize=13; bt.TextXAlignment=Enum.TextXAlignment.Left; bt.ZIndex=51; bt.Parent=BT
		local bm=Instance.new("TextLabel"); bm.Size=UDim2.new(1,-52,0,34); bm.Position=UDim2.new(0,46,0,28)
		bm.BackgroundTransparency=1; bm.Text=msg; bm.TextColor3=Color3.fromRGB(180,220,255)
		bm.Font=Enum.Font.Gotham; bm.TextSize=10; bm.TextXAlignment=Enum.TextXAlignment.Left
		bm.TextWrapped=true; bm.ZIndex=51; bm.Parent=BT
		tw(BT,{Position=UDim2.new(0.5,-160,1,-88)},0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
		for _=1,3 do tw(bts,{Transparency=0.6},0.5); task.wait(0.55); tw(bts,{Transparency=0},0.5); task.wait(0.55) end
		task.wait(2.5); tw(BT,{Position=UDim2.new(0.5,-160,1,80)},0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.In)
		task.wait(0.35); BT:Destroy()
	end
end)

-- ══════════════════════════════════════════
--   STARTUP
-- ══════════════════════════════════════════
task.wait(0.25)
animateOpen()
