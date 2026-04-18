local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CryoX_Furina_Final_v4"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- ID ẢNH & BIẾN HỆ THỐNG
local ID_ANH_NEN = "rbxthumb://type=Asset&id=116367849760314&w=420&h=420"
local ID_LOGO_DONG = "rbxthumb://type=Asset&id=135753950157111&w=420&h=420"
local ID_ANH_NEN_SIDE = "rbxthumb://type=Asset&id=124781052988441&w=420&h=420"
local ID_ANH_NEN_EXTRA = "rbxthumb://type=Asset&id=104695209222974&w=420&h=420"
local KEY_CHINH_XAC = "CryoXHUB"

local TechUnlocked = false
local ScriptUnlocked = false
local CurrentKeyTarget = ""

local function ApplyCyanButtonStyle(btn, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 12)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Color = Color3.fromRGB(0, 255, 255)
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = btn
end

-- KHUNG CHÍNH
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 280)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local BackgroundImg = Instance.new("ImageLabel")
BackgroundImg.Size = UDim2.new(1, 0, 1, 0)
BackgroundImg.BackgroundTransparency = 1
BackgroundImg.Image = ID_ANH_NEN
BackgroundImg.ImageTransparency = 0.15
BackgroundImg.ZIndex = 1
BackgroundImg.Parent = MainFrame

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2.5
MainStroke.Color = Color3.fromRGB(0, 255, 255)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0, 100, 0, 35)
TitleText.Position = UDim2.new(0, 15, 0, 10)
TitleText.BackgroundTransparency = 1
TitleText.ZIndex = 2
TitleText.Text = "CryoX HUB"
TitleText.TextColor3 = Color3.fromRGB(0, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = MainFrame

-- PHẦN ĐÃ FIX: CHUYỂN THÀNH SCROLLINGFRAME ĐỂ KÉO NGANG
local TabFrame = Instance.new("ScrollingFrame")
TabFrame.Size = UDim2.new(0, 355, 0, 42) -- Giới hạn khung nhìn 355px
TabFrame.Position = UDim2.new(0, 125, 0, 5)
TabFrame.BackgroundTransparency = 1
TabFrame.BorderSizePixel = 0
TabFrame.ZIndex = 2
TabFrame.ScrollBarThickness = 0 -- Ẩn thanh cuộn để đẹp hơn
TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.X -- Tự động dài vùng chứa để kéo
TabFrame.ScrollingDirection = Enum.ScrollingDirection.X -- Chỉ cho phép kéo ngang
TabFrame.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.Padding = UDim.new(0, 8)
TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabListLayout.Parent = TabFrame

-- Thêm khoảng đệm để nút không sát mép
local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingLeft = UDim.new(0, 5)
TabPadding.PaddingRight = UDim.new(0, 10)
TabPadding.Parent = TabFrame

local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, -30, 0, 2)
TopLine.Position = UDim2.new(0, 15, 0, 48)
TopLine.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
TopLine.BackgroundTransparency = 0.3
TopLine.ZIndex = 2
TopLine.Parent = MainFrame

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -30, 1, -75)
ContentFrame.Position = UDim2.new(0, 15, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ZIndex = 2
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.ScrollBarThickness = 2
ContentFrame.Parent = MainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Parent = ContentFrame
contentLayout.Padding = UDim.new(0, 10)

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(1, -30, 1, -75)
KeyFrame.Position = UDim2.new(0, 15, 0, 60)
KeyFrame.BackgroundTransparency = 1
KeyFrame.ZIndex = 5
KeyFrame.Visible = false
KeyFrame.Parent = MainFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 220, 0, 40)
KeyInput.Position = UDim2.new(0.5, -110, 0.2, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.PlaceholderText = "Nhập Key tại đây..."
KeyInput.Text = ""
KeyInput.Font = Enum.Font.GothamBold
KeyInput.TextSize = 14
KeyInput.TextColor3 = Color3.new(0,0,0)
KeyInput.Parent = KeyFrame
ApplyCyanButtonStyle(KeyInput, 10)

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0, 100, 0, 35)
SubmitBtn.Position = UDim2.new(0.5, -50, 0.5, 0)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Text = "XÁC NHẬN"
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 13
SubmitBtn.TextColor3 = Color3.new(0,0,0)
SubmitBtn.Parent = KeyFrame
ApplyCyanButtonStyle(SubmitBtn, 10)

local function clearContent()
	for _, v in pairs(ContentFrame:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
end

local function createScriptBtn(name, code)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 42)
	btn.Text = "  " .. name
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.ZIndex = 3
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = ContentFrame
	ApplyCyanButtonStyle(btn, 12)

	btn.MouseButton1Click:Connect(function()
		local func, err = loadstring(code)
        if func then task.spawn(func) else warn(err) end
	end)
end

local function createTabBtn(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 80, 0, 30) -- Kích thước tab đồng nhất
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.TextXAlignment = Enum.TextXAlignment.Center
	btn.TextYAlignment = Enum.TextYAlignment.Center
	btn.ZIndex = 3
	btn.Parent = TabFrame
	ApplyCyanButtonStyle(btn, 12)
	return btn
end



-- TAB FPS
local function LoadFPSContent()
	KeyFrame.Visible = false
	ContentFrame.Visible = true
	clearContent()
	createScriptBtn("CryoX Anti-Lag", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/CryoX%20Anti-Lag.lua"))()]])
end

local FPSBtn = createTabBtn("FPS")
FPSBtn.MouseButton1Click:Connect(LoadFPSContent)

-- TAB TECH
local function LoadTechContent()
	clearContent()
	createScriptBtn("Supa Tech", [[loadstring(game:HttpGet("https://rawscripts.net/raw/The-Strongest-Battlegrounds-Supa-tech-v2-77454"))()]])
	createScriptBtn("Kiba Tech", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/yqantg-pixel/Find/refs/heads/main/Protected_1593573630798166.lua.txt"))()]])
	createScriptBtn("Oreo Tech", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/OreoTech/refs/heads/main/Protected_6856895483929371.lua"))()]])
	createScriptBtn("Lethal Dash", [[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/57a4d240a2440f0450986c966469092ccfb8d4797392cb8f469fa8b6e605e64d/download"))()]])
	createScriptBtn("Back dash cancel", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/dinhthanhtuankiet1762009-sudo/Js/refs/heads/main/4418648b0e9b71ef.lua"))()]])
	createScriptBtn("Instant twised v2", [[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/60a7a7c77395006ebd63fce0a17c13241f932bd414c9aba3158b716da00ade01/download"))()]])
	createScriptBtn("loop dash", [[loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/28513f51c0ca2c03d4d7d94f59215d13ce1a2a470bf187f0a685b58ccb4dae98/download"))()]])
end

local TechBtn = createTabBtn("TECH")
TechBtn.MouseButton1Click:Connect(function()
	if TechUnlocked then
		KeyFrame.Visible = false
		ContentFrame.Visible = true
		LoadTechContent()
	else
		CurrentKeyTarget = "TECH"
		ContentFrame.Visible = false
		KeyFrame.Visible = true
	end
end)

-- TAB SHADER
local ShaderBtn = createTabBtn("SHADER")
ShaderBtn.MouseButton1Click:Connect(function()
	KeyFrame.Visible = false
	ContentFrame.Visible = true
	clearContent()
	createScriptBtn("Custom Shader", [[loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Simple-Shader-37434"))()]])
end)

-- TAB SCRIPT
local ScriptBtn = createTabBtn("SCRIPT")
ScriptBtn.MouseButton1Click:Connect(function()
	if ScriptUnlocked then
		KeyFrame.Visible = false
		ContentFrame.Visible = true
		clearContent()

		createScriptBtn("Fly GuiV3", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()]])
		createScriptBtn("Anti Death Counter", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Anti-Death-Counter.lua"))()]])
		createScriptBtn("Avatar Changer", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/darkdexv2/universalavatarchanger/main/avatarchanger"))()]])
		createScriptBtn("Dex", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/Dex_Explorer_v2.lua"))()]])
		createScriptBtn("Shield", [[Instance.new("ForceField", game.Players.LocalPlayer.Character)]])
		createScriptBtn("TouchFling", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/long191910/all-my-roblox-script/refs/heads/main/touchfling.lua"))()]])
	else
		CurrentKeyTarget = "SCRIPT"
		ContentFrame.Visible = false
		KeyFrame.Visible = true
	end
end)

SubmitBtn.MouseButton1Click:Connect(function()
	if KeyInput.Text == KEY_CHINH_XAC then
		if CurrentKeyTarget == "TECH" then
			TechUnlocked = true
			LoadTechContent()
		elseif CurrentKeyTarget == "SCRIPT" then
			ScriptUnlocked = true
		end
		KeyFrame.Visible = false
		ContentFrame.Visible = true
	else
		KeyInput.Text = ""
		KeyInput.PlaceholderText = "SAI KEY RỒI!"
		task.wait(1)
		KeyInput.PlaceholderText = "Nhập Key tại đây..."
	end
end)

local OpenButton = Instance.new("ImageButton")
OpenButton.Size = UDim2.new(0, 55, 0, 55)
OpenButton.Position = UDim2.new(0, 15, 0.5, -27)
OpenButton.Image = ID_LOGO_DONG
OpenButton.BackgroundTransparency = 1
OpenButton.Visible = false
OpenButton.Draggable = true
OpenButton.Parent = ScreenGui
ApplyCyanButtonStyle(OpenButton, 999)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "×"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.ZIndex = 5
CloseBtn.Parent = MainFrame
ApplyCyanButtonStyle(CloseBtn, 15)

-- TAB AURA
local function LoadAuraContent()
    KeyFrame.Visible = false
    ContentFrame.Visible = true
    clearContent()
    -- Bạn có thể thêm các script Aura vào đây
    createScriptBtn("Blue Flame Aura", [[loadstring(game:HttpGet("Link_Script_Aura_Tai_Day"))()]])
    createScriptBtn("Ultra Instinct Aura", [[loadstring(game:HttpGet("Link_Script_Aura_2"))()]])
end

local AuraBtn = createTabBtn("AURA")
AuraBtn.MouseButton1Click:Connect(LoadAuraContent)

-- TAB MOVESET
local function LoadMovesetContent()
    KeyFrame.Visible = false
    ContentFrame.Visible = true
    clearContent()
    -- Bạn có thể thêm các script Moveset vào đây
    createScriptBtn("KAR[SAITAMA]", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/OfficialAposty/RBLX-Scripts/refs/heads/main/UltimateLifeForm.lua"))()]])
    createScriptBtn("Gojo[SAITAMA]", [[getgenv().morph = false
loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/BaldyToSorcerer/refs/heads/main/LatestV2.lua"))()]])
	createScriptBtn("CHARA[SAITAMA]", [[loadstring(game:HttpGet("https://pastefy.app/gFRaeMGz/raw"))()]])
end

local MovesetBtn = createTabBtn("MOVESET")
MovesetBtn.MouseButton1Click:Connect(LoadMovesetContent)


-- ===== SIDE UI + PANEL DƯỚI =====
local RunService = game:GetService("RunService")

local SideToggleBtn = Instance.new("TextButton")
SideToggleBtn.Name = "SideToggleBtn"
SideToggleBtn.Text = ">"
SideToggleBtn.Size = UDim2.new(0, 26, 0, 26)
SideToggleBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
SideToggleBtn.TextColor3 = Color3.fromRGB(0,0,0)
SideToggleBtn.Font = Enum.Font.GothamBold
SideToggleBtn.TextSize = 18
SideToggleBtn.ZIndex = 2
SideToggleBtn.Visible = true
SideToggleBtn.Parent = ScreenGui
ApplyCyanButtonStyle(SideToggleBtn, 13)

local SideFrame = Instance.new("Frame")
SideFrame.Name = "SideFrame"
SideFrame.Size = UDim2.new(0, 220, 0, 120)
SideFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
SideFrame.BackgroundTransparency = 0.1
SideFrame.Visible = false
SideFrame.ZIndex = 2
SideFrame.Parent = ScreenGui

local SideStroke = Instance.new("UIStroke", SideFrame)
SideStroke.Thickness = 2.5
SideStroke.Color = Color3.fromRGB(0, 255, 255)
SideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local SideBg = Instance.new("ImageLabel")
SideBg.Size = UDim2.new(1, 0, 1, 0)
SideBg.BackgroundTransparency = 1
SideBg.Image = ID_ANH_NEN_SIDE
SideBg.ImageTransparency = 0.15
SideBg.ZIndex = 2
SideBg.Parent = SideFrame

local BottomHolder = Instance.new("Frame")
BottomHolder.Size = UDim2.new(1, 0, 0, 40)
BottomHolder.Position = UDim2.new(0, 0, 1, -40)
BottomHolder.BackgroundTransparency = 1
BottomHolder.ZIndex = 2
BottomHolder.Parent = SideFrame

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 6)
layout.Parent = BottomHolder

local function createSideBtn(text, parent)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 36, 0, 26)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.ZIndex = 21
	btn.Parent = parent
	ApplyCyanButtonStyle(btn, 6)
	return btn
end

createSideBtn("L", BottomHolder)
createSideBtn("Loop", BottomHolder)
createSideBtn("pause", BottomHolder)
createSideBtn("N", BottomHolder)
createSideBtn("R", BottomHolder)

-- GUI THỨ 3 Ở BÊN DƯỚI
local ExtraFrame = Instance.new("Frame")
ExtraFrame.Name = "ExtraFrame"
ExtraFrame.Size = UDim2.new(0, 220, 0, 160)
ExtraFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ExtraFrame.BackgroundTransparency = 0.1
ExtraFrame.Visible = false
ExtraFrame.ZIndex = 1
ExtraFrame.Parent = ScreenGui

local ExtraStroke = Instance.new("UIStroke", ExtraFrame)
ExtraStroke.Thickness = 2.5
ExtraStroke.Color = Color3.fromRGB(0, 255, 255)
ExtraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local ExtraBg = Instance.new("ImageLabel")
ExtraBg.Size = UDim2.new(1, 0, 1, 0)
ExtraBg.BackgroundTransparency = 1
ExtraBg.Image = ID_ANH_NEN_EXTRA
ExtraBg.ImageTransparency = 0.15
ExtraBg.ZIndex = 2
ExtraBg.Parent = ExtraFrame

local ExtraHolder = Instance.new("ScrollingFrame")
ExtraHolder.Size = UDim2.new(1, -10, 1, -10)
ExtraHolder.Position = UDim2.new(0, 5, 0, 5)
ExtraHolder.BackgroundTransparency = 1
ExtraHolder.BorderSizePixel = 0
ExtraHolder.ScrollBarThickness = 2
ExtraHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
ExtraHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
ExtraHolder.ZIndex = 19
ExtraHolder.Parent = ExtraFrame

local ExtraLayout = Instance.new("UIListLayout")
ExtraLayout.FillDirection = Enum.FillDirection.Vertical
ExtraLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ExtraLayout.VerticalAlignment = Enum.VerticalAlignment.Top
ExtraLayout.Padding = UDim.new(0, 4)
ExtraLayout.Parent = ExtraHolder

local function createAbcBtn(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 28)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.ZIndex = 20
	btn.Parent = ExtraHolder
	ApplyCyanButtonStyle(btn, 6)
	return btn
end

createAbcBtn("It going down now")
createAbcBtn("Monster[yoasobi]")
createAbcBtn("overthink")
createAbcBtn("dimension")
createAbcBtn("everytime we touch")
createAbcBtn("into the night")
createAbcBtn("sphere[creo]")
createAbcBtn("love machine[ft teto]")
createAbcBtn("at the speed of light")

local sideOpen = false

local function closeAllSidePanels()
	sideOpen = false
	SideFrame.Visible = false
	ExtraFrame.Visible = false
	SideToggleBtn.Text = ">"
end

local function updateUI()
	if not MainFrame.Visible then
		SideToggleBtn.Visible = false
		SideFrame.Visible = false
		ExtraFrame.Visible = false
		return
	end

	SideToggleBtn.Visible = true

	local baseX = MainFrame.AbsolutePosition.X + MainFrame.AbsoluteSize.X + 5
	local baseY = MainFrame.AbsolutePosition.Y

	if sideOpen then
		SideFrame.Visible = true
		ExtraFrame.Visible = true

		SideFrame.Position = UDim2.fromOffset(baseX, baseY)
		ExtraFrame.Position = UDim2.fromOffset(baseX, baseY + 120)

		SideToggleBtn.Text = "<"
		SideToggleBtn.Position = UDim2.fromOffset(baseX + 220 - 26, baseY)
	else
		SideFrame.Visible = false
		ExtraFrame.Visible = false

		SideToggleBtn.Text = ">"
		SideToggleBtn.Position = UDim2.fromOffset(baseX, baseY)
	end
end

CloseBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	OpenButton.Visible = true
	closeAllSidePanels()
	SideToggleBtn.Visible = false
end)

OpenButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	OpenButton.Visible = false
	SideToggleBtn.Visible = true
	updateUI()
end)

SideToggleBtn.MouseButton1Click:Connect(function()
	if not MainFrame.Visible then
		return
	end
	sideOpen = not sideOpen
	updateUI()
end)

RunService.RenderStepped:Connect(updateUI)
updateUI()

-- Mở tab FPS mặc định
LoadFPSContent()
