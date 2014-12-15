(setq gnus-nntp-server 'nil)
(setq gnus-select-method '(nnrss ""))
(setq gnus-secondary-select-methods '((nntp "news.gmane.org")))
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

(load-file "~/.emacs.d/News/rss/nnrss.el")

(setq gnus-summary-line-format "%U%R%z %(%&user-date;  %-15,15f %* %B%s%)\n"
  gnus-user-date-format-alist '((t . "%Y-%m-%d %H:%M"))
  gnus-sum-thread-tree-false-root ""
  gnus-sum-thread-tree-indent " "
  gnus-sum-thread-tree-root ""
  gnus-sum-thread-tree-leaf-with-other "├► "
  gnus-sum-thread-tree-single-leaf "╰► "
  gnus-sum-thread-tree-vertical "│")

(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

(defun my-gnus-group-list-subscribed-groups ()
  "List all subscribed groups with or without un-read messages"
  (interactive)
  (gnus-group-list-all-groups 5)
  )
 (add-hook 'gnus-group-mode-hook
           ;; list all the subscribed groups even they contain zero un-read messages
           (lambda () (local-set-key "o" 'my-gnus-group-list-subscribed-groups ))
           )