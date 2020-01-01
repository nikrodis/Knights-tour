local N = 32
local N_Block = 0 -- Блоки не работают, так что 0
local CenterX = 16;
local CenterY = 65;
local SizeBox = love.graphics.getWidth() / (N + N / 8);
local Board = {}
local Board_Val = {}

function ChessBoard(x, y)
  love.graphics.setColor(0, 0, 0, 1);
  love.graphics.setLineWidth(1)
  love.graphics.rectangle("line", CenterX + (SizeBox * x), CenterY + (SizeBox * y), SizeBox, SizeBox);
end

function DrawObj(x, y)
  love.graphics.setColor(0, 0, 0, 1);
  if Board[x * N + y] == 'K' then
    love.graphics.circle('fill', CenterX + SizeBox / 2 + (SizeBox * x), CenterY + SizeBox / 2 + (SizeBox * y), SizeBox / 4);
  elseif Board[x * N + y] == 'B' then
    love.graphics.rectangle("fill", CenterX + SizeBox / 4 + (SizeBox * x), CenterY + SizeBox / 4 + (SizeBox * y), SizeBox / 2, SizeBox / 2)
  elseif Board[x * N + y] == '#' then
    love.graphics.circle('line', CenterX + SizeBox / 2 + (SizeBox * x), CenterY + SizeBox / 2 + (SizeBox * y), SizeBox / 4);
  end
end

function NextStep()
  local min = 9

  for i_val = -2, 2 do
    for j_val = -2, 2 do
      if math.abs(i_val) ~= math.abs(j_val) and
      i_val ~= 0 and j_val ~= 0 and
      ki + i_val >= 0 and ki + i_val <= N - 1 and
      kj + j_val >= 0 and kj + j_val <= N - 1 and
      Board_Val[(ki + i_val) * N + (kj + j_val)] ~= 0 and
      Board_Val[(ki + i_val) * N + (kj + j_val)] < min then
        min = Board_Val[(ki + i_val) * N + (kj + j_val)];
        new_ki, new_kj = ki + i_val, kj + j_val;
      end
    end
  end

  old_ki, old_kj = ki, kj;
  ki, kj = new_ki, new_kj;
  Board_Val[ki * N + kj] = 0;
  Board[ki * N + kj] = 'K';
  Board[old_ki * N + old_kj] = '#';

  if ki == old_ki or kj == old_kj then
    local pressedbutton = love.window.showMessageBox("Error", "Vse ochen ploho", { "Exit", "Restart", "Nothing" })
    if (pressedbutton == 1) then
      love.event.quit()
    elseif (pressedbutton == 2) then
      love.load()
    end
  end

  for i_val = -2, 2 do
    for j_val = -2, 2 do
      if math.abs(i_val) ~= math.abs(j_val) and
      i_val ~= 0 and j_val ~= 0 and
      old_ki + i_val >= 0 and old_ki + i_val <= N - 1 and
      old_kj + j_val >= 0 and old_kj + j_val <= N - 1 and
      Board_Val[(old_ki + i_val) * N + (old_kj + j_val)] ~= 0 then
        Board_Val[(old_ki + i_val) * N + (old_kj + j_val)] = Board_Val[(old_ki + i_val) * N + (old_kj + j_val)] - 1
      end
    end
  end

  Step = Step + 1
end
function love.load()
  Step = 1
  love.graphics.setBackgroundColor(1 / 255 * 51, 1 / 255 * 153, 1 / 255 * 102);

  for i = 0, N - 1 do
    for j = 0, N - 1 do
      Board[i * N + j] = '*'
      Board_Val[i * N + j] = 0
    end
  end

  for i = 1, N_Block do
    repeat
      bi = love.math.random(0, N - 1)
      bj = love.math.random(0, N - 1)
    until Board[bi * N + bj] ~= 'B'
    Board[bi * N + bj] = 'B'
  end

  while true do
    ki = love.math.random(0, N - 1)
    kj = love.math.random(0, N - 1)
    if Board[ki * N + kj] ~= 'B' then
      Board[ki * N + kj] = 'K'
      break
    end
  end

  for i = 0, N - 1 do
    for j = 0, N - 1 do
      for i_val = -2, 2 do
        for j_val = -2, 2 do
          if i + i_val > -1 and i + i_val < N and
          j + j_val > -1 and j + j_val < N and
          Board[(i + i_val) * N + j + j_val] ~= 'B' and Board[i * N + j] ~= 'B' and
          math.abs(i_val) ~= math.abs(j_val) and
          i_val ~= 0 and j_val ~= 0 and
          (i ~= ki or j ~= kj)
          then
            Board_Val[i * N + j] = Board_Val[i * N + j] + 1
          end
        end
      end
    end
  end

  --	for key, val in pairs(Board_Val) do
  --		print("key == " .. key .. "; val == " .. val)
  --	end
end

function love.keypressed(keyCode)
  if (keyCode == "escape") then
    local pressedbutton = love.window.showMessageBox("Exit or Restart", "What do you want?", { "Exit", "Restart", "Nothing" })
    if (pressedbutton == 1) then
      love.event.quit()
    elseif (pressedbutton == 2) then
      love.load()
    end
  end
end

function love.update()
end

function love.draw()
  for i = 0, N - 1 do
    for j = 0, N - 1 do
      ChessBoard(i, j)
      DrawObj(i, j)
      --love.graphics.print(Board_Val[i * N + j], CenterX + SizeBox / 4 + (SizeBox * i), CenterY + SizeBox / 8 + (SizeBox * j), 0, 2)
    end
  end

  if love.mouse.isDown(1) and Step < N * N then
    NextStep()
  elseif love.mouse.isDown(2) then
    love.load()
  end
end