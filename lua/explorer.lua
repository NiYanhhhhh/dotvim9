local vim = vim
local api = vim.api
local loop = vim.loop

local yanil      = require("yanil")
local git        = require("yanil/git")
local decorators = require("yanil/decorators")
local devicons   = require("yanil/devicons")
local canvas     = require("yanil/canvas")
local utils      = require("yanil/utils")

local M = {}

local border_symbols = {
    vertical = "▸",
    horizontal = "▾",
    fill = " ",
    corner = {
        topleft = "",
        topright = "",
        bottomleft = "",
        bottomright = "",
    }
}

local function floating_window(bufnr)
    local winnr_bak = vim.fn.winnr()
    local altwinnr_bak = vim.fn.winnr("#")

    local width, height = vim.o.columns, vim.o.lines

    local win_width = math.ceil(width * 0.8) - 4
    local win_height = math.ceil(height * 0.8)
    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)

    -- border
    local border_opts = {
        style = "minimal",
        relative = "editor",
        width = win_width + 2,
        height = win_height + 2,
        row = row - 1,
        col = col - 1
    }

    local border_bufnr = api.nvim_create_buf(false, true)
    local border_lines = border_symbols:draw(win_width, win_height)
    vim.api.nvim_buf_set_lines(border_bufnr, 0, -1, false, border_lines)
    local border_winnr = api.nvim_open_win(border_bufnr, true, border_opts)
    api.nvim_win_set_option(border_winnr, "winblend", 0)
    api.nvim_win_set_option(border_winnr, "winhl", "NormalFloat:")

    -- content
    local win_opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
    }
    local winnr = api.nvim_open_win(bufnr, true, win_opts)

    api.nvim_command(string.format([[autocmd BufWipeout <buffer> execute "silent bwipeout! %d"]], border_bufnr))
    api.nvim_command(string.format([[autocmd WinClosed  <buffer> execute "%dwincmd w" | execute "%dwincmd w"]], altwinnr_bak, winnr_bak))

    api.nvim_buf_set_keymap(bufnr, "n", "q", ":q<CR>", {nowait = true, noremap = false, silent = false})
    api.nvim_buf_set_keymap(bufnr, "n", "<ESC><ESC>", ":q<CR>", {nowait = true, noremap = false, silent = false})

    return winnr
end

local function git_diff(_tree, node)
    local diff = git.diff(node)
    if not diff then return end

    -- content
    local bufnr = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(bufnr, "filetype", "diff")
    api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
    api.nvim_buf_set_option(bufnr, "swapfile", false)
    api.nvim_buf_set_lines(bufnr, 0, -1, false, diff)

    local winnr = floating_window(bufnr)

    api.nvim_win_set_option(winnr, "cursorline", true)
    api.nvim_win_set_option(winnr, "winblend", 0)
    api.nvim_win_set_option(winnr, "winhl", "NormalFloat:")
    api.nvim_win_set_option(winnr, "number", true)

    api.nvim_command(string.format([[command! -buffer Apply lua require("yanil/git").apply_buf(%d)]], bufnr))
end

local function create_node(tree, node)
    node = node:is_dir() and node or node.parent
    local name = vim.fn.input(string.format([[Add a childnode
==========================================================
Enter the dir/file name to be created. Dirs end with a '/'
%s]], node.abs_path))
    if not name or name == "" then return end
    local path = node.abs_path .. name

    -- checking file exists in schedule function to make input prompt close
    vim.schedule(function()
        if tree.root:find_node_by_path(path) then
            print("path", path, "is already exists")
            return
        end
    end)

    local refresh = vim.schedule_wrap(function()
        tree:refresh(node, {}, function()
            node:load(true)
            node:open()
        end)
        git.update(tree.cwd)
    end)

    if vim.endswith(path, "/") then
        -- 0755
        loop.fs_mkdir(path, 16877, function(err, ok)
            assert(not err, err)
            assert(ok, "mkdir failed")
            refresh()
        end)
        return
    end

    -- 0644
    loop.fs_open(path, "w+", 33188, function(err, fd)
        assert(not err, err)
        loop.fs_close(fd, function(c_err, ok) assert(not c_err and ok, "create file failed") end)
        refresh()
    end)
end

local function delete_node(tree, node)
    if node == tree.root then
        print("You can NOT delete the root")
        return
    end
    if node:is_dir() then node:load() end
    if node:is_dir() and #node.entries > 0 then
        local answer = vim.fn.input(string.format([[Delete the current node
==========================================================
STOP! Directory is not empty! To delete, type 'yes'

%s: ]], node.abs_path))
        if answer:lower() ~= "yes" then return end
    end

    local handle
    handle = loop.spawn("rm", {
        args = { "-rf", node.abs_path },
    }, function(code)
        handle:close()
        if code ~= 0 then
            print("delete node failed")
            return
        end

        vim.schedule(function()
            local next_node = tree:find_neighbor(node, 1) or tree:find_neighbor(node, -1)
            local path = next_node.abs_path
            local parent = node.parent
            tree:refresh(parent, {}, function()
                parent:load(true)
            end)
            tree:go_to_node(tree.root:find_node_by_path(path))
            git.update(tree.cwd)
        end)
    end)
end

function M.setup()
    yanil.setup()

    local header = require("yanil/sections/header"):new()
    local tree = require("yanil/sections/tree"):new()

    tree:setup {
        draw_opts = {
            decorators = {
                decorators.pretty_indent_with_git,
                devicons.decorator(),
                decorators.space,
                decorators.default,
                decorators.executable,
                decorators.readonly,
                decorators.link_to,
            }
        },
        filters = {
            function(name)
                local patterns = { "^%.git$", "%.pyc", "^%.idea$", "^%.iml$", "^%.DS_Store$", "%.o$", "%.d$" }
                for _, pat in ipairs(patterns) do
                    if string.find(name, pat) then return true end
                end
            end,
        },
        keymaps = {
            ["]c"] = git.jump_next,
            ["[c"] = git.jump_prev,
            gd = git_diff,
            ["<A-a>"] = create_node,
            ["<A-x>"] = delete_node,
        },
    }

    canvas.register_hooks {
        on_enter = function()
            git.update(tree.cwd)
            utils.buf_set_keymap(canvas.bufnr, "n", "q", function()
                vim.fn.execute("quit")
            end)
        end,
    }

    canvas.setup {
        sections = {
            header,
            tree,
        },
        autocmds = {
            {
                event = "User",
                pattern = "YanilGitStatusChanged",
                cmd = function() git.refresh_tree(tree) end,
            },
        }
    }
end

return M
