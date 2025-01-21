(use-package gptel)
(gptel-make-anthropic "Claude"          ;Any name you want
  :stream t                             ;Streaming responses
  :key "[REDACTED-API-KEY]")
(setq
 gptel-model 'claude-3-sonnet-20240229 ;  "claude-3-opus-20240229" also available
 gptel-backend (gptel-make-anthropic "Claude"
                 :stream t :key "claude-3-5-sonnet-20241022"))
