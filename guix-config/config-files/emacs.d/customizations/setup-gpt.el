(use-package gptel)
(setq
 gptel-model 'claude-3-sonnet-20240229 ;
 gptel-backend (gptel-make-anthropic "Claude" ; Any name you want
                 :stream t ; Streaming responses
                 :key "[REDACTED-API-KEY]"))
