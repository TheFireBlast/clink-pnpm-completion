-- local inspect = require('inspect')
--TODO: use a better color library
local chalk = require('chalk')
--TODO: remove dependency 'tables'
local w = require('tables').wrap
local cache = require("cache"):new(10)
local JSON = require("JSON")
function JSON:assert() end -- silence JSON parsing errors

-- local function run_cmd(cmd)
--     assert(cmd and type(cmd) == "string" and #cmd > 0, "run_cmd: cmd param should be non-empty string")
--     local proc = io.popen(cmd .. " 2>nul")
--     if not proc then return "" end
--     local value = proc:read()
--     proc:close()
--     return value or nil
-- end

---@param matches string[]
---@param formatter fun(s: string):string
---@return table
local function format_matches(matches, formatter)
    local colorized = {}
    for _, m in ipairs(matches) do
        table.insert(colorized, { match = m, display = formatter(m) })
    end
    return colorized
end

---@param generator fun():string[]
---@param formatter fun(s: string):string
---@return fun():string
local function format_matches_factory(generator, formatter)
    return function()
        return format_matches(generator(), formatter)
    end
end

---@return string
local function get_root()
    local current = os.getcwd()
    local i = 0
    local count
    while not os.isdir(current .. "\\node_modules") do
        if i > 6 then
            current = os.getcwd()
            break
        end
        current, count = current:gsub("\\[^\\]+$", "")
        if count == 0 then
            current = os.getcwd()
            break
        end
        i = i + 1
    end
    return current
end

---@return string | nil
local function get_global_root()
    local local_appdata = os.getenv("LOCALAPPDATA")
    local dirs = os.globdirs(local_appdata .. "\\pnpm\\global\\*")
    if #dirs == 0 then return nil end
    return local_appdata .. "\\pnpm\\global\\" .. dirs[1]:gsub("\\$", "")
end

---@return table | nil
local function get_package_json()
    if cache:valid("get_package_json") then return cache:get("get_package_json") end

    local package_json = io.open(get_root() .. '\\package.json')
    if package_json == nil then return nil end
    local package_contents = package_json:read("*a")
    package_json:close()
    local package = JSON:decode(package_contents)
    if not package then return nil end

    cache:update("get_package_json", package)
    return package
end

---@return string[]
local function get_scripts()
    local pkg = get_package_json();
    if not pkg then return {} end
    return w(pkg.scripts):keys()
end

---@return string[]
local function get_dependencies()
    local pkg = get_package_json();
    if not pkg then return {} end
    local dependencies = {}

    if pkg.dependencies then
        for dep, _ in pairs(pkg.dependencies) do
            table.insert(dependencies, dep)
        end
    end
    if pkg.devDependencies then
        for dep, _ in pairs(pkg.devDependencies) do
            table.insert(dependencies, dep)
        end
    end

    return dependencies
end

---@return string[]
local function get_global_modules()
    if cache:valid("get_global_modules") then return cache:get("get_global_modules") end
    local modules = {}

    local global_root = get_global_root()
    if global_root then
        local global_modules = os.globdirs(global_root .. "\\node_modules\\*")
        for _, m in ipairs(global_modules) do
            modules[#modules + 1] = m:sub(1, -2)
        end
    end

    cache:update("get_dependencies_commands", modules)
    return modules
end

---@return string[]
local function get_dependencies_commands()
    if cache:valid("get_dependencies_commands") then return cache:get("get_dependencies_commands") end
    local bins = {}

    local bin_path = get_root() .. "\\node_modules\\.bin\\*"
    local files = os.globfiles(bin_path)
    for _, f in ipairs(files) do
        -- Ignores file names with a dot (eg. mocha.CMD and mocha.ps1) and returns the pure name (eg. mocha)
        if not f:find("%.") then
            bins[#bins + 1] = f
        end
    end

    cache:update("get_dependencies_commands", bins)
    return bins
end

--TODO: avoid repetition

local function get_all_local_modules()
    local hash = {}
    local modules = {}
    local dirs = os.globdirs(get_root() .. "\\node_modules\\.pnpm\\*")
    for _, mdir in ipairs(dirs) do
        -- Matches module name until @version
        local m = string.match(mdir, '(.+)@')
        if m then
            m = string.gsub(m, "+", "/")
            if not hash[m] then
                modules[#modules + 1] = m
                hash[m] = true
            end
        end
    end
    return modules
end

local function get_all_global_modules()
    local global_root = get_global_root()
    if global_root then
        local hash = {}
        local modules = {}
        local dirs = os.globdirs(global_root .. "\\.pnpm\\*")
        for _, mdir in ipairs(dirs) do
            -- Matches module name until @version
            local m = string.match(mdir, '(.+)@')
            if m then
                m = string.gsub(m, "+", "/")
                if not hash[m] then
                    modules[#modules + 1] = m
                    hash[m] = true
                end
            end
        end
        return modules
    end
    return {}
end

---Gets dependencies of local and global modules
---@return string[]
local function get_module_suggestions()
    if cache:valid("get_module_suggestions") then return cache:get("get_module_suggestions") end

    local hash = {}
    local modules = {}
    local function add(target)
        for _, m in ipairs(target) do
            if not hash[m] then
                modules[#modules + 1] = m
                hash[m] = true
            end
        end
    end

    -- Local modules include dependencies of project dependencies
    --TODO: exclude direct project dependencies
    add(get_all_local_modules())
    add(get_all_global_modules())

    cache:update("get_module_suggestions", modules)
    return modules
end

local remove_parser = clink.argmatcher():addflags({
    "-g" .. clink.argmatcher()
        :addarg(function()
            local m = get_global_modules()
            return m
        end)
        :loop(1)
}):addarg(get_dependencies):loop(1)

local run_parser = clink.argmatcher():addarg(format_matches_factory(get_scripts, chalk.style("blue bold")))
local exec_parser = clink.argmatcher():addarg(format_matches_factory(get_dependencies_commands, chalk.style("green bold")))
local why_parser = clink.argmatcher():addarg(get_all_local_modules)

local dir_parser = clink.argmatcher():addarg(clink.dirmatches)
local file_parser = clink.argmatcher():addarg(clink.filematches)

local filtering_options_flags = {
    "--changed-files-ignore-pattern" .. clink.argmatcher():addarg({}),
    "--filter" .. dir_parser,
    "--filter-prod" .. clink.argmatcher():addarg({}),
    "--test-pattern" .. clink.argmatcher():addarg({}),
}

local pnpm_general_flags = {
    "-h", "--help",
    "--color",
    "--no-color",
    "-C" .. dir_parser, "--dir" .. dir_parser,
    "-w", "--workspace-root",
    "--use-stderr",
    "--loglevel" .. clink.argmatcher():addarg({ "debug", "info", "warn", "error" }),
    "--aggregate-output",
    "--stream",
}

local add_parser = clink.argmatcher()
    :addflags({
        "-E", "--save-exact",
        "--no-save-exact",
        "--save-workspace-protocol",
        "--no-save-workspace-protocol",
        "-g", "--global",
        "--global-dir",
        "--ignore-scripts",
        "--offline",
        "--prefer-offline",
        "-r", "--recursive",
        "-D", "--save-dev",
        "-O", "--save-optional",
        "--save-peer",
        "-P", "--save-prod",
        "--store-dir" .. dir_parser,
        "--virtual-store-dir" .. dir_parser,
        "--workspace",
    }, pnpm_general_flags, filtering_options_flags)
    :addarg({ fromhistory = true, get_module_suggestions }):loop(1)

--TODO: support aliases (but don't show them as suggestions)
clink.argmatcher("pnpm")
    :addflags({ "-v", "--version" }, pnpm_general_flags)
    :addarg({
        nosort = true,
        "add" .. add_parser,
        "remove" .. remove_parser,
        "update" .. remove_parser,
        { match = "start", display = chalk.style("blue bold")("start") },
        { match = "test", display = chalk.style("blue bold")("test") },
        "run" .. run_parser,
        "exec" .. exec_parser,
        "dlx",
        format_matches_factory(get_scripts, chalk.style("blue bold")),
        --TODO: use same color as clink commands
        format_matches_factory(get_dependencies_commands, chalk.style("green bold")),
        "install",
        "install-test",
        "init",
        "create",
        "rebuild",
        "audit",
        "outdated",
        "list",
        "why" .. why_parser,
        "link",
        "unlink",
        "import",
        "prune",
        "pack",
        "publish",
        "root",
        "store" .. clink.argmatcher():addarg({ "add", "prune", "status" }),
    })

-- clink.suggester()
