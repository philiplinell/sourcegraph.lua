" Default keybinding
if !exists('g:sourcegraph_key')
    let g:sourcegraph_key = '<leader>S'
endif

if has('nvim')
    execute 'vnoremap' g:sourcegraph_key ':lua require"sourcegraph".search_sourcegraph()<CR>'
endif

