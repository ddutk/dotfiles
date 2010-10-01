(defun color-theme-pence ()
  "Color theme by Charles Pence, created 2010-07-17.
Based on color-theme-gtk-ide, Jeff Atwood's programming IDE
screenshot, and the Tango palette."
  (interactive)
  (color-theme-install
   '(color-theme-pence
     ((background-color . "#f8f8f8")
      (foreground-color . "#000000")
      (background-mode . light)
      (mouse-color . "#2e3436")
      (cursor-color . "#2e3436"))
     (default ((t nil)))
     (font-lock-comment-face ((t (:foreground "#438504"))))
     (font-lock-string-face ((t (:foreground "#8f5902"))))
     (font-lock-keyword-face ((t (:foreground "#204a87"))))
     (font-lock-warning-face ((t (:bold t :foreground "#cc0000"))))
     (font-lock-constant-face ((t (:foreground "#204a87"))))
     (font-lock-type-face ((t (:foreground "#ce5c00"))))
     (font-lock-variable-name-face ((t (:foreground "#a40000"))))
     (font-lock-function-name-face ((t (:foreground "#a40000"))))
     (font-lock-builtin-face ((t (:foreground "#204a87"))))
     (font-lock-preprocessor-face ((t (:foreground "#204a87"))))
     (hl-line ((t (:background "#eeeeec"))))
     (show-paren-match-face ((t (:bold t :background "#d3d7cf"))))
     (region ((t (:background "#ceff84"))))
     (highlight ((t (:background "#ceff84"))))
	 (fringe ((t (:background "#f8f8f8"))))
     (widget-field-face ((t (:background "grey55"))))
     (widget-single-line-field-face ((t (:background "grey55"))))
     
     (font-latex-warning-face ((t (:bold t :foreground "#cc0000"))))
     (font-latex-sectioning-0-face ((t (:bold t :foreground "#ce5c00"))))
     (font-latex-sectioning-1-face ((t (:bold t :foreground "#ce5c00"))))
     (font-latex-sectioning-2-face ((t (:bold t :foreground "#ce5c00"))))
     (font-latex-sectioning-3-face ((t (:bold t :foreground "#ce5c00"))))
     (font-latex-sectioning-4-face ((t (:bold t :foreground "#ce5c00"))))
     (font-latex-sectioning-5-face ((t (:bold t :foreground "#ce5c00"))))
     (font-latex-bold-face ((t (:inherit bold))))
     (font-latex-italic-face ((t (:inherit italic))))
     (font-latex-type-face ((t (:inherit font-lock-type-face))))
     (font-latex-string-face ((t (:inherit font-lock-string-face))))
     (font-latex-verbatim-face ((t (:inherit font-lock-string-face))))
     (font-latex-math-face ((t (:inherit font-lock-string-face))))
)) )