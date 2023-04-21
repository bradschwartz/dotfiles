(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; using `use-package` to ensure all packages I want are installed
;; Globally allow `use-package` to always install if not available
;; This _must_ come first before any other package references/configurations
;; Auto install use-package directly from ELPA if needed, otherwise it handles everything
(unless (package-installed-p 'use-package) (package-install 'use-package))
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; All the packages I want to always have available
;; Populate manually from `M-x packages-list-packages` and find installed
(use-package company)
(use-package lsp-mode)
(use-package paredit)

;; language modes
(use-package go-mode)
(use-package rust-mode)

(setq column-number-mode t)
(setq show-paren-mode t)
(setq make-backup-files nil) ; stop creating backup~ files
;; auto backup to ~/.emacs.d/backups
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))
(setq auto-save-default nil) ; stop creating #autosave# files
(setq vc-follow-symlinks t)
;; issue on Mac when opening entire dirs: https://stackoverflow.com/a/56096775
(when (string= system-type "darwin")
  (setq dired-use-ls-dired nil))

;; Don't clutter init files with auto-inserted settings
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; lsp settings
;; ensure gopls is always started when go-mode is ran
(require 'lsp-mode)
(add-hook 'go-mode-hook #'lsp-deferred)
(add-hook 'rust-mode-hook #'lsp-deferred)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; paredit-mode settings: https://wikemacs.org/wiki/Paredit-mode
;; enabled in all elisp buffers
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)

;; always enable company-mode
(add-hook 'after-init-hook 'global-company-mode)

;; Section for any local working stuff
(use-package devcontainer
  :load-path "~/code/bradschwartz/devcontainer.el/")

(add-hook 'dired-before-readin-hook #'devcontainer-dir-open-hook)

(when (file-exists-p "~/.emacs.d/debug-hooks.el") (load "~/.emacs.d/debug-hooks.el"))
