WINDOW_WIDTH = 1000
WINDOW_HEIGHT = 600

local player = {
    x = 100,
    y = WINDOW_HEIGHT / 2,
    width = 10,
    height = 100,
    speed = 300,
    score = 0
}

local enemy = {
    x = 900,
    y = WINDOW_HEIGHT / 2,
    width = 10,
    height = 100,
    speed = 300,
    score = 0
}

local ball = {
    x = WINDOW_WIDTH / 2,
    y = WINDOW_HEIGHT / 2,
    radius = 10,
    speedX = 0,
    speedY = 0
}

local scoreFont

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    math.randomseed(os.time())

    --love.graphics.setDefaultFilter("nearest", "nearest")
    scoreFont = love.graphics.newFont(40)
end


function love.draw() 
    love.graphics.setFont(scoreFont)

    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
    love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.width, enemy.height)
    love.graphics.circle("fill", ball.x, ball.y, ball.radius)
    love.graphics.rectangle("fill", WINDOW_WIDTH / 2, 0, 2, 600)

    love.graphics.print(player.score, WINDOW_WIDTH / 4, 30 )
    love.graphics.print(enemy.score, WINDOW_WIDTH * 3 / 4, 30 )
end

function love.update(dt)
    
    moveBall(dt)
    movePlayer(dt)
    moveEnemy(dt)
    checkWallCollission()

    if checkPaddleCollision(ball, player) then
        ball.x = player.x + player.width + ball.radius
        ball.speedX = math.abs(ball.speedX)
    end

    if checkPaddleCollision(ball, enemy) then
        ball.x = enemy.x - ball.radius
        ball.speedX = -math.abs(ball.speedX)
    end

    checkScore()

end

--Functions
--ball movement
function moveBall(dt)
    
    ball.x = ball.x + ball.speedX * dt
    ball.y = ball.y + ball.speedY * dt

end    

function checkWallCollission()
    --Top wall 
    if ball.y - ball.radius <= 0 then
       ball.y = ball.radius
       ball.speedY = -ball.speedY
    end
    --Bottom wall
    if ball.y + ball.radius >= 600 then
        ball.y = 600 - ball.radius
        ball.speedY = -ball.speedY
    end
end    

--Left paddle
function movePlayer(dt)
    --move player paddle to the right
    if love.keyboard.isDown("d") then 
        player.x = player.x + player.speed * dt
    end

    --move player paddle to the left
    if love.keyboard.isDown("a") then 
        player.x = player.x - player.speed * dt
      
    end
    if player.x < 0 then
        player.x = 0
    end

    if player.x > WINDOW_WIDTH / 4 then
        player.x = WINDOW_WIDTH / 4
    end
    if love.keyboard.isDown("w") then
        player.y = player.y - player.speed * dt
    end

    if love.keyboard.isDown("s") then
        player.y = player.y + player.speed * dt
    end

     --top boundery left paddle
    if player.y < 0 then
       player.y = 0
    end
    --bottom boundery left paddle

    if player.y > WINDOW_HEIGHT - player.height then
        player.y = WINDOW_HEIGHT - player.height
    end
end    


--Right paddle
function moveEnemy(dt)
    if love.keyboard.isDown("up") then
        enemy.y = enemy.y - enemy.speed * dt
    end

    if love.keyboard.isDown("down") then
        enemy.y = enemy.y + enemy.speed * dt
    end

    if love.keyboard.isDown("left") then
        enemy.x = enemy.x -  enemy.speed * dt
    end

    if love.keyboard.isDown("right") then
        enemy.x = enemy.x + enemy.speed * dt
    end

     --top boundery right paddle
    if enemy.y < 0 then
        enemy.y = 0
    end

    if enemy.x < WINDOW_WIDTH - 250 then
        enemy.x = WINDOW_WIDTH -250
    end

    if enemy.x > WINDOW_WIDTH - enemy.width then
        enemy.x = WINDOW_WIDTH - enemy.width
    end

    --bottom boundery right paddle
    if enemy.y > WINDOW_HEIGHT - enemy.height then
        enemy.y = WINDOW_HEIGHT - enemy.height
    end 

end

function checkPaddleCollision(ball, paddle)
    --Ball edges
    local ballLeft = ball.x - ball.radius
    local ballRight = ball.x + ball.radius
    local ballTop = ball.y - ball.radius
    local ballBottom = ball.y + ball.radius
    --Paddle edges
    local paddleLeft = paddle.x
    local paddleRight = paddle.x + paddle.width
    local paddleTop = paddle.y
    local paddleBottom = paddle.y + paddle.height

    if ballRight >= paddleLeft and
       ballLeft <= paddleRight and
       ballBottom >= paddleTop and
       ballTop <= paddleBottom then
        return true
    end 

    return false   

end    

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "return" then
        if math.random(2) == 1 then
            ball.speedX = 200
        else 
            ball.speedX = -200  
        end

        ball.speedY = math.random(-200, 200)
    end

end

function checkScore()
    --enemy scores if ball leaves left side
    if ball.x < 0 then
        enemy.score = enemy.score + 1
        resetBall()
    end
    --player scores if ball leaves right side
    if ball.x > WINDOW_WIDTH then
        player.score = player.score + 1
        resetBall()
    end
end    

function resetBall()
    ball.x = WINDOW_WIDTH / 2
    ball.y = WINDOW_HEIGHT / 2
    ball.speedX = 0
    ball.speedY = 0
end    