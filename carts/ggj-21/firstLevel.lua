firstLevel = {}
createLevel(firstLevel)
local super = levelBase

function firstLevel:init(inGameContext)
    super.init(self, inGameContext)
    self.mx, self.my = 17, 0
end

function firstLevel:onEnterScreen()
    super.onEnterScreen(self)
end

function firstLevel:onExitScreen()
    super.onExitScreen(self)
end

function firstLevel:update()
    super.update(self)
end

function firstLevel:draw()
    super.draw(self)
end

function firstLevel:getMapOffset()
    return super.getMapOffset(self)
end