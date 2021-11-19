;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Fengyu Quan"
      user-mail-address "18b353011@stu.hit.edu.cn")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

(setq doom-font (font-spec :family "monospace" :size 24 )
      doom-variable-pitch-font (font-spec :family "Sans" :size 24))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-dracula)
(setq doom-theme 'dracula)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


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

(setq lsp-clients-clangd-args '("-j=20"
                                "--background-index"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

;; (setq org-agenda-files (quote ("~/Nextcloud/Notes/daily/2021/20211116.org")))
(setq org-agenda-files (append
                        (file-expand-wildcards "~/Nextcloud/Notes/daily/2021/*.org")))

(use-package org-super-agenda
  :init
  (let ((org-super-agenda-groups
         '(;; Each group has an implicit boolean OR operator between its selectors.
           (:name "Today"  ; Optionally specify section name
            :time-grid t  ; Items that appear on the time grid
            :todo "TODAY")  ; Items that have this TODO keyword
           (:name "Important"
            ;; Single arguments given alone
            :tag "bills"
            :priority "A")
           ;; Set order of multiple groups at once
           (:order-multi (2 (:name "Shopping in town"
                             ;; Boolean AND group matches items that match all subgroups
                             :and (:tag "shopping" :tag "@town"))
                            (:name "Food-related"
                             ;; Multiple args given in list with implicit OR
                             :tag ("food" "dinner"))
                            (:name "Personal"
                             :habit t
                             :tag "personal")
                            (:name "Space-related (non-moon-or-planet-related)"
                             ;; Regexps match case-insensitively on the entire entry
                             :and (:regexp ("space" "NASA")
                                   ;; Boolean NOT also has implicit OR between selectors
                                   :not (:regexp "moon" :tag "planet")))))
           ;; Groups supply their own section names when none are given
           (:todo "WAITING" :order 8)  ; Set order of this section
           (:todo ("SOMEDAY" "TO-READ" "CHECK" "TO-WATCH" "WATCHING")
            ;; Show this group at the end of the agenda (since it has the
            ;; highest number). If you specified this group last, items
            ;; with these todo keywords that e.g. have priority A would be
            ;; displayed in that group instead, because items are grouped
            ;; out in the order the groups are listed.
            :order 9)
           (:priority<= "B"
            ;; Show this section after "Today" and "Important", because
            ;; their order is unspecified, defaulting to 0. Sections
            ;; are displayed lowest-number-first.
            :order 1)
           ;; After the last group, the agenda will display items that didn't
           ;; match any of these groups, with the default order position of 99
           )))
    (org-agenda nil "a"))
  :config
  (org-super-agenda-mode)
  )

;; set bash to default shell of vterm
(use-package! vterm
  :config
  (setq vterm-shell "bash"))

(use-package! rime
  :config
  (setq rime-show-candidate 'posframe)
  :custom
  (default-input-method "rime")
  )

;; keybinds
(map! :desc "lsp-clangd-find-other-file" :n "g h" #'lsp-clangd-find-other-file)

; roslaunch world sdf urdf highlighting
(add-to-list 'auto-mode-alist '("\\.launch$" . xml-mode))
(add-to-list 'auto-mode-alist '("\\.world$" . xml-mode))
(add-to-list 'auto-mode-alist '("\\.sdf$" . xml-mode))
(add-to-list 'auto-mode-alist '("\\.urdf$" . xml-mode))

;; (defadvice evil-inner-word (around underscore-as-word activate)
;;   (let ((table (copy-syntax-table (syntax-table))))
;;     (modify-syntax-entry ?_ "w" table)
;;     (with-syntax-table table
;;       ad-do-it)))
;;
;; (with-eval-after-load 'evil
;; (defalias #'forward-evil-word #'forward-evil-symbol))
;;
(modify-syntax-entry ?_ "w")
(modify-syntax-entry ?- "w")
;; (defalias 'forward-evil-word 'forward-evil-symbol)
(define-key evil-outer-text-objects-map "w" 'evil-a-symbol)
(define-key evil-inner-text-objects-map "w" 'evil-inner-symbol)
(define-key evil-outer-text-objects-map "o" 'evil-a-word)
(define-key evil-inner-text-objects-map "o" 'evil-inner-word)

(setq lsp-ui-doc-show-with-cursor 'nil)
