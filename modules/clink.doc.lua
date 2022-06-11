---@alias file unknown
---@alias coroutine unknown
---@alias choices {nosort: boolean, fromhistory: true}

---@class argmatcher
local argmatcher = {}

---This
--- adds argument matches.  Arguments can be a string, a string linked to 
---another parser by the concatenation operator, a table of arguments, or a
--- function that returns a table of arguments.  See Argument Completion for more information.
---@vararg string | choices
---@return argmatcher
function argmatcher:addarg(...) end
---This is the same as _argmatcher:addarg except that this disables sorting the matches.
---@vararg string | choices
---@return argmatcher
function argmatcher:addargunsorted(...) end
---Adds
--- descriptions for arg matches and/or flag matches.  Descriptions are 
---displayed for their associated args or flags whenever possible 
---completions are listed, for example by the complete or clink-select-complete or possible-completions commands.
---@vararg table
---@return argmatcher
function argmatcher:adddescriptions(...) end
---This
--- adds flag matches.  Flags are separate from arguments:  When listing 
---possible completions for an empty word, only arguments are listed.  But 
---when the word being completed starts with the first character of any of 
---the flags, then only flags are listed.  See Argument Completion for more information.
---@vararg string
---@return argmatcher
function argmatcher:addflags(...) end
---This is the same as _argmatcher:addflags except that this also disables sorting for flags.
---@vararg string
---@return argmatcher
function argmatcher:addflagsunsorted(...) end
---This makes the rest of the line be parsed as a separate command.  You can use it to "chain" from one parser to another.
---@return argmatcher
function argmatcher:chaincommand() end
---This hides the specified flags when displaying possible completions (the flags are still recognized).
---@vararg string
---@return argmatcher
function argmatcher:hideflags(...) end
---This makes the parser loop back to argument position index when it runs out of positional sets of arguments (if index is omitted it loops back to argument position 1).
---@param index? integer
---@return argmatcher
function argmatcher:loop(index) end
---This makes the parser prevent invoking match generators.  You can use it to "dead end" a parser and suggest no completions.
---@return argmatcher
function argmatcher:nofiles() end
---Resets
--- the argmatcher to an empty state.  All flags, arguments, and settings 
---are cleared and reset back to a freshly-created state.
---@return argmatcher
function argmatcher:reset() end
---This
--- registers a function that gets called for each word the argmatcher 
---handles, to classify the word as part of coloring the input text.  See Coloring the Input Text for more information.
---@param func function
---@return argmatcher
function argmatcher:setclassifier(func) end
---This registers a function that gets called the first time the argmatcher is used in each edit line session.  See Adaptive Argmatchers for more information.
---@param func function
---@return argmatcher
function argmatcher:setdelayinit(func) end
---When endofflags is a string, it is a special flag that signals the end of flags.  When endflags is true or nil, then "--" is used as the end of flags string. Otherwise, the end of flags string is cleared.
---@param endofflags? string | boolean
---@return argmatcher
function argmatcher:setendofflags(endofflags) end
---This is almost never needed, because :addflags() automatically identifies flag prefix characters.
---@vararg string
---@return argmatcher
function argmatcher:setflagprefix(...) end
---When anywhere
--- is false, flags are only recognized until an argument is encountered.  
---Otherwise they are recognized anywhere (which is the default).
---@param anywhere boolean
---@return argmatcher
function argmatcher:setflagsanywhere(anywhere) end

---@class builder
local builder = {}

---Adds a match.
---@param match string | table
---@param type? string
---@return boolean
function builder:addmatch(match, type) end
---This is the equivalent of calling builder:addmatch() in a for-loop. Returns the number of matches added and a boolean indicating if all matches were added successfully.
---@param matches table
---@param type? string
---@return integer, boolean
function builder:addmatches(matches, type) end
---Returns whether the match builder is empty.  It is empty when no matches have been added yet.
---@return boolean
function builder:isempty() end
---Sets character to append after matches.  For example the set match generator uses this to append "=" when completing matches, so that completing set USER becomes set USERDOMAIN= (rather than set USERDOMAIN ).
---@param append? string
---@return nil
function builder:setappendcharacter(append) end
---Turns off sorting the matches.
---@return nil
function builder:setnosort() end
---Sets
--- whether to suppress appending anything after the match except a 
---possible closing quote.  For example the env var match generator uses 
---this.
---@param state? boolean
---@return nil
function builder:setsuppressappend(state) end
---Sets
--- whether to suppress quoting for the matches.  Set to 0 for normal 
---quoting, or 1 to suppress quoting, or 2 to suppress end quotes.  For 
---example the env var match generator sets this to 1 to overcome the 
---quoting that would normally happen for "%" characters in filenames.
---@param state? integer
---@return nil
function builder:setsuppressquoting(state) end
---@class console
local console = {}

---Returns the count of visible character cells that would be consumed if the text string were output to the console, accounting for any ANSI escape codes that may be present in the text.
---@param text string
---@return integer
function console.cellcount(text) end
---Searches downwards (forwards) for a line containing the specified text and/or attributes, starting at line starting_line. The matching line number is returned, or 0 if no matching line is found.
---@param starting_line integer
---@param text? string
---@param mode? string
---@param attr? integer
---@param attrs? table of integers
---@param mask? string
---@return integer
function console.findnextline(starting_line, text, mode, attr, attrs, mask) end
---Searches upwards (backwards) for a line containing the specified text and/or attributes, starting at line starting_line.  The matching line number is returned, or 0 if no matching line is found, or -1 if an invalid regular expression is provided.
---@param starting_line integer
---@param text? string
---@param mode? string
---@param attr? integer
---@param attrs? table of integers
---@param mask? string
---@return integer
function console.findprevline(starting_line, text, mode, attr, attrs, mask) end
---Returns the number of visible lines of the console screen buffer.
---@return integer
function console.getheight() end
---Returns the text from line number line, from 1 to console.getnumlines().
---@param line integer
---@return string
function console.getlinetext(line) end
---Returns the total number of lines in the console screen buffer.
---@return integer
function console.getnumlines() end
---Returns the console title text.
---@return string
function console.gettitle() end
---Returns the current top line (scroll position) in the console screen buffer.
---@return integer
function console.gettop() end
---Returns the width of the console screen buffer in characters.
---@return integer
function console.getwidth() end
---Returns whether line number line uses only the default text color.
---@param line integer
---@return boolean
function console.islinedefaultcolor(line) end
---Returns whether line number line contains the DOS color code attr, or any of the DOS color codes in attrs (either an integer or a table of integers must be provided, but not both).  mask is optional and can be "fore" or "back" to only match foreground or background colors, respectively.
---@param line integer
---@param attr? integer
---@param attrs? table of integers
---@param mask? string
---@return boolean
function console.linehascolor(line, attr, attrs, mask) end
---Returns the input text
--- with ANSI escape codes removed, and the count of visible character 
---cells that would be consumed if the text were output to the console.
---@param text string
---@return string, integer
function console.plaintext(text) end
---Reads one key sequence from the console input.  If no input is available, it waits until input becomes available.
---@return string | nil
function console.readinput() end
---Uses
--- the provided Lua string patterns to collect text from the current 
---console screen and returns a table of matching text snippets.  The 
---snippets are ordered by distance from the input line.
---@param candidate_pattern string
---@param accept_pattern string
---@return table
function console.screengrab(candidate_pattern, accept_pattern) end
---Scrolls the console screen buffer and returns the number of lines scrolled up (negative) or down (positive).
---@param mode string
---@param amount integer
---@return integer
function console.scroll(mode, amount) end
---Sets the console title text.
---@param title string
---@return nil
function console.settitle(title) end
---@class io
io = {}

---Runs command
--- and returns two file handles:  a file handle for reading output from 
---the command, and a file handle for writing input to the command.
---@param command string
---@param mode? string
---@return file, file
function io.popenrw(command, mode) end
---This is the same as io.popen(command, mode) except that it only supports read mode and it yields until the command has finished:
---@param command string
---@param mode? string
---@return file
function io.popenyield(command, mode) end
---@class line_state
local line_state = {}

---Returns
--- the offset to the start of the delimited command in the line that's 
---being effectively edited. Note that this may not be the offset of the 
---first command of the line unquoted as whitespace isn't considered for 
---words.
---@return integer
function line_state:getcommandoffset() end
---Returns
--- the index of the command word. Usually the index is 1, but if a 
---redirection symbol occurs before the command name then the index can be 
---greater than 1.
---@return integer
function line_state:getcommandwordindex() end
---Returns the position of the cursor.
---@return integer
function line_state:getcursor() end
---Returns the last word of the line. This is the word that matches are being generated for.
---@return string
function line_state:getendword() end
---Returns the current line in its entirety.
---@return string
function line_state:getline() end
---Returns the word of the line at index.
---@param index integer
---@return string
function line_state:getword(index) end
---Returns the number of words in the current line.
---@return integer
function line_state:getwordcount() end
---Returns a table of information about the Nth word in the line.
---@param index integer
---@return table
function line_state:getwordinfo(index) end
---@class log
local log = {}

---Writes info message to the Clink log file.  Use this sparingly, or it could cause performance problems or disk space problems.
---@param message string
---@return nil
function log.info(message) end
---@class matches
local matches = {}

---Returns the number of available matches.
---@return integer
function matches:getcount() end
---Returns the match text for the index match.
---@param index integer
---@return string
function matches:getmatch(index) end
---Returns the longest common prefix of the available matches.
---@return string
function matches:getprefix() end
---@class matches_lua
local matches_lua = {}

---Returns the match type for the index match.
---@param index integer
---@return string
function matches_lua:gettype(index) end
---@class os
os = {}

---Changes the current directory to path and returns whether it was successful.
---@param path string
---@return boolean
function os.chdir(path) end
---This returns the number of seconds since the program started.
---@return number
function os.clock() end
---Copies the src file to the dest file.
---@param src string
---@param dest string
---@return boolean
function os.copy(src, dest) end
---Creates a uniquely named file, intended for use as a temporary file.  The name pattern is "location \ prefix _ processId _ uniqueNum extension".
---@param prefix? string
---@param ext? string
---@param path? string
---@param mode? string
---@return file, string
function os.createtmpfile(prefix, ext, path, mode) end
---This works like print() but writes the output via the OS `OutputDebugString()` API.
---@vararg any
---@return nil
function os.debugprint(...) end
---Returns value with any %name% environment variables expanded.  Names are case insensitive.  Special CMD syntax is not supported (e.g. %name:str1=str2% or %name:~offset,length%).
---@param value string
---@return string
function os.expandenv(value) end
---Returns command string for doskey alias name, or nil if the named alias does not exist.
---@param name string
---@return string | nil
function os.getalias(name) end
---Returns doskey alias names in a table of strings.
---@return table
function os.getaliases() end
---Returns
--- a table containing the battery status for the device, or nil if an 
---error occurs.  The returned table has the following scheme:
---@return table
function os.getbatterystatus() end
---This returns the text from the system clipboard, or nil if there is no text on the system clipboard.
---@return string | nil
function os.getclipboardtext() end
---Returns the current directory.
---@return string
function os.getcwd() end
---Returns the value of the named environment variable, or nil if it doesn't exist.
---@param name string
---@return string | nil
function os.getenv(name) end
---Returns all environment variables in a table with the following scheme:
---@return table
function os.getenvnames() end
---Returns the last command's exit code, if the cmd.get_errorlevel setting is enabled (it is disabled by default).  Otherwise it returns 0.
---@return integer
function os.geterrorlevel() end
---Returns the full path name for path.
---@param path string
---@return string
function os.getfullpathname(path) end
---Returns the fully qualified file name of the host process.  Currently only CMD.EXE can host Clink.
---@return string
function os.gethost() end
---Returns the long path name for path.
---@param path string
---@return string
function os.getlongpathname(path) end
---Returns the remote name associated with path, or an empty string if it's not a network drive.
---@param path string
---@return string
function os.getnetconnectionname(path) end
---Returns the CMD.EXE process ID. This is mainly intended to help with salting unique resource names (for example named pipes).
---@return integer
function os.getpid() end
---Returns dimensions of the terminal's buffer and visible window. The returned table has the following scheme:
---@return table
function os.getscreeninfo() end
---Returns the 8.3 short path name for path.  This may return the input path if an 8.3 short path name is not available.
---@param path string
---@return string
function os.getshortpathname(path) end
---Collects directories matching globpattern and returns them in a table of strings.
---@param globpattern string
---@param extrainfo? integer | boolean
---@return table
function os.globdirs(globpattern, extrainfo) end
---Collects files and/or directories matching globpattern and returns them in a table of strings.
---@param globpattern string
---@param extrainfo? integer | boolean
---@return table
function os.globfiles(globpattern, extrainfo) end
---Returns whether path is a directory.
---@param path string
---@return boolean
function os.isdir(path) end
---Returns whether path is a file.
---@param path string
---@return boolean
function os.isfile(path) end
---Returns whether a Ctrl+Break has been received. Scripts may use this to decide when to end work early.
---@return boolean
function os.issignaled() end
---Creates the directory path and returns whether it was successful.
---@param path string
---@return boolean
function os.mkdir(path) end
---Moves the src file to the dest file.
---@param src string
---@param dest string
---@return boolean
function os.move(src, dest) end
---Identifies whether text begins with a doskey alias, and expands the doskey alias.
---@param text string
---@return table | nil
function os.resolvealias(text) end
---Removes the directory path and returns whether it was successful.
---@param path string
---@return boolean
function os.rmdir(path) end
---This sets the text onto the system clipboard, and returns whether it was successful.
---@return boolean
function os.setclipboardtext() end
---Sets the name environment variable to value and returns whether it was successful.
---@param name string
---@param value string
---@return boolean
function os.setenv(name, value) end
---Sleeps for the indicated duration, in seconds, with millisecond granularity.
---@param seconds number
---@return nil
function os.sleep(seconds) end
---Sets the access and modified times for path.
---@param path string
---@param atime? number
---@param mtime? number
---@return nil
function os.touch(path, atime, mtime) end
---Deletes the file path and returns whether it was successful.
---@param path string
---@return boolean
function os.unlink(path) end
---@class path
path = {}

---
---@param path string
---@return string
function path.getbasename(path) end
---This is similar to path.toparent()
--- but can behave differently when the input path ends with a path 
---separator.  This is the recommended API for parsing a path into its 
---component pieces, but is not recommended for walking up through parent 
---directories.
---@param path string
---@return nil | string
function path.getdirectory(path) end
---
---@param path string
---@return nil | string
function path.getdrive(path) end
---
---@param path string
---@return string
function path.getextension(path) end
---
---@param path string
---@return string
function path.getname(path) end
---Examines
--- the extension of the path name.  Returns true if the extension is 
---listed in %PATHEXT%.  This caches the extensions in a map so that it's 
---more efficient than getting and parsing %PATHEXT% each time.
---@param path string
---@return boolean
function path.isexecext(path) end
---
---@param left string
---@param right string
---@return string
function path.join(left, right) end
---Cleans path by normalising separators and removing "." and ".." elements.  If separator is provided it is used to delimit path elements, otherwise a system-specific delimiter is used.
---@param path string
---@param separator? string
---@return string
function path.normalise(path, separator) end
---Splits the last path component from path, if possible. Returns the result and the component that was split, if any.
---@param path string
---@return string
function path.toparent(path) end
---@class rl
local rl = {}

---Undoes Readline tilde expansion.  See rl.expandtilde for more information.
---@param path string
---@param force? boolean
---@return string
function rl.collapsetilde(path, force) end
---Performs Readline tilde expansion.
---@param path string
---@return string, boolean
function rl.expandtilde(path) end
---Returns the command or macro bound to key, and the type of the binding.
---@param key string
---@param keymap? string
---@return string
function rl.getbinding(key, keymap) end
---Returns key bindings in a table with the following scheme:
---@param raw boolean
---@param mode? integer
---@return table
function rl.getkeybindings(raw, mode) end
---Returns two values:
---@return string, function
function rl.getlastcommand() end
---Returns the color string associated with the match.
---@param match string | table
---@param type? string
---@return string
function rl.getmatchcolor(match, type) end
---Returns information about the current prompt and input line.
---@return table
function rl.getpromptinfo() end
---Returns the value of the named Readline configuration variable as a string, or nil if the variable name is not recognized.
---@param name string
---@return string | nil
function rl.getvariable(name) end
---Returns true when typing insertion mode is on.
---@param insert? boolean
---@return boolean
function rl.insertmode(insert) end
---Invokes a Readline command named command.  May only be used within a luafunc: key binding.
---@param command string
---@param count? integer
---@return boolean | nil
function rl.invokecommand(command, count) end
---Returns true when the current input line is a history entry that has been modified (i.e. has an undo list).
---@return boolean
function rl.ismodifiedline() end
---Returns
--- a boolean value indicating whether the named Readline configuration 
---variable is set to true (on), or nil if the variable name is not 
---recognized.
---@param name string
---@return boolean | nil
function rl.isvariabletrue(name) end
---Binds key to invoke binding, and returns whether it was successful.
---@param key string
---@param binding string | nil
---@param keymap? string
---@return boolean
function rl.setbinding(key, binding, keymap) end
---Provides
--- an alternative set of matches for the current word.  This discards any 
---matches that may have already been collected and uses matches
--- for subsequent Readline completion commands until any action that 
---normally resets the matches (such as moving the cursor or editing the 
---input line).
---@param matches table
---@param type? string
---@return integer, boolean
function rl.setmatches(matches, type) end
---Temporarily
--- overrides the named Readline configuration variable to the specified 
---value.  The return value reports whether it was successful, or is nil if
--- the variable name is not recognized.
---@param name string
---@param value string
---@return boolean
function rl.setvariable(name, value) end
---@class rl_buffer
local rl_buffer = {}

---Advances
--- the output cursor to the next line after the Readline input buffer so 
---that subsequent output doesn't overwrite the input buffer display.
---@return nil
function rl_buffer:beginoutput() end
---Starts a new undo group.  This is useful for grouping together multiple editing actions into a single undo operation.
---@return nil
function rl_buffer:beginundogroup() end
---Dings the bell.  If the bell-style Readline variable is visible then it flashes the cursor instead.
---@return nil
function rl_buffer:ding() end
---Ends an undo group.  This is useful for grouping together multiple editing actions into a single undo operation.
---@return nil
function rl_buffer:endundogroup() end
---Returns
--- the anchor position of the currently selected text in the input line, 
---or nil if there is no selection.  The value can be from 1 to 
---rl_buffer:getlength() + 1.  It can exceed the length of the input line 
---because the anchor can be positioned just past the end of the input 
---line.
---@return integer | nil
function rl_buffer:getanchor() end
---Returns any accumulated numeric argument (Alt+Digits, etc), or nil if no numeric argument has been entered.
---@return integer | nil
function rl_buffer:getargument() end
---Returns the current input line.
---@return string
function rl_buffer:getbuffer() end
---Returns
--- the cursor position in the input line.  The value can be from 1 to 
---rl_buffer:getlength() + 1.  It can exceed the length of the input line 
---because the cursor can be positioned just past the end of the input 
---line.
---@return integer
function rl_buffer:getcursor() end
---Returns the length of the input line.
---@return integer
function rl_buffer:getlength() end
---Inserts text at the cursor position in the input line.
---@param text string
---@return nil
function rl_buffer:insert(text) end
---Redraws the input line.
---@return nil
function rl_buffer:refreshline() end
---Removes text from the input line starting at cursor position from through to.
---@param from integer
---@param to integer
---@return nil
function rl_buffer:remove(from, to) end
---When argument is a number, it is set as the numeric argument for use by Readline commands (as entered using Alt+Digits, etc).  When argument is nil, the numeric argument is cleared (having no numeric argument is different from having 0 as the numeric argument).
---@param argument integer | nil
---@return nil
function rl_buffer:setargument(argument) end
---Sets the cursor position in the input line and returns the previous cursor position.  cursor
--- can be from 1 to rl_buffer:getlength() + 1.  It can exceed the length 
---of the input line because the cursor can be positioned just past the end
--- of the input line.
---@param cursor integer
---@return integer
function rl_buffer:setcursor(cursor) end
---@class settings
settings = {}

---Adds a setting to the list of Clink settings and includes it in clink set.  The new setting is named name and has a default value default when the setting isn't explicitly set.
---@param name string
---@param default ...
---@param short_desc? string
---@param long_desc? string
---@return boolean
function settings.add(name, default, short_desc, long_desc) end
---Returns the current value of the name Clink setting.
---@param name string
---@param descriptive? boolean
---@return boolean | string | integer
function settings.get(name, descriptive) end
---Sets the name Clink setting to value and returns whether it was successful.
---@param name string
---@param value string
---@return boolean
function settings.set(name, value) end
---@class string
string = {}

---Performs
--- a case insensitive comparison of the strings with international 
---linguistic awareness.  This is more efficient than converting both 
---strings to lowercase and comparing the results.
---@param a string
---@param b string
---@return boolean
function string.equalsi(a, b) end
---Splits text delimited by delims (or by spaces if not provided) and returns a table containing the substrings.
---@param text string
---@param delims? string
---@param quote_pair? string
---@return table
function string.explode(text, delims, quote_pair) end
---Returns a hash of the input text.
---@param text string
---@return integer
function string.hash(text) end
---Returns how many characters match at the beginning of the strings, or -1 if the entire strings match.  This respects the match.ignore_case and match.ignore_accents Clink settings.
---@param a string
---@param b string
---@return integer
function string.matchlen(a, b) end
---@class word_classifications
local word_classifications = {}

---Applies an ANSI SGR escape code to some characters in the input line.
---@param start integer
---@param length integer
---@param color string
---@param overwrite? boolean
---@return nil
function word_classifications:applycolor(start, length, color, overwrite) end
---This classifies the indicated word so that it can be colored appropriately.
---@param word_index integer
---@param word_class string
---@param overwrite? boolean
---@return nil
function word_classifications:classifyword(word_index, word_class, overwrite) end

---@class clink
clink = {}

---Creates and returns a new argument matcher parser object.  Use :addarg() and etc to add arguments, flags, other parsers, and more.  See Argument Completion for more information.
---@param priority? integer
---@vararg string
---@return argmatcher
function clink.argmatcher(priority, ...) end
---Creates and returns a new word classifier object.  Define on the object a :classify() function which gets called in increasing priority order (low values to high values) when classifying words for coloring the input.  See Coloring the Input Text for more information.
---@param priority? integer
---@return table
function clink.classifier(priority) end
---You can use this function in an argmatcher to supply directory matches. This automatically handles Readline tilde completion.
---@param word string
---@return table
function clink.dirmatches(word) end
---You can use this function in an argmatcher to supply file matches.  This automatically handles Readline tilde completion.
---@param word string
---@return table
function clink.filematches(word) end
---Creates and returns a new match generator object.  Define on the object a :generate() function which gets called in increasing priority order (low values to high values) when generating matches for completion.  See Match Generators for more information.
---@param priority? integer
---@return table
function clink.generator(priority) end
---Returns a string indicating who Clink thinks will currently handle ANSI escape codes.  This can change based on the terminal.emulation setting.  This always returns "unknown" until the first edit prompt (see clink.onbeginedit()).
---@return string
function clink.getansihost() end
---Finds the argmatcher registered to handle a command, if any.
---@param find string | line_state
---@return argmatcher | nil
function clink.getargmatcher(find) end
---Returns the current Clink session id.
---@return string
function clink.getsession() end
---This API correctly converts UTF8 strings to lowercase, with international linguistic awareness.
---@param text string
---@return string
function clink.lower(text) end
---Registers func to be called after every editing command (key binding).
---@param func function
---@return nil
function clink.onaftercommand(func) end
---Registers func to be called when Clink's edit prompt is activated.  The function receives no arguments and has no return values.
---@param func function
---@return nil
function clink.onbeginedit(func) end
---Registers func to be called when the command word changes in the edit line.
---@param func function
---@return nil
function clink.oncommand(func) end
---Registers func to be called when Clink is about to display matches.  See Filtering the Match Display for more information.
---@param func function
---@return nil
function clink.ondisplaymatches(func) end
---Registers func
--- to be called when Clink's edit prompt ends.  The function receives a 
---string argument containing the input text from the edit prompt.
---@param func function
---@return nil
function clink.onendedit(func) end
---Registers func to be called after Clink's edit prompt ends (it is called after the onendedit
--- event).  The function receives a string argument containing the input 
---text from the edit prompt.  The function returns up to two values.  If 
---the first is not nil then it's a string that replaces the edit prompt 
---text.  If the second is not nil and is false then it stops further 
---onfilterinput handlers from running.
---@param func function
---@return nil
function clink.onfilterinput(func) end
---Registers func to be called after Clink generates matches for completion.  See  Filtering Match Completions for more information.
---@param func function
---@return nil
function clink.onfiltermatches(func) end
---Registers func to be called when Clink is injected into a CMD process.  The function is called only once per session.
---@param func function
---@return nil
function clink.oninject(func) end
---Displays a popup list and returns the selected item.  May only be used within a luafunc: key binding.
---@param title string
---@param items table
---@param index? integer
---@return string, boolean, integer
function clink.popuplist(title, items, index) end
---This works like print(), but this supports ANSI escape codes.
---@vararg any
---@return nil
function clink.print(...) end
---@generic T
---@param func fun():T
---@return T
function clink:promptcoroutine(func) end
---Creates and returns a new promptfilter object that is applied in increasing priority order (low values to high values).  Define on the object a :filter()
--- function that takes a string argument which contains the filtered 
---prompt so far.  The function can return nil to have no effect, or can 
---return a new prompt string.  It can optionally stop further prompt 
---filtering by also returning false.  See Customizing the Prompt for more information.
---@param priority? integer
---@return table
function clink.promptfilter(priority) end
---Reclassify the input line text again and refresh the input line display.
---@return nil
function clink.reclassifyline() end
---Invoke the prompt filters again and refresh the prompt.
---@return nil
function clink.refilterprompt() end
---Reloads Lua scripts and Readline config file at the next prompt.
---@return nil
function clink.reload() end
---By
--- default, a coroutine is canceled if it doesn't complete before an edit 
---line ends.  In some cases it may be necessary for a coroutine to run 
---until it completes, even if it spans multiple edit lines.
---@param coroutine coroutine
---@return nil
function clink.runcoroutineuntilcomplete(coroutine) end
---Overrides
--- the interval at which a coroutine is resumed.  All coroutines are 
---automatically added with an interval of 0 by default, so calling this is
--- only needed when you want to change the interval.
---@param coroutine coroutine
---@param interval? number
---@return nil
function clink.setcoroutineinterval(coroutine, interval) end
---Sets a name for the coroutine.  This is purely for diagnostic purposes.
---@param coroutine coroutine
---@param name string
---@return nil
function clink.setcoroutinename(coroutine, name) end
---Creates and returns a new suggester object.  Suggesters are consulted in the order their names are listed in the autosuggest.strategy setting.
---@param name string
---@return table
function clink.suggester(name) end
---This overrides how Clink translates slashes in completion matches, which is normally determined by the match.translate_slashes setting.
---@param mode? integer
---@return integer
function clink.translateslashes(mode) end
---This API correctly converts UTF8 strings to uppercase, with international linguistic awareness.
---@param text string
---@return string
function clink.upper(text) end
---@type string
clink.version_commit = {}
---@type integer
clink.version_encoded = {}
---@type integer
clink.version_major = {}
---@type integer
clink.version_minor = {}
---@type integer
clink.version_patch = {}

---@type fun(message?: string, lines?: integer, force?: boolean): nil
---@diagnostic disable-next-line:lowercase-global
pause = pause