(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; using `use-package` to ensure all packages I want are installed
;; Globally allow `use-package` to always install if not available
;; This _must_ come first before any other package references/configurations
;; Need to manually install `use-package` the first time on a fresh install/wipe of elpa folder
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; All the packages I want to always have available
;; Populate manually from `M-x packages-list-packages` and find installed
(use-package company)
(use-package go-mode)
(use-package lsp-mode)
(use-package paredit)

(setq column-number-mode t)
(setq show-paren-mode t)
(setq make-backup-files nil) ; stop creating backup~ files
;; auto backup to ~/.emacs.d/backups
(setq backup-directory-alist
          `(("." . ,(concat user-emacs-directory "backups"))))
(setq auto-save-default nil) ; stop creating #autosave# files
(setq vc-follow-symlinks t)

;; Don't clutter init files with auto-inserted settings
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; lsp settings
;; ensure gopls is always started when go-mode is ran
(require 'lsp-mode)
(add-hook 'go-mode-hook #'lsp-deferred)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; always enable company-mode
(add-hook 'after-init-hook 'global-company-mode)
