(setq inhibit-startup-message t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
;; (setq initial-buffer-choice (lambda () (org-agenda nil "a")))

(scroll-bar-mode -1)  ; disable visible scrollbar
(tool-bar-mode -1)    ; disable the toolbar
(tooltip-mode -1)     ; disable tooltips
(set-fringe-mode 10)  ; give some breathing room

(menu-bar-mode -1)

(setq visible-bell t)

(set-face-attribute 'default nil :font "Fira Code Retina" :height 130)
;; (set-face-attribute 'default nil :height 120)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; (setopt
;;  display-buffer-base-action
;;  '((display-buffer-reuse-window display-buffer-same-window display-buffer-in-previous-window)
;;    (reusable-frames . 0)))

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
      

;; (use-package dashboard
;;   :ensure t
;;   :config
;;   (dashboard-setup-startup-hook))

;; (use-package command-log-mode)

;; treemacs
(use-package treemacs
  :ensure t
  :bind("<f5>" . treemacs)
  :custom
  (treemacs-is-never-other-window t)
  (treemacs-expand-after-init t)
  (treemacs-position 'left))
(add-hook 'emacs-startup-hook 'treemacs)

;; Sidebar with open buffers
(setq
 sr-speedbar-width 50
 sr-speedbar-max-width 50
 sr-speedbar-right-side t
 sr-speedbar-skip-other-window-p t
 sr-speedbar-use-frame-root-window t)
;; (global-set-key [f12] 'sr-speedbar-toggle)
;; (sr-speedbar-open)
;; (sr-speedbar-toggle)

;; Configure Ivy and Counsel
;; (use-package counsel
;;   :bind (("M-x" . counsel-M-x)
;;          ("C-x b" . counsel-ibuffer)
;;          ("C-x C-f" . counsel-find-file)
;;          :map minibuffer-local-map
;;          ("C-r" . 'counsel-minibuffer-history)))

;; (use-package ivy
;;   :config
;;   (ivy-mode 1))

;; (use-package ivy-rich
;;   :init
;;   (ivy-rich-mode 1))

;; (setq ivy-initial-inputs-alist nil)


;; helm
(use-package helm
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x b" . helm-mini))
  :config
  (setq helm-buffers-fuzzy-matching t)
  (setq helm-recentf-fuzzy-match t))

;; Restrict helm to the bottom-third of the screen
(use-package shackle
  :ensure t
  :after helm
  :diminish
  :config
  (setq helm-display-function 'pop-to-buffer) ; make helm play nice
  (setq shackle-rules '(("\\`\\*helm.*?\\*\\'"
                         :regexp t
                         :align t
                         :size 0.3)))
  (shackle-mode))


(require 'nerd-icons)
(use-package nerd-icons)

;; To configure fonts, run:
;; M-x nerd-icons-install-fonts

;; (use-package all-the-icons)

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
                shell-mode-hook
                treemacs-mode-hook))
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
  (setq org-pretty-entities t)
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-todo-keywords
        '((sequence "TODO" "INVESTIGATING" "DEVELOPING" "QUALIFYING" "|" "DONE" "CANCELLED"))))

(add-to-list 'org-entities-user
            ;'(NAME LATEX MATH-MODE? HTML ASCII LATIN-1 UTF-8)
             '("mapsto" "\\mapsto{}" t "&#8614;" "->" "->" "↦")
             '("vdash" "\\vdash{}" t "&vdash;" "|-" "|-" "⊦"))

;; (use-package git-auto-commit-mode)
;; (setq-default gac-automatically-push-p t)


;;  :config
;;  (setq org-ellipsis " ..."
;;        org-hide-emphasis-markers t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#292D3E" "#ff5370" "#c3e88d" "#ffcb6b" "#82aaff" "#c792ea" "#89DDFF" "#EEFFFF"])
 '(custom-safe-themes
   '("5f128efd37c6a87cd4ad8e8b7f2afaba425425524a68133ac0efd87291d05874" default))
 '(exwm-floating-border-color "#232635")
 '(fci-rule-color "#676E95")
 '(gdb-non-stop-setting nil t)
 '(highlight-tail-colors ((("#383f45") . 0) (("#323e51") . 20)))
 '(jdee-db-active-breakpoint-face-colors (cons "#1c1f2b" "#c792ea"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#1c1f2b" "#c3e88d"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#1c1f2b" "#676E95"))
 '(message-fill-column 100)
 '(objed-cursor-color "#ff5370")
 '(org-agenda-files '("/local-ssd/mdibello/docs/gecks.org"))
 '(package-selected-packages
   '(treemacs git-auto-commit-mode which-key rainbow-delimiters doom-themes doom-modeline all-the-icons ivy-rich counsel use-package))
 '(pdf-view-midnight-colors (cons "#EEFFFF" "#292D3E"))
 '(rustic-ansi-faces
   ["#292D3E" "#ff5370" "#c3e88d" "#ffcb6b" "#82aaff" "#c792ea" "#89DDFF" "#EEFFFF"])
 '(vc-annotate-background "#292D3E")
 '(vc-annotate-color-map
   (list
    (cons 20 "#c3e88d")
    (cons 40 "#d7de81")
    (cons 60 "#ebd476")
    (cons 80 "#ffcb6b")
    (cons 100 "#fcb66b")
    (cons 120 "#f9a16b")
    (cons 140 "#f78c6c")
    (cons 160 "#e78e96")
    (cons 180 "#d690c0")
    (cons 200 "#c792ea")
    (cons 220 "#d97dc1")
    (cons 240 "#ec6898")
    (cons 260 "#ff5370")
    (cons 280 "#d95979")
    (cons 300 "#b36082")
    (cons 320 "#8d678b")
    (cons 340 "#676E95")
    (cons 360 "#676E95")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
