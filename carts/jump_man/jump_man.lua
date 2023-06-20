local player_x, player_y = 0, 0

function _update60()
    if (btn(0)) player_x += -1
    if (btn(1)) player_x += 1
    if (btn(2)) player_y += -1
    if (btn(3)) player_y += 1
end

function _draw()
    cls()
    spr(1, player_x, player_y)
    map(0, 0, 0, 0)
end