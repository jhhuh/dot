;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Ji-Haeng Huh"
      user-mail-address "jhhuh.note@gmail.com")

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
(setq doom-font (font-spec :family "Ubuntu Mono" :size 24)
     doom-big-font (font-spec :family "Ubuntu Mono" :size 48)
     doom-variable-pitch-font (font-spec :family "sans" :size 24))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-ir-black)
(setq doom-theme 'leuven)

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
;; they are implemented.

(setq which-key-idle-delay 0.01)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(after! lsp-ui
  (setq lsp-ui-doc-position 'top))

(after! lsp-haskell
  (setq lsp-haskell-formatting-provider "floskell"))

;; (defun markdown-raw-links (&rest ignore)
;;   "Convert link markup [ANCHOR](URL) to raw URL
;;      so lsp-ui-doc--make-clickable-link can find it"
;;   (save-excursion
;;     (goto-char (point-min))
;;     (while (re-search-forward markdown-regex-link-inline nil t)
;;       (replace-match (replace-regexp-in-string "\n" "" (match-string 6))))))
;; (advice-add 'lsp--render-markdown :before #'markdown-raw-links)
