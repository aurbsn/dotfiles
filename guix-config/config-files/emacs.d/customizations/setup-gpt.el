(use-package gptel)
(setq anthropic-api-key "[REDACTED-API-KEY]")
(setq vody-anthropic-api-key "[REDACTED-WORK-API-KEY]")
(setq
 gptel-model 'claude-3-sonnet-20241022 ;
 gptel-backend (gptel-make-anthropic "Claude" ; Any name you want
                 :stream t ; Streaming responses
                 :key vody-anthropic-api-key))
(use-package claude-code :ensure t
  :vc (:url "https://github.com/stevemolitor/claude-code.el" :rev :newest)
  :config (claude-code-mode)
  :bind-keymap ("C-c c" . claude-code-command-map))
(setq claude-code-terminal-backend 'vterm)



