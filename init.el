(add-hook 'emacs-startup-hook
	  (lambda ()
	    (message "*** Emacs loaded in %s with %d garbage collections."
		     (format "%.2f seconds"
			     (float-time
			      (time-subtract after-init-time before-init-time)))
		     gcs-done)))

(setq inhibit-startup-message t
      gc-cons-threshold (* 100 1024 1024) ; 100mb
      gc-cons-percentage 0.1
      tramp-default-method "ssh"
      ring-bell-function #'ignore
      visible-bell nil
      ibuffer-expert t
      ibuffer-show-empty-filter-groups nil)

(setq-default delete-by-moving-to-trash t
	      fill-column 80)

(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(global-set-key (kbd "<escape>") #'keyboard-escape-quit)
(global-set-key (kbd "s-a") #'mark-whole-buffer)
(global-set-key (kbd "s-s") #'save-buffer)
(global-set-key (kbd "s-S") #'write-file)
(global-set-key (kbd "s-q") #'save-buffers-kill-emacs)
(global-set-key (kbd "s-k") #'kill-this-buffer)
(global-set-key (kbd "s-v") #'yank)
(global-set-key (kbd "s-c") #'kill-ring-save)
(global-set-key (kbd "s-w") #'delete-window)
(global-set-key (kbd "s-z") #'undo)
(global-set-key (kbd "s-<backspace>") #'kill-whole-line)
(global-set-key (kbd "C-x C-b") #'ibuffer)
(global-set-key (kbd "s-o") #'find-file)
(global-set-key (kbd "s-p") #'project-find-file)
(global-set-key (kbd "s-f") #'isearch-forward)
(global-set-key (kbd "s-b") #'switch-to-buffer)

(add-hook 'prog-mode-hook #'show-paren-mode)
(add-hook 'emacs-startup-hook #'recentf-mode)
(add-hook 'emacs-startup-hook #'savehist-mode)
(add-hook 'emacs-startup-hook #'save-place-mode)

(custom-set-variables
 '(recentf-max-saved-items 200)
 '(dired-auto-revert-buffer t)
 '(dired-dwim-target t)
 '(dired-recursive-copies 'always)
 '(dired-recursive-deletes 'always)
 '(savehist-file "~/emacs.d/savehist")
 '(savehist-save-minibuffer-history t)
 '(savehist-additional-variables '(kill-ring
				   mark-ring
				   global-mark-ring
				   search-ring
				   regexp-search-ring))
 '(history-length 20000))

(when (eq system-type 'darwin)
  (setq mac-command-modifier 'super
	mac-option-modifier 'meta
	insert-directory-program "gls")
  (custom-set-variables
   '(find-ls-option '("-print0 | xargs -0 ls -ld" . "-ld"))))

;;; Package manager

(setq straight-build-dir (format "build-%s" emacs-version)
      straight-check-for-modifications '(check-on-save find-when-checking))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;; Third party packages

(straight-use-package 'orderless)
(straight-use-package 'selectrum)
(straight-use-package 'rg)
(straight-use-package 'magit)
(straight-use-package 'clojure-mode)
(straight-use-package 'cider)
(straight-use-package 'org)

(add-hook 'emacs-startup-hook #'selectrum-mode)

(setq clojure-indent-style 'align-arguments
      clojure-align-forms-automatically t
      orderless-skip-highlighting (lambda () selectrum-is-active)
      selectrum-highlight-candidates-function #'orderless-highlight-matches)

(custom-set-variables
 '(completion-styles '(orderless))
 '(magit-diff-refine-hunk 'all)
 '(magit-display-buffer-function
   #'magit-display-buffer-same-window-except-diff-v1)
 '(cljr-magic-requires nil)
 '(cider-repl-display-help-banner nil)
 '(cider-repl-display-in-current-window nil)
 '(cider-repl-pop-to-buffer-on-connect nil)
 '(cider-repl-use-pretty-printing t)
 '(cider-repl-buffer-size-limit 100000))

(global-set-key (kbd "s-F") #'rg)
(global-set-key (kbd "s-g") #'magit-status)