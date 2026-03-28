local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CryoX_Furina_Final_v4"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- ID ẢNH & BIẾN HỆ THỐNG
local ID_ANH_NEN = "rbxthumb://type=Asset&id=116367849760314&w=420&h=420"
local ID_LOGO_DONG = "rbxthumb://type=Asset&id=135753950157111&w=420&h=420"
local KEY_CHINH_XAC = "CryoXHUB"

local TechUnlocked = false
local ScriptUnlocked = false
local CurrentKeyTarget = "" 

-- KHUNG CHÍNH
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 280)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local BackgroundImg = Instance.new("ImageLabel")
BackgroundImg.Size = UDim2.new(1, 0, 1, 0)
BackgroundImg.BackgroundTransparency = 1
BackgroundImg.Image = ID_ANH_NEN
BackgroundImg.ImageTransparency = 0.4
BackgroundImg.ZIndex = 1
BackgroundImg.Parent = MainFrame
Instance.new("UICorner", BackgroundImg).CornerRadius = UDim.new(0, 15)

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

local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(0, 350, 0, 35)
TabFrame.Position = UDim2.new(0, 125, 0, 10)
TabFrame.BackgroundTransparency = 1
TabFrame.ZIndex = 2
TabFrame.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.Padding = UDim.new(0, 8)
TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabListLayout.Parent = TabFrame

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

Instance.new("UIListLayout", ContentFrame).Padding = UDim.new(0, 10)

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
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0, 100, 0, 35)
SubmitBtn.Position = UDim2.new(0.5, -50, 0.5, 0)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Text = "XÁC NHẬN"
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 13
SubmitBtn.TextColor3 = Color3.new(0,0,0)
SubmitBtn.Parent = KeyFrame
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", SubmitBtn).Color = Color3.fromRGB(0, 200, 200)

local function clearContent()
    for _, v in pairs(ContentFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
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
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    local s = Instance.new("UIStroke", btn)
    s.Color = Color3.fromRGB(0, 200, 200)
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    btn.MouseButton1Click:Connect(function() task.spawn(loadstring(code)) end)
end

local function createTabBtn(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 75, 0, 30) 
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Center
    btn.TextYAlignment = Enum.TextYAlignment.Center
    btn.ZIndex = 3
    btn.Parent = TabFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    local s = Instance.new("UIStroke", btn)
    s.Color = Color3.fromRGB(0, 200, 200)
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return btn
end

-- TAB FPS
local FPSBtn = createTabBtn("FPS")
FPSBtn.MouseButton1Click:Connect(function()
    KeyFrame.Visible = false
    ContentFrame.Visible = true
    clearContent()
    createScriptBtn("CryoX Anti-Lag", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/refs/heads/main/CryoX%20Anti-Lag.lua"))()]])
end)

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

-- TAB SKY
local SkyBtn = createTabBtn("SKY")
SkyBtn.MouseButton1Click:Connect(function()
    KeyFrame.Visible = false
    ContentFrame.Visible = true
    clearContent()
    
    -- Hàm dọn dẹp cực mạnh (Xóa mọi thứ gây tối và mây)
    local function cleanAll()
        local L = game:GetService("Lighting")
        for _, v in pairs(L:GetChildren()) do
            if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") then
                v:Destroy()
            end
        end
        local clouds = game.Workspace.Terrain:FindFirstChildOfClass("Clouds")
        if clouds then clouds:Destroy() end
    end

    -- GALAXY NIGHT
    createScriptBtn("Galaxy Night", [[
        local L = game:GetService("Lighting")
        for _, v in pairs(L:GetChildren()) do if v:IsA("Sky") then v:Destroy() end end
        
        local s = Instance.new("Sky", L)
        s.SkyboxBk = "rbxassetid://570357514"
        s.SkyboxDn = "rbxassetid://570357521"
        s.SkyboxFt = "rbxassetid://570357508"
        s.SkyboxLf = "rbxassetid://570357525"
        s.SkyboxRt = "rbxassetid://570357512"
        s.SkyboxUp = "rbxassetid://570357501"
        
        L.ClockTime = 0
        L.Brightness = 2
        L.ExposureCompensation = 1
        L.Ambient = Color3.fromRGB(50, 50, 50)
    ]])

    -- AURORA NIGHT (BẢN FIX CUỐI CÙNG - ÉP THAY ĐỔI)
    createScriptBtn("Aurora Night", [[
        local L = game:GetService("Lighting")
        
        -- Xóa Sky cũ
        for _, v in pairs(L:GetChildren()) do if v:IsA("Sky") then v:Destroy() end end
        
        local s = Instance.new("Sky", L)
        s.Name = "Aurora_New"
        
        -- Dùng định dạng rbxassetid trực tiếp với ID của bạn
        s.SkyboxUp = "rbxassetid://126802361950769"
        s.SkyboxRt = "rbxassetid://114054873360114"
        s.SkyboxLf = "rbxassetid://113636521190162"
        s.SkyboxFt = "rbxassetid://93720219915142"
        s.SkyboxDn = "rbxassetid://125031880295948"
        s.SkyboxBk = "rbxassetid://88145295302782"
        
        -- ÉP THAY ĐỔI LIGHTING ĐỂ THẤY KHÁC BIỆT MÀU SẮC
        L.ClockTime = 0
        L.Brightness = 3
        L.ExposureCompensation = 1.5
        L.OutdoorAmbient = Color3.fromRGB(0, 255, 150) -- Ép màu xanh Aurora vào môi trường
        L.Ambient = Color3.fromRGB(0, 50, 50)
        
        -- Vòng lặp xóa mây và giữ Sky này ưu tiên
        task.spawn(function()
            for i = 1, 10 do
                local clouds = game.Workspace.Terrain:FindFirstChildOfClass("Clouds")
                if clouds then clouds.Enabled = false end
                task.wait(0.5)
            end
        end)
        
        print("Đã ép chạy Aurora Night!")
    ]])

    -- RESET DEFAULT SKY (FIX LỖI TỐI)
    createScriptBtn("Reset Default Sky", [[
        local L = game:GetService("Lighting")
        for _, v in pairs(L:GetChildren()) do
            if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") or v:IsA("ColorCorrectionEffect") then
                v:Destroy()
            end
        end
        
        -- Thông số mặc định chuẩn của Roblox (Không bao giờ tối)
        L.ClockTime = 14
        L.Brightness = 2
        L.ExposureCompensation = 0
        L.Ambient = Color3.fromRGB(127, 127, 127)
        L.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        L.GlobalShadows = true
        
        local defaultSky = Instance.new("Sky", L)
        print("Đã Reset sạch sẽ!")
    ]])
end)


-- TAB SCRIPT
local ScriptBtn = createTabBtn("SCRIPT")
ScriptBtn.MouseButton1Click:Connect(function()
    if ScriptUnlocked then
        KeyFrame.Visible = false
        ContentFrame.Visible = true
        clearContent()
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
            clearContent()
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
Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1, 0)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "×"; CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.ZIndex = 5
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenButton.Visible = true end)
OpenButton.MouseButton1Click:Connect(function() MainFrame.Visible = true; OpenButton.Visible = false end)

FPSBtn.MouseButton1Click:Fire()
