;====================================
;; define
;====================================
(defvar viper-mode t
  "viper(vimpulse)をデフォルトで有効/無効")
(defvar my-viper-toggle-key [M-delete]
  "viper-mode 切替キー")
(define-key global-map my-viper-toggle-key 'toggle-viper-mode)

;------------------------------------
;; turn on
;------------------------------------
;; (add-to-list 'load-path "~/.emacs.d/lisp/vimpulse")
(defvar vimpulse-startup viper-mode)
(setq viper-mode t)
(require 'vimpulse)
(setq viper-mode vimpulse-startup)
(unless viper-mode
  (toggle-viper-mode))

;------------------------------------
;; 以降に設定を追加して下さい
;------------------------------------

(provide 'my-vimpulse)

;------------------------------------
;; defadvice
;------------------------------------
;; Vimpulse/viper-mode起動時に呼び出される
;; (defadvice viper-mode (after my-viper-mode activate)
;;   (setq viper-shift-width tab-width))

;; Vimpulse/viper-mode終了時に呼び出される
(defadvice viper-go-away (after my-viper-go-away activate)
  (message "Exit viper"))

