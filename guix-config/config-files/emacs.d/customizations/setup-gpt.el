(use-package gptel)
(setq anthropic-api-key "[REDACTED-API-KEY]")
(setq
 gptel-model 'claude-3-sonnet-20241022 ;
 gptel-backend (gptel-make-anthropic "Claude" ; Any name you want
                 :stream t ; Streaming responses
                 :key anthropic-api-key))

(use-package aidermacs
  :straight (:host github :repo "MatthewZMD/aidermacs" :files ("*.el"))
  :config
  (setq aidermacs-default-model "sonnet")
  (global-set-key (kbd "C-c a") 'aidermacs-transient-menu)
  ; Enable minor mode for Aider files
  (aidermacs-setup-minor-mode)
  ; See the Configuration section below
  (setq aidermacs-auto-commits t)
  (setq aidermacs-use-architect-mode t)
  ; Ensure emacs can access *_API_KEY through .bashrc or setenv
  (setenv "ANTHROPIC_API_KEY" anthropic-api-key)
  (setq aidermacs-backend 'vterm)
  (setq aidermacs-vterm-multiline-newline-key "S-<return>"))
