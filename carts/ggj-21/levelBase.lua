levelBase = {}

function createLevel(subclass)
    setmetatable(subclass, levelBase)
end

function createMapLevel(level_x, level_y)
    local level = {}

    level.init = function(self, inGameContext)
        levelBase.init(self, inGameContext)
    end
    level.onEnterScreen = function(self)
        levelBase.onEnterScreen(self)
    end
    level.onExitScreen = function(self)
        levelBase.onExitScreen(self)
    end
    level.update = function(self)
        levelBase.update(self)
    end
    level.draw = function(self)
        levelBase.draw(self)
    end
    level.getMapOffset = function(self)
        return levelBase.getMapOffset(self)
    end


    setmetatable(level, levelBase)
    level.mx = level_x
    level.my = level_y
    return level
end

function levelBase:init(inGameContext)
    self.gameContext = inGameContext
end

function levelBase:onEnterScreen()
    self.gameContext:resetState(true)
end

function levelBase:onExitScreen()

end

function levelBase:getMapOffset()
    return self.mx, self.my
end

function levelBase:update()
    self.gameContext.player:update()


    if btn_down(5) and not self.gameContext.isLevelComplete then
        -- self.gameContext:completeLevel()
        self.gameContext:resetState()
    end
    hud:update()
end

function levelBase:draw()
    map(self.mx, self.my, 0, 0, 16, 16)
    self.gameContext.player:draw()
    hud:draw()
end