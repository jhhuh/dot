;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Ji-Haeng Huh"
      user-mail-address "jhhuh.korea@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:

(cond ((string= (system-name) "cafe")
       (setq doom-font (font-spec :family "Iosevka Term" :size 14.0 :weight 'regular)
             doom-big-font (font-spec :family "Iosevka Term" :size 16.0)
             doom-variable-pitch-font (font-spec :family "sans" :size 14.0)))
      ((string= (system-name) "x230")
       (setq doom-font (font-spec :family "Ubuntu Mono" :size 16.0 :weight 'regular)
             doom-variable-pitch-font (font-spec :family "sans" :size 12.0)))
      ((string= (system-name) "p1gen3")
       (setq doom-font (font-spec :family "Iosevka Term" :size 12.0)
             doom-big-font (font-spec :family "Iosevka Term" :size 14.0)
             doom-variable-pitch-font (font-spec :family "sans" :size 12.0)))
      (t
       (setq doom-font (font-spec :family "Ubuntu Mono" :size 16.0 :weight 'regular)
             doom-variable-pitch-font (font-spec :family "sans" :size 12.0))))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;;;; they are implemented.

(use-package! envrc
  :config
  (setq envrc-debug t)
  :hook (after-init . envrc-global-mode))

(use-package! lsp-mode
  :custom
  (lsp-completion-enable-additional-text-edit nil)
  :config
  (setq lsp-use-plists "true")
  :hook (lsp-mode . (lambda ()
                      (lsp-ui-mode)
                      (lsp-ui-doc-mode))))

(use-package! lsp-haskell
  :hook (haskell-mode . lsp-deferred))

(use-package! lsp-ui
  :config
  (setq lsp-ui-doc-show-with-cursor t)
  (setq lsp-ui-doc-position 'top))

(setq company-idle-delay nil)

(setq which-key-idle-delay 0.01)

(setq doom-modeline-persp-name t)

(defun on-after-init ()
  (unless (display-graphic-p (selected-frame))
    (set-face-background 'default "unspecified-bg" (selected-frame))))

(add-hook 'server-after-make-frame-hook 'on-after-init)

(use-package! auth-source
  :config
  (setq auth-sources '(password-store)))

;(use-package! org-ai
;  :commands (org-ai-mode org-ai-global-mode)
;  :init
;  (add-hook 'org-mode-hook #'org-ai-mode)
;  (org-ai-global-mode)
;  :config
;  ;(setq org-ai-default-chat-model "gpt-4")
;  (setq org-ai-use-auth-source t)
;  (org-ai-install-yasnippets))

(use-package! gptel
  :config
  (setq! gptel-default-mode #'org-mode)
  (setq! gptel-model "gpt-4")
  )

(use-package! greader)

(use-package! lsp-grammarly
  :ensure t
  :hook (text-mode . (lambda ()
                       (require 'lsp-grammarly)
                       (lsp))))  ; or lsp-deferred
