-- CryoXHUB GUI v5.1 — GUI v5 + Full Features v4.1
-- Layout pixel-perfect v5, chức năng đầy đủ v4.1

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CryoXHUB_v51"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local RunService      = game:GetService("RunService")
local HttpService     = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService= game:GetService("UserInputService")
local StatsService    = game:GetService("Stats")
local LocalPlayer     = Players.LocalPlayer

-- ══════════════════════════════════════════
--   DIMENSIONS
-- ══════════════════════════════════════════
local RW, RH = 580, 370
local C1W    = 148
local C2W    = 46
local C3W    = RW - C1W - C2W - 5*3
local PAD    = 5
local GAP    = 4
local FPANW  = math.floor(C3W * 0.595)
local CPANW  = C3W - FPANW - GAP
local SUBTAB_H = 30
local CONT_H   = RH - PAD*2 - SUBTAB_H - GAP

-- ══════════════════════════════════════════
--   COLORS
-- ══════════════════════════════════════════
local BG     = Color3.fromRGB(7,  13,  26)
local PANEL  = Color3.fromRGB(11, 19,  36)
local PANEL2 = Color3.fromRGB(15, 25,  48)
local PANEL3 = Color3.fromRGB(10, 17,  33)
local CYAN   = Color3.fromRGB(0,  200, 255)
local TEXT   = Color3.fromRGB(210, 235, 255)
local SUB    = Color3.fromRGB(85,  135, 185)
local RED    = Color3.fromRGB(215,  55,  55)
local GREEN  = Color3.fromRGB(40,  215, 110)
local WHITE  = Color3.fromRGB(245, 250, 255)
local ORANGE = Color3.fromRGB(255, 160,  30)

-- ══════════════════════════════════════════
--   SAVE / KEY
-- ══════════════════════════════════════════
local SAVE_FILE = "CryoXHUB_v51.json"
local KEY_STR   = "CryoXHUB"
local DEFAULT_SAVE = {
	keyVerified=false, keyTime=0,
	accentR=0, accentG=200, accentB=255,
	showFPS=false, showPing=false, showPlayers=false,
	showDashCD=false, showSkillDetector=false,
}
local function loadSave()
	local ok,r = pcall(function()
		if isfile and isfile(SAVE_FILE) then return HttpService:JSONDecode(readfile(SAVE_FILE)) end
	end)
	if ok and r then
		for k,v in pairs(DEFAULT_SAVE) do if r[k]==nil then r[k]=v end end
		return r
	end
	return DEFAULT_SAVE
end
local function writeSave(d) pcall(function() writefile(SAVE_FILE, HttpService:JSONEncode(d)) end) end
local SaveData = loadSave()

local Settings = {
	showFPS           = SaveData.showFPS,
	showPing          = SaveData.showPing,
	showPlayers       = SaveData.showPlayers,
	showDashCD        = SaveData.showDashCD,
	showSkillDetector = SaveData.showSkillDetector,
	accentColor       = Color3.fromRGB(SaveData.accentR, SaveData.accentG, SaveData.accentB),
}
local Favorites = type(SaveData.favorites)=="table" and SaveData.favorites or {}
local function saveFavorites() SaveData.favorites=Favorites; writeSave(SaveData) end
local function saveSettings()
	SaveData.accentR=math.floor(Settings.accentColor.R*255)
	SaveData.accentG=math.floor(Settings.accentColor.G*255)
	SaveData.accentB=math.floor(Settings.accentColor.B*255)
	SaveData.showFPS=Settings.showFPS; SaveData.showPing=Settings.showPing
	SaveData.showPlayers=Settings.showPlayers; SaveData.showDashCD=Settings.showDashCD
	SaveData.showSkillDetector=Settings.showSkillDetector; writeSave(SaveData)
end

local function checkKey()
	if SaveData.keyVerified and os.time()-(SaveData.keyTime or 0)<86400 then return true end
	SaveData.keyVerified=false; SaveData.keyTime=0; writeSave(SaveData); return false
end
local function saveKey() SaveData.keyVerified=true; SaveData.keyTime=os.time(); writeSave(SaveData) end
local keyVerified = checkKey()

-- ══════════════════════════════════════════
--   HELPERS
-- ══════════════════════════════════════════
local function tw(o,p,t,s,d)
	TweenService:Create(o,TweenInfo.new(t or .18,s or Enum.EasingStyle.Quint,d or Enum.EasingDirection.Out),p):Play()
end
local function rnd(p,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=p end
local function bdr(p,t,tr,col)
	local s=Instance.new("UIStroke"); s.Thickness=t or 1.2; s.Transparency=tr or .22
	s.Color=col or CYAN; s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=p; return s
end
local function mkF(parent,x,y,w,h,col,z,r,clip)
	local f=Instance.new("Frame")
	f.Size=UDim2.new(0,w,0,h); f.Position=UDim2.new(0,x,0,y)
	f.BackgroundColor3=col or PANEL; f.BorderSizePixel=0; f.ZIndex=z or 3
	if clip then f.ClipsDescendants=true end
	f.Parent=parent; if r then rnd(f,r) end; return f
end
local function mkT(parent,text,sz,col,font,x,y,w,h,z,xa)
	local l=Instance.new("TextLabel"); l.BackgroundTransparency=1
	l.Size=UDim2.new(0,w,0,h); l.Position=UDim2.new(0,x,0,y)
	l.Text=text; l.TextSize=sz or 10; l.TextColor3=col or TEXT
	l.Font=font or Enum.Font.Gotham; l.ZIndex=z or 5
	l.TextXAlignment=xa or Enum.TextXAlignment.Center
	l.TextTruncate=Enum.TextTruncate.AtEnd; l.Parent=parent; return l
end
local function mkDiv(parent,x,y,w,z)
	local d=mkF(parent,x,y,w,1,CYAN,z or 4); d.BackgroundTransparency=0.58; return d
end
local function mkScroll(parent,x,y,w,h,z)
	local s=Instance.new("ScrollingFrame")
	s.Size=UDim2.new(0,w,0,h); s.Position=UDim2.new(0,x,0,y)
	s.BackgroundTransparency=1; s.BorderSizePixel=0
	s.ScrollBarThickness=2; s.ScrollBarImageColor3=CYAN
	s.CanvasSize=UDim2.new(0,0,0,0); s.AutomaticCanvasSize=Enum.AutomaticSize.Y
	s.ZIndex=z or 5; s.Parent=parent; return s
end
local function vlist(parent,gap)
	local l=Instance.new("UIListLayout"); l.FillDirection=Enum.FillDirection.Vertical
	l.Padding=UDim.new(0,gap or 3); l.Parent=parent; return l
end
local function hlist(parent,gap,va)
	local l=Instance.new("UIListLayout"); l.FillDirection=Enum.FillDirection.Horizontal
	l.Padding=UDim.new(0,gap or 3)
	if va then l.VerticalAlignment=va end; l.Parent=parent; return l
end
local function ptop(parent,t) local p=Instance.new("UIPadding"); p.PaddingTop=UDim.new(0,t); p.Parent=parent end

-- ══════════════════════════════════════════
--   TOAST
-- ══════════════════════════════════════════
local function toast(msg,col,dur)
	col=col or CYAN; dur=dur or 2.5
	local T=mkF(ScreenGui,0,0,280,46,Color3.fromRGB(5,12,24),80,10)
	T.Position=UDim2.new(.5,-140,1,55); bdr(T,1.5,.04,col)
	mkF(T,6,5,3,36,col,81,2)
	local m=Instance.new("TextLabel"); m.Size=UDim2.new(1,-20,1,0); m.Position=UDim2.new(0,16,0,0)
	m.BackgroundTransparency=1; m.Text=msg; m.TextColor3=TEXT; m.Font=Enum.Font.GothamBold
	m.TextSize=10; m.TextXAlignment=Enum.TextXAlignment.Left; m.TextWrapped=true; m.ZIndex=81; m.Parent=T
	tw(T,{Position=UDim2.new(.5,-140,1,-54)},.26,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
	task.delay(dur,function()
		tw(T,{Position=UDim2.new(.5,-140,1,55)},.2)
		task.wait(.22); T:Destroy()
	end)
end

-- ══════════════════════════════════════════
--   HUD OVERLAYS (FPS/Ping/Players)
-- ══════════════════════════════════════════
local function mkHUD(y,col)
	local l=Instance.new("TextLabel"); l.Size=UDim2.new(0,200,0,16)
	l.Position=UDim2.new(0,8,0,y); l.BackgroundTransparency=1; l.Text=""
	l.TextColor3=col; l.Font=Enum.Font.GothamBold; l.TextSize=12
	l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=10; l.Visible=false; l.Parent=ScreenGui
	return l
end
local StatFPSLbl     = mkHUD(52,GREEN)
local StatPingLbl    = mkHUD(70,Color3.fromRGB(255,200,60))
local StatPlayersLbl = mkHUD(88,Color3.fromRGB(0,210,255))

local DashCDLabel=Instance.new("TextLabel"); DashCDLabel.Size=UDim2.new(0,110,0,20)
DashCDLabel.AnchorPoint=Vector2.new(.5,1); DashCDLabel.Position=UDim2.new(.5,-65,1,-125)
DashCDLabel.BackgroundTransparency=1; DashCDLabel.Font=Enum.Font.GothamBold; DashCDLabel.TextSize=12
DashCDLabel.TextColor3=GREEN; DashCDLabel.TextStrokeTransparency=.5
DashCDLabel.Text="DASH: READY ✓"; DashCDLabel.Visible=false; DashCDLabel.ZIndex=10; DashCDLabel.Parent=ScreenGui
local SideCDLabel=Instance.new("TextLabel"); SideCDLabel.Size=UDim2.new(0,110,0,20)
SideCDLabel.AnchorPoint=Vector2.new(.5,1); SideCDLabel.Position=UDim2.new(.5,65,1,-125)
SideCDLabel.BackgroundTransparency=1; SideCDLabel.Font=Enum.Font.GothamBold; SideCDLabel.TextSize=12
SideCDLabel.TextColor3=GREEN; SideCDLabel.TextStrokeTransparency=.5
SideCDLabel.Text="SIDE: READY ✓"; SideCDLabel.Visible=false; SideCDLabel.ZIndex=10; SideCDLabel.Parent=ScreenGui

-- ══════════════════════════════════════════
--   ESP SYSTEM
-- ══════════════════════════════════════════
local espEnabled=false; local espConnections={}; local espObjects={}

local function createESP(plr)
	if plr==LocalPlayer then return end
	local function buildESP()
		local char=plr.Character; if not char then return end
		local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
		if espObjects[plr] then pcall(function() espObjects[plr]:Destroy() end) end
		local bb=Instance.new("BillboardGui")
		bb.Size=UDim2.new(0,0,0,0); bb.StudsOffsetWorldSpace=Vector3.new(0,3,0)
		bb.AlwaysOnTop=true; bb.Adornee=hrp; bb.Parent=ScreenGui
		local nameL=Instance.new("TextLabel"); nameL.Size=UDim2.new(0,130,0,20)
		nameL.Position=UDim2.new(.5,-65,0,0); nameL.BackgroundTransparency=1
		nameL.Text=plr.DisplayName.." ["..plr.Name.."]"; nameL.TextColor3=CYAN
		nameL.Font=Enum.Font.GothamBold; nameL.TextSize=11; nameL.TextStrokeTransparency=.4; nameL.Parent=bb
		local hpL=Instance.new("TextLabel"); hpL.Size=UDim2.new(0,80,0,16)
		hpL.Position=UDim2.new(.5,-40,0,20); hpL.BackgroundTransparency=1
		hpL.TextColor3=GREEN; hpL.Font=Enum.Font.Gotham; hpL.TextSize=9; hpL.TextStrokeTransparency=.4; hpL.Parent=bb
		espObjects[plr]=bb
		local hum=char:FindFirstChildOfClass("Humanoid")
		if hum then
			espConnections[tostring(plr.UserId).."_hp"]=RunService.Heartbeat:Connect(function()
				if hum and hum.Parent then
					local pct=math.floor((hum.Health/math.max(hum.MaxHealth,1))*100)
					local c2=pct>60 and GREEN or pct>30 and Color3.fromRGB(255,200,60) or RED
					hpL.Text="❤ "..pct.."%"; hpL.TextColor3=c2
				end
			end)
		end
	end
	buildESP()
	espConnections[plr]=plr.CharacterAdded:Connect(function() task.wait(.5); buildESP() end)
end

local function removeESP(plr)
	if espObjects[plr] then pcall(function() espObjects[plr]:Destroy() end); espObjects[plr]=nil end
	local k=tostring(plr.UserId)
	for _,key in ipairs({plr, k.."_hp"}) do
		if espConnections[key] then pcall(function() espConnections[key]:Disconnect() end); espConnections[key]=nil end
	end
end

local function toggleESP(state)
	espEnabled=state
	if state then
		for _,p in ipairs(Players:GetPlayers()) do createESP(p) end
		espConnections["added"]=Players.PlayerAdded:Connect(createESP)
		espConnections["removed"]=Players.PlayerRemoving:Connect(removeESP)
	else
		for _,p in ipairs(Players:GetPlayers()) do removeESP(p) end
		for k,c in pairs(espConnections) do pcall(function() c:Disconnect() end); espConnections[k]=nil end
	end
end

-- ══════════════════════════════════════════
--   ESP FRIENDS
-- ══════════════════════════════════════════
local espFriendsEnabled=false; local espFriendObjs={}; local espFriendConns={}

local function isFriend(plr)
	local ok,r=pcall(function() return LocalPlayer:IsFriendsWith(plr.UserId) end)
	return ok and r
end

local function createFriendESP(plr)
	if plr==LocalPlayer then return end
	if not isFriend(plr) then return end
	local function buildF()
		local char=plr.Character; if not char then return end
		local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
		if espFriendObjs[plr] then pcall(function() espFriendObjs[plr]:Destroy() end) end
		local bb=Instance.new("BillboardGui")
		bb.Size=UDim2.new(0,0,0,0); bb.StudsOffsetWorldSpace=Vector3.new(0,3.5,0)
		bb.AlwaysOnTop=true; bb.Adornee=hrp; bb.Parent=ScreenGui
		local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(0,140,0,20)
		nl.Position=UDim2.new(.5,-70,0,0); nl.BackgroundTransparency=1
		nl.Text="👥 "..plr.DisplayName; nl.TextColor3=Color3.fromRGB(100,255,160)
		nl.Font=Enum.Font.GothamBold; nl.TextSize=12; nl.TextStrokeTransparency=.3; nl.Parent=bb
		local tg=Instance.new("TextLabel"); tg.Size=UDim2.new(0,80,0,14)
		tg.Position=UDim2.new(.5,-40,0,22); tg.BackgroundTransparency=1
		tg.Text="[FRIEND]"; tg.TextColor3=Color3.fromRGB(100,255,160)
		tg.Font=Enum.Font.GothamBold; tg.TextSize=9; tg.TextStrokeTransparency=.4; tg.Parent=bb
		espFriendObjs[plr]=bb
	end
	buildF()
	espFriendConns[plr]=plr.CharacterAdded:Connect(function() task.wait(.5); buildF() end)
end

local function removeFriendESP(plr)
	if espFriendObjs[plr] then pcall(function() espFriendObjs[plr]:Destroy() end); espFriendObjs[plr]=nil end
	if espFriendConns[plr] then pcall(function() espFriendConns[plr]:Disconnect() end); espFriendConns[plr]=nil end
end

local function toggleFriendESP(state)
	espFriendsEnabled=state
	if state then
		for _,p in ipairs(Players:GetPlayers()) do createFriendESP(p) end
		espFriendConns["added"]=Players.PlayerAdded:Connect(createFriendESP)
		espFriendConns["removed"]=Players.PlayerRemoving:Connect(removeFriendESP)
	else
		for _,p in ipairs(Players:GetPlayers()) do removeFriendESP(p) end
		for k,c in pairs(espFriendConns) do pcall(function() c:Disconnect() end); espFriendConns[k]=nil end
	end
end

-- ══════════════════════════════════════════
--   HITBOX EXPANDER
-- ══════════════════════════════════════════
local hitboxEnabled=false; local hitboxSize=Vector3.new(6,6,6); local hitboxConns={}

local function applyHitbox(plr)
	if plr==LocalPlayer then return end
	local function doHitbox()
		local char=plr.Character; if not char then return end
		local hrp=char:FindFirstChild("HumanoidRootPart")
		if hrp then pcall(function() hrp.Size=hitboxSize end) end
	end
	doHitbox()
	hitboxConns[plr]=plr.CharacterAdded:Connect(function() task.wait(.5); doHitbox() end)
end

local function removeHitbox(plr)
	if hitboxConns[plr] then pcall(function() hitboxConns[plr]:Disconnect() end); hitboxConns[plr]=nil end
	pcall(function()
		local char=plr.Character; if not char then return end
		local hrp=char:FindFirstChild("HumanoidRootPart")
		if hrp then hrp.Size=Vector3.new(2,2,1) end
	end)
end

local function toggleHitbox(state, sz)
	hitboxEnabled=state
	if sz then hitboxSize=Vector3.new(sz,sz,sz) end
	if state then
		for _,p in ipairs(Players:GetPlayers()) do applyHitbox(p) end
		hitboxConns["added"]=Players.PlayerAdded:Connect(applyHitbox)
	else
		for _,p in ipairs(Players:GetPlayers()) do removeHitbox(p) end
		if hitboxConns["added"] then pcall(function() hitboxConns["added"]:Disconnect() end); hitboxConns["added"]=nil end
	end
end

-- ══════════════════════════════════════════
--   NOCLIP
-- ══════════════════════════════════════════
local noclipEnabled=false; local noclipConn=nil
local function toggleNoclip(state)
	noclipEnabled=state
	if state then
		noclipConn=RunService.Stepped:Connect(function()
			local char=LocalPlayer.Character; if not char then return end
			for _,p in ipairs(char:GetDescendants()) do
				if p:IsA("BasePart") then p.CanCollide=false end
			end
		end)
	else
		if noclipConn then noclipConn:Disconnect(); noclipConn=nil end
		local char=LocalPlayer.Character
		if char then for _,p in ipairs(char:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide=true end
		end end
	end
end

-- ══════════════════════════════════════════
--   ANTI-AFK
-- ══════════════════════════════════════════
local antiAFKConn=nil
local function toggleAntiAFK(state)
	if state then
		if not antiAFKConn then
			local VU=game:GetService("VirtualUser")
			antiAFKConn=Players.LocalPlayer.Idled:Connect(function()
				VU:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
				task.wait(1)
				VU:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
			end)
		end
	else
		if antiAFKConn then antiAFKConn:Disconnect(); antiAFKConn=nil end
	end
end

-- ══════════════════════════════════════════
--   SKILL DETECTOR
-- ══════════════════════════════════════════
local skillDetConn=nil; local skillDetState={}
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
		lbl.TextColor3=Color3.new(1,1,1); lbl.TextStrokeTransparency=.5; lbl.Parent=bb
	end
	bb.Label.Text=text
end
local function removeBillboard(target)
	if target and target:FindFirstChild("Head") then
		local bb=target.Head:FindFirstChild("SkillTag"); if bb then bb:Destroy() end
	end
end
local function clearAllBillboards()
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=LocalPlayer and p.Character then removeBillboard(p.Character) end
	end; skillDetState={}
end
local function startSkillDetector()
	if skillDetConn then return end
	skillDetConn=RunService.Heartbeat:Connect(function()
		for _,p in ipairs(Players:GetPlayers()) do
			if p~=LocalPlayer then
				local char=p.Character; local bp=p:FindFirstChildOfClass("Backpack")
				if char and bp then
					local st=nil
					for _,tool in ipairs(bp:GetChildren()) do
						if strongSkills[tool.Name] then st="strong";break end
						if weakSkills[tool.Name] then st="weak";break end
					end
					local last=skillDetState[p]
					if st=="strong" then
						if last~="strong" then createBillboard(char,"💢") end; skillDetState[p]="strong"
					elseif st=="weak" then
						if last=="strong" then createBillboard(char,"☠")
							task.delay(math.random(8,9),function()
								if skillDetState[p]=="weak" then removeBillboard(char) end
							end)
						else removeBillboard(char) end; skillDetState[p]="weak"
					else removeBillboard(char); skillDetState[p]=nil end
				end
			end
		end
	end)
end
local function stopSkillDetector()
	if skillDetConn then skillDetConn:Disconnect(); skillDetConn=nil end; clearAllBillboards()
end

-- ══════════════════════════════════════════
--   STAT WIDGET UPDATE
-- ══════════════════════════════════════════
local function updateStatWidget()
	StatFPSLbl.Visible=Settings.showFPS; StatPingLbl.Visible=Settings.showPing
	StatPlayersLbl.Visible=Settings.showPlayers; DashCDLabel.Visible=Settings.showDashCD
	SideCDLabel.Visible=Settings.showDashCD
	if Settings.showSkillDetector then startSkillDetector() else stopSkillDetector() end
end
updateStatWidget()

-- ══════════════════════════════════════════
--   ROOT FRAME
-- ══════════════════════════════════════════
local Root=mkF(ScreenGui,0,0,RW,RH,BG,2,12,true)
Root.Position=UDim2.new(.5,-RW/2,.5,-RH/2)
Root.Active=true; Root.Draggable=true; Root.Visible=false
bdr(Root,1.6,.07)
local RootGlow=Instance.new("ImageLabel"); RootGlow.Size=UDim2.new(1,80,1,80)
RootGlow.Position=UDim2.new(0,-40,0,-40); RootGlow.BackgroundTransparency=1
RootGlow.Image="rbxassetid://5028857084"; RootGlow.ImageColor3=CYAN
RootGlow.ImageTransparency=.94; RootGlow.ZIndex=1; RootGlow.Parent=Root

-- ══════════════════════════════════════════
--   KEY OVERLAY
-- ══════════════════════════════════════════
local KO=mkF(Root,0,0,RW,RH,BG,22,12)
KO.BackgroundTransparency=.04; KO.Visible=not keyVerified
local KGl=Instance.new("ImageLabel"); KGl.Size=UDim2.new(0,200,0,200)
KGl.Position=UDim2.new(.5,-100,.5,-100); KGl.BackgroundTransparency=1
KGl.Image="rbxassetid://5028857084"; KGl.ImageColor3=CYAN; KGl.ImageTransparency=.76
KGl.ZIndex=23; KGl.Parent=KO
mkT(KO,"🔐",22,CYAN,Enum.Font.GothamBold,0,0,RW,40,24).Position=UDim2.new(0,0,.10,0)
mkT(KO,"Nhập key để mở CryoXHUB",13,CYAN,Enum.Font.GothamBold,0,0,RW,22,24).Position=UDim2.new(0,0,.28,0)
mkT(KO,"Key hợp lệ 24 giờ  •  Key: CryoXHUB",10,SUB,Enum.Font.Gotham,0,0,RW,18,24).Position=UDim2.new(0,0,.40,0)
local KInput=Instance.new("TextBox"); KInput.Size=UDim2.new(.62,0,0,34); KInput.Position=UDim2.new(.19,0,.50,0)
KInput.BackgroundColor3=PANEL2; KInput.PlaceholderText="Nhập Key tại đây..."; KInput.Text=""
KInput.Font=Enum.Font.Gotham; KInput.TextSize=12; KInput.TextColor3=TEXT; KInput.PlaceholderColor3=SUB
KInput.ZIndex=25; KInput.Parent=KO; rnd(KInput,8); bdr(KInput,1.4,.22)
local KStat=mkT(KO,"",10,RED,Enum.Font.Gotham,0,0,RW,16,25); KStat.Position=UDim2.new(0,0,.66,0)
local KBtn=Instance.new("TextButton"); KBtn.Size=UDim2.new(.62,0,0,30); KBtn.Position=UDim2.new(.19,0,.72,0)
KBtn.BackgroundColor3=CYAN; KBtn.Text="XÁC NHẬN  (24H)"; KBtn.Font=Enum.Font.GothamBold
KBtn.TextSize=12; KBtn.TextColor3=BG; KBtn.ZIndex=25; KBtn.Parent=KO; rnd(KBtn,8)
KBtn.MouseEnter:Connect(function() tw(KBtn,{BackgroundColor3=Color3.fromRGB(0,225,255)},.1) end)
KBtn.MouseLeave:Connect(function() tw(KBtn,{BackgroundColor3=CYAN},.1) end)

-- ══════════════════════════════════════════
--   COLUMN 1
-- ══════════════════════════════════════════
local Col1=mkF(Root,PAD,PAD,C1W,RH-PAD*2,Color3.fromRGB(0,0,0),3); Col1.BackgroundTransparency=1

-- Avatar Card
local AH=145
local ACard=mkF(Col1,0,0,C1W,AH,PANEL,3,8); bdr(ACard,1.1,.28)
local aGlow=Instance.new("ImageLabel"); aGlow.Size=UDim2.new(0,66,0,66); aGlow.Position=UDim2.new(.5,-33,0,3)
aGlow.BackgroundTransparency=1; aGlow.Image="rbxassetid://5028857084"; aGlow.ImageColor3=CYAN
aGlow.ImageTransparency=.65; aGlow.ZIndex=4; aGlow.Parent=ACard
local aImg=Instance.new("ImageLabel"); aImg.Size=UDim2.new(0,52,0,52); aImg.Position=UDim2.new(.5,-26,0,8)
aImg.Image="rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150"
aImg.BackgroundColor3=PANEL2; aImg.ZIndex=5; aImg.Parent=ACard; rnd(aImg,999); bdr(aImg,1.8,.06)
mkT(ACard,LocalPlayer.DisplayName,11,TEXT,Enum.Font.GothamBold,4,63,C1W-8,16,5)
mkT(ACard,"@"..LocalPlayer.Name,9,CYAN,Enum.Font.Gotham,4,79,C1W-8,14,5)
mkDiv(ACard,8,96,C1W-16)
mkT(ACard,"UID: "..LocalPlayer.UserId,8,SUB,Enum.Font.Gotham,4,100,C1W-8,13,5)
local gn="Unknown"
pcall(function() gn=game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
mkT(ACard,gn,8,SUB,Enum.Font.Gotham,4,113,C1W-8,13,5)
mkT(ACard,"CryoXHUB  v5.1",8,CYAN,Enum.Font.GothamBold,4,128,C1W-8,13,5)

-- Dark/Light toggle strip (bên dưới avatar)
local ThemeH=22
local TBar=mkF(Col1,0,AH+GAP,C1W,ThemeH,PANEL,3,6); bdr(TBar,1,.3)
local DarkBtn=Instance.new("TextButton"); DarkBtn.Size=UDim2.new(.5,-1,1,-2); DarkBtn.Position=UDim2.new(0,1,0,1)
DarkBtn.BackgroundColor3=Color3.fromRGB(0,38,85); DarkBtn.Text="🌙 Dark"; DarkBtn.Font=Enum.Font.GothamBold
DarkBtn.TextSize=8; DarkBtn.TextColor3=CYAN; DarkBtn.ZIndex=5; DarkBtn.Parent=TBar; rnd(DarkBtn,5)
local LightBtn=Instance.new("TextButton"); LightBtn.Size=UDim2.new(.5,-1,1,-2); LightBtn.Position=UDim2.new(.5,0,0,1)
LightBtn.BackgroundColor3=PANEL2; LightBtn.Text="☀️ Light"; LightBtn.Font=Enum.Font.GothamBold
LightBtn.TextSize=8; LightBtn.TextColor3=SUB; LightBtn.ZIndex=5; LightBtn.Parent=TBar; rnd(LightBtn,5)

-- Leaderboard
local RANKH=96
local RANKY=AH+GAP+ThemeH+GAP
local RankCard=mkF(Col1,0,RANKY,C1W,RANKH,PANEL,3,8); bdr(RankCard,1.1,.28)
mkT(RankCard,"🏆 LEADERBOARD",8,CYAN,Enum.Font.GothamBold,5,4,C1W-10,14,5,Enum.TextXAlignment.Left)
mkDiv(RankCard,5,19,C1W-10)
local RankScroll=mkScroll(RankCard,2,22,C1W-4,RANKH-24,5); vlist(RankScroll,2); ptop(RankScroll,1)
local rankMedal={"🥇","🥈","🥉"}
local function refreshRank()
	for _,v in pairs(RankScroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
	local plrs=Players:GetPlayers(); local entries={}
	for _,p in ipairs(plrs) do
		local sc=0; pcall(function()
			local ls=p:FindFirstChild("leaderstats"); if ls then
				for _,v2 in pairs(ls:GetChildren()) do
					local n=tonumber(tostring(v2.Value)); if n then sc=sc+n;break end
				end
			end
		end)
		table.insert(entries,{name=p.DisplayName,score=sc})
	end
	table.sort(entries,function(a,b) return a.score>b.score end)
	for i,e in ipairs(entries) do
		if i>7 then break end
		local row=mkF(RankScroll,0,0,C1W-6,17,PANEL2,6,4)
		mkT(row,rankMedal[i] or tostring(i),7,i<=3 and ORANGE or SUB,Enum.Font.GothamBold,1,0,16,17,7)
		mkT(row,e.name,7,TEXT,Enum.Font.Gotham,17,0,C1W-54,17,7,Enum.TextXAlignment.Left)
		mkT(row,tostring(e.score),7,CYAN,Enum.Font.GothamBold,C1W-36,0,32,17,7)
	end
end
pcall(refreshRank)
task.spawn(function() while task.wait(6) do pcall(refreshRank) end end)
Players.PlayerAdded:Connect(function() task.wait(.5);pcall(refreshRank) end)
Players.PlayerRemoving:Connect(function() task.wait(.5);pcall(refreshRank) end)

-- Update Log
local ULOGY2=RANKY+RANKH+GAP
local ULOH=RH-PAD*2-ULOGY2
local UCard=mkF(Col1,0,ULOGY2,C1W,ULOH,PANEL,3,8); bdr(UCard,1.1,.28)
mkT(UCard,"UPDATE LOG",8,SUB,Enum.Font.GothamBold,5,4,C1W-10,13,5,Enum.TextXAlignment.Left)
mkDiv(UCard,5,18,C1W-10)
local UScroll=mkScroll(UCard,2,21,C1W-4,ULOH-23,5); vlist(UScroll,2); ptop(UScroll,1)
local logs={
	{"v5.1","ESP + ESP Friends + Hitbox"},
	{"v5.1","Merge full features v4.1"},
	{"v5.1","WalkSpeed/Jump slider fixed"},
	{"v5.0","Pixel perfect GUI rebuild"},
	{"v4.1","ESP, Noclip, Anti-AFK"},
	{"v4.1","Server hop, Quick Exec"},
	{"v4.0","Tab MAP 16 locations"},
	{"v3.5","Key 24H, Visual tab"},
}
for _,u in ipairs(logs) do
	local row=mkF(UScroll,0,0,C1W-6,17,PANEL2,6,4)
	mkT(row,u[1],6,CYAN,Enum.Font.GothamBold,2,0,28,17,7)
	mkT(row,u[2],6,SUB,Enum.Font.Gotham,30,0,C1W-34,17,7,Enum.TextXAlignment.Left)
end

-- ══════════════════════════════════════════
--   COLUMN 2 — Main Tab Icons
-- ══════════════════════════════════════════
local C2X=PAD+C1W+GAP
local Col2=mkF(Root,C2X,PAD,C2W,RH-PAD*2,PANEL,3,8,true); bdr(Col2,1.1,.28)
local C2InnFrame=mkF(Col2,2,4,C2W-4,RH-PAD*2-44,Color3.fromRGB(0,0,0),4); C2InnFrame.BackgroundTransparency=1
vlist(C2InnFrame,3)

local MiniBtn=Instance.new("TextButton"); MiniBtn.Size=UDim2.new(1,-4,0,28); MiniBtn.Position=UDim2.new(0,2,1,-32)
MiniBtn.BackgroundColor3=PANEL2; MiniBtn.Text="◈"; MiniBtn.Font=Enum.Font.GothamBold; MiniBtn.TextSize=12
MiniBtn.TextColor3=CYAN; MiniBtn.ZIndex=5; MiniBtn.Parent=Col2; rnd(MiniBtn,6); bdr(MiniBtn,1,.5)

local mainTabs={
	{icon="⚔️",name="Tech"},   {icon="📊",name="FPS"},    {icon="👁️",name="Visual"},
	{icon="👤",name="Player"},  {icon="🗺️",name="Map"},    {icon="🖥️",name="Server"},
	{icon="⚙️",name="Setting"},
}
local mainBtns={}; local activeMainBtn=nil

-- ══════════════════════════════════════════
--   COLUMN 3 — SubTab + Content + Config
-- ══════════════════════════════════════════
local C3X=C2X+C2W+GAP
local Col3=mkF(Root,C3X,PAD,C3W,RH-PAD*2,Color3.fromRGB(0,0,0),3); Col3.BackgroundTransparency=1

-- SubTab row
local STRow=mkF(Col3,0,0,C3W,SUBTAB_H,PANEL,4,8); bdr(STRow,1.1,.28)
local CloseBtn=Instance.new("TextButton"); CloseBtn.Size=UDim2.new(0,SUBTAB_H,0,SUBTAB_H)
CloseBtn.Position=UDim2.new(1,-SUBTAB_H,0,0); CloseBtn.BackgroundColor3=RED
CloseBtn.Text="✕"; CloseBtn.TextColor3=TEXT; CloseBtn.Font=Enum.Font.GothamBold
CloseBtn.TextSize=11; CloseBtn.ZIndex=8; CloseBtn.Parent=STRow; rnd(CloseBtn,6)
CloseBtn.MouseEnter:Connect(function() tw(CloseBtn,{BackgroundColor3=Color3.fromRGB(240,70,70)},.1) end)
CloseBtn.MouseLeave:Connect(function() tw(CloseBtn,{BackgroundColor3=RED},.1) end)
local SubScroll=Instance.new("ScrollingFrame"); SubScroll.Size=UDim2.new(0,C3W-SUBTAB_H-4,0,SUBTAB_H-4)
SubScroll.Position=UDim2.new(0,2,0,2); SubScroll.BackgroundTransparency=1; SubScroll.BorderSizePixel=0
SubScroll.ScrollBarThickness=0; SubScroll.CanvasSize=UDim2.new(0,0,0,0)
SubScroll.AutomaticCanvasSize=Enum.AutomaticSize.X; SubScroll.ScrollingDirection=Enum.ScrollingDirection.X
SubScroll.ZIndex=5; SubScroll.Parent=STRow
hlist(SubScroll,3,Enum.VerticalAlignment.Center)

-- Content area
local ContY=SUBTAB_H+GAP
local ContArea=mkF(Col3,0,ContY,C3W,CONT_H,Color3.fromRGB(0,0,0),3); ContArea.BackgroundTransparency=1
hlist(ContArea,GAP)

-- Feature panel (left)
local FPanel=mkF(ContArea,0,0,FPANW,CONT_H,PANEL,3,8,true); bdr(FPanel,1.1,.28)
mkF(FPanel,0,0,FPANW,CONT_H,BG,4,8).BackgroundTransparency=.5
local FScroll=mkScroll(FPanel,3,3,FPANW-6,CONT_H-6,6); vlist(FScroll,3); ptop(FScroll,2)

-- Config panel (right)
local CPanel=mkF(ContArea,0,0,CPANW,CONT_H,PANEL,3,8,true); bdr(CPanel,1.1,.28)
mkF(CPanel,0,0,CPANW,CONT_H,BG,4,8).BackgroundTransparency=.5
mkT(CPanel,"CONFIG",8,TEXT,Enum.Font.GothamBold,0,4,CPANW,14,7)
local CScroll=mkScroll(CPanel,3,20,CPANW-6,CONT_H-22,6); vlist(CScroll,3); ptop(CScroll,2)

-- ══════════════════════════════════════════
--   WIDGET BUILDERS
-- ══════════════════════════════════════════

-- Feature button (click to run)
local function mkFeat(label, icon, cb)
	local row=mkF(FScroll,0,0,FPANW-8,26,PANEL2,7,5)
	mkT(row,icon or "×",9,CYAN,Enum.Font.GothamBold,3,0,14,26,8)
	mkT(row,label,9,TEXT,Enum.Font.Gotham,18,0,FPANW-72,26,8,Enum.TextXAlignment.Left)
	local runBtn=Instance.new("TextButton"); runBtn.Size=UDim2.new(0,44,0,18)
	runBtn.Position=UDim2.new(1,-48,0,4); runBtn.BackgroundColor3=PANEL3
	runBtn.Text="RUN"; runBtn.Font=Enum.Font.GothamBold; runBtn.TextSize=7
	runBtn.TextColor3=CYAN; runBtn.ZIndex=9; runBtn.Parent=row; rnd(runBtn,4); bdr(runBtn,1,.4)
	local hbtn=Instance.new("TextButton"); hbtn.Size=UDim2.new(1,0,1,0)
	hbtn.BackgroundTransparency=1; hbtn.Text=""; hbtn.ZIndex=10; hbtn.Parent=row
	hbtn.MouseEnter:Connect(function() tw(row,{BackgroundColor3=Color3.fromRGB(0,35,70)},.1) end)
	hbtn.MouseLeave:Connect(function() tw(row,{BackgroundColor3=PANEL2},.1) end)
	hbtn.MouseButton1Click:Connect(function()
		tw(row,{BackgroundColor3=Color3.fromRGB(0,60,100)},.08)
		task.wait(.12); tw(row,{BackgroundColor3=PANEL2},.15)
		if cb then task.spawn(cb) end
	end)
	return row
end

-- Section label
local function mkSec(text)
	local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-4,0,16); l.BackgroundTransparency=1
	l.Text="── "..text.." ──"; l.TextColor3=CYAN; l.Font=Enum.Font.GothamBold
	l.TextSize=8; l.TextXAlignment=Enum.TextXAlignment.Center; l.ZIndex=6; l.Parent=FScroll
end

-- Toggle (config panel)
local function mkToggle(label, default, cb)
	local row=mkF(CScroll,0,0,CPANW-8,22,PANEL2,7,5)
	mkT(row,label,8,TEXT,Enum.Font.Gotham,5,0,CPANW-50,22,8,Enum.TextXAlignment.Left)
	local on=default or false
	local pill=mkF(row,CPANW-46,4,26,14,on and CYAN or PANEL3,8,999)
	local knob=mkF(pill,on and 13 or 1,1,12,12,WHITE,9,999)
	local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,1,0)
	btn.BackgroundTransparency=1; btn.Text=""; btn.ZIndex=10; btn.Parent=row
	btn.MouseButton1Click:Connect(function()
		on=not on
		tw(pill,{BackgroundColor3=on and CYAN or PANEL3},.15)
		tw(knob,{Position=UDim2.new(0,on and 13 or 1,0,1)},.15)
		if cb then cb(on) end
	end)
	return row,function() return on end
end

-- Slider (config panel) — FIXED drag
local function mkSlider(label, mn, mx, def, cb)
	local row=mkF(CScroll,0,0,CPANW-8,34,PANEL2,7,5)
	local val=def or mn
	mkT(row,label,8,TEXT,Enum.Font.Gotham,5,2,CPANW-46,13,8,Enum.TextXAlignment.Left)
	local vl=mkT(row,tostring(val),8,CYAN,Enum.Font.GothamBold,CPANW-44,2,36,13,8)
	local track=mkF(row,5,20,CPANW-18,4,PANEL3,8,999)
	local pct=(val-mn)/math.max(mx-mn,1)
	local fill=mkF(track,0,0,math.floor(pct*(CPANW-18)),4,CYAN,9,999)
	local knob=mkF(track,0,-3,10,10,WHITE,10,999)
	knob.Position=UDim2.new(pct,-5,0,-3)
	local drag=false
	local hit=Instance.new("TextButton"); hit.Size=UDim2.new(1,10,0,20); hit.Position=UDim2.new(0,-5,0,-8)
	hit.BackgroundTransparency=1; hit.Text=""; hit.ZIndex=12; hit.Parent=track
	local function upd(x)
		local p2=math.clamp((x-track.AbsolutePosition.X)/math.max(track.AbsoluteSize.X,1),0,1)
		val=math.round(mn+(mx-mn)*p2)
		fill.Size=UDim2.new(p2,0,1,0); knob.Position=UDim2.new(0,-5+math.floor(p2*(CPANW-18)),0,-3)
		vl.Text=tostring(val); if cb then cb(val) end
	end
	hit.MouseButton1Down:Connect(function() drag=true end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
	end)
	RunService.RenderStepped:Connect(function()
		if drag then upd(UserInputService:GetMouseLocation().X) end
	end)
	return row
end

-- Slider in FScroll (Player tab)
local function mkSliderF(label, mn, mx, def, cb)
	local row=mkF(FScroll,0,0,FPANW-8,38,PANEL2,7,5)
	local val=def or mn
	mkT(row,label,9,TEXT,Enum.Font.Gotham,5,2,FPANW-70,13,8,Enum.TextXAlignment.Left)
	local vl=mkT(row,tostring(val),9,CYAN,Enum.Font.GothamBold,FPANW-68,2,56,13,8)
	local track=mkF(row,5,20,FPANW-22,5,PANEL3,8,999)
	local pct=(val-mn)/math.max(mx-mn,1)
	local fill=mkF(track,0,0,math.floor(pct*(FPANW-22)),5,CYAN,9,999)
	local knob=mkF(track,0,-4,12,12,WHITE,10,999); knob.Position=UDim2.new(pct,-6,0,-4)
	rnd(knob,999); rnd(fill,999)
	local drag=false
	local hit=Instance.new("TextButton"); hit.Size=UDim2.new(1,12,0,22); hit.Position=UDim2.new(0,-6,0,-8)
	hit.BackgroundTransparency=1; hit.Text=""; hit.ZIndex=12; hit.Parent=track
	local function upd(x)
		local p2=math.clamp((x-track.AbsolutePosition.X)/math.max(track.AbsoluteSize.X,1),0,1)
		val=math.round(mn+(mx-mn)*p2)
		fill.Size=UDim2.new(p2,0,1,0); knob.Position=UDim2.new(0,-6+math.floor(p2*(FPANW-22)),0,-4)
		vl.Text=tostring(val); if cb then cb(val) end
	end
	hit.MouseButton1Down:Connect(function() drag=true end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
	end)
	RunService.RenderStepped:Connect(function()
		if drag then upd(UserInputService:GetMouseLocation().X) end
	end)
	return row
end

-- Toggle in FScroll
local function mkToggleF(label, default, cb)
	local row=mkF(FScroll,0,0,FPANW-8,26,PANEL2,7,5)
	mkT(row,label,9,TEXT,Enum.Font.Gotham,5,0,FPANW-60,26,8,Enum.TextXAlignment.Left)
	local on=default or false
	local pill=mkF(row,FPANW-58,6,26,14,on and CYAN or PANEL3,8,999)
	local knob=mkF(pill,on and 13 or 1,1,12,12,WHITE,9,999)
	local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,1,0)
	btn.BackgroundTransparency=1; btn.Text=""; btn.ZIndex=10; btn.Parent=row
	btn.MouseButton1Click:Connect(function()
		on=not on
		tw(pill,{BackgroundColor3=on and CYAN or PANEL3},.15)
		tw(knob,{Position=UDim2.new(0,on and 13 or 1,0,1)},.15)
		if cb then cb(on) end
	end)
	return row
end

-- Script button (favorites + loadstring)
local AllScripts={}
local function isFav(name) for _,f in ipairs(Favorites) do if f.name==name then return true end end; return false end
local function addFav(name,code) if not isFav(name) then table.insert(Favorites,{name=name,code=code}); saveFavorites() end end
local function remFav(name) for i,f in ipairs(Favorites) do if f.name==name then table.remove(Favorites,i); saveFavorites(); return end end end

local function mkScript(name, code)
	local found=false
	for _,s in ipairs(AllScripts) do if s.name==name then found=true;break end end
	if not found then table.insert(AllScripts,{name=name,code=code}) end
	local row=mkF(FScroll,0,0,FPANW-8,26,PANEL2,7,5)
	mkT(row,"▶",9,CYAN,Enum.Font.GothamBold,3,0,14,26,8)
	mkT(row,name,9,TEXT,Enum.Font.Gotham,18,0,FPANW-80,26,8,Enum.TextXAlignment.Left)
	local fav=isFav(name)
	local favBtn=Instance.new("TextButton"); favBtn.Size=UDim2.new(0,24,0,18); favBtn.Position=UDim2.new(1,-52,0,4)
	favBtn.BackgroundColor3=fav and Color3.fromRGB(255,200,30) or PANEL3; favBtn.Text=fav and "★" or "☆"
	favBtn.Font=Enum.Font.GothamBold; favBtn.TextSize=11; favBtn.TextColor3=fav and BG or SUB
	favBtn.ZIndex=9; favBtn.Parent=row; rnd(favBtn,4)
	local runBtn=Instance.new("TextButton"); runBtn.Size=UDim2.new(0,40,0,18); runBtn.Position=Udim2.new and UDim2.new(1,-48,0,4) or UDim2.new(1,-48,0,4)
	-- fix
	runBtn=Instance.new("TextButton"); runBtn.Size=UDim2.new(0,38,0,18); runBtn.Position=UDim2.new(1,-42,0,4)
	runBtn.BackgroundColor3=PANEL3; runBtn.Text="RUN"; runBtn.Font=Enum.Font.GothamBold; runBtn.TextSize=7
	runBtn.TextColor3=CYAN; runBtn.ZIndex=9; runBtn.Parent=row; rnd(runBtn,4); bdr(runBtn,1,.4)
	favBtn.MouseButton1Click:Connect(function()
		if isFav(name) then
			remFav(name); favBtn.Text="☆"; favBtn.TextColor3=SUB; tw(favBtn,{BackgroundColor3=PANEL3},.15)
			task.spawn(function() toast("💔 Xóa yêu thích: "..name,RED,2) end)
		else
			addFav(name,code); favBtn.Text="★"; favBtn.TextColor3=BG; tw(favBtn,{BackgroundColor3=Color3.fromRGB(255,200,30)},.15)
			task.spawn(function() toast("⭐ Thêm yêu thích: "..name,CYAN,2) end)
		end
	end)
	local hbtn=Instance.new("TextButton"); hbtn.Size=UDim2.new(1,-48,1,0); hbtn.Position=UDim2.new(0,0,0,0)
	hbtn.BackgroundTransparency=1; hbtn.Text=""; hbtn.ZIndex=10; hbtn.Parent=row
	hbtn.MouseEnter:Connect(function() tw(row,{BackgroundColor3=Color3.fromRGB(0,35,70)},.1) end)
	hbtn.MouseLeave:Connect(function() tw(row,{BackgroundColor3=PANEL2},.1) end)
	runBtn.MouseButton1Click:Connect(function()
		tw(row,{BackgroundColor3=Color3.fromRGB(0,60,100)},.08)
		task.wait(.12); tw(row,{BackgroundColor3=PANEL2},.15)
		local f,e=loadstring(code); if f then task.spawn(f) else warn("[CryoX] "..tostring(e)) end
	end)
	hbtn.MouseButton1Click:Connect(function()
		tw(row,{BackgroundColor3=Color3.fromRGB(0,60,100)},.08)
		task.wait(.12); tw(row,{BackgroundColor3=PANEL2},.15)
		local f,e=loadstring(code); if f then task.spawn(f) else warn("[CryoX] "..tostring(e)) end
	end)
	return row
end

-- Dropdown (config)
local function mkDropdown(label, opts, def, cb)
	local row=mkF(CScroll,0,0,CPANW-8,22,PANEL2,7,5)
	if label and label~="" then mkT(row,label,8,TEXT,Enum.Font.Gotham,5,0,CPANW-70,22,8,Enum.TextXAlignment.Left) end
	local sel=def or (opts and opts[1]) or ""
	local sl=mkT(row,sel.."  ▾",8,TEXT,Enum.Font.Gotham,CPANW-68,0,62,22,8,Enum.TextXAlignment.Right)
	local open=false; local df=nil
	local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,1,0)
	btn.BackgroundTransparency=1; btn.Text=""; btn.ZIndex=9; btn.Parent=row
	btn.MouseButton1Click:Connect(function()
		open=not open; if df then df:Destroy(); df=nil end
		if open then
			df=mkF(row,0,22,CPANW-8,#opts*20+4,PANEL2,18,6); bdr(df,1,.2)
			for i,op in ipairs(opts) do
				local ob=Instance.new("TextButton"); ob.Size=UDim2.new(1,-4,0,18)
				ob.Position=UDim2.new(0,2,0,2+(i-1)*20); ob.BackgroundTransparency=1
				ob.Text=op; ob.Font=Enum.Font.Gotham; ob.TextSize=8; ob.TextColor3=TEXT; ob.ZIndex=19; ob.Parent=df
				ob.MouseEnter:Connect(function() ob.TextColor3=CYAN end)
				ob.MouseLeave:Connect(function() ob.TextColor3=TEXT end)
				ob.MouseButton1Click:Connect(function()
					sel=op; sl.Text=op.."  ▾"; open=false
					if df then df:Destroy(); df=nil end; if cb then cb(sel) end
				end)
			end
		end
	end)
end

-- ══════════════════════════════════════════
--   CLEAR CONTENT
-- ══════════════════════════════════════════
local function clearF()
	for _,v in pairs(FScroll:GetChildren()) do
		if not (v:IsA("UIListLayout") or v:IsA("UIPadding")) then v:Destroy() end
	end; FScroll.CanvasPosition=Vector2.new(0,0)
end
local function clearC()
	for _,v in pairs(CScroll:GetChildren()) do
		if not (v:IsA("UIListLayout") or v:IsA("UIPadding")) then v:Destroy() end
	end; CScroll.CanvasPosition=Vector2.new(0,0)
end

-- ══════════════════════════════════════════
--   TELEPORT LOCATIONS
-- ══════════════════════════════════════════
local Locations={
	{name="Above Tunnel",cf=CFrame.new(-301,594,-322)},{name="Arena",cf=CFrame.new(-130,440,-373)},
	{name="Atomic Slash",cf=CFrame.new(1064,131,23007)},{name="Baseplate",cf=CFrame.new(1073,406,22984)},
	{name="Below Baseplate",cf=CFrame.new(1073,20,22984)},{name="Bigger Jail",cf=CFrame.new(290,440,465)},
	{name="Even Bigger Jail",cf=CFrame.new(378,439,457)},{name="Dark Domain",cf=CFrame.new(-80,84,20395)},
	{name="Death Counter",cf=CFrame.new(-66,29,20383)},{name="Jail",cf=CFrame.new(440,440,-395)},
	{name="Jail But Smaller",cf=CFrame.new(20,439,-460)},{name="Middle",cf=CFrame.new(150,441,32)},
	{name="Mountain 1",cf=CFrame.new(9,653,-363)},{name="Mountain 2",cf=CFrame.new(-1,653,-354)},
	{name="Mountain Edge",cf=CFrame.new(-297,594,-336)},{name="Void",cf=CFrame.new(0,-10000,0)},
}
local locIcons={Void="☠",Arena="⚔",Jail="🔒",["Bigger Jail"]="🔒",["Even Bigger Jail"]="🔒",
	["Jail But Smaller"]="🔒",["Mountain 1"]="🏔",["Mountain 2"]="🏔",["Mountain Edge"]="🏔",
	["Above Tunnel"]="🌐",Middle="🎯",["Dark Domain"]="🌑",["Death Counter"]="💀",
	["Atomic Slash"]="⚡",Baseplate="🟦",["Below Baseplate"]="🟦"}
local function tpTo(cf)
	local char=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hrp=char:WaitForChild("HumanoidRootPart")
	TweenService:Create(hrp,TweenInfo.new(.5,Enum.EasingStyle.Quad),{CFrame=cf*CFrame.new(0,2,0)}):Play()
end

-- ══════════════════════════════════════════
--   CONTENT LOADERS — by subTab
-- ══════════════════════════════════════════

-- TECH tabs
local function loadTech_Main()
	mkSec("TECH SCRIPTS")
	mkScript("Supa Tech",         [[loadstring(game:HttpGet("https://rawscripts.net/raw/The-Strongest-Battlegrounds-Supa-tech-v2-77454"))()]])
	mkScript("Kiba Tech",         [[loadstring(game:HttpGet("https://raw.githubusercontent.com/yqantg-pixel/Find/refs/heads/main/Protected_1593573630798166.lua.txt"))()]])
	mkScript("Oreo Tech",         [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/OreoTech/refs/heads/main/Protected_6856895483929371.lua"))()]])
	mkScript("Lethal Dash",       [[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/57a4d240a2440f0450986c966469092ccfb8d4797392cb8f469fa8b6e605e64d/download"))()]])
	mkScript("Back Dash Cancel",  [[loadstring(game:HttpGet("https://raw.githubusercontent.com/dinhthanhtuankiet1762009-sudo/Js/refs/heads/main/4418648b0e9b71ef.lua"))()]])
	mkScript("Instant Twisted v2",[[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/60a7a7c77395006ebd63fce0a17c13241f932bd414c9aba3158b716da00ade01/download"))()]])
	mkScript("Loop Dash",         [[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/28513f51c0ca2c03d4d7d94f59215d13ce1a2a470bf187f0a685b58ccb4dae98/download"))()]])
	mkScript("lix tech",          [[loadstring(game:HttpGet("https://raw.githubusercontent.com/MerebennieOfficial/ExoticJn/refs/heads/main/Protected_83737738.txt"))()]])
	mkScript("lethal kiba",       [[loadstring(game:HttpGet("https://raw.githubusercontent.com/MinhNhatHUB/MinhNhat/refs/heads/main/Lethal%20Kiba.lua"))()]])
	mkScript("Silent aim rework", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/yqantg-pixel/Find/refs/heads/main/Protected_6124417452209241.lua.txt"))()]])
end
local function loadTech_Moveset()
	mkSec("MOVESET")
	mkScript("KAR [SAITAMA]",  [[loadstring(game:HttpGet("https://raw.githubusercontent.com/OfficialAposty/RBLX-Scripts/refs/heads/main/UltimateLifeForm.lua"))()]])
	mkScript("Gojo [SAITAMA]", [[getgenv().morph=false loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/BaldyToSorcerer/refs/heads/main/LatestV2.lua"))()]])
	mkScript("CHARA [SAITAMA]",[[loadstring(game:HttpGet("https://pastefy.app/gFRaeMGz/raw"))()]])
end
local function loadTech_Emote()
	mkSec("EMOTE")
	mkScript("Divine Form",        [[loadstring(game:HttpGet("https://raw.githubusercontent.com/IdkRandomUsernameok/PublicAssets/refs/heads/main/Releases/MUI.lua"))()]])
	mkScript("MYKIO Limited Aura", [[loadstring(game:HttpGet("https://arch-http.vercel.app/files/LIMITED EMOTE HUB (75-100) BY MIYKO"))()]])
	mkScript("Basic Emote",        [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/EmoteGui/refs/heads/main/Protected_4900496055951847.lua"))()]])
	mkScript("Sukuna Emote",       [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Yourfavoriteguy/Sukunaslash/refs/heads/main/WorldCuttingSlash"))()]])
	mkScript("MIUI",               [[loadstring(game:HttpGet("https://raw.githubusercontent.com/IdkRandomUsernameok/PublicAssets/refs/heads/main/Releases/MUI.lua"))()]])
end
local function loadTech_Access()
	mkSec("ACCESSORIES")
	mkScript("Oinan-Thickhoof-Axe",      [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Guestly-Scripts/Items-Scripts/refs/heads/main/Oinan-Thickhoof"))()]])
	mkScript("Erisyphia-Staff",           [[loadstring(game:HttpGet("https://raw.githubusercontent.com/GuestlyTheGreatestGuest/Scripts/refs/heads/main/Erisyphia-Staff-made-by-Guestly"))()]])
	mkScript("Elemental-Crystal-Golem",   [[loadstring(game:HttpGet("https://raw.githubusercontent.com/GuestlyTheGreatestGuest/Scripts/refs/heads/main/Elemental-Crystal-Golem-made-by-Guestly"))()]])
end
local function loadTechConf()
	mkToggle("Skill Detector",Settings.showSkillDetector,function(v)
		Settings.showSkillDetector=v; updateStatWidget(); saveSettings()
		task.spawn(function() toast(v and "🔍 Skill Detector BẬT!" or "🔍 Skill Detector TẮT!",v and GREEN or RED,2) end)
	end)
	mkDropdown("",{"Script","Moveset","Emote","Accessories"},"Script")
end

-- FPS tabs
local function loadFPS_AntiLag()
	mkSec("ANTI-LAG SCRIPTS")
	mkScript("CryoX Anti-Lag",          [[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/CryoX%20Anti-Lag.lua"))()]])
	mkScript("Blox Strap",              [[loadstring(game:HttpGet("https://raw.githubusercontent.com/qwertyui-is-back/Bloxstrap/main/Initiate.lua"))()]])
	mkScript("Turbo Lite",              [[loadstring(game:HttpGet("https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua"))()]])
	mkScript("Flags Smooth",            [[loadstring(game:HttpGet("https://raw.githubusercontent.com/ngoclinh02042011-stack/Flags-Smooth/refs/heads/main/Flags%20by%20ThanhDuy.lua"))()]])
	mkScript("Anti Lag Remove Effect",  [[loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV2/YQANTGV2/refs/heads/main/Protected_5743487458031851.lua.txt"))()]])
end
local function loadFPS_Conf()
	mkToggle("Show FPS",Settings.showFPS,function(v) Settings.showFPS=v; updateStatWidget(); saveSettings() end)
	mkToggle("Show Ping",Settings.showPing,function(v) Settings.showPing=v; updateStatWidget(); saveSettings() end)
	mkToggle("Show Players",Settings.showPlayers,function(v) Settings.showPlayers=v; updateStatWidget(); saveSettings() end)
	mkToggle("Show Dash CD",Settings.showDashCD,function(v) Settings.showDashCD=v; updateStatWidget(); saveSettings() end)
end

-- VISUAL tabs
local function loadVisual_Main()
	mkSec("VISUAL SCRIPTS")
	mkScript("M1 Effect [Red+Blue]",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/ngoclinh02042011-stack/Fist-Blue-And-Red/refs/heads/main/HieuUngVuiNhon.lua"))()]])
	mkScript("Fake Animation",      [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Mautiku/ehh/main/strong%20guest.lua.txt"))()]])
	mkScript("Ping and CPU",        [[loadstring(game:HttpGet("https://raw.githubusercontent.com/ngoclinh02042011-stack/Ping-All-Game/refs/heads/main/Ping%20Player.lua"))()]])
	mkScript("Custom Shader",       [[loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Simple-Shader-37434"))()]])
	mkScript("Curse Energy Effect", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Curse%20energy%20effect%5Bsaitama%5D"))()]])
end
local function loadVisual_ESP()
	mkSec("ESP")
	mkToggleF("ESP Người Chơi",false,function(v) toggleESP(v); toast(v and "🔵 ESP BẬT" or "🔵 ESP TẮT",v and GREEN or RED,2) end)
	mkToggleF("ESP Friends",false,function(v) toggleFriendESP(v); toast(v and "👥 Friend ESP BẬT" or "👥 Friend ESP TẮT",v and GREEN or RED,2) end)
	mkSec("HITBOX")
	mkToggleF("Hitbox Expander",false,function(v)
		toggleHitbox(v)
		toast(v and "📦 Hitbox ON" or "📦 Hitbox OFF",v and GREEN or RED,2)
	end)
	mkSec("SCRIPTS MISC")
	mkScript("Dex Explorer",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Dex_Explorer_v2.lua"))()]])
	mkScript("Avatar Changer",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/darkdexv2/universalavatarchanger/main/avatarchanger"))()]])
end
local function loadVisual_Conf()
	mkToggle("ESP Players",false,function(v) toggleESP(v); toast(v and "ESP BẬT" or "ESP TẮT",v and GREEN or RED,2) end)
	mkToggle("ESP Friends",false,function(v) toggleFriendESP(v); toast(v and "Friend ESP BẬT" or "Friend ESP TẮT",v and GREEN or RED,2) end)
	mkToggle("Hitbox",false,function(v) toggleHitbox(v); toast(v and "Hitbox ON" or "Hitbox OFF",v and GREEN or RED,2) end)
	mkSlider("Hitbox Size",1,20,6,function(v) hitboxSize=Vector3.new(v,v,v); if hitboxEnabled then toggleHitbox(false); toggleHitbox(true) end end)
	mkDropdown("Color By",{"Team","HP","Default"},"Team")
end

-- PLAYER tabs
local function loadPlayer_Char()
	mkSec("CHARACTER")
	mkSliderF("🏃 WalkSpeed",4,500,16,function(v)
		pcall(function()
			local char=LocalPlayer.Character; if not char then return end
			local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum.WalkSpeed=v end
		end)
	end)
	mkSliderF("🦘 JumpPower",10,500,50,function(v)
		pcall(function()
			local char=LocalPlayer.Character; if not char then return end
			local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum.JumpPower=v end
		end)
	end)
	mkSec("TOGGLES")
	mkToggleF("👻 Noclip",false,function(v) toggleNoclip(v); toast(v and "👻 Noclip BẬT" or "👻 Noclip TẮT",v and GREEN or RED,2) end)
	mkToggleF("🤖 Anti-AFK",false,function(v) toggleAntiAFK(v); toast(v and "🤖 Anti-AFK BẬT" or "🤖 Anti-AFK TẮT",v and GREEN or RED,2) end)
	mkSec("ACTIONS")
	mkFeat("Hồi Máu Đầy","❤️",function()
		pcall(function() local char=LocalPlayer.Character; if char then local h=char:FindFirstChildOfClass("Humanoid"); if h then h.Health=h.MaxHealth end end end)
		toast("❤️ Đã hồi máu!",GREEN,2)
	end)
	mkFeat("ForceField","🛡️",function()
		pcall(function() Instance.new("ForceField",LocalPlayer.Character) end); toast("🛡️ Shield ON!",CYAN,2)
	end)
	mkFeat("Respawn","🔁",function() LocalPlayer:LoadCharacter(); toast("🔁 Đã respawn!",CYAN,2) end)
end
local function loadPlayer_Script()
	mkSec("PLAYER SCRIPTS")
	mkScript("Fly GuiV3",          [[loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()]])
	mkScript("Anti Death Counter", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Anti-Death-Counter.lua"))()]])
	mkScript("Shield",             [[Instance.new("ForceField",game.Players.LocalPlayer.Character)]])
	mkScript("TouchFling",         [[loadstring(game:HttpGet("https://raw.githubusercontent.com/long191910/all-my-roblox-script/refs/heads/main/touchfling.lua"))()]])
	mkScript("Orbit Farm",         [[loadstring(game:httpGet("https://raw.githubusercontent.com/minhnhatdepzai8-cloud/FARM-KILL/refs/heads/main/TSB"))()]])
	mkScript("Farm Kill",          [[loadstring(game:HttpGet("https://raw.githubusercontent.com/minhnhatdepzai8-cloud/Farm-Kill-V2/refs/heads/main/TSB"))()]])
end
local function loadPlayer_Fav()
	mkSec("⭐ YÊU THÍCH")
	if #Favorites==0 then
		local e=Instance.new("TextLabel"); e.Size=UDim2.new(1,-4,0,50); e.BackgroundTransparency=1
		e.Text="Nhấn ★ để thêm script"; e.TextColor3=SUB; e.Font=Enum.Font.GothamBold
		e.TextSize=9; e.TextXAlignment=Enum.TextXAlignment.Center; e.TextWrapped=true; e.ZIndex=6; e.Parent=FScroll
		return
	end
	for _,f in ipairs(Favorites) do mkScript(f.name,f.code) end
end
local function loadPlayer_Conf()
	mkToggle("Noclip",false,function(v) toggleNoclip(v) end)
	mkToggle("Anti-AFK",false,function(v) toggleAntiAFK(v) end)
	mkSlider("WalkSpeed",4,500,16,function(v)
		pcall(function() local c=LocalPlayer.Character; if c then local h=c:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed=v end end end)
	end)
	mkSlider("JumpPower",10,500,50,function(v)
		pcall(function() local c=LocalPlayer.Character; if c then local h=c:FindFirstChildOfClass("Humanoid"); if h then h.JumpPower=v end end end)
	end)
end

-- MAP tabs
local function loadMap_TP()
	mkSec("TELEPORT")
	for _,loc in ipairs(Locations) do
		local icon=locIcons[loc.name] or "📍"; local cf=loc.cf; local nm=loc.name
		mkFeat(nm,icon,function() tpTo(cf); toast("📍 Tp → "..nm,CYAN,2) end)
	end
end
local function loadMap_Conf()
	mkToggle("Tp Animation",true)
	mkToggle("Safe Tp",true)
	mkSlider("Tp Height",0,20,2)
end

-- SERVER tabs
local function loadServer_Main()
	mkSec("SERVER HOP")
	mkFeat("Hop Server (Random)","🔀",function()
		local pid=game.PlaceId
		local ok,sv=pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..pid.."/servers/Public?sortOrder=Asc&limit=25")) end)
		if ok and sv and sv.data then
			local list={}; for _,s in ipairs(sv.data) do if s.id~=game.JobId and s.playing<s.maxPlayers then table.insert(list,s.id) end end
			if #list>0 then toast("🔀 Đang hop...",CYAN,2); task.wait(1); TeleportService:TeleportToPlaceInstance(pid,list[math.random(1,#list)],LocalPlayer)
			else toast("❌ Không tìm thấy server!",RED,3) end
		else toast("❌ Lỗi server list!",RED,3) end
	end)
	mkFeat("Server Ít Người","👤",function()
		local pid=game.PlaceId
		local ok,sv=pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..pid.."/servers/Public?sortOrder=Asc&limit=25")) end)
		if ok and sv and sv.data and #sv.data>0 then
			local least,minP=nil,math.huge
			for _,s in ipairs(sv.data) do if s.id~=game.JobId and s.playing<minP then minP=s.playing; least=s.id end end
			if least then toast("👤 Server ít người: "..minP,CYAN,2); task.wait(1); TeleportService:TeleportToPlaceInstance(pid,least,LocalPlayer)
			else toast("❌ Không tìm thấy!",RED,3) end
		else toast("❌ Lỗi!",RED,3) end
	end)
	mkFeat("Rejoin","🔄",function() toast("🔄 Đang rejoin...",CYAN,2); task.wait(.8); pcall(function() TeleportService:Teleport(game.PlaceId,LocalPlayer) end) end)
	mkFeat("Copy Server ID","📋",function()
		if setclipboard then setclipboard(game.JobId); toast("📋 Đã copy Server ID!",GREEN,2)
		else toast("❌ Không hỗ trợ clipboard!",RED,2) end
	end)
end
local function loadServer_Exec()
	mkSec("QUICK EXEC")
	local inputF=mkF(FScroll,0,0,FPANW-8,80,PANEL2,7,5)
	local codeBox=Instance.new("TextBox"); codeBox.Size=UDim2.new(1,-6,1,-28); codeBox.Position=UDim2.new(0,3,0,3)
	codeBox.BackgroundTransparency=1; codeBox.PlaceholderText="https://... hoặc lua code..."
	codeBox.Text=""; codeBox.Font=Enum.Font.Code; codeBox.TextSize=8; codeBox.TextColor3=TEXT
	codeBox.PlaceholderColor3=SUB; codeBox.MultiLine=true; codeBox.TextXAlignment=Enum.TextXAlignment.Left
	codeBox.TextYAlignment=Enum.TextYAlignment.Top; codeBox.ClearTextOnFocus=false; codeBox.ZIndex=8; codeBox.Parent=inputF
	local runC=Instance.new("TextButton"); runC.Size=UDim2.new(.48,-2,0,22); runC.Position=UDim2.new(0,2,1,-24)
	runC.BackgroundColor3=CYAN; runC.Text="▶ RUN"; runC.Font=Enum.Font.GothamBold; runC.TextSize=9
	runC.TextColor3=BG; runC.ZIndex=9; runC.Parent=inputF; rnd(runC,5)
	local clrC=Instance.new("TextButton"); clrC.Size=UDim2.new(.48,-2,0,22); clrC.Position=UDim2.new(.5,1,1,-24)
	clrC.BackgroundColor3=PANEL3; clrC.Text="🗑 CLEAR"; clrC.Font=Enum.Font.GothamBold; clrC.TextSize=9
	clrC.TextColor3=SUB; clrC.ZIndex=9; clrC.Parent=inputF; rnd(clrC,5); bdr(clrC,1,.4)
	runC.MouseButton1Click:Connect(function()
		local inp=codeBox.Text; if not inp or #inp<3 then toast("❌ Chưa nhập!",RED,2);return end
		if inp:sub(1,4)=="http" then
			local ok,code=pcall(function() return game:HttpGet(inp) end)
			if ok and code then local f,e=loadstring(code); if f then task.spawn(f); toast("✅ Chạy URL!",GREEN,2) else toast("❌ "..tostring(e),RED,3) end
			else toast("❌ Không tải URL!",RED,3) end
		else
			local f,e=loadstring(inp); if f then task.spawn(f); toast("✅ Chạy code!",GREEN,2) else toast("❌ "..tostring(e),RED,3) end
		end
	end)
	clrC.MouseButton1Click:Connect(function() codeBox.Text="" end)
end
local function loadServer_Conf()
	mkDropdown("",{"Asc","Desc","Players"},"Asc")
	mkSlider("Min Players",1,50,10)
	mkToggle("Auto Hop",false)
end

-- SETTING tabs
local THEMES2={
	{"🔵 Cyan",Color3.fromRGB(0,200,255)},{"🟣 Purple",Color3.fromRGB(160,80,255)},
	{"🟢 Neon",Color3.fromRGB(50,255,120)},{"🔴 Red",Color3.fromRGB(255,60,60)},
	{"🟡 Gold",Color3.fromRGB(255,200,30)},{"🩷 Pink",Color3.fromRGB(255,100,200)},
	{"🟠 Orange",Color3.fromRGB(255,130,40)},{"⚪ White",Color3.fromRGB(220,230,255)},
}
local function loadSetting_Theme()
	mkSec("ACCENT COLOR")
	for _,th in ipairs(THEMES2) do
		local col=th[2]; local nm=th[1]
		mkFeat(nm,"🎨",function()
			CYAN=col
			for _,v in ipairs(Root:GetDescendants()) do
				if v:IsA("UIStroke") then v.Color=col end
			end
			Settings.accentColor=col; saveSettings()
			toast("🎨 Đã đổi màu!",col,2)
		end)
	end
end
local function loadSetting_Key()
	mkFeat("Show Key","🔑",function() toast("Key: CryoXHUB",CYAN,4) end)
	mkFeat("Reset Key","🔄",function()
		SaveData.keyVerified=false; SaveData.keyTime=0; writeSave(SaveData)
		toast("Key reset! Reload để nhập lại.",ORANGE,3)
	end)
	mkFeat("Reset Save","🗑️",function()
		for k,v in pairs(DEFAULT_SAVE) do SaveData[k]=v end; Favorites={}; writeSave(SaveData)
		toast("🗑 Đã reset save!",RED,3)
	end)
end
local function loadSetting_Conf()
	mkToggle("Show FPS",Settings.showFPS,function(v) Settings.showFPS=v; updateStatWidget(); saveSettings() end)
	mkToggle("Show Ping",Settings.showPing,function(v) Settings.showPing=v; updateStatWidget(); saveSettings() end)
	mkToggle("Show Players",Settings.showPlayers,function(v) Settings.showPlayers=v; updateStatWidget(); saveSettings() end)
	mkToggle("Skill Detector",Settings.showSkillDetector,function(v) Settings.showSkillDetector=v; updateStatWidget(); saveSettings() end)
	mkToggle("Auto Update 24H",true)
	mkToggle("Watermark",true)
end

-- ══════════════════════════════════════════
--   TAB SYSTEM
-- ══════════════════════════════════════════
-- subTab definitions per main tab
local tabDef = {
	Tech    = {subs={"Main","Moveset","Emote","Access"},   loads={loadTech_Main,loadTech_Moveset,loadTech_Emote,loadTech_Access},   conf=loadTechConf},
	FPS     = {subs={"Anti-Lag"},                          loads={loadFPS_AntiLag},                                                  conf=loadFPS_Conf},
	Visual  = {subs={"Scripts","ESP+Hitbox"},              loads={loadVisual_Main,loadVisual_ESP},                                   conf=loadVisual_Conf},
	Player  = {subs={"Char","Scripts","Favorites"},        loads={loadPlayer_Char,loadPlayer_Script,loadPlayer_Fav},                 conf=loadPlayer_Conf},
	Map     = {subs={"Teleport"},                          loads={loadMap_TP},                                                       conf=loadMap_Conf},
	Server  = {subs={"Hop","QuickExec"},                   loads={loadServer_Main,loadServer_Exec},                                  conf=loadServer_Conf},
	Setting = {subs={"Theme","Key"},                       loads={loadSetting_Theme,loadSetting_Key},                                conf=loadSetting_Conf},
}

local activeSubBtn=nil; local currentMain=nil; local currentConf=nil

local function selectSub(mainName, idx, btn)
	if activeSubBtn then
		tw(activeSubBtn,{BackgroundColor3=PANEL2},.12); activeSubBtn.TextColor3=SUB
		local s=activeSubBtn:FindFirstChildOfClass("UIStroke"); if s then tw(s,{Transparency=.65},.12) end
	end
	activeSubBtn=btn; tw(btn,{BackgroundColor3=Color3.fromRGB(0,42,88)},.12); btn.TextColor3=CYAN
	local s=btn:FindFirstChildOfClass("UIStroke"); if s then tw(s,{Transparency=0},.12) end
	clearF(); clearC()
	local td=tabDef[mainName]
	if td then
		if td.loads[idx] then td.loads[idx]() end
		if td.conf then td.conf() end
	end
end

local function selectMain(mainName, mainBtn)
	if activeMainBtn then
		tw(activeMainBtn,{BackgroundColor3=PANEL2},.15); activeMainBtn.TextColor3=SUB
		local s=activeMainBtn:FindFirstChildOfClass("UIStroke"); if s then tw(s,{Transparency=.65},.15) end
	end
	activeMainBtn=mainBtn; tw(mainBtn,{BackgroundColor3=Color3.fromRGB(0,42,92)},.15); mainBtn.TextColor3=CYAN
	local s=mainBtn:FindFirstChildOfClass("UIStroke"); if s then tw(s,{Transparency=0},.15) end
	currentMain=mainName

	for _,v in pairs(SubScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
	activeSubBtn=nil; clearF(); clearC()

	local td=tabDef[mainName]; if not td then return end
	local firstBtn=nil
	for i,sn in ipairs(td.subs) do
		local sb=Instance.new("TextButton"); sb.Size=UDim2.new(0,64,0,SUBTAB_H-6)
		sb.BackgroundColor3=PANEL2; sb.Text=sn; sb.Font=Enum.Font.GothamBold
		sb.TextSize=8; sb.TextColor3=SUB; sb.ZIndex=6; sb.Parent=SubScroll
		rnd(sb,5); bdr(sb,1,.65)
		sb.MouseEnter:Connect(function() if activeSubBtn~=sb then tw(sb,{BackgroundColor3=Color3.fromRGB(0,22,45)},.1) end end)
		sb.MouseLeave:Connect(function() if activeSubBtn~=sb then tw(sb,{BackgroundColor3=PANEL2},.1) end end)
		local ci=i; sb.MouseButton1Click:Connect(function() selectSub(mainName,ci,sb) end)
		if i==1 then firstBtn=sb end
	end
	if firstBtn then task.spawn(function() task.wait(.05); selectSub(mainName,1,firstBtn) end) end
end

-- Build main icon buttons
for i,td in ipairs(mainTabs) do
	local mb=Instance.new("TextButton"); mb.Size=UDim2.new(1,0,0,34)
	mb.BackgroundColor3=PANEL2; mb.Text=td.icon; mb.Font=Enum.Font.GothamBold
	mb.TextSize=15; mb.TextColor3=SUB; mb.ZIndex=5; mb.Parent=C2InnFrame
	rnd(mb,6); bdr(mb,1.1,.65)
	mb.MouseEnter:Connect(function() if activeMainBtn~=mb then tw(mb,{BackgroundColor3=Color3.fromRGB(0,22,45)},.1) end end)
	mb.MouseLeave:Connect(function() if activeMainBtn~=mb then tw(mb,{BackgroundColor3=PANEL2},.1) end end)
	mb.MouseButton1Click:Connect(function() selectMain(td.name,mb) end)
	mainBtns[i]=mb
end

-- ══════════════════════════════════════════
--   DARK / LIGHT MODE
-- ══════════════════════════════════════════
DarkBtn.MouseButton1Click:Connect(function()
	tw(Root,{BackgroundColor3=Color3.fromRGB(7,13,26)},.25)
	tw(DarkBtn,{BackgroundColor3=Color3.fromRGB(0,38,85)},.15); DarkBtn.TextColor3=CYAN
	tw(LightBtn,{BackgroundColor3=PANEL2},.15); LightBtn.TextColor3=SUB
	toast("🌙 Dark Mode",CYAN,2)
end)
LightBtn.MouseButton1Click:Connect(function()
	tw(Root,{BackgroundColor3=Color3.fromRGB(165,185,215)},.25)
	tw(LightBtn,{BackgroundColor3=Color3.fromRGB(195,150,0)},.15); LightBtn.TextColor3=Color3.fromRGB(20,10,0)
	tw(DarkBtn,{BackgroundColor3=PANEL2},.15); DarkBtn.TextColor3=SUB
	toast("☀️ Light Mode",ORANGE,2)
end)

-- ══════════════════════════════════════════
--   ANIMATE
-- ══════════════════════════════════════════
local function animOpen()
	Root.Visible=true; Root.BackgroundTransparency=1
	Root.Size=UDim2.new(0,RW*.88,0,RH*.88)
	Root.Position=UDim2.new(.5,-(RW*.88)/2,.5,-(RH*.88)/2)
	tw(Root,{Size=UDim2.new(0,RW,0,RH),Position=UDim2.new(.5,-RW/2,.5,-RH/2),BackgroundTransparency=0},.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
end
local function animClose(cb)
	tw(Root,{Size=UDim2.new(0,RW*.88,0,RH*.88),Position=UDim2.new(.5,-(RW*.88)/2,.5,-(RH*.88)/2),BackgroundTransparency=1},.2)
	task.wait(.22); Root.Visible=false; if cb then cb() end
end

local OpenBtn=Instance.new("ImageButton"); OpenBtn.Size=UDim2.new(0,40,0,40); OpenBtn.Position=UDim2.new(0,12,.5,-20)
OpenBtn.BackgroundColor3=PANEL; OpenBtn.Image="rbxassetid://5028857084"; OpenBtn.ImageColor3=CYAN
OpenBtn.ImageTransparency=.3; OpenBtn.Visible=false; OpenBtn.Draggable=true; OpenBtn.ZIndex=5; OpenBtn.Parent=ScreenGui
rnd(OpenBtn,10); bdr(OpenBtn,1.4,.18)
OpenBtn.MouseButton1Click:Connect(function() OpenBtn.Visible=false; animOpen() end)

CloseBtn.MouseButton1Click:Connect(function()
	animClose(function()
		OpenBtn.Visible=true; OpenBtn.Size=UDim2.new(0,22,0,22)
		tw(OpenBtn,{Size=UDim2.new(0,40,0,40)},.26,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
	end)
end)

-- ══════════════════════════════════════════
--   KEY SUBMIT
-- ══════════════════════════════════════════
local function unlockGUI()
	KStat.Text="✓ Key OK — 24 giờ!"; KStat.TextColor3=GREEN
	tw(KBtn,{BackgroundColor3=GREEN},.2); task.wait(.5)
	tw(KO,{BackgroundTransparency=1},.28); task.wait(.3); KO.Visible=false
	if mainBtns[1] then
		task.spawn(function() task.wait(.25); selectMain(mainTabs[1].name,mainBtns[1]) end)
	end
	task.spawn(function() task.wait(.8); toast("✅ CryoXHUB v5.1 mở khóa! 🎉",GREEN,3) end)
end

KBtn.MouseButton1Click:Connect(function()
	if KInput.Text==KEY_STR then saveKey(); unlockGUI()
	else
		KInput.Text=""; KStat.Text="❌ Sai Key! Thử lại."; KStat.TextColor3=RED
		local orig=KInput.Position
		for i=1,5 do tw(KInput,{Position=orig+UDim2.new(0,i%2==0 and 5 or -5,0,0)},.04); task.wait(.045) end
		tw(KInput,{Position=orig},.07); task.delay(1.5,function() KStat.Text="" end)
	end
end)

if keyVerified then task.spawn(function() task.wait(.5); unlockGUI() end) end

-- ══════════════════════════════════════════
--   FPS / PING / PLAYERS LOOP
-- ══════════════════════════════════════════
local fpsCount=0; local lastFT=tick()
RunService.RenderStepped:Connect(function()
	fpsCount=fpsCount+1; local now=tick()
	if now-lastFT>=.5 then
		local fps=math.floor(fpsCount/(now-lastFT)); fpsCount=0; lastFT=now
		if Settings.showFPS then
			local c2=fps>=55 and GREEN or fps>=30 and Color3.fromRGB(255,200,60) or RED
			StatFPSLbl.TextColor3=c2; StatFPSLbl.Text="⚡ FPS: "..fps
		end
		if Settings.showPing then
			local ok,ping=pcall(function() return math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
			if ok then
				local c2=ping<=80 and GREEN or ping<=150 and Color3.fromRGB(255,200,60) or RED
				StatPingLbl.TextColor3=c2; StatPingLbl.Text="📶 Ping: "..ping.."ms"
			end
		end
		if Settings.showPlayers then StatPlayersLbl.Text="👥 Players: "..#Players:GetPlayers() end
	end
	if Settings.showDashCD then
		DashCDLabel.Text="DASH: READY ✓"; SideCDLabel.Text="SIDE: READY ✓"
	end
end)

-- 30 phút toast
task.spawn(function()
	while true do task.wait(1800)
		local msgs={"💙 CryoXHUB v5.1 — Cảm ơn bạn!","✨ Thử tab Visual → ESP+Hitbox mới!","🌊 CryoXHUB v5.1 — Chúc chơi vui!"}
		task.spawn(function() toast(msgs[math.random(1,#msgs)],CYAN,5) end)
	end
end)

-- ══════════════════════════════════════════
--   START
-- ══════════════════════════════════════════
task.wait(.2)
animOpen()
