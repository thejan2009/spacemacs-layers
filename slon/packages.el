;;; packages.el --- slon layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author:  <js@planica>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst slon-packages
  '(
    (php-doc :location local)
    eldoc
    flycheck
    ggtags
    helm-gtags
    php-auto-yasnippets
    (php-extras :location (recipe :fetcher github :repo "arnested/php-extras"))
    php-mode
    (company-php :requires company)
    ;; phpunit
    )
  "The list of Lisp packages required by the slon layer.")

(defun slon/post-init-eldoc ()
  (add-hook 'php-mode-hook 'eldoc-mode))

(defun slon/post-init-flycheck ()
  (setq flycheck-phpcs-standard "PSR2")
  (spacemacs/enable-flycheck 'php-mode))

(defun slon/post-init-ggtags ()
  (add-hook 'php-mode-local-vars-hook #'spacemacs/ggtags-mode-enable))

(defun slon/post-init-helm-gtags ()
  (spacemacs/helm-gtags-define-keys-for-mode 'php-mode))

(defun slon/init-php-auto-yasnippets ()
  (use-package php-auto-yasnippets
    :defer t))

(defun slon/init-php-extras ()
  (use-package php-extras
    :defer t))

(defun slon/init-php-mode ()
  (use-package php-mode
    :defer t
    :mode ("\\.php\\'" . php-mode)
    :config
    (progn
      (defun php-cs-fixer ()
        (interactive)
        (call-process-shell-command
         (format
          "php-cs-fixer --rules=@PSR2 --using-cache=false fix %s"
          ;; "php-cs-fixer --config=\"/path/to/.php-cs.dist\" fix %s"
          (buffer-file-name))))
      (spacemacs/declare-prefix-for-mode 'php-mode "mh" "help")
      (spacemacs/declare-prefix-for-mode 'php-mode "mi" "insert")

      (spacemacs/set-leader-keys-for-major-mode 'php-mode
        "ic" 'php-current-class
        "in" 'php-current-namespace
        "hh" 'php-search-documentation
        "f"  'php-cs-fixer)
      )))

(defun slon/init-php-doc()
  (use-package php-doc
    :defer t
    :commands (php-insert-doc-block)
    :init
    (progn
      (setq php-insert-doc-access-tag nil
            php-insert-doc-attribute-tags nil
            php-insert-doc-uses-tag nil
            php-insert-doc-author-email nil
            php-insert-doc-author-name nil
            php-insert-doc-copyright-email nil
            php-insert-doc-copyright-name nil
            php-insert-doc-package-tag nil
            php-insert-doc-global-type-alist nil)
      (defun spacemacs/php-doc-insert-doc ()
        (interactive)
        (end-of-line)
        (insert " ")
        (php-insert-doc-block))
      (spacemacs/set-leader-keys-for-major-mode 'php-mode
        "hd" 'spacemacs/php-doc-insert-doc))
    ))

;; (defun slon/init-phpunit ()
;;   (use-package phpunit
;;     :defer t))

(defun slon/init-company-php ()
  (use-package company-php
    :defer t
    :init
    (progn
      (push 'ac-php-find-symbol-at-point spacemacs-jump-handlers-php-mode)
      (add-hook 'php-mode-hook 'ac-php-core-eldoc-setup)
      (spacemacs|add-company-backends
        :modes php-mode
        :backends company-ac-php-backend))))
;;; packages.el ends here
