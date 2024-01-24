;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Ji-Haeng Huh"
      user-mail-address "jhhuh.korea@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;

(cond ((string= (system-name) "cafe")
       (setq doom-font (font-spec :family "IosevkaTerm Nerd Font Mono" :size 14.0 :weight 'regular)
             doom-big-font (font-spec :family "IosevkaTerm Nerd Font Mono" :size 16.0)
             doom-variable-pitch-font (font-spec :family "sans" :size 14.0)))
      ((string= (system-name) "x230")
       (setq doom-font (font-spec :family "Ubuntu Nerd Font Mono" :size 16.0 :weight 'regular)
             doom-variable-pitch-font (font-spec :family "sans" :size 12.0)))
      ((string= (system-name) "p1gen3")
       (setq doom-font (font-spec :family "IosevkaTerm Nerd Font Mono" :size 10.0)
             doom-big-font (font-spec :family "IosevkaTerm Nerd Font Mono" :size 12.0)
             doom-variable-pitch-font (font-spec :family "sans" :size 10.0)))
      (t
       (setq doom-font (font-spec :family "Ubuntu Nerd Font Mono" :size 16.0 :weight 'regular)
             doom-variable-pitch-font (font-spec :family "sans" :size 12.0))))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

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

(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main")

  (defun workspaces-formatted ()
    (+doom-dashboard--center (frame-width) (+workspace--tabline)))

  (defun hy/invisible-current-workspace ()
    (propertize (safe-persp-name (get-current-persp)) 'invisible t))

  (customize-set-variable 'tab-bar-format '(+workspace--tabline tab-bar-format-align-right hy/invisible-current-workspace))

  (advice-add #'+workspace/display :override #'ignore)
  (advice-add #'+workspace-message :override #'ignore))

(run-at-time nil nil (cmd! (tab-bar-mode +1)))

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
  (setq! auth-sources '(password-store))
  (setq! auth-source-cache-expiry nil))

(use-package! gptel
  :config
  (setq! gptel-default-mode #'org-mode
        gptel-model "gpt-4-1106-preview"
        gptel-temperature 0.0)
  )

(use-package! gptel-extensions)

(use-package! codegpt
  :ensure t
  :config
  (setq! openai-key #'openai-key-auth-source))

(use-package! codegpt
  :ensure t
  :config
  (setq! codegpt-tunnel 'chat            ; The default is 'completion
        codegpt-model "gpt-")) ; You can pick any model you want!

(use-package! chatgpt
  :ensure t
  :config
  (setq! chatgpt-model "gpt-4"))

;; Upstream dash-docs is broken for async functionality
(defun dash-docs-async-install-docset (docset-name)
  "Asynchronously download docset with specified DOCSET-NAME and move its stuff to docsets-path."
  (interactive (list (dash-docs-read-docset "Install docset" (dash-docs-official-docsets))))
  (when (dash-docs--ensure-created-docsets-path (dash-docs-docsets-path))
    (let ((feed-url (format "%s/%s.xml" dash-docs-docsets-url docset-name)))
      (message (concat "The docset \"" docset-name "\" will now be installed asynchronously."))
      (async-start ; First async call gets the docset meta data
       `(lambda ()
          ;; Beware! This lambda is run in it's own instance of emacs.
          (url-file-local-copy ,feed-url))
       (lambda (filename)
         (let ((docset-url (dash-docs-get-docset-url filename)))
           (async-start     ; Second async call gets the docset itself
            `(lambda ()
               ;; Beware! This lambda is run in it's own instance of emacs.
               (url-file-local-copy ,docset-url))
            (lambda (docset-tmp-path)
              (let ((docset-folder (dash-docs-extract-and-get-folder docset-tmp-path)))
                (dash-docs-activate-docset docset-folder)
                (message (format
                          "Docset installed. Add \"%s\" to dash-docs-common-docsets or dash-docs-docsets."
                          docset-folder)))))))))))

;(use-package! org-ai
;  :commands (org-ai-mode org-ai-global-mode)
;  :init
;  (add-hook 'org-mode-hook #'org-ai-mode)
;  (org-ai-global-mode)
;  :config
;  ;(setq org-ai-default-chat-model "gpt-4")
;  (setq org-ai-use-auth-source t)
;  (org-ai-install-yasnippets))

;(use-package! greader)

;; (use-package! lsp-grammarly
;;   :ensure t
;;   :hook (text-mode . (lambda ()
;;                        (require 'lsp-grammarly)
;;                        (lsp))))  ; or lsp-deferred
