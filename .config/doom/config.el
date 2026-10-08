;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Marcel van Laar"
      user-mail-address "m.s.vanlaar@students.uu.nl")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
(setq doom-font (font-spec :family "monospace" :size 9.0))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(set-frame-parameter (selected-frame) 'alpha-background '(90))
;;(add-to-list 'default-frame-alist '(alpha-background . 50))
(setq doom-theme 'doom-1337)
 ;;(setq doom-theme 'doom-tomorrow-night)
;; (custom-set-faces!
;; '(default :background "#000000")
;; '(solaire-default-face :background "#000000"))


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;follow windows
(defun after_split-window (&rest _arg)
"go to new window when you spawn it, and open buffer selector"
(other-window 1)
(ibuffer))

(advice-add 'evil-window-vsplit :after #'after_split-window)
(advice-add 'evil-window-split :after #'after_split-window)

;; org mode
        ;;disable flycheck, company, when using org-mode
        (add-hook 'org-mode-hook (lambda () (flycheck-mode -1)))
        (add-hook 'org-mode-hook (lambda () (company-mode -1)))

        ;;images
        (setq org-startup-with-inline-images t)
        (setq org-image-actual-width 300)


;; latex and exporting to pdf
        ;; alllow keywords for images
        (setq org-export-allow-bind-keywords t)
        (setq org-latex-image-default-width "")

        ;;press SPC i l to insert "export" snippit with "latex", and enter cdlatex mode
        (map! :leader
                :desc "insert latex"
                "i l" #'my/insert-latex_export)

        ;;press SPC p l to export to latex
        (map! :leader
                :desc "export to latex pdf with pandoc"
                "p l" #'org-pandoc-export-to-latex-pdf)
        (map! :leader
                :desc "export to latex pdf with pandoc and open"
                "p o" #'org-pandoc-export-to-latex-pdf-and-open)

        (defun my/insert-latex_export ()
        "insert export latex statement"
        (interactive)
        (insert "#+BEGIN_EXPORT latex \n #+END_EXPORT")
        (evil-previous-line)
        (evil-insert-state)
        (cdlatex-mode)
        (pandoc-mode)
        (global-prettify-symbols-mode)) ;; \alpha -> a, as a substitute for actually decoding LaTeX

        ;; (cdlatex-mode))
        ;; rebind cdlatex-tab to ; while in cdlatex mode
        (add-hook 'cdlatex-mode-hook (map! ";" #'cdlatex-tab))
        (add-hook 'cdlatex-mode-hook (map! "C-;" #'my/insertcomma))
        (defun my/insertcomma()
        (interactive)
        (insert! ";"))


        ;; turn off cd latex mode with SPC k c
        (map! :leader
                :desc "sortof reset cdlatex mode"
                "k c" #'my/resetcdlatex)

        (defun my/resetcdlatex()
        (interactive)
        (cdlatex-reset-mode)
        (add-hook 'cdlatex-mode-hook (map! ";" #'my/insertcomma))
        (add-hook 'cdlatex-mode-hook (map! "C-;" #'embark-act)))


        ;;pdf loader
        ;;(pdf-loader-install)

        ;;fix org mode export to pdf?
        (require 'ox-latex)
        (unless (boundp 'org-latex-classes)
        (setq org-latex-classes nil))
        (add-to-list 'org-latex-classes
                '("apa6"
                        "\\documentclass{apa6}"
                        ("\\section{%s}" . "\\section*{%s}")
                        ("\\subsection{%s}" . "\\subsection*{%s}")
                        ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                        ("\\paragraph{%s}" . "\\paragraph*{%s}")
                        ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
        ;;boiler code from http://www.wouterspekkink.org/academia/writing/tool/doom-emacs/2021/02/27/writing-academic-papers-with-org-mode.html
        ;; helm-bibtex related stuff
        (after! helm
        (use-package! helm-bibtex
        :custom
        ;; In the lines below I point helm-bibtex to my default library file.
        (bibtex-completion-bibliography '("~/Zotero/bibtex/library.bib"))
        (reftex-default-bibliography '("~/Zotero/bibtex/library.bib"))
        ;; The line below tells helm-bibtex to find the path to the pdf
        ;; in the "file" field in the .bib file.
        (bibtex-completion-pdf-field "file")
        :hook (Tex . (lambda () (define-key Tex-mode-map "\C-ch" 'helm-bibtex))))
        ;; I also like to be able to view my library from anywhere in emacs, for example if I want to read a paper.
        ;; I added the keybind below for that.
        (map! :leader
                :desc "Open literature database"
                "o l" #'helm-bibtex)
        ;; And I added the keybinds below to make the helm-menu behave a bit like the other menus in emacs behave with evil-mode.
        ;; Basically, the keybinds below make sure I can scroll through my list of references with C-j and C-k.
        (map! :map helm-map
                "C-j" #'helm-next-line
                "C-k" #'helm-previous-line)
        )

;; Disable mouse (because it's fucking annoying)
        (use-package inhibit-mouse
        :ensure t
        :custom
        ;; Disable highlighting of clickable text such as URLs and hyperlinks when
        ;; hovered by the mouse pointer.
        (inhibit-mouse-adjust-mouse-highlight t)

        ;; Disables the use of tooltips (show-help-function) during mouse events.
        (inhibit-mouse-adjust-show-help-function t)

        :config
        (if (daemonp)
        (add-hook 'server-after-make-frame-hook #'inhibit-mouse-mode)
        (inhibit-mouse-mode 1)))
