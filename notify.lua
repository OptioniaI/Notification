local NotificationLibrary = {}
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local library

function NotificationLibrary:Load()
    library = Instance.new("ScreenGui")
    library.Name = "MaterialisticNotification"
    library.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    library.Parent = CoreGui

    local Holder = Instance.new("Frame")
    local NotificationTitle = Instance.new("TextLabel")
    local HolderCorner = Instance.new("UICorner")
    local NotificationDescription = Instance.new("TextLabel")
    local NotificationDelay = Instance.new("Frame")
    local DelayCorner = Instance.new("UICorner")
    local NotificationIcon = Instance.new("ImageLabel")

    Holder.Name = "Holder"
    Holder.Parent = library
    Holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Holder.BorderSizePixel = 0
    Holder.Position = UDim2.new(1.25, 0, 0.816286027, 0)
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
end

function NotificationLibrary:SendNotification(Title, Description, Duration)
    local libaryCore = CoreGui:FindFirstChild("MaterialisticNotification")
    if not libaryCore then
        NotificationLibrary:Load()
    else
        library = libaryCore
    end

    task.spawn(function()
        local success, err = pcall(function()
            local Notification = library.Holder:Clone()
            Notification.Parent = library
            Notification.Position = UDim2.new(1.25, 0, 0.816286027, 0)
            Notification.Visible = true

            Notification.NotificationTitle.Text = Title or "Title"
            Notification.NotificationDescription.Text = Description or "Description"

            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tweenIn = TweenService:Create(Notification, tweenInfo, {Position = UDim2.new(0.728927195, 0, 0.816286027, 0)})
            tweenIn:Play()

            local delayBar = Notification.NotificationDelay
            delayBar.Size = UDim2.new(0.949999988, 0, 0.0500000007, 0)
            local delayTween = TweenService:Create(delayBar, TweenInfo.new(Duration or 3, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0.0500000007, 0)})
            delayTween:Play()

            delayTween.Completed:Connect(function()
                local tweenOut = TweenService:Create(Notification, tweenInfo, {Position = UDim2.new(1.25, 0, 0.816286027, 0)})
                tweenOut:Play()
                tweenOut.Completed:Connect(function()
                    Notification:Destroy()
                end)
            end)
        end)
        if not success then
            warn("Error creating notification: " .. tostring(err))
        end)
    end)
end

return NotificationLibrary
