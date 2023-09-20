(setq inhibit-startup-message t)

(scroll-bar-mode -1)  ; disable visible scrollbar
(tool-bar-mode -1)    ; disable the toolbar
(tooltip-mode -1)     ; disable tooltips
(set-fringe-mode 10)  ; give some breathing room

(menu-bar-mode -1)

(setq visible-bell t)

;; (set-face-attribute 'default nil :font "Fira Code Retina" :height 80)
(set-face-attribute 'default nil :height 120)


;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents (package-refresh-contents))


;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
      

;; (use-package command-log-mode)

;; Configure Ivy and Counsel
(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package ivy
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(setq ivy-initial-inputs-alist nil)


(use-package all-the-icons)

;; To configure fonts:
;; M-x all-the-icons-install-fonts
;; fc-cache -f -v

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 30))

(use-package doom-themes)

(load-theme 'doom-palenight t)

;; Enable line numbers
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                eshell-mode-hook
                shell-mode-hook))
  (add-hook mode (lambda() (display-line-numbers-mode 0))))


;; Add some contrast to delimiters when editting code files
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Interactive keypress assistant
(use-package which-key
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 1))


;; Improved help system
;; Look into the `helpful` packages

;; org mode config
(defun mrd/org-mode-setup()
  (org-indent-mode)
;;  (auto-fill-mode 0)
  (visual-line-mode 1))

(use-package org
  :hook (org-mode . mrd/org-mode-setup)
  :config
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t))

;; (setq-default gac-automatically-push-p t)


;;  :config
;;  (setq org-ellipsis " ..."
;;        org-hide-emphasis-markers t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(which-key rainbow-delimiters doom-themes doom-modeline all-the-icons ivy-rich counsel use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
