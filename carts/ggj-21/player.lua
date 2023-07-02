local boundY = -3.5

local idle_animation = {
    frames = {4, 4, 20},
    frame_duration = 60,
    cur_frame = 1,
    cur_duration = 0,
}

local moving_animation = {
    frames = {8, 24, 40 },
    frame_duration = 5,
    cur_frame = 1,
    cur_duration = 0,
}

local bounding_animation = {
    frames = {8, 24, 40 },
    frame_duration = 6,
    cur_frame = 1,
    cur_duration = 0,
}

function reset_animation(animation)
    animation.cur_frame = 1
    animation.cur_duration = 0
end

function get_frame(a)

    a.cur_duration += 1
    if a.cur_duration > a.frame_duration then
        a.cur_frame += 1
        a.cur_duration = 0

        if a.cur_frame > #a.frames then
            a.cur_frame = 1
        end
    end

    return a.frames[a.cur_frame]
end

function level_mget(x, y)
    local mx, my = curscreen:getMapOffset()
    return mget(x + (mx or 0), y + (my or 0))
end

function level_mset(x, y, v)
    local mx, my = curscreen:getMapOffset()
    return mset(x + (mx or 0), y + (my or 0), v)
end

local function createBound(xDirection, yDirection)
    local bound = {}
    bound.xDirection = xDirection
    bound.xVelocity = xDirection
    bound.yDirection = yDirection
    bound.yVelocity = yDirection
    bound.update = function(self)
        if self.xVelocity ~= 0 then
            local prevVelocity = self.xVelocity
            self.xVelocity -= self.xDirection/60 -- decrease velocity over a second
            if prevVelocity * self.xVelocity < 0 then
                self.xVelocity = 0
            end
        end
        if self.yVelocity ~= 0 then
            local prevVelocity = self.yVelocity
            self.yVelocity -= self.yDirection/60 -- decrease velocity over a second
            if prevVelocity * self.yVelocity < 0 then
                self.yVelocity = 0
            end
        end
        -- printDebug("x: " .. self.xVelocity .. ", y: " .. self.yVelocity)
    end
    bound.isComplete = function(self)
        return self.xVelocity == 0 and self.yVelocity == 0
    end
    return bound
end

local gravity = 7 * 1/60

player = {
    x = 64,
    y = 64,
    dx = 0,
    dy = 0,
    accumulatedGravity = 0,
    grounded = false,
    vertical = false,
    moving = false,
    freeze = false,
    direction = 0,
    currentAni = idle_animation,
    numResets = 0,
    bounding = false,
    enteringMap = true,
    boundQueue = {
        -- createBound(0, -5),
        -- createBound(0, -5),
        -- createBound(0, -5),
        -- createBound(0, -5),
        -- createBound(0, -5),
        -- createBound(0, -5),
        -- createBound(0, -5),
        -- createBound(0, -5),
    },
    curBound = nil,
    sense_data = {{0, 0}, {0, 0}, {0, 0}, {0, 0}},
}

function player:sense()
    -- left

    -- right


end

function player:solveCollisions(startx, starty)


    local xoffset=0
    if self.dx>0 then xoffset=7 end

    local h=level_mget((self.x + xoffset) / 8, (self.y + 4) / 8)
    if fget(h,0) then
        self.x = startx
    end

    local val = level_mget((self.x+4)/8,(self.y+8)/8)
    if fget(val, 0) then
        self.y = flr((self.y)/8)*8
        self.grounded = true
        self.accumulatedGravity = 0
        self.enteringMap = false
    end

    val = level_mget((self.x + 4)/8, self.y / 8)
    if fget(val, 0) then
        self.y = flr((self.y)/8 + 1)*8
        if self.curBound then
            self.curBound.yVelocity = 0
        end
    end

end

function player:processPickups()

    local val = level_mget(self.x/8, self.y/8)
    if fget(val, 1) then
        add(self.boundQueue, createBound(0, boundY))
        level_mset(self.x/8, self.y/8, 0)
    end

    if fget(val, 2) then
        add(self.boundQueue, createBound(0, boundY))
        add(self.boundQueue, createBound(0, boundY))
        add(self.boundQueue, createBound(0, boundY))
        add(self.boundQueue, createBound(0, boundY))
        add(self.boundQueue, createBound(0, boundY))
        level_mset(self.x/8, self.y/8, 0)
    end

end

function player:checkWinCondition()
    -- check win condition and send to next level if true
    if not self.enteringMap then
        local tile_x, tile_y = (self.x / 8), (self.y / 8)
        if tile_x < -1 or tile_y > 16 or tile_y < -1 or tile_y > 16 then
            -- We have escaped the bounds!!
            gameContext:completeLevel()
            self.freeze = true
        end
    end
end

function player:update()

    if self.freeze then
        return
    end

    -- Set up initial assumptions and data
    local startx = self.x
    local starty = self.y
    local wasGrounded = self.grounded
    self.dx=0
    self.dy=0
    self.grounded = false

    -- Update Velocity
    if btn(0) then --left
        self.dx=-2
    end
    if btn(1) then --right
        self.dx=2
    end

    -- Apply Gravity if not grounded
    self.dy += self.accumulatedGravity
    self.accumulatedGravity += gravity

    if self.curBound then
        self.curBound:update()
        if self.curBound:isComplete() then
            self.curBound = nil
        else
            self.dx += self.curBound.xVelocity
            self.dy += self.curBound.yVelocity
        end
    elseif wasGrounded then
        -- Check if we can BOUND
        self.bounding = false
        if btn_down(4) then
            if self.boundQueue[1] then
                sfx(0)
                self.curBound = remove(self.boundQueue, 1)
                self.dx += self.curBound.xVelocity
                self.dy += self.curBound.yVelocity
                self.bounding = true
            else
                sfx(4)
            end
        end
    end

    -- Update Position

    self.x += self.dx
    self.y += self.dy

    self:solveCollisions(startx, starty)
    self:processPickups()
    self:checkWinCondition()

    -- Set animation state variables
    -- printDebug("self.dx: " .. self.dx .. ", self.dy: " .. self.dy)
    self.direction = self.dx > 0 and 1 or self.dx < 0 and 0 or self.direction
    self.moving = self.dx ~= 0 or self.dy ~= 0
end

function player:draw()
    if(player.grounded == true and player.moving == false) then
        -- play stationary animation
        if(player.currentAni != idle_animation) then
            player.currentAni = idle_animation
            reset_animation(player.currentAni)
        end

        spr(get_frame(player.currentAni) + player.direction, self.x, self.y)
    else
        -- check for motion and play animation for that motion
        if(player.currentAni != moving_animation) then
            player.currentAni = moving_animation
            reset_animation(player.currentAni)
        end

        spr(get_frame(player.currentAni) + player.direction, self.x, self.y)
    end
end

function player:reset_position(x, y)
    self.x, self.y = x, y
    self.dx, self.v_y = 0, 0
end


