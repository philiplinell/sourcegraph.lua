--[[
    This script allows you to quickly search for a selected piece of code
    in Sourcegraph directly from Neovim. When you highlight text in visual
    mode and press <leader>S (default), the script fetches the selected text, URL encodes
    it, and constructs a Sourcegraph search URL. The search is also tailored
    to the file type you're currently working with in Neovim. The script then
    opens the constructed URL in your default web browser, taking you straight
    to the search results on Sourcegraph. This helps you swiftly find usage
    examples, definitions, and other relevant information about the selected
    piece of code on Sourcegraph.
]]

-- Disclaimer: Written with the help of ChatGPT 4

-- Create a module M.
local M = {}

-- Function to convert a character to its hexadecimal value.
local function char_to_hex(c)
    return string.format("%%%02X", string.byte(c))
end

-- Function to URL encode a string.
-- From https://gist.github.com/liukun/f9ce7d6d14fa45fe9b924a3eed5c3d99
local function url_encode(url)
    -- If url is nil, return nil.
    if url == nil then
        return
    end

    -- Replace newline characters with carriage return + newline.
    url = url:gsub("\n", "\r\n")

    -- URL encode non-alphanumeric characters.
    url = url:gsub("([^%w ])", char_to_hex)

    -- Replace spaces with '+'.
    url = url:gsub(" ", "+")
    return url
end

-- Main function for searching Sourcegraph with the selected text.
function M.search_sourcegraph()
    -- Get the start and end position of the selected text.
    local _, vs_line, vs_col, _ = unpack(vim.fn.getpos("'<"))
    local _, ve_line, ve_col, _ = unpack(vim.fn.getpos("'>"))

    -- Get the selected text.
    local selected_text = vim.fn.getline(vs_line, ve_line)

    -- If the selected text is only one line, just get the selected part.
    -- If it's multiple lines, concatenate them with newline characters.
    if #selected_text == 1 then
        selected_text = selected_text[1]:sub(vs_col, ve_col)
    else
        selected_text[1] = selected_text[1]:sub(vs_col)
        selected_text[#selected_text] = selected_text[#selected_text]:sub(1, ve_col)
        selected_text = table.concat(selected_text, '\n')
    end

    -- If no text was selected, print an error message and return.
    if not selected_text then
        print("Error: No text selected.")
        return
    end

    -- URL encode the selected text.
    local encoded_text = url_encode(selected_text)

    -- Get the filetype of the current buffer.
    local filetype = vim.bo.filetype
    local lang_query = ""

    -- Lookup table for matching Neovim filetypes to Sourcegraph language names.
    local filetype_to_sourcegraph_lang = {
        go = "Go",
        python = "Python",
        javascript = "JavaScript",
        cpp = "C++",
        markdown = "Markdown",
        lua = "Lua",
        html = "HTML"
        -- Add more file types as needed
    }

    -- If the filetype is found in the lookup table, append it to the Sourcegraph query.
    if filetype_to_sourcegraph_lang[filetype] then
        lang_query = "+lang:" .. filetype_to_sourcegraph_lang[filetype]
    else
        -- If not, print a warning message.
        print("Warning: Filetype " .. filetype .. " not found in Sourcegraph language dictionary.")
    end

    -- Construct the Sourcegraph URL.
    local url = "https://sourcegraph.com/search?q=context:global+" .. encoded_text .. lang_query .. "&patternType=standard&sm=1"

    -- Determine the operating system and use the appropriate command to open the URL in the default browser.
    local OS = string.lower(jit.os)
    if OS == "osx" then
        os.execute('open ' .. url .. ' &')
    elseif OS == "linux" then
        os.execute('xdg-open ' .. url .. ' &')
    elseif OS == "windows" then
        os.execute('start ' .. url)
    else
        print("Error: Unrecognized OS.")
    end
end

return M
