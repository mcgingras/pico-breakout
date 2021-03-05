pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function _init()
 cls()
	mode="start"
end

function _update60()
	if mode=="game" then update_game()
 elseif mode=="start" then update_start()
 else update_gameover()
 end
end

function update_start()
 if btn(5) then
 	startgame()
 end
end

function startgame()
	mode="game"
	ball_r=2
	ball_dr=1
	
	pad_x=45
	pad_y=120
	pad_w=24
	pad_h=2
	pad_dx=2.5
	pad_c=7
	
	lives=3
	points=0
	serveball()
end

function update_gameover()
 if btn(5) then
 	startgame()
 end
end

function update_game()
 local button_press=false
 local next_x,next_y
 
 if btn(0) then -- left
  pad_dx=-2.5 
  button_press=true
 end
 
 if btn(1) then -- right
  pad_dx=2.5
  button_press=true
 end
 
 if not(button_press) then
  pad_dx = pad_dx/1.3
 end
 
 pad_x+=pad_dx
	next_x = ball_x+ball_dx
	next_y = ball_y+ball_dy
	
	
	if next_x > 124 or next_x < 3 then
		next_x=mid(0,next_x,127)
		ball_dx = -ball_dx
		sfx(0)
	end
	
	if next_y < 10 then
		next_y=mid(0,next_y,127)
		ball_dy = -ball_dy
		sfx(0)
	end
	
	
	pad_c = 7
	if ball_box(next_x, next_y, pad_x, pad_y, pad_w, pad_h) then
		if deflx_ball_box(ball_x,ball_y,ball_dx,ball_dy,pad_x,pad_y,pad_w,pad_h) then
		 ball_dx = -ball_dx
		else
		 ball_dy = -ball_dy
		end
		sfx(1) 
		points+=1
	end
	
	ball_x = next_x
	ball_y = next_y
	
		-- hit the bottom, game ove
	if next_y > 127 then
	 sfx(2)
	 lives-=1
	 if lives<0 then
	  gameover()
	 else
	  serveball()
	 end
	end
end

function serveball()
 ball_x=10
	ball_dx=1
	ball_y=30
	ball_dy=1
end

function gameover()
 mode="gameover"
end

function _draw()
 if mode=="game" then draw_game()
 elseif mode=="start" then draw_start()
 else draw_gameover()
 end
end

function draw_start()
	cls(0)
	print("😐 breakout 😐", 35, 40, 7)
	print("press ❎ to start", 30, 70,11)
end

function draw_gameover()
 --cls()
 rectfill(0,60,128,77,0)
 print("game over",46,62,7)
 print("press ❎ to restart",27,69,6) 
end

function draw_game()
	cls(1)
	circfill(ball_x, ball_y, ball_r, 10)
	rectfill(pad_x, pad_y, pad_x+pad_w, pad_y+pad_h, pad_c)
 
 rectfill(0,0,128,6,0)
 print("lives:"..lives,1,1,7)
 print("score:"..points,40,1,7)
end

function ball_box(nx,ny, box_x, box_y, box_w, box_h)
 if ny-ball_r > box_y+box_h then return false end
 if ny+ball_r < box_y then return false end
 if nx-ball_r > box_x+box_w then return false end
 if nx+ball_r < box_x then return false end
 return true
end

function deflx_ball_box(rx,ry,rdx,rdy,bx,by,bw,bh)
 -- calculate wether to deflect the ball
 -- horizontally or vertically when it hits a box
 if rdx == 0 then
  -- moving vertically
  return false
 elseif rdy == 0 then
  -- moving horizontally
  return true
 else
  -- moving diagonally
  -- calculate slope
  local slp = rdy / rdx
  local cx, cy
  -- check variants
  if slp > 0 and rdx > 0 then
   -- moving down right
   debug1="q1"
   cx = bx-rx --box_x - ray_x
   cy = by-ry --box_y - ray_y
   if cx<=0 then
    return false
   elseif cy/cx < slp then
    return true
   else
    return false
   end
  elseif slp < 0 and rdx > 0 then
   debug1="q2"
   -- moving up right
   cx = bx-rx
   cy = by+bh-ry
   if cx<=0 then
    return false
   elseif cy/cx < slp then
    return false
   else
    return true
   end
  elseif slp > 0 and rdx < 0 then
   debug1="q3"
   -- moving left up
   cx = bx+bw-rx
   cy = by+bh-ry
   if cx>=0 then
    return false
   elseif cy/cx > slp then
    return false
   else
    return true
   end
  else
   -- moving left down
   debug1="q4"
   cx = bx+bw-rx
   cy = by-ry
   if cx>=0 then
    return false
   elseif cy/cx < slp then
    return false
   else
    return true
   end
  end
 end
 return false
end
__gfx__
00000000007007000070070000700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007007000070070000700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700007777000077770000777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000007777000077770000777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000078888700788887007888860000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070007aaaa7007aaaa7007aaaa60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008888000088870000788800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007007000070000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001836018360183501833018320183100d0000d0000d0000d0000d0000d0000d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100002436024360243502433024320243100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00060000234501f4501d4501b450194501645013450114500e4500c45009450064500445002450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
