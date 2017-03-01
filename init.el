;############################################################################
;
;
;
;                                     -`
;                     ...            .o+`
;                  .+++s+   .h`.    `ooo/
;                 `+++%++  .h+++   `+oooo:
;                 +++o+++ .hhs++. `+oooooo:
;                 +s%%so%.hohhoo'  'oooooo+:
;                 `+ooohs+h+sh++`/:  ++oooo+:
;                  hh+o+hoso+h+`/++++.+++++++:
;                   `+h+++h.+ `/++++++++++++++:
;                            `/+++ooooooooooooo/`
;                           ./ooosssso++osssssso+`
;                          .oossssso-````/osssss::`
;                         -osssssso.      :ssss``to.
;                        :osssssss/  Mike  osssl   +
;                       /ossssssss/   8a   +sssslb
;                     `/ossssso+/:-        -:/+ossss'.-
;                    `+sso+:-`                 `.-/+oso:
;                   `++:.                           `-/+/
;                   .`                                 `/
;
;############################################################################

;############################################################################
; Setting up plugins stuff
;############################################################################
(require 'package)

;; Plugin sources
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "10e231624707d46f7b2059cc9280c332f7c7a530ebc17dba7e506df34c5332c4" default)))
 '(package-selected-packages
   (quote
    (go-mode go-autocomplete markdown-mode smart-mode-line-powerline-theme powerline gruvbox-theme nlinum-relative evil-nerd-commenter evil-surround evil-magit evil fill-column-indicator yasnippet autopair ggtags jedi helm-projectile helm projectile magit vimrc-mode use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(powerline-evil-normal-face ((t (:inherit powerline-evil-base-face :background "chartreuse3"))))
 '(sml/folder ((t (:inherit sml/global :background "grey22" :foreground "grey50" :weight normal))))
 '(sml/git ((t (:background "grey22" :foreground "chartreuse3")))))

(setq package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))

(eval-when-compile (require 'use-package))

;############################################################################
; Small Improvements
;############################################################################

;; Visual indication at column 80
(use-package fill-column-indicator
  :ensure t
  :config
  (setq fill-column 80)
  (add-hook 'prog-mode-hook 'fci-mode))

;; Syntax for vim files
(use-package vimrc-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode)))

;; Close pair stuff
(use-package autopair
  :ensure t
  :config
  (autopair-global-mode))

;; Emacs Git integration
(use-package magit
  :ensure t
  :config
  (add-hook 'magit-mode-hook
            (lambda ()
              (define-key magit-mode-map (kbd ",o") 'delete-other-windows))))

(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'"
  :config
  (add-hook 'markdown-mode-hook (lambda ()
                                  (yas-minor-mode t)
                                  (setq fill-column 80)
                                  (fci-mode)
                                  (flyspell-mode))))

;############################################################################
; Project management
;############################################################################
;; Project management plugin
(use-package projectile
  :ensure t
  :config
  (projectile-mode)
  (setq projectile-enable-caching t) ;; Always cach project list
  (setq projectile-indexing-method 'alien)) ;; Always index with external tools

;; Cool universal narrowing list
(use-package helm
  :ensure t
  :config
  (setq helm-buffer-max-length 40))

;; Helm projectile integration
(use-package helm-projectile
  :ensure t
  :config
  (setq projectile-completion-system 'helm))

;############################################################################
; Code Completion
;############################################################################
;; Cool snippets plugins
;; TODO: write more snippets
(use-package yasnippet
  :ensure t
  :config
  (add-to-list 'yas/root-directory "~/.emacs.d/snippets/")
  (yas-global-mode 1))

;; Require to install
;; Jedi
;; epc
;; flake8
;; virtualenv
;; Completion for python stuff
(use-package jedi
  :ensure t
  :config
  (add-hook 'python-mode-hook 'jedi:setup)
  (setq jedi:complete-on-dot t)

  (use-package epc
    :ensure t))

(use-package go-autocomplete
  :ensure t)

(use-package go-mode
  :ensure t
  :config
  (add-hook 'go-mode-hook '(lambda ()
                             (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)))
  (add-hook 'before-save-hook 'gofmt-before-save))

;; Require
;; gnu global
;; ctags
;; pygments
;; Tags manager
(use-package ggtags
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'ggtags-mode))

;; Cool autocompletion engine
(use-package auto-complete
  :ensure t
  :config
  (ac-config-default)
  (global-auto-complete-mode t)
  (ac-linum-workaround)
  (setq ac-show-menu-immediately-on-auto-complete t)
  (add-to-list 'ac-sources 'ac-source-filename t)
  (add-to-list 'ac-sources 'ac-source-files-in-current-dir t)
  (add-to-list 'ac-sources 'ac-source-gtags)
  (add-to-list 'ac-sources 'ac-source-jedi-direct))

;############################################################################
; Evil
;############################################################################

(use-package evil
  :ensure t
  :config
  (evil-mode t)

  ;; Some Basic Evil mappings
  (define-key evil-normal-state-map (kbd "t w") 'toggle-truncate-lines)
  (define-key evil-normal-state-map (kbd "t r") 'nlinum-relative-toggle)
  (define-key evil-normal-state-map (kbd "t n") 'nlinum-mode)

  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)

  (define-key evil-normal-state-map (kbd "M-t") 'term)

  (define-key evil-normal-state-map (kbd "C-b") 'helm-buffers-list)
  (define-key evil-normal-state-map (kbd "C-p") 'helm-projectile-find-file)
  (define-key evil-normal-state-map (kbd "C-o") 'helm-projectile-switch-project)
  (define-key evil-normal-state-map (kbd "C-a") 'projectile-add-known-project)

  ;; Local ORG mode Evil mappings
  (evil-define-key 'normal org-mode-map (kbd "Q") #'org-ctrl-c-ctrl-c)
  (evil-define-key 'normal org-mode-map (kbd "C-n") #'org-next-item)
  (evil-define-key 'normal org-mode-map (kbd "C-p") #'org-previous-item)

  (evil-define-key 'normal org-mode-map (kbd "C-j") #'org-forward-heading-same-level)
  (evil-define-key 'normal org-mode-map (kbd "C-k") #'org-backward-heading-same-level)

  (evil-define-key 'normal org-mode-map (kbd "C-l") #'org-forward-element)
  (evil-define-key 'normal org-mode-map (kbd "C-h") #'org-backward-element)

  (evil-define-key 'normal org-mode-map (kbd "g k") #'org-metaup)
  (evil-define-key 'normal org-mode-map (kbd "g j") #'org-metadown)
  (evil-define-key 'normal org-mode-map (kbd "g h") #'org-metaleft)
  (evil-define-key 'normal org-mode-map (kbd "g l") #'org-metaright)

  (use-package evil-leader
    :ensure t
    :config
    (global-evil-leader-mode)

    ;; Use the space bar as a leader character
    (evil-leader/set-leader "<SPC>")
    (evil-leader/set-key
        "w"    'save-buffer
        "t"    'term
        "d"    'kill-this-buffer
        "n"    'evil-next-buffer
        "p"    'evil-prev-buffer
        "q"    'evil-quit
        "i"    'projectile-invalidate-cache
        "ci"   'evilnc-comment-or-uncomment-lines
        "cl"   'evilnc-quick-comment-or-uncomment-to-the-line
        "ll"   'evilnc-quick-comment-or-uncomment-to-the-line
        "cc"   'evilnc-copy-and-comment-lines
        "cp"   'evilnc-comment-or-uncomment-paragraphs
        "cr"   'comment-or-uncomment-region
        "cv"   'evilnc-toggle-invert-comment-line-by-line
        "."    'evilnc-copy-and-comment-operator
        "\\"   'evilnc-comment-operator ; if you prefer backslash key
        "g c"  'magit-commit
        "g s"  'magit-status))

  ;; Change comment style
  ;; (add-hook 'c-mode-common-hook
  ;;   (lambda ()
  ;;     ;; Preferred comment style
  ;;     (setq comment-start "// "
  ;;           comment-end "")))

  ;; Evil key mapping for magit
  (use-package evil-magit
    :ensure t
    :config
    (require 'magit)
    (setq evil-magit-state 'normal)
    (setq evil-magit-use-y-for-yank nil))

  ;; Surround stuff ", ', (), [], {}, etc.
  (use-package evil-surround
    :ensure t
    :config
    (global-evil-surround-mode))

  ;; cool commenter plugins
  (use-package evil-nerd-commenter
    :ensure t))

;; TODO: Imporve terminal padding
(use-package nlinum-relative
  :ensure t
  :config
  (nlinum-relative-setup-evil)     ;; setup for evil
  (setq nlinum-relative-redisplay-delay 0)
  (add-hook 'prog-mode-hook 'nlinum-relative-mode))


;############################################################################
; Themes
;############################################################################
(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox))

(use-package powerline
  :ensure t
  :config
  (setq powerline-default-separator 'arrow-fade))

(use-package smart-mode-line-powerline-theme
  :ensure t)

(use-package smart-mode-line
  :ensure t
  :config
  (require 'powerline)

  (setq sml/theme 'powerline)
  (sml/setup)
  ;; These colors are more pleasing (for gruvbox)
  (custom-theme-set-faces
   'user
   '(powerline-evil-normal-face ((t (:inherit powerline-evil-base-face :background "chartreuse3"))))
   '(sml/folder ((t (:inherit sml/global :background "grey22" :foreground "grey50" :weight normal))) t)
   '(sml/git ((t (:background "grey22" :foreground "chartreuse3"))) t)))

;############################################################################
; Setting keys and stuff
;############################################################################

;; No annoying start messages
(setq inhibit-splash-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)

;; Vim's like scroll
(setq scroll-step            1
      scroll-conservatively  10000)

;; Set backup stuff
(defvar backup-dir "~/.emacs.d/backups/")
(setq backup-directory-alist (list (cons "." backup-dir)))

;; Set autosave stuff
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; Save commands and stuff history
(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))

;; Case-insensitive buffer name tab autocompletion
(setq read-buffer-completion-ignore-case t)

 ;; Default to Unix LF line endings
(setq buffer-file-coding-system 'utf-8-unix)

;; Ignore case when finding files
(setq read-file-name-completion-ignore-case t)

;; No graphic stuff
(show-paren-mode 1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; To cursor line background color
(global-hl-line-mode 1)
(set-face-background 'hl-line "#363636")

(column-number-mode t)

;; Make indentation commands use space only (never tab character)
(setq-default indent-tabs-mode nil)
;; Set default tab char's display width to 4 spaces
(setq-default tab-width 4)
;; Complete or tab
(setq-default tab-always-indent 'complete)
;; Set tab stops to four chars, not eight
(setq tab-stop-list
    '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80))

; (electric-indent-mode 1) ;; make return key also do indent, globally

;; Load server, only if there's none running
(load "server")
(unless (server-running-p) (server-start))

; No wrap text
(setq-default truncate-lines 0)

;; Delete trailing spaces before save file
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Compile init.el on save for speed
(add-hook 'after-save-hook
    (lambda ()
        (let ((dotemacs (expand-file-name "~/.emacs.d/init.el")))
            (if (string= (buffer-file-name) (file-chase-links dotemacs))
                (byte-compile-file dotemacs)))))


(setq default-frame-alist
    (add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono for Powerline-11")))

;; Only y/n questions, not yes/no
(defalias 'yes-or-no-p 'y-or-n-p )

;; Emacs shortcut to kill the buffer
(global-set-key (kbd "C-d") 'kill-buffer)

;############################################################################
; Custom functions
;############################################################################

;;  Fix autocomplete popup {{{
(defun sanityinc/fci-enabled-p () (symbol-value 'fci-mode))

(defvar sanityinc/fci-mode-suppressed nil)
(make-variable-buffer-local 'sanityinc/fci-mode-suppressed)

(defadvice popup-create (before suppress-fci-mode activate)
  "Suspend fci-mode while popups are visible"
  (let ((fci-enabled (sanityinc/fci-enabled-p)))
    (when fci-enabled
      (setq sanityinc/fci-mode-suppressed fci-enabled)
      (turn-off-fci-mode))))

(defadvice popup-delete (after restore-fci-mode activate)
  "Restore fci-mode when all popups have closed"
  (when (and sanityinc/fci-mode-suppressed
             (null popup-instances))
    (setq sanityinc/fci-mode-suppressed nil)
    (setq fill-column 80)
    (turn-on-fci-mode)))
;; }}} End fix autocomplete popup
