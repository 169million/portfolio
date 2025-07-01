local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        -- Any Button Pressed
        print("Button Pressed")
        -- Specific Button
        if input.KeyCode == Enum.KeyCode.F then
            print("F Pressed")
        end
    end
end)
