;; init-hideshow.el -- initialize the hs minor mode

;; Mike Barker <mike@thebarkers.com>
;; November 19, 2012

;; Copyright (c) 2012 Mike Barker

;; Change log:
;; 2012.11.19
;; * First release.

;; 2014-02-27 MRB
;; * Added initialization message
;; * Some reformatting of the code.

;;; setup selective display for hiding
(message "init-hideshow -- Initialize the hideshow minor mode...")

(defun toggle-selective-display (column)
      (interactive "P")
      (set-selective-display
       (or column
           (unless selective-display
             (1+ (current-column))))))

(defun toggle-hiding (column)
      (interactive "P")
      (if hs-minor-mode
          (if (condition-case nil
                  (hs-toggle-hiding)
                (error t))
              (hs-show-all))
        (toggle-selective-display column)))

;;; global keymaps for toggling hiding
(global-set-key (kbd "C-+") 'toggle-hiding)
(global-set-key (kbd "C-=") 'toggle-selective-display)

;;; handle hidding html and nxml documents
(defun my-nxml-forward-sexp-func (pos)
  (my-nxml-forward-element))

(defun my-nxml-forward-element ()
  (let ((nxml-sexp-element-flag)
  	(outline-regexp "\\s *<\\([h][1-6]\\|html\\|body\\|head\\)\\b"))
    (setq nxml-sexp-element-flag (not (looking-at "<!--")))
    (unless (looking-at outline-regexp)
      (condition-case nil
  	  (nxml-forward-balanced-item 1)
  	(error nil)))))

;;; nxml-mode config to hide/show blocks
(add-to-list 'hs-special-modes-alist
	     '(nxml-mode
	       "<!--\\|<[^/>]>\\|<[^/][^>]*[^/]>"
	       ""
	       "<!--"                        ;; won't work on its own; uses syntax table
	       my-nxml-forward-sexp-func
	       nil                           ;; my-nxml-hs-adjust-beg-func
	       ))

;;; html-mode config to hide/show blocks
(add-to-list 'hs-special-modes-alist
	     '(html-mode
	       "<!--\\|<[^/>]>\\|<[^/][^>]*"
	       "</\\|-->"
	       "<!--"
	       sgml-skip-tag-forward
	       nil))

;;; hook into the following major modes
(add-hook 'c-mode-common-hook   'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook       'hs-minor-mode)
(add-hook 'lisp-mode-hook       'hs-minor-mode)
(add-hook 'perl-mode-hook       'hs-minor-mode)
(add-hook 'sh-mode-hook         'hs-minor-mode)
(add-hook 'nxml-mode-hook       'hs-minor-mode)
(add-hook 'html-mode-hook       'hs-minor-mode)

(provide 'init-hideshow)
