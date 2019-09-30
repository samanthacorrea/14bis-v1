SCREEN_HEIGHT = 480
SCREEN_WIDTH = 320
MAX_METEORS = 12
GAMEOVER = false

airplane_14bis = {
    src = "imagens/14bis.png",
    width = 55,
    height = 63,
    x = SCREEN_WIDTH/2 - 64/2,
    y = SCREEN_HEIGHT - 66
}

meteors = {}

function destroyAirplane()
    airplane_14bis.src = "imagens/explosao_nave.png"
    airplane_14bis.image = love.graphics.newImage(airplane_14bis.src)
    airplane_14bis.width = 67
    airplane_14bis.height = 77
    GAMEOVER = true

end

function hasCollision(X1, Y1, L1, A1, X2, Y2, L2, A2)
    return X2 < X1 + L1 and
           X1 < X2 + L2 and
           Y1 < Y2 + A2 and
           Y2 < Y1 + A1
end

function checkCollision()
    for k, meteor in pairs(meteors) do
        if hasCollision(meteor.x, meteor.y, meteor.width, meteor.height, airplane_14bis.x, airplane_14bis.y, airplane_14bis.width, airplane_14bis.height) then
            destroyAirplane()
        end
    end
end
function removeMeteors()
    for i = #meteors, 1, -1 do
        if meteors[i].y > SCREEN_HEIGHT then
            table.remove(meteors, i)
        end
    end
end

function createMeteor()
    meteor = {
        x = math.random(SCREEN_WIDTH),
        y = -100,
        width = 50,
        height = 44,
        weight = math.random(4),
        spread = math.random(-1, 1)
    }

    table.insert(meteors, meteor)
end

function moveMeteors()
    for k, meteor in pairs(meteors) do
        meteor.y = meteor.y + meteor.weight
        meteor.x = meteor.x + meteor.spread
    end
end

function move14bis()
    if love.keyboard.isDown('w') then
        airplane_14bis.y = airplane_14bis.y - 1
    end

    if love.keyboard.isDown('s') then
        airplane_14bis.y = airplane_14bis.y + 1
    end

    if love.keyboard.isDown('a') then
        airplane_14bis.x = airplane_14bis.x - 1
    end

    if love.keyboard.isDown('d') then
        airplane_14bis.x = airplane_14bis.x + 1
    end
end

function love.load()
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, { resizable=false })
    love.window.setTitle("14bis vs meteors")

    math.randomseed(os.time())

    background = love.graphics.newImage("imagens/background.png")
    airplane_14bis.image = love.graphics.newImage(airplane_14bis.src)

    meteor_img = love.graphics.newImage("imagens/meteoro.png")


end

function love.update(dt)
    if not GAMEOVER then
        if love.keyboard.isDown('w', 'a', 'd', 's') then
            move14bis()
        end

        removeMeteors()

        if #meteors < MAX_METEORS then
            createMeteor()
        end
        moveMeteors()
        checkCollision()
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(airplane_14bis.image, airplane_14bis.x, airplane_14bis.y)
    
    for k, meteor in pairs(meteors) do
        love.graphics.draw(meteor_img, meteor.x, meteor.y)
    end

end