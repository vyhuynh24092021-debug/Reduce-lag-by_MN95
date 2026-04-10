-- ===== LOAD YTB MUSIC PLAYER =====
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-YouTube-Music-Player-72222"))()

-- ===== CONFIG =====
local MY_GUI_NAME = "CryoX_Furina_Final_v4"

-- ===== FUNCTION CHECK YTB GUI =====
local function isYTBGui(gui)
    for _,v in pairs(gui:GetDescendants()) do
        if v:IsA("TextLabel") then
            local t = v.Text:lower()
            if t:find("youtube") or t:find("music") then
                return true
            end
        end
    end
    return false
end

-- ===== MAIN OVERRIDE FUNCTION =====
local function fixYTB()
    for _,gui in pairs(game.CoreGui:GetChildren()) do
        
        -- ❌ BỎ QUA GUI CỦA BẠN
        if gui.Name ~= MY_GUI_NAME then
            
            -- ✅ CHỈ XỬ LÝ YTB
            if isYTBGui(gui) then
                
                for _,v in pairs(gui:GetDescendants()) do
                    
                    -- ===== TEXT =====
                    if v:IsA("TextLabel") or v:IsA("TextButton") then
                        
                        local text = v.Text
                        
                        -- đổi tên
                        if text:lower():find("youtube") then
                            v.Text = "CryoXMusic"
                        end
                        
                        -- giữ credit bạn
                        if text:lower():find("termux") then
                            v.Text = "By CryoX"
                        end
                        
                        -- chữ dịu
                        v.TextColor3 = Color3.fromRGB(40,40,40)
                    end
                    
                    -- ===== BUTTON =====
                    if v:IsA("TextButton") then
                        v.BackgroundColor3 = Color3.fromRGB(255,255,255)
                        
                        if not v:FindFirstChild("UIStroke") then
                            local s = Instance.new("UIStroke")
                            s.Color = Color3.fromRGB(0,255,255)
                            s.Thickness = 2
                            s.Parent = v
                        end
                    end
                    
                    -- ===== IMAGE BUTTON =====
                    if v:IsA("ImageButton") then
                        v.BackgroundColor3 = Color3.fromRGB(255,255,255)
                        
                        if not v:FindFirstChild("UIStroke") then
                            local s = Instance.new("UIStroke")
                            s.Color = Color3.fromRGB(0,255,255)
                            s.Thickness = 2
                            s.Parent = v
                        end
                    end
                    
                    -- ===== FRAME =====
                    if v:IsA("Frame") then
                        v.BackgroundColor3 = Color3.fromRGB(245,245,245)
                    end
                    
                    -- ===== XÓA BACKGROUND YTB =====
                    if v:IsA("ImageLabel") then
                        if v.Size.X.Scale == 1 and v.Size.Y.Scale == 1 then
                            v.ImageTransparency = 1
                        end
                    end
                    
                end
            end
        end
    end
end

-- ===== LOOP ANTI RESET =====
while true do
    task.wait(1)
    pcall(fixYTB)
end
