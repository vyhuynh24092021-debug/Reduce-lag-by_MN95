--// CryoX Multi Game Loader V2 (FIXED)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

--// SERVICES
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

--// SAFE HTTP
local function httpget(url)
    if syn and syn.request then
        return syn.request({Url = url, Method = "GET"}).Body
    elseif http_request then
        return http_request({Url = url, Method = "GET"}).Body
    elseif request then
        return request({Url = url, Method = "GET"}).Body
    elseif game.HttpGet then
        return game:HttpGet(url)
    else
        error("Exploit không hỗ trợ HTTP")
    end
end

--// TOAST
local function showToast(msg, color, duration)
    local gui = Instance.new("ScreenGui")
    gui.Name = "CryoX_Toast"
    gui.ResetOnSpawn = false

    pcall(function()
        gui.Parent = CoreGui
    end)

    if not gui.Parent then
        gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 54)
    frame.Position = UDim2.new(0.5, -150, 1, 80)
    frame.BackgroundColor3 = Color3.fromRGB(5, 15, 30)
    frame.BorderSizePixel = 0

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local text = Instance.new("TextLabel", frame)
    text.Size = UDim2.new(1, -16, 1, 0)
    text.Position = UDim2.new(0, 12, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = msg
    text.TextColor3 = Color3.fromRGB(220, 240, 255)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 13
    text.TextWrapped = true

    TweenService:Create(frame, TweenInfo.new(0.3), {
        Position = UDim2.new(0.5, -150, 1, -70)
    }):Play()

    task.wait(duration or 2)

    TweenService:Create(frame, TweenInfo.new(0.3), {
        Position = UDim2.new(0.5, -150, 1, 80)
    }):Play()

    task.wait(0.4)
    gui:Destroy()
end

--// MAIN
local id = game.PlaceId

showToast("🔍 Đang nhận diện game...", Color3.fromRGB(0,170,255), 2)

if id == 116495829188952 then
    showToast("🚂 Dead Rails detected...", Color3.fromRGB(0,255,170), 2)

    local ok, err = pcall(function()
        loadstring(httpget("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/main/CryoXDeadRail.lua"))()
    end)

    if not ok then
        warn(err)
        showToast("❌ Load fail!", Color3.fromRGB(255,80,80), 3)
    end

elseif id == 10449761463 then
    showToast("⚔️ TSB detected...", Color3.fromRGB(255,170,0), 2)

    local ok, err = pcall(function()
        loadstring(httpget("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/main/CryoXHUB%5BV4.1%5D.Lua"))()
    end)

    if not ok then
        warn(err)
        showToast("❌ Load fail!", Color3.fromRGB(255,80,80), 3)
    end

else
    showToast("❌ Game không hỗ trợ!", Color3.fromRGB(255,80,80), 3)
end
