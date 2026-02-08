--[[
    RUFOCHECK MOD MENU v1.1 (Sabit Hitbox)
    Özellikler: Gelişmiş ESP & Hitbox (Otomatik Boyut 5)
    Tasarım: Siyah/Mavi Tema
    Aç/Kapat: Sol ALT (Left Alt)
    Hazırlayan: Gemini
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- AYARLAR
local Settings = {
    MenuOpen = true,
    ESP = {
        Enabled = true,
        Box = true,
        Name = true,
        Health = true,
        Distance = true,
        Chams = true
    },
    Hitbox = {
        Enabled = true,
        Size = 5, -- SABİT BOYUT 5
        Transparency = 0.6,
        TeamCheck = false
    }
}

-- UI OLUŞTURMA (MODERN BLUE/BLACK THEME)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RufocheckGUI"
pcall(function() ScreenGui.Parent = CoreGui end)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Siyah Arka Plan
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255) -- Mavi Çizgi
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 320) -- Boyut biraz küçültüldü (Slider kalktı)
MainFrame.Active = true
MainFrame.Draggable = true 

-- Başlık
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "RUFOCHECK"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

-- Kapatma Bilgisi
local Info = Instance.new("TextLabel")
Info.Parent = MainFrame
Info.BackgroundTransparency = 1
Info.Position = UDim2.new(0, 0, 1, -20)
Info.Size = UDim2.new(1, 0, 0, 20)
Info.Font = Enum.Font.SourceSans
Info.Text = "Menü: Sol ALT"
Info.TextColor3 = Color3.fromRGB(150, 150, 150)
Info.TextSize = 14

-- Scroll Frame
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 0, 0, 35)
Container.Size = UDim2.new(1, 0, 1, -60)
Container.ScrollBarThickness = 2

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- UI BUTON FONKSİYONU
local function CreateToggle(text, category, settingName)
    local Button = Instance.new("TextButton")
    Button.Parent = Container
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.BorderColor3 = Color3.fromRGB(0, 170, 255)
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, -10, 0, 30)
    Button.Font = Enum.Font.Gotham
    Button.Text = text .. ": AÇIK"
    Button.TextColor3 = Color3.fromRGB(0, 255, 0)
    Button.TextSize = 14
    
    -- Başlangıç durum kontrolü
    if not Settings[category][settingName] then
        Button.Text = text .. ": KAPALI"
        Button.TextColor3 = Color3.fromRGB(255, 0, 0)
    end

    Button.MouseButton1Click:Connect(function()
        Settings[category][settingName] = not Settings[category][settingName]
        if Settings[category][settingName] then
            Button.Text = text .. ": AÇIK"
            Button.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            Button.Text = text .. ": KAPALI"
            Button.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    end)
end

-- MENU ELEMANLARI
CreateToggle("ESP Genel", "ESP", "Enabled")
CreateToggle("Kutu (Box)", "ESP", "Box")
CreateToggle("İsimler", "ESP", "Name")
CreateToggle("Can (HP)", "ESP", "Health")
CreateToggle("Chams (Parlaklık)", "ESP", "Chams")
-- Boşluk bırakmak için görünmez frame
local Spacer = Instance.new("Frame")
Spacer.Parent = Container
Spacer.BackgroundTransparency = 1
Spacer.Size = UDim2.new(1, 0, 0, 10)

CreateToggle("Hitbox (Kafa: 5)", "Hitbox", "Enabled") -- Sabit 5 olduğu belirtildi
CreateToggle("Takım Kontrolü", "Hitbox", "TeamCheck")

-- TUŞ ATAMASI (LEFT ALT)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.LeftAlt then 
        Settings.MenuOpen = not Settings.MenuOpen
        MainFrame.Visible = Settings.MenuOpen
    end
end)

-------------------------------------------------------------------------
-- ESP SISTEMI
-------------------------------------------------------------------------
local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local char = player.Character
            local hrp = char.HumanoidRootPart
            local hum = char:FindFirstChild("Humanoid")

            -- Temizlik
            local existingHighlight = char:FindFirstChild("RufoHighlight")
            local existingGui = hrp:FindFirstChild("RufoGui")

            if Settings.ESP.Enabled then
                -- 1. CHAMS
                if Settings.ESP.Chams then
                    if not existingHighlight then
                        local hl = Instance.new("Highlight")
                        hl.Name = "RufoHighlight"
                        hl.FillColor = Color3.fromRGB(0, 170, 255)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.FillTransparency = 0.5
                        hl.Parent = char
                    end
                else
                    if existingHighlight then existingHighlight:Destroy() end
                end

                -- 2. GUI
                if not existingGui then
                    local bgui = Instance.new("BillboardGui")
                    bgui.Name = "RufoGui"
                    bgui.Adornee = hrp
                    bgui.Size = UDim2.new(0, 200, 0, 50)
                    bgui.StudsOffset = Vector3.new(0, 3, 0)
                    bgui.AlwaysOnTop = true
                    bgui.Parent = hrp

                    local txt = Instance.new("TextLabel")
                    txt.Name = "InfoText"
                    txt.BackgroundTransparency = 1
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
                    txt.TextStrokeTransparency = 0
                    txt.Font = Enum.Font.SourceSansBold
                    txt.TextSize = 14
                    txt.Parent = bgui
                end

                local gui = hrp:FindFirstChild("RufoGui")
                if gui then
                    local label = gui.InfoText
                    local content = ""
                    
                    if Settings.ESP.Name then content = content .. player.Name .. "\n" end
                    if Settings.ESP.Health and hum then content = content .. "HP: " .. math.floor(hum.Health) .. " " end
                    if Settings.ESP.Distance then 
                        local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                        content = content .. "[" .. dist .. "m]"
                    end
                    label.Text = content
                    
                    if Settings.ESP.Box then
                        label.BorderSizePixel = 1
                        label.BorderColor3 = Color3.fromRGB(0, 170, 255)
                    else
                        label.BorderSizePixel = 0
                    end
                end
            else
                if existingHighlight then existingHighlight:Destroy() end
                if existingGui then existingGui:Destroy() end
            end
        end
    end
end

-------------------------------------------------------------------------
-- HITBOX EXPANDER (SABİT BOYUT 5)
-------------------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    UpdateESP() -- ESP Döngüsü

    if not Settings.Hitbox.Enabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChild("Humanoid")

            if head and hum and hum.Health > 0 then
                local isTeammate = (player.Team == LocalPlayer.Team)
                
                -- Takım Kontrolü AÇIKSA ve oyuncu TAKIM ARKADAŞIYSA: Büyütme yapma
                if Settings.Hitbox.TeamCheck and isTeammate then
                    -- Normal bırak (veya sıfırla)
                    head.Size = Vector3.new(1.2, 1.2, 1.2)
                    head.Transparency = 0
                    head.CanCollide = true
                else
                    -- RAKİP: Kafayı 5 yap
                    head.Size = Vector3.new(5, 5, 5) -- SABİT BOYUT BURADA
                    head.Transparency = Settings.Hitbox.Transparency
                    head.CanCollide = false
                end
            end
        end
    end
end)

print("Rufocheck v1.1 Aktif! Hitbox: Sabit 5")
