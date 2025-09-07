--[[ 
Script: Invisibilidade + Anti Hit com GUI
Autor: Richard
Descrição: Invisibilidade total + anti-hit com GUI preto/cinza
]]

-- Garantir que o jogo carregou
repeat task.wait() until game:IsLoaded()

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Variáveis de controle
local invisivelAtivo = false
local antihitAtivo = false

-- Função de invisibilidade
local function AtivarInvisibilidade()
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            part.CanCollide = false
        elseif part:IsA("Decal") then
            part.Transparency = 1
        end
    end
end

local function DesativarInvisibilidade()
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
            part.CanCollide = true
        elseif part:IsA("Decal") then
            part.Transparency = 0
        end
    end
end

-- Função Anti Hit
local function AtivarAntiHit()
    if Humanoid then
        Humanoid.Health = Humanoid.MaxHealth
        Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Touched:Connect(function(hit)
                            if hit.Parent == Character then
                                Humanoid.Health = Humanoid.MaxHealth
                            end
                        end)
                    end
                end
            end
        end
    end
end

-- Criando GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RichardHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(0.5, -125, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderColor3 = Color3.fromRGB(100,100,100)
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

-- Botão Invisibilidade
local InvisButton = Instance.new("TextButton")
InvisButton.Size = UDim2.new(0, 200, 0, 40)
InvisButton.Position = UDim2.new(0, 25, 0, 20)
InvisButton.Text = "Invisibilidade: OFF"
InvisButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
InvisButton.BorderColor3 = Color3.fromRGB(150,150,150)
InvisButton.TextColor3 = Color3.fromRGB(200,200,200)
InvisButton.Parent = Frame

InvisButton.MouseButton1Click:Connect(function()
    invisivelAtivo = not invisivelAtivo
    if invisivelAtivo then
        AtivarInvisibilidade()
        InvisButton.Text = "Invisibilidade: ON"
    else
        DesativarInvisibilidade()
        InvisButton.Text = "Invisibilidade: OFF"
    end
end)

-- Botão Anti Hit
local AntiButton = Instance.new("TextButton")
AntiButton.Size = UDim2.new(0, 200, 0, 40)
AntiButton.Position = UDim2.new(0, 25, 0, 80)
AntiButton.Text = "Anti Hit: OFF"
AntiButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
AntiButton.BorderColor3 = Color3.fromRGB(150,150,150)
AntiButton.TextColor3 = Color3.fromRGB(200,200,200)
AntiButton.Parent = Frame

AntiButton.MouseButton1Click:Connect(function()
    antihitAtivo = not antihitAtivo
    if antihitAtivo then
        AtivarAntiHit()
        AntiButton.Text = "Anti Hit: ON"
    else
        AntiButton.Text = "Anti Hit: OFF"
    end
end)

-- Atualização contínua
RunService.RenderStepped:Connect(function()
    if invisivelAtivo then
        AtivarInvisibilidade()
    end
    if antihitAtivo then
        Humanoid.Health = Humanoid.MaxHealth
    end
end)
