
  print("mason-lspconfig")
return function(_, opts)
  print("mason-lspconfig!!!")
  print_table(opts)
  require("mason-lspconfig").setup(opts)
  require("mason-lspconfig").setup_handlers({
    function(server_name)
      print("server_name "..tostring(server_name))
    end
  })
  -- require("astronvim.utils").event "MasonLspSetup"
end
