local player = game.Players.LocalPlayer
local ts = game:GetService("TweenService")
local playerGui = player:WaitForChild("PlayerGui"):WaitForChild("gui"):WaitForChild("main")

local guiAnimator = require(script.Parent.guiAnimator)

local mode = playerGui:WaitForChild("mode")
local puncAndNum = playerGui:WaitForChild("puncAndNum")
local quoteLength = playerGui:WaitForChild("quoteLength")
local wordTime = playerGui:WaitForChild("wordTime")

local currentMode = "time" -- TODO: Store user data to save what mode the user had on start
local launch = false

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

	local moveOut = guiAnimator.hide({"left", puncAndNum}, {"right", wordTime})
	for _, data in moveOut do
		move(data.frame, data.targetPosition)
	end
	puncAndNum.Visible = false
	wordTime.Visible = false
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
	local hideAll = guiAnimator.hide({"left", puncAndNum}, {"right", wordTime}, {"right", quoteLength})
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
		if currentMode == "words" then
			local moveOut = guiAnimator.hide({"right", wordTime}, {"right", puncAndNum})
			for _, data in moveOut do
				move(data.frame, data.targetPosition)
				task.delay(0.3, function()
					wordTime.Visible = false
					puncAndNum.Visible = false
					showQuoteMode()
				end)
			end
		else
			showQuoteMode()
		end
	elseif newMode == "time" then
		if currentMode == "quote" then
			hideQuote()
			task.delay(0.3, function()
				quoteLength.Visible = false
				showTimeMode()
			end)
		else
			showTimeMode()
		end
	elseif newMode == "zen" then
		showZenMode()
	elseif newMode == "words" then
		if currentMode == "quote" then
			hideQuote()
			task.delay(0.3, function()
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

local selected = mode.time1

mode.time1.MouseButton1Click:Connect(function()
	fadeColor(selected, Color3.fromHex("#535553"))
	fadeColor(mode.time1, Color3.fromHex("#e2b714"))
	selected = mode.time1
	switchMode("time")
end)

mode.words.MouseButton1Click:Connect(function()
	fadeColor(selected, Color3.fromHex("#535553"))
	fadeColor(mode.words, Color3.fromHex("#e2b714"))
	selected = mode.words
	switchMode("words")
end)

mode.quote.MouseButton1Click:Connect(function()
	fadeColor(selected, Color3.fromHex("#535553"))
	fadeColor(mode.quote, Color3.fromHex("#e2b714"))
	selected = mode.quote
	switchMode("quote")
end)

mode.zen.MouseButton1Click:Connect(function()
	fadeColor(selected, Color3.fromHex("#535553"))
	fadeColor(mode.zen, Color3.fromHex("#e2b714"))
	selected = mode.zen
	switchMode("zen")
end)