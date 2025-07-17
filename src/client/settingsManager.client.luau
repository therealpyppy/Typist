local player = game.Players.LocalPlayer
local ts = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local playerGui = player:WaitForChild("PlayerGui"):WaitForChild("gui"):WaitForChild("main")

local guiAnimator = require(script.Parent.guiAnimator)

local mode = playerGui:WaitForChild("mode")
local puncAndNum = playerGui:WaitForChild("puncAndNum")
local quoteLength = playerGui:WaitForChild("quoteLength")
local wordTime = playerGui:WaitForChild("wordTime")

local currentMode = "time"
-- Defaults
local punctuation = false
local numbers = false
local quoteLengths = {}
local words = 50
local time = 60

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function move(frame, targetPosition)
	local tween = ts:Create(frame, tweenInfo, { Position = targetPosition })
	tween:Play()
	return tween
end

local function fade(object, transparency)
	if transparency == 0 then
		object.Visible = true
	end
	local tween = ts:Create(object, tweenInfo2, { TextTransparency = transparency })
	tween:Play()
	if transparency == 1 then
		tween.Completed:Connect(function()
			object.Visible = false
		end)
	end
	return tween
end

local function fadeGroup(elements, transparency)
	for _, el in elements do
		fade(el, transparency)
	end
end

local function showQuoteMode()
	local moveIn = guiAnimator.show({"right", quoteLength})
	quoteLength.Visible = true
	for _, data in moveIn do
		move(data.frame, data.targetPosition)
	end
end

local function showTimeMode()
	local moveIn = guiAnimator.show({"left", puncAndNum}, {"right", wordTime})
	puncAndNum.Visible = true
	wordTime.Visible = true

	for _, data in moveIn do
		move(data.frame, data.targetPosition)
	end

	if wordTime.word1.TextTransparency ~= 1 then
		fadeGroup({wordTime.word1, wordTime.word2, wordTime.word3, wordTime.word4}, 1)
		task.delay(0.3, function()
			fadeGroup({wordTime.time1, wordTime.time2, wordTime.time3, wordTime.time4}, 0)
		end)
	end
end

local function showZenMode()
	local hideAll
	if currentMode == "quote" then
		hideAll = guiAnimator.hide({"right", quoteLength})
	else
		hideAll = guiAnimator.hide({"left", puncAndNum}, {"right", wordTime})
	end
	for _, data in hideAll do
		move(data.frame, data.targetPosition)
	end
	task.delay(0.3, function()
		puncAndNum.Visible = false
		wordTime.Visible = false
		quoteLength.Visible = false
	end)
end

local function showWordsMode()
	puncAndNum.Visible = true
	wordTime.Visible = true

	local moveIn = guiAnimator.show({"left", puncAndNum}, {"right", wordTime})
	for _, data in moveIn do
		move(data.frame, data.targetPosition)
	end

	if wordTime.time1.TextTransparency ~= 1 then
		fadeGroup({wordTime.time1, wordTime.time2, wordTime.time3, wordTime.time4}, 1)
		task.delay(0.3, function()
			fadeGroup({wordTime.word1, wordTime.word2, wordTime.word3, wordTime.word4}, 0)
		end)
	end
end

local function hideQuote()
	local moveOut = guiAnimator.hide({"right", quoteLength})
	for _, data in moveOut do
		move(data.frame, data.targetPosition)
	end
end

local function switchMode(newMode)
	if currentMode == newMode then return end
	if newMode == "quote" then
		if currentMode == "words" or currentMode == "time" then
			showZenMode()
			task.delay(0.5, function()
				wordTime.Visible = false
				puncAndNum.Visible = false
				showQuoteMode()
			end)
		else
			showQuoteMode()
		end
	elseif newMode == "time" then
		if currentMode == "words" then
			if wordTime.word1.TextTransparency ~= 1 then
				fadeGroup({wordTime.word1, wordTime.word2, wordTime.word3, wordTime.word4}, 1)
				task.delay(0.3, function()
					fadeGroup({wordTime.time1, wordTime.time2, wordTime.time3, wordTime.time4}, 0)
				end)
			end
			currentMode = newMode
			return
		end
		if currentMode == "quote" then
			hideQuote()
			task.delay(0.5, function()
				quoteLength.Visible = false
				showTimeMode()
			end)
		else
			showTimeMode()
		end
	elseif newMode == "zen" then
		showZenMode()
	elseif newMode == "words" then
		if currentMode == "time" then
			if wordTime.time1.TextTransparency ~= 1 then
				fadeGroup({wordTime.time1, wordTime.time2, wordTime.time3, wordTime.time4}, 1)
				task.delay(0.3, function()
					fadeGroup({wordTime.word1, wordTime.word2, wordTime.word3, wordTime.word4}, 0)
				end)
			end
			currentMode = newMode
			return
		end
		if currentMode == "quote" then
			hideQuote()
			task.delay(0.5, function()
				quoteLength.Visible = false
				showWordsMode()
			end)
		else
			showWordsMode()
		end
	end
	currentMode = newMode
end

local function fadeColor(object, color)
	local tween = ts:Create(object, tweenInfo, { TextColor3 = color })
	tween:Play()
	return tween
end

local selected = nil

mode.time1.MouseButton1Click:Connect(function()
	if selected then fadeColor(selected, Color3.fromHex("#535553")) end
	fadeColor(mode.time1, Color3.fromHex("#e2b714"))
	selected = mode.time1
	switchMode("time")
end)

mode.words.MouseButton1Click:Connect(function()
	if selected then fadeColor(selected, Color3.fromHex("#535553")) end
	fadeColor(mode.words, Color3.fromHex("#e2b714"))
	selected = mode.words
	switchMode("words")
end)

mode.quote.MouseButton1Click:Connect(function()
	if selected then fadeColor(selected, Color3.fromHex("#535553")) end
	fadeColor(mode.quote, Color3.fromHex("#e2b714"))
	selected = mode.quote
	switchMode("quote")
end)

mode.zen.MouseButton1Click:Connect(function()
	if selected then fadeColor(selected, Color3.fromHex("#535553")) end
	fadeColor(mode.zen, Color3.fromHex("#e2b714"))
	selected = mode.zen
	switchMode("zen")
end)

local punctuationToggle = false
puncAndNum.punctuation.MouseButton1Click:Connect(function()
    if punctuationToggle then
        fadeColor(puncAndNum.punctuation, Color3.fromHex("#535553"))
    else
	    fadeColor(puncAndNum.punctuation, Color3.fromHex("#e2b714"))
    end
	punctuationToggle = not punctuationToggle
end)

local numbersToggle = false
puncAndNum.numbers.MouseButton1Click:Connect(function()
    if numbersToggle then
        fadeColor(puncAndNum.numbers, Color3.fromHex("#535553"))
    else
	    fadeColor(puncAndNum.numbers, Color3.fromHex("#e2b714"))
    end
	numbersToggle = not numbersToggle
end)

local function find(tbl: table, field: string, value: string | TextButton)
	for i, v in tbl do
		if v[field] == value then
			return i
		end
	end
	return nil
end

quoteLength.all.MouseButton1Click:Connect(function()
	table.clear(quoteLengths)

	for _, option in {quoteLength.short, quoteLength.medium, quoteLength.long, quoteLength.thicc} do
		table.insert(quoteLengths, {
			value = option.Name,
			uiElement = option
		})
		fadeColor(option, Color3.fromHex("#e2b714"))
	end
end)

quoteLength.short.MouseButton1Click:Connect(function()
	local shiftPressed = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
	local uiE = quoteLength.short

	if shiftPressed then
		local find = find(quoteLengths, "uiElement", uiE)
		if find then
			table.remove(quoteLengths, find)
			fadeColor(uiE, Color3.fromHex("#535553"))
		else
			table.insert(quoteLengths, {
				value = "short",
				uiElement = uiE
			})
			fadeColor(uiE, Color3.fromHex("#e2b714"))
		end
	else
		for i, v in quoteLengths do
			fadeColor(v.uiElement, Color3.fromHex("#535553"))
		end
		table.clear(quoteLengths)
		table.insert(quoteLengths, {
			value = "short",
			uiElement = uiE
		})
		fadeColor(uiE, Color3.fromHex("#e2b714"))
	end
end)

quoteLength.medium.MouseButton1Click:Connect(function()
	local shiftPressed = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
	local uiE = quoteLength.medium

	if shiftPressed then
		local find = find(quoteLengths, "uiElement", uiE)
		if find then
			table.remove(quoteLengths, find)
			fadeColor(uiE, Color3.fromHex("#535553"))
		else
			table.insert(quoteLengths, {
				value = "medium",
				uiElement = uiE
			})
			fadeColor(uiE, Color3.fromHex("#e2b714"))
		end
	else
		for i, v in quoteLengths do
			fadeColor(v.uiElement, Color3.fromHex("#535553"))
		end
		table.clear(quoteLengths)
		table.insert(quoteLengths, {
			value = "medium",
			uiElement = uiE
		})
		fadeColor(uiE, Color3.fromHex("#e2b714"))
	end
end)

quoteLength.long.MouseButton1Click:Connect(function()
	local shiftPressed = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
	local uiE = quoteLength.long

	if shiftPressed then
		local find = find(quoteLengths, "uiElement", uiE)
		if find then
			table.remove(quoteLengths, find)
			fadeColor(uiE, Color3.fromHex("#535553"))
		else
			table.insert(quoteLengths, {
				value = "long",
				uiElement = uiE
			})
			fadeColor(uiE, Color3.fromHex("#e2b714"))
		end
	else
		for i, v in quoteLengths do
			fadeColor(v.uiElement, Color3.fromHex("#535553"))
		end
		table.clear(quoteLengths)
		table.insert(quoteLengths, {
			value = "long",
			uiElement = uiE
		})
		fadeColor(uiE, Color3.fromHex("#e2b714"))
	end
end)

quoteLength.thicc.MouseButton1Click:Connect(function()
	local shiftPressed = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
	local uiE = quoteLength.thicc

	if shiftPressed then
		local find = find(quoteLengths, "uiElement", uiE)
		if find then
			table.remove(quoteLengths, find)
			fadeColor(uiE, Color3.fromHex("#535553"))
		else
			table.insert(quoteLengths, {
				value = "thicc",
				uiElement = uiE
			})
			fadeColor(uiE, Color3.fromHex("#e2b714"))
		end
	else
		for i, v in quoteLengths do
			fadeColor(v.uiElement, Color3.fromHex("#535553"))
		end
		table.clear(quoteLengths)
		table.insert(quoteLengths, {
			value = "thicc",
			uiElement = uiE
		})
		fadeColor(uiE, Color3.fromHex("#e2b714"))
	end
end)

local selectedTime = nil
local selectedWord = nil

for _, v in wordTime:GetChildren() do
	if v:IsA("TextButton") then
		if v.Name:sub(1, 4) == "time" then
			v.MouseButton1Click:Connect(function()
				if selectedTime then
					fadeColor(selectedTime, Color3.fromHex("#535553"))
				end
				fadeColor(v, Color3.fromHex("#e2b714"))
				selectedTime = v
			end)
		elseif v.Name:sub(1, 4) == "word" then
			v.MouseButton1Click:Connect(function()
				if selectedWord then
					fadeColor(selectedWord, Color3.fromHex("#535553"))
				end
				fadeColor(v, Color3.fromHex("#e2b714"))
				selectedWord = v
			end)
		end
	end
end