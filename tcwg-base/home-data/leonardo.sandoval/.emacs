;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - " (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
;(setq require-final-newline 'query)

(global-set-key [f3] `auto-revert-mode)
(global-set-key [f4] `auto-revert-tail-mode)
(global-set-key [f5] 'goto-line)
(global-set-key [f6] 'next-multiframe-window)
(global-set-key "\M-p" `grep-find)
(global-set-key "\M-g" 'goto-line)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-compression-mode t nil (jka-compr))
 '(blink-cursor-mode nil)
 '(case-fold-search t)
 '(current-language-environment "UTF-8")
 '(default-frame-alist (quote ((width . 80) (height . 70))))
 '(default-input-method "rfc1345")
 '(global-font-lock-mode t nil (font-lock))
 '(inhibit-startup-screen t)
 '(initial-frame-alist (quote ((width . 80) (height . 70))))
 '(show-paren-mode t nil (paren))
 '(tool-bar-mode nil)
 '(menu-bar-mode nil))

(defun my-java-mode-hook ()
  (setq c-basic-offset 4)
  (setq tab-width 4))
(add-hook 'java-mode-hook 'my-java-mode-hook)
(add-hook 'c-mode-hook (which-func-mode))

(setq-default header-line-format '(which-func-mode which-func-format))

(add-to-list 'load-path "~/share/emacs/site-lisp")
;(require 'git)
;(require 'git-blame)

(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
	 (column (c-langelem-2nd-pos c-syntactic-element))
	 (offset (- (1+ column) anchor))
	 (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(add-hook 'c-mode-common-hook
          (lambda ()
            ;; Add kernel style
            (c-add-style
             "linux-tabs-only"
             '("linux" (c-offsets-alist
                        (arglist-cont-nonempty
                         c-lineup-gcc-asm-reg
                         c-lineup-arglist-tabs-only))))))

(add-hook 'c-mode-hook
          (lambda ()
            (let ((filename (buffer-file-name)))
              ;; Enable kernel mode for the appropriate files
              (when (and filename
                         (string-match (expand-file-name "/scratch/lsandov1/cf/src/linux-2.6.git")
                                       filename))
                (setq indent-tabs-mode t)
                (c-set-style "linux-tabs-only")))))

(normal-erase-is-backspace-mode 1)
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 90 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))
;;(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
;; '(default ((t (:inherit nil :stipple nil :background "#ffffff" :foreground "#1a1a1a" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 116 :width normal :foundry "bitstream" :family "Courier 10 Pitch")))))

(setq grep-find-command "find . -type f -a ! '(' -name 'ChangeLog*' ')' -print0 | \"xargs\" -0 -e grep -nH -e ")

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
(add-hook 'yaml-mode-hook
	  '(lambda ()
	     (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
