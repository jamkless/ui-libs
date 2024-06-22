local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()

local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/laderite/siernlib/main/library.lua"))()

local win = Library:Create({
    Name = "jamkles.lua"
})
local Legit = win:Tab('Legit')
local Rage = win:Tab('Rage')


Legit:Button('Load Tool', function()
    print(1)  
end)


getgenv().Prediction = 0.12389724521
getgenv().Smoothness = 1
getgenv().AimPart = "UpperTorso"
getgenv().ShakeValue = 0
getgenv().AutoPred = false

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local WS = game:GetService("Workspace")
local GS = game:GetService("GuiService")
local SG = game:GetService("StarterGui")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = WS.CurrentCamera
local GetGuiInset = GS.GetGuiInset

local AimlockState = true
local Locked
local Victim

local SelectedKey = getgenv().Key
local SelectedDisableKey = getgenv().DisableKey

if getgenv().Loaded == true then
    Notify("Loaded")
    return
end

getgenv().Loaded = true

local fov = Drawing.new("Circle")
fov.Filled = false
fov.Transparency = 1
fov.Thickness = 1
fov.Color = Color3.fromRGB(255, 255, 0)
fov.NumSides = 1000

function update()
    if getgenv().FOV == true then
        if fov then
            fov.Radius = getgenv().FOVSize * 2
            fov.Visible = getgenv().ShowFOV
            fov.Position = Vector2.new(Mouse.X, Mouse.Y + GetGuiInset(GS).Y)

            return fov
        end
    end
end

function WTVP(arg)
    return Camera:WorldToViewportPoint(arg)
end

function WTSP(arg)
    return Camera.WorldToScreenPoint(Camera, arg)
end

function getClosest()
    local closestPlayer
    local shortestDistance = math.huge

    for i, v in pairs(game.Players:GetPlayers()) do
        local notKO = v.Character:WaitForChild("BodyEffects")["K.O"].Value ~= true
        local notGrabbed = v.Character:FindFirstChild("GRABBING_COINSTRAINT") == nil

        if
            v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and
                v.Character.Humanoid.Health ~= 0 and
                v.Character:FindFirstChild(getgenv().AimPart) and
                notKO and
                notGrabbed
         then
            local pos = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude

            if (getgenv().FOV) then
                if (fov.Radius > magnitude and magnitude < shortestDistance) then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            else
                if (magnitude < shortestDistance) then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            end
        end
    end
    return closestPlayer
end

Tool.Activated:Connect(
    function()
        if AimlockState == true then
            Locked = not Locked
            if Locked then
                Victim = getClosest()

                Notification:Notify(
                    {
                        Title = "jamkles.lua",
                        Description = "Locked on: " .. tostring(Victim.Character.Humanoid.DisplayName)
                    },
                    {OutlineColor = Color3.fromRGB(255, 0, 54), Time = 3, Type = "default"},
                    {
                        Image = "http://www.roblox.com/asset/?id=6023426923",
                        ImageColor = Color3.fromRGB(255, 84, 84),
                        Callback = function(State)
                            print(tostring(State))
                        end
                    }
                )
            else
                if Victim ~= nil then
                    Victim = nil

                    Notification:Notify(
                        {Title = "jamkles.lua", Description = "unlocked"},
                        {OutlineColor = Color3.fromRGB(255, 0, 54), Time = 3, Type = "default"},
                        {
                            Image = "http://www.roblox.com/asset/?id=6023426923",
                            ImageColor = Color3.fromRGB(255, 84, 84),
                            Callback = function(State)
                                print(tostring(State))
                            end
                        }
                    )
                end
            end
        else
            Notify("Aimlock is not enabled!")
        end
    end
)

RS.RenderStepped:Connect(
    function()
        update()
        if Locked == true then
            if Victim ~= nil then
                local shakeOffset =
                    Vector3.new(
                    math.random(-getgenv().ShakeValue, getgenv().ShakeValue),
                    math.random(-getgenv().ShakeValue, getgenv().ShakeValue),
                    math.random(-getgenv().ShakeValue, getgenv().ShakeValue)
                ) * 0.171
                local LookPosition =
                    CFrame.new(
                    Camera.CFrame.p,
                    Victim.Character[getgenv().AimPart].Position +
                        (Vector3.new(
                            Victim.Character.HumanoidRootPart.Velocity.X,
                            Victim.Character.HumanoidRootPart.AssemblyAngularVelocity.Y * 0.5,
                            Victim.Character.HumanoidRootPart.Velocity.Z
                        ) *
                            getgenv().Prediction)
                ) + shakeOffset
                Camera.CFrame = Camera.CFrame:Lerp(LookPosition, getgenv().Smoothness)
            end
        end
    end
)

for _, con in next, getconnections(workspace.CurrentCamera.Changed) do
    task.wait()
    con:Disable()
end
for _, con in next, getconnections(workspace.CurrentCamera:GetPropertyChangedSignal("CFrame")) do
    task.wait()
    con:Disable()
end

while task.wait() do
    if getgenv().AutoPred == true then
        pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        split = string.split(pingvalue, "(")
        ping = tonumber(split[1])
        if ping < 225 then
            getgenv().Prediction = 1.4
        elseif ping < 215 then
            getgenv().Prediction = 0.24
        elseif ping < 205 then
            getgenv().Prediction = 0.209
        elseif ping < 190 then
            getgenv().Prediction = 0.18474
        elseif ping < 180 then
            getgenv().Prediction = 0.177
        elseif ping < 170 then
            getgenv().Prediction = 0.174
        elseif ping < 160 then
            getgenv().Prediction = 0.17
        elseif ping < 150 then
            getgenv().Prediction = 0.165
        elseif ping < 140 then
            getgenv().Prediction = 0.165
        elseif ping < 130 then
            getgenv().Prediction = 0.165
        elseif ping < 120 then
            getgenv().Prediction = 0.155
        elseif ping < 110 then
            getgenv().Prediction = 0.155
        elseif ping < 105 then
            getgenv().Prediction = 0.149533
        elseif ping < 90 then
            getgenv().Prediction = 0.146373
        elseif ping < 80 then
            getgenv().Prediction = 0.14211
        elseif ping < 70 then
            getgenv().Prediction = 0.136354
        elseif ping < 60 then
            getgenv().Prediction = 0.1343
        elseif ping < 50 then
            getgenv().Prediction = 0.12846
        elseif ping < 40 then
            getgenv().Prediction = 0.126
        elseif ping < 30 then
            getgenv().Prediction = 0.12
        elseif ping < 20 then
            getgenv().Prediction = 0.11
        end
    



