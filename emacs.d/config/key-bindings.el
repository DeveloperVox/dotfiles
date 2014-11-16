(global-set-key [ "M-]" ] 'forward-paragraph) ;
(global-unset-key [ "M-[" ] )
(global-set-key [ "M-[" ] 'backward-paragraph) ;
(global-set-key (kbd "C-x n") 'gnus)
(global-set-key "\C-cw" 'wc-mode)
(global-set-key (kbd "C-x m") 'mu4e)

;; org-mode
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(define-key global-map "\C-cc" 'org-capture)

;; Create keyboard shortcut to quickly open ledger journal file
(define-key global-map "\C-xj" (defun my-open-org-journal ()
  "Open my journal.org file."
  (interactive)
  (find-file org-journal-file)))

;; Create keyboard shortcut to quickly open ledger journal file
(define-key global-map "\C-xl" (defun my-open-ledger-journal ()
  "Open my journal.ledger file."
  (interactive)
  (find-file ledger-journal-file)))
