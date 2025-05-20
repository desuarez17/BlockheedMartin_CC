print("Installing Webserver Program...")

print("Deleting old files...")

shell.run("delete webServer.lua")
shell.run("delete startup.lua")

print("Downloading new files...")
shell.run("wget https://github.com/desuarez17/BlockheedMartin_CC/tree/DesDEV/WebServerr/webServer.lua webServer.lua")
shell.run("wget https://github.com/desuarez17/BlockheedMartin_CC/tree/DesDEV/WebServer/startup.lua startup.lua")
shell.run("wget https://github.com/desuarez17/BlockheedMartin_CC/tree/DesDEV/WebServer/BlockheedMartinNet.txt BlockheedMartinNet.txt")
shell.run("wget https://github.com/desuarez17/BlockheedMartin_CC/tree/DesDEV/WebServerr/install.lua install.lua")

print("Downloading complete.")
print("Restarting Webserver...")
sleep(5)
shell.run("reboot")
