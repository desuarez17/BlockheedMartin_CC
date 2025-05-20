
-- Blockheed Martin CC Updater
-- Version: 1.0.0

---Just for copy paste purposes, this is not a real file. This is just a placeholder for the code to be copied into.

local url = "https://raw.githubusercontent.com/user/repo/branch/path/to/script.lua"
local versionUrl = "https://raw.githubusercontent.com/user/repo/branch/path/to/version.txt"
local filename = shell.getRunningProgram()
local currentVersion = "1.0.0" -- change this to your current version

local function fetch(url)
    local response = http.get(url)
    if response then
        local content = response.readAll()
        response.close()
        return content
    end
    return nil
end

local function update()
    local latestVersion = fetch(versionUrl)

    if latestVersion and latestVersion:gsub("%s+", "") ~= currentVersion then
        print("New version available: "..latestVersion)
        local newScript = fetch(url)

        if newScript then
            local file = fs.open(filename, "w")
            file.write(newScript)
            file.close()

            print("Updated to version: "..latestVersion..". Restarting...")
            sleep(1)
            shell.run(filename)
        else
            print("Update failed: Couldn't fetch new script.")
        end
    else
        print("Already up-to-date (version "..currentVersion..")")
    end
end

update()
