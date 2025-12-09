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

(setq sgml-basic-offset 4)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; (setq display-buffer-base-action
;;      '((display-buffer-reuse-window
;;         display-buffer-use-some-window)))

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

;; (require 'cl-lib)

;; (require 'desktop)
;; (desktop-save-mode 1)
;; (defun my-desktop-save ()
;;   (interactive)
;;   ;; Don't call desktop-save-in-desktop-dir, as it prints a message.
;;   (if (eq (desktop-owner) (emacs-pid))
;;       (desktop-save desktop-dirname)))
;; (add-hook 'auto-save-hook 'my-desktop-save)

      
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
;; (add-hook 'emacs-startup-hook 'treemacs)

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

;; (require 'ibuffer)

(use-package ibuffer-sidebar
  :ensure t
  ;; :commands (ibuffer-sidebar-toggle-sidebar)
  :init
  (setq ibuffer-sidebar-width 30)
  (setq ibuffer-sidebar-display-column-titles nil)
  (setq ibuffer-sidebar-display-summary nil)
  (setq ibuffer-sidebar-refresh-timer 1)
  :config
  ;; Open sidebar on Emacs start
  ;;(define-key ibuffer-sidebar-mode-map [mouse-1] #'ibuffer-sidebar-visit-buffer)
  ;; (add-hook 'emacs-startup-hook #'ibuffer-sidebar-toggle-sidebar)
  )

(with-eval-after-load 'ibuffer-sidebar
  (add-hook 'ibuffer-sidebar-mode-hook
            (lambda ()
              (setq-local ibuffer-never-show-predicates
                          '("^\\*.*\\*$"))))
  (add-hook 'ibuffer-sidebar-mode-hook
          (lambda ()
            (display-line-numbers-mode 0))))



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
  (setq helm-recentf-fuzzy-match t)
  (setq helm-move-to-line-cycle-in-source nil))

;; Enable the global helm minor mode after emacs is initialized
;; (add-hook 'after-init-hook 'helm-mode)

(defun mrd/correct-helm-keybinds()
    (define-key helm-find-files-map (kbd "<tab>") 'helm-execute-persistent-action)
    (define-key helm-find-files-map (kbd "C-<backspace>") 'helm-find-files-up-one-level))

;; (add-hook 'after-init-hook 'mrd/correct-helm-keybinds);

;; (use-package helm-files
;;   :bind (:map helm-find-files-map
;;               ("<C-backspace>" . helm-find-files-up-one-level)
;;               ("<tab>" . helm-execute-persistent-action)))
 
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
                         :size 0.33)))
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
  ;; :bind-keymap
  ;; ("C-c p" . projectile-command-map)
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


;; org mode config
(defun mrd/org-mode-setup()
  (org-indent-mode)
;;  (auto-fill-mode 0)
  (visual-line-mode 1)
  (add-to-list 'org-entities-user
            ;'(NAME LATEX MATH-MODE? HTML ASCII LATIN-1 UTF-8)
             '("mapsto" "\\mapsto{}" t "&#8614;" "->" "->" "↦")
             '("vdash" "\\vdash{}" t "&vdash;" "|-" "|-" "⊦")))

(use-package org
  :hook (org-mode . mrd/org-mode-setup)
  :config
  (setq org-pretty-entities t)
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-todo-keywords
        '((sequence "TODO" "IN PROGRESS" "|" "DONE" "CANCELLED")))
  (setq org-agenda-files '("/local-ssd/mdibello/docs")))


(use-package pdf-tools
  :disabled
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  :custom
  (pdf-view-display-size 'fit-page)
  :bind
  (:map pdf-view-mode-map
    ("O" . pdf-occur)
    ("d" . pdf-view-midnight-minor-mode)
    ("s a" . pdf-view-auto-slice-minor-mode)
    ("t" . (lambda (beg end) (interactive "r") (go-translate))))
  :hook
  (pdf-view-mode . pdf-links-minor-mode)
  (pdf-view-mode . pdf-isearch-minor-mode)
  (pdf-view-mode . pdf-outline-minor-mode)
  (pdf-view-mode . pdf-history-minor-mode)
  :config
  (with-eval-after-load 'pdf-links
    (define-key pdf-links-minor-mode-map (kbd "f") 'pdf-links-action-perform)))

(pdf-tools-install)
(use-package org-noter
  :config
  ;; (require 'org-noter-pdftools)
  (setq org-noter-highlight-selected-text t))

(use-package org-pdftools
  :hook (org-mode . org-pdftools-setup-link))

;; (use-package org-noter-pdftools
;;   :after org-noter
;;   :config
;;   ;; Add a function to ensure precise note is inserted
;;   (defun org-noter-pdftools-insert-precise-note (&optional toggle-no-questions)
;;     (interactive "P")
;;     (org-noter--with-valid-session
;;      (let ((org-noter-insert-note-no-questions (if toggle-no-questions
;;                                                    (not org-noter-insert-note-no-questions)
;;                                                  org-noter-insert-note-no-questions))
;;            (org-pdftools-use-isearch-link t)
;;            (org-pdftools-use-freepointer-annot t))
;;        (org-noter-insert-note (org-noter--get-precise-info)))))

;;   ;; fix https://github.com/weirdNox/org-noter/pull/93/commits/f8349ae7575e599f375de1be6be2d0d5de4e6cbf
;;   (defun org-noter-set-start-location (&optional arg)
;;     "When opening a session with this document, go to the current location.
;; With a prefix ARG, remove start location."
;;     (interactive "P")
;;     (org-noter--with-valid-session
;;      (let ((inhibit-read-only t)
;;            (ast (org-noter--parse-root))
;;            (location (org-noter--doc-approx-location (when (called-interactively-p 'any) 'interactive))))
;;        (with-current-buffer (org-noter--session-notes-buffer session)
;;          (org-with-wide-buffer
;;           (goto-char (org-element-property :begin ast))
;;           (if arg
;;               (org-entry-delete nil org-noter-property-note-location)
;;             (org-entry-put nil org-noter-property-note-location
;;                            (org-noter--pretty-print-location location))))))))
;;   (with-eval-after-load 'pdf-annot
;;     (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note)))

;; Improved help system
;; Look into the `helpful` packages

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
        ;; === GECKS ===
        ("g" "Geck TODO" entry
         (file "~/docs/gecks.org")
         "* TODO %^{Task name}
:PROPERTIES:
:EFFORT: %^{Time estimate (hours)} :gecks:
:END:
  - [ ] Investigate geck
  - [ ] Implement solution
  - [ ] Perform initial qualification
  - [ ] Run test suite
  - [ ] Create reviewboard
  - [ ] Review test results
  - [ ] Address test results
  - [ ] Address reviewboard feedback
  - [ ] Re-run qualification
  - [ ] Update reviewboard
  - [ ] Submit
")
        
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

(setq org-enforce-todo-dependencies t)
(setq org-hierarchical-todo-statistics t)

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
	(:name "General (Active)"
	       :and (:not (:todo "DONE") :not (:todo "CANCELLED") :not (:tag "gecks") :not (:tag "learning") :not (:tag "backlog")))
	(:name "General (Backlog)"
	       :and (:not (:todo "DONE") :not (:todo "CANCELLED") :not (:tag "gecks") :not (:tag "learning") :tag "backlog"))
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

(defun my/org-add-clock-for-last-hours (hours)
  "For the TODO heading at point, add a CLOCK entry from HOURS hours ago to now."
  (interactive "nHours: ")
  (unless (derived-mode-p 'org-mode)
    (user-error "Not in org-mode"))
  (save-excursion
    (org-back-to-heading t)
    (let* ((now (current-time))
           (start (time-subtract now (seconds-to-time (floor (* hours 3600)))))
           (start-str (format-time-string (org-time-stamp-format t t) start))
           (end-str   (format-time-string (org-time-stamp-format t t) now))
           (duration  (org-duration-from-minutes
                       (round (/ (float-time (time-subtract now start)) 60.0)))))
      ;; Ensure we are on a headline
      (unless (org-before-first-heading-p)
        ;; Ensure CLOCK drawer exists at this entry
        (org-back-to-heading t)
        (org-end-of-meta-data)
        (let ((drawer-pos (save-excursion
                            (org-log-beginning t))))
          (unless drawer-pos
            ;; Insert a LOGBOOK drawer if none exists; org will reuse it for CLOCK
            (save-excursion
              (org-back-to-heading t)
              (org-end-of-meta-data)
              (insert ":LOGBOOK:\n:END:\n"))))
        ;; Insert the CLOCK line at the right place
        (save-excursion
          (let ((logpos (or (save-excursion (org-log-beginning t))
                            (progn
                              (org-end-of-meta-data)
                              (point)))))
            (goto-char logpos)
            ;; Move to just before :END:
            (save-excursion
              (re-search-forward "^[ \t]*:END:" (org-entry-end-position) t))
            (re-search-forward "^[ \t]*:END:" (org-entry-end-position) t)
            (beginning-of-line)
            (open-line 1)
            (insert (format "CLOCK: [[%s]]--[[%s]] =>  %s"
                            start-str end-str duration))))))))

;; Optional convenience: bind to a key in org-mode
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c C-x H") #'my/org-add-clock-for-last-hours))

;; (global-set-key (kbd "C-c t") 'org-agenda-and-todo)
;; (setq initial-buffer-choice 'org-agenda-and-todo)


(use-package magit
  :ensure t)

(global-set-key (kbd "C-x g") 'magit-status)

;; (org-agenda nil "n")

;;  :config
;;  (setq org-ellipsis " ..."
;;        org-hide-emphasis-markers t))

(defun aborn/backward-kill-word ()
  "Customize/Smart backward-kill-word."
  (interactive)
  (let* ((cp (point))
         (backword)
         (end)
         (space-pos)
         (backword-char (if (bobp)
                            ""           ;; cursor in begin of buffer
                          (buffer-substring cp (- cp 1)))))
    (if (equal (length backword-char) (string-width backword-char))
        (progn
          (save-excursion
            (setq backword (buffer-substring (point) (progn (forward-word -1) (point)))))
          (setq ab/debug backword)
          (save-excursion
            (when (and backword          ;; when backword contains space
                       (s-contains? " " backword))
              (setq space-pos (ignore-errors (search-backward " ")))))
          (save-excursion
            (let* ((pos (ignore-errors (search-backward-regexp "\n")))
                   (substr (when pos (buffer-substring pos cp))))
              (when (or (and substr (s-blank? (s-trim substr)))
                        (s-contains? "\n" backword))
                (setq end pos))))
          (if end
              (kill-region cp end)
            (if space-pos
                (kill-region cp space-pos)
              (backward-kill-word 1))))
      (kill-region cp (- cp 1)))         ;; word is non-english word
    ))

(global-set-key  [C-backspace]
                 'aborn/backward-kill-word)


(defvar bd-url "https://bd-on-prem.ipws.mathworks.com/static/beardedDragon.html?geck=%s")

(defun is-geck (s)
  (and (stringp s)
       (string-match-p "^[Gg][0-9]\\{0,8\\}$" s)))

(defun open-geck-in-bd ()
  (interactive)
  (let* ((word (thing-at-point 'word t)))
    (if (or (not word) (not (is-geck word)))
        (message "No geck at point!")
      (let ((url (format bd-url (url-hexify-string word))))
        (browse-url url)))))

(global-set-key (kbd "C-M-g") #'open-geck-in-bd)

(defun org-todo-today ()
  "Move all TODO and IN PROGRESS items to a new header at the top of the file."
  (interactive)
  (let* ((today (format-time-string "* <%Y-%m-%d %a>\n"))
         (todo-lines '()))
    (save-excursion
      ;; Go to the end of the buffer to iterate upwards
      (goto-char (point-max))
      (while (not (bobp))
        (forward-line -1)
        (let ((line (thing-at-point 'line t)))
          (when (or (string-match-p "^\\*\\* TODO " line)
                    (string-match-p "^\\*\\* IN PROGRESS " line))
            (push line todo-lines)
            ;; Delete the line
            (delete-region (line-beginning-position) (line-beginning-position 2))))))
    ;; Now insert at the top of the buffer
    (goto-char (point-min))
    (insert today)
    (dolist (line todo-lines)
      (insert line))
    (message "Moved all TODO and IN PROGRESS items to today's header.")))


;; (defun p4-opened-files ()
;;   "Get the list of files opened in Perforce in the current directory."
;;   (let ((output (shell-command-to-string "p4 opened")))
;;     (when (not (string-match-p "File\(s\) not opened on this client." output))
;;       (let ((lines (split-string output "\n" t)))
;;         (mapcar (lambda (line)
;;                   (when (string-match "\\(matlab/[^#]+\\)" line)
;;                     (match-string 1 line)))
;;                 lines)))))

;; (defun in-perforce-repo-p ()
;;   "Return non-nil if the current directory is under Perforce control."
;;   (let ((output (shell-command-to-string "p4 info 2>&1")))
;;     (not (string-match-p "Perforce client error" output))))

;; (defun p4-where-full-path (relative-path)
;;   "Return the full local path for RELATIVE-PATH using `p4 where`."
;;   (let* ((output (shell-command-to-string (format "p4 where %s" relative-path)))
;;          (fields (split-string output)))
;;     (nth 2 fields))) ;; third path is the local path

;; (defun load-perforce-and-open-p4-files ()
;;   "Load Perforce, check for repo, and open all opened files."
;;   ;; (require 'p4) ;; or (load "p4") if you load it differently
;;   (when (in-perforce-repo-p)
;;     (let ((files (p4-opened-files)))
;;       ;; (message files)
;;       (dolist (file files)
;;         ;; (message (p4-where-full-path file))
;;         (when file
;;           (message (p4-where-full-path file)))))))

;; ;; Run after Emacs startup
;; (add-hook 'emacs-startup-hook #'load-perforce-and-open-p4-files)


(use-package gnu-elpa-keyring-update)

;; AUCTeX: the LaTeX major mode
(use-package tex
  :ensure auctex
  :defer t
  :hook ((LaTeX-mode . visual-line-mode)
         (LaTeX-mode . LaTeX-math-mode)
         (LaTeX-mode . reftex-mode))
  :config
  ;; Enable parsing of local settings
  (setq TeX-parse-self t)
  (setq TeX-auto-save t)

  ;; Use pdf-tools for preview inside Emacs
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
        TeX-source-correlate-start-server t)

  ;; Use latexmk for compilation
  (setq TeX-command-default "LatexMk")
  (add-to-list 'TeX-command-list
               '("LatexMk" "latexmk -lualatex -pdf -interaction=nonstopmode -synctex=1 %s"
                 TeX-run-TeX nil t :help "Run LatexMk")))

;; RefTeX: cross-references, bibliographies, and TOC navigation
(use-package reftex
  :after tex
  :hook (LaTeX-mode . reftex-mode)
  :config
  (setq reftex-plug-into-AUCTeX t))

;; Optional: pdf-tools for integrated PDF viewing
(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install)
  ;; SyncTeX forward/backward search
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
  (setq TeX-source-correlate-mode t)
  (setq TeX-source-correlate-start-server t))

;; Company-mode backend for LaTeX symbols
;; (use-package company-auctex
;;   :after (company tex)
;;   :config
;;   (company-auctex-init))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#292D3E" "#ff5370" "#c3e88d" "#ffcb6b" "#82aaff" "#c792ea" "#89DDFF" "#EEFFFF"])
 '(c-doc-comment-style
   '((java-mode . javadoc) (pike-mode . autodoc) (c-mode . doxygen) (c++-mode . doxygen)
     (objc-mode . doxygen)))
 '(custom-safe-themes
   '("5f128efd37c6a87cd4ad8e8b7f2afaba425425524a68133ac0efd87291d05874" default))
 '(exwm-floating-border-color "#232635")
 '(fci-rule-color "#676E95")
 '(gdb-non-stop-setting nil t)
 '(git-commit-summary-max-length 100)
 '(highlight-tail-colors ((("#383f45") . 0) (("#323e51") . 20)))
 '(jdee-db-active-breakpoint-face-colors (cons "#1c1f2b" "#c792ea"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#1c1f2b" "#c3e88d"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#1c1f2b" "#676E95"))
 '(message-fill-column 100)
 '(objed-cursor-color "#ff5370")
 '(package-selected-packages
   '(all-the-icons auctex company-auctex counsel doom-modeline doom-themes git-auto-commit-mode
                   gnu-elpa-keyring-update ivy-rich rainbow-delimiters treemacs use-package
                   which-key))
 '(pdf-view-midnight-colors (cons "#EEFFFF" "#292D3E"))
 '(rustic-ansi-faces
   ["#292D3E" "#ff5370" "#c3e88d" "#ffcb6b" "#82aaff" "#c792ea" "#89DDFF" "#EEFFFF"])
 '(sb-mlint-locations '((vdi-ahddp-012 . "/local-ssd/mdibello/g3791790/matlab/")))
 '(vc-annotate-background "#292D3E")
 '(vc-annotate-color-map
   (list (cons 20 "#c3e88d") (cons 40 "#d7de81") (cons 60 "#ebd476") (cons 80 "#ffcb6b")
         (cons 100 "#fcb66b") (cons 120 "#f9a16b") (cons 140 "#f78c6c") (cons 160 "#e78e96")
         (cons 180 "#d690c0") (cons 200 "#c792ea") (cons 220 "#d97dc1") (cons 240 "#ec6898")
         (cons 260 "#ff5370") (cons 280 "#d95979") (cons 300 "#b36082") (cons 320 "#8d678b")
         (cons 340 "#676E95") (cons 360 "#676E95")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(woman-unknown ((t (:inherit font-lock-warning-face :foreground "red4")))))
