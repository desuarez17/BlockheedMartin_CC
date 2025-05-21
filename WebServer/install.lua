--wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/main/WebServer/install.lua install.lua
sourse = "DesDEV"
print("Installing Webserver Program...")

print("Deleting old files...")

shell.run("delete /*")

print("Downloading new files...")

--main programs
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/"..sourse.."/WebServer/webServer.lua webServer.lua")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/ma"..sourse.."in/WebServer/startup.lua startup.lua")

--pages
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/"..sourse.."/WebServer/BlockheedMartinNet.txt BlockheedMartinNet.txt")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/"..sourse.."/WebServer/Catalog.txt Catalog.txt")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/"..sourse.."/WebServer/Service.txt Service.txt")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/"..sourse.."/WebServer/Mission.txt Mission.txt")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/"..sourse.."/WebServer/About.txt About.txt")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/"..sourse.."/WebServer/ABT_CrabbyWings15.txt ABT_CrabbyWings15.txt")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/"..sourse.."/WebServer/ABT_desuarez17.txt ABT_desuarez17.txt")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/"..sourse.."/WebServer/404.txt 404.txt")

--installer
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/"..sourse.."/WebServer/install.lua install.lua")

print("Downloading complete.")
print("Restarting Webserver...")
sleep(5)
shell.run("reboot")
