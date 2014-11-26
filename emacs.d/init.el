
(setq package-enable-at-startup nil)
(package-initialize)

;; Tell Customize to use its own file
(setq custom-file "~/.emacs.d/config/customize.el")
(load custom-file)

;; Set various paths 
(setq exec-path (append exec-path '("/usr/local/bin")))
(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(setq ispell-program-name "/usr/local/bin/ispell")

;; Load other configuration files
(load-file "~/.emacs.d/lisp/floobits/floobits.el")
(load-file "~/.emacs.d/config/mu4e.el")
(load-file "~/.emacs.d/config/org-mode.el")
(load-file "~/.emacs.d/config/key-bindings.el")
(load-file "~/.emacs.d/config/custom-functions.el")

;; Ledger Mode
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/ledger/")
(require 'ledger-mode)

;; Edit Server (used by Chrome plugin to edit form fields in emacs)
(require 'edit-server)
(edit-server-start)

;; Start the Emacs server to for opening files via the emacsclient
(server-start)

;; Launch in full-screen mode
(toggle-frame-fullscreen)

;; Auto-saving configuration
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; sort directories first
(setq insert-directory-program "/usr/local/bin/gls")
(setq dired-listing-switches "-aBhl --group-directories-first")

;; Key bindings for Mac keyboard
;; Caps Lock is mapped to Control in System Preferences -> Keyboard -> Modifier Keys
(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'meta) ;; used to be used as 'super
(setq ns-function-modifier 'hyper)
(setq mac-right-option-modifier 'meta)

;; Configure markdown-mode

(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.txt\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
;; Enable markdown-mode when editing certain web forms in Chrome via edit-server
(setq edit-server-url-major-mode-alist
      '(("github\\.com" . markdown-mode)
	("wordpress\\.org" . markdown-mode)))
(add-hook 'markdown-mode-hook (lambda () (setq wc-mode t)))

;; Use ledger-mode for .ledger files
(add-to-list 'auto-mode-alist '("\\.ledger$" . ledger-mode))

;; Misc appearance and behavior settings
(fset 'yes-or-no-p 'y-or-n-p) ;; y/n instead of yes/no in prompts
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Load package browser
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )

;; Load Sunburst theme
(defun sunburst-init ()
  (load-theme 'sunburst)
)
(add-hook 'after-init-hook 'sunburst-init)
