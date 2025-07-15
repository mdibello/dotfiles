(setq inhibit-startup-message t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
;; (setq initial-buffer-choice (lambda () (org-todo-list)))

(scroll-bar-mode -1)  ; disable visible scrollbar
(tool-bar-mode -1)    ; disable the toolbar
(tooltip-mode -1)     ; disable tooltips
(set-fringe-mode 10)  ; give some breathing room

(menu-bar-mode -1)

(setq visible-bell t)

(set-face-attribute 'default nil :font "Fira Code Retina" :height 130)
;; (set-face-attribute 'default nil :height 120)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq-default indent-tabs-mode nil)

;; (setopt
;;  display-buffer-base-action
;;  '((display-buffer-reuse-window display-buffer-same-window display-buffer-in-previous-window)
;;    (reusable-frames . 0)))

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))


;; NOTE: if package fails to install, run `package-refresh-contents` and then try again
(package-initialize)
(unless package-archive-contents (package-refresh-contents))


;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package transpose-frame)

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

; (setf dired-kill-when-opening-new-dired-buffer t)
;; (setq delete-by-moving-to-trash t)
;; (setq load-prefer-newer t)
;; (put 'dired-find-alternate-file 'disabled nil)
;; (add-hook dired-mode-hook (lambda()
;; 			    (local-set-key (kbd "<mouse-2>") #'dired-find-alternate-file)
;; 			    (local-set-key (kbd "RET") #'dired-find-alternate-file)
;; 			    (local-set-key (kbd "^")
;; 					   (lambda () (interactive) (find-alternate-file "..")))))

(defun open-project ()
  (interactive)
  (projectile-dired)
  (magit-status))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'helm))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (setq projectile-project-search-path '("~/repositories"))
  (setq projectile-switch-project-action #'open-project)
  )

(use-package helm-projectile
  :ensure t
  :init (helm-projectile-on))


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

;; (add-to-list 'org-entities-user
;;             ;'(NAME LATEX MATH-MODE? HTML ASCII LATIN-1 UTF-8)
;;              '("mapsto" "\\mapsto{}" t "&#8614;" "->" "->" "↦")
;;              '("vdash" "\\vdash{}" t "&vdash;" "|-" "|-" "⊦"))

;; (use-package git-auto-commit-mode)
;; (setq-default gac-automatically-push-p t)

(require 'org-capture)

(global-set-key (kbd "C-c c") 'org-capture)

(setq org-capture-templates
      '(
        ;; === MEETINGS ===
	("m" "Meetings")

        ;; 1:1 meetings -> one-on-ones.org, header is the date
        ("m1" "Meeting: 1:1" entry
         (file "~/docs/one-on-ones.org")
         "* %u\n- %?")

        ;; Kanban meeting -> meetings.org, under Kanban -> date
        ("mk" "Meeting: Kanban" entry
         (file+headline "~/docs/meetings.org" "Kanban")
         "* %u\n- %?")

        ;; Brainstorming meeting -> meetings.org, under Brainstorming -> date
        ("mb" "Meeting: Brainstorming" entry
         (file+headline "~/docs/meetings.org" "Brainstorming")
         "* %u\n- %?")

        ;; ClassEP Brainstorming -> meetings.org, under ClassEP Brainstorming -> date
        ("mc" "Meeting: ClassEP Brainstorming" entry
         (file+headline "~/docs/meetings.org" "ClassEP Brainstorming")
         "* %u\n- %?")

        ;; KSMS -> ksm.org, under date
        ("ms" "Meeting: KSM" entry
         (file "~/docs/ksm.org")
         "* %u %?")

        ;; Other meeting -> meetings.org, under a prompted header
        ("mo" "Meeting: Other" entry
         (file+headline "~/docs/meetings.org" "Other")
         "* %u %?")

        ;; === JOURNAL ===
	("j" "Journal")

        ;; Morning goals -> journal.org, under Goals -> date
        ("jg" "Journal: Morning Goals" entry
         (file+datetree "~/docs/journal.org")
         "* Morning Goals\n- %?")

        ;; End-of-day wrapup -> journal.org, under Wrap-up -> date
        ("jw" "Journal: End-of-Day Wrap-up" entry
         (file+datetree "~/docs/journal.org")
         "* End-of-Day Wrap-up\n- %?")

        ;; === TODO ===
        ;; Todo -> todo.org, under date
        ("t" "Todo" entry
         (file+datetree "~/docs/todo.org")
         "* TODO %?")

        ;; === OTHER NOTES ===
	("n" "Notes")

        ;; Other notes -> misc.org, under a chosen header or prompt
        ("nm" "Note: MATLAB Coder" entry
         (file+headline "~/docs/misc.org" "MATLAB Coder")
         "* %?")
        ("nc" "Note: C++" entry
         (file+headline "~/docs/misc.org" "C++")
         "* %?")
        ("nd" "Note: Dev Processes" entry
         (file+headline "~/docs/misc.org" "Dev Processes")
         "* %?")
        ("nl" "Note: Linux" entry
         (file+headline "~/docs/misc.org" "Linux")
         "* %?")
        ("no" "Note: Other" entry
         (file+headline "~/docs/misc.org" "Other")
         "* %?")
        ))



(use-package org-super-agenda)
(org-super-agenda-mode)
(setq org-agenda-files '("~/docs"))
(setq org-agenda-window-setup 'current-window)
(setq org-agenda-tags-column -120)
(setq org-super-agenda-groups
      '((:name "Today"
	       :time-grid t)
	(:name "Gecks"
	       :and (:not (:todo "DONE") :not (:todo "CANCELLED") :tag "gecks"))
	(:name "General"
	       :and (:not (:todo "DONE") :not (:todo "CANCELLED") :not (:tag "gecks") :not (:tag "learning")))
	(:name "Learning (Active)"
	       :and (:todo "TODO" :tag "learning" :not (:tag "backlog")))
	(:name "Learning (Backlog)"
	       :and (:todo "TODO" :tag "learning" :tag "backlog"))
	)
      )

(defun org-agenda-and-todo ()
  "Display the weekly org-agenda and all TODOs."
  (interactive)
  (org-agenda nil "n"))

(global-set-key (kbd "C-c t") 'org-agenda-and-todo)
(setq initial-buffer-choice 'org-agenda-and-todo)


(use-package magit
  :ensure t)

;; (org-agenda nil "n")

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
