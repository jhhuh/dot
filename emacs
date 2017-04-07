;; tab completion
(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initials t)

;; disable aquamacs tabbar, tool-bar, scroll-bar
;(tabbar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
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

(display-battery-mode 1)
(require 'ido)
(ido-mode t)
(setq confirm-kill-emacs 'yes-or-no-p)
(global-hl-line-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (slime org-pomodoro))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
