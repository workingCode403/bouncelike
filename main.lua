player = {
    x = 100,
    y = 100,
    speed = 300,
    direction = "right"
}

bullets = {}

function love.load()
    yotsuba = love.graphics.newImage("ys.png")
    bulletimg = love.graphics.newImage("bullet.png")

    bulletTimerMax = 0.2
    bulletTimer = 0
    bulletSpeed = 500

    player.width = yotsuba:getWidth()
    player.height = yotsuba:getHeight()

    tileSize = 16
    tilemap = {}

    local w = math.ceil(love.graphics.getWidth() / tileSize)
    local h = math.ceil(love.graphics.getHeight() / tileSize)

    for y = 1, h do
        tilemap[y] = {}

        for x = 1, w do
            tilemap[y][x] = (x == 1 or x == w or y == 1 or y == h) and 1 or 0
        end
    end
end

function checkCollision(a, b)
    return a.x < b.x + b.width
       and a.x + a.width > b.x
       and a.y < b.y + b.height
       and a.y + a.height > b.y
end

function spawnBullet(x, y, dx, dy)
    table.insert(bullets, {
        x = x,
        y = y,
        dx = dx,
        dy = dy
    })
end

function love.update(dt)
    local oldX = player.x
    local oldY = player.y

    if love.keyboard.isDown("a") then
        player.x = player.x - player.speed * dt
        player.direction = "left"
    end

    if love.keyboard.isDown("d") then
        player.x = player.x + player.speed * dt
        player.direction = "right"
    end

    if love.keyboard.isDown("w") then
        player.y = player.y - player.speed * dt
        player.direction = "up"
    end

    if love.keyboard.isDown("s") then
        player.y = player.y + player.speed * dt
        player.direction = "down"
    end

    for i, row in ipairs(tilemap) do
        for j, tile in ipairs(row) do
            if tile == 1 then
                local wall = {
                    x = (j - 1) * tileSize,
                    y = (i - 1) * tileSize,
                    width = tileSize,
                    height = tileSize
                }

                if checkCollision(player, wall) then
                    player.x = oldX
                    player.y = oldY
                end
            end
        end
    end

    bulletTimer = bulletTimer - dt

    if love.keyboard.isDown("l") and bulletTimer <= 0 then
        local dx, dy = 0, 0

        if player.direction == "right" then
            dx = 1
        elseif player.direction == "left" then
            dx = -1
        elseif player.direction == "up" then
            dy = -1
        elseif player.direction == "down" then
            dy = 1
        end

        spawnBullet(
            player.x + player.width / 2,
            player.y + player.height / 2,
            dx,
            dy
        )

        bulletTimer = bulletTimerMax
    end

    for i = #bullets, 1, -1 do
        local bullet = bullets[i]

        bullet.x = bullet.x + bullet.dx * bulletSpeed * dt
        bullet.y = bullet.y + bullet.dy * bulletSpeed * dt

        if bullet.x < 0
        or bullet.x > love.graphics.getWidth() then
            bullet.dx = bullet.dx * -1
        end

        if bullet.y < 0
        or bullet.y > love.graphics.getHeight() then
            bullet.dy = bullet.dy * -1
        end
    end
end

function love.draw()
    love.graphics.clear(0, 0, 0)
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(yotsuba, player.x, player.y)

    for _, bullet in ipairs(bullets) do
        love.graphics.draw(bulletimg, bullet.x, bullet.y)
    end

    for i, row in ipairs(tilemap) do
        for j, tile in ipairs(row) do
            if tile == 1 then
                love.graphics.rectangle(
                    "line",
                    (j - 1) * tileSize,
                    (i - 1) * tileSize,
                    tileSize,
                    tileSize
                )
            end
        end
    end
end
