;; -----------------------------------------------------------------------------
;; See http://www.emacswiki.org/emacs/VisualLineMode
(defvar visual-wrap-column nil)

(defun set-visual-wrap-column (new-wrap-column &optional buffer)
      "Force visual line wrap at NEW-WRAP-COLUMN in BUFFER (defaults
    to current buffer) by setting the right-hand margin on every
    window that displays BUFFER.  A value of NIL or 0 for
    NEW-WRAP-COLUMN disables this behavior."
      (interactive (list (read-number "New visual wrap column, 0 to disable: " (or visual-wrap-column fill-column 0))))
      (if (and (numberp new-wrap-column)
               (zerop new-wrap-column))
        (setq new-wrap-column nil))
      (with-current-buffer (or buffer (current-buffer))
        (visual-line-mode t)
        (set (make-local-variable 'visual-wrap-column) new-wrap-column)
        (add-hook 'window-configuration-change-hook 'update-visual-wrap-column nil t)
        (let ((windows (get-buffer-window-list)))
          (while windows
            (when (window-live-p (car windows))
              (with-selected-window (car windows)
                (update-visual-wrap-column)))
            (setq windows (cdr windows))))))

(defun update-visual-wrap-column ()
      (if (not visual-wrap-column)
        (set-window-margins nil nil)
        (let* ((current-margins (window-margins))
               (right-margin (or (cdr current-margins) 0))
               (current-width (window-width))
               (current-available (+ current-width right-margin)))
          (if (<= current-available visual-wrap-column)
            (set-window-margins nil (car current-margins))
            (set-window-margins nil (car current-margins)
                                (- current-available visual-wrap-column))))))

;; -----------------------------------------------------------------------------
;; See http://nileshk.com/2009/06/13/prompt-before-closing-emacs.html
(defun ask-before-closing ()
  "Ask whether or not to close, and then close if y was pressed"
  (interactive)
  (if (y-or-n-p (format "Are you sure you want to exit Emacs? "))
      (if (< emacs-major-version 22)
          (save-buffers-kill-terminal)
        (save-buffers-kill-emacs))
    (message "Canceled exit")))

(when window-system
  (global-set-key (kbd "C-x C-c") 'ask-before-closing))

;;-----------------------------------------------------------------------
;; See http://www.paulwrankin.com/blog/2014/10/09/asynchronous-rss-fetching-in-gnus/
(defun -nnrss-fetch-async ()
  "Run a dynamic asynchronous shell command to fetch RSS feeds.
Creates a dynamic shell command to fetch RSS feeds in
`nnrss-group-alist' and runs using `async-shell-command'."
  (interactive)
  (or nnrss-use-local
      (setq nnrss-use-local t))
  (let* ((rssdir (expand-file-name nnrss-directory))
         list
         (fetch-str
          (dolist (var nnrss-server-data list)
            (let* ((url (or (nth 2 var)
                            (second (assoc (car var)
                                           nnrss-group-alist)))))
              (setq list
                    (concat list " -o '" rssdir
                            (nnrss-translate-file-chars (concat (car var) ".xml"))
                            "' '" url "'")))))
         (command (concat "curl" fetch-str)))
    (async-shell-command command "*nnRSS Fetch RSS Process*")))

;;-----------------------------------------------------------------
;; See http://punchagan.muse-amuse.in/posts/refile-to-date-tree.html
(defun my-org-refile-to-journal ()
  "Refile an entry to journal file's date-tree"
  (interactive)
  (require 'org-datetree)
  (let ((journal (expand-file-name "journal.org" org-directory))
	post-date)
    (setq post-date (or (org-entry-get (point) "TIMESTAMP_IA")
			(org-entry-get (point) "TIMESTAMP")))
    (setq post-date (nthcdr 3 (parse-time-string post-date)))
    (setq post-date (list (cadr post-date)
			  (car post-date)
			  (caddr post-date)))
    (org-cut-subtree)
    (with-current-buffer (or (find-buffer-visiting journal)
			     (find-file-noselect journal))
      (save-excursion
	(org-datetree-file-entry-under (current-kill 0) post-date)
	(bookmark-set "org-refile-last-stored")))
       (message "Refiled to %s" journal)))
    
