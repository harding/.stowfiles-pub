(require 'package)
(push '("marmalade" . "http://marmalade-repo.org/packages/")
      package-archives )
(push '("melpa" . "http://melpa.milkbox.net/packages/")
      package-archives)
(package-initialize)

(require 'evil)
(evil-mode 1)

;; Auto-wrap lines
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Change bell from audible to visible
(setq visible-bell 1)

;; Org mode
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cb" 'org-iswitchb)
(setq org-log-done t)
(setq org-default-notes-file (concat org-directory "/notes.org"))
(define-key global-map "\C-cc" 'org-capture)
;; Don't allow completing parent tasks until all child tasks are complete
(setq org-enforce-todo-dependencies t)
;; Track the time TODO tasks are completed
(setq org-log-done 'time)
;; Keep closing time stamp even if cycled back to non-TODO
(setq org-closed-keep-when-no-todo t)
;; Enable org-habits
(add-to-list 'org-modules 'org-habit t)
;; Include the emacs diary in orgmode agenda
(setq org-agenda-include-diary t)
;; Allow refiling among all agenda files
(setq org-refile-targets
      '((nil :maxlevel . 3)
        (org-agenda-files :maxlevel . 3)))
;; Use path style for refile, e.g. notes/habits/foo
(setq org-refileuse-outline-path t)
;; Dont't show future items in the todo list. This is very useful for
;; habits which would otherwise always show up even if you've done
;; them today
(setq org-agenda-todo-ignore-scheduled 'future)
;; TODO states
(setq org-todo-keywords
      '((sequence "TODO" "FEEDBACK" "VERIFY" "|" "DONE" "DELEGATED")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(org-agenda-files (quote ("~/org/")))
 '(org-log-into-drawer t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
