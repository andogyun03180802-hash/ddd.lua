local StarterGui = game:GetService("StarterGui")

-- 첫 번째 알림
StarterGui:SetCore("SendNotification", {
    Title = "조작법",
    Text = "F는 플라이입니다!",
    Duration = 4
})

task.wait(4)

-- 두 번째
StarterGui:SetCore("SendNotification", {
    Title = "조작법",
    Text = "E는 ESP입니다!",
    Duration = 4
})

task.wait(4)

-- 세 번째
StarterGui:SetCore("SendNotification", {
    Title = "조작법",
    Text = "Q는 에임 따라갑니다!",
    Duration = 4
})
