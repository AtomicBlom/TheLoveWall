local colours = {
  ["patreon"] = colors.cyan,
  ["beam-sub"] = colors.red
}
lovelies = {}
monitor = peripheral.wrap("top")
concurrentLovelies = 5
title = "The Love Wall"
 
function marquee()
  monitor.setTextScale(2)
  local sizeX, sizeY = monitor.getSize()
  sizeX = sizeX
  sizeY = sizeY
  monitor.clear()
  monitor.setCursorPos(sizeX / 2 - string.len(title) / 2, 1)
  monitor.write(title)
 
  local lines = {}
  for i = 1, concurrentLovelies do
    local lovely = lovelies[math.random(#lovelies)]
 
    lines[i] = {
      ["lovely"] = lovely,
      ["pos"] = math.random(1, sizeX + 20),
      ["line"] = math.random(2, sizeY)
    }
   
    print (lines[i]["lovely"]["subscriber"].." on line "..lines[i]["line"])
  end    
    while(true) do
      for i = 1, concurrentLovelies do
        lines[i]["pos"] = lines[i]["pos"] - 1
        monitor.setCursorPos(
          lines[i]["pos"],
          lines[i]["line"]
        )
       
        if ((lines[i]["pos"] + string.len(lines[i]["lovely"]["subscriber"])) < -4) then
          monitor.clearLine()
          local valid = false
          while (valid ~= true) do
            valid = true
            local newLovely = {
              ["lovely"] = lovelies[math.random(#lovelies)],
              ["pos"] = math.random(sizeX, sizeX + 20),
              ["line"] = math.random(2, sizeY)            
            }

            for j = 1, #lovelies do
              if (j ~= i) then
                if (newLovely["lovely"]["subscriber"] == lines[j]["lovely"]["subscriber"]) then
                  print "Subscriber "..newLovely["lovely"]["subscriber].." is already on the screen"
                  valid = false
                end
                if (newLovely["line"] == lines[j]["line"]) then
                  print "There is already a subscriber on line "..newLovely["line"]
                  valid = false
                end
              end
            end

            if (valid) then
              lines[i] = newLovely
            end
            
          end
          print (lines[i]["lovely"]["subscriber"].." on line "..lines[i]["line"])
        end
       
        monitor.clearLine()
        monitor.setTextColor(colours[lines[i]["lovely"]["level"]])
        monitor.write(lines[i]["lovely"]["subscriber"])
      end
   
      sleep(0.5)
    end    
end
 
function readLovelyPeople()
  local hFile = fs.open("lovelyPeople", "r")
  if hFile then
    local line = hFile.readLine()
    local lineNum = 1
    while line ~= nil do
      local subscriber = split(line)
      lovelies[lineNum] = {
        ["subscriber"] = subscriber[1],
        ["level"] = subscriber[2]
      }
      lineNum = lineNum + 1          
      line = hFile.readLine()
    end
  end
  print("Found "..#lovelies.." lovelies")
end
 
function split(input)
  local sep = ","
  local t={} ; i = 1
  for str in string.gmatch(input, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end
 
readLovelyPeople()
for index, lovely in pairs(lovelies) do
  print(index..". "..lovely["subscriber"]..": "..lovely["level"])
end
 
marquee()
