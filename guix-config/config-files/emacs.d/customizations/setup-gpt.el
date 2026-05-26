(defvar minuet-openai-compatible-options
    `(:end-point "https://api.deepseek.com"
      :api-key "DEEPSEEK_API_KEY"
      :model "deepseek-chat"
      :system
      (:template minuet-default-system-template
       :prompt minuet-default-prompt
       :guidelines minuet-default-guidelines
       :n-completions-template minuet-default-n-completion-template)
      :fewshots minuet-default-fewshots
      :chat-input
      (:template minuet-default-chat-input-template
       :language-and-tab minuet--default-chat-input-language-and-tab-function
       :context-before-cursor minuet--default-chat-input-before-cursor-function
       :context-after-cursor minuet--default-chat-input-after-cursor-function)
      :transform ()
      :optional nil)
    "Config options for Minuet OpenAI compatible provider.")

(use-package minuet
    :bind
    (("M-y" . #'minuet-complete-with-minibuffer) ;; use minibuffer for completion
     ("M-i" . #'minuet-show-suggestion) ;; use overlay for completion
     ("C-c m" . #'minuet-configure-provider)
     :map minuet-active-mode-map
     ;; These keymaps activate only when a minuet suggestion is displayed in the current buffer
     ("M-p" . #'minuet-previous-suggestion) ;; invoke completion or cycle to next completion
     ("M-n" . #'minuet-next-suggestion) ;; invoke completion or cycle to previous completion
     ("M-A" . #'minuet-accept-suggestion) ;; accept whole completion
     ;; Accept the first line of completion, or N lines with a numeric-prefix:
     ;; e.g. C-u 2 M-a will accepts 2 lines of completion.
     ("M-a" . #'minuet-accept-suggestion-line)
     ("M-e" . #'minuet-dismiss-suggestion))

    :init
    ;; if you want to enable auto suggestion.
    ;; Note that you can manually invoke completions without enable minuet-auto-suggestion-mode
    (add-hook 'prog-mode-hook #'minuet-auto-suggestion-mode)

    :config
    ;; You can use M-x minuet-configure-provider to interactively configure provider and model
    (setq minuet-provider 'openai-compatible)

    (minuet-set-optional-options minuet-openai-compatible-options :max_tokens 256)
    (minuet-set-optional-options minuet-openai-compatible-options :top_p 0.9)
    (minuet-set-optional-options
     minuet-openai-compatible-options
     :reasoning
     '(:enabled :false)))
