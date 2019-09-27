SCREEN_HEIGHT = 480
SCREEN_WIDTH = 320

airplane_14bis = {
    src = "imagens/14bis.png",
    width = 64,
    height = 64,
    x = SCREEN_WIDTH/2 - 64/2,
    y = SCREEN_HEIGHT - 66
}

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

    background = love.graphics.newImage("imagens/background.png")
    airplane_14bis.image = love.graphics.newImage(airplane_14bis.src)

end

function love.update(dt)
    if love.keyboard.isDown('w', 'a', 'd', 's') then
        move14bis()
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(airplane_14bis.image, airplane_14bis.x, airplane_14bis.y)
end