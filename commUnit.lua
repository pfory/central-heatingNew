--Init  
base = "/home/Corridor/esp06/"
deviceID = "ESP8266 CentralHeating "..node.chipid()

wifi.setmode(wifi.STATION)
wifi.sta.config("Datlovo","Nu6kMABmseYwbCoJ7LyG")
wifi.sta.autoconnect(1)

Broker="88.146.202.186"  
sendDelay = 60000 --ms

received = ""

pinLed = 4
gpio.mode(pinLed,gpio.OUTPUT)  
gpio.write(pinLed,gpio.LOW)  
tmr.delay(1000000)
gpio.write(pinLed,gpio.HIGH)  


heartBeat = node.bootreason()+10
print("Boot reason:"..heartBeat)

versionSW                  = "0.5"
versionSWString            = "Central Heating v" 
print(versionSWString .. versionSW)

function reconnect()
  print ("Waiting for Wifi")
  heartBeat = 20
  if wifi.sta.status() == 5 and wifi.sta.getip() ~= nil then 
    print ("Wifi Up!")
    tmr.stop(1) 
    m:connect(Broker, 31883, 0, function(conn) 
      print(wifi.sta.getip())
      print("Mqtt Connected to:" .. Broker) 
      mqtt_sub() --run the subscription function 
    end)
  end
end

m = mqtt.Client(deviceID, 180, "datel", "hanka12")  
m:lwt("/lwt", deviceID, 0, 0)  
m:on("offline", function(con)   
  print ("Mqtt Reconnecting...")   
  tmr.alarm(1, 10000, 1, function()  
    reconnect()
  end)
end)  

uart.on("data", 0,
  function(data)
    --print("receive from uart:", data)
    received = received..data
end, 0)

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function sendData()
  gpio.write(pinLed,gpio.LOW)
  m:publish(base.."HeartBeat",              heartBeat,0,0)  
  if heartBeat==0 then heartBeat=1
  else heartBeat=0
  end
  objProp = {}
  prikaz = ""
  received=trim(received)
  --received = "#0;54.06#1;44.38#2;27.38#3;11.06#4;40.00#5;52.88#6;11.31#7;72.25#8;11.06#9;48.25#I;57.19#O;70.50#R;1$*"
  if trim(received)~="" then 
    print(received)
    if string.find(received,"*")~=nil then 
      index = 1
      for value in string.gmatch(received,"\#%w?\;%d*[\.%d]*") do 
        objProp [index] = value
        prikaz = string.sub(value, 2, 2)
        if prikaz == "I" then
         tINKamna = string.sub(value, 4, 99)
        end
        if prikaz == "O" then
         tOUTKamna = string.sub(value, 4, 99)
        end
        if prikaz == "0" then
         t1 = string.sub(value, 4, 99)
        end
        if prikaz == "1" then
         t2 = string.sub(value, 4, 99)
        end
        if prikaz == "2" then
         t3 = string.sub(value, 4, 99)
        end
        if prikaz == "3" then
         t4 = string.sub(value, 4, 99)
        end
        if prikaz == "4" then
         t5 = string.sub(value, 4, 99)
        end
        if prikaz == "5" then
         t6 = string.sub(value, 4, 99)
        end
        if prikaz == "6" then
         t7 = string.sub(value, 4, 99)
        end
        if prikaz == "7" then
         t8 = string.sub(value, 4, 99)
        end
        if prikaz == "8" then
         t9 = string.sub(value, 4, 99)
        end
        if prikaz == "9" then
         t10 = string.sub(value, 4, 99)
        end
        if prikaz == "A" then
         t11 = string.sub(value, 4, 99)
        end
        if prikaz == "B" then
         t12 = string.sub(value, 4, 99)
        end

        if prikaz == "R" then
          --print(string.sub(value, 4, 4))
          if string.sub(value, 4, 4) == "1" then
            sPumpKamna = "ON"
          else
            sPumpKamna = "OFF"
          end
        end
        index = index + 1
      end
    end
  else 
    print("empty data")
    tINKamna=0
    tOUTKamna=0
    t1=0
    t2=0
    t3=0
    t4=0
    t5=0
    t6=0
    t7=0
    t8=0
    t9=0
    t10=0
    t11=0
    t12=0
    sPumpKamna="OFF"
  end
  print(tINKamna)
  print(tOUTKamna)
  print(sPumpKamna)
  print(t1)
  print(t2)
  print(t3)
  print(t4)
  print(t5)
  print(t6)
  print(t7)
  print(t8)
  print(t9)
  print(t10)
  print(t11)
  print(t12)
  print("I am sending data from Solar unit to OpenHab")
  received=""

  m:publish(base.."tINKamna",               string.format("%.1f",tINKamna),0,0)  
  m:publish(base.."tOUTKamna",              string.format("%.1f",tOUTKamna),0,0)  
  m:publish(base.."sPumpKamna",             sPumpKamna,0,0)  
  m:publish(base.."t1",                     string.format("%.1f",t1),0,0)  
  m:publish(base.."t2",                     string.format("%.1f",t2),0,0)  
  m:publish(base.."t3",                     string.format("%.1f",t3),0,0)  
  m:publish(base.."t4",                     string.format("%.1f",t4),0,0)  
  m:publish(base.."t5",                     string.format("%.1f",t5),0,0)  
  m:publish(base.."t6",                     string.format("%.1f",t6),0,0)  
  m:publish(base.."t7",                     string.format("%.1f",t7),0,0)  
  m:publish(base.."t8",                     string.format("%.1f",t8),0,0)  
  m:publish(base.."t9",                     string.format("%.1f",t9),0,0)  
  m:publish(base.."t10",                    string.format("%.1f",t10),0,0)  
  --m:publish(base.."t11",                    string.format("%.1f",t11),0,0)  
  --m:publish(base.."t12",                    string.format("%.1f",t12),0,0)  
  gpio.write(pinLed,gpio.HIGH)  
end


function mqtt_sub()  
  m:subscribe(base,0, function(conn)   
    print("Mqtt Subscribed to OpenHAB feed for device "..deviceID)  
  end)  
end

 -- on publish message receive event  
m:on("message", function(conn, topic, data)   
  print("Received:" .. topic .. ":" .. data) 
end)  

tmr.alarm(0, 5000, 1, function() 
  parseData()
end)

tmr.alarm(0, 1000, 1, function() 
  print ("Connecting to Wifi... ")
  if wifi.sta.status() == 5 and wifi.sta.getip() ~= nil then 
    print ("Wifi connected")
    tmr.stop(0) 
    m:connect(Broker, 31883, 0, function(conn) 
      mqtt_sub() --run the subscription function 
      print(wifi.sta.getip())
      print("Mqtt Connected to:" .. Broker.." - "..base) 
      m:publish(base.."VersionSWCentral",       versionSW,0,0)  
      m:publish(base.."HeartBeat",              heartBeat,0,0)  
      heartBeat=0
      tmr.alarm(0, sendDelay, tmr.ALARM_AUTO, function()
        sendData() 
      end)
    end) 
  end
end)