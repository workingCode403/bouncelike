local patterns = {}
function patterns.circle(x, y, scale)
    scale = scale or 1

    local function bullet(px, py, dx, dy)
        spawnBullet(
            x + px * scale,
            y + py * scale,
            dx,
            dy
        )
    end

    for angle = 0, 360 do
        if angle % 10 == 0 then
            bullet(math.cos(math.rad(angle)),
                   math.sin(math.rad(angle)),
                   math.cos(math.rad(angle)),
                   math.sin(math.rad(angle)))
        end
    end
end

function patterns.star(x, y, scale)
    scale = scale or 1

    local function bullet(px, py, dx, dy)
        spawnBullet(
            x + px * scale,
            y + py * scale,
            dx,
            dy
        )
    end

    for angle = 0, 360 do
        if angle % 30 == 0 then
            bullet(math.cos(math.rad(angle)),
                   math.sin(math.rad(angle)),
                   math.cos(math.rad(angle)),
                   math.sin(math.rad(angle)))
        end
    end
end

return patterns