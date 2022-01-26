;; init.el -*- lexical-binding: t; -*-

(add-to-list 'load-path (expand-file-name "./lisp" user-emacs-directory))

(setq user-full-name "nuxsh"
      user-mail-address "nuxshed@gmail.com")

(setq-default require-final-newline t
              vc-follow-symlinks)

(setq undo-limit 80000000            ; moar undo
      auto-save-default t            ; who knows what could happen?
      truncate-string-ellipsis "…")  ; prettier ellipsis

(setq use-short-answers t)

(setq inhibit-startup-echo-area-message t
      inhibit-startup-message t)
(tool-bar-mode -1)     ; Disable the toolbar
(tooltip-mode -1)      ; Disable tooltips
(menu-bar-mode -1)     ; Disable the menu bar
(scroll-bar-mode -1)   ; Disable the scrollbar

(setq frame-inhibit-implied-resize t
      initial-major-mode 'fundamental-mode
      file-name-handler-alist nil)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(electric-pair-mode) ;; autopairs
(recentf-mode) ;; recent files

;; init package sources
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("melpa" . "http://melpa.org/packages/")))
(customize-set-variable 'package-enable-at-startup nil)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t
      package-quickstart t)

(use-package gcmh
  :init
  (gcmh-mode 1))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(setq evil-cross-lines t
      evil-move-beyond-eol t
      evil-symbol-word-search t
      evil-want-Y-yank-to-eol t
      evil-cross-lines t)

(use-package evil-leader
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
    ;; General
    ".f" 'consult-isearch
    ".q" 'delete-frame
    ".e" 'eval-region
    ".s" 'straight-use-package
    ;; Files
    "fr" 'consult-recent-file
    "fb" 'consult-bookmark
    "ff" 'find-file
    "fd" 'dired
    ;; Open
    "oa" 'org-agenda
    "om" 'mu4e
    "og" 'magit
    ;; Notes
    "no" 'deft
    "nf" 'deft-find-file
    "nn" 'deft-new-file-named
    ;; Bufffers
    "bv" 'split-window-right
    "bh" 'split-window-below
    "bd" 'kill-current-buffer
    "bb" 'consult-buffer
    "bx" 'switch-to-scratch
    "bi" 'ibuffer
    ;; Help
    "hh" 'help
    "hk" 'describe-key
    "hv" 'describe-variable
    "hF" 'describe-function
    "hf" 'describe-face
    "hs" 'describe-symbol
    "hm" 'describe-mode))

(use-package consult)

(use-package vertico
  :init
  (vertico-mode)
  (setq vertico-cycle t))

(use-package orderless
  :init
  (setq completion-styles '(orderless)))

(use-package marginalia
  :init (marginalia-mode))

(use-package company
  :bind (:map company-active-map
              ("<tab>" . company-select-next)))

(use-package company-statistics
  :hook (company-mode . company-statistics-mode))

(use-package company-quickhelp
  :hook (company-mode . company-quickhelp-mode))

(use-package company-box
  :hook (company-mode . company-box-mode)
  :config
  (setq company-box-scrollbar nil))

(add-hook 'after-init-hook 'global-company-mode)

(use-package vterm
  :commands (vterm vterm-other-window))

(use-package which-key
  :config (which-key-mode)
  (which-key-setup-side-window-bottom)
  (setq which-key-idle-delay 0.1))

(use-package nix-mode)
(use-package lua-mode)
(use-package markdown-mode)

(use-package flycheck
  :ensure t
  :config
  (setq flycheck-elisp-load-path 'inherit)
  (setq flycheck-idle-change-delay 1.0)
  (setq-local flycheck-elisp-initialize-packages t)
  (setq-local flycheck-elisp-package-user-dir package-user-dir)
  (setq-default flycheck-disabled-checkers '(elisp-checkdoc)))

  (add-hook 'prog-mode-hook 'flycheck-mode)

(use-package rainbow-mode
  :defer t)

(with-eval-after-load 'dired
  (setq dired-dwim-target t
        dired-listing-switches "-Alh"
        dired-use-ls-dired t
        dired-omit-files "\\`[.]?#\\|\\`[.][.]?\\|\\`[.].*\\'"
        dired-always-read-filesystem t
        dired-create-destination-dirs 'ask
        dired-hide-details-hide-symlink-targets nil
        dired-isearch-filenames 'dwim)
  (define-key dired-mode-map (kbd "^") (lambda () (interactive) (find-alternate-file ".."))))
(add-hook 'dired-mode-hook 'dired-hide-details-mode)
(add-hook 'dired-mode-hook 'dired-omit-mode)

(use-package all-the-icons-dired)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
(setq all-the-icons-dired-monochrome 't)

(global-set-key (kbd "C-x C-b") 'ibuffer)
(with-eval-after-load 'ibuffer
  (setq ibuffer-expert t
        ibuffer-show-empty-filter-groups nil)
  (defun my/human-readable-file-sizes-to-bytes (string)
    "Convert a human-readable file size into bytes."
    (interactive)
    (cond
     ((string-suffix-p "G" string t)
      (* 1000000000 (string-to-number (substring string 0 (- (length string) 1)))))
     ((string-suffix-p "M" string t)
      (* 1000000 (string-to-number (substring string 0 (- (length string) 1)))))
     ((string-suffix-p "K" string t)
      (* 1000 (string-to-number (substring string 0 (- (length string) 1)))))
     (t
      (string-to-number (substring string 0 (- (length string) 1))))))

  (defun my/bytes-to-human-readable-file-sizes (bytes)
    "Convert number of bytes to human-readable file size."
    (interactive)
    (cond
     ((> bytes 1000000000) (format "%10.1fG" (/ bytes 1000000000.0)))
     ((> bytes 100000000) (format "%10.0fM" (/ bytes 1000000.0)))
     ((> bytes 1000000) (format "%10.1fM" (/ bytes 1000000.0)))
     ((> bytes 100000) (format "%10.0fk" (/ bytes 1000.0)))
     ((> bytes 1000) (format "%10.1fk" (/ bytes 1000.0)))
     (t (format "%10d" bytes))))

  ;; Use human readable Size column instead of original one
  (define-ibuffer-column size-h
    (:name "Size"
           :inline t
           :summarizer
           (lambda (column-strings)
             (let ((total 0))
               (dolist (string column-strings)
                 (setq total
                       (+ (float (my/human-readable-file-sizes-to-bytes string))
                          total)))
               (my/bytes-to-human-readable-file-sizes total)))
           )
    (my/bytes-to-human-readable-file-sizes (buffer-size)))

(setq ibuffer-formats
      '((mark modified read-only locked " "
              (name 20 20 :left :elide)
              " "
              (size-h 11 -1 :right)
              " "
              (mode 16 16 :left :elide))
        (mark " "
              (name 16 -1)
              " " filename))))

(setq ibuffer-saved-filter-groups
      '(("main"
         ("modified" (and
                      (modified . t)
                      (visiting-file . t)))
         ("term" (or
                  (mode . vterm-mode)
                  (mode . eshell-mode)
                  (mode . term-mode)
                  (mode . shell-mode)))
         ("planning" (or
                      (name . "^\\*Calendar\\*$")
                      (name . "^agenda")
                      (mode . org-agenda-mode)))
         ("img" (mode . image-mode))
         ("config" (filename . "/dotfiles/"))
         ("blog" (filename . "/projects/site/"))
         ("code" (filename . "/projects/"))
         ("notes" ( filename . "/notes/"))
         ("org" (mode . org-mode))
         ("dired" (mode . dired-mode))
         ("help" (or (name . "\*Help\*")
                     (name . "\*Apropos\*")
                     (name . "\*info\*")
                     (mode . help-mode)))
         ("internal" (name . "^\*.*$"))
         ("other" (name . "^.*$"))
         )))
(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-auto-mode 1)
            (ibuffer-switch-to-saved-filter-groups "main")))

(use-package all-the-icons-ibuffer
  :ensure t
  :init (all-the-icons-ibuffer-mode 1))

(set-face-attribute 'default nil :font "Cartograph CF 10")
(set-face-attribute 'fixed-pitch nil :font "Cartograph CF 10")
(set-face-attribute 'variable-pitch nil :font "Commissioner 10")

(use-package all-the-icons)

(use-package doom-themes
  :config
  (load-theme 'doom-cafe t))

(setq default-frame-alist
      (append (list
             '(min-height . 1)
               '(height     . 45)
             '(min-width  . 1)
               '(width      . 81)
               '(vertical-scroll-bars . nil)
               '(internal-border-width . 24)
               '(tool-bar-lines . 0))))

(fringe-mode '(0 . 0))
(defface fallback '((t :family "Cartograph CF"
		       :inherit 'face-faded)) "Fallback")
(set-display-table-slot standard-display-table 'truncation
			(make-glyph-code ?… 'fallback))
(set-display-table-slot standard-display-table 'wrap
			(make-glyph-code ?↩ 'fallback))
(set-display-table-slot standard-display-table 'selective-display
			(string-to-vector " …"))

(defun mode-line-render (left right)
  "Return a string of `window-width' length.
   Containing LEFT, and RIGHT aligned respectively."
  (let ((available-width
          (- (window-width)
            (+ (length (format-mode-line left))
               (length (format-mode-line right))))))
    (append left
            (list (format (format "%%%ds" available-width) ""))
      right)))

(setq-default mode-line-format
  '((:eval (mode-line-render
             '((:eval (propertize " %b" 'face `(:slant italic)))
               (:eval (if (and buffer-file-name (buffer-modified-p))
                          (propertize "*" 'face `(:inherit face-faded))))
               (:eval (if (buffer-narrowed-p)
                         (propertize "-" 'face `(:inherit face-faded)))))
             '("%p %l:%c "
               (:eval (propertize " %m " 'face 'font-lock-string-face)))))))

(require 'splash)
(splash-screen)

(use-package good-scroll
  :config
  (good-scroll-mode 1))

(require 'mu4e)

(setq mu4e-maildir (expand-file-name "~/.mail/"))

(setq mu4e-drafts-folder "/Gmail/[Gmail]/Drafts")
(setq mu4e-sent-folder   "/Gmail/[Gmail]/Sent Mail")
(setq mu4e-trash-folder  "/Gmail/[Gmail]/Trash")

(setq mu4e-get-mail-command "mbsync -a"
      mu4e-compose-signature-auto-include nil
      mu4e-compose-format-flowed t)

(setq
 user-mail-address "nuxshed@gmail.com"
 user-full-name  "nuxsh")

(setq mu4e-view-show-images t)

(setq smtpmail-smtp-server "smtp.gmail.com"
      user-mail-address "nuxshed@gmail.com"
      smtpmail-smtp-user "nuxshed"
      smtpmail-smtp-service 587)

(setq smtpmail-auth-credentials (expand-file-name "~/.authinfo"))

(use-package org-contrib)
(use-package org-bullets
  :after org
  :hook
  (org-mode . (lambda () (org-bullets-mode 1))))

(setq org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●"))
(setq org-agenda-files '("~/org/agenda.org"))

(add-hook 'org-agenda-mode-hook
          (lambda ()
            (local-set-key (kbd "q") 'org-agenda-exit)))
(use-package htmlize)
(add-hook 'org-mode-hook (lambda ()
                           (toggle-word-wrap)
                           (flyspell-mode t)
                           (electric-indent-local-mode -1)))
(setq org-src-window-setup 'current-window)

  (defun org-toggle-emphasis ()
    "Toggle hiding/showing of org emphasize markers."
    (interactive)
    (if org-hide-emphasis-markers
      (set-variable 'org-hide-emphasis-markers nil)
      (set-variable 'org-hide-emphasis-markers t)))
  (define-key org-mode-map (kbd "C-c e") 'org-toggle-emphasis)

(use-package deft
  :config
  (setq deft-directory "~/notes"
        deft-default-extension "org"
        deft-extensions '("txt" "md" "org")
        deft-use-filter-string-for-filename t))

(add-hook 'deft-mode-hook
          (lambda ()
            (define-key evil-normal-state-local-map (kbd "n") 'deft-new-file-named)
            (define-key evil-normal-state-local-map (kbd "q") 'quit-window)
            (define-key evil-normal-state-local-map (kbd "f") 'deft-find-file)))

(require 'publish)

(defun org/prettify-set ()
  (interactive)
  (setq prettify-symbols-alist
	'(("#+begin_src" . ">")
	  ("#+BEGIN_SRC" . ">")
	  ("#+end_src" . "<")
	  ("#+END_SRC" . "<")
	  ("#+begin_example" . "")
	  ("#+BEGIN_EXAMPLE" . "")
	  ("#+end_example" . "")
	  ("#+END_EXAMPLE" . "")
	  ("#+results:" . "")
	  ("#+RESULTS:" . "")
	  ("#+begin_quote" . "❝")
	  ("#+BEGIN_QUOTE" . "❝")
	  ("#+end_quote" . "❞")
	  ("#+END_QUOTE" . "❞"))))
(add-hook 'org-mode-hook 'org/prettify-set)

(defun prog/prettify-set ()
  (interactive)
  (setq prettify-symbols-alist
	'(("lambda" . "λ")
	  ("->" . "→")
	  ("<-" . "←")
	  ("<=" . "≤")
	  (">=" . "≥")
	  ("!=" . "≠")
	  ("~=" . "≃")
	  ("=~" . "≃"))))
(add-hook 'prog-mode-hook 'prog/prettify-set)

(global-prettify-symbols-mode)

;; init.el ends here
