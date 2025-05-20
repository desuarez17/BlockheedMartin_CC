print("Installing Webserver Program...")

print("Deleting old files...")

shell.run("delete WebServer.lua")
shell.run("delete startup.lua")
shell.run("BlockheedMartinNet.txt")
shell.run("delete install.lua")

print("Downloading new files...")

shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/main/WebServer/WebServer.lua WebServer.lua")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/main/WebServer/startup.lua startup.lua")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/main/WebServer/BlockheedMartinNet.txt BlockheedMartinNet.txt")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/main/WebServer/install.lua install.lua")

print("Downloading complete.")
print("Restarting Webserver...")
sleep(5)
shell.run("reboot")
