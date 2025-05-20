(use-package gptel)
(setq anthropic-api-key "[REDACTED-API-KEY]")
(setq vody-anthropic-api-key "[REDACTED-WORK-API-KEY]")
(setq
 gptel-model 'claude-3-sonnet-20241022 ;
 gptel-backend (gptel-make-anthropic "Claude" ; Any name you want
                 :stream t ; Streaming responses
                 :key vody-anthropic-api-key))
