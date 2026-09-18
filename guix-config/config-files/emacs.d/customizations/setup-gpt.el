;; -*- lexical-binding: t; -*-
(use-package gptel
  :config
  ;; --- Local: Ollama ---
  (gptel-make-ollama "Ollama"
    :host "localhost:11434"
    :stream t
    :models '(qwen2.5-coder:14b))

  ;; --- Cloud fallback: DeepSeek ---
  (gptel-make-openai "DeepSeek"
    :host "api.deepseek.com"
    :endpoint "/chat/completions"
    :protocol "https"
    :stream t
    :key (lambda () (auth-source-pick-first-password :host "api.deepseek.com"))
    :models '(deepseek-chat deepseek-reasoner))

  ;; Default to local/free
  (setq gptel-backend (gptel-get-backend "Ollama")
        gptel-model 'qwen2.5-coder:14b))

(use-package agent-shell)
