hud = {}

function hud:init(gameContext)
    self.gameContext = gameContext
end

function hud:update()
    if self.gameContext.isLevelComplete then
        if btn_down(4) then
            if self.gameContext:hasNextLevel() then
                self.gameContext:nextLevel()
            else
                self.gameContext:resetGame()
            end
        end
    end
end

function hud:draw()
    print("bounds: " .. #self.gameContext.player.boundQueue, 1, 121, 0)
    -- TODO: store resets
    print("resets: " .. self.gameContext.player.numResets, 85, 121, 0)
    if self.gameContext.isLevelComplete then
        if self.gameContext:hasNextLevel() then
            print("level complete", 36, 54, utilities:getHighlightColor())
            print("PRESS z TO GO TO NEXT LEVEL", 11, 74, 11)
        else
            print("you have completed the game!", 5, 54, utilities:getHighlightColor())
            print("PRESS z TO GO TO THE MENU", 11, 74, 11)
        end
    end
end