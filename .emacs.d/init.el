;;; init.el
;;
;; cpence's emacs configuration
;;
;; N.B.: This is designed for Emacs 24 nightly builds; YMMV on Emacs 23
;; and earlier.
;;


;; -------------------------------------
;; Utility code

(load (concat user-emacs-directory "platform.el"))


;; -------------------------------------
;; Path variables

;; Lisp loading path
(let ((default-directory (concat user-emacs-directory "site-lisp/")))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

;; Themes path
(add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes"))

;; Customize tool output
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file)

;; Executable path
(add-dir-to-path "/usr/local/bin")
(if (system-type-is-darwin)
    (add-dir-to-path "/usr/texbin"))


;; -------------------------------------
;; File Input/Output

(require 'recentf)
(setq recentf-save-file (concat user-emacs-directory "recentf"))
(recentf-mode 1)

(global-auto-revert-mode 1)

;; Default to text-mode, not fundamental-mode
(setq-default major-mode 'text-mode)

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq auto-save-list-file-name nil)
(setq auto-save-list-file-prefix nil)

;; UTF-8 *everywhere*
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
(if (system-type-is-windows)
    (set-clipboard-coding-system 'utf-16le-dos))


;; -------------------------------------
;; Aesthetics

(setq default-frame-alist
      (append
       (list
        '(width . 85)
        '(height . 35)
        '(cursor-type . bar)
        '(line-spacing . 1)
        '(alpha . 100))
       default-frame-alist))

(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)

;; On Mac, you get the top-screen menu bar anyway
(unless (system-type-is-darwin)
  (menu-bar-mode -1))

;; Enable mouse and disable menu in console
(if (not window-system)
    (progn
      (menu-bar-mode -1)
      (xterm-mouse-mode t)))

(set-frame-font "Panic Sans-14")
(load-theme 'Railscasts)

(blink-cursor-mode t)
(show-paren-mode t)
(global-hl-line-mode 1)
(setq search-highlight t)
(setq query-replace-highlight t)

(fset 'yes-or-no-p 'y-or-n-p)

(line-number-mode t)
(column-number-mode t)


;; -------------------------------------
;; Load el-get packages

(load (concat user-emacs-directory "packages.el"))


;; -------------------------------------
;; Modernize editing

(delete-selection-mode t)
(transient-mark-mode 1)
(setq x-select-enable-clipboard t)

(setq fill-column 80)

;; Auto-complete *everything*
(require 'ido)
(ido-mode t)
(setq ido-save-directory-list-file "~/.emacs.d/.ido.last")
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
(setq ido-show-dot-for-dired t)


;; -------------------------------------
;; Keys

(cua-mode t)
(setq cua-auto-tabify-rectangles nil)
(setq cua-keep-region-after-copy t)

(windmove-default-keybindings 'meta)
(setq windmove-wrap-around t)

(global-set-key [home] 'beginning-of-line)
(global-set-key [end] 'end-of-line)
(global-set-key [kp-home] 'beginning-of-line)
(global-set-key [kp-end] 'end-of-line)
(global-set-key [kp-delete] 'delete-char)

;; Add save on C-s, move find to C-f
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-S-s") 'save-some-buffers)
(global-set-key (kbd "C-f") 'isearch-forward)
(define-key isearch-mode-map (kbd "C-f") 'isearch-repeat-forward)

;; Set some other comfort keys from other editors
(global-set-key (kbd "C-a") 'mark-whole-buffer)
(global-set-key (kbd "C-l") 'goto-line)
(global-set-key (kbd "C-o") 'find-file)
(global-set-key (kbd "C-{") 'previous-buffer)
(global-set-key (kbd "C-}") 'next-buffer)
(global-set-key (kbd "C-w") (lambda () (interactive) (kill-buffer (current-buffer))))
(global-set-key (kbd "C-q") 'save-buffers-kill-terminal)
(global-set-key (kbd "M-q") 'quoted-insert)
(global-set-key (kbd "<C-prior>") (lambda () (interactive) (goto-char (point-min))))
(global-set-key (kbd "<C-next>") (lambda () (interactive) (goto-char (point-max))))

(global-set-key (kbd "<M-tab>") 'ido-switch-buffer)
(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)
(global-set-key (kbd "C-x C-c") 'ido-switch-buffer)
(global-set-key (kbd "C-x B") 'ibuffer)


;; -------------------------------------
;; Tabs

(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)


;; -------------------------------------
;; Mode Hooks

(defun cpence-text-mode-hook ()
  (interactive)
  
  ;; Enable longlines-mode for text
  (longlines-mode 1)
  
  ;; Normal TAB key in text editing
  (setq indent-line-function 'insert-tab)
  
  ;; Enable modeline word counting
  (word-count-mode-on)
  (word-count-set-marker-off)
)
(add-hook 'text-mode-hook 'cpence-text-mode-hook)


(defun cpence-latex-mode-hook ()
  (interactive)
  
  ;; Bind the TeX building and viewing commands
  (local-set-key (kbd "C-r") 'TeX-command-master)
  (local-set-key [f7] 'TeX-command-master)
  (local-set-key (kbd "C-S-r") 'TeX-view)
  (local-set-key [f5] 'TeX-view)
  
  ;; Configure AucTeX
  (TeX-PDF-mode 1)
  (font-latex-add-quotes '("“" "”"))
  
  ;; Add BuildTex script
  (add-to-list 'TeX-command-list '("BuildTeX" "~/bin/buildtex %t" TeX-run-LaTeX nil t))
  (setq TeX-command-default "BuildTeX")
  
  ;; Set an OS-appropriate TeX view command
  (setq TeX-view-program-list '(("Skim" "open \"%s.pdf\"") ("Okular" "okular \"%s.pdf\"")))
  
  (if (system-type-is-gnu)
      (setq TeX-view-program-selection '((output-pdf "Okular") (output-dvi "Okular"))))
  (if (system-type-is-darwin)
      (setq TeX-view-program-selection '((output-pdf "Skim"))))
)
(add-hook 'LaTeX-mode-hook 'cpence-latex-mode-hook)


