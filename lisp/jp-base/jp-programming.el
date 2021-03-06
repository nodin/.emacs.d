;;; jp-programming.el --- An awesome elisp package -*- lexical-binding: t; -*-

;; Copyright (C) 2017 Jerry Peng

;; Author: Jerry Peng <pr2jerry@gmail.com>

;;; Commentary:

;;; Code:

(autoload 'smartparens-mode "smartparens")
(autoload 'show-smartparens-mode "smartparens")
(autoload 'company-mode "company")
(autoload 'flycheck-mode "flycheck")
(autoload 'rainbow-delimiters-mode-enable "rainbow-delimiters")

(defvar jp-prog-mode-hook nil
  "A hook to be run on entering a de facto prog mode.")

(defvar jp-prog-mode-hooks
  '(prog-mode-hook
    css-mode-hook
    sgml-mode-hook
    html-mode-hook))

;; Main hook to be run on entering de facto prog modes
(add-hook 'jp-prog-mode-hook
          (lambda ()
            (jp-pairs)
            (jp-show-pairs)
            (jp-completion)
            (jp-errors)
            (jp-whitespace-cleanup)))

;; Attach de facto prog mode hooks after loading init file
(add-hook 'after-init-hook
          (lambda ()
            (dolist (hook jp-prog-mode-hooks)
              (add-hook hook (lambda () (run-hooks 'jp-prog-mode-hook))))))

;;; auto-pairing
(defun jp-pairs ()
  (smartparens-mode t)
  (bind-key "C-M-q" #'sp-indent-defun prog-mode-map))

;;; show pairs
(defun jp-show-pairs ()
  (show-paren-mode nil)
  (setq blink-matching-paren nil)
  (show-smartparens-mode)
  (setq sp-show-pair-delay 0)
  (rainbow-delimiters-mode-enable))

;;; completion
(defun jp-completion ()
  (company-mode t))

;;; error checking
(defun jp-errors ()
  (flycheck-mode))

;;; cleanup whitespace on save
(defun jp-whitespace-cleanup ()
  (add-hook 'before-save-hook 'whitespace-cleanup t t))

;; Delete marked text on typing
(delete-selection-mode t)

;; Soft-wrap lines
;;(global-visual-line-mode t)

;; Don't use tabs for indent; replace tabs with two spaces.
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

;; Better scrolling with mouse wheel/trackpad.
(unless (and (boundp 'mac-mouse-wheel-smooth-scroll) mac-mouse-wheel-smooth-scroll)
  (global-set-key [wheel-down] (lambda () (interactive) (scroll-up-command 1)))
  (global-set-key [wheel-up] (lambda () (interactive) (scroll-down-command 1)))
  (global-set-key [double-wheel-down] (lambda () (interactive) (scroll-up-command 2)))
  (global-set-key [double-wheel-up] (lambda () (interactive) (scroll-down-command 2)))
  (global-set-key [triple-wheel-down] (lambda () (interactive) (scroll-up-command 4)))
  (global-set-key [triple-wheel-up] (lambda () (interactive) (scroll-down-command 4))))

;; Character encodings default to utf-8.
(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;; apply syntax highlighting to all buffers
(global-font-lock-mode t)

;; auto json-mode
(push '("\\.json\\'" . json-mode) auto-mode-alist)

;; Cassandra CQL
(push '("\\.cql\\'" . sql-mode) auto-mode-alist)
(push '("\\.hcql\\'" . sql-mode) auto-mode-alist)

;; 2-space indent for CSS
(setq css-indent-offset 2)

(defvar jp-ediff-last-windows nil)

(defun jp-store-pre-ediff-winconfig ()
  (setq jp-ediff-last-windows (current-window-configuration)))

(defun jp-restore-pre-ediff-winconfig ()
  (set-window-configuration jp-ediff-last-windows))

(add-hook 'ediff-before-setup-hook #'jp-store-pre-ediff-winconfig)
(add-hook 'ediff-quit-hook #'jp-restore-pre-ediff-winconfig)

(provide 'jp-programming)
;;; jp-programming.el ends here
