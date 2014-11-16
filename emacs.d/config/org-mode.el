
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; Org buffers only
(add-hook 'org-mode-hook
	  (defun my-org-mode-settings ()
	  "My settings for org-mode."
	  (set-visual-wrap-column '80)))


;; Set variable with path to journal.org
(defvar org-journal-file "~/Documents/journal.org"
  "Path to journal.ledger file. Used as an easy reference, primarily in org-capture-templates.")

;; =================================================
;; Ledger-related stuff
;; =================================================

;; Set variable with path to journal.ledger
(defvar ledger-journal-file "~/Documents/journal.ledger"
  "Path to journal.ledger file. Used as an easy reference, primarily in org-capture-templates.")

;; Templates for Ledger
;; Thanks to Sacha Chua for the idea! http://sachachua.com
(setq org-capture-templates
      '(("x" "Transfer Ledger Entry" plain
                 (file ledger-journal-file)
	        "%(org-read-date) * %^{Description|Transfer}
  Assets:%^{To Account||Cash|PayPal-Personal|PayPal-ActualWebSpace|TDBank-Personal|TDBank-ActualWebSpace|DCU-Checking|DCU-Savings|ETRADE-Checking|Bitcoin|ETRADE-RothIRA-Personal|ETRADE-RothIRA-Ananda|ETRADE-Brokerage|Ameriprise-Life-Insurance} %^{Amount}
  Assets:%^{From Account||Cash|PayPal-Personal|PayPal-ActualWebSpace|TDBank-Personal|TDBank-ActualWebSpace|DCU-Checking|DCU-Savings|ETRADE-Checking|Bitcoin|ETRADE-RothIRA-Personal|ETRADE-RothIRA-Ananda|ETRADE-Brokerage|Ameriprise-Life-Insurance} -%\\3
")
		)
       org-capture-templates)

(setq org-capture-templates
      (append '(("i" "Income Ledger Entry")

		("iw" "Income:WebSharks" plain
                 (file ledger-journal-file)
	        "%(org-read-date) * WebSharks, Inc.
  Assets:PayPal-Personal %^{Amount}
  Income:WebSharks -%\\1
")
		("ia" "Income:ActualWebSpace" plain
                 (file ledger-journal-file)
	        "%(org-read-date) * %^{Received From}
  Assets:%^{Deposited into|PayPal-ActualWebSpace|PayPal-ActualWebSpace|TDBank-ActualWebSpace} %^{Amount}
  Income:ActualWebSpace -%\\3
")
		("ip" "Income:Affiliate-Programs" plain
                 (file ledger-journal-file)
	        "%(org-read-date) * %^{Received From}
  Assets:%^{Deposited into|PayPal-ActualWebSpace|PayPal-ActualWebSpace|TDBank-ActualWebSpace} %^{Amount}
  Income:Affiliate-Programs -%\\3
")
		("ic" "Income:PayPal-Cash-Back" plain
                 (file ledger-journal-file)
	        "%(org-read-date) * PayPal Cash-Back
  Assets:PayPal-Personal %^{Amount}
  Income:PayPal-Cash-Back -%\\1
")
		("ig" "Income:Google-Adsense" plain
                 (file ledger-journal-file)
	        "%(org-read-date) * Google Adsense
  Assets:TDBank-Personal %^{Amount}
  Income:Google-Adsense -%\\1
")
		)
       org-capture-templates))

(setq org-capture-templates
      (append '(("e" "Expense Ledger Entry (Personal)")

		("eo" "Expense:Other" plain
                 (file ledger-journal-file)
	        "%(org-read-date) * %^{Description}
  Expenses:Other %^{Amount}
  Assets:%^{Account||Cash|PayPal-Personal|PayPal-ActualWebSpace|TDBank-Personal|TDBank-ActualWebSpace|DCU-Checking|DCU-Savings}  
")
		("ec" "Expense:Food:Cafes" plain
                 (file ledger-journal-file)
	        "%(org-read-date) * %^{Description}
  Expenses:Food:Cafes %^{Amount}
    Assets:%^{Account||Cash|PayPal-Personal|PayPal-ActualWebSpace|TDBank-Personal|TDBank-ActualWebSpace|DCU-Checking|DCU-Savings}
")
		("er" "Expense:Food:Restaurants" plain
                 (file ledger-journal-file)
	        "%(org-read-date) * %^{Description}
  Expenses:Food:Restaurants %^{Amount}
  Assets:%^{Account||Cash|PayPal-Personal|PayPal-ActualWebSpace|TDBank-Personal|TDBank-ActualWebSpace|DCU-Checking|DCU-Savings}
  ")
		("eg" "Expense:Food:Groceries" plain
                 (file ledger-journal-file)
	        "%(org-read-date) * %^{Description}
  Expenses:Food:Groceries %^{Amount}
  Assets:%^{Account||Cash|PayPal-Personal|PayPal-ActualWebSpace|TDBank-Personal|TDBank-ActualWebSpace|DCU-Checking|DCU-Savings}
  ")
		("et" "Expense:Travel" plain
                 (file ledger-journal-file)
	        "%(org-read-date) * %^{Description}
  Expenses:Travel %^{Amount}
  Assets:%^{Account||Cash|PayPal-Personal|PayPal-ActualWebSpace|TDBank-Personal|TDBank-ActualWebSpace|DCU-Checking|DCU-Savings}
  ")
		("eh" "Expense:Housing" plain
                 (file ledger-journal-file)
	        "%(org-read-date) * %^{Description}
  Expenses:Housing %^{Amount}
  Assets:%^{Account||Cash|PayPal-Personal|PayPal-ActualWebSpace|TDBank-Personal|TDBank-ActualWebSpace|DCU-Checking|DCU-Savings}
  ")
		("ef" "Expense:Office" plain
                 (file ledger-journal-file)
	        "%(org-read-date) * %^{Description}
  Expenses:Office %^{Amount}
  Assets:%^{Account||Cash|PayPal-Personal|PayPal-ActualWebSpace|TDBank-Personal|TDBank-ActualWebSpace|DCU-Checking|DCU-Savings}
")
		("ei" "Expense:Life-Insurance" plain
                 (file ledger-journal-file)
	        "%(org-read-date) * %^{Description}
  Expenses:Life-Insurance %^{Amount}
  Assets:%^{Account||Cash|PayPal-Personal|PayPal-ActualWebSpace|TDBank-Personal|TDBank-ActualWebSpace|DCU-Checking|DCU-Savings}
")
		)
       org-capture-templates))

(setq org-capture-templates
      (append '(("t" "Todo" entry (file+headline "~/Documents/gtd.org" "Tasks")
             "* TODO %^{Brief Description} %^g\n%?\nAdded: %U")
        ("j" "Journal" entry (file+datetree org-journal-file)
	 "** %^{Your Location or the Entry Title} %U %^g\n%i%?"))
      org-capture-templates))

