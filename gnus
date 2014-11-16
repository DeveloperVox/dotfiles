(setq gnus-nntp-server 'nil)
(setq gnus-select-method '(nnrss ""))
;;(setq gnus-secondary-select-method '(nnrss "~/.emacs.d/test"))

;;; RSS
(eval-after-load "gnus"
  '(require 'nnrss))

(add-hook 'gnus-after-getting-new-news-hook '-nnrss-fetch-async)
;; Gnus has built in support for RSS feeds, just hit "G R" and enter the feed URL. Unfortunately Gnus will check RSS
;; feeds everytime you check your email, which is very impolite.

;; To get around this, you set nnrss into local mode, which will fetch news from locally stored RSS feeds.
(setq nnrss-use-local t)

;; Format RSS feed titles nicely
;;(eval-after-load "gnus"
;;  '(add-hook 'gnus-summary-mode-hook
;;    (lambda ()
;;      (if (string-match "^nnrss:.*" gnus-newsgroup-name)
;;          (progn (make-local-variable 'gnus-article-sort-functions)
;;                 (make-local-variable 'gnus-use-adaptive-scoring)
;;                 (make-local-variable 'gnus-use-scoring)
;;                 (make-local-variable 'gnus-score-find-score-files-function)
;;                 (make-local-variable 'gnus-summary-line-format)
;;                 (setq gnus-article-sort-functions 'gnus-article-sort-by-date
;;                       gnus-use-adaptive-scoring nil
;;                       gnus-use-scoring t
;;                       gnus-score-find-score-files-function 'gnus-score-find-single
;;                       gnus-summary-line-format "%U%R%z%d %I%(%[ %s %]%)\n")))))
;;)

;;              (setq gnus-article-sort-functions 'gnus-article-sort-by-date
  ;;                     gnus-use-adaptive-scoring nil
    ;;                   gnus-use-scoring t
      ;;                 gnus-score-find-score-files-function 'gnus-score-find-single
        ;;               gnus-summary-line-format "%U%R%z%d %I%(%[ %s %]%)\n")

(load-file "~/News/rss/nnrss.el")

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


(setq gnus-summary-line-format "%U%R%z %(%&user-date;  %-15,15f %* %B%s%)\n"
  gnus-user-date-format-alist '((t . "%Y-%m-%d %H:%M"))
  gnus-sum-thread-tree-false-root ""
  gnus-sum-thread-tree-indent " "
  gnus-sum-thread-tree-root ""
  gnus-sum-thread-tree-leaf-with-other "├► "
  gnus-sum-thread-tree-single-leaf "╰► "
  gnus-sum-thread-tree-vertical "│")

(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)
