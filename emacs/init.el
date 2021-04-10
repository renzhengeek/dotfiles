(require 'package)
(setq package-archives '(("gnu" . "http://mirrors.ustc.edu.cn/elpa/gnu/")
			 ("melpa" . "http://mirrors.ustc.edu.cn/elpa/melpa/")))

;; Initialize packages
(package-initialize)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(setenv "GOPATH" "/nvme1/go")

;;; edit setting
(setq-default tab-width 4)
(defvaralias 'c-basic-offset 'tab-width)


;(when (version<= "26.0.50" emacs-version )
;   (global-display-line-numbers-mode))
(global-linum-mode 1)

;;; Compare windows
(global-set-key "\C-cw" 'compare-windows)

(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))

;;;; GO Mode
(require 'go-mode)
(setq exec-path (append exec-path '("/nvme1/go/bin")))

;;; LSP
(require 'project)

(defun project-find-go-module (dir)
  (when-let ((root (locate-dominating-file dir "go.mod")))
    (cons 'go-module root)))

(cl-defmethod project-root ((project (head go-module)))
  (cdr project))

(add-hook 'project-find-functions #'project-find-go-module)

;; Company mode
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 1)
(add-hook 'go-mode-hook (lambda ()
                          (set (make-local-variable 'company-backends) '(company-go))
                          (company-mode)))
;;;; GO Mode END

;; Optional: load other packages before eglot to enable eglot integrations.
(require 'company)
(require 'yasnippet)
(require 'eglot)
(add-hook 'go-mode-hook 'eglot-ensure)

;; Optional: install eglot-format-buffer as a save hook.
;; The depth of -10 places this before eglot's willSave notification,
;; so that that notification reports the actual contents that will be saved.
(defun eglot-format-buffer-on-save ()
  (add-hook 'before-save-hook #'eglot-format-buffer -10 t))
(add-hook 'go-mode-hook #'eglot-format-buffer-on-save)

(setq-default eglot-workspace-configuration
    '((:gopls .
        ((staticcheck . t)
         (matcher . "CaseSensitive")))))

(define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
(define-key eglot-mode-map (kbd "C-c o") 'eglot-code-action-organize-imports)
(define-key eglot-mode-map (kbd "C-c h") 'eldoc)
(define-key eglot-mode-map (kbd "<f6>") 'xref-find-definitions)

; end of eglot

;;;; RUST

; Set path to racer binary
(setq racer-cmd "~/.cargo/bin/racer")

 ;Set path to rust src directory
(setq racer-rust-src-path "/home/renzhen.rz/.rustup/toolchains/1.46.0-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src/")

;Load rust-mode when you open `.rs` files
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))

; Setting up configurations when you load rust-mode
(add-hook 'rust-mode-hook
	'(lambda ()
	;; Enable racer
	(racer-activate)

	;; Hook in racer with eldoc to provide documentation
	(racer-turn-on-eldoc)

	;; Use flycheck-rust in rust-mode
	(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

	;; Key binding to jump to method definition
	(local-set-key (kbd "M-.") #'racer-find-definition)))

(setq rust-format-on-save t)

(add-hook 'rust-mode-hook 'eglot-ensure)
;;;; RUST END

;;;; C/C++
;; install ccls
; https://snapcraft.io/install/ccls/centos
; sudo ln -s /snap/ccls/80/bin/ccls /usr/local/bin/ccls
(add-hook 'c-mode-hook 'eglot-ensure)
;;;; C/C++ END

;;;; windows
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

;;;; display
(setq-default cursor-type 'bar)

(add-hook 'dired-mode-hook
          (lambda ()
            ;; TODO: handle (DIRECTORY FILE ...) list value for dired-directory
            (setq mode-line-buffer-identification
                  ;; emulate "%17b" (see dired-mode):
                  '(:eval
                    (propertized-buffer-identification
                     (if (< (length default-directory) 17)
                         (concat default-directory
                                 (make-string (- 17 (length default-directory))
                                              ?\s))
                       default-directory))))))

;;;; custom functions
(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))


;;;; Variables setting
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(projectile project-root ccls company-go eglot yasnippet rust-mode go-mode flycheck-rust exec-path-from-shell)))

 (setq max-specpdl-size 13000)
 (setq max-lisp-eval-depth 13000)

;;;; Debug
;(setq debug-on-error t)    ; now you should get a backtrace

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
