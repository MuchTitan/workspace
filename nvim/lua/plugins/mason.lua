return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "gopls",
      "pyright",
      "ansiblels",
      "dockerls",
      "docker_compose_language_service",
      "templ",
      "htmx",
      "helm_ls",
      "groovyls",
    },
  },
}
