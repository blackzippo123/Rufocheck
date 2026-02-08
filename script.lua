--[[
    RUFOCHECK MOD MENU v2.0 (Smart Fix)
    Özellikler: Smart ESP (Team Color), Charms, Auto Hitbox (Fixed)
    Tuş: Sol ALT (Left Alt)
    Hazırlayan: Gemini
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- AYARLAR
local Settings = {
    MenuOpen = true,
    ESP = {
        Enabled = true,
        Box = true,
        Text = true,      -- İsim, Can, Mesafe hepsi burada
        Charms = true,    -- Vücut Boyama (Highlight)
        SmartColor = true -- Düşman Kırmızı, Dost Yeşil
    },
    Hitbox = {
        Enabled = true,
        Size = 5,         -- SABİT BOYUT
        Transparency = 0.7
    },
    Colors = {
        Enemy = Color3.fromRGB(255, 40, 40),   -- Kırmızı
        Team = Color3.fromRGB(40, 255, 40),    -- Yeşil
        Neutral = Color3.fromRGB(255, 255, 255) -- Beyaz (Takımsız)
    }
}

-- UI OLUŞTURMA (MODERN BLUE/BLACK)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RufocheckV2"
-- Güvenli GUI Parent (CoreGui yoksa PlayerGui)
if pcall(function() ScreenGui.Parent = CoreGui end) then
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderColor3 = Color3.fromRGB(0, 160, 255) -- Neon Mavi
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = Settings.MenuOpen

-- Başlık
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.GothamBlack
Title.Text = "RUFOCHECK v2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

local Info = Instance.new("TextLabel")
Info.Parent = MainFrame
Info.BackgroundTransparency = 1
Info.Position = UDim2.new(0, 0, 1, -25)
Info.Size = UDim2.new(1, 0, 0, 25)
Info.Font = Enum.Font.Gotham
Info.Text = "Gizle/Göster: Sol ALT"
Info.TextColor3 = Color3.fromRGB(180, 180, 180)
Info.TextSize = 12

-- Scroll
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 0, 0, 40)
Container.Size = UDim2.new(1, 0, 1, -70)
Container.ScrollBarThickness = 3

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

-- UI Buton Fonksiyonu
local function CreateButton(text, category, setting)
    local Btn = Instance.new("TextButton")
    Btn.Parent = Container
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Btn.BorderColor3 = Color3.fromRGB(60, 60, 60)
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = text .. ": AÇIK"
    Btn.TextColor3 = Color3.fromRGB(0, 255, 100) -- Yeşil
    Btn.TextSize = 14

    if not Settings[category][setting] then
        Btn.Text = text .. ": KAPALI"
        Btn.TextColor3 = Color3.fromRGB(255, 50, 50) -- Kırmızı
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

CreateButton("ESP Master", "ESP", "Enabled")
CreateButton("Smart Charms", "ESP", "Charms")
CreateButton("Box (Kutu)", "ESP", "Box")
CreateButton("Bilgi (HP/İsim)", "ESP", "Text")
local Spacer = Instance.new("Frame", Container) -- Boşluk
Spacer.Size = UDim2.new(1,0,0,10)
Spacer.BackgroundTransparency = 1
CreateButton("Big Head (Hitbox)", "Hitbox", "Enabled")

-- Menü Tuşu
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        Settings.MenuOpen = not Settings.MenuOpen
        MainFrame.Visible = Settings.MenuOpen
    end
end)

--------------------------------------------------------------------------------
-- YARDIMCI FONKSİYONLAR
--------------------------------------------------------------------------------

local function GetTeamColor(player)
    if not Settings.ESP.SmartColor then return Settings.Colors.Neutral end
    
    if player.Team == LocalPlayer.Team then
        return Settings.Colors.Team
    else
        return Settings.Colors.Enemy
    end
end

-- BillboardGui Oluşturucu
local function CreateESP_Visuals(player, root)
    if not root:FindFirstChild("RufoESP") then
        local bb = Instance.new("BillboardGui")
        bb.Name = "RufoESP"
        bb.Adornee = root
        bb.Size = UDim2.new(0, 200, 0, 50)
        bb.StudsOffset = Vector3.new(0, 3.5, 0)
        bb.AlwaysOnTop = true
        bb.Parent = root

        local txt = Instance.new("TextLabel")
        txt.Name = "MainText"
        txt.Parent = bb
        txt.BackgroundTransparency = 1
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.Font = Enum.Font.GothamBold
        txt.TextSize = 13
        txt.TextStrokeTransparency = 0
        txt.TextColor3 = Color3.new(1,1,1)
    end
    
    if not player.Character:FindFirstChild("RufoBox") then
        local hl = Instance.new("Highlight")
        hl.Name = "RufoBox"
        hl.Parent = player.Character
    end
end

--------------------------------------------------------------------------------
-- ANA DÖNGÜ (ESP & HITBOX)
--------------------------------------------------------------------------------

RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChild("Humanoid")

            if root and head and hum and hum.Health > 0 then
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local dist = 0
                if myRoot then
                    dist = math.floor((myRoot.Position - root.Position).Magnitude)
                end

                local color = GetTeamColor(player)

                -- 1. ESP MANTIĞI
                if Settings.ESP.Enabled then
                    CreateESP_Visuals(player, root)
                    
                    -- Charms / Highlight
                    local hl = char:FindFirstChild("RufoBox")
                    if hl then
                        hl.Enabled = Settings.ESP.Charms
                        hl.FillColor = color
                        hl.OutlineColor = Color3.new(1,1,1)
                        if Settings.ESP.Box then
                            hl.OutlineTransparency = 0
                        else
                            hl.OutlineTransparency = 1
                        end
                        hl.FillTransparency = 0.5 -- Charms görünümü için
                    end

                    -- Yazılar
                    local bg = root:FindFirstChild("RufoESP")
                    if bg then
                        local txt = bg:FindFirstChild("MainText")
                        if txt then
                            if Settings.ESP.Text then
                                txt.Visible = true
                                txt.TextColor3 = color
                                txt.Text = string.format("%s\n[ %d HP ]\n%dm", player.Name, math.floor(hum.Health), dist)
                            else
                                txt.Visible = false
                            end
                        end
                    end
                else
                    -- ESP Kapalıysa temizle
                    local hl = char:FindFirstChild("RufoBox")
                    if hl then hl:Destroy() end
                    local bg = root:FindFirstChild("RufoESP")
                    if bg then bg:Destroy() end
                end

                -- 2. HITBOX MANTIĞI (Fixlendi)
                if Settings.Hitbox.Enabled then
                    -- Sadece Düşmanlar için
                    if player.Team ~= LocalPlayer.Team then
                        head.Size = Vector3.new(Settings.Hitbox.Size, Settings.Hitbox.Size, Settings.Hitbox.Size)
                        head.Transparency = Settings.Hitbox.Transparency
                        head.CanCollide = false
                    else
                        -- Takım arkadaşıysa veya özellik kapalıysa normal boyut (Yaklaşık 1.2)
                        head.Size = Vector3.new(1.2, 1.2, 1.2)
                        head.Transparency = 0
                        head.CanCollide = true
                    end
                else
                    -- Hitbox kapalıysa normale döndür
                    head.Size = Vector3.new(1.2, 1.2, 1.2)
                    head.Transparency = 0
                    head.CanCollide = true
                end
            end
        end
    end
end)

-- Bildirim
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("SendNotification", {
    Title = "Rufocheck v2.0";
    Text = "Yüklendi! Menü için Sol ALT'a bas.";
    Duration = 5;
})
