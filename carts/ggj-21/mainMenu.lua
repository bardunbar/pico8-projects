mainMenu = {}

local function onStartGame()
    -- mainMenu.gameContext:goToScreen("firstLevel")
    mainMenu.gameContext:goToScreen("whiteboxLevel")
end

local function onOpenCredits()
    mainMenu.gameContext:goToScreen("credits")
end

local function backToMenu()
    mainMenu.gameContext:goToScreen("mainMenu")
end

-- Buttons
local xoffset = 20
local ystart = 40
local yoffset = 10

function mainMenu:upInput()
    self.highlightedButton = self.highlightedButton - 1
    if self.highlightedButton < 1 then
        self.highlightedButton = #self.buttonOptions
    end
end

function mainMenu:downInput()
    self.highlightedButton = self.highlightedButton + 1
    if self.highlightedButton > #self.buttonOptions then
        self.highlightedButton = 1
    end
end

-- Start required interface
function mainMenu:init(inGameContext)
    self.gameContext = inGameContext

    self.highlightedButton = 1
    self.buttonOptions = {
        { text = "START GAME", onPress = onStartGame },
        { text = "CREDITS", onPress = onOpenCredits},
    }
end

function mainMenu:onEnterScreen()
    music(0)
end

function mainMenu:onExitScreen()

end

function mainMenu:update()
    if btn_down(2) then
        self:upInput()
    elseif btn_down(3) then
        self:downInput()
    end
    if btn_down(4) then
        self.buttonOptions[self.highlightedButton].onPress()
    end
end

function mainMenu:draw()
    print("out of bounds", 30, 30, 7)

    for i = 1, #self.buttonOptions do
        local isHighlighted = i == self.highlightedButton
        local prefix = isHighlighted and " > " or "  "
        local color = (isHighlighted and utilities:getHighlightColor()) or 6
        print(prefix .. self.buttonOptions[i].text, xoffset, yoffset*i + ystart, color)
    end
end
-- End required interface

credits = {}

function credits:init(inGameContext)
    self.gameContext = inGameContext

    self.highlightedButton = 1
    self.buttonOptions = {
        { text = "CREDITS" },
        { text = "ian dunbar" },
        { text = "jono ryley" },
        { text = "dave ryley" },
        { text = "menu", onPress = backToMenu},
    }
end

function credits:onEnterScreen()
end

function credits:onExitScreen()
end

function credits:upInput()
    self.highlightedButton = self.highlightedButton - 1
    if self.highlightedButton < 1 then
        self.highlightedButton = #self.buttonOptions
    end
end

function credits:downInput()
    self.highlightedButton = self.highlightedButton + 1
    if self.highlightedButton > #self.buttonOptions then
        self.highlightedButton = 1
    end
end


function credits:update()
    if btn_down(2) then
        self:upInput()
    elseif btn_down(3) then
        self:downInput()
    end
    if btn_down(4) then
        local fn = self.buttonOptions[self.highlightedButton]
        if fn.onPress then
            fn.onPress()
        end
    end
end

function credits:draw()
    print("out of bounds", 30, 30, 7)

    for i = 1, #self.buttonOptions do
        local isHighlighted = i == self.highlightedButton
        local prefix = isHighlighted and " > " or "  "
        local color = (isHighlighted and utilities:getHighlightColor()) or 6
        print(prefix .. self.buttonOptions[i].text, xoffset, yoffset*i + ystart, color)
    end
end