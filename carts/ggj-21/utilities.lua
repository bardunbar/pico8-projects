utilities = {}

-- Highlighting
local highlightColor = 8
local highlightFramesBetweenFlashes = 10
local highlightFrame = 0
local function updateHighlightColor()
    highlightFrame = highlightFrame + 1
    if highlightFrame > highlightFramesBetweenFlashes then
        highlightFrame = 0
        if highlightColor > 14 then
            highlightColor = 8
        else
            highlightColor = highlightColor + 1
        end
    end
end

local debugString
function printDebug(inDebugString)
    debugString = inDebugString
end

function remove(t, indexToRemove)
    local result = t[indexToRemove]
    for i = indexToRemove, #t do
        t[i] = t[i + 1]
    end
    return result
end

function utilities:update()
    btn_state_update()
    updateHighlightColor()
end

function utilities:draw()
    if debugString then
        print(debugString, 0, 0, 8)
    end
end

function utilities:getHighlightColor()
    return highlightColor
end

-- Button Functions
btn_state = {}
btn_state[0] = {cur = btn(0), prev = btn(0)}
btn_state[1] = {cur = btn(1), prev = btn(1)}
btn_state[2] = {cur = btn(2), prev = btn(2)}
btn_state[3] = {cur = btn(3), prev = btn(3)}
btn_state[4] = {cur = btn(4), prev = btn(4)}
btn_state[5] = {cur = btn(5), prev = btn(5)}

function btn_state_update()
    btn_state[0].prev = btn_state[0].cur
    btn_state[0].cur = btn(0)

    btn_state[1].prev = btn_state[1].cur
    btn_state[1].cur = btn(1)

    btn_state[2].prev = btn_state[2].cur
    btn_state[2].cur = btn(2)

    btn_state[3].prev = btn_state[3].cur
    btn_state[3].cur = btn(3)

    btn_state[4].prev = btn_state[4].cur
    btn_state[4].cur = btn(4)

    btn_state[5].prev = btn_state[5].cur
    btn_state[5].cur = btn(5)
end

function btn_release(b)
    return btn_state[b].prev and not btn_state[b].cur
end

function btn_down(b)
    return btn_state[b].cur and not btn_state[b].prev
end