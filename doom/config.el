;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Till Schröder"
      user-mail-address "hi@till.red")


;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'mastering
;; play play vif=deo in be,acs
;;
;;
;;
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;;(setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type  t)


;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;(custom-set-variables
;; custom-set-variables was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
;; '(package-selected-packages
;;   '(undo-tree zpl-mode helm-idris zig-mode elm-mode csharp-mode zzz-to-char idris-mode))
;; '(safe-local-variable-values
;;   '((eval if
;;           (boundp 'c-offsets-alist))
;;     (eval add-to-list 'auto-mode-alist
;;           '("\\.h\\'" . c-mode))
;;     (whitespace-style face tabs tab-mark trailing lines-tail empty))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq doom-font (font-spec :family "Fira Code" :size 30)
      ;;     doom-variable-pitch-font (font-spec :family "Fira Sans") ; inherits `doom-font''s :size
      ;;      ; doom-unicode-font (font-spec :family "Input Mono Narrow" :size 12)
      doom-big-font (font-spec :family "Fira Code" :size 50))

;; Key binds

(map!
 :map  helm-find-files-map
 "TAB"  'helm-execute-persistent-action
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package! company                                                      ;;
;;   :config                                                                  ;;
;;   ;;<return> is for windowed Emacs; RET is for terminal Emacs              ;;
;;   (dolist (key '("<return>" "RET"))                                        ;;
;;     ;; Here we are using an advanced feature of define-key that lets       ;;
;;     ;; us pass an "extended menu item" instead of an interactive           ;;
;;     ;; function. Doing this allows RET to regain its usual                 ;;
;;     ;; functionality when the user has not explicitly interacted with      ;;
;;     ;; Company.                                                            ;;
;;     (define-key company-active-map (kbd key)                               ;;
;;                 `(menu-item nil company-complete                           ;;
;;                   :filter ,(lambda (cmd)                                   ;;
;;                              (when (company-explicit-action-p)             ;;
;;                                cmd)))))                                    ;;
;;   (define-key company-active-map (kbd "TAB") #'company-complete-selection) ;;
;;   (define-key company-active-map (kbd "SPC") nil)                          ;;
;;   (setq company-idle-delay -1                                              ;;
;;         company-minimum-prefix-length 3))                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'tramp
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  )


;; define that the company completion is done with tab. Enter should just be used to insert a new line.
(use-package! company
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
              ("TAB" . 'company-complete-selection)
              ("<tab>" . 'company-complete-selection)
              ("RET" . nil)
              ("<return>" . nil)))

;; in prog mode, tab should perform company-indent-or-complete-common, but this should effect other modes, such as helm.
(add-hook 'prog-mode-hook
          (lambda ()
            (define-key global-map (kbd "M-TAB") #'company-search-mode)
            (define-key global-map (kbd "M-<tab>") #'company-search-mode)
            )
          )

(with-eval-after-load 'company
  (define-key company-active-map (kbd "<return>") nil)
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map (kbd "TAB") #'company-complete-selection)
  (define-key company-active-map (kbd "<tab>") #'company-complete-selection)
  (setq company-idle-delay nil)
  )

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)
              )
  )

;; Custom Packages

;; (use-package! idris2-mode
;;   :load-path "list/idris2-mode"
;;   )

;; Straight settings
;;(setq straight-disable-native-compilation t)
;;  (auto-save-visited-mode 1)


;; haskell

(after! lsp-haskell
  (setq lsp-haskell-formatting-provider "brittany"))


(setq shell-file-name "/bin/bash")


;; The doom dashbaord of doom should show links to hardcoded files, such as "/ssh:netem@172.16.0.2:/home/netem/" or ~/.doom.d/config.el.
;; For this we need to change +doom-dashboard-functions.
;; ssh path link for tramp:


(defun +doom-dashboard--insert-links ()
  "Insert the list of links."
  (insert "\n")
  (insert (propertize "  Links\n" 'face 'doom-dashboard-menu-title))
  (let ((links
         (cl-loop for path in (list "~/.doom.d/config.el" "/ssh:netem@"))
         ))
    (insert (mapconcat (lambda (link) (concat "  " link "\n")) links ""))
    (insert "\n")))
