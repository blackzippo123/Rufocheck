--[[
    RUFOCHECK v3.0 - BLOX STRIKE EDITION
    Özellikler: Smart ESP (Mor Düşmanlar), Force Hitbox, Dynamic Distance
    Oyun: Blox Strike (Roblox)
    Tuş: Sol ALT (Left Alt)
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
        Text = true,      -- İsim/Can/Mesafe
        Charms = true,    -- Vücut Parlatma
        SmartColor = true -- Takım rengi kontrolü
    },
    Hitbox = {
        Enabled = true,
        Size = 5,         -- SABİT BOYUT 5
        Transparency = 0.7,
        TeamCheck = true  -- Sadece rakiplerin kafasını büyüt
    },
    Colors = {
        Enemy = Color3.fromRGB(140, 0, 255),   -- KOYU MOR (İstediğin Renk)
        Team = Color3.fromRGB(0, 255, 100),    -- YEŞİL
    }
}

-- UI OLUŞTURMA (MODERN BLUE/BLACK)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RufocheckBloxStrike"
if pcall(function() ScreenGui.Parent = CoreGui end) then else ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 230, 0, 280)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = Settings.MenuOpen

-- Başlık
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBlack
Title.Text = "RUFOCHECK: BLOX STRIKE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

-- Scroll
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 0, 0, 35)
Container.Size = UDim2.new(1, 0, 1, -35)
Container.ScrollBarThickness = 3

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Buton Fonksiyonu
local function CreateButton(text, category, setting)
    local Btn = Instance.new("TextButton")
    Btn.Parent = Container
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Btn.BorderColor3 = Color3.fromRGB(60, 60, 60)
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = text .. ": AÇIK"
    Btn.TextColor3 = Color3.fromRGB(0, 255, 100)
    Btn.TextSize = 13

    if not Settings[category][setting] then
        Btn.Text = text .. ": KAPALI"
        Btn.TextColor3 = Color3.fromRGB(255, 50, 50)
    end

    Btn.MouseButton1Click:Connect(function()
        Settings[category][setting] = not Settings[category][setting]
        if Settings[category][setting] then
            Btn.Text = text .. ": AÇIK"
            Btn.TextColor3 = Color3.fromRGB(0, 255, 100)
        else
            Btn.Text = text .. ": KAPALI"
            Btn.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end)
end

CreateButton("ESP Aktif", "ESP", "Enabled")
CreateButton("Charms (Parlaklık)", "ESP", "Charms")
CreateButton("Kutu (Box)", "ESP", "Box")
CreateButton("Bilgi (İsim/Can)", "ESP", "Text")
local Spacer = Instance.new("Frame", Container); Spacer.Size = UDim2.new(1,0,0,10); Spacer.BackgroundTransparency = 1
CreateButton("Hitbox (Kafa: 5)", "Hitbox", "Enabled")

-- Menü Tuşu
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        Settings.MenuOpen = not Settings.MenuOpen
        MainFrame.Visible = Settings.MenuOpen
    end
end)

--------------------------------------------------------------------------------
-- BLOX STRIKE ÖZEL MANTIK
--------------------------------------------------------------------------------

local function GetColor(player)
    -- Takım Rengi Kontrolü
    if player.Team == LocalPlayer.Team then
        return Settings.Colors.Team -- Yeşil
    else
        return Settings.Colors.Enemy -- Koyu Mor
    end
end

-- ESP GÜNCELLEME (RENDER LOOP)
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")

            if head and root and hum and hum.Health > 0 then
                local color = GetColor(player)
                
                -- ============================
                -- 1. ESP KISMI
                -- ============================
                if Settings.ESP.Enabled then
                    -- Highlight (Charms)
                    local hl = char:FindFirstChild("RufoCharms")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "RufoCharms"
                        hl.Parent = char
                    end
                    
                    if Settings.ESP.Charms then
                        hl.Enabled = true
                        hl.FillColor = color
                        hl.OutlineColor = Color3.new(1,1,1)
                        hl.FillTransparency = 0.5
                    else
                        hl.Enabled = false
                    end

                    -- Text & Box (Billboard)
                    local bg = root:FindFirstChild("RufoInfo")
                    if not bg then
                        bg = Instance.new("BillboardGui")
                        bg.Name = "RufoInfo"
                        bg.Adornee = root
                        bg.Size = UDim2.new(0, 200, 0, 50)
                        bg.StudsOffset = Vector3.new(0, 3.5, 0)
                        bg.AlwaysOnTop = true
                        bg.Parent = root
                        
                        local lbl = Instance.new("TextLabel")
                        lbl.Name = "Label"
                        lbl.Parent = bg
                        lbl.BackgroundTransparency = 1
                        lbl.Size = UDim2.new(1,0,1,0)
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextSize = 13
                        lbl.TextStrokeTransparency = 0
                    end

                    local txtLabel = bg:FindFirstChild("Label")
                    if Settings.ESP.Text then
                        -- MESAFE HESAPLAMA (HER KAREDE YENİDEN)
                        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local dist = 0
                        if myRoot then
                            dist = math.floor((myRoot.Position - root.Position).Magnitude)
                        end

                        txtLabel.Visible = true
                        txtLabel.TextColor3 = color
                        txtLabel.Text = string.format("%s\nHP: %d | Dist: %dm", player.Name, math.floor(hum.Health), dist)
                        
                        -- Box Çerçevesi
                        if Settings.ESP.Box then
                            txtLabel.BorderSizePixel = 1
                            txtLabel.BorderColor3 = color
                        else
                            txtLabel.BorderSizePixel = 0
                        end
                    else
                        txtLabel.Visible = false
                    end
                else
                    -- ESP Kapalıysa temizle
                    if char:FindFirstChild("RufoCharms") then char.RufoCharms:Destroy() end
                    if root:FindFirstChild("RufoInfo") then root.RufoInfo:Destroy() end
                end

                -- ============================
                -- 2. HITBOX (BIG HEAD) KISMI
                -- ============================
                if Settings.Hitbox.Enabled then
                    local isEnemy = (player.Team ~= LocalPlayer.Team)
                    
                    -- Sadece düşmanlara veya herkese uygulama ayarı
                    if isEnemy then
                        -- Blox Strike bazen kafayı resetler, bu yüzden her karede kontrol edip boyutu zorluyoruz
                        if head.Size.X ~= Settings.Hitbox.Size then
                            head.Size = Vector3.new(Settings.Hitbox.Size, Settings.Hitbox.Size, Settings.Hitbox.Size)
                            head.Transparency = Settings.Hitbox.Transparency
                            head.CanCollide = false
                        end
                    else
                        -- Takım arkadaşıysa normal bırak
                        if head.Size.X == Settings.Hitbox.Size then
                            head.Size = Vector3.new(1.2, 1.2, 1.2) -- Standart boyut
                            head.Transparency = 0
                            head.CanCollide = true
                        end
                    end
                else
                    -- Özellik kapalıysa herkesi normale döndür
                    if head.Size.X == Settings.Hitbox.Size then
                        head.Size = Vector3.new(1.2, 1.2, 1.2)
                        head.Transparency = 0
                        head.CanCollide = true
                    end
                end
            end
        end
    end
end)

-- Bildirim
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Rufocheck v3.0";
    Text = "Blox Strike Modu Yüklendi! (Mor Düşmanlar)";
    Duration = 5;
})
