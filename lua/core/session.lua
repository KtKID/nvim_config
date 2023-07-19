local M = {}

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local utils = require("core.utils")

-- 保存会话文件位置
vim.g.session_dir = vim.fn.stdpath("config") .. "/sessions"

if vim.fn.isdirectory(vim.g.session_dir) == 0 then
  vim.fn.mkdir(vim.g.session_dir, "p")
end

local function get_session_name()
    if vim.fn.trim(vim.fn.system("git rev-parse --is-inside-work-tree")) == "true" then
        -- 如果在git工作区内，使用git仓库名作为会话文件名
        return vim.fn.trim(vim.fn.system("git rev-parse --show-toplevel"))
    else
        return "Session.vim"
    end
end

local default_session_name = get_session_name()

local function make_session(session_name)
    -- 写入会话文件
    local cmd = "mks! " .. session_name
    vim.cmd(cmd)
end

function M.save_session()
    vim.ui.input({ prompt = "Input session name: ", default = default_session_name }, function(session_name)
        if session_name then
            session_name = vim.g.session_dir .. "/" .. session_name
            -- print_file("name "..session_name)
            make_session(session_name)
        end
    end)
end

local function restore_session(prompt_bufnr, _)
    actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local select_name = selection[1]:gsub("./", "")
        session_name = vim.g.session_dir .. "/" .. select_name
        local cmd = "source " .. session_name
        vim.cmd(cmd)
        notify_show(session_name, "Session restored")
    end)
    return true
end

function M.list_session()
  local opts = {
    attach_mappings = restore_session,
    prompt_title = "Select session ",
    cwd = vim.g.session_dir,
  }
  require("telescope.builtin").find_files(opts)
end

local function delete_session(prompt_bufnr, _)
    actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local session_name = selection[1]:gsub("./", "")
        session_name = vim.g.session_dir .. "/" .. session_name
        if vim.fn.delete(session_name) == 0 then
            notify_show(session_name.." Session deleted")
        end
    end)
    return true
end

function M.delete_session()
    local opts = {
        attach_mappings = delete_session,
        prompt_title = "Delete session ",
        cwd = vim.g.session_dir,
    }
    require("telescope.builtin").find_files(opts)
end

local track_session = false

function M.toggle_session()
    if track_session then
        vim.api.nvim_del_augroup_by_name "SessionTracking" -- nvim 0.7 and above only
        track_session = false
        notify_show("Session tracking disabled".. " Session")
    else
        vim.ui.input({ prompt = "Input session name: ", default = default_session_name }, function(session_name)
            if session_name then
                session_name = vim.g.session_dir .. "/" .. session_name
                make_session(session_name) -- Save the session on toggle
                -- Create autocmd
                local grp = vim.api.nvim_create_augroup("SessionTracking", { clear = true })
                vim.api.nvim_create_autocmd("VimLeave", { -- nvim 0.7 and above only
                pattern = "*",
                callback = function()
                    make_session(session_name)
                end,
                group = grp,
            })
            track_session = true
            notify_show("Session tracking enabled ".. "Session")
        end
    end)
end
end

return M
