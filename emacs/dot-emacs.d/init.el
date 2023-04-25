(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

(when (file-exists-p "~/.emacs.d/debug-hooks.el") (load "~/.emacs.d/debug-hooks.el"))

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

;; using `use-package` to ensure all packages I want are installed
;; Globally allow `use-package` to always install if not available
;; This _must_ come first before any other package references/configurations
;; Auto install use-package directly from ELPA if needed, otherwise it handles everything
(unless (package-installed-p 'use-package) (package-install 'use-package))
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; All the packages I want to always have available
;; Populate manually from `M-x packages-list-packages` and find installed

(use-package magit)
(use-package editorconfig
  :config
  (editorconfig-mode 1)
  )
(use-package markdown-mode)

(use-package company
  :hook (
	 (prog-mode))
  )
(use-package paredit
  ;; Active paredit automatically: https://www.emacswiki.org/emacs/ParEdit#h5o-1
  :hook (
	 (emacs-lisp-mode . enable-paredit-mode)
	 ;; disabled for: https://www.reddit.com/r/emacs/comments/101uwgd/enable_paredit_mode_for_evalexpression_mini/
	 ;;(eval-expression-minibuffer-setup . enable-paredit-mode)
	 (ielm-mode . enable-paredit-mode)
	 (lisp-mode . enable-paredit-mode)
	 (lisp-interaction-mode . enable-paredit-mode)
	 (scheme-mode . enable-paredit-mode))
  :init
  (autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
  )

;; language modes
(use-package go-mode
  :hook (
	 (go-mode . eglot-ensure)
	 (before-save . eglot-format-buffer)
	 (before-save . eglot-code-action-organize-imports)
	 )
  )
;; sets up inlay hints
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       '((go-mode) .
		 ("gopls" :initializationOptions
		  (:hints (:parameterNames t
					   :rangeVariableTypes t
					   :functionTypeParameters t
					   :assignVariableTypes t
					   :compositeLiteralFields t
					   :compositeLiteralTypes t
					   :constantValues t)))))
  )
(use-package rust-mode
  :hook ((rust-mode . eglot-ensure))
  )

;; validate elisp packages, required for melpa upload
;; https://github.com/purcell/package-lint
(use-package package-lint)

;; terraform language settings
;; lsp was installed with `brew install hashicorp/tap/terraform-ls`
(use-package company-terraform
  :init
  (company-terraform-init)
  :hook (
	 (terraform-mode . eglot-ensure))
  )
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       '(terraform-mode . ("terraform-ls" "serve"))
	       )
  )

;; Section for any local working stuff
(use-package devcontainer
  :load-path "~/code/bradschwartz/devcontainer.el/"
  :hook ((dired-before-readin . devcontainer-dir-open-hook))
  )
