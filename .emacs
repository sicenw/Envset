(show-paren-mode 1)
(column-number-mode 1)
(menu-bar-mode -1)
(eval-after-load 'ido (ido-mode 1))

(setq-default indent-tabs-mode nil)
(setq display-time-day-and-date 't)
(setq display-time-24hr-format 't)
(display-time)

;; (load-theme 'afternoon)
;; (load-file "~/.emacs.d/afternoon-theme.el")
(load-file "~/.emacs.d/god-mode/cl-lib-0.5.el")
;; (load-file "~/.emacs.d/autopair/autopair.el")
;; (require 'autopair)

;; ---- god-mode ----
;; https://github.com/chrisdone/god-mode.git
;; https://elpa.gnu.org/packages/cl-lib-0.5.el
;; ------------------
(load-file "~/.emacs.d/god-mode/god-mode.el")
(require 'god-mode)
(global-set-key (kbd "C-c ;")  'god-mode-all)
(define-key god-local-mode-map (kbd ".") 'repeat)
(define-key god-local-mode-map (kbd "i") 'god-local-mode)
(define-key god-local-mode-map (kbd "M-n") (lambda()
                                             (interactive)
                                             (next-line 5)))
(define-key god-local-mode-map (kbd "M-p") (lambda()
                                             (interactive)
                                             (previous-line 5)))
(load-file "~/.emacs.d/god-mode/god-mode-isearch.el")
(require 'god-mode-isearch)
(define-key isearch-mode-map (kbd "M-a") 'god-mode-isearch-activate)
(define-key god-mode-isearch-map (kbd "M-a") 'god-mode-isearch-disable)
(define-key god-mode-isearch-map (kbd "M-v") 'scroll-down)
(define-key god-mode-isearch-map (kbd "v") 'scroll-up)
(define-key god-mode-isearch-map (kbd "n") (lambda()
                                             (interactive)
                                             (isearch-exit)
                                             (next-line)))
(define-key god-mode-isearch-map (kbd "p") (lambda()
                                             (interactive)
                                             (isearch-exit)
                                             (previous-line)))

(defun duplicate-current-line-or-region (arg)
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg))))
  )
(global-set-key (kbd "C-M-j") 'duplicate-current-line-or-region)
(global-set-key (kbd "C-c d") 'duplicate-current-line-or-region)

(defun duplicate-and-comment-current-line-or-region (arg)
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (comment-or-uncomment-region beg end)
      (setq end (line-end-position))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (exchange-point-and-mark)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg 3))))  ;; under development
  )
(global-set-key (kbd "C-c M-d") 'duplicate-and-comment-current-line-or-region)

;; when you do not have a text selection, select the current line. 
(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy the current line."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (progn
       (message "Current line is copied.")
       (list (line-beginning-position) (line-end-position)))))
  )

;; when you do not have a text selection, select the whole of current line. 
(defadvice kill-region (before slick-copy activate compile)
  "When called interactively with no active region, cut the current line."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (progn
       (message "Current line is cut.")
       (let (beg (origin (point)))
         (setq beg (line-beginning-position))
         (forward-line 1)
         (list beg (line-beginning-position))))))
  )

;; put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
(defvar backup-dir (expand-file-name "~/.emacs.d/backup/"))
(defvar autosave-dir (expand-file-name "~/.emacs.d/autosave/"))
(setq backup-directory-alist (list (cons ".*" backup-dir)))
(setq auto-save-list-file-prefix autosave-dir)
(setq auto-save-file-name-transforms `((".*" ,autosave-dir t)))

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosave/" t)

;; backup by copying
(setq backup-by-copying t)

;; control how many backup versions to keep
(setq make-backup-files t               ; make ~ files
      ;; With nil, numbered backups are made only if they already exist.
      ;; A new backup version is made every time the file is loaded.
      version-control t ; set to t below if `backup-directory-alist' exists
      kept-old-versions 2
      kept-new-versions 6
      ;; Preserves permissions of file being edited. Also affects links.
      backup-by-copying nil
      backup-by-copying-when-linked t
      backup-by-copying-when-mismatch nil
      backup-by-copying-when-privileged-mismatch 200
      delete-old-versions t           ; auto-delete excess numbered backups
      delete-auto-save-files t          ; delete auto-save files on save
      auto-save-default t               ; auto-save on every visit
      auto-save-interval 200            ; input events between auto-saves
      auto-save-timeout 30)             ; seconds idleness before autosave

