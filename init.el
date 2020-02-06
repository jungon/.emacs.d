;;; package --- Summary - My Emacs init file

;;; Commentary:
;;; Simple Emacs setup I carry everywhere

;;; Code:

(setq gc-cons-threshold 50000000)
(setq large-file-warning-threshold 100000000)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(global-hl-line-mode +1)
(blink-cursor-mode -1)
(line-number-mode +1)
(global-display-line-numbers-mode 1)
(column-number-mode t)
(size-indication-mode t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq inhibit-startup-screen t)

(use-package material-theme
  :ensure t
  :config
  (load-theme 'material t))

(use-package smart-mode-line
  :ensure t
  :config
  (setq sml/no-confirm-load-theme t)
  (setq sml/theme 'dark)
  (add-hook 'after-init-hook 'sml/setup))

(setq initial-frame-alist '((top . 0) (left . 1040) (width . 104) (height . 64)))
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)
(set-frame-font "Source Code Pro 10" nil t)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(global-auto-revert-mode t)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq-default tab-width 2
              indent-tabs-mode nil)
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(add-hook 'before-save-hook 'whitespace-cleanup)

(use-package diminish
  :ensure t)

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :init
  (add-hook 'prog-mode-hook #'smartparens-mode)
  :config
  (progn
    (require 'smartparens-config)
    (sp-use-paredit-bindings)
    (show-paren-mode t)))

(use-package expand-region
  :ensure t
  :bind ("M-m" . er/expand-region))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode +1))

(use-package avy
  :ensure t
  :bind
  ("C-=" . avy-goto-char)
  :config
  (setq avy-background t))

(use-package crux
  :ensure t
  :bind
  ("C-k" . crux-smart-kill-line)
  ("C-c n" . crux-cleanup-buffer-or-region)
  ("C-c f" . crux-recentf-find-file)
  ("C-a" . crux-move-beginning-of-line))

(use-package magit
  :ensure t
  :bind (("C-M-g" . magit-status)))

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :bind-keymap
  ("s-p" . projectile-command-map)
  ("C-c p" . projectile-command-map)
  :config
  (projectile-mode +1)
  )

(use-package company
  :ensure t
  :diminish company-mode
  :config
  (add-hook 'after-init-hook #'global-company-mode))

(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package helm
  :ensure t
  :defer 2
  :diminish helm-mode
  :bind
  ("M-x" . helm-M-x)
  ("C-x C-f" . helm-find-files)
  ("M-y" . helm-show-kill-ring)
  ("C-x C-b" . helm-mini)
  :config
  (require 'helm-config)
  (helm-mode 1)
  (setq helm-split-window-inside-p t
    helm-move-to-line-cycle-in-source t)
  (setq helm-autoresize-max-height 0)
  (setq helm-autoresize-min-height 20)
  (helm-autoresize-mode 1)
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
  (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
  )

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

(use-package yasnippet
  :ensure t)


(use-package lsp-mode :hook rust-mode :commands lsp :ensure t)
(use-package lsp-ui :commands lsp-ui-mode :ensure t)
(use-package company-lsp
  :ensure t
  :commands company-lsp
  :config (push 'company-lsp company-backends))

(use-package ccls
  :ensure t
  :config
  (setq ccls-executable "ccls")
  (setq lsp-prefer-flymake nil)
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))


;;; Shell integration

(use-package exec-path-from-shell
  :when (memq window-system '(mac ns x))
  :ensure t
  :config
  (setq exec-path-from-shell-arguments '("-l"))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-envs '("PATH")))


;;; Ediff

(use-package ediff
  :init
  (setq ediff-window-setup-function #'ediff-setup-windows-plain)
  (setq ediff-split-window-function #'split-window-horizontally)
  (setq ediff-diff-options "-w")
  (winner-mode)
  (add-hook 'ediff-after-quit-hook-internal #'winner-undo))


;;; Modes

(add-hook 'prog-mode-hook #'prettify-symbols-mode)

(use-package rainbow-delimiters
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package aggressive-indent
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'aggressive-indent-mode))


;;; Clojure

(use-package clojure-mode
  :ensure t
  :mode (("\\.clj\\'" . clojure-mode)
         ("\\.edn\\'" . clojure-mode))
  :config
  (progn
    (setq clojure-align-forms-automatically t)
    (setq clojure--prettify-symbols-alist
          '(("fn" . ?λ)))))

(use-package cider
  :ensure t
  :defer t
  :init
  (add-hook 'cider-mode-hook #'yas-minor-mode)
  (add-hook 'cider-mode-hook #'subword-mode)
  (add-hook 'cider-mode-hook #'clj-refactor-mode)
  (add-hook 'cider-mode-hook #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'subword-mode)
  (add-hook 'cider-repl-mode-hook #'smartparens-mode)
  (add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode)
  :config
  (progn
    (setq nrepl-hide-special-buffers t)
    (setq cider-save-file-on-load t)
    (setq cider-eval-result-prefix ";; => ")
    (setq cider-special-mode-truncate-lines nil)
    (setq cider-font-lock-dynamically '(macro core function var))
    (setq cider-font-lock-reader-conditionals nil)
    (setq cider-overlays-use-font-lock t)
    (setq cider-show-error-buffer t)
    (setq cider-auto-select-error-buffer t)
    (setq cider-repl-history-file "~/.emacs.d/nrepl-history")
    (setq cider-repl-pop-to-buffer-on-connect nil)
    (setq cider-repl-display-in-current-window nil)
    (setq cider-repl-display-help-banner nil)
    (setq cider-repl-require-ns-on-set t)))

(use-package clj-refactor
  :ensure t
  :defer t
  :diminish clj-refactor-mode
  :config (cljr-add-keybindings-with-prefix "C-c C-m"))

(use-package cider-eval-sexp-fu
  :ensure t)


;;; Web mode

(use-package web-mode
  :ensure t
  :mode ("\\.[jt]sx?\\'" . web-mode)
  :config
  (defun my-web-mode-hook ()
    (setq web-mode-content-types-alist '(("jsx" . "\\.[jt]sx?\\'")))
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 2)
    (setq web-mode-script-padding 2)
    (setq web-mode-block-padding 2)
    (setq web-mode-style-padding 2)
    (setq web-mode-enable-auto-pairing t)
    (setq web-mode-enable-auto-closing t)
    (setq web-mode-enable-current-element-highlight t))
  (add-hook 'web-mode-hook 'my-web-mode-hook)
  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers
                        '(javascript-jshint json-jsonlist))))

(use-package emmet-mode
  :ensure t
  :diminish emmet-mode
  :hook web-mode)


;;; Rust
(use-package rust-mode
  :ensure t
  :config
  (add-hook 'rust-mode (lambda () (setq indent-tabs-mode nil)))
  (setq rust-format-on-save t))

(use-package cargo
  :ensure t
  :hook (rust-mode . cargo-minor-mode))




(require 'server)
(if (not (server-running-p)) (server-start))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" default)))
 '(package-selected-packages
   (quote
    (ccls company-lsp lsp-ui lsp-mode yasnippet helm-projectile helm flycheck company projectile magit crux avy which-key expand-region smartparens diminish smart-mode-line-powerline-theme material-theme use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((((min-colors 16777216)) (:background "#282a36" :foreground "#f8f8f2")) (t (:background "#000000" :foreground "#f8f8f2")))))
