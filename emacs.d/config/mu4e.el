(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e/")

(require 'mu4e)

; get mail
(setq mu4e-get-mail-command "/usr/local/bin/mbsync -c ~/.mbsyncrc mu4e"
      mu4e-update-interval 300
      mu4e-headers-auto-update t
      mu4e-compose-signature-auto-include nil)

;; Some IMAP-synchronization programs such as mbsync
;; don’t like it when message files do not change their
;; names when they are moved to different folders.
(setq mu4e-change-filenames-when-moving t)

(setq mu4e-maildir (expand-file-name "~/Maildir"))
(setq mu4e-mu-home "~/.mu")
(setq mu4e-mu-binary "/usr/local/bin/mu")

;; threading and duplicates
(setq mu4e-headers-results-limit 500)
(setq mu4e-headers-show-threads t)

(setq mu4e-maildir-shortcuts
      '( ("/raam@raamdev.com/Archive"   . ?r)
         ("/raam@websharks-inc.com/Archive"   . ?w)
         ("/raam@actualwebspace.com/Archive"   . ?a)))

;; Bookmarks
(setq mu4e-bookmarks
      '(("flag:unread AND NOT flag:trashed AND NOT from:raam@raamdev.com AND NOT from:raam@actualwebspace.com AND NOT from:raam@websharks-inc.com" "Unread messages"      ?u)
        ("date:today..now AND NOT from:raam@raamdev.com AND NOT from:raam@actualwebspace.com AND NOT from:raam@websharks-inc.com"                  "Today's messages"     ?t)
        ("date:7d..now AND NOT flag:trashed AND NOT from:raam@raamdev.com AND NOT from:raam@actualwebspace.com AND NOT from:raam@websharks-inc.com"                     "Last 7 days"          ?w)
	("m:/raam\@raamdev.com/INBOX OR m:/raam\@actualwebspace.com/INBOX OR m:/raam\@websharks-inc.com/INBOX AND NOT from:raam@raamdev.com AND NOT from:raam@actualwebspace.com AND NOT from:raam@websharks-inc.com"         "Inboxes"                 ?i)
	("m:/raam\@raamdev.com/Subscriptions OR m:/raam\@raamdev.com/Google-Alerts OR m:/raam\@websharks-inc.com/Contact-Form OR m:/raam\@websharks-inc.com/WordPress-News AND flag:unread"         "Misc"                 ?m)
	("m:/raam\@raamdev.com/Drafts OR m:/raam\@actualwebspace.com/Drafts m:/raam\@websharks-inc.com/Drafts"         "Drafts"                 ?d)
	("m:/raam\@raamdev.com/Sent OR m:/raam\@actualwebspace.com/Sent m:/raam\@websharks-inc.com/Sent"         "Sent"                 ?s)
      ))

;; don't save messages to Sent Messages, Gmail/IMAP takes care of this
(setq mu4e-sent-messages-behavior 'delete)

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)

;; general emacs mail settings; used when composing e-mail
;; the non-mu4e-* stuff is inherited from emacs/message-mode

 ;; accounts to chose when composing or replying
  (setq raam-mu4e-account-alist
        '(("raam@raamdev.com"
           (user-mail-address "raam@raamdev.com")
           (user-full-name "Raam Dev")
	   (mu4e-drafts-folder "/raam@raamdev.com/Drafts")
	   (mu4e-sent-folder "/raam@raamdev.com/Sent")
	   ;;(mu4e-trash-folder "/raam@raamdev.com/Trash") ;; not used with Gmail--see below
	   )

          ("raam@actualwebspace.com"
           (user-mail-address "raam@actualwebspace.com")
           (user-full-name "Raam Dev")
	   (mu4e-drafts-folder "/raam@actualwebspace.com/Drafts")
	   (mu4e-sent-folder "/raam@actualwebspace.com/Sent")
	   ;;(mu4e-trash-folder "/raam@actualwebspace.com/Trash") ;; not used with Gmail--see below
	   )

	  ("raam@websharks-inc.com"
           (user-mail-address "raam@websharks-inc.com")
           (user-full-name "Raam Dev")
	   (mu4e-drafts-folder "/raam@websharks-inc.com/Drafts")
	   (mu4e-sent-folder "/raam@websharks-inc.com/Sent")
	   ;;(mu4e-trash-folder "/raam@websharks-inc.com/Trash") ;; not used with Gmail--see below
	   )))

;; GMail is configured to "Archive the message" when a message is
;; marked as deleted and expunged from the last visible IMAP folder.
;; This means that we don't need to sync a local trash directory
;; with the remote IMAP server; simply syncing the fact that the
;; message was deleted is enough.
(setq mu4e-trash-folder "/trash")

;; email addresses to consider 'my email addresses'
(setq mu4e-user-mail-address-list
   (quote
    ("raam@raamdev.com" "raam@websharks-inc.com" "raam@actualwebspace.com")))

;; tell message-mode how to send mail
(setq message-send-mail-function 'smtpmail-send-it)

;; if our mail server lives at smtp.example.org; if you have a local
;; mail-server, simply use 'localhost' here.
(setq smtpmail-smtp-server "localhost")

;; Ask for which account we should compose with
(add-hook 'mu4e-compose-pre-hook 'raam-mu4e-set-account)

;; setup composition area
(add-hook 'mu4e-compose-mode-hook
        (defun my-do-compose-stuff ()
           "My settings for message composition."
           (auto-fill-mode -1)
	   (set-visual-wrap-column '80)
           (flyspell-mode)))

;; the "Indexing messages..." message gets old fast...
;;(setq mu4e-hide-index-messages t)

;; use w3m for parsing HTML emails
(setq mu4e-html2text-command
      "/usr/local/bin/w3m -T text/html")

;; prefer HTML version of message if available
(setq mu4e-view-prefer-html t)

;;; message view action in eww browser
(defun mu4e-msgv-action-view-in-browser (msg)
  "View the body of the message in a web browser."
  (interactive)
  (let ((html (mu4e-msg-field (mu4e-message-at-point t) :body-html))
        (tmpfile (format "%s/%d.html" temporary-file-directory (random))))
    (unless html (error "No html part for this message"))
    (with-temp-file tmpfile
      (insert
       "<html>"
       "<head><meta http-equiv=\"content-type\""
       "content=\"text/html;charset=UTF-8\">"
       html))
    (eww-browse-url (concat "file://" tmpfile))))

;;; message view action in external browser (Google Chrome)
(defun mu4e-msgv-action-view-in-external-browser (msg)
  "View the body of the message in a external web browser."
  (interactive)
  (let ((html (mu4e-msg-field (mu4e-message-at-point t) :body-html))
        (tmpfile (format "%s/%d.html" temporary-file-directory (random))))
    (unless html (error "No html part for this message"))
    (with-temp-file tmpfile
      (insert
       "<html>"
       "<head><meta http-equiv=\"content-type\""
       "content=\"text/html;charset=UTF-8\">"
       html))
    (browse-url (concat "file://" tmpfile))))

(add-to-list 'mu4e-view-actions
             '("View in eww browser" . mu4e-msgv-action-view-in-browser) t)
(add-to-list 'mu4e-view-actions
             '("Google Chrome external browser" . mu4e-msgv-action-view-in-external-browser) t)

;; enable inline images
(setq mu4e-show-images t)

;; use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
   (imagemagick-register-types))

;; Smart refiling
;; See http://www.djcbsoftware.nl/code/mu/mu4e/Smart-refiling.html#Smart-refiling
(setq mu4e-refile-folder
  (lambda (msg)
    (cond
      ;; messages to raam@raamdev.com
      ((mu4e-message-contact-field-matches msg :to
        "raam@raamdev.com")
       "/raam@raamdev.com/Archive")
      ;; messages to raam@websharks-inc.com
      ((mu4e-message-contact-field-matches msg :to
        "raam@websharks-inc.com")
      	"/raam@websharks-inc.com/Archive")
      ;; messages to raam@actualwebspace.com
      ((mu4e-message-contact-field-matches msg :to
        "raam@actualwebspace.com")
       "/raam@actualwebspace.com/Archive")
      ;; messages to support@actualwebspace.com
      ((mu4e-message-contact-field-matches msg :to
        "support@actualwebspace.com")
       "/raam@actualwebspace.com/Archive")
      ;; messages to billing@actualwebspace.com
      ((mu4e-message-contact-field-matches msg :to
        "billing@actualwebspace.com")
       "/raam@actualwebspace.com/Archive")
      ;; messages to paypal@actualwebspace.com
      ((mu4e-message-contact-field-matches msg :to
        "paypal@actualwebspace.com")
       "/raam@actualwebspace.com/Archive")
      ;; messages with football or soccer in the subject go to /football
;;      ((string-match "football\\|soccer"
;;        (mu4e-message-field msg :subject))
;;        "/football")
      ;; messages sent by raam@raamdev.com go to the sent folder
      ((find-if
	 (lambda (addr)
	   (mu4e-message-contact-field-matches msg :from addr))
	 "raam@raamdev.com")
       "/raam@raamdev.com/Sent")
      ;; messages sent by raam@websharks-inc.com go to the sent folder
      ((find-if
	 (lambda (addr)
	   (mu4e-message-contact-field-matches msg :from addr))
	 "raam@websharks-inc.com")
	"/raam@websharks-inc.com/Sent")
      ;; messages sent by raam@actualwebspace.com go to the sent folder
      ((find-if
	 (lambda (addr)
	   (mu4e-message-contact-field-matches msg :from addr))
	 "raam@actualwebspace.com")
	"/raam@actualwebspace.com/Sent")
      
      ;; everything else goes to /archive
      ;; important to have a catch-all at the end!
      (t  "/archive"))))

;; Functions
;; -----------------------------------------------

(defun raam-mu4e-set-account ()
  "Set the account for composing a message. If composing new,
   let's the user chose, and otherwise us the to field"
  (let* ((account
          (if nil nil
               ; TODO: get the appropriate account from 'to' and 'cc' fields.
;              mu4e-compose-parent-message
;              (let ((to (mu4e-msg-field mu4e-compose-parent-message :to)))
;                (string-match "/\\(.*?\\)/" maildir)
;                (match-string 1 maildir))

            (ido-completing-read
             "Compose with account: "
             (mapcar #'(lambda (var) (car var)) raam-mu4e-account-alist)
             nil t nil nil (caar raam-mu4e-account-alist))))
         (account-vars (cdr (assoc account raam-mu4e-account-alist))))
    (if account-vars
        (mapc #'(lambda (var)
                  (set (car var) (cadr var)))
              account-vars))))
