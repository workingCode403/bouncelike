local patterns = {}

fibAngle = 0
fib1Angle = 180
fib2Angle = 0

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

function patterns.fibArc(x, y, scale)
    scale = scale or 1

    local function bullet(px, py, dx, dy)
        spawnBullet(
            x + px * scale,
            y + py * scale,
            dx,
            dy
        )
    end

    bullet(math.cos(math.rad(fibAngle)),
           math.sin(math.rad(fibAngle)),
           math.cos(math.rad(fibAngle)),
           math.sin(math.rad(fibAngle)))

    fibAngle = fibAngle + 5
end

function patterns.doubleFibArc(x, y, scale)
    scale = scale or 1

    local function bullet(px, py, dx, dy)
        spawnBullet(
            x + px * scale,
            y + py * scale,
            dx,
            dy
        )
    end

    bullet(math.cos(math.rad(fib1Angle)),
           math.sin(math.rad(fib1Angle)),
           math.cos(math.rad(fib1Angle)),
           math.sin(math.rad(fib1Angle)))
    bullet(math.cos(math.rad(fib2Angle)),
           math.sin(math.rad(fib2Angle)),
           math.cos(math.rad(fib2Angle)),
           math.sin(math.rad(fib2Angle)))

    fib1Angle = fib1Angle + 5
    fib2Angle = fib2Angle + 5
end

function patterns.resetFib()
    fibAngle = 0
    fib1Angle = 180
    fib2Angle = 0
end

return patterns