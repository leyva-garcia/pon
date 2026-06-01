WINDOW_WIDTH = 1000
WINDOW_HEIGHT = 600

local player = {
    x = 100,
    y = WINDOW_HEIGHT / 2,
    width = 10,
    height = 100,
    speed = 300

}

local enemy = {
    x = 900,
    y = WINDOW_HEIGHT / 2,
    width = 10,
    height = 100,
    speed = 300
}

local ball = {
    x = WINDOW_WIDTH / 2,
    y = WINDOW_HEIGHT / 2,
    radius = 10,
    speedX = 0,
    speedY = 0
}


function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    math.randomseed(os.time())
end


function love.draw() 
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
    love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.width, enemy.height)
    love.graphics.circle("fill", ball.x, ball.y, ball.radius)
end

function love.update(dt)
    
    moveBall(dt)
    movePlayer(dt)
    moveEnemy(dt)
    checkWallCollission()

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

     --top boundery right paddle
    if enemy.y < 0 then
        enemy.y = 0
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

    

end    

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "return" then
        if math.random(2) == 1 then
            ball.speedX = 300
        else 
            ball.speedX = -300  
        end

        ball.speedY = math.random(-300, 300)
    end

end