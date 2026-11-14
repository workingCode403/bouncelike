player = {
    x = 100,
    y = 100,
    speed = 500,
    direction = "right",
    health = 100,
    regen = 2,
    regenTime = 60
}

bullets = {}

function love.load()
    yotsuba = love.graphics.newImage("ys.png")
    bulletimg = love.graphics.newImage("bullet.png")
    bulletTimerMax = 0.2
    bulletTimer = 0
    bulletSpeed = 600
    love.window.setMode(1000, 1000)
    love.window.setTitle("BOUNCELIKE")

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

function destroyBullet(bullet)
    for j, v in ipairs(bullets) do
        if (v == bullet) then
            table.remove(bullets, j)
        end
    end
end

function love.update(dt)
    if player.health < 100 and player.regenTime == 60 then
        player.health = player.health + player.regen
        player.regenTime = player.regenTime - 1
    end

    if player.regenTime < 60 then
        if player.regenTime == 0 then
            player.regenTime = 60
        else
            player.regenTime = player.regenTime - 1
        end
    end

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
            destroyBullet(bullet)
        end

        if bullet.lifetime < 14
        and bullet.x > player.x
        and bullet.x < player.x + player.width
        and bullet.y > player.y
        and bullet.y < player.y + player.height then
            destroyBullet(bullet)
            player.health = player.health - 10
        end
    end
end

function love.draw()
    local r, g, b = love.math.colorFromBytes(181, 157, 164)
    love.graphics.clear(r, g, b)
    love.graphics.setBackgroundColor( r, g, b )

    love.graphics.draw(yotsuba, player.x, player.y)

    for _, bullet in ipairs(bullets) do
        love.graphics.draw(bulletimg, bullet.x, bullet.y)
    end
end