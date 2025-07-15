(defun my/ibuffer-sidebar ()
  "Open `ibuffer' in a dedicated left sidebar window."
  (interactive)
  (let ((buf (get-buffer-create "*Ibuffer Sidebar*")))
    (unless (get-buffer-window buf)
      (let ((window (split-window (frame-root-window) 30 'left)))
        (set-window-buffer window buf)
        (set-window-dedicated-p window t)
        (with-current-buffer buf
          (ibuffer)
          (setq-local cursor-type nil) ; Hide cursor
          (setq-local mode-line-format nil))))))

;; Automatically open ibuffer sidebar on startup
(add-hook 'emacs-startup-hook #'my/ibuffer-sidebar)

(defun my/ensure-ibuffer-sidebar ()
  (unless (get-buffer-window "*Ibuffer Sidebar*")
    (my/ibuffer-sidebar)))

(add-hook 'window-configuration-change-hook #'my/ensure-ibuffer-sidebar)

(defvar my/ibuffer-last-selected-window nil
  "The last selected window before ibuffer sidebar.")

(defun my/save-last-selected-window ()
  "Save the currently selected window unless it's the ibuffer sidebar."
  (let ((buf (window-buffer)))
    (unless (string= (buffer-name buf) "*Ibuffer Sidebar*")
      (setq my/ibuffer-last-selected-window (selected-window)))))

(add-hook 'buffer-list-update-hook #'my/save-last-selected-window)

(defun my/ibuffer-visit-buffer-other-window (&optional arg)
  "Visit buffer at point in previously selected window."
  (interactive "P")
  (let ((buf (ibuffer-current-buffer)))
    (when (window-live-p my/ibuffer-last-selected-window)
      (select-window my/ibuffer-last-selected-window)
      (switch-to-buffer buf))))

;; Bind mouse click and RET in ibuffer to our function
(with-eval-after-load 'ibuffer
  (define-key ibuffer-mode-map (kbd "RET") #'my/ibuffer-visit-buffer-other-window)
  (define-key ibuffer-mode-map [mouse-1] #'my/ibuffer-visit-buffer-other-window))
