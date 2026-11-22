local version = {}

local function parseVersion(versionString)
    return versionString and versionString:match('%d+%.%d+%.%d+') or versionString
end

local function padVersion(versionString)
    local parts = {}
    for num in versionString:gmatch('%d+') do
        parts[#parts + 1] = tonumber(num)
    end
    while #parts < 3 do
        parts[#parts + 1] = 0
    end
    return parts
end

local function compareVersions(v1, v2)
    local a, b = padVersion(v1), padVersion(v2)
    for i = 1, 3 do
        if a[i] < b[i] then
            return -1
        elseif a[i] > b[i] then
            return 1
        end
    end
    return 0
end

local function buildPatchNotesUrl(branch, repoPath)
    local username, reponame = repoPath:match('([^/]+)/([^/]+)')
    return ('https://raw.githubusercontent.com/%s/%s/%s/resources.json'):format(username, reponame, branch)
end

local function getDownloadUrl(repoPath, isTebex, actualRepoPath)
    if isTebex then
        return 'https://portal.cfx.re/assets/granted-assets'
    end

    if actualRepoPath then
        local username, reponame = actualRepoPath:match('([^/]+)/([^/]+)')
        if username and reponame then
            return ('https://github.com/%s/%s/releases/latest'):format(username, reponame)
        end
    end

    return nil
end

local function printUpdateAvailable(resource, localVersion, downloadUrl)
    print(('^1An update is available for %s (current version: %s)\r\n - ^5Please download the latest version from %s^7'):format(resource, localVersion, downloadUrl))
end

local function printPatchNotes(notesToPrint)
    print('^3Patch Notes:^7')
    for _, entry in ipairs(notesToPrint) do
        print(('^2Version %s:^7'):format(entry.version))
        for _, line in ipairs(entry.notes) do
            print((' - %s'):format(line))
        end
    end
end

local function validateRepoPath(repoPath)
    local username, reponame = repoPath:match('([^/]+)/([^/]+)')
    if not username or not reponame then return false end
    return true, username, reponame
end

local function getLocalVersion(resource)
    local raw = GetResourceMetadata(resource, 'version', 0)
    if not raw then return nil end
    return parseVersion(raw)
end

local function processVersions(allVersions, localVersion)
    local notesToPrint = {}

    for versionString, notes in pairs(allVersions) do
        if compareVersions(versionString, localVersion) > 0 and type(notes) == 'table' then
            notesToPrint[#notesToPrint + 1] = { version = versionString, notes = notes }
        end
    end

    table.sort(notesToPrint, function(a, b)
        return compareVersions(a.version, b.version) < 0
    end)

    return notesToPrint
end

local function fetchPatchNotes(branch, resource, repoPath, localVersion)
    local url = buildPatchNotesUrl(branch, repoPath)

    PerformHttpRequest(url, function(status, body)
        if status == 200 then
            local patchData = json.decode(body)
            if not patchData then return end

            local resourceData = patchData[resource]
            if not resourceData or type(resourceData) ~= 'table' then return end

            local actualRepoPath = resourceData.repo or resourceData.actualRepoPath
            local isTebex = not actualRepoPath
            local allVersions = resourceData.versions or resourceData
            local notesToPrint = processVersions(allVersions, localVersion)

            if #notesToPrint > 0 then
                local downloadUrl = getDownloadUrl(repoPath, isTebex, actualRepoPath) or url
                printUpdateAvailable(resource, localVersion, downloadUrl)
                printPatchNotes(notesToPrint)
            end
        elseif branch == 'main' then
            fetchPatchNotes('master', resource, repoPath, localVersion)
        end
    end, 'GET')
end

function version.VersionChecker(repoPath, tebex)
    local isValid, username, reponame = validateRepoPath(repoPath)
    if not isValid then return print('^1Invalid repository format. Expected "username/reponame"^0') end

    local resource = GetCurrentResourceName()
    local localVersion = getLocalVersion(resource)
    if not localVersion then return end

    PerformHttpRequest(('https://api.github.com/repos/%s/%s/releases/latest'):format(username, reponame), function(status, body)
        if status ~= 200 then return end

        local data = json.decode(body)
        local latest = data and data.tag_name and data.tag_name:match('%d+%.%d+%.%d+')
        if not latest or compareVersions(latest, localVersion) <= 0 then return end

        local url = tebex and 'https://portal.cfx.re/assets/granted-assets' or data.html_url
        printUpdateAvailable(resource, localVersion, url)
    end, 'GET')
end

function version.AdvancedVersionChecker(repoPath, resourceName)
    local isValid = validateRepoPath(repoPath)
    if not isValid then return print('^1Invalid repository format. Expected "username/reponame"^0') end

    local resource = resourceName or GetCurrentResourceName()
    local localVersion = getLocalVersion(resource)
    if not localVersion then
        return print(('^1No valid version metadata found for %s^0'):format(resource))
    end

    fetchPatchNotes('main', resource, repoPath, localVersion)
end

return version
