SCREEN_HEIGHT = 480
SCREEN_WIDTH = 320
MAX_METEORS = 12
GAMEOVER = false
HIT_METEORS = 0
QUANTITY_METEORS = 10
WINNER = false

airplane_14bis = {
    src = "imagens/14bis.png",
    width = 55,
    height = 63,
    x = SCREEN_WIDTH/2 - 64/2,
    y = SCREEN_HEIGHT - 66,
    shots = {},
}

meteors = {}

function shoot()
    if WINNER == true then
        music_shot:stop() 
    else
        music_shot:play()
    end

    local shot = {
        x = airplane_14bis.x + airplane_14bis.width/2,
        y = airplane_14bis.y,
        width = 16,
        height = 16,
    }

    table.insert(airplane_14bis.shots, shot)
end

function moveShots()
    for i = #airplane_14bis.shots, 1, -1 do
        if airplane_14bis.shots[i].y > 0 then
            airplane_14bis.shots[i].y = airplane_14bis.shots[i].y - 1
        else
            table.remove(airplane_14bis.shots, i)
        end
    end
end

function destroyAirplane()
    music_destroy:play()
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

function changeMusic()
    music_game:stop()
    music_gameover:play()
end

function checkCollisionWithAirplane()
    for k, meteor in pairs(meteors) do
        if hasCollision(meteor.x, meteor.y, meteor.width, meteor.height, 
                        airplane_14bis.x, airplane_14bis.y, airplane_14bis.width, 
                        airplane_14bis.height) then
            changeMusic()
            destroyAirplane()
            GAMEOVER = true
        end
    end
end

function checkCollisionWithShots()
    for i = #airplane_14bis.shots, 1, -1 do
        for j = #meteors, 1, -1 do
            if hasCollision(airplane_14bis.shots[i].x, airplane_14bis.shots[i].y, 
                            airplane_14bis.shots[i].width, airplane_14bis.shots[i].height,
                            meteors[j].x, meteors[j].y, meteors[j].width, meteors[j].height) then
                HIT_METEORS = HIT_METEORS + 1

                table.remove(airplane_14bis.shots, i)
                table.remove(meteors, j)
                break
            end
        end
    end
end

function checkCollision()
    checkCollisionWithAirplane()
    checkCollisionWithShots()
end

function winTheGame()
    if HIT_METEORS >= QUANTITY_METEORS then
        WINNER = true
        music_winner:play()
        music_game:stop()
    end
end

function love.load()
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, { resizable=false })
    love.window.setTitle("14bis vs meteors")

    math.randomseed(os.time())

    background = love.graphics.newImage("imagens/background.png")
    gameover_img = love.graphics.newImage("imagens/gameover.png")
    winner_img = love.graphics.newImage("imagens/vencedor.png")

    airplane_14bis.image = love.graphics.newImage(airplane_14bis.src)
    meteor_img = love.graphics.newImage("imagens/meteoro.png")
    shot_img = love.graphics.newImage("imagens/tiro.png")

    music_game = love.audio.newSource("audios/ambiente.wav", "static")
    music_game:setLooping(true)
    music_game:play()

    music_destroy = love.audio.newSource("audios/destruicao.wav", "static")
    music_gameover = love.audio.newSource("audios/game_over.wav", "static")
    music_shot = love.audio.newSource("audios/disparo.wav", "static")
    music_winner = love.audio.newSource("audios/winner.wav", "static")


end

function love.update(dt)
    if not GAMEOVER and not WINNER then
        if love.keyboard.isDown('w', 'a', 'd', 's') then
            move14bis()
        end

        removeMeteors()

        if #meteors < MAX_METEORS then
            createMeteor()
        end
        moveMeteors()
        moveShots()
        checkCollision()
        winTheGame()
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "space" then
        shoot()
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(airplane_14bis.image, airplane_14bis.x, airplane_14bis.y)
    
    love.graphics.print("Remaining meteors " .. QUANTITY_METEORS - HIT_METEORS, 1, 1)
    for k, meteor in pairs(meteors) do
        love.graphics.draw(meteor_img, meteor.x, meteor.y)
    end

    for k, shot in pairs(airplane_14bis.shots) do
        love.graphics.draw(shot_img, shot.x, shot.y)
    end

    if GAMEOVER then
        love.graphics.draw(gameover_img, SCREEN_WIDTH/2 - (gameover_img:getWidth()/2), SCREEN_HEIGHT/2 - (gameover_img:getHeight()/2))
    end

    if WINNER then 
        love.graphics.draw(winner_img, SCREEN_WIDTH/2 - (winner_img:getWidth()/2), SCREEN_HEIGHT/2 - (winner_img:getHeight()/2))

    end
end