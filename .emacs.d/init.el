
;; -------------------------------------
;; Add a bunch of paths

(push "/usr/local/bin" exec-path)
(push "/usr/texbin" exec-path)
(setenv "PATH" (mapconcat (lambda (dir) (or dir ".")) exec-path ":"))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; This path is used by lots of different things
(add-to-list 'load-path "~/.emacs.d/packages")


;; -------------------------------------
;; Window settings

(require 'saveplace)
(require 'uniquify)

(setq default-frame-alist
      '((width . 115)
        (height . 40)
        (cursor-type . bar)
        (font . "Panic Sans-13")))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(mouse-wheel-mode t)
(require 'smooth-scrolling)

(set-fringe-style -1)

(blink-cursor-mode t)
(show-paren-mode t)

(fset 'yes-or-no-p 'y-or-n-p)

(add-to-list 'custom-theme-load-path "~/.emacs.d/packages/themes")
(load-theme 'tomorrow-night)
(require 'rainbow-mode)

(setq-default save-place t)

(setq inhibit-startup-message t
      inhibit-splash-screen t
      visible-bell t
      echo-keystrokes 0.1
      font-lock-maximum-decoration t
      xterm-mouse-mode t
      search-highlight t
      query-replace-highlight t
      uniquify-buffer-name-style 'forward
      color-theme-is-global t
      save-place-file "~/.emacs.d/cache/places")


;; -------------------------------------
;; Window settings

(line-number-mode t)
(column-number-mode t)

(add-hook 'emacs-lisp-mode-hook (lambda() (setq mode-name "el")))
(add-hook 'org-mode-hook (lambda() (setq mode-name "Org")))

(setq cp-mode-line-filename
      (list
       '(:eval (propertize "%b" 'face 'font-lock-string-face
                           'help-echo (buffer-file-name)))
       '(:eval (when (buffer-modified-p)
                 (propertize "*" 'face 'font-lock-variable-name-face
                             'help-echo "Buffer has been modified")))
       " "))

(setq cp-mode-line-position
      (list
       "("
       (propertize "%02l" 'face 'font-lock-builtin-face) ","
       (propertize "%02c" 'face 'font-lock-builtin-face)
       ") "))

(setq global-mode-string '(wl-modeline-biff-status
                           wl-modeline-biff-state-on
                           wl-modeline-biff-state-off))

(setq cp-mode-line-time
      (list
       '(:eval (propertize (format-time-string "%H:%M")
                           'help-echo (concat (format-time-string "%c; ")
                                              (emacs-uptime "Uptime: %hh"))))))

(setq-default mode-line-format (list " "
                                     cp-mode-line-filename
                                     cp-mode-line-position
                                     "%M "
                                     cp-mode-line-time
                                     " %-"
                                     ))


;; -------------------------------------
;; Editing

(delete-selection-mode t)

(setq-default tab-width 2
              indent-tabs-mode nil
              fill-column 80)

(defun set-tab-stop-width (width)
  "Set all tab stops to WIDTH in current buffer.
    
   This updates `tab-stop-list', but not `tab-width'.
    
   By default, `indent-for-tab-command' uses tabs to indent, see
   `indent-tabs-mode'."
  (interactive "nTab width: ")
  (let* ((max-col (car (last tab-stop-list)))
         ;; If width is not a factor of max-col,
         ;; then max-col could be reduced with each call.
         (n-tab-stops (/ max-col width)))
    (set (make-local-variable 'tab-stop-list)
         (mapcar (lambda (x) (* width x))
                 (number-sequence 1 n-tab-stops)))
    ;; So preserve max-col, by adding to end.
    (unless (zerop (% max-col width))
      (setcdr (last tab-stop-list)
              (list max-col)))))

(setq transient-mark-mode t
      x-select-enable-clipboard t)


;; -------------------------------------
;; Visual-line-mode with a wrap column

(defvar visual-wrap-column nil)

(defun set-visual-wrap-column (new-wrap-column &optional buffer)
  "Force visual line wrap at NEW-WRAP-COLUMN in BUFFER (defaults
    to current buffer) by setting the right-hand margin on every
    window that displays BUFFER.  A value of NIL or 0 for
    NEW-WRAP-COLUMN disables this behavior."
  (interactive (list (read-number "New visual wrap column, 0 to disable: " (or visual-wrap-column fill-column 0))))
  (if (and (numberp new-wrap-column)
           (zerop new-wrap-column))
      (setq new-wrap-column nil))
  (with-current-buffer (or buffer (current-buffer))
    (visual-line-mode t)
    (set (make-local-variable 'visual-wrap-column) new-wrap-column)
    (add-hook 'window-configuration-change-hook 'update-visual-wrap-column nil t)
    (let ((windows (get-buffer-window-list)))
      (while windows
        (when (window-live-p (car windows))
          (with-selected-window (car windows)
            (update-visual-wrap-column)))
        (setq windows (cdr windows))))))

(defun update-visual-wrap-column ()
  (if (not visual-wrap-column)
      (set-window-margins nil nil)
    (let* ((current-margins (window-margins))
           (right-margin (or (cdr current-margins) 0))
           (current-width (window-width))
           (current-available (+ current-width right-margin)))
      (if (<= current-available visual-wrap-column)
          (set-window-margins nil (car current-margins))
        (set-window-margins nil (car current-margins)
                            (- current-available visual-wrap-column))))))

(defun visual-line-line-range ()
  (save-excursion
    (cons (progn (vertical-motion 0) (point))
          (progn (vertical-motion 1) (point)))))


;; -------------------------------------
;; File writing

(global-auto-revert-mode 1)

(setq make-backup-files nil
      auto-save-default nil
      auto-save-list-file-name nil
      auto-save-list-file-prefix nil
      delete-by-moving-to-trash t)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))


;; -------------------------------------
;; Auto-completion, with recent file support

(require 'recentf)
(recentf-mode 1)
(setq recentf-exclude '("ido.last" "~$"))

(ido-mode t)
(setq ido-enable-prefix nil
      ido-enable-flex-matching t
      ido-create-new-buffer 'always
      ido-use-filename-at-point 'guess
      ido-save-directory-list-file "~/.emacs.d/cache/ido.last")

(defun recentf-ido-find-file ()
  "Find a recent file using Ido."
  (interactive)
  (let* ((file-assoc-list
          (mapcar (lambda (x)
                    (cons (file-name-nondirectory x)
                          x))
                  recentf-list))
         (filename-list
          (remove-duplicates (mapcar #'car file-assoc-list)
                             :test #'string=))
         (filename (ido-completing-read "Choose recent file: "
                                        filename-list
                                        nil
                                        t)))
    (when filename
      (find-file (cdr (assoc filename
                             file-assoc-list))))))


;; -------------------------------------
;; Global key bindings

;; On Mac OS X, turn Command into Super
(if (string-equal system-type "darwin")
    (progn
      (setq ns-command-modifier 'super)))

;; Fix home and end on Mac OS X
(global-set-key [home] 'beginning-of-visual-line)
(global-set-key [end] 'end-of-visual-line)
(global-set-key [kp-home] 'beginning-of-visual-line)
(global-set-key [kp-end] 'end-of-visual-line)
(global-set-key [kp-delete] 'delete-char)
(if (string-equal system-type "darwin")
    (progn
      (global-set-key [s-left] 'beginning-of-visual-line)
      (global-set-key [s-right] 'end-of-visual-line)))

;; Enable ido buffer switching
(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)
(global-set-key (kbd "C-x B") 'ibuffer)

;; Enable recent file opening (I don't use find-file-read-only)
(global-set-key (kbd "C-x C-r") 'recentf-ido-find-file)

;; Go-to-line should be easy
(global-set-key "\C-xg" 'goto-line)


;; -------------------------------------
;; Dired

(require 'ls-lisp)
(setq ls-lisp-use-insert-directory-program nil)

(require 'dired-details)
(setq dired-details-hidden-string "")
(dired-details-install)


;; -------------------------------------
;; Eshell

(global-set-key [f1] 'eshell)

(defun cpence-eshell-mode-hook ()
  (interactive)
  (define-key eshell-mode-map "\C-a" 'eshell-bol)
)

(eval-after-load 'esh-opt
  '(progn
     (require 'em-cmpl)
     (require 'em-prompt)
     (require 'em-term)
     (setenv "PAGER" "cat")
     (add-hook 'eshell-mode-hook 'cpence-eshell-mode-hook)
     (add-to-list 'eshell-visual-commands "ssh")
     (add-to-list 'eshell-visual-commands "tail")
     (add-to-list 'eshell-command-completions-alist
                  '("gunzip" "gz\\'"))
     (add-to-list 'eshell-command-completions-alist
                  '("tar" "\\(\\.tar|\\.tgz\\|\\.tar\\.gz\\|\\.tar\\.bz2\\)\\'"))
     (add-to-list 'eshell-output-filter-functions 'eshell-handle-ansi-color)))

(setq eshell-cmpl-cycle-completions nil
      eshell-save-history-on-exit t
      eshell-cmpl-dir-ignore "\\`\\(\\.\\.?\\|CVS\\|\\.svn\\|\\.git\\)/\\'"
      eshell-directory-name "~/.emacs.d/eshell")


;; -------------------------------------
;; W3M / Wanderlust

(add-to-list 'load-path "~/.emacs.d/packages/apel")
(add-to-list 'load-path "~/.emacs.d/packages/flim")
(add-to-list 'load-path "~/.emacs.d/packages/semi")
(add-to-list 'load-path "~/.emacs.d/packages/wl")
(add-to-list 'load-path "~/.emacs.d/packages/w3m")

(setq browse-url-browser-function 'w3m-browse-url)
(require 'w3m-load)
(require 'mime-w3m)

(setq w3m-use-cookies t
      mime-w3m-safe-url-regexp nil
      w3m-default-display-inline-images t
      w3m-toggle-inline-images-permanently nil)

;; Fix W3M's silly keys
(define-key w3m-mode-map [left] 'backward-char)
(define-key w3m-mode-map [right] 'forward-char)
(define-key w3m-mode-map [up] 'previous-line)
(define-key w3m-mode-map [down] 'next-line)
(define-key w3m-minor-mode-map [left] 'backward-char)
(define-key w3m-minor-mode-map [right] 'forward-char)
(define-key w3m-minor-mode-map [up] 'previous-line)
(define-key w3m-minor-mode-map [down] 'next-line)

(autoload 'wl "wl" "Wanderlust" t)
(global-set-key [f12] 'wl)
(setq wl-init-file "~/.emacs.d/wl.el"
      wl-folders-file "~/.emacs.d/folders")


;; -------------------------------------
;; Org-mode

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)

(global-set-key [f11] (lambda () (interactive) (org-agenda nil "n")))
(global-set-key [f9] (lambda () (interactive) (find-file "~/Dropbox/Charles/Personal/Org/")))
(global-set-key [f10] 'org-agenda)
(global-set-key (kbd "C-c a") 'org-agenda)

(setq org-directory "~/Dropbox/Charles/Personal/Org/")
(setq org-agenda-files '("~/Dropbox/Charles/Personal/Org/"))
(setq org-default-notes-file (concat org-directory "todo.org"))

(setq org-log-done 'time
      org-use-fast-todo-selection t
      org-M-RET-may-split-line nil
      org-agenda-ndays 7
      org-agenda-show-all-dates t
      org-agenda-skip-deadline-if-done t
      org-agenda-skip-scheduled-if-done t
      org-agenda-start-on-weekday nil
      org-agenda-skip-additional-timestamps-same-entry nil
      org-agenda-window-setup 'current-window
      org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9)))
      org-refile-use-outline-path 'file
      org-outline-path-complete-in-steps t
      org-refile-allow-creating-parent-nodes (quote confirm)
      org-completion-use-ido t
      org-attach-method 'cp
      calenar-date-mode 'iso
      bookmark-default-file "~/.emacs.d/cache/bookmarks"
      org-id-locations-file "~/.emacs.d/cache/org-id-locations")

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w)" "HOLD(h)" "|" "CANCELLED(c)"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "#CC6666" :weight bold)
              ("NEXT" :foreground "#81A2BE" :weight bold)
              ("DONE" :foreground "#B5BD68" :weight bold)
              ("WAITING" :foreground "#DE935F" :weight bold)
              ("CANCELLED" :foreground "#F0C674" :weight bold))))

(setq org-agenda-custom-commands
      '(("n" "Agenda and next actions"
         ((todo "NEXT")
          (agenda "")))
        ("P" "Timestamped items in the past"
         ((tags "TIMESTAMP<=\"<now>\"")))))

(defun cpence-org-mode-hook ()
  (interactive)

  ;; Patch up some variables
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'org-indent-line-function)
)
(add-hook 'org-mode-hook 'cpence-org-mode-hook)


;; -------------------------------------
;; Magit

(add-to-list 'load-path "~/.emacs.d/packages/magit.git")
(require 'magit)
(add-to-list 'auto-mode-alist '("COMMIT_EDITMSG$" . diff-mode))
(set-face-foreground 'magit-diff-add "green3")
(set-face-foreground 'magit-diff-del "red3")

;; -------------------------------------
;; YASnippet

(add-to-list 'load-path "~/.emacs.d/packages/yasnippet.git")
(require 'yasnippet)
(yas/global-mode 1)

;; -------------------------------------
;; Deft mode

(add-to-list 'load-path "~/.emacs.d/packages/deft.git")
(require 'deft)
(setq deft-extension "md")
(setq deft-directory "~/Dropbox/Charles/Notes")
(setq deft-text-mode 'markdown-mode)
(setq deft-use-filename-as-title t)
(global-set-key [f2] 'deft)

;; -------------------------------------
;; Markdown mode

(add-to-list 'load-path "~/.emacs.d/packages/markdown-mode.git")
(autoload 'markdown-mode "markdown-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))

;; -------------------------------------
;; Fill Column Indicator mode

(add-to-list 'load-path "~/.emacs.d/packages/fill-column-indicator.git")
(autoload 'fci-mode "fill-column-indicator" nil t)
(setq fci-rule-color "#2B2B2B")

;; -------------------------------------
;; AUCTeX

(add-to-list 'load-path "~/.emacs.d/packages/auctex-11.86")
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(add-to-list 'completion-ignored-extensions ".aux")
(add-to-list 'completion-ignored-extensions ".ent")
(add-to-list 'completion-ignored-extensions ".toc")
(add-to-list 'completion-ignored-extensions ".bbl")
(add-to-list 'completion-ignored-extensions ".blg")
(add-to-list 'completion-ignored-extensions ".fdb_latexmk")
(setq font-latex-fontify-sectioning 'color)

;; -------------------------------------
;; CSS mode

(autoload 'css-mode "css-mode-1.0" nil t)
(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))
(add-to-list 'auto-mode-alist '("\\.scss$" . css-mode))
(add-hook 'css-mode-hook '(lambda ()
                            (setq css-indent-level 2)
                            (setq css-indent-offset 2)))

;; -------------------------------------
;; Ruby mode

(autoload 'ruby-mode "ruby-mode-1.1" nil t)
(add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru\\'" . ruby-mode))
(add-to-list 'completion-ignored-extensions ".rbc")

;; -------------------------------------
;; YAML mode

(add-to-list 'load-path "~/.emacs.d/packages/yaml-mode.git/")
(autoload 'yaml-mode "yaml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

;; -------------------------------------
;; RHTML mode

(add-to-list 'load-path "~/.emacs.d/packages/rhtml.git/")
(autoload 'rhtml-mode "rhtml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.erb\\'" . rhtml-mode))
(add-to-list 'auto-mode-alist '("\\.rjs\\'" . rhtml-mode))

;; -------------------------------------
;; Cucumber feature mode

(add-to-list 'load-path "~/.emacs.d/packages/cucumber.el.git/")
(autoload 'feature-mode "feature-mode" nil t)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))

;; -------------------------------------
;; JS2 mode

(add-to-list 'load-path "~/.emacs.d/packages/js2-mode.git/")
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js\\(on\\)?$" . js2-mode))

;; -------------------------------------
;; Python mode

(add-to-list 'load-path "~/.emacs.d/packages/python-mode.git/")
(autoload 'python-mode "python-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))

;; -------------------------------------
;; Haml mode

(add-to-list 'load-path "~/.emacs.d/packages/haml-mode.git/")
(autoload 'haml-mode "haml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.haml$" . haml-mode))

;; ----------------------------------------------------
;; C mode

(defun cpence-c-mode-hook ()
  (interactive)

  ;; Engage automatic-everything mode
  (c-toggle-auto-state 1)

  ;; Don't indent namespaces, do indent comments
  (c-set-offset 'innamespace 0)
  (setq c-comment-only-line-offset 0)

  ;; Set cleanups
  (add-to-list 'c-cleanup-list 'defun-close-semi)
)
(add-hook 'c-mode-common-hook 'cpence-c-mode-hook)

;; Set indentation options
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

;; H files should be in C++
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; -------------------------------------
;; Mode hooks

(defun cpence-text-mode-hook ()
  (interactive)

  (hl-line-mode)
  (set (make-local-variable 'hl-line-range-function) 'visual-line-line-range)

  (visual-line-mode)
  (set-visual-wrap-column 82)

  (setq indent-line-function 'insert-tab)
  (set-tab-stop-width 2)
)
(add-hook 'text-mode-hook 'cpence-text-mode-hook)

(defun cpence-latex-mode-hook ()
  (interactive)

  ;; Patch up some variables
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'LaTeX-indent-line)

  (TeX-PDF-mode 1)
  (setq TeX-save-query nil
        TeX-parse-self t
        TeX-auto-save t
        TeX-auto-untabify t
        TeX-command-default "Latexmk"
        TeX-view-program-list '(("Open" "open %s.pdf"))
        TeX-view-program-selection '((output-pdf "Open")))
  (push '("Latexmk" "latexmk -f -pdf %s" TeX-run-command nil t :help "Run Latexmk on file")
        TeX-command-list)
)
(add-hook 'LaTeX-mode-hook 'cpence-latex-mode-hook)

(defun cpence-markdown-mode-hook ()
  (interactive)
  
  ;; Actually insert tab characters and newlines, indentation stuff
  ;; goes crazy in markdown-mode for some reason
  (define-key markdown-mode-map (kbd "<tab>") 'tab-to-tab-stop)
  (define-key markdown-mode-map (kbd "C-m") 'newline)

  (set-tab-stop-width 4)
)
(add-hook 'markdown-mode-hook 'cpence-markdown-mode-hook)

;; When killing a line, strip the indentation characters off
;; of the front
(defun kill-and-join-forward (&optional arg)
  (interactive "P")
  (if (and (eolp) (not (bolp)))
      (progn (forward-char 1)
             (just-one-space 0)
             (backward-char 1)
             (kill-line arg))
    (kill-line arg)))

(defun cpence-code-mode-hook ()
  (interactive)

  ;; Highlight current line
  (hl-line-mode)
  
  ;; Newline = indent
  (local-set-key (kbd "RET") 'newline-and-indent)

  ;; And bind kill-line to indent-killing-kill-line in
  ;; all source modes
  (local-set-key (kbd "C-k") 'kill-and-join-forward)

  ;; Show me the fill column
  (fci-mode 1)
)

;; There's no "general" mode-hook that handles all of the
;; programming modes, so we have to set all these hooks
;; ourselves.
(add-hook 'c-mode-common-hook 'cpence-code-mode-hook)
(add-hook 'html-mode-hook 'cpence-code-mode-hook)
(add-hook 'css-mode-hook 'cpence-code-mode-hook)
(add-hook 'asm-mode-hook 'cpence-code-mode-hook)
(add-hook 'xml-mode-hook 'cpence-code-mode-hook)
(add-hook 'js2-mode-hook 'cpence-code-mode-hook)
(add-hook 'python-mode-hook 'cpence-code-mode-hook)
(add-hook 'ruby-mode-hook 'cpence-code-mode-hook)
(add-hook 'rhtml-mode-hook 'cpence-code-mode-hook)
(add-hook 'yaml-mode-hook 'cpence-code-mode-hook)
(add-hook 'emacs-lisp-mode-hook 'cpence-code-mode-hook)

