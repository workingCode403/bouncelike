local patterns = require("patterns")
player = {
    x = 100,
    y = 100,
    speed = 300,
    direction = "right",
    health = 1000,
    regen = 20,
    regenTime = 60
}

showHitboxes = true -- set to true for hitboxes

bullets = {}

function love.load()
    yotsuba = love.graphics.newImage("ys.png")
    bossimg = love.graphics.newImage("eys.png")
    bulletimg = love.graphics.newImage("bullet.png")
    pbulletimg = love.graphics.newImage("pink2.png")
    bulletTimerMax = 0.2
    bulletTimer = 0
    bulletSpeed = 600
    love.window.setMode(1000, 700)
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
        lifetime = 15.0,
        player = false
    })
end

function spawnPBullet(x, y, dx, dy)
    table.insert(bullets, {
        x = x,
        y = y,
        dx = dx,
        dy = dy,
        lifetime = 15.0,
        player = true
    })
end

function love.update(dt)
    if player.health < 1000 and player.regenTime == 60 then
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

    if love.keyboard.isDown("k") then
        patterns.circle(450, 0, 1)
    end
    if love.keyboard.isDown("j") then
        patterns.star(450, 0, 1)
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

        spawnPBullet(
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

        if bullet.x < 0 then
            bullet.x = 0
            bullet.dx = bullet.dx * -1
        end
        if bullet.x > love.graphics.getWidth() - 32 then
            bullet.x = love.graphics.getWidth() - 32
            bullet.dx = bullet.dx * -1
        end

        if bullet.y < 0 then
            bullet.y = 0
            bullet.dy = bullet.dy * -1
        end
        if bullet.y > love.graphics.getHeight() - 32 then
            bullet.y = love.graphics.getHeight() - 32
            bullet.dy = bullet.dy * -1
        end

        bullet.lifetime = bullet.lifetime - dt
        if bullet.lifetime <= 0 then
            table.remove(bullets, i)
        end

        local difX = (player.x + player.width / 2) - (bullet.x + 16)
        local difY = (player.y + player.height / 2) - (bullet.y + 16)
        local dif = math.sqrt(math.pow(difX, 2) + math.pow(difY, 2))

        if bullet.lifetime < 14
        and dif <= 23
        and not bullet.player then
            table.remove(bullets, i)
            player.health = player.health - 10
        end
    end
end

function love.draw()
    local r, g, b = love.math.colorFromBytes(181, 157, 164)
    love.graphics.clear(r, g, b)
    love.graphics.setBackgroundColor( r, g, b )
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(yotsuba, player.x, player.y)
    love.graphics.draw(bossimg, 430, 0)
    love.graphics.print("Health: " .. player.health, 600, 430, 0, 2, 2)
    for _, bullet in ipairs(bullets) do
        love.graphics.setColor(1, 1, 1)
        if bullet.player then
            love.graphics.draw(pbulletimg, bullet.x, bullet.y)
        else
            love.graphics.draw(bulletimg, bullet.x, bullet.y)
        end
        love.graphics.setColor(1, 0, 0)
        if showHitboxes then
            love.graphics.circle("line", bullet.x + 16, bullet.y + 16, 16)
        end
    end

    love.graphics.setColor(255, 255, 255)
    if showHitboxes then
        love.graphics.circle("fill", player.x + player.width / 2, player.y + player.height / 2, 7)
    end
end
