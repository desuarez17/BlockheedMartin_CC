print("Installing Webserver Program...")

print("Deleting old files...")

shell.run("delete /*")

print("Downloading new files...")

--main programs
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/main/WebServer/webServer.lua webServer.lua")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/main/WebServer/startup.lua startup.lua")

--pages
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/main/WebServer/BlockheedMartinNet.txt BlockheedMartinNet.txt")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/main/WebServer/Catalog.txt Catalog.txt")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/main/WebServer/Service.txt Service.txt")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/main/WebServer/Mission.txt Mission.txt")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/main/WebServer/About.txt About.txt")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/main/WebServer/ABT_Crabby.txt ABT_Crabby.txt")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/main/WebServer/ABT_desuarez17.txt ABT_desuarez17.txt")
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/main/WebServer/404.txt 404.txt")

--installer
shell.run("wget https://raw.githubusercontent.com/desuarez17/BlockheedMartin_CC/refs/heads/main/WebServer/install.lua install.lua")

print("Downloading complete.")
print("Restarting Webserver...")
sleep(5)
shell.run("reboot")
