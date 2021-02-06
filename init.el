;;; package --- Summary - My Emacs init file

;;; Commentary:
;;; Simple Emacs setup I carry everywhere

;;; Code:
(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024))

(require 'package)

(setq package-enable-at-startup nil)

;;; Define package repositories
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)

;;; Initializes the package infrastructure
(package-initialize)

;;; If there are no archived package contents, refresh theme
(when (not package-archive-contents)
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package)
  (require 'use-package-ensure)
  (setq use-package-always-ensure t))

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
(windmove-default-keybindings)

(set-frame-font "Hack-10" nil t)

(setq initial-frame-alist '((left . 901)
                            (top . 5)
                            (width . 123)
                            (height . 74)))
;; (setq initial-frame-alist '((fullscreen . maximized)))

(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

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

(global-set-key (kbd "C-x C-k") 'kill-this-buffer)
(global-set-key (kbd "C-;") 'comment-line)
(global-set-key [remap suspend-frame] 'undo)
(global-set-key [remap just-one-space] 'mark-word)
(global-set-key (kbd "C-c s") 'eshell)

(add-hook 'before-save-hook #'whitespace-cleanup)

(use-package all-the-icons)

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)

  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;;(doom-themes-neotree-config)
  ;; or for treemacs users
  ;;(setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme

  ;; Corrects (and improves) org-mode's native fontification
  (doom-themes-org-config))

(use-package doom-modeline
  :init (doom-modeline-mode 1))

(use-package diminish)

(use-package smartparens
  :diminish smartparens-mode
  :init
  (add-hook 'prog-mode-hook #'smartparens-mode)
  :config
  (progn
    (require 'smartparens-config)
    (sp-use-paredit-bindings)
    (show-paren-mode t)))

(use-package expand-region
  :bind ("M-m" . er/expand-region))

(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode +1))

(use-package avy
  :bind
  ("C-=" . avy-goto-char)
  :config
  (setq avy-background t))

(use-package crux
  :bind
  ("C-a" . crux-move-beginning-of-line)
  ("C-k" . crux-smart-kill-line)
  ("C-c n" . crux-cleanup-buffer-or-region))

(use-package magit
  :bind (("C-x g" . magit-status)))

(use-package projectile
  :diminish projectile-mode
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (setq projectile-globally-ignored-directories '(".git" "node_modules"))
  :config
  (projectile-mode +1))

(use-package company
  :diminish company-mode
  :config
  (setq company-tooltip-align-annotations t
        company-idle-delay 0.0
        company-minimum-prefix-length 1)
  (add-hook 'after-init-hook #'global-company-mode))

(use-package flycheck
  :diminish flycheck-mode
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package helm
  :defer 2
  :diminish helm-mode
  :commands
  (helm-autoresize-mode)
  :bind
  ("M-x" . helm-M-x)
  ("C-x C-f" . helm-find-files)
  ("M-y" . helm-show-kill-ring)
  ("C-x C-b" . helm-buffers-list)
  ("C-x b" . helm-mini)
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
  :config
  (helm-projectile-on))

(use-package yasnippet)

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l"
        lsp-lens-enable t
        lsp-signature-auto-activate nil
        ;;lsp-enable-indentation nil ; uncomment to use cider indentation instead of lsp
        ;;lsp-enable-completion-at-point nil ; uncomment to use cider completion instead of lsp
        )
  :hook (lsp-mode . lsp-enable-which-key-integration)
  :commands lsp)

(use-package lsp-ui :commands lsp-ui-mode)

(use-package company-lsp
  :commands company-lsp
  :config (push 'company-lsp company-backends))

(use-package lsp-treemacs
  :init (setq treemacs-space-between-root-nodes nil))

(use-package helm-lsp :commands helm-lsp-workspace-symbol)

(use-package ccls
  :config
  (setq ccls-executable "ccls")
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))


;;; Shell integration

(when (eq system-type 'darwin)
  (use-package exec-path-from-shell
    :commands
    (exec-path-from-shell-initialize exec-path-from-shell-copy-envs)
    :config
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-envs '("PATH"))))


;;; Ediff

(use-package ediff
  :commands
  (ediff-setup-windows-plain winner-undo)
  :init
  (setq ediff-window-setup-function #'ediff-setup-windows-plain)
  (setq ediff-split-window-function #'split-window-horizontally)
  (setq ediff-diff-options "-w")
  (winner-mode)
  (add-hook 'ediff-after-quit-hook-internal #'winner-undo))


;;; Modes

(global-prettify-symbols-mode +1)

(use-package rainbow-delimiters
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))


;;; Multiple Cursors

(use-package multiple-cursors
  :bind
  (("M-C i" . mc/edit-lines)
   ("M-C h" . mc/mark-all-like-this)
   ("M-N" . mc/mark-next-like-this)
   ("M-P" . mc/mark-previous-like-this)
   ("M-S-<mouse-1>" . mc/add-cursor-on-click)))


;;; rjsx

(use-package add-node-modules-path
  :after (rjsx-mode)
  :hook (rjsx-mode))

(use-package prettier-js
  :after (rjsx-mode)
  :hook (rjsx-mode . prettier-js-mode)
  :config
  (setq prettier-js-args '("--trailing-comma" "all"
                           "--bracket-spacing" "false"
                           "--single-quote" "true"
                           "--jsx-single-quote" "true"
                           "--print-width" "100")))

(use-package rjsx-mode
  :mode "\\.js\\'")


;;; tide

(defun my/tide-mode()
  "Function for tide."
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enable))
  (tide-hl-identifier-mode +1)
  (company-mode +1)
  (setq js2-basic-offset 2)
  (setq js-indent-level 2))

(use-package tide
  :diminish tide-mode
  :after (rjsx-mode company flycheck eldoc)
  :hook ((rjsx-mode . my/tide-mode)
         (before-save . tide-format-before-save)))


;;; Clojure

(use-package clojure-mode
  :mode (("\\.clj\\'" . clojure-mode)
         ("\\.edn\\'" . clojure-mode)
         ("\\.cljs\\'" . clojurescript-mode))
  :config
  (progn
    (setq clojure-align-forms-automatically t)
    (setq clojure--prettify-symbols-alist
          '(("fn" . ?λ)))))

(use-package cider
  :hook
  (cider-mode . (lambda ()
                  (lsp)
                  (subword-mode)
                  (yas-minor-mode)
                  (eldoc-mode)))
  (cider-repl-mode . (lambda ()
                       (subword-mode)
                       (smartparens-mode)
                       (rainbow-delimiters-mode)))
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
    (setq cider-repl-pop-to-buffer-on-connect 'display-only)
    (setq cider-repl-display-help-banner nil)
    (setq cider-repl-use-pretty-printing t)
    (setq cider-repl-require-ns-on-set t)))

(defun my/clojure-mode()
  "Function for clojure."
  (clj-refactor-mode 1)
  (yas-minor-mode 1)
  (cljr-add-keybindings-with-prefix "C-c C-m"))

(use-package clj-refactor
  :diminish clj-refactor-mode
  :after
  (clojure-mode)
  :hook
  (clojure-mode . my/clojure-mode))



(require 'server)
(if (not (server-running-p)) (server-start))


(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(rg lsp-treemacs helm-ag doom-themes which-key web-mode use-package tide spacemacs-theme smartparens smart-mode-line-powerline-theme rustic rjsx-mode rainbow-delimiters prettier-js magit lsp-ui helm-projectile helm-lsp expand-region exec-path-from-shell emmet-mode eglot edn doom-modeline diminish crux company-lsp clojure-mode-extra-font-locking clj-refactor cider-eval-sexp-fu ccls cargo avy aggressive-indent add-node-modules-path)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
