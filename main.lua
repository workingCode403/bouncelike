player = {
    x = 100,
    y = 100,
    speed = 500,
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
        dy = dy,
        lifetime = 15.0
    })
end

function love.update(dt)
    if love.keyboard.isDown("a")
    and player.x > 0 then
        player.x = player.x - player.speed * dt
        player.direction = "left"
    end

    if love.keyboard.isDown("d")
    and player.x < love.graphics.getWidth() - player.width then
        player.x = player.x + player.speed * dt
        player.direction = "right"
    end

    if love.keyboard.isDown("w")
    and player.y > 0 then
        player.y = player.y - player.speed * dt
        player.direction = "up"
    end

    if love.keyboard.isDown("s")
    and player.y < love.graphics.getHeight() - player.height then
        player.y = player.y + player.speed * dt
        player.direction = "down"
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

        bullet.lifetime = bullet.lifetime - dt
        if bullet.lifetime <= 0 then
            for j, v in ipairs(bullets) do
                if (v == bullet) then
                    table.remove(bullets, j)
                end
            end
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
end
