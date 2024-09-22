-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<tab>", "<cmd>bnext<cr>", {})
map("n", "<S-tab>", "<cmd>bprevious<cr>", {})
map("n", "0", "^", { silent = true, noremap = true })
map("n", "^", "0", { silent = true, noremap = true })
