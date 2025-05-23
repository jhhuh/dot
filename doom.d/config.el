;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Ji-Haeng Huh"
      user-mail-address "jhhuh.note@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec
                 :family "Iosevka Nerd Font Mono"
                 :size 32)
      doom-variable-pitch-font (font-spec
                                :family "Noto Sans CJK KR"
                                :size 32))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-monokai-machine)

(doom/set-frame-opacity 80)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
(advice-add #'lsp! :override #'ignore)

(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "emacsclient"))

(setq doom-reload-command "EMACS=emacs %s sync -B -e")

(after! envrc
  (setq envrc-remote t))

(after! doom-modeline
  (setq doom-modeline-persp-name t))

(after! auth-source
  (setq! auth-sources '(password-store))
  (setq! auth-source-cache-expiry nil))

(use-package! gptel-extensions)

(after! gptel
  (setq! gptel-default-mode #'org-mode
         gptel-model 'gpt-4o
         gptel-temperature 0.0))

;; (after! magit-gptcommit
;;     :after magit
;;     :bind (:map git-commit-mode-map
;;                 ("C-c C-g" . magit-gptcommit-commit-accept))
;;     :init
;;     (defun my/magit-gptcommit-openai-llm-provider ()
;;       (let (provider)
;;         (lambda ()
;;           (or provider
;;               (progn
;;                 (require 'llm-openai)
;;                 (setq provider (make-llm-openai
;;                                 :key
;;                                 (auth-info-password
;;                                  (car (auth-source-search
;;                                        :host (gptel-backend-host gptel-backend)
;;                                        :user "apikey"
;;                                        :require '(:secret)))))))))))
;;     :custom
;;     (magit-gptcommit-llm-provider (my/magit-gptcommit-openai-llm-provider))

;;     :config
;;     (magit-gptcommit-mode 1)
;;     (magit-gptcommit-status-buffer-setup))


(use-package! copilot
 :bind (:map copilot-mode-map
        ("<tab>" . #'copilot-accept-completion)
        ("C-<tab>" . #'copilot-accept-completion-by-word)
        ("C-!" . #'copilot-next-completion)
        :map copilot-completion-map
        ("<tab>" . #'copilot-accept-completion))
  :config
  (setq! copilot-indent-offset-warning-disable t
   copilot-idle-delay 0.12
   copilot-max-char -1
   copilot-log-max 10000))
