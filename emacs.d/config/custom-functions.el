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
