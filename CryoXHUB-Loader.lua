--// CryoX Multi Game Loader V2 (Professional Edition)

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
        return syn.request({
            Url = url,
            Method = "GET"
        }).Body

    elseif http_request then
        return http_request({
            Url = url,
            Method = "GET"
        }).Body

    elseif request then
        return request({
            Url = url,
            Method = "GET"
        }).Body

    elseif game.HttpGet then
        return game:HttpGet(url)

    else
        error("Executor không hỗ trợ HTTP Request.")
    end
end

--// UI TOAST
local function showToast(message, state, duration)
    duration = duration or 2

    local gui = Instance.new("ScreenGui")
    gui.Name = "CryoXNotification"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true

    pcall(function()
        gui.Parent = CoreGui
    end)

    if not gui.Parent then
        gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local colors = {
        info = Color3.fromRGB(0, 170, 255),
        success = Color3.fromRGB(0, 200, 120),
        error = Color3.fromRGB(255, 70, 70),
        warning = Color3.fromRGB(255, 170, 0)
    }

    local frame = Instance.new("Frame")
    frame.Parent = gui
    frame.AnchorPoint = Vector2.new(0.5, 1)
    frame.Position = UDim2.new(0.5, 0, 1, 80)
    frame.Size = UDim2.new(0, 340, 0, 56)
    frame.BackgroundColor3 = Color3.fromRGB(12, 18, 28)
    frame.BorderSizePixel = 0

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke")
    stroke.Parent = frame
    stroke.Color = colors[state] or colors.info
    stroke.Thickness = 1.2
    stroke.Transparency = 0.15

    local accent = Instance.new("Frame")
    accent.Parent = frame
    accent.Size = UDim2.new(0, 4, 1, 0)
    accent.BackgroundColor3 = colors[state] or colors.info
    accent.BorderSizePixel = 0

    Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 16, 0, 8)
    title.Size = UDim2.new(1, -20, 0, 18)
    title.Font = Enum.Font.GothamBold
    title.Text = "CryoX Loader"
    title.TextColor3 = Color3.fromRGB(240, 245, 255)
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left

    local text = Instance.new("TextLabel")
    text.Parent = frame
    text.BackgroundTransparency = 1
    text.Position = UDim2.new(0, 16, 0, 24)
    text.Size = UDim2.new(1, -24, 0, 22)
    text.Font = Enum.Font.Gotham
    text.Text = message
    text.TextColor3 = Color3.fromRGB(200, 210, 225)
    text.TextSize = 12
    text.TextWrapped = true
    text.TextXAlignment = Enum.TextXAlignment.Left

    TweenService:Create(
        frame,
        TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {
            Position = UDim2.new(0.5, 0, 1, -28)
        }
    ):Play()

    task.wait(duration)

    TweenService:Create(
        frame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        {
            Position = UDim2.new(0.5, 0, 1, 80),
            BackgroundTransparency = 1
        }
    ):Play()

    task.wait(0.35)
    gui:Destroy()
end

--// GAME DETECTION
local PlaceId = game.PlaceId

showToast("Detecting current game...", "info", 1.8)

if PlaceId == 116495829188952 then

    showToast("Dead Rails script initialized.", "success", 2)

    local success, result = pcall(function()
        loadstring(httpget("https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/main/CryoXDeadRail.lua"
        ))()
    end)

    if not success then
        warn(result)
        showToast("Failed to load Dead Rails module.", "error", 3)
    end

elseif PlaceId == 10449761463 then

    showToast("The Strongest Battlegrounds detected.", "warning", 2)

    local success, result = pcall(function()
        loadstring(httpget(
            "https://raw.githubusercontent.com/vyhuynh24092021-debug/Reduce-lag-by_MN95/main/CryoXHUB%5BV4.1%5D.Lua"
        ))()
    end)

    if not success then
        warn(result)
        showToast("Failed to load TSB module.", "error", 3)
    end

else

    showToast("This game is currently unsupported.", "error", 3)

end
