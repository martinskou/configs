(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; ===== LOAD PACKAGES

(use-package use-package-ensure-system-package :ensure t)

(use-package exec-path-from-shell
  :ensure t
  :init (exec-path-from-shell-initialize))

(use-package idle-highlight-mode :ensure t)

(use-package lsp-mode
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'lsp))

(use-package lsp-treemacs
  :ensure t)

(use-package treemacs :ensure t)
(use-package treemacs-evil :ensure t)
(use-package treemacs-projectile :ensure t)

(use-package helm :ensure t)
(use-package helm-lsp :ensure t :commands helm-lsp-workspace-symbol)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package dracula-theme
  :defer t
  :ensure t)

(use-package apropospriate-theme
  :ensure t
  :defer t)

(use-package emojify
  :ensure t
  :config
  (add-hook 'after-init-hook #'global-emojify-mode))



(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)
  
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package which-key
   :ensure t
   :config
;   (setq which-key-allow-evil-operators  t)
;   (setq which-key-show-operator-state-maps t)
   (setq which-key-add-column-padding 3)
   (setq which-key-idle-delay 0.05)
   (setq which-key-popup-type 'minibuffer)
   (which-key-mode))
 
(use-package yasnippet :ensure t)

(use-package company
   :ensure t
   :diminish
   :custom
   (company-begin-commands '(self-insert-command))
   (company-idle-delay .1)
   (company-minimum-prefix-length 2)
   (company-show-numbers t)
   (company-tooltip-align-annotations 't)
   (global-company-mode t))


(use-package company-box
   :ensure t
   :after company
   :hook (company-mode . company-box-mode))

;(use-package company-lsp :ensure t)
;(push 'company-lsp company-backends)


(use-package dashboard
  :ensure t
  :preface
  (defun my/dashboard-banner ()
    (setq dashboard-banner-logo-title
          (format "Loadtime %.2f seconds with %d GC.\n\nUse SHIFT+ARROW to change window.\nUse CTRL+SHIFT+ARROW to change window size.\n\n"
                  (float-time (time-subtract after-init-time before-init-time)) gcs-done))
	(setq dashboard-startup-banner 1))
  :init
  (add-hook 'after-init-hook 'dashboard-refresh-buffer)
  (add-hook 'dashboard-mode-hook 'my/dashboard-banner)
  :config (dashboard-setup-startup-hook))


(use-package general
  :ensure t)

(use-package evil
  :ensure t
  :config
  (evil-mode))


;; ===== GENERAL SETUP

(cd "~/")                                         ; Move to the user directory
(column-number-mode 1)                            ; Show the column number
(display-time-mode 1)                             ; Enable time in the mode-line
(fset 'yes-or-no-p 'y-or-n-p)                     ; Replace yes/no prompts with y/n
(global-hl-line-mode)                             ; Hightlight current line
(show-paren-mode 1)                               ; Show the parent
(setq default-tab-width 4)
(setq tab-width 4)
(setq-default tab-width 4)


(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
;(set-w32-system-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8) 




;(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files
(setq create-lockfiles nil)
;; backup in one place. flat, no tree structure
(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))

(setq
   backup-by-copying t      ; don't clobber symlinks
  ; backup-directory-alist '(("." . "~/.saves/"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups


(when window-system
  ; (menu-bar-mode -1)                              ; Disable the menu bar
  (scroll-bar-mode -1)                            ; Disable the scroll bar
  (tool-bar-mode -1)                              ; Disable the tool bar
  (tooltip-mode -1))                              ; Disable the tooltips

										;(use-package ibuffer
;   :ensure t
;  :defer 1
;  :bind ("C-x C-b" . ibuffer))

;(use-package ibuffer-projectile
;  :after ibuffer
;  :preface
;  (defun my/ibuffer-projectile ()
;    (ibuffer-projectile-set-filter-groups)
;    (unless (eq ibuffer-sorting-mode 'alphabetic)
;      (ibuffer-do-sort-by-alphabetic)))
;  :hook (ibuffer . my/ibuffer-projectile))

(defun toggle-window-split ()
  (interactive)
    (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
            (next-win-buffer (window-buffer (next-window)))
            (this-win-edges (window-edges (selected-window)))
            (next-win-edges (window-edges (next-window)))
            (this-win-2nd
             (not (and (<= (car this-win-edges)
                        (car next-win-edges))
                    (<= (cadr this-win-edges)
                        (cadr next-win-edges)))))
         (splitter
          (if (= (car this-win-edges)
                 (car (window-edges (next-window))))
              'split-window-horizontally
            'split-window-vertically)))
    (delete-other-windows)
    (let ((first-win (selected-window)))
      (funcall splitter)
      (if this-win-2nd (other-window 1))
      (set-window-buffer (selected-window) this-win-buffer)
      (set-window-buffer (next-window) next-win-buffer)
      (select-window first-win)
      (if this-win-2nd (other-window 1))))))

;(use-package slime)
;(setq inferior-lisp-program "/usr/local/bin/ros -Q run")
;(setq slime-contribs '(slime-fancy))


(defun nuke-all-buffers ()
  (interactive)
  (mapcar 'kill-buffer (buffer-list))
  (delete-other-windows))

(defun kill-this-buffer-volatile ()
  "Kill current buffer, even if it has been modified."
  (interactive)
  (set-buffer-modified-p nil)
  (kill-this-buffer))

(defun kill-other-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer
          (delq (current-buffer)
                (remove-if-not 'buffer-file-name (buffer-list)))))

(defun load-init ()
  (interactive)
  (find-file (expand-file-name "init.el" "~/.emacs.d/")))

(defun eval-init ()
  (interactive)
  (load (expand-file-name "init.el" "~/.emacs.d/")))

(defun save-all () (interactive) (save-some-buffers t))


(global-set-key (kbd "C-<tab>") 'helm-mini)

(global-set-key (kbd "C-<up>") 'next-buffer)
(global-set-key (kbd "C-<down>") 'previous-buffer)

;(global-set-key (kbd "C-<right>") 'forward-list)
;(global-set-key (kbd "C-<left>") 'backward-list)

;(global-set-key (kbd "<C-right>") 'evil-window-right)
;(global-set-key (kbd "<C-left>") 'evil-window-left)


(global-set-key (kbd "<s-right>") 'move-end-of-line)
(global-set-key (kbd "<s-left>") 'move-beginning-of-line)

(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

;(global-set-key (kbd "S <left>")  'windmove-left)
;(global-set-key (kbd "S <right>") 'windmove-right)
;(global-set-key (kbd "S <up>")    'windmove-up)
;(global-set-key (kbd "S <down>")  'windmove-down)

;(evil-define-key 'normal (kbd "S <up>") 'newline)

(define-key evil-normal-state-map (kbd "S-<left>") 'evil-window-left)
(define-key evil-normal-state-map (kbd "S-<right>") 'evil-window-right)
(define-key evil-normal-state-map (kbd "S-<up>") 'evil-window-up)
(define-key evil-normal-state-map (kbd "S-<down>") 'evil-window-down)

										;(windmove-default-keybindings)


(general-define-key :states '(normal visual insert emacs)
                    :prefix "SPC"
                    :non-normal-prefix "M-SPC"

                    "<right>" 'previous-buffer
                    "<left>" 'next-buffer

                    "o" 'other-window
                    "j" 'helm-imenu
                    "x" 'helm-M-x
                    "k" 'helm-show-kill-ring
                    "q" 'kill-buffer-and-window
                    "r" 'anzu-query-replace
                    "l" 'display-line-numbers-mode


					"g" '(:ignore t :which-key "Grep")
                    "gg" 'deadgrep

					
                    "c" '(:ignore t :which-key "C++")
					"cf" 'clang-format-buffer
					"cF" 'lsp-format-buffer
					"cs" 'lsp-treemacs-symbols
					"cr" 'lsp-treemacs-references
					"ce" 'lsp-treemacs-errors-list
					"cd" 'lsp-ui-doc-mode
					"cl" 'lsp-ui-sideline-mode

					
                    "d" '(:ignore t :which-key "Delete")
                    "dx" 'delete-trailing-whitespace


					"f" '(:ignore t :which-key "Format")
                    "fc" 'comment-region
                    "fu" 'uncomment-region
                    "fd" 'delete-indentation
					"fZ" 'text-scale-increase
					"fz" 'text-scale-decrease
                    "ft" 'toggle-truncate-lines


                    "i" '(:ignore t :which-key "Init")
                    "il" 'load-init
                    "ie" 'eval-init


                    "m" '(:ignore t :which-key "Mode")
					"mi" 'idle-highlight-mode

					"s" '(:ignore t :which-key "Save")
                    "ss" 'save-some-buffers
					"sa" 'save-all


					"t" '(:ignore t :which-key "Treemacs")
					"tt" 'treemacs
					"ts" 'treemacs-select-window

					
                    "T" '(:ignore t :which-key "Theme")
                    "Td" '((lambda () (interactive) (load-theme 'dracula t)) :which-key "Dracula")
                    "To" '((lambda () (interactive) (load-theme 'doom-one t)) :which-key "Doom One")
                    "Ta" '((lambda () (interactive) (load-theme 'apropospriate-dark t)) :which-key "Apropospriate")
				
					
                    "w" '(:ignore t :which-key "Windows")
                    "wk" 'kill-this-buffer-volatile
					"wK" 'kill-other-buffers
                    "wn" 'nuke-all-buffers
                    "wo" 'other-window
                    "wf" 'other-frame
                    "wd" 'delete-window
					"wD" 'delete-other-windows
                    "wr" 'split-window-right
					"wt" 'toggle-window-split
					
                    )

;(pretty-deactivate-groups
; '(:equality :ordering :ordering-double :ordering-triple
;             :arrows :arrows-twoheaded :punctuation
;             :logic :sets))

;(pretty-activate-groups
; '(:sub-and-superscripts :greek :arithmetic-nary))


(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))


(when window-system
  (set-frame-size (selected-frame) 150 40)
;  (set-frame-font "Source Code Pro-14" nil t)
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(fullscreen . maximized))
  (set-frame-font "Fira Code-15" nil t)

  ;; This makes left-option do M-
  (setq ns-alternate-modifier 'meta)
  ;; ... and right-option just do option so I can still type
  ;; alternate characters.
  (setq ns-right-alternate-modifier nil)

  ;; command is super
  (setq ns-command-modifier 'super)

  ;; set fn to hyper
  (setq ns-function-modifier 'hyper)

  ;; This works for copying, but not pasting for some reason
  (setq select-enable-clipboard t)

  (setq interprogram-cut-function 'paste-to-osx)
  (setq interprogram-paste-function 'copy-from-osx))


(setq ns-pop-up-frames nil)
;(load-theme 'dracula t)
(set-default 'truncate-lines t)
(delete-selection-mode 1)

(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-scroll-amount '(0.05))

(global-prettify-symbols-mode +1)
