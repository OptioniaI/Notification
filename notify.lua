local CoreGui = game:GetService("CoreGui");

if CoreGui:FindFirstChild("MaterialisticNotification") then
	CoreGui:FindFirstChild("MaterialisticNotification"):Remove()
end

local MaterialisticNotification = Instance.new("ScreenGui")
local Holder = Instance.new("Frame")
local NotificationTitle = Instance.new("TextLabel")
local HolderCorner = Instance.new("UICorner")
local NotificationDescription = Instance.new("TextLabel")
local NotificationDelay = Instance.new("Frame")
local DelayCorner = Instance.new("UICorner")
local NotificationIcon = Instance.new("ImageLabel")

MaterialisticNotification.Name = "MaterialisticNotification"
MaterialisticNotification.Parent = CoreGui
MaterialisticNotification.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Holder.Name = "Holder"
Holder.Parent = MaterialisticNotification
Holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
Holder.BorderSizePixel = 0
Holder.Position = UDim2.new(1.2, 0, 0.816286027, 0)
Holder.Size = UDim2.new(0.25, 0, 0.150000006, 0)

NotificationTitle.Name = "NotificationTitle"
NotificationTitle.Parent = Holder
NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NotificationTitle.BackgroundTransparency = 1.000
NotificationTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
NotificationTitle.BorderSizePixel = 0
NotificationTitle.Position = UDim2.new(0.25, 0, 0.100000001, 0)
NotificationTitle.Size = UDim2.new(0.5, 0, 0.150000006, 0)
NotificationTitle.Font = Enum.Font.SpecialElite
NotificationTitle.Text = "Title"
NotificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationTitle.TextScaled = true
NotificationTitle.TextSize = 14.000
NotificationTitle.TextStrokeTransparency = 0.000
NotificationTitle.TextWrapped = true

HolderCorner.CornerRadius = UDim.new(0.100000001, 0)
HolderCorner.Name = "HolderCorner"
HolderCorner.Parent = Holder

NotificationDescription.Name = "NotificationDescription"
NotificationDescription.Parent = Holder
NotificationDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NotificationDescription.BackgroundTransparency = 1.000
NotificationDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
NotificationDescription.BorderSizePixel = 0
NotificationDescription.Position = UDim2.new(0, 0, 0.400000006, 0)
NotificationDescription.Size = UDim2.new(1, 0, 0.400000006, 0)
NotificationDescription.Font = Enum.Font.SpecialElite
NotificationDescription.Text = "Description"
NotificationDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationDescription.TextScaled = true
NotificationDescription.TextSize = 14.000
NotificationDescription.TextStrokeTransparency = 0.000
NotificationDescription.TextWrapped = true

NotificationDelay.Name = "NotificationDelay"
NotificationDelay.Parent = Holder
NotificationDelay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NotificationDelay.BorderColor3 = Color3.fromRGB(0, 0, 0)
NotificationDelay.BorderSizePixel = 0
NotificationDelay.Position = UDim2.new(0.0250000004, 0, 0.86500001, 0)
NotificationDelay.Size = UDim2.new(0.949999988, 0, 0.0500000007, 0)

DelayCorner.CornerRadius = UDim.new(1, 0)
DelayCorner.Name = "DelayCorner"
DelayCorner.Parent = NotificationDelay

NotificationIcon.Name = "NotificationIcon"
NotificationIcon.Parent = Holder
NotificationIcon.BackgroundTransparency = 1.000
NotificationIcon.Position = UDim2.new(0.0149999997, 0, 0.0500000007, 0)
NotificationIcon.Size = UDim2.new(0.0700000003, 0, 0.185000002, 0)
NotificationIcon.Image = "rbxassetid://2790551206"

local NotificationLibrary = {}
local TweenService = game:GetService("TweenService")
local isDisplaying = false
local notificationQueue = {}

function NotificationLibrary:Notify(title, description, duration)
    if isDisplaying then
        table.insert(notificationQueue, {title = title, description = description, duration = duration})
        return
    end

    isDisplaying = true
    duration = duration or 5

    NotificationTitle.Text = title or "Title"
    NotificationDescription.Text = description or "Description"
    
    NotificationDelay.Size = UDim2.new(0.949999988, 0, 0.0500000007, 0)
    
    local tweenIn = TweenService:Create(
        Holder,
        TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.728927195, 0, 0.816286027, 0)}
    )
    
    local tweenDelay = TweenService:Create(
        NotificationDelay,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {Size = UDim2.new(0, 0, 0.0500000007, 0)}
    )
    
    local tweenOut = TweenService:Create(
        Holder,
        TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        {Position = UDim2.new(1.2, 0, 0.816286027, 0)}
    )

    tweenIn:Play()
    tweenIn.Completed:Connect(function()
        tweenDelay:Play()
    end)
    
    tweenDelay.Completed:Connect(function()
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            isDisplaying = false
            if #notificationQueue > 0 then
                local nextNotification = table.remove(notificationQueue, 1)
                NotificationLibrary:Notify(
                    nextNotification.title,
                    nextNotification.description,
                    nextNotification.duration
                )
            end
        end)
    end)
end
return NotificationLibrary
