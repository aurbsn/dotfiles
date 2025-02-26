(use-package gptel)
(setq anthropic-api-key "[REDACTED-API-KEY]")
(setq
 gptel-model 'claude-3-sonnet-20241022 ;
 gptel-backend (gptel-make-anthropic "Claude" ; Any name you want
                 :stream t ; Streaming responses
                 :key anthropic-api-key))

(use-package aidermacs
  :config
  (setq aidermacs-args '("--model" "anthropic/claude-3-5-sonnet-20241022"))
  (setenv "ANTHROPIC_API_KEY" anthropic-api-key)
  (global-set-key (kbd "C-c a") 'aidermacs-transient-menu))
