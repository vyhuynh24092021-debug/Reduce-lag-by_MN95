-- CryoXHUB GUI v5.3 — Restructured Tabs
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CryoXHUB_v53"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local RunService      = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService     = game:GetService("HttpService")
local UIS             = game:GetService("UserInputService")
local StatsService    = game:GetService("Stats")
local LocalPlayer     = Players.LocalPlayer

local ID_ANH_NEN   = "rbxthumb://type=Asset&id=116367849760314&w=420&h=420"
local ID_LOGO_DONG = "rbxthumb://type=Asset&id=135753950157111&w=420&h=420"
local KEY_CHINH_XAC = "CryoXHUB"
local SAVE_FILE     = "CryoXHUB_v53_save.json"

-- ══════════════════════════════════════════
--   SAVE SYSTEM
-- ══════════════════════════════════════════
local DEFAULT_SAVE = {
    keyVerified=false, keyTime=0,
    accentR=0, accentG=210, accentB=255,
    showFPS=false, showPing=false, showPlayers=false,
    showDashCD=false, showSkillDetector=false,
    favorites={}, lastTab=1,
    currentTheme="Dark",
}
local function loadSave()
    local ok,result = pcall(function()
        if isfile and isfile(SAVE_FILE) then
            return HttpService:JSONDecode(readfile(SAVE_FILE))
        end
    end)
    if ok and result then
        for k,v in pairs(DEFAULT_SAVE) do
            if result[k]==nil then result[k]=v end
        end
        return result
    end
    return DEFAULT_SAVE
end
local function writeSave(data)
    pcall(function() writefile(SAVE_FILE, HttpService:JSONEncode(data)) end)
end
local SaveData = loadSave()

local keyVerified = false
local function checkKeyValid()
    if SaveData.keyVerified then
        if os.time()-(SaveData.keyTime or 0) < 86400 then return true end
        SaveData.keyVerified=false; SaveData.keyTime=0; writeSave(SaveData)
    end
    return false
end
local function saveKeyTime()
    SaveData.keyVerified=true; SaveData.keyTime=os.time(); writeSave(SaveData)
end
keyVerified = checkKeyValid()

-- ══════════════════════════════════════════
--   THEMES
-- ══════════════════════════════════════════
local THEMES_LIST = {
    {name="🌑 Dark",        bg=Color3.fromRGB(4,8,18),   panel=Color3.fromRGB(8,16,32),  panel2=Color3.fromRGB(12,22,42)},
    {name="☀️ Light",       bg=Color3.fromRGB(200,210,230),panel=Color3.fromRGB(180,190,215),panel2=Color3.fromRGB(160,175,200)},
    {name="🌊 Ocean",       bg=Color3.fromRGB(2,18,38),   panel=Color3.fromRGB(4,28,58),  panel2=Color3.fromRGB(6,38,75)},
    {name="🌲 Forest",      bg=Color3.fromRGB(4,18,8),    panel=Color3.fromRGB(8,28,12),  panel2=Color3.fromRGB(12,40,16)},
    {name="🌸 Sakura",      bg=Color3.fromRGB(28,8,18),   panel=Color3.fromRGB(45,12,30), panel2=Color3.fromRGB(60,16,42)},
    {name="🔥 Inferno",     bg=Color3.fromRGB(22,4,2),    panel=Color3.fromRGB(38,8,4),   panel2=Color3.fromRGB(55,12,6)},
    {name="🌌 Galaxy",      bg=Color3.fromRGB(6,2,22),    panel=Color3.fromRGB(12,4,38),  panel2=Color3.fromRGB(18,6,55)},
    {name="⬛ Amoled",      bg=Color3.fromRGB(0,0,0),     panel=Color3.fromRGB(8,8,8),    panel2=Color3.fromRGB(16,16,16)},
    {name="🌫️ Ash",         bg=Color3.fromRGB(16,16,20),  panel=Color3.fromRGB(26,26,32), panel2=Color3.fromRGB(36,36,44)},
    {name="🍬 Candy",       bg=Color3.fromRGB(28,4,28),   panel=Color3.fromRGB(40,6,40),  panel2=Color3.fromRGB(55,8,55)},
    {name="🧊 Ice",         bg=Color3.fromRGB(8,18,30),   panel=Color3.fromRGB(14,26,44), panel2=Color3.fromRGB(20,35,58)},
    {name="🌙 Midnight",    bg=Color3.fromRGB(2,2,14),    panel=Color3.fromRGB(4,4,22),   panel2=Color3.fromRGB(6,6,32)},
}

local C = {
    BG     = Color3.fromRGB(4,  8,  18),
    PANEL  = Color3.fromRGB(8,  16, 32),
    PANEL2 = Color3.fromRGB(12, 22, 42),
    CYAN   = Color3.fromRGB(SaveData.accentR, SaveData.accentG, SaveData.accentB),
    TEXT   = Color3.fromRGB(220,240,255),
    SUB    = Color3.fromRGB(100,160,200),
    RED    = Color3.fromRGB(200,50,50),
    GREEN  = Color3.fromRGB(50,220,120),
}
local Settings = {
    accentColor       = Color3.fromRGB(SaveData.accentR, SaveData.accentG, SaveData.accentB),
    showFPS           = SaveData.showFPS,
    showPing          = SaveData.showPing,
    showPlayers       = SaveData.showPlayers,
    showDashCD        = SaveData.showDashCD,
    showSkillDetector = SaveData.showSkillDetector,
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

-- ══════════════════════════════════════════
--   LAYOUT
-- ══════════════════════════════════════════
local PAD      = 5
local GAP      = 4
local ROOT_W   = 640
local ROOT_H   = 420
local LEFT_W   = 148
local MID_W    = 82
local RIGHT_W  = ROOT_W - PAD*2 - LEFT_W - MID_W - GAP*2
local AVATAR_H = 148
local TAB_H    = 30
local CONTENT_H= ROOT_H - PAD*2 - TAB_H - GAP

-- ══════════════════════════════════════════
--   HELPERS
-- ══════════════════════════════════════════
local function tw(obj,props,t,style,dir)
    TweenService:Create(obj,TweenInfo.new(
        t or 0.22, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out
    ),props):Play()
end
local function corner(p,r)
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 10); c.Parent=p
end
local function stroke(p,t,tr)
    local s=Instance.new("UIStroke")
    s.Color=C.CYAN; s.Thickness=t or 1.5; s.Transparency=tr or 0.2
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=p; return s
end
local function glowOrb(p,tr)
    local g=Instance.new("ImageLabel")
    g.Size=UDim2.new(1,50,1,50); g.Position=UDim2.new(0,-25,0,-25)
    g.BackgroundTransparency=1; g.Image="rbxassetid://5028857084"
    g.ImageColor3=C.CYAN; g.ImageTransparency=tr or 0.88
    g.ZIndex=(p.ZIndex or 1)-1; g.Parent=p
end
local function bgImg(parent, tr, z)
    local i=Instance.new("ImageLabel")
    i.Size=UDim2.new(1,0,1,0); i.BackgroundTransparency=1
    i.Image=ID_ANH_NEN; i.ImageTransparency=tr or 0.88
    i.ScaleType=Enum.ScaleType.Crop; i.ZIndex=z or 1; i.Parent=parent
    return i
end

-- ══════════════════════════════════════════
--   TOAST
-- ══════════════════════════════════════════
local function showToast(msg,color,duration)
    color=color or C.CYAN; duration=duration or 3
    local T=Instance.new("Frame")
    T.Size=UDim2.new(0,300,0,52); T.Position=UDim2.new(0.5,-150,1,70)
    T.BackgroundColor3=Color3.fromRGB(4,14,28); T.BorderSizePixel=0; T.ZIndex=50
    T.Parent=ScreenGui; corner(T,12)
    local ts=Instance.new("UIStroke"); ts.Color=color; ts.Thickness=1.8; ts.Transparency=0.05
    ts.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; ts.Parent=T
    local tb=Instance.new("Frame"); tb.Size=UDim2.new(0,4,1,-16); tb.Position=UDim2.new(0,8,0,8)
    tb.BackgroundColor3=color; tb.BorderSizePixel=0; tb.ZIndex=51; tb.Parent=T; corner(tb,3)
    local tm=Instance.new("TextLabel"); tm.Size=UDim2.new(1,-20,1,0); tm.Position=UDim2.new(0,16,0,0)
    tm.BackgroundTransparency=1; tm.Text=msg; tm.TextColor3=C.TEXT; tm.Font=Enum.Font.GothamBold
    tm.TextSize=11; tm.TextXAlignment=Enum.TextXAlignment.Left; tm.TextWrapped=true; tm.ZIndex=51; tm.Parent=T
    tw(T,{Position=UDim2.new(0.5,-150,1,-70)},0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    task.delay(duration,function()
        tw(T,{Position=UDim2.new(0.5,-150,1,70)},0.28)
        task.wait(0.3); T:Destroy()
    end)
end

-- ══════════════════════════════════════════
--   HUD OVERLAYS
-- ══════════════════════════════════════════
local StatFPSLbl=Instance.new("TextLabel"); StatFPSLbl.Size=UDim2.new(0,200,0,16)
StatFPSLbl.Position=UDim2.new(0,8,0,52); StatFPSLbl.BackgroundTransparency=1; StatFPSLbl.Text=""
StatFPSLbl.TextColor3=C.GREEN; StatFPSLbl.Font=Enum.Font.GothamBold; StatFPSLbl.TextSize=12
StatFPSLbl.TextXAlignment=Enum.TextXAlignment.Left; StatFPSLbl.ZIndex=10; StatFPSLbl.Visible=false; StatFPSLbl.Parent=ScreenGui

local StatPingLbl=Instance.new("TextLabel"); StatPingLbl.Size=UDim2.new(0,200,0,16)
StatPingLbl.Position=UDim2.new(0,8,0,70); StatPingLbl.BackgroundTransparency=1; StatPingLbl.Text=""
StatPingLbl.TextColor3=Color3.fromRGB(255,200,60); StatPingLbl.Font=Enum.Font.GothamBold; StatPingLbl.TextSize=12
StatPingLbl.TextXAlignment=Enum.TextXAlignment.Left; StatPingLbl.ZIndex=10; StatPingLbl.Visible=false; StatPingLbl.Parent=ScreenGui

local StatPlayersLbl=Instance.new("TextLabel"); StatPlayersLbl.Size=UDim2.new(0,200,0,16)
StatPlayersLbl.Position=UDim2.new(0,8,0,88); StatPlayersLbl.BackgroundTransparency=1; StatPlayersLbl.Text=""
StatPlayersLbl.TextColor3=Color3.fromRGB(0,210,255); StatPlayersLbl.Font=Enum.Font.GothamBold; StatPlayersLbl.TextSize=12
StatPlayersLbl.TextXAlignment=Enum.TextXAlignment.Left; StatPlayersLbl.ZIndex=10; StatPlayersLbl.Visible=false; StatPlayersLbl.Parent=ScreenGui

local DashCDLabel=Instance.new("TextLabel"); DashCDLabel.Size=UDim2.new(0,110,0,20)
DashCDLabel.AnchorPoint=Vector2.new(0.5,1); DashCDLabel.Position=UDim2.new(0.5,-65,1,-125)
DashCDLabel.BackgroundTransparency=1; DashCDLabel.Font=Enum.Font.GothamBold; DashCDLabel.TextSize=12
DashCDLabel.TextColor3=Color3.fromRGB(50,220,120); DashCDLabel.TextStrokeTransparency=0.5
DashCDLabel.Text="DASH: READY ✓"; DashCDLabel.Visible=false; DashCDLabel.ZIndex=10; DashCDLabel.Parent=ScreenGui

local SideCDLabel=Instance.new("TextLabel"); SideCDLabel.Size=UDim2.new(0,110,0,20)
SideCDLabel.AnchorPoint=Vector2.new(0.5,1); SideCDLabel.Position=UDim2.new(0.5,65,1,-125)
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
    end; skillDetectorState={}
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
                        if strongSkills[tool.Name] then st="strong"; break end
                        if weakSkills[tool.Name] then st="weak"; break end
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
        local nameL=Instance.new("TextLabel"); nameL.Size=UDim2.new(0,120,0,20)
        nameL.Position=UDim2.new(0.5,-60,0,0); nameL.BackgroundTransparency=1
        nameL.Text=plr.DisplayName.." ["..plr.Name.."]"; nameL.TextColor3=C.CYAN
        nameL.Font=Enum.Font.GothamBold; nameL.TextSize=11; nameL.TextStrokeTransparency=0.4; nameL.Parent=bb
        local hpL=Instance.new("TextLabel"); hpL.Size=UDim2.new(0,80,0,16)
        hpL.Position=UDim2.new(0.5,-40,0,20); hpL.BackgroundTransparency=1
        hpL.TextColor3=C.GREEN; hpL.Font=Enum.Font.Gotham; hpL.TextSize=9
        hpL.TextStrokeTransparency=0.4; hpL.Parent=bb
        espObjects[plr]=bb
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum then
            local key=tostring(plr.UserId).."_hp"
            espConnections[key]=RunService.Heartbeat:Connect(function()
                if hum and hum.Parent then
                    local pct=math.floor((hum.Health/math.max(hum.MaxHealth,1))*100)
                    local col=pct>60 and C.GREEN or pct>30 and Color3.fromRGB(255,200,60) or C.RED
                    hpL.Text="❤ "..pct.."%"; hpL.TextColor3=col
                end
            end)
        end
    end
    buildESP()
    espConnections[plr]=plr.CharacterAdded:Connect(function() task.wait(0.5); buildESP() end)
end
local function removeESP(plr)
    if espObjects[plr] then pcall(function() espObjects[plr]:Destroy() end); espObjects[plr]=nil end
    local key=tostring(plr.UserId).."_hp"
    if espConnections[plr] then pcall(function() espConnections[plr]:Disconnect() end); espConnections[plr]=nil end
    if espConnections[key] then pcall(function() espConnections[key]:Disconnect() end); espConnections[key]=nil end
end
local function toggleESP(state)
    espEnabled=state
    if state then
        for _,plr in ipairs(Players:GetPlayers()) do createESP(plr) end
        espConnections["added"]=Players.PlayerAdded:Connect(createESP)
        espConnections["removed"]=Players.PlayerRemoving:Connect(removeESP)
    else
        for _,plr in ipairs(Players:GetPlayers()) do removeESP(plr) end
        for k,c in pairs(espConnections) do pcall(function() c:Disconnect() end); espConnections[k]=nil end
    end
end

-- ESP FRIENDS
local espFriendEnabled=false; local espFriendConns={}; local espFriendObjs={}
local function createFriendESP(plr)
    if plr==LocalPlayer then return end
    local ok,isFr=pcall(function() return LocalPlayer:IsFriendsWith(plr.UserId) end)
    if not (ok and isFr) then return end
    local function buildF()
        local char=plr.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        if espFriendObjs[plr] then pcall(function() espFriendObjs[plr]:Destroy() end) end
        local bb=Instance.new("BillboardGui")
        bb.Size=UDim2.new(0,0,0,0); bb.StudsOffsetWorldSpace=Vector3.new(0,3.8,0)
        bb.AlwaysOnTop=true; bb.Adornee=hrp; bb.Parent=ScreenGui
        local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(0,140,0,20)
        nl.Position=UDim2.new(0.5,-70,0,0); nl.BackgroundTransparency=1
        nl.Text="👥 "..plr.DisplayName; nl.TextColor3=Color3.fromRGB(100,255,160)
        nl.Font=Enum.Font.GothamBold; nl.TextSize=12; nl.TextStrokeTransparency=0.3; nl.Parent=bb
        local tg=Instance.new("TextLabel"); tg.Size=UDim2.new(0,80,0,14)
        tg.Position=UDim2.new(0.5,-40,0,22); tg.BackgroundTransparency=1
        tg.Text="[FRIEND]"; tg.TextColor3=Color3.fromRGB(100,255,160)
        tg.Font=Enum.Font.GothamBold; tg.TextSize=9; tg.TextStrokeTransparency=0.4; tg.Parent=bb
        espFriendObjs[plr]=bb
    end
    buildF()
    espFriendConns[plr]=plr.CharacterAdded:Connect(function() task.wait(0.5); buildF() end)
end
local function removeFriendESP(plr)
    if espFriendObjs[plr] then pcall(function() espFriendObjs[plr]:Destroy() end); espFriendObjs[plr]=nil end
    if espFriendConns[plr] then pcall(function() espFriendConns[plr]:Disconnect() end); espFriendConns[plr]=nil end
end
local function toggleFriendESP(state)
    espFriendEnabled=state
    if state then
        for _,p in ipairs(Players:GetPlayers()) do createFriendESP(p) end
        espFriendConns["added"]=Players.PlayerAdded:Connect(createFriendESP)
    else
        for _,p in ipairs(Players:GetPlayers()) do removeFriendESP(p) end
        for k,c in pairs(espFriendConns) do pcall(function() c:Disconnect() end); espFriendConns[k]=nil end
    end
end

-- HITBOX EXPANDER
local hitboxEnabled=false; local hitboxSize=6; local hitboxConns={}
local function applyHitboxToChar(plr)
    if plr==LocalPlayer then return end
    local char=plr.Character; if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart")
    if hrp then pcall(function() hrp.Size=Vector3.new(hitboxSize,hitboxSize,hitboxSize) end) end
end
local function toggleHitbox(state, sz)
    hitboxEnabled=state
    if sz then hitboxSize=sz end
    if state then
        for _,p in ipairs(Players:GetPlayers()) do applyHitboxToChar(p) end
        hitboxConns["added"]=Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function() task.wait(0.5); applyHitboxToChar(p) end)
        end)
    else
        if hitboxConns["added"] then pcall(function() hitboxConns["added"]:Disconnect() end); hitboxConns["added"]=nil end
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer then
                pcall(function()
                    local hrp=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.Size=Vector3.new(2,2,1) end
                end)
            end
        end
    end
end

-- NOCLIP
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

-- ANTI-AFK
local antiAFKConn=nil
local function toggleAntiAFK(state)
    if state then
        if not antiAFKConn then
            local VU=game:GetService("VirtualUser")
            antiAFKConn=LocalPlayer.Idled:Connect(function()
                VU:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                task.wait(1)
                VU:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            end)
        end
    else
        if antiAFKConn then antiAFKConn:Disconnect(); antiAFKConn=nil end
    end
end

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
local Root=Instance.new("Frame")
Root.Size=UDim2.new(0,ROOT_W,0,ROOT_H)
Root.Position=UDim2.new(0.5,-ROOT_W/2,0.5,-ROOT_H/2)
Root.BackgroundColor3=C.BG; Root.BorderSizePixel=0
Root.Active=true; Root.Draggable=true; Root.ZIndex=2
Root.ClipsDescendants=true; Root.Visible=false; Root.Parent=ScreenGui
corner(Root,14); stroke(Root,1.8,0.08); glowOrb(Root,0.88)
local RootBg=Instance.new("ImageLabel")
RootBg.Size=UDim2.new(1,0,1,0); RootBg.BackgroundTransparency=1
RootBg.Image=ID_ANH_NEN; RootBg.ImageTransparency=0.93
RootBg.ScaleType=Enum.ScaleType.Crop; RootBg.ZIndex=1; RootBg.Parent=Root; corner(RootBg,14)
local RootPad=Instance.new("UIPadding")
RootPad.PaddingTop=UDim.new(0,PAD); RootPad.PaddingBottom=UDim.new(0,PAD)
RootPad.PaddingLeft=UDim.new(0,PAD); RootPad.PaddingRight=UDim.new(0,PAD)
RootPad.Parent=Root
local RootLayout=Instance.new("UIListLayout")
RootLayout.FillDirection=Enum.FillDirection.Horizontal
RootLayout.Padding=UDim.new(0,GAP); RootLayout.Parent=Root

-- ══════════════════════════════════════════
--   KEY OVERLAY
-- ══════════════════════════════════════════
local KeyOverlay=Instance.new("Frame")
KeyOverlay.Size=UDim2.new(1,0,1,0); KeyOverlay.BackgroundColor3=C.BG
KeyOverlay.BackgroundTransparency=0.05; KeyOverlay.BorderSizePixel=0
KeyOverlay.ZIndex=20; KeyOverlay.Visible=not keyVerified; KeyOverlay.Parent=Root; corner(KeyOverlay,14)
local KOBg=Instance.new("ImageLabel"); KOBg.Size=UDim2.new(1,0,1,0); KOBg.BackgroundTransparency=1
KOBg.Image=ID_ANH_NEN; KOBg.ImageTransparency=0.55; KOBg.ScaleType=Enum.ScaleType.Stretch
KOBg.ZIndex=20; KOBg.Parent=KeyOverlay; corner(KOBg,14)
local KODark=Instance.new("Frame"); KODark.Size=UDim2.new(1,0,1,0); KODark.BackgroundColor3=C.BG
KODark.BackgroundTransparency=0.45; KODark.BorderSizePixel=0; KODark.ZIndex=21; KODark.Parent=KeyOverlay; corner(KODark,14)
local function koLabel(text,sz,col,y,h)
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-20,0,h or 22)
    l.Position=UDim2.new(0,10,0,y); l.BackgroundTransparency=1; l.Text=text
    l.TextColor3=col or C.TEXT; l.Font=Enum.Font.GothamBold; l.TextSize=sz or 12
    l.ZIndex=23; l.Parent=KeyOverlay; return l
end
local KIcon=koLabel("🔐",28,C.CYAN,0,40); KIcon.Position=UDim2.new(0,0,0.08,0)
local KTitle=koLabel("Nhập key để mở CryoXHUB v5.3",15,C.CYAN,0,24); KTitle.Position=UDim2.new(0,10,0.25,0)
local KSub=koLabel("Key hợp lệ 24 giờ  •  Key: CryoXHUB",11,C.SUB,0,18); KSub.Font=Enum.Font.Gotham; KSub.Position=UDim2.new(0,10,0.36,0)
local KeyInput=Instance.new("TextBox")
KeyInput.Size=UDim2.new(0.75,0,0,38); KeyInput.Position=UDim2.new(0.125,0,0.48,0)
KeyInput.BackgroundColor3=C.PANEL2; KeyInput.PlaceholderText="Nhập Key tại đây..."; KeyInput.Text=""
KeyInput.Font=Enum.Font.Gotham; KeyInput.TextSize=13; KeyInput.TextColor3=C.TEXT
KeyInput.PlaceholderColor3=C.SUB; KeyInput.ZIndex=24; KeyInput.Parent=KeyOverlay; corner(KeyInput,9); stroke(KeyInput,1.5,0.2)
local KeyStatus=Instance.new("TextLabel")
KeyStatus.Size=UDim2.new(1,-20,0,16); KeyStatus.Position=UDim2.new(0,10,0.48,42)
KeyStatus.BackgroundTransparency=1; KeyStatus.Text=""; KeyStatus.TextColor3=C.RED
KeyStatus.Font=Enum.Font.Gotham; KeyStatus.TextSize=11; KeyStatus.ZIndex=23; KeyStatus.Parent=KeyOverlay
local KeySubmit=Instance.new("TextButton")
KeySubmit.Size=UDim2.new(0.75,0,0,36); KeySubmit.Position=UDim2.new(0.125,0,0.48,62)
KeySubmit.BackgroundColor3=C.CYAN; KeySubmit.Text="XÁC NHẬN  (24H)"; KeySubmit.Font=Enum.Font.GothamBold
KeySubmit.TextSize=13; KeySubmit.TextColor3=C.BG; KeySubmit.ZIndex=24; KeySubmit.Parent=KeyOverlay; corner(KeySubmit,9)
KeySubmit.MouseEnter:Connect(function() tw(KeySubmit,{BackgroundColor3=Color3.fromRGB(0,240,255)},0.12) end)
KeySubmit.MouseLeave:Connect(function() tw(KeySubmit,{BackgroundColor3=C.CYAN},0.12) end)

-- ══════════════════════════════════════════
--   COLUMN 1 — LEFT
-- ══════════════════════════════════════════
local LeftCol=Instance.new("Frame")
LeftCol.Size=UDim2.new(0,LEFT_W,1,0); LeftCol.BackgroundTransparency=1
LeftCol.BorderSizePixel=0; LeftCol.ZIndex=3; LeftCol.Parent=Root
local LeftLayout=Instance.new("UIListLayout")
LeftLayout.FillDirection=Enum.FillDirection.Vertical
LeftLayout.Padding=UDim.new(0,GAP); LeftLayout.Parent=LeftCol

-- Avatar Card
local AvatarCard=Instance.new("Frame")
AvatarCard.Size=UDim2.new(1,0,0,AVATAR_H); AvatarCard.BackgroundColor3=C.PANEL
AvatarCard.BorderSizePixel=0; AvatarCard.ZIndex=3; AvatarCard.Parent=LeftCol
corner(AvatarCard,10); stroke(AvatarCard,1.2,0.2); bgImg(AvatarCard,0.78,3)
local AvatarGlow=Instance.new("ImageLabel")
AvatarGlow.Size=UDim2.new(0,70,0,70); AvatarGlow.Position=UDim2.new(0.5,-35,0,2)
AvatarGlow.BackgroundTransparency=1; AvatarGlow.Image="rbxassetid://5028857084"
AvatarGlow.ImageColor3=C.CYAN; AvatarGlow.ImageTransparency=0.70; AvatarGlow.ZIndex=4; AvatarGlow.Parent=AvatarCard
local AvatarImg=Instance.new("ImageLabel")
AvatarImg.Size=UDim2.new(0,54,0,54); AvatarImg.Position=UDim2.new(0.5,-27,0,8)
AvatarImg.BackgroundColor3=C.PANEL2
AvatarImg.Image="rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150"
AvatarImg.ZIndex=5; AvatarImg.Parent=AvatarCard; corner(AvatarImg,999); stroke(AvatarImg,2,0.05)
local function aLbl(text,sz,col,y,h)
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-6,0,h or 14); l.Position=UDim2.new(0,3,0,y)
    l.BackgroundTransparency=1; l.Text=text; l.TextColor3=col or C.TEXT
    l.Font=Enum.Font.GothamBold; l.TextSize=sz or 10; l.TextXAlignment=Enum.TextXAlignment.Center
    l.ZIndex=5; l.Parent=AvatarCard; return l
end
aLbl(LocalPlayer.DisplayName,12,C.TEXT,66,18)
aLbl("@"..LocalPlayer.Name,10,C.CYAN,84,14).Font=Enum.Font.Gotham
local ADiv=Instance.new("Frame"); ADiv.Size=UDim2.new(1,-16,0,1); ADiv.Position=UDim2.new(0,8,0,102)
ADiv.BackgroundColor3=C.CYAN; ADiv.BackgroundTransparency=0.55; ADiv.BorderSizePixel=0; ADiv.ZIndex=4; ADiv.Parent=AvatarCard
aLbl("UID: "..LocalPlayer.UserId,9,C.SUB,106,13).Font=Enum.Font.Gotham
local gn="Unknown Game"
pcall(function() gn=game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
local gnLbl=aLbl(gn,8,C.SUB,119,13); gnLbl.Font=Enum.Font.Gotham; gnLbl.TextTruncate=Enum.TextTruncate.AtEnd
aLbl("CryoXHUB  v5.3  ✦",9,C.CYAN,132,13)

-- Leaderboard
local RANKH = 112
local RankCard=Instance.new("Frame"); RankCard.Size=UDim2.new(1,0,0,RANKH)
RankCard.BackgroundColor3=C.PANEL; RankCard.BorderSizePixel=0; RankCard.ZIndex=3; RankCard.Parent=LeftCol
corner(RankCard,8); stroke(RankCard,1.2,0.2); bgImg(RankCard,0.88,3)
local RankTitle=Instance.new("TextLabel"); RankTitle.Size=UDim2.new(1,-10,0,16); RankTitle.Position=UDim2.new(0,6,0,3)
RankTitle.BackgroundTransparency=1; RankTitle.Text="🏆 LEADERBOARD"; RankTitle.TextColor3=C.CYAN
RankTitle.Font=Enum.Font.GothamBold; RankTitle.TextSize=9; RankTitle.TextXAlignment=Enum.TextXAlignment.Left
RankTitle.ZIndex=5; RankTitle.Parent=RankCard
local RDiv=Instance.new("Frame"); RDiv.Size=UDim2.new(1,-10,0,1); RDiv.Position=UDim2.new(0,5,0,20)
RDiv.BackgroundColor3=C.CYAN; RDiv.BackgroundTransparency=0.55; RDiv.BorderSizePixel=0; RDiv.ZIndex=4; RDiv.Parent=RankCard
local RankScroll=Instance.new("ScrollingFrame")
RankScroll.Size=UDim2.new(1,-4,0,RANKH-24); RankScroll.Position=UDim2.new(0,2,0,23)
RankScroll.BackgroundTransparency=1; RankScroll.BorderSizePixel=0
RankScroll.ScrollBarThickness=2; RankScroll.ScrollBarImageColor3=C.CYAN
RankScroll.CanvasSize=UDim2.new(0,0,0,0); RankScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
RankScroll.ZIndex=5; RankScroll.Parent=RankCard
local RankLL=Instance.new("UIListLayout",RankScroll); RankLL.Padding=UDim.new(0,2)
local RankLP=Instance.new("UIPadding",RankScroll); RankLP.PaddingTop=UDim.new(0,1)
local rankMedals={"🥇","🥈","🥉"}
local function refreshRank()
    for _,v in pairs(RankScroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    local plrs=Players:GetPlayers(); local entries={}
    for _,p in ipairs(plrs) do
        local sc=0; pcall(function()
            local ls=p:FindFirstChild("leaderstats"); if ls then
                for _,v2 in pairs(ls:GetChildren()) do
                    local n=tonumber(tostring(v2.Value)); if n then sc=sc+n; break end
                end
            end
        end)
        table.insert(entries,{name=p.DisplayName,score=sc})
    end
    table.sort(entries,function(a,b) return a.score>b.score end)
    for i,e in ipairs(entries) do
        if i>7 then break end
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,-2,0,18); row.BackgroundColor3=C.PANEL2
        row.BorderSizePixel=0; row.ZIndex=6; row.Parent=RankScroll; corner(row,4)
        local med=Instance.new("TextLabel"); med.Size=UDim2.new(0,16,1,0); med.Position=UDim2.new(0,1,0,0)
        med.BackgroundTransparency=1; med.Text=rankMedals[i] or tostring(i)
        med.TextColor3=i<=3 and Color3.fromRGB(255,160,30) or C.SUB
        med.Font=Enum.Font.GothamBold; med.TextSize=7; med.ZIndex=7; med.Parent=row
        local nm=Instance.new("TextLabel"); nm.Size=UDim2.new(1,-52,1,0); nm.Position=UDim2.new(0,18,0,0)
        nm.BackgroundTransparency=1; nm.Text=e.name; nm.TextColor3=C.TEXT
        nm.Font=Enum.Font.Gotham; nm.TextSize=7; nm.TextXAlignment=Enum.TextXAlignment.Left
        nm.TextTruncate=Enum.TextTruncate.AtEnd; nm.ZIndex=7; nm.Parent=row
        local sc2=Instance.new("TextLabel"); sc2.Size=UDim2.new(0,32,1,0); sc2.Position=UDim2.new(1,-34,0,0)
        sc2.BackgroundTransparency=1; sc2.Text=tostring(e.score); sc2.TextColor3=C.CYAN
        sc2.Font=Enum.Font.GothamBold; sc2.TextSize=7; sc2.ZIndex=7; sc2.Parent=row
    end
end
pcall(refreshRank)
task.spawn(function() while task.wait(6) do pcall(refreshRank) end end)
Players.PlayerAdded:Connect(function() task.wait(0.5); pcall(refreshRank) end)
Players.PlayerRemoving:Connect(function() task.wait(0.5); pcall(refreshRank) end)

-- Update Log
local UpdateCard=Instance.new("Frame")
do local tempSize=ROOT_H-PAD*2-AVATAR_H-GAP-RANKH-GAP
UpdateCard.Size=UDim2.new(1,0,0,tempSize) end
UpdateCard.BackgroundColor3=C.PANEL; UpdateCard.BorderSizePixel=0; UpdateCard.ZIndex=3; UpdateCard.Parent=LeftCol
corner(UpdateCard,8); stroke(UpdateCard,1.2,0.2); bgImg(UpdateCard,0.88,3)
local UpdateTitle2=Instance.new("TextLabel")
UpdateTitle2.Size=UDim2.new(1,-10,0,16); UpdateTitle2.Position=UDim2.new(0,6,0,3)
UpdateTitle2.BackgroundTransparency=1; UpdateTitle2.Text="  Update Log"; UpdateTitle2.TextColor3=C.CYAN
UpdateTitle2.Font=Enum.Font.GothamBold; UpdateTitle2.TextSize=9; UpdateTitle2.TextXAlignment=Enum.TextXAlignment.Left
UpdateTitle2.ZIndex=5; UpdateTitle2.Parent=UpdateCard
local UDiv2=Instance.new("Frame"); UDiv2.Size=UDim2.new(1,-10,0,1); UDiv2.Position=UDim2.new(0,5,0,20)
UDiv2.BackgroundColor3=C.CYAN; UDiv2.BackgroundTransparency=0.55; UDiv2.BorderSizePixel=0; UDiv2.ZIndex=4; UDiv2.Parent=UpdateCard
local UpdateScroll=Instance.new("ScrollingFrame")
UpdateScroll.Size=UDim2.new(1,-6,1,-24); UpdateScroll.Position=UDim2.new(0,3,0,23)
UpdateScroll.BackgroundTransparency=1; UpdateScroll.BorderSizePixel=0
UpdateScroll.ScrollBarThickness=2; UpdateScroll.ScrollBarImageColor3=C.CYAN
UpdateScroll.CanvasSize=UDim2.new(0,0,0,0); UpdateScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
UpdateScroll.ZIndex=5; UpdateScroll.Parent=UpdateCard
local UL2=Instance.new("UIListLayout",UpdateScroll); UL2.Padding=UDim.new(0,3)
local UP3=Instance.new("UIPadding",UpdateScroll); UP3.PaddingTop=UDim.new(0,2)
local updates={
    {"v5.3","Tab mới: COMBAT, FPS, VISUAL, PLAYER, SETTING"},
    {"v5.3","12 Themes + Theme Picker"},
    {"v5.3","ESP Box, Hitbox vào Settings"},
    {"v5.3","Combat gộp Tech + Moveset"},
    {"v5.2","GUI layout + ảnh nền restored"},
    {"v5.1","ESP Friends + Hitbox Expander"},
    {"v4.1","Walkspeed & JumpPower slider"},
    {"v4.0","Search + Yêu Thích + EXEC"},
    {"v3.6","MAP + 16 Teleport locations"},
}
for _,u in ipairs(updates) do
    local row=Instance.new("Frame"); row.Size=UDim2.new(1,-2,0,20); row.BackgroundColor3=C.PANEL2
    row.BorderSizePixel=0; row.ZIndex=6; row.Parent=UpdateScroll; corner(row,5)
    local ver=Instance.new("TextLabel"); ver.Size=UDim2.new(0,30,1,0); ver.Position=UDim2.new(0,3,0,0)
    ver.BackgroundTransparency=1; ver.Text=u[1]; ver.TextColor3=C.CYAN; ver.Font=Enum.Font.GothamBold
    ver.TextSize=7; ver.ZIndex=7; ver.Parent=row
    local desc=Instance.new("TextLabel"); desc.Size=UDim2.new(1,-34,1,0); desc.Position=UDim2.new(0,32,0,0)
    desc.BackgroundTransparency=1; desc.Text=u[2]; desc.TextColor3=C.SUB; desc.Font=Enum.Font.Gotham
    desc.TextSize=7; desc.TextXAlignment=Enum.TextXAlignment.Left; desc.TextWrapped=true; desc.ZIndex=7; desc.Parent=row
end

-- ══════════════════════════════════════════
--   COLUMN 2 — MID
-- ══════════════════════════════════════════
local MidCol=Instance.new("Frame")
MidCol.Size=UDim2.new(0,MID_W,1,0); MidCol.BackgroundColor3=C.PANEL
MidCol.BorderSizePixel=0; MidCol.ZIndex=3; MidCol.Parent=Root; MidCol.ClipsDescendants=true
corner(MidCol,10); stroke(MidCol,1.2,0.2); bgImg(MidCol,0.92,3)
local MidInner=Instance.new("Frame"); MidInner.Size=UDim2.new(1,-6,1,-36); MidInner.Position=UDim2.new(0,3,0,4)
MidInner.BackgroundTransparency=1; MidInner.ZIndex=4; MidInner.Parent=MidCol
local MidLayout=Instance.new("UIListLayout"); MidLayout.FillDirection=Enum.FillDirection.Vertical
MidLayout.Padding=UDim.new(0,3); MidLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center; MidLayout.Parent=MidInner

-- Theme Picker Button (bên dưới col2)
local ThemePickerBtn=Instance.new("TextButton"); ThemePickerBtn.Size=UDim2.new(1,-6,0,28)
ThemePickerBtn.Position=UDim2.new(0,3,1,-31)
ThemePickerBtn.BackgroundColor3=C.PANEL2; ThemePickerBtn.Text="🎨 Theme"; ThemePickerBtn.Font=Enum.Font.GothamBold
ThemePickerBtn.TextSize=9; ThemePickerBtn.TextColor3=C.CYAN; ThemePickerBtn.ZIndex=5; ThemePickerBtn.Parent=MidCol
corner(ThemePickerBtn,7); stroke(ThemePickerBtn,1,0.3)

-- ══════════════════════════════════════════
--   COLUMN 3 — RIGHT
-- ══════════════════════════════════════════
local RightCol=Instance.new("Frame")
RightCol.Size=UDim2.new(0,RIGHT_W,1,0); RightCol.BackgroundTransparency=1
RightCol.BorderSizePixel=0; RightCol.ZIndex=3; RightCol.Parent=Root

-- SubTab row
local TabRow=Instance.new("Frame")
TabRow.Size=UDim2.new(1,0,0,TAB_H); TabRow.Position=UDim2.new(0,0,0,0)
TabRow.BackgroundColor3=C.PANEL; TabRow.BorderSizePixel=0; TabRow.ZIndex=4; TabRow.Parent=RightCol
corner(TabRow,9); stroke(TabRow,1.2,0.2)
local TabBar=Instance.new("Frame")
TabBar.Size=UDim2.new(1,-(TAB_H+GAP),1,0); TabBar.BackgroundTransparency=1; TabBar.ZIndex=4; TabBar.Parent=TabRow
local TabScroll=Instance.new("ScrollingFrame")
TabScroll.Size=UDim2.new(1,-4,1,-4); TabScroll.Position=UDim2.new(0,2,0,2)
TabScroll.BackgroundTransparency=1; TabScroll.BorderSizePixel=0; TabScroll.ScrollBarThickness=0
TabScroll.CanvasSize=UDim2.new(0,0,0,0); TabScroll.AutomaticCanvasSize=Enum.AutomaticSize.X
TabScroll.ScrollingDirection=Enum.ScrollingDirection.X; TabScroll.ZIndex=5; TabScroll.Parent=TabBar
local TabLayout=Instance.new("UIListLayout"); TabLayout.FillDirection=Enum.FillDirection.Horizontal
TabLayout.Padding=UDim.new(0,4); TabLayout.VerticalAlignment=Enum.VerticalAlignment.Center; TabLayout.Parent=TabScroll
local CloseBtn=Instance.new("TextButton")
CloseBtn.Size=UDim2.new(0,TAB_H,0,TAB_H); CloseBtn.Position=UDim2.new(1,-TAB_H,0,0)
CloseBtn.BackgroundColor3=C.RED; CloseBtn.Text="✕"; CloseBtn.TextColor3=C.TEXT
CloseBtn.Font=Enum.Font.GothamBold; CloseBtn.TextSize=13; CloseBtn.ZIndex=6; CloseBtn.Parent=TabRow; corner(CloseBtn,8)
CloseBtn.MouseEnter:Connect(function() tw(CloseBtn,{BackgroundColor3=Color3.fromRGB(240,70,70)},0.12) end)
CloseBtn.MouseLeave:Connect(function() tw(CloseBtn,{BackgroundColor3=C.RED},0.12) end)

-- Search Row
local SearchRow=Instance.new("Frame")
SearchRow.Size=UDim2.new(1,0,0,26); SearchRow.Position=UDim2.new(0,0,0,TAB_H+GAP)
SearchRow.BackgroundTransparency=1; SearchRow.ZIndex=4; SearchRow.Parent=RightCol
local SearchBox=Instance.new("TextBox")
SearchBox.Size=UDim2.new(1,0,1,0); SearchBox.BackgroundColor3=C.PANEL
SearchBox.PlaceholderText="🔍  Tìm kiếm script..."; SearchBox.Text=""
SearchBox.Font=Enum.Font.Gotham; SearchBox.TextSize=11; SearchBox.TextColor3=C.TEXT
SearchBox.PlaceholderColor3=C.SUB; SearchBox.ZIndex=5; SearchBox.Parent=SearchRow
corner(SearchBox,8); stroke(SearchBox,1.2,0.3)
local SrchPad=Instance.new("UIPadding",SearchBox); SrchPad.PaddingLeft=UDim.new(0,8)

-- Content Area
local ContentBg=Instance.new("Frame")
ContentBg.Size=UDim2.new(1,0,0,ROOT_H-PAD*2-TAB_H-GAP-26-GAP)
ContentBg.Position=UDim2.new(0,0,0,TAB_H+GAP+26+GAP)
ContentBg.BackgroundColor3=C.PANEL; ContentBg.BorderSizePixel=0; ContentBg.ClipsDescendants=true
ContentBg.ZIndex=3; ContentBg.Parent=RightCol; corner(ContentBg,10); stroke(ContentBg,1.2,0.2)
local CBgImg=Instance.new("ImageLabel"); CBgImg.Size=UDim2.new(1,0,1,0); CBgImg.BackgroundTransparency=1
CBgImg.Image=ID_ANH_NEN; CBgImg.ImageTransparency=0.42; CBgImg.ScaleType=Enum.ScaleType.Stretch
CBgImg.ZIndex=3; CBgImg.Parent=ContentBg; corner(CBgImg,10)
local COvl=Instance.new("Frame"); COvl.Size=UDim2.new(1,0,1,0); COvl.BackgroundColor3=C.BG
COvl.BackgroundTransparency=0.48; COvl.BorderSizePixel=0; COvl.ZIndex=4; COvl.Parent=ContentBg; corner(COvl,10)
local ContentFrame=Instance.new("ScrollingFrame")
ContentFrame.Size=UDim2.new(1,-6,1,-8); ContentFrame.Position=UDim2.new(0,3,0,4)
ContentFrame.BackgroundTransparency=1; ContentFrame.ZIndex=6
ContentFrame.CanvasSize=UDim2.new(0,0,0,0); ContentFrame.AutomaticCanvasSize=Enum.AutomaticSize.Y
ContentFrame.ScrollBarThickness=3; ContentFrame.ScrollBarImageColor3=C.CYAN
ContentFrame.BorderSizePixel=0; ContentFrame.Parent=ContentBg
local CLayout=Instance.new("UIListLayout"); CLayout.Padding=UDim.new(0,5); CLayout.Parent=ContentFrame
local CPad=Instance.new("UIPadding"); CPad.PaddingTop=UDim.new(0,4); CPad.PaddingBottom=UDim.new(0,4)
CPad.PaddingLeft=UDim.new(0,2); CPad.PaddingRight=UDim.new(0,2); CPad.Parent=ContentFrame

-- Search Results
local SRBg=Instance.new("Frame"); SRBg.Size=UDim2.new(1,0,1,0); SRBg.BackgroundColor3=C.BG
SRBg.BackgroundTransparency=0.05; SRBg.BorderSizePixel=0; SRBg.ZIndex=15; SRBg.Visible=false
SRBg.Parent=ContentBg; corner(SRBg,10)
local SRScroll=Instance.new("ScrollingFrame"); SRScroll.Size=UDim2.new(1,-6,1,-8); SRScroll.Position=UDim2.new(0,3,0,4)
SRScroll.BackgroundTransparency=1; SRScroll.ZIndex=16; SRScroll.CanvasSize=UDim2.new(0,0,0,0)
SRScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; SRScroll.ScrollBarThickness=3
SRScroll.ScrollBarImageColor3=C.CYAN; SRScroll.BorderSizePixel=0; SRScroll.Parent=SRBg
local SRL=Instance.new("UIListLayout"); SRL.Padding=UDim.new(0,5); SRL.Parent=SRScroll
local SRPAD=Instance.new("UIPadding"); SRPAD.PaddingTop=UDim.new(0,4); SRPAD.PaddingBottom=UDim.new(0,4)
SRPAD.PaddingLeft=UDim.new(0,2); SRPAD.PaddingRight=UDim.new(0,2); SRPAD.Parent=SRScroll

-- Open Button
local OpenBtn=Instance.new("ImageButton")
OpenBtn.Size=UDim2.new(0,46,0,46); OpenBtn.Position=UDim2.new(0,12,0.5,-23)
OpenBtn.Image=ID_LOGO_DONG; OpenBtn.BackgroundColor3=C.PANEL; OpenBtn.Visible=false; OpenBtn.Draggable=true
OpenBtn.ZIndex=5; OpenBtn.Parent=ScreenGui; corner(OpenBtn,10); stroke(OpenBtn,1.5,0.15); glowOrb(OpenBtn,0.82)

-- ══════════════════════════════════════════
--   ANIMATE
-- ══════════════════════════════════════════
local function animateOpen()
    Root.Visible=true; Root.Size=UDim2.new(0,ROOT_W*0.88,0,ROOT_H*0.88)
    Root.Position=UDim2.new(0.5,-(ROOT_W*0.88)/2,0.5,-(ROOT_H*0.88)/2); Root.BackgroundTransparency=1
    tw(Root,{Size=UDim2.new(0,ROOT_W,0,ROOT_H),Position=UDim2.new(0.5,-ROOT_W/2,0.5,-ROOT_H/2),BackgroundTransparency=0},0.35,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
end
local function animateClose(cb)
    tw(Root,{Size=UDim2.new(0,ROOT_W*0.88,0,ROOT_H*0.88),Position=UDim2.new(0.5,-(ROOT_W*0.88)/2,0.5,-(ROOT_H*0.88)/2),BackgroundTransparency=1},0.25)
    task.delay(0.26,function() Root.Visible=false; if cb then cb() end end)
end

-- ══════════════════════════════════════════
--   TAB SYSTEM
-- ══════════════════════════════════════════
local currentTabIndex=1; local isSliding=false
local function slideContent(newIndex,loadFunc)
    if isSliding then return end; isSliding=true
    local W=ContentBg.AbsoluteSize.X
    local goRight=newIndex>currentTabIndex; currentTabIndex=newIndex
    local exitX=goRight and -W or W; local enterX=goRight and W or -W
    tw(ContentFrame,{Position=UDim2.new(0,exitX,0,4)},0.15,Enum.EasingStyle.Cubic,Enum.EasingDirection.In)
    task.wait(0.16)
    for _,v in pairs(ContentFrame:GetChildren()) do
        if v:IsA("GuiObject") and not (v:IsA("UIListLayout") or v:IsA("UIPadding")) then v:Destroy() end
    end
    ContentFrame.CanvasPosition=Vector2.new(0,0); loadFunc()
    ContentFrame.Position=UDim2.new(0,enterX,0,4)
    tw(ContentFrame,{Position=UDim2.new(0,3,0,4)},0.18,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out)
    task.wait(0.19); isSliding=false
end
local activeMainTab=nil
local function setMainActive(btn,index,loadFunc)
    if activeMainTab==btn or isSliding then return end
    if activeMainTab then
        tw(activeMainTab,{BackgroundColor3=C.PANEL2},0.18); activeMainTab.TextColor3=C.SUB
        local s=activeMainTab:FindFirstChildOfClass("UIStroke"); if s then tw(s,{Transparency=0.6},0.18) end
    end
    activeMainTab=btn; tw(btn,{BackgroundColor3=Color3.fromRGB(0,50,90)},0.18); btn.TextColor3=C.CYAN
    local s=btn:FindFirstChildOfClass("UIStroke"); if s then tw(s,{Transparency=0},0.18) end
    if loadFunc then task.spawn(function() slideContent(index,loadFunc) end) end
end
local activeSubTab=nil
local function setSubActive(btn,loadFunc)
    if activeSubTab==btn then return end
    if activeSubTab then
        tw(activeSubTab,{BackgroundColor3=C.PANEL2},0.15); activeSubTab.TextColor3=C.SUB
        local s=activeSubTab:FindFirstChildOfClass("UIStroke"); if s then tw(s,{Transparency=0.6},0.15) end
    end
    activeSubTab=btn; tw(btn,{BackgroundColor3=Color3.fromRGB(0,50,90)},0.15); btn.TextColor3=C.CYAN
    local s=btn:FindFirstChildOfClass("UIStroke"); if s then tw(s,{Transparency=0},0.15) end
    if loadFunc then
        for _,v in pairs(ContentFrame:GetChildren()) do
            if v:IsA("GuiObject") and not (v:IsA("UIListLayout") or v:IsA("UIPadding")) then v:Destroy() end
        end
        ContentFrame.CanvasPosition=Vector2.new(0,0)
        loadFunc()
    end
end
local function clearContent()
    for _,v in pairs(ContentFrame:GetChildren()) do
        if v:IsA("GuiObject") and not (v:IsA("UIListLayout") or v:IsA("UIPadding")) then v:Destroy() end
    end
end
local function buildSubTabs(tabDefs)
    for _,v in pairs(TabScroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    activeSubTab=nil
    local firstBtn=nil
    for i,def in ipairs(tabDefs) do
        local btn=Instance.new("TextButton"); btn.Size=UDim2.new(0,68,0,24); btn.Text=def.name
        btn.BackgroundColor3=C.PANEL2; btn.TextColor3=C.SUB; btn.Font=Enum.Font.GothamBold
        btn.TextSize=9; btn.ZIndex=6; btn.Parent=TabScroll; corner(btn,7); stroke(btn,1.2,0.6)
        btn.MouseEnter:Connect(function() if activeSubTab~=btn then tw(btn,{BackgroundColor3=Color3.fromRGB(0,26,50)},0.12) end end)
        btn.MouseLeave:Connect(function() if activeSubTab~=btn then tw(btn,{BackgroundColor3=C.PANEL2},0.12) end end)
        local loadF=def.load; btn.MouseButton1Click:Connect(function() setSubActive(btn,loadF) end)
        if i==1 then firstBtn=btn end
    end
    if firstBtn then task.spawn(function() task.wait(0.05); setSubActive(firstBtn,tabDefs[1].load) end) end
end

-- ══════════════════════════════════════════
--   UI BUILDERS
-- ══════════════════════════════════════════
local AllScripts={}
local function isFavorited(name)
    for _,f in ipairs(Favorites) do if f.name==name then return true end end; return false
end
local function addFavorite(name,code)
    if not isFavorited(name) then table.insert(Favorites,{name=name,code=code}); saveFavorites() end
end
local function removeFavorite(name)
    for i,f in ipairs(Favorites) do if f.name==name then table.remove(Favorites,i); saveFavorites(); return end end
end

local function makeScriptBtn(name,code,parent)
    parent=parent or ContentFrame
    local found=false
    for _,s in ipairs(AllScripts) do if s.name==name then found=true; break end end
    if not found then table.insert(AllScripts,{name=name,code=code}) end
    local btn=Instance.new("Frame"); btn.Size=UDim2.new(1,0,0,36); btn.BackgroundColor3=C.PANEL2
    btn.BorderSizePixel=0; btn.ZIndex=7; btn.Parent=parent; corner(btn,8); stroke(btn,1.2,0.5)
    local runBtn=Instance.new("TextButton"); runBtn.Size=UDim2.new(1,-70,1,0); runBtn.Position=UDim2.new(0,0,0,0)
    runBtn.BackgroundTransparency=1; runBtn.Text=""; runBtn.ZIndex=9; runBtn.Parent=btn
    local ic=Instance.new("TextLabel"); ic.Size=UDim2.new(0,28,1,0); ic.Position=UDim2.new(0,5,0,0)
    ic.BackgroundTransparency=1; ic.Text="▶"; ic.TextColor3=C.CYAN; ic.Font=Enum.Font.GothamBold
    ic.TextSize=12; ic.ZIndex=8; ic.Parent=btn
    local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,-104,1,0); nl.Position=UDim2.new(0,30,0,0)
    nl.BackgroundTransparency=1; nl.Text=name; nl.TextColor3=C.TEXT; nl.Font=Enum.Font.GothamBold
    nl.TextSize=11; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.TextTruncate=Enum.TextTruncate.AtEnd
    nl.ZIndex=8; nl.Parent=btn
    local favState=isFavorited(name)
    local favBtn=Instance.new("TextButton"); favBtn.Size=UDim2.new(0,28,0,28); favBtn.Position=UDim2.new(1,-64,0.5,-14)
    favBtn.BackgroundColor3=favState and Color3.fromRGB(255,200,30) or C.PANEL
    favBtn.Text=favState and "★" or "☆"; favBtn.Font=Enum.Font.GothamBold; favBtn.TextSize=14
    favBtn.TextColor3=favState and C.BG or C.SUB; favBtn.ZIndex=9; favBtn.Parent=btn; corner(favBtn,6)
    favBtn.MouseButton1Click:Connect(function()
        if isFavorited(name) then
            removeFavorite(name); favBtn.Text="☆"; favBtn.TextColor3=C.SUB
            tw(favBtn,{BackgroundColor3=C.PANEL},0.15)
            task.spawn(function() showToast("💔  Xóa khỏi Yêu Thích: "..name,C.RED,2) end)
        else
            addFavorite(name,code); favBtn.Text="★"; favBtn.TextColor3=C.BG
            tw(favBtn,{BackgroundColor3=Color3.fromRGB(255,200,30)},0.15)
            task.spawn(function() showToast("⭐  Thêm Yêu Thích: "..name,C.CYAN,2) end)
        end
    end)
    local copyBtn=Instance.new("TextButton"); copyBtn.Size=UDim2.new(0,28,0,28); copyBtn.Position=UDim2.new(1,-32,0.5,-14)
    copyBtn.BackgroundColor3=C.PANEL; copyBtn.Text="⧉"; copyBtn.Font=Enum.Font.GothamBold; copyBtn.TextSize=13
    copyBtn.TextColor3=C.SUB; copyBtn.ZIndex=9; copyBtn.Parent=btn; corner(copyBtn,6)
    copyBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(code); task.spawn(function() showToast("📋  Đã copy: "..name,C.GREEN,2) end)
        else task.spawn(function() showToast("❌  Không hỗ trợ clipboard",C.RED,2) end) end
    end)
    runBtn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=Color3.fromRGB(0,38,68)},0.12); tw(nl,{TextColor3=C.CYAN},0.12) end)
    runBtn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=C.PANEL2},0.12); tw(nl,{TextColor3=C.TEXT},0.12) end)
    runBtn.MouseButton1Click:Connect(function()
        tw(btn,{BackgroundColor3=Color3.fromRGB(0,65,100)},0.08); task.wait(0.1); tw(btn,{BackgroundColor3=C.PANEL2},0.18)
        local f,e=loadstring(code); if f then task.spawn(f) else warn("[CryoX] "..tostring(e)) end
    end)
    return btn
end

local function makeActionBtn(name,icon,callback,parent)
    parent=parent or ContentFrame
    local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,0,36); btn.Text=""
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

local function makeSectionLabel(text,parent)
    parent=parent or ContentFrame
    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,0,0,18); lbl.BackgroundTransparency=1
    lbl.Text="── "..text.." ──"; lbl.TextColor3=C.CYAN; lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=9; lbl.TextXAlignment=Enum.TextXAlignment.Center; lbl.ZIndex=7; lbl.Parent=parent
end

local function makeToggle(labelText,state,onChange,parent)
    parent=parent or ContentFrame
    local frame=Instance.new("Frame"); frame.Size=UDim2.new(1,0,0,34); frame.BackgroundColor3=C.PANEL2
    frame.BorderSizePixel=0; frame.ZIndex=7; frame.Parent=parent; corner(frame,8); stroke(frame,1.2,0.5)
    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.72,0,1,0); lbl.Position=UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=labelText; lbl.TextColor3=C.TEXT; lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=11; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=8; lbl.Parent=frame
    local pill=Instance.new("Frame"); pill.Size=UDim2.new(0,40,0,20); pill.Position=UDim2.new(1,-48,0.5,-10)
    pill.BackgroundColor3=state and C.CYAN or C.PANEL; pill.BorderSizePixel=0; pill.ZIndex=8; pill.Parent=frame
    corner(pill,999); stroke(pill,1.2,state and 0.4 or 0.2)
    local dot=Instance.new("Frame"); dot.Size=UDim2.new(0,14,0,14)
    dot.Position=state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
    dot.BackgroundColor3=state and C.BG or C.SUB; dot.BorderSizePixel=0; dot.ZIndex=9; dot.Parent=pill; corner(dot,999)
    local isOn=state
    local tBtn=Instance.new("TextButton"); tBtn.Size=UDim2.new(1,0,1,0); tBtn.BackgroundTransparency=1
    tBtn.Text=""; tBtn.ZIndex=10; tBtn.Parent=frame
    tBtn.MouseButton1Click:Connect(function()
        isOn=not isOn
        tw(pill,{BackgroundColor3=isOn and C.CYAN or C.PANEL},0.18)
        tw(dot,{Position=isOn and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),BackgroundColor3=isOn and C.BG or C.SUB},0.18)
        onChange(isOn)
    end)
end

local function makeSlider(labelText,minVal,maxVal,currentVal,onChange,parent)
    parent=parent or ContentFrame
    local frame=Instance.new("Frame"); frame.Size=UDim2.new(1,0,0,46); frame.BackgroundColor3=C.PANEL2
    frame.BorderSizePixel=0; frame.ZIndex=7; frame.Parent=parent; corner(frame,8); stroke(frame,1.2,0.5)
    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.65,0,0,20); lbl.Position=UDim2.new(0,10,0,4)
    lbl.BackgroundTransparency=1; lbl.Text=labelText; lbl.TextColor3=C.TEXT; lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=11; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=8; lbl.Parent=frame
    local valLbl=Instance.new("TextLabel"); valLbl.Size=UDim2.new(0.3,0,0,20); valLbl.Position=UDim2.new(0.68,0,0,4)
    valLbl.BackgroundTransparency=1; valLbl.Text=tostring(currentVal); valLbl.TextColor3=C.CYAN
    valLbl.Font=Enum.Font.GothamBold; valLbl.TextSize=12; valLbl.TextXAlignment=Enum.TextXAlignment.Right
    valLbl.ZIndex=8; valLbl.Parent=frame
    local track=Instance.new("Frame"); track.Size=UDim2.new(1,-20,0,6); track.Position=UDim2.new(0,10,0,30)
    track.BackgroundColor3=C.PANEL; track.BorderSizePixel=0; track.ZIndex=8; track.Parent=frame; corner(track,999)
    local fill=Instance.new("Frame"); fill.Size=UDim2.new((currentVal-minVal)/math.max(maxVal-minVal,1),0,1,0)
    fill.BackgroundColor3=C.CYAN; fill.BorderSizePixel=0; fill.ZIndex=9; fill.Parent=track; corner(fill,999)
    local handle=Instance.new("Frame"); handle.Size=UDim2.new(0,16,0,16)
    handle.Position=UDim2.new((currentVal-minVal)/math.max(maxVal-minVal,1),-8,0.5,-8)
    handle.BackgroundColor3=C.TEXT; handle.BorderSizePixel=0; handle.ZIndex=10; handle.Parent=track; corner(handle,999)
    local dragBtn=Instance.new("TextButton")
    dragBtn.Size=UDim2.new(1,20,0,30); dragBtn.Position=UDim2.new(0,-10,0.5,-15)
    dragBtn.BackgroundTransparency=1; dragBtn.Text=""; dragBtn.ZIndex=12; dragBtn.Parent=track
    local dragging=false
    dragBtn.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then dragging=true end
    end)
    dragBtn.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)
    UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType~=Enum.UserInputType.MouseMovement
        and input.UserInputType~=Enum.UserInputType.Touch then return end
        local abs=track.AbsolutePosition; local sz=track.AbsoluteSize
        local mouseX=input.UserInputType==Enum.UserInputType.Touch
            and input.Position.X or UIS:GetMouseLocation().X
        local rel=math.clamp((mouseX-abs.X)/math.max(sz.X,1),0,1)
        local val=math.floor(minVal+(maxVal-minVal)*rel)
        fill.Size=UDim2.new(rel,0,1,0)
        handle.Position=UDim2.new(rel,-8,0.5,-8)
        valLbl.Text=tostring(val)
        if onChange then onChange(val) end
    end)
    return frame
end

-- ══════════════════════════════════════════
--   THEME APPLY FUNCTION
-- ══════════════════════════════════════════
local function applyTheme(theme)
    C.BG=theme.bg; C.PANEL=theme.panel; C.PANEL2=theme.panel2
    tw(Root,{BackgroundColor3=theme.bg},0.3)
    tw(MidCol,{BackgroundColor3=theme.panel},0.3)
    tw(AvatarCard,{BackgroundColor3=theme.panel},0.3)
    tw(RankCard,{BackgroundColor3=theme.panel},0.3)
    tw(UpdateCard,{BackgroundColor3=theme.panel},0.3)
    tw(TabRow,{BackgroundColor3=theme.panel},0.3)
    tw(ContentBg,{BackgroundColor3=theme.panel},0.3)
    tw(COvl,{BackgroundColor3=theme.bg},0.3)
    SaveData.currentTheme=theme.name; writeSave(SaveData)
    task.spawn(function() showToast("🎨 Theme: "..theme.name,C.CYAN,2) end)
end

local function applyAccentColor(newColor)
    local old=Settings.accentColor; Settings.accentColor=newColor; C.CYAN=newColor
    for _,v in ipairs(Root:GetDescendants()) do
        if v:IsA("UIStroke") then v.Color=newColor end
        if v:IsA("TextLabel") and v.TextColor3==old then v.TextColor3=newColor end
        if v:IsA("ImageLabel") and v.ImageColor3==old then v.ImageColor3=newColor end
    end
    saveSettings(); task.spawn(function() showToast("🎨  Đã đổi màu!",newColor,2) end)
end

-- ══════════════════════════════════════════
--   SEARCH
-- ══════════════════════════════════════════
local function buildSearchResults(query)
    for _,v in pairs(SRScroll:GetChildren()) do
        if v:IsA("GuiObject") and not (v:IsA("UIListLayout") or v:IsA("UIPadding")) then v:Destroy() end
    end
    query=query:lower(); local count=0
    for _,s in ipairs(AllScripts) do
        if s.name:lower():find(query,1,true) then
            makeScriptBtn(s.name,s.code,SRScroll); count=count+1
        end
    end
    if count==0 then
        local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,0,0,40); nl.BackgroundTransparency=1
        nl.Text="❌  Không tìm thấy '"..query.."'"; nl.TextColor3=C.SUB; nl.Font=Enum.Font.GothamBold
        nl.TextSize=11; nl.TextXAlignment=Enum.TextXAlignment.Center; nl.ZIndex=17; nl.Parent=SRScroll
    end
end
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q=SearchBox.Text
    if q and #q>0 then SRBg.Visible=true; buildSearchResults(q)
    else SRBg.Visible=false end
end)

-- ══════════════════════════════════════════
--   CONTENT LOADERS — COMBAT TAB
-- ══════════════════════════════════════════
local function LoadCombat_Tech()
    makeSectionLabel("TECH SCRIPTS")
    makeScriptBtn("Supa Tech",          [[loadstring(game:HttpGet("https://rawscripts.net/raw/The-Strongest-Battlegrounds-Supa-tech-v2-77454"))()]])
    makeScriptBtn("Kiba Tech",          [[loadstring(game:HttpGet("https://raw.githubusercontent.com/yqantg-pixel/Find/refs/heads/main/Protected_1593573630798166.lua.txt"))()]])
    makeScriptBtn("Oreo Tech",          [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/OreoTech/refs/heads/main/Protected_6856895483929371.lua"))()]])
    makeScriptBtn("lix tech",           [[loadstring(game:HttpGet("https://raw.githubusercontent.com/MerebennieOfficial/ExoticJn/refs/heads/main/Protected_83737738.txt"))()]])
    makeScriptBtn("lethal kiba",        [[loadstring(game:HttpGet("https://raw.githubusercontent.com/MinhNhatHUB/MinhNhat/refs/heads/main/Lethal%20Kiba.lua"))()]])
    makeScriptBtn("Silent aim reworked",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/yqantg-pixel/Find/refs/heads/main/Protected_6124417452209241.lua.txt"))()]])
end
local function LoadCombat_Dash()
    makeSectionLabel("DASH TECHNIQUES")
    makeScriptBtn("Lethal Dash",        [[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/57a4d240a2440f0450986c966469092ccfb8d4797392cb8f469fa8b6e605e64d/download"))()]])
    makeScriptBtn("Back Dash Cancel",   [[loadstring(game:HttpGet("https://raw.githubusercontent.com/dinhthanhtuankiet1762009-sudo/Js/refs/heads/main/4418648b0e9b71ef.lua"))()]])
    makeScriptBtn("Instant Twisted v2", [[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/60a7a7c77395006ebd63fce0a17c13241f932bd414c9aba3158b716da00ade01/download"))()]])
    makeScriptBtn("Loop Dash",          [[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/28513f51c0ca2c03d4d7d94f59215d13ce1a2a470bf187f0a685b58ccb4dae98/download"))()]])
end
local function LoadCombat_Moveset()
    makeSectionLabel("MOVESET / MORPH")
    makeScriptBtn("KAR [SAITAMA]",  [[loadstring(game:HttpGet("https://raw.githubusercontent.com/OfficialAposty/RBLX-Scripts/refs/heads/main/UltimateLifeForm.lua"))()]])
    makeScriptBtn("Gojo [SAITAMA]", [[getgenv().morph=false loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/BaldyToSorcerer/refs/heads/main/LatestV2.lua"))()]])
    makeScriptBtn("CHARA [SAITAMA]",[[loadstring(game:HttpGet("https://pastefy.app/gFRaeMGz/raw"))()]])
    makeSectionLabel("UTILITY COMBAT")
    makeScriptBtn("Anti Death Counter",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Anti-Death-Counter.lua"))()]])
    makeScriptBtn("Orbit Farm",        [[loadstring(game:httpGet("https://raw.githubusercontent.com/minhnhatdepzai8-cloud/FARM-KILL/refs/heads/main/TSB"))()]])
    makeScriptBtn("Farm Kill",         [[loadstring(game:HttpGet("https://raw.githubusercontent.com/minhnhatdepzai8-cloud/Farm-Kill-V2/refs/heads/main/TSB"))()]])
    makeScriptBtn("TouchFling",        [[loadstring(game:HttpGet("https://raw.githubusercontent.com/long191910/all-my-roblox-script/refs/heads/main/touchfling.lua"))()]])
end

-- ══════════════════════════════════════════
--   CONTENT LOADERS — FPS TAB
-- ══════════════════════════════════════════
local function LoadFPS_AntiLag()
    makeSectionLabel("ANTI LAG SCRIPTS")
    makeScriptBtn("CryoX Anti-Lag",        [[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/CryoX%20Anti-Lag.lua"))()]])
    makeScriptBtn("Blox Strap",            [[loadstring(game:HttpGet("https://raw.githubusercontent.com/qwertyui-is-back/Bloxstrap/main/Initiate.lua"))()]])
    makeScriptBtn("Turbo Lite",            [[loadstring(game:HttpGet("https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua"))()]])
    makeScriptBtn("Flags Smooth",          [[loadstring(game:HttpGet("https://raw.githubusercontent.com/ngoclinh02042011-stack/Flags-Smooth/refs/heads/main/Flags%20by%20ThanhDuy.lua"))()]])
    makeScriptBtn("Anti Lag Remove Effect",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/YQANTGV2/YQANTGV2/refs/heads/main/Protected_5743487458031851.lua.txt"))()]])
end
local function LoadFPS_HUD()
    makeSectionLabel("HUD SETTINGS")
    makeToggle("📊  Show FPS Counter",Settings.showFPS,function(v) Settings.showFPS=v; updateStatWidget(); saveSettings() end)
    makeToggle("📶  Show Ping",Settings.showPing,function(v) Settings.showPing=v; updateStatWidget(); saveSettings() end)
    makeToggle("👥  Show Player Count",Settings.showPlayers,function(v) Settings.showPlayers=v; updateStatWidget(); saveSettings() end)
    makeToggle("⚔️  Show Dash CD",Settings.showDashCD,function(v) Settings.showDashCD=v; updateStatWidget(); saveSettings() end)
    makeSectionLabel("PERFORMANCE INFO")
    makeScriptBtn("Ping and CPU",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/ngoclinh02042011-stack/Ping-All-Game/refs/heads/main/Ping%20Player.lua"))()]])
end

-- ══════════════════════════════════════════
--   CONTENT LOADERS — VISUAL TAB
-- ══════════════════════════════════════════
local function LoadVisual_Effects()
    makeSectionLabel("M1 EFFECTS")
    makeScriptBtn("M1 Effect [Red+Blue]",[[loadstring(game:HttpGet("https://raw.githubusercontent.com/ngoclinh02042011-stack/Fist-Blue-And-Red/refs/heads/main/HieuUngVuiNhon.lua"))()]])
    makeScriptBtn("Fake Animation",      [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Mautiku/ehh/main/strong%20guest.lua.txt"))()]])
    makeSectionLabel("AURA & ENERGY")
    makeScriptBtn("Curse Energy Aura",   [[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Curse%20energy%20effect%5Bsaitama%5D"))()]])
    makeSectionLabel("SHADER")
    makeScriptBtn("Custom Shader",       [[loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Simple-Shader-37434"))()]])
end
local function LoadVisual_Emote()
    makeSectionLabel("EMOTE SCRIPTS")
    makeScriptBtn("Divine Form",        [[loadstring(game:HttpGet("https://raw.githubusercontent.com/IdkRandomUsernameok/PublicAssets/refs/heads/main/Releases/MUI.lua"))()]])
    makeScriptBtn("MYKIO Limited Aura", [[loadstring(game:HttpGet("https://arch-http.vercel.app/files/LIMITED EMOTE HUB (75-100) BY MIYKO"))()]])
    makeScriptBtn("Basic Emote",        [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/EmoteGui/refs/heads/main/Protected_4900496055951847.lua"))()]])
    makeScriptBtn("Sukuna Emote",       [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Yourfavoriteguy/Sukunaslash/refs/heads/main/WorldCuttingSlash",true))()]])
    makeScriptBtn("MIUI",               [[loadstring(game:HttpGet("https://raw.githubusercontent.com/IdkRandomUsernameok/PublicAssets/refs/heads/main/Releases/MUI.lua"))()]])
end
local function LoadVisual_Accessories()
    makeSectionLabel("ACCESSORIES")
    makeScriptBtn("Oinan-Thickhoof-Axe",      [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Guestly-Scripts/Items-Scripts/refs/heads/main/Oinan-Thickhoof"))()]])
    makeScriptBtn("Erisyphia-Staff",           [[loadstring(game:HttpGet("https://raw.githubusercontent.com/GuestlyTheGreatestGuest/Scripts/refs/heads/main/Erisyphia-Staff-made-by-Guestly"))()]])
    makeScriptBtn("Elemental-Crystal-Golem",   [[loadstring(game:HttpGet("https://raw.githubusercontent.com/GuestlyTheGreatestGuest/Scripts/refs/heads/main/Elemental-Crystal-Golem-made-by-Guestly"))()]])
end

-- ══════════════════════════════════════════
--   CONTENT LOADERS — PLAYER TAB
-- ══════════════════════════════════════════
local function LoadPlayer_Stats()
    makeSectionLabel("CHARACTER STATS")
    makeSlider("🏃 Walkspeed",16,500,16,function(v)
        pcall(function()
            local char=LocalPlayer.Character; if not char then return end
            local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum.WalkSpeed=v end
        end)
    end)
    makeSlider("🦘 JumpPower",50,500,50,function(v)
        pcall(function()
            local char=LocalPlayer.Character; if not char then return end
            local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum.JumpPower=v end
        end)
    end)
    makeSectionLabel("ACTIONS")
    makeActionBtn("Hồi Máu Đầy","❤️",function()
        pcall(function()
            local char=LocalPlayer.Character; if not char then return end
            local hum=char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health=hum.MaxHealth end
        end)
        task.spawn(function() showToast("❤️  Đã hồi máu đầy!",C.GREEN,2) end)
    end)
    makeActionBtn("ForceField (Shield)","🛡️",function()
        pcall(function() Instance.new("ForceField",LocalPlayer.Character) end)
        task.spawn(function() showToast("🛡️  Shield đã bật!",C.CYAN,2) end)
    end)
    makeActionBtn("Respawn","🔁",function()
        LocalPlayer:LoadCharacter()
        task.spawn(function() showToast("🔁  Đã respawn!",C.CYAN,2) end)
    end)
end
local function LoadPlayer_Toggles()
    makeSectionLabel("MOVEMENT & UTILITY")
    makeToggle("👻  Noclip",false,function(v) toggleNoclip(v); task.spawn(function() showToast(v and "👻 Noclip BẬT" or "👻 Noclip TẮT",v and C.GREEN or C.RED,2) end) end)
    makeToggle("🤖  Anti-AFK",false,function(v) toggleAntiAFK(v); task.spawn(function() showToast(v and "🤖 Anti-AFK BẬT" or "🤖 Anti-AFK TẮT",v and C.GREEN or C.RED,2) end) end)
    makeSectionLabel("OTHER SCRIPTS")
    makeScriptBtn("Fly GuiV3",      [[loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()]])
    makeScriptBtn("Avatar Changer", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/darkdexv2/universalavatarchanger/main/avatarchanger"))()]])
    makeScriptBtn("Dex Explorer",   [[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Dex_Explorer_v2.lua"))()]])
    makeScriptBtn("Shield Script",  [[Instance.new("ForceField",game.Players.LocalPlayer.Character)]])
end

-- ══════════════════════════════════════════
--   CONTENT LOADERS — SETTING TAB
-- ══════════════════════════════════════════
local function LoadSetting_ESP()
    makeSectionLabel("ESP PLAYERS")
    makeToggle("🔵  ESP Người Chơi",false,function(v) toggleESP(v); task.spawn(function() showToast(v and "🔵 ESP BẬT" or "🔵 ESP TẮT",v and C.GREEN or C.RED,2) end) end)
    makeToggle("👥  ESP Friends",false,function(v) toggleFriendESP(v); task.spawn(function() showToast(v and "👥 Friend ESP BẬT" or "Friend ESP TẮT",v and C.GREEN or C.RED,2) end) end)
    makeSectionLabel("HITBOX")
    makeToggle("📦  Hitbox Expander",false,function(v) toggleHitbox(v); task.spawn(function() showToast(v and "📦 Hitbox BẬT" or "📦 Hitbox TẮT",v and C.GREEN or C.RED,2) end) end)
    makeSlider("📦 Hitbox Size",1,20,6,function(v)
        hitboxSize=v
        if hitboxEnabled then toggleHitbox(false); task.wait(0.1); toggleHitbox(true) end
    end)
    makeSectionLabel("SKILL DETECTOR")
    makeToggle("🔍  Skill Detector",Settings.showSkillDetector,function(v)
        Settings.showSkillDetector=v; updateStatWidget(); saveSettings()
        task.spawn(function() showToast(v and "🔍 Skill Detector BẬT!" or "🔍 Skill Detector TẮT!",v and C.GREEN or C.RED,2) end)
    end)
end

local ACCENT_THEMES={
    {"🔵 Cyan (Default)",Color3.fromRGB(0,210,255)},{"🟣 Purple",Color3.fromRGB(160,80,255)},
    {"🟢 Neon Green",Color3.fromRGB(50,255,120)},{"🔴 Red",Color3.fromRGB(255,60,60)},
    {"🟡 Gold",Color3.fromRGB(255,200,30)},{"🩷 Pink",Color3.fromRGB(255,100,200)},
    {"🟠 Orange",Color3.fromRGB(255,130,40)},{"⚪ White",Color3.fromRGB(220,230,255)},
    {"🩵 Sky",Color3.fromRGB(80,200,255)},{"🌿 Mint",Color3.fromRGB(80,255,180)},
    {"🫐 Indigo",Color3.fromRGB(120,60,255)},{"🌹 Rose",Color3.fromRGB(255,80,130)},
}
local function LoadSetting_Accent()
    makeSectionLabel("ACCENT COLOR")
    for _,theme in ipairs(ACCENT_THEMES) do
        local col=theme[2]
        local frame=Instance.new("Frame"); frame.Size=UDim2.new(1,0,0,32); frame.BackgroundColor3=C.PANEL2
        frame.BorderSizePixel=0; frame.ZIndex=7; frame.Parent=ContentFrame; corner(frame,8); stroke(frame,1.2,0.5)
        local dot=Instance.new("Frame"); dot.Size=UDim2.new(0,14,0,14); dot.Position=UDim2.new(0,8,0.5,-7)
        dot.BackgroundColor3=col; dot.BorderSizePixel=0; dot.ZIndex=8; dot.Parent=frame; corner(dot,999)
        local lbl2=Instance.new("TextLabel"); lbl2.Size=UDim2.new(0.68,0,1,0); lbl2.Position=UDim2.new(0,28,0,0)
        lbl2.BackgroundTransparency=1; lbl2.Text=theme[1]; lbl2.TextColor3=C.TEXT; lbl2.Font=Enum.Font.GothamBold
        lbl2.TextSize=11; lbl2.TextXAlignment=Enum.TextXAlignment.Left; lbl2.ZIndex=8; lbl2.Parent=frame
        local al=Instance.new("TextLabel"); al.Size=UDim2.new(0.28,0,1,0); al.Position=UDim2.new(0.70,0,0,0)
        al.BackgroundTransparency=1; al.Text="Chọn ▸"; al.TextColor3=C.CYAN; al.Font=Enum.Font.GothamBold
        al.TextSize=9; al.ZIndex=8; al.Parent=frame
        local tBtn=Instance.new("TextButton"); tBtn.Size=UDim2.new(1,0,1,0); tBtn.BackgroundTransparency=1
        tBtn.Text=""; tBtn.ZIndex=9; tBtn.Parent=frame
        tBtn.MouseButton1Click:Connect(function() applyAccentColor(col) end)
        tBtn.MouseEnter:Connect(function() tw(frame,{BackgroundColor3=Color3.fromRGB(0,38,68)},0.12) end)
        tBtn.MouseLeave:Connect(function() tw(frame,{BackgroundColor3=C.PANEL2},0.12) end)
    end
end

local function LoadSetting_Theme()
    makeSectionLabel("GUI THEMES")
    for _,theme in ipairs(THEMES_LIST) do
        local t=theme
        local frame=Instance.new("Frame"); frame.Size=UDim2.new(1,0,0,36); frame.BackgroundColor3=C.PANEL2
        frame.BorderSizePixel=0; frame.ZIndex=7; frame.Parent=ContentFrame; corner(frame,8); stroke(frame,1.2,0.5)
        -- preview boxes
        local p1=Instance.new("Frame"); p1.Size=UDim2.new(0,12,0,12); p1.Position=UDim2.new(0,6,0.5,-6)
        p1.BackgroundColor3=theme.bg; p1.BorderSizePixel=0; p1.ZIndex=8; p1.Parent=frame; corner(p1,3)
        local p2=Instance.new("Frame"); p2.Size=UDim2.new(0,12,0,12); p2.Position=UDim2.new(0,20,0.5,-6)
        p2.BackgroundColor3=theme.panel; p2.BorderSizePixel=0; p2.ZIndex=8; p2.Parent=frame; corner(p2,3)
        local p3=Instance.new("Frame"); p3.Size=UDim2.new(0,12,0,12); p3.Position=UDim2.new(0,34,0.5,-6)
        p3.BackgroundColor3=theme.panel2; p3.BorderSizePixel=0; p3.ZIndex=8; p3.Parent=frame; corner(p3,3)
        local lbl2=Instance.new("TextLabel"); lbl2.Size=UDim2.new(1,-100,1,0); lbl2.Position=UDim2.new(0,52,0,0)
        lbl2.BackgroundTransparency=1; lbl2.Text=theme.name; lbl2.TextColor3=C.TEXT; lbl2.Font=Enum.Font.GothamBold
        lbl2.TextSize=11; lbl2.TextXAlignment=Enum.TextXAlignment.Left; lbl2.ZIndex=8; lbl2.Parent=frame
        local al=Instance.new("TextLabel"); al.Size=UDim2.new(0,42,1,0); al.Position=UDim2.new(1,-44,0,0)
        al.BackgroundTransparency=1; al.Text="Apply ▸"; al.TextColor3=C.CYAN; al.Font=Enum.Font.GothamBold
        al.TextSize=9; al.ZIndex=8; al.Parent=frame
        local tBtn=Instance.new("TextButton"); tBtn.Size=UDim2.new(1,0,1,0); tBtn.BackgroundTransparency=1
        tBtn.Text=""; tBtn.ZIndex=9; tBtn.Parent=frame
        tBtn.MouseButton1Click:Connect(function() applyTheme(t) end)
        tBtn.MouseEnter:Connect(function() tw(frame,{BackgroundColor3=Color3.fromRGB(0,38,68)},0.12) end)
        tBtn.MouseLeave:Connect(function() tw(frame,{BackgroundColor3=C.PANEL2},0.12) end)
    end
    makeSectionLabel("DANGER ZONE")
    local delSave=Instance.new("TextButton"); delSave.Size=UDim2.new(1,0,0,30); delSave.Text="🗑  Xóa toàn bộ Save (Reset)"
    delSave.BackgroundColor3=Color3.fromRGB(60,12,12); delSave.TextColor3=C.RED; delSave.Font=Enum.Font.GothamBold
    delSave.TextSize=10; delSave.ZIndex=7; delSave.Parent=ContentFrame; corner(delSave,8); stroke(delSave,1.2,0.5)
    delSave.MouseButton1Click:Connect(function()
        SaveData=DEFAULT_SAVE; Favorites={}; writeSave(SaveData)
        task.spawn(function() showToast("🗑  Đã xóa save! Reload để áp dụng.",C.RED,3) end)
    end)
end

-- ══════════════════════════════════════════
--   CONTENT LOADERS — MAP TAB
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
local locationIcons={["Void"]="☠",["Arena"]="⚔",["Jail"]="🔒",["Bigger Jail"]="🔒",["Even Bigger Jail"]="🔒",
    ["Jail But Smaller"]="🔒",["Mountain 1"]="🏔",["Mountain 2"]="🏔",["Mountain Edge"]="🏔",
    ["Above Tunnel"]="🌐",["Middle"]="🎯",["Dark Domain"]="🌑",["Death Counter"]="💀",
    ["Atomic Slash"]="⚡",["Baseplate"]="🟦",["Below Baseplate"]="🟦"}
local function teleportTo(cf)
    local char=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp=char:WaitForChild("HumanoidRootPart")
    TweenService:Create(hrp,TweenInfo.new(0.5,Enum.EasingStyle.Quad),{CFrame=cf*CFrame.new(0,2,0)}):Play()
end
local function LoadMap()
    makeSectionLabel("TELEPORT LOCATIONS")
    for _,loc in ipairs(Locations) do
        local icon=locationIcons[loc.name] or "📍"; local capturedCF=loc.cf; local capturedName=loc.name
        local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,0,36); btn.Text=""
        btn.BackgroundColor3=C.PANEL2; btn.ZIndex=7; btn.Parent=ContentFrame; corner(btn,8); stroke(btn,1.2,0.5)
        local ic=Instance.new("TextLabel"); ic.Size=UDim2.new(0,28,1,0); ic.Position=UDim2.new(0,5,0,0)
        ic.BackgroundTransparency=1; ic.Text=icon; ic.TextColor3=C.CYAN; ic.Font=Enum.Font.GothamBold; ic.TextSize=14; ic.ZIndex=8; ic.Parent=btn
        local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,-90,1,0); nl.Position=UDim2.new(0,30,0,0)
        nl.BackgroundTransparency=1; nl.Text=capturedName; nl.TextColor3=C.TEXT; nl.Font=Enum.Font.GothamBold
        nl.TextSize=11; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.ZIndex=8; nl.Parent=btn
        local cl=Instance.new("TextLabel"); cl.Size=UDim2.new(0,80,1,0); cl.Position=UDim2.new(1,-82,0,0)
        cl.BackgroundTransparency=1; cl.Text=math.floor(capturedCF.X)..", "..math.floor(capturedCF.Y)
        cl.TextColor3=C.SUB; cl.Font=Enum.Font.Gotham; cl.TextSize=8; cl.TextXAlignment=Enum.TextXAlignment.Right; cl.ZIndex=8; cl.Parent=btn
        btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=Color3.fromRGB(0,38,68)},0.12); tw(nl,{TextColor3=C.CYAN},0.12) end)
        btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=C.PANEL2},0.12); tw(nl,{TextColor3=C.TEXT},0.12) end)
        btn.MouseButton1Click:Connect(function()
            tw(btn,{BackgroundColor3=Color3.fromRGB(0,65,100)},0.08); task.wait(0.1); tw(btn,{BackgroundColor3=C.PANEL2},0.18)
            teleportTo(capturedCF); task.spawn(function() showToast("📍  Teleport → "..capturedName,C.CYAN,2) end)
        end)
    end
end

-- ══════════════════════════════════════════
--   CONTENT LOADERS — SERVER TAB
-- ══════════════════════════════════════════
local function LoadServer()
    makeSectionLabel("SERVER HOP")
    makeActionBtn("Hop Server (Random)","🔀",function()
        local pid=game.PlaceId
        local ok,sv=pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..pid.."/servers/Public?sortOrder=Asc&limit=25")) end)
        if ok and sv and sv.data then
            local list={}; for _,s in ipairs(sv.data) do if s.id~=game.JobId and s.playing<s.maxPlayers then table.insert(list,s.id) end end
            if #list>0 then task.spawn(function() showToast("🔀  Đang hop...",C.CYAN,2) end); task.wait(1); TeleportService:TeleportToPlaceInstance(pid,list[math.random(1,#list)],LocalPlayer)
            else task.spawn(function() showToast("❌  Không tìm thấy server!",C.RED,3) end) end
        else task.spawn(function() showToast("❌  Lỗi server list!",C.RED,3) end) end
    end)
    makeActionBtn("Server Ít Người","👤",function()
        local pid=game.PlaceId
        local ok,sv=pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..pid.."/servers/Public?sortOrder=Asc&limit=25")) end)
        if ok and sv and sv.data and #sv.data>0 then
            local least,minP=nil,math.huge
            for _,s in ipairs(sv.data) do if s.id~=game.JobId and s.playing<minP then minP=s.playing; least=s.id end end
            if least then task.spawn(function() showToast("👤  Server: "..minP.." players",C.CYAN,2) end); task.wait(1); TeleportService:TeleportToPlaceInstance(pid,least,LocalPlayer)
            else task.spawn(function() showToast("❌  Không tìm thấy!",C.RED,3) end) end
        else task.spawn(function() showToast("❌  Lỗi!",C.RED,3) end) end
    end)
    makeActionBtn("Server Đông Người (≥10)","👥",function()
        local pid=game.PlaceId
        local ok,sv=pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..pid.."/servers/Public?sortOrder=Desc&limit=100")) end)
        if ok and sv and sv.data then
            local list={}; for _,s in ipairs(sv.data) do if s.id~=game.JobId and s.playing>=10 then table.insert(list,s) end end
            if #list>0 then
                table.sort(list,function(a,b) return a.playing>b.playing end)
                task.spawn(function() showToast("👥  Đông nhất: "..list[1].playing.." người",C.CYAN,3) end)
                task.wait(1.5); TeleportService:TeleportToPlaceInstance(pid,list[1].id,LocalPlayer)
            else task.spawn(function() showToast("❌  Không có server ≥10!",C.RED,3) end) end
        else task.spawn(function() showToast("❌  Lỗi!",C.RED,3) end) end
    end)
    makeSectionLabel("JOIN THEO SỐ NGƯỜI")
    local fF=Instance.new("Frame"); fF.Size=UDim2.new(1,0,0,42); fF.BackgroundColor3=C.PANEL2
    fF.BorderSizePixel=0; fF.ZIndex=7; fF.Parent=ContentFrame; corner(fF,8); stroke(fF,1.2,0.5)
    local fL=Instance.new("TextLabel"); fL.Size=UDim2.new(0.55,0,1,0); fL.Position=UDim2.new(0,10,0,0)
    fL.BackgroundTransparency=1; fL.Text="👥  Tối thiểu players:"; fL.TextColor3=C.TEXT
    fL.Font=Enum.Font.GothamBold; fL.TextSize=10; fL.TextXAlignment=Enum.TextXAlignment.Left; fL.ZIndex=8; fL.Parent=fF
    local minBox=Instance.new("TextBox"); minBox.Size=UDim2.new(0.2,0,0,26); minBox.Position=UDim2.new(0.56,0,0.5,-13)
    minBox.BackgroundColor3=C.BG; minBox.Text="10"; minBox.Font=Enum.Font.GothamBold; minBox.TextSize=12
    minBox.TextColor3=C.CYAN; minBox.ZIndex=9; minBox.Parent=fF; corner(minBox,6)
    local goBtn=Instance.new("TextButton"); goBtn.Size=UDim2.new(0.2,0,0,26); goBtn.Position=UDim2.new(0.78,0,0.5,-13)
    goBtn.BackgroundColor3=C.CYAN; goBtn.Text="JOIN"; goBtn.Font=Enum.Font.GothamBold; goBtn.TextSize=10
    goBtn.TextColor3=C.BG; goBtn.ZIndex=9; goBtn.Parent=fF; corner(goBtn,6)
    goBtn.MouseButton1Click:Connect(function()
        local minP=tonumber(minBox.Text) or 10; local pid=game.PlaceId
        local ok,sv=pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..pid.."/servers/Public?sortOrder=Desc&limit=100")) end)
        if ok and sv and sv.data then
            local list={}; for _,s in ipairs(sv.data) do if s.id~=game.JobId and s.playing>=minP then table.insert(list,s) end end
            if #list>0 then
                table.sort(list,function(a,b) return a.playing>b.playing end)
                task.spawn(function() showToast("👥  "..list[1].playing.." người\nĐang join...",C.CYAN,3) end)
                task.wait(1.5); TeleportService:TeleportToPlaceInstance(pid,list[1].id,LocalPlayer)
            else task.spawn(function() showToast("❌  Không có server ≥"..minP.."!",C.RED,3) end) end
        else task.spawn(function() showToast("❌  Lỗi!",C.RED,3) end) end
    end)
    makeActionBtn("Rejoin","🔄",function()
        task.spawn(function() showToast("🔄  Đang rejoin...",C.CYAN,2) end); task.wait(0.8)
        pcall(function() TeleportService:Teleport(game.PlaceId,LocalPlayer) end)
    end)
    makeActionBtn("Copy Server ID","📋",function()
        if setclipboard then setclipboard(game.JobId); task.spawn(function() showToast("📋  Đã copy Server ID!",C.GREEN,2) end)
        else task.spawn(function() showToast("❌  Không hỗ trợ clipboard!",C.RED,3) end) end
    end)
    makeSectionLabel("JOIN SERVER CỤ THỂ")
    local iF=Instance.new("Frame"); iF.Size=UDim2.new(1,0,0,36); iF.BackgroundColor3=C.PANEL2
    iF.BorderSizePixel=0; iF.ZIndex=7; iF.Parent=ContentFrame; corner(iF,8); stroke(iF,1.2,0.5)
    local sBox=Instance.new("TextBox"); sBox.Size=UDim2.new(0.72,0,1,-8); sBox.Position=UDim2.new(0,6,0,4)
    sBox.BackgroundColor3=C.BG; sBox.PlaceholderText="Nhập Server ID..."; sBox.Text=""
    sBox.Font=Enum.Font.Gotham; sBox.TextSize=10; sBox.TextColor3=C.TEXT; sBox.PlaceholderColor3=C.SUB; sBox.ZIndex=8; sBox.Parent=iF; corner(sBox,5)
    local jBtn=Instance.new("TextButton"); jBtn.Size=UDim2.new(0.25,0,1,-8); jBtn.Position=UDim2.new(0.74,0,0,4)
    jBtn.BackgroundColor3=C.CYAN; jBtn.Text="JOIN"; jBtn.Font=Enum.Font.GothamBold; jBtn.TextSize=10
    jBtn.TextColor3=C.BG; jBtn.ZIndex=8; jBtn.Parent=iF; corner(jBtn,5)
    jBtn.MouseButton1Click:Connect(function()
        local sid=sBox.Text
        if sid and #sid>5 then task.spawn(function() showToast("🚀  Đang join...",C.CYAN,2) end); task.wait(0.8)
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,sid,LocalPlayer) end)
        else task.spawn(function() showToast("❌  Server ID không hợp lệ!",C.RED,2) end) end
    end)
    makeSectionLabel("THÔNG TIN SERVER")
    local info=Instance.new("Frame"); info.Size=UDim2.new(1,0,0,58); info.BackgroundColor3=C.PANEL2
    info.BorderSizePixel=0; info.ZIndex=7; info.Parent=ContentFrame; corner(info,8); stroke(info,1.2,0.5)
    local gameName2="Unknown"; pcall(function() gameName2=game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
    local lines={"🎮  Game: "..gameName2,"🆔  ID: "..string.sub(game.JobId,1,22).."...","👥  Players: "..#Players:GetPlayers().."/"..(game.Players.MaxPlayers or "?")}
    for i,line in ipairs(lines) do
        local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-8,0,17); l.Position=UDim2.new(0,5,0,(i-1)*18+2)
        l.BackgroundTransparency=1; l.Text=line; l.TextColor3=C.SUB; l.Font=Enum.Font.Gotham
        l.TextSize=9; l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=8; l.Parent=info
    end
end

-- ══════════════════════════════════════════
--   CONTENT LOADERS — FAVORITES
-- ══════════════════════════════════════════
local function LoadFavorites()
    if #Favorites==0 then
        local empty=Instance.new("TextLabel"); empty.Size=UDim2.new(1,0,0,60); empty.BackgroundTransparency=1
        empty.Text="⭐  Chưa có script yêu thích\nNhấn ★ trên bất kỳ script nào để thêm"
        empty.TextColor3=C.SUB; empty.Font=Enum.Font.GothamBold; empty.TextSize=11
        empty.TextXAlignment=Enum.TextXAlignment.Center; empty.TextWrapped=true; empty.ZIndex=7; empty.Parent=ContentFrame
        return
    end
    makeSectionLabel("⭐ SCRIPTS YÊU THÍCH ("..#Favorites..")")
    for _,f in ipairs(Favorites) do makeScriptBtn(f.name,f.code) end
    local clearBtn=Instance.new("TextButton"); clearBtn.Size=UDim2.new(1,0,0,30); clearBtn.Text="🗑  Xóa tất cả Yêu Thích"
    clearBtn.BackgroundColor3=Color3.fromRGB(60,12,12); clearBtn.TextColor3=C.RED; clearBtn.Font=Enum.Font.GothamBold
    clearBtn.TextSize=10; clearBtn.ZIndex=7; clearBtn.Parent=ContentFrame; corner(clearBtn,8); stroke(clearBtn,1.2,0.5)
    clearBtn.MouseButton1Click:Connect(function()
        Favorites={}; saveFavorites()
        task.spawn(function() showToast("🗑  Đã xóa tất cả Yêu Thích",C.RED,2) end)
        clearContent(); LoadFavorites()
    end)
end

-- ══════════════════════════════════════════
--   CONTENT LOADERS — QUICK EXEC
-- ══════════════════════════════════════════
local function LoadQuickExec()
    makeSectionLabel("QUICK EXECUTE — Paste URL hoặc Code")
    local inputFrame=Instance.new("Frame"); inputFrame.Size=UDim2.new(1,0,0,90); inputFrame.BackgroundColor3=C.PANEL2
    inputFrame.BorderSizePixel=0; inputFrame.ZIndex=7; inputFrame.Parent=ContentFrame; corner(inputFrame,8); stroke(inputFrame,1.2,0.4)
    local codeBox=Instance.new("TextBox"); codeBox.Size=UDim2.new(1,-8,1,-8); codeBox.Position=UDim2.new(0,4,0,4)
    codeBox.BackgroundTransparency=1; codeBox.PlaceholderText="https://... hoặc lua code..."
    codeBox.Text=""; codeBox.Font=Enum.Font.Code; codeBox.TextSize=9; codeBox.TextColor3=C.TEXT
    codeBox.PlaceholderColor3=C.SUB; codeBox.MultiLine=true; codeBox.TextXAlignment=Enum.TextXAlignment.Left
    codeBox.TextYAlignment=Enum.TextYAlignment.Top; codeBox.ClearTextOnFocus=false; codeBox.ZIndex=8; codeBox.Parent=inputFrame
    local btnRow=Instance.new("Frame"); btnRow.Size=UDim2.new(1,0,0,34); btnRow.BackgroundTransparency=1
    btnRow.ZIndex=7; btnRow.Parent=ContentFrame
    local bL=Instance.new("UIListLayout"); bL.FillDirection=Enum.FillDirection.Horizontal; bL.Padding=UDim.new(0,5); bL.Parent=btnRow
    local runCode=Instance.new("TextButton"); runCode.Size=UDim2.new(0.48,0,1,0)
    runCode.BackgroundColor3=C.CYAN; runCode.Text="▶  RUN"; runCode.Font=Enum.Font.GothamBold; runCode.TextSize=12
    runCode.TextColor3=C.BG; runCode.ZIndex=8; runCode.Parent=btnRow; corner(runCode,8)
    runCode.MouseButton1Click:Connect(function()
        local input=codeBox.Text; if not input or #input<3 then task.spawn(function() showToast("❌  Chưa nhập gì!",C.RED,2) end); return end
        if input:sub(1,4)=="http" then
            local ok,code=pcall(function() return game:HttpGet(input) end)
            if ok and code then local f,e=loadstring(code); if f then task.spawn(f); task.spawn(function() showToast("✅  Đã chạy từ URL!",C.GREEN,2) end) else task.spawn(function() showToast("❌  Lỗi: "..(e or "?"),C.RED,3) end) end
            else task.spawn(function() showToast("❌  Không tải được URL!",C.RED,3) end) end
        else local f,e=loadstring(input); if f then task.spawn(f); task.spawn(function() showToast("✅  Đã chạy code!",C.GREEN,2) end) else task.spawn(function() showToast("❌  Lỗi: "..(e or "?"),C.RED,3) end) end end
    end)
    local clearCode=Instance.new("TextButton"); clearCode.Size=UDim2.new(0.48,0,1,0)
    clearCode.BackgroundColor3=C.PANEL2; clearCode.Text="🗑  CLEAR"; clearCode.Font=Enum.Font.GothamBold; clearCode.TextSize=12
    clearCode.TextColor3=C.SUB; clearCode.ZIndex=8; clearCode.Parent=btnRow; corner(clearCode,8); stroke(clearCode,1.2,0.5)
    clearCode.MouseButton1Click:Connect(function() codeBox.Text="" end)
    makeSectionLabel("QUICK URLs")
    local quickURLs={
        {"Inf Yield","https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
        {"Dex Explorer","https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Dex_Explorer_v2.lua"},
        {"SimpleAdmin","https://raw.githubusercontent.com/Tomi3gaming/SimpleAdmin/main/Source"},
    }
    for _,u in ipairs(quickURLs) do
        local capturedURL=u[2]; local capturedName=u[1]
        local qBtn=Instance.new("TextButton"); qBtn.Size=UDim2.new(1,0,0,30); qBtn.Text=""
        qBtn.BackgroundColor3=C.PANEL2; qBtn.ZIndex=7; qBtn.Parent=ContentFrame; corner(qBtn,7); stroke(qBtn,1.2,0.5)
        local ql=Instance.new("TextLabel"); ql.Size=UDim2.new(0.38,0,1,0); ql.Position=UDim2.new(0,8,0,0)
        ql.BackgroundTransparency=1; ql.Text=capturedName; ql.TextColor3=C.CYAN; ql.Font=Enum.Font.GothamBold; ql.TextSize=10; ql.TextXAlignment=Enum.TextXAlignment.Left; ql.ZIndex=8; ql.Parent=qBtn
        local qu=Instance.new("TextLabel"); qu.Size=UDim2.new(0.58,0,1,0); qu.Position=UDim2.new(0.38,0,0,0)
        qu.BackgroundTransparency=1; qu.Text=capturedURL:sub(1,42).."..."; qu.TextColor3=C.SUB; qu.Font=Enum.Font.Code; qu.TextSize=7; qu.TextXAlignment=Enum.TextXAlignment.Left; qu.ZIndex=8; qu.Parent=qBtn
        qBtn.MouseButton1Click:Connect(function() codeBox.Text=capturedURL; task.spawn(function() showToast("📋  Đã điền: "..capturedName,C.CYAN,2) end) end)
    end
end

-- ══════════════════════════════════════════
--   THEME PICKER POPUP (nút bên dưới col2)
-- ══════════════════════════════════════════
local themePickerOpen=false
local ThemePopup=Instance.new("Frame")
ThemePopup.Size=UDim2.new(0,RIGHT_W+MID_W,0,220)
ThemePopup.Position=UDim2.new(0,MID_W+PAD,1,-225)
ThemePopup.BackgroundColor3=C.PANEL; ThemePopup.BorderSizePixel=0; ThemePopup.ZIndex=30
ThemePopup.Visible=false; ThemePopup.Parent=Root; corner(ThemePopup,10); stroke(ThemePopup,1.5,0.1)
local TpTitle=Instance.new("TextLabel"); TpTitle.Size=UDim2.new(1,-8,0,20); TpTitle.Position=UDim2.new(0,8,0,4)
TpTitle.BackgroundTransparency=1; TpTitle.Text="🎨  Chọn Theme GUI"; TpTitle.TextColor3=C.CYAN
TpTitle.Font=Enum.Font.GothamBold; TpTitle.TextSize=11; TpTitle.TextXAlignment=Enum.TextXAlignment.Left; TpTitle.ZIndex=31; TpTitle.Parent=ThemePopup
local TpDiv=Instance.new("Frame"); TpDiv.Size=UDim2.new(1,-10,0,1); TpDiv.Position=UDim2.new(0,5,0,26)
TpDiv.BackgroundColor3=C.CYAN; TpDiv.BackgroundTransparency=0.5; TpDiv.BorderSizePixel=0; TpDiv.ZIndex=31; TpDiv.Parent=ThemePopup
local TpScroll=Instance.new("ScrollingFrame"); TpScroll.Size=UDim2.new(1,-6,0,182); TpScroll.Position=UDim2.new(0,3,0,30)
TpScroll.BackgroundTransparency=1; TpScroll.BorderSizePixel=0; TpScroll.ScrollBarThickness=3
TpScroll.ScrollBarImageColor3=C.CYAN; TpScroll.CanvasSize=UDim2.new(0,0,0,0)
TpScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; TpScroll.ZIndex=31; TpScroll.Parent=ThemePopup
local TpLayout=Instance.new("UIListLayout"); TpLayout.Padding=UDim.new(0,4); TpLayout.Parent=TpScroll
local TpPad=Instance.new("UIPadding"); TpPad.PaddingTop=UDim.new(0,3); TpPad.PaddingBottom=UDim.new(0,3)
TpPad.PaddingLeft=UDim.new(0,2); TpPad.PaddingRight=UDim.new(0,2); TpPad.Parent=TpScroll

-- Build theme buttons in popup
for _,theme in ipairs(THEMES_LIST) do
    local t=theme
    local row=Instance.new("Frame"); row.Size=UDim2.new(1,-4,0,28); row.BackgroundColor3=C.PANEL2
    row.BorderSizePixel=0; row.ZIndex=32; row.Parent=TpScroll; corner(row,6); stroke(row,1,0.5)
    local p1=Instance.new("Frame"); p1.Size=UDim2.new(0,10,0,10); p1.Position=UDim2.new(0,5,0.5,-5)
    p1.BackgroundColor3=theme.bg; p1.BorderSizePixel=0; p1.ZIndex=33; p1.Parent=row; corner(p1,3)
    local p2=Instance.new("Frame"); p2.Size=UDim2.new(0,10,0,10); p2.Position=UDim2.new(0,17,0.5,-5)
    p2.BackgroundColor3=theme.panel; p2.BorderSizePixel=0; p2.ZIndex=33; p2.Parent=row; corner(p2,3)
    local p3=Instance.new("Frame"); p3.Size=UDim2.new(0,10,0,10); p3.Position=UDim2.new(0,29,0.5,-5)
    p3.BackgroundColor3=theme.panel2; p3.BorderSizePixel=0; p3.ZIndex=33; p3.Parent=row; corner(p3,3)
    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-56,1,0); lbl.Position=UDim2.new(0,44,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=theme.name; lbl.TextColor3=C.TEXT; lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=10; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=33; lbl.Parent=row
    local tBtn=Instance.new("TextButton"); tBtn.Size=UDim2.new(1,0,1,0); tBtn.BackgroundTransparency=1
    tBtn.Text=""; tBtn.ZIndex=34; tBtn.Parent=row
    tBtn.MouseButton1Click:Connect(function()
        applyTheme(t)
        themePickerOpen=false; tw(ThemePopup,{Position=UDim2.new(0,MID_W+PAD,1,10)},0.2)
        task.delay(0.22,function() ThemePopup.Visible=false end)
    end)
    tBtn.MouseEnter:Connect(function() tw(row,{BackgroundColor3=Color3.fromRGB(0,38,68)},0.1) end)
    tBtn.MouseLeave:Connect(function() tw(row,{BackgroundColor3=C.PANEL2},0.1) end)
end

ThemePickerBtn.MouseButton1Click:Connect(function()
    if not themePickerOpen then
        themePickerOpen=true
        ThemePopup.Visible=true; ThemePopup.Position=UDim2.new(0,MID_W+PAD,1,10)
        tw(ThemePopup,{Position=UDim2.new(0,MID_W+PAD,1,-225)},0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    else
        themePickerOpen=false
        tw(ThemePopup,{Position=UDim2.new(0,MID_W+PAD,1,10)},0.2)
        task.delay(0.22,function() ThemePopup.Visible=false end)
    end
end)

-- ══════════════════════════════════════════
--   MAIN TAB DEFINITIONS (restructured)
-- ══════════════════════════════════════════
local mainTabDefs={
    {name="COMBAT", icon="⚔️", subs={
        {name="Tech",    load=LoadCombat_Tech},
        {name="Dash",    load=LoadCombat_Dash},
        {name="Moveset", load=LoadCombat_Moveset},
    }},
    {name="FPS",    icon="📊", subs={
        {name="Anti-Lag", load=LoadFPS_AntiLag},
        {name="HUD",      load=LoadFPS_HUD},
    }},
    {name="VISUAL", icon="👁️", subs={
        {name="Effects",   load=LoadVisual_Effects},
        {name="Emote",     load=LoadVisual_Emote},
        {name="Access",    load=LoadVisual_Accessories},
    }},
    {name="PLAYER", icon="👤", subs={
        {name="Stats",   load=LoadPlayer_Stats},
        {name="Toggles", load=LoadPlayer_Toggles},
    }},
    {name="MAP",    icon="🗺️", subs={
        {name="Teleport", load=LoadMap},
    }},
    {name="SERVER", icon="🖥️", subs={
        {name="Server", load=LoadServer},
        {name="Exec",   load=LoadQuickExec},
    }},
    {name="SETTING",icon="⚙️", subs={
        {name="ESP",    load=LoadSetting_ESP},
        {name="Accent", load=LoadSetting_Accent},
        {name="Theme",  load=LoadSetting_Theme},
    }},
    {name="FAV",    icon="⭐", subs={
        {name="Yêu Thích", load=LoadFavorites},
    }},
}

local mainBtns={}
for i,td in ipairs(mainTabDefs) do
    local mb=Instance.new("TextButton")
    mb.Size=UDim2.new(1,0,0,34)
    mb.BackgroundColor3=C.PANEL2; mb.ZIndex=5; mb.Parent=MidInner
    mb.Font=Enum.Font.GothamBold; mb.TextSize=9; mb.TextColor3=C.SUB
    mb.Text=td.icon.."  "..td.name
    corner(mb,7); stroke(mb,1.2,0.6)
    mb.MouseEnter:Connect(function() if activeMainTab~=mb then tw(mb,{BackgroundColor3=Color3.fromRGB(0,26,50)},0.12) end end)
    mb.MouseLeave:Connect(function() if activeMainTab~=mb then tw(mb,{BackgroundColor3=C.PANEL2},0.12) end end)
    local subDef=td.subs; local idx=i
    mb.MouseButton1Click:Connect(function()
        -- close theme popup if open
        if themePickerOpen then
            themePickerOpen=false
            tw(ThemePopup,{Position=UDim2.new(0,MID_W+PAD,1,10)},0.2)
            task.delay(0.22,function() ThemePopup.Visible=false end)
        end
        setMainActive(mb,idx,nil)
        buildSubTabs(subDef)
    end)
    mainBtns[i]=mb
end

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
    task.spawn(function()
        task.wait(0.3)
        setMainActive(mainBtns[1],1,nil)
        buildSubTabs(mainTabDefs[1].subs)
    end)
    task.spawn(function() task.wait(1); showToast("✅  CryoXHUB v5.3 mở khóa! 🎉",C.GREEN,3) end)
end

KeySubmit.MouseButton1Click:Connect(function()
    if KeyInput.Text==KEY_CHINH_XAC then saveKeyTime(); unlockGUI()
    else
        KeyInput.Text=""; KeyStatus.Text="❌  Sai Key!"; KeyStatus.TextColor3=C.RED
        local orig=KeyInput.Position
        for i=1,5 do tw(KeyInput,{Position=orig+UDim2.new(0,i%2==0 and 7 or -7,0,0)},0.04); task.wait(0.045) end
        tw(KeyInput,{Position=orig},0.07); task.delay(1.5,function() KeyStatus.Text="" end)
    end
end)

if keyVerified then task.spawn(function() task.wait(0.5); unlockGUI() end) end

-- ══════════════════════════════════════════
--   CLOSE / OPEN
-- ══════════════════════════════════════════
CloseBtn.MouseButton1Click:Connect(function()
    if themePickerOpen then themePickerOpen=false; ThemePopup.Visible=false end
    animateClose(function()
        OpenBtn.Visible=true; OpenBtn.Size=UDim2.new(0,26,0,26)
        tw(OpenBtn,{Size=UDim2.new(0,46,0,46)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    end)
end)
OpenBtn.MouseButton1Click:Connect(function() OpenBtn.Visible=false; animateOpen() end)

-- ══════════════════════════════════════════
--   FPS / PING / PLAYERS LOOP
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

-- 30 phút toast
task.spawn(function()
    while true do
        task.wait(1800)
        local msgs={
            "💙  Cảm ơn bạn đã dùng CryoXHUB v5.3!\nChúc bạn chơi vui vẻ~",
            "✨  CryoXHUB v5.3  —  Cảm ơn vì sự tin tưởng!",
            "🌊  Thử tab COMBAT — Tech, Dash, Moveset! 💙",
            "⚙️  Tab SETTING có ESP, Hitbox, Theme, Accent!",
        }
        task.spawn(function() showToast(msgs[math.random(1,#msgs)],C.CYAN,5) end)
    end
end)

-- ══════════════════════════════════════════
--   STARTUP
-- ══════════════════════════════════════════
task.wait(0.25)
animateOpen()
