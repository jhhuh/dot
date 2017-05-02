(setq auto-save-default nil)
(setq backup-inhibited nil)

(setq confirm-kill-emacs 'yes-or-no-p)

(global-hl-line-mode 1)

(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initials t)

(tool-bar-mode 0)
(scroll-bar-mode 0)

(toggle-truncate-lines)

;; MELPA
(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(require 'ido)
(ido-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (slime org-pomodoro))))
