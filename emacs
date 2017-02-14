;; open in same buffer
(setq special-display-regexps nil)

;; tab completion
(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initials t)

;; disable aquamacs tabbar, tool-bar, scroll-bar
;(tabbar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

;; Some AUCTeX tweaks
(set-default 'preview-scale-function .4)
(custom-set-variables
 '(LaTeX-command "latex -synctex=1")
 '(TeX-view-program-list (quote (("Skim" "/Applications/Skim.app/Contents/SharedSupport/displayline %n %o %b") ("Preview" "open -a Preview.app %o"))))
)
(setq TeX-source-correlate-method 'synctex)
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode) 

;; soft wrap
(toggle-truncate-lines)

;; MELPA
(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("elpy" . "http://jorgenschaefer.github.io/packages/"))
(package-initialize)

;; display battery life
(display-battery-mode 1)

;; load-theme
;(require 'zenburn-theme)
;(load-theme 'zenburn t)

;; ido-mode
(require 'ido)
(ido-mode t)

;; auto-complete
;;(require 'auto-complete)
;;(global-auto-complete-mode t)

;; yasnippet
; I needed to change the name of the file 'go-mode/default' to 'go-mode/defaultGo',
; or put an empty 'default' file in '~/Library/Preferences/[Aquamacs]/' or 
; '~/Library/Application Support/[Aquamacs]/'
;;(require 'yasnippet)
;;(yas-global-mode t)

;; confirm-kill-emacs
(setq confirm-kill-emacs 'yes-or-no-p)

;; global current line highlight
(global-hl-line-mode 1)

;; evil-mode
;;(require 'evil)
;;(evil-mode 1)

;; powerline-evil
;;(require 'powerline-evil)
;;(powerline-evil-vim-color-theme)

;; Bind SPC SPC to execute-extended-command
;;(define-key evil-visual-state-map (kbd "SPC SPC") 'execute-extended-command)
;;(define-key evil-normal-state-map (kbd "SPC SPC") 'execute-extended-command)
;; evil + toggle-trucate-lines
;;(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
;;(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
;;(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
;;(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
;;(define-key evil-normal-state-map (kbd "<remap> <evil-backward-char>") 'left-char)
;;(define-key evil-motion-state-map (kbd "<remap> <evil-forward-char>") 'right-char)
;;(define-key evil-normal-state-map (kbd "<remap> <evil-backward-char>") 'left-char)
;;(define-key evil-motion-state-map (kbd "<remap> <evil-forward-char>") 'right-char)

;; magit-status binding
;;(define-key evil-visual-state-map (kbd "gs") 'magit-status)
;;(define-key evil-normal-state-map (kbd "gs") 'magit-status)

;; bind <tab> for outline-minor-mode
;; (defmacro define-context-key (keymap key predicate command &optional mode)
;;   "Bind KEY in KEYMAP to a command which calls COMMAND if PREDICATE is non-nil.

;; If PREDICATE doesn't match and KEY is normally bound in KEYMAP,
;; the corresponding default command will be executed.

;; If KEY isn't normally bound in KEYMAP, MODE (defaulting to
;; s/KEYMAP/-map//) will be disabled temporally (to prevent an
;; infinite recursion) and the function which is then bound to KEY
;; will be called.

;; Here're two examples:

;;   ;; TAB on an outline heading toggles visibility in outline-minor-mode
;;   (define-context-key outline-minor-mode-map
;;     (kbd \"TAB\")
;;     ;; This evals to non-nil, if `point' is on a outline-heading
;;     (save-excursion
;;       (goto-char (line-beginning-position))
;;       (looking-at outline-regexp))
;;     outline-toggle-children)

;;   ;; TAB at end of line insert a TAB character
;;   (define-context-key outline-minor-mode-map
;;     (kbd \"TAB\")
;;     eolp
;;     self-insert-command)

;; The context key for KEYMAP and KEY which was given as last has
;; precedence, so in this example TAB at the end of a line of an
;; outline heading inserts a TAB and doesn't toggle the visibility."
;;   (let* ((mode (or mode
;;                    (intern (replace-regexp-in-string "-map" ""
;;                                                      (symbol-name keymap)))))
;;          (default-fun (lookup-key (symbol-value keymap) (eval key))))
;;     `(define-key ,keymap ,key
;;        (defun ,(gensym "context-key-") ()
;;          ,(concat "Execute " (symbol-name command)
;;                   " if " (format "%s" predicate) " matches.")
;;          (interactive)
;;          (if (cond
;;               ((user-variable-p (quote ,predicate))
;;                ,predicate)
;;               ((functionp (quote ,predicate))
;;                (funcall (quote ,predicate)))
;;               (t
;;                (eval ,predicate)))
;;              (call-interactively (quote ,command))
;;            (if (quote ,default-fun)
;;                (call-interactively (quote ,default-fun))
;;              (let (,mode)
;;                (call-interactively (key-binding ,key)))))))))
;; (define-context-key hs-minor-mode-map
;;   (kbd "TAB")
;;   (let ((obj (car (overlays-in
;;                    (save-excursion (move-beginning-of-line nil) (point))
;;                    (save-excursion (move-end-of-line nil) (point))))))
;;     (and (null obj)
;;          (eq last-command this-command)))
;; hs-hide-block)
