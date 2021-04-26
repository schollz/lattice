-- lattice wip

lattice = include("lattice/lib/lattice")
engine.name = 'PolyPerc'

function init()
  -- basic lattice usage (uses defaults)
  my_lattice = lattice:new()
  my_lattice2 = lattice:new()

  pattern_a = my_lattice:new_pattern{
    action = function(t) 
	    print("swinging", util.round(clock.get_beats())) 
	    engine.amp(0.5)
	    engine.hz(440)
    end,
    division = 1/4
  }

  pattern_b = my_lattice2:new_pattern{
     action = function(t) 
	     print("4 on the floor", util.round(clock.get_beats())) 
     end,
     division = 1/4
  }

  -- demo stuff
  screen_dirty = true
  redraw_clock_id = clock.run(redraw_clock)
end

function key(k, z)
  if z == 0 then return end
  if k == 2 then
    print("start "..clock.get_beats())
    my_lattice:start()
    my_lattice2:start()
  elseif k == 3 then
    print("stop "..clock.get_beats())
    my_lattice:stop()
    my_lattice2:stop()
  elseif k == 1 then
    print("restart "..clock.get_beats())
    my_lattice:hard_restart()
    my_lattice2:hard_restart()
    print("restarted "..clock.get_beats())
  end

  -- more api

  -- global lattice controls
  -- my_lattice:stop()
  -- my_lattice:start()
  -- my_lattice:toggle()
  -- my_lattice:destroy()
  -- my_lattice:set_meter(7)

  -- individual pattern controls
  -- pattern_a:stop()
  -- pattern_a:start()
  -- pattern_a:toggle()
  -- pattern_a:destroy()
  -- pattern_a:set_division(1/7)
  -- pattern_a:set_action(function() print("change the action") end)

end

function enc(e, d)
  if e==1 then
    params:set("clock_tempo", params:get("clock_tempo") + d)
  else
    pattern_a.set_swing(util.clamp(pattern_a.swing+d,0,100))
  end
  screen_dirty = true
end

function cleanup()
  my_lattice:destroy()
end

-- screen stuff

function redraw_clock()
  while true do
    clock.sleep(1/15)
    if screen_dirty then
      redraw()
      screen_dirty = false
    end
  end
end

function redraw()
  screen.clear()
  screen.level(15)
  screen.aa(0)
  screen.font_size(8)
  screen.font_face(0)
  screen.move(1, 8)
  screen.text(params:get("clock_tempo") .. " BPM")
  screen.update()
end

function rerun()
  norns.script.load(norns.state.script)
end
