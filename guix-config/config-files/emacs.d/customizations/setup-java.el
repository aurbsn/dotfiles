(require 'lsp-java)
(add-hook 'java-mode-hook #'lsp)
(use-package dap-java :ensure nil)
