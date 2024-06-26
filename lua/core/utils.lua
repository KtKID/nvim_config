local U = {}

function print_table(t, file, indent)
  indent = indent or 0
  for k, v in pairs(t) do
    local formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      if file then
        print_file(formatting)
      else
        print(formatting)
      end
      print_table(v, indent + 1)
    else
      if file then
        print_file(formatting .. tostring(v))
      else
        print(formatting .. tostring(v))
      end
    end
  end
end

function print_stack(...)
  -- 获取当前堆栈信息
  local traceback = debug.traceback("", 2)
  print(traceback, ...)
end

function print_stack_2file(...)
  -- 获取当前堆栈信息
  local traceback = debug.traceback("", 2)
  print_file(traceback, ...)
end

function print_file(msg,...)
  local path = vim.fn.stdpath("config") .. "/log.txt"
  print(path)
  local file = io.open(path, "a") -- 以写入模式打开文件
  

  if file then                    -- 判断文件是否成功打开
    file:write(msg)               -- 写入文件内容
    file:close()                  -- 关闭文件
    return true                   -- 返回写入成功
  else
    return false                  -- 返回写入失败
  end
end

-- 滑动窗口tips
function notify_show(msg)
  vim.notify(msg)
end

--- Check if a plugin is defined in lazy. Useful with lazy loading when a plugin is not necessarily loaded yet
---@param plugin string The plugin to search for
---@return boolean available # Whether the plugin is available
function U.is_available(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  return lazy_config_avail and lazy_config.plugins[plugin] ~= nil
end

--- Table based API for setting keybindings
---@param map_table table A nested table where the first key is the vim mode, the second key is the key to map, and the value is the function to set the mapping to
---@param base? table A base set of options to set on every keybinding
function U.set_mappings(map_table, base)
  -- iterate over the first keys for each mode
  base = base or {}
  for mode, maps in pairs(map_table) do
    -- iterate over each keybinding set in the current mode
    for keymap, options in pairs(maps) do
      -- build the options for the command accordingly
      if options then
        local cmd = options
        local keymap_opts = base
        if type(options) == "table" then
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend("force", keymap_opts, options)
          keymap_opts[1] = nil
          -- print("keymap_opts")
          -- print_table(keymap_opts)
        end
        if not cmd or keymap_opts.name then -- if which-key mapping, queue it
          if not U.which_key_queue then U.which_key_queue = {} end
          if not U.which_key_queue[mode] then U.which_key_queue[mode] = {} end
          U.which_key_queue[mode][keymap] = keymap_opts
          -- print_table(U.which_key_queue)
        else -- if not which-key mapping, set it
          vim.keymap.set(mode, keymap, cmd, keymap_opts)
          -- print("vim.km "..tostring(mode).." "..tostring(keymap).." "..tostring(cmd).." "..tostring(keymap_opts))
        end
      end
    end
  end
  U.which_key_register()
end

--- Register queued which-key mappings 注册which-key的队列映射
function U.which_key_register()
  if U.which_key_queue then
    local wk_avail, wk = pcall(require, "which-key")
    if wk_avail then
      for mode, registration in pairs(U.which_key_queue) do
        -- print_table(registration)
        wk.register(registration, { mode = mode })
      end
      U.which_key_queue = nil
    end
  end
end

--- Get an icon from `lspkind` if it is available and return it
---@param kind string The kind of icon in `lspkind` to retrieve
---@return string icon
-- function U.get_icon(kind)
--   local icon_pack = vim.g.icons_enabled and "icons" or "text_icons"
--   if not U[icon_pack] then
--     U.icons = astronvim.user_opts("icons", require "astronvim.icons.nerd_font")
--     U.text_icons = astronvim.user_opts("text_icons", require "astronvim.icons.text")
--   end
--   return U[icon_pack] and U[icon_pack][kind] or ""
-- end

function U.Capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
  }
  return capabilities
end

return U
