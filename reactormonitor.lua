local w, h = term.getSize()

local turbine1Addr = "BigReactors-Turbine_1";
local reactor1Addr = "BigReactors-Reactor_4";
local turbine2Addr = "BigReactors-Turbine_2";
local reactor2Addr = "BigReactors-Reactor_3";
local standaloneReactorAddr = "BigReactors-Reactor_2";
local monitorAddr = "monitor_2";

-- Helper functions

function DrawBox(display, x1, y1, x2, y2, color)       
    display.setBackgroundColor(color)
    
    for y=y1,y2,1 do  
      display.setCursorPos(x1,y)
      for x=x1,x2,1 do        
        display.write(" ")
      end   
    end
end

-- Button functions

function toggleReactorOrTurbinePower(device)
  if device == nil then
    return
  else
    device.setActive(bool.reverse(device.getActive()))
  end
end

-- Turbine Stats Sections

function StatBlock_Turbine(display, xstart, ystart, turbineAddr, turbineName)
  local turbine = peripheral.wrap(turbineAddr)
  local bgColor = colors.gray
  local fgColor = colors.white
  local titleColor = colors.blue
  local width = 30

  if turbine==nil then
    bgColor = colors.red
    fgColor = colors.white
  else
    if turbine.getActive()==true then
      bgColor = colors.green
      fgColor = colors.white
    end
  end
    
  DrawBox(display, xstart, ystart, xstart+width, ystart+15, bgColor)
  DrawBox(display, xstart, ystart, xstart+width, ystart, titleColor)
  display.setCursorPos(xstart,ystart) 
  display.write(turbineName) 
  display.setTextColor(fgColor)
  display.setBackgroundColor(bgColor)

  display.setCursorPos(xstart,ystart+1)
  
  if (turbine == nil) then
    display.write("Turbine not found at address: ")
    display.setCursorPos(xstart, ystart+2)
    display.write(turbineAddr)
    return
  end

  if turbine.getActive() == true then
    display.write("Turbine is:          ON")
  else 
    display.write("Turbine is:          OFF")
  end

  display.setCursorPos(xstart, ystart+2)
  display.write("RF/t:                ")
  display.write(string.format("%i",turbine.getEnergyProducedLastTick()))
  
  display.setCursorPos(xstart, ystart+3)
  if turbine.getInductorEngaged() == true then
    display.write("Inductor is:         ENGAGED")
  else 
    display.write("Inductor is:         DISENGAGED")
  end

  display.setCursorPos(xstart, ystart+4)
  display.write("Energy Stored:       ")
  display.write(string.format("%i%%",((turbine.getEnergyStored()/1000000)*100))) -- make this a percent

  display.setCursorPos(xstart, ystart+5)
  display.write("Rotor Speed:         ")
  display.write(string.format("%i",turbine.getRotorSpeed()))

  display.setCursorPos(xstart, ystart+6)
  display.write("Steam Flow Rate:     ")
  display.write(string.format("%i",turbine.getFluidFlowRate()))

  display.setCursorPos(xstart, ystart+7)
  display.write("Steam Input buffer:  ")
  display.write(string.format("%i",turbine.getInputAmount()))

  display.setCursorPos(xstart, ystart+8)
  display.write("Steam Output buffer: ")
  display.write(string.format("%i",turbine.getOutputAmount()))
  
end

function StatBlock_TurbineReactor(display, xstart, ystart, reactorAddr, reactorName)
  local reactor = peripheral.wrap(reactorAddr)
  local bgColor = colors.gray
  local fgColor = colors.white
  local titleColor = colors.blue
  local width = 30

  if reactor==nil then
    bgColor = colors.red
    fgColor = colors.white
  else
    if reactor.getActive()==true then
      bgColor = colors.green
      fgColor = colors.white
    end
  end
    
  DrawBox(display, xstart, ystart, xstart+width, ystart+25, bgColor)
  DrawBox(display, xstart, ystart, xstart+width, ystart, titleColor)
  display.setCursorPos(xstart,ystart) 
  display.write(reactorName) 
  display.setTextColor(fgColor)
  display.setBackgroundColor(bgColor)

  
  display.setCursorPos(xstart,ystart+1)
  
   if (reactor == nil) then
    display.write("Reactor not found at address: ")
    display.setCursorPos(xstart, ystart+2)
    display.write(reactorAddr)
    return
  end

  if reactor.getActive() == true then
    display.write("Reactor is:          ON")
  else 
    display.write("Reactor is:          OFF")
  end

  display.setCursorPos(xstart, ystart+2)
  display.write("Steam mb/t:          ")
  display.write(reactor.getHotFluidProducedLastTick())

  display.setCursorPos(xstart, ystart+3)
  display.write("Casing Temperature:  ")
  display.write(string.format("%i°",reactor.getCasingTemperature()))

  display.setCursorPos(xstart, ystart+4)
  display.write("Fuel Temperature:    ")
  display.write(string.format("%i°",reactor.getFuelTemperature()))
  
  display.setCursorPos(xstart, ystart+5)
  display.write("Fuel consumed /t:    ")
  local fpt = math.floor(reactor.getFuelConsumedLastTick() * 10000)/10000
  display.write(fpt)
  
  -- ingots per  tick
  display.setCursorPos(xstart, ystart+6)
  display.write(" Ingots / 24hr:      ")
  local ipt = string.format("%i",((fpt / 1000) * 20 * 60 * 60 * 24))
  display.write(ipt)

  display.setCursorPos(xstart, ystart+7)
  display.setTextColor(fgColor)
  display.write("Control Rods:")
  local rodY = ystart+8
  for i=0,reactor.getNumberOfControlRods()-1,1
  do
    display.setCursorPos(xstart + 3,rodY)
    display.write(" ")
    display.write(string.format("%i",i))
    display.write(": ")
    display.write(reactor.getControlRodLevel(i))
    display.write("%")
    rodY = rodY + 1
  end
end

function fullTurbineStats(display, xstart, ystart, turbineName, turbineAddr, reactorAddr)
  local ypos = ystart
  local xpos = xstart
  local width = 30
  local bgColor = colors.blue
  local fgColor = colors.white

  DrawBox(display, xpos, ypos, xpos+width, ypos+2, bgColor)
  display.setCursorPos(xpos,ypos)
  display.setBackgroundColor(bgColor)
  display.setTextColor(fgColor)
      
  display.write(turbineName)
  display.setCursorPos(xpos,ypos+1)
  display.write("==============================")
 
  StatBlock_Turbine(display, xpos,3 , turbineAddr, turbineName .. " Turbine")
  StatBlock_TurbineReactor(display, xpos, 13, reactorAddr, turbineName .. " Reactor")        
end


function StatBlock_Reactor(display,xstart, ystart, reactorName, reactorAddr)
  local reactor = peripheral.wrap(reactorAddr)
  local bgColor = colors.gray
  local fgColor = colors.white
  local titleColor = colors.blue
  local width = 30

  if reactor==nil then
    bgColor = colors.red
    fgColor = colors.white
  else
    if reactor.getActive()==true then
      bgColor = colors.green
      fgColor = colors.white
    end
  end
    
  DrawBox(display, xstart, ystart, xstart+width, ystart+25, bgColor)
  DrawBox(display, xstart, ystart, xstart+width, ystart, titleColor)
  display.setCursorPos(xstart,ystart) 
  display.write(reactorName) 
  display.setTextColor(fgColor)
  display.setBackgroundColor(bgColor)

  
  display.setCursorPos(xstart,ystart+1)
  
   if (reactor == nil) then
    display.write("Reactor not found at address: ")
    display.setCursorPos(xstart, ystart+2)
    display.write(reactorAddr)
    return
  end

  if reactor.getActive() == true then
    display.write("Reactor is:          ON")
  else 
    display.write("Reactor is:          OFF")
  end


  display.setCursorPos(xstart, ystart+2)
  display.write("RF/t:                ")
  display.write(string.format("%i",reactor.getEnergyProducedLastTick()))
  
  display.setCursorPos(xstart, ystart+3)
  display.write("Energy Stored:       ")
  display.write(string.format("%i%%",((reactor.getEnergyStored()/10000000)*100))) -- make this a percent
  
  display.setCursorPos(xstart, ystart+4)
  display.write("Fuel consumed /t:    ")
  local fpt = math.floor(reactor.getFuelConsumedLastTick() * 10000)/10000
  display.write(fpt)
  
  -- ingots per  tick
  display.setCursorPos(xstart, ystart+5)
  display.write(" Ingots / 24hr:      ")
  local ipt = string.format("%i",((fpt / 1000) * 20 * 60 * 60 * 24))
  display.write(ipt)

  display.setCursorPos(xstart, ystart+6)
  display.write("Casing Temperature:  ")
  display.write(string.format("%i°",reactor.getCasingTemperature()))

  display.setCursorPos(xstart, ystart+7)
  display.write("Fuel Temperature:    ")
  display.write(string.format("%i°",reactor.getFuelTemperature()))
  
  display.setCursorPos(xstart, ystart+8)
  display.write("Fuel Reactivity:     ")
  display.write(string.format("%i%%",reactor.getFuelReactivity()))

  display.setCursorPos(xstart, ystart+9)
  display.setTextColor(fgColor)
  display.write("Control Rods:")
  local rodY = ystart+10
  for i=0,reactor.getNumberOfControlRods()-1,1
  do
    display.setCursorPos(xstart + 3,rodY)
    display.write(" ")
    display.write(string.format("%i",i))
    display.write(": ")
    display.write(reactor.getControlRodLevel(i))
    display.write("%")
    rodY = rodY + 1
  end
end

function initScreen(display)
  display.setBackgroundColor(colors.black)
  display.setTextColor(colors.white)
  display.clear()
  display.setCursorPos(1,1)  
  display.setTextScale(0.5)
end

function updateScreen(display)
  fullTurbineStats(display,1,1,"Turbine 1", turbine1Addr,reactor1Addr)  
  fullTurbineStats(display,35,1,"Turbine 2", turbine2Addr, reactor2Addr)
  StatBlock_Reactor(display,69,13,"Passively Cooled Reactor", standaloneReactorAddr)
end

-- Initialize peripherals
local mon = peripheral.wrap(monitorAddr)

-- Initialize the monitor
initScreen(mon);

-- Main loop functions

-- This function is the starting point for all screen refreshes
function refreshLoop()
  --while true do
    write(os.time())
    print(": Updating screens...")
    updateScreen(mon)
    sleep(5)
  --end
end

-- This function is the starting point for all input
function inputLoop()
  event, side, xPos, yPos = os.pullEvent("monitor_touch")
  write("X:" .. xPos .. ", Y: " .. yPos)
  -- Need to somehow detect buttons and what they do
  -- Perhaps keep an arraylist of coordinates and device names
end

-- Here is the main loop, which runs the screen refresh method adn the input method
-- each in their own seperate thread, so they don't block eachother.
while true do
  -- As a side effect, this means whenever the screen is touched, it refreshes
  parallel.waitForAny(refreshLoop, inputLoop)
end



