;; -*- lexical-binding: t -*-

(define-minor-mode my-mode
 ""
 :global t
 :keymap (make-sparse-keymap)
 :init-value t)

(let (warned)
 (setq warned t)
 (define-key my-mode-map (kbd "C-c") (lambda () (interactive) (if warned (kill-emacs) (progn (setq warned t) (message "WARNING: file modified (once more to quit)") nil))))
 (add-hook 'before-change-functions (lambda (x y) (setq warned nil))))

(define-key my-mode-map (kbd "C-d") 'kill-region)
(define-key my-mode-map (kbd "C-x") 'save-buffer)
(define-key my-mode-map (kbd "C-w") 'backward-kill-word)

(global-set-key (kbd "S-<left>") 'backward-word)
(global-set-key (kbd "S-<right>") 'forward-word)

(global-set-key (kbd "<home>") 'beginning-of-line)
(global-set-key (kbd "<end>") 'end-of-line)

(define-key input-decode-map "\e[1~" [home])
(define-key input-decode-map "\e[4~" [end])

(set-face-background 'region "white")
(set-face-foreground 'region "black")

(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

(define-key my-mode-map (kbd "C-a =") 'agda2-show-constraints)
(define-key my-mode-map (kbd "C-a ?") 'agda2-show-goals)
(define-key my-mode-map (kbd "C-a a") 'agda2-auto-maybe-all)
(define-key my-mode-map (kbd "C-a c") 'agda2-make-case)
(define-key my-mode-map (kbd "C-a e") 'agda2-show-context)
(define-key my-mode-map (kbd "C-a l") 'agda2-load)
(define-key my-mode-map (kbd "C-a r") 'agda2-refine)
(define-key my-mode-map (kbd "C-a s") 'agda2-solve-maybe-all)
(define-key my-mode-map (kbd "C-a t") 'agda2-infer-type)
(define-key my-mode-map (kbd "C-a ,") 'agda2-goal-and-context)
(define-key my-mode-map (kbd "C-a .") 'agda2-goal-and-context-and-inferred)
(define-key my-mode-map (kbd "C-a ;") 'agda2-goal-and-context-and-checked)

(define-key my-mode-map (kbd "M-|") (let ((current-prefix-arg '(4))) 'shell-command-on-region))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(agda2-highlight-level (quote none))
 '(column-number-mode t)
 '(delete-auto-save-files t)
 '(describe-char-unidata-list
   (quote
    (name old-name general-category bidi-class decomposition mirrored uppercase lowercase titlecase)))
 '(electric-indent-mode nil)
 '(font-lock-global-modes nil)
 '(indent-tabs-mode nil)
 '(menu-bar-mode nil)
 '(scroll-error-top-bottom t)
 '(show-paren-mode t)
 '(show-trailing-whitespace t)
 '(tab-width 4)
 '(use-empty-active-region t)
 '(vc-follow-symlinks nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
