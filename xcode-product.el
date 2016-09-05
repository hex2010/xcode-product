;;; xcode-product --- Launch xcode products (build results) from within emacs.

;;; Commentary:

;; This is free and unencumbered software released into the public domain.

;; Anyone is free to copy, modify, publish, use, compile, sell, or
;; distribute this software, either in source code form or as a compiled
;; binary, for any purpose, commercial or non-commercial, and by any
;; means.

;; In jurisdictions that recognize copyright laws, the author or authors
;; of this software dedicate any and all copyright interest in the
;; software to the public domain. We make this dedication for the benefit
;; of the public at large and to the detriment of our heirs and
;; successors. We intend this dedication to be an overt act of
;; relinquishment in perpetuity of all present and future rights to this
;; software under copyright law.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
;; IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
;; OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
;; ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
;; OTHER DEALINGS IN THE SOFTWARE.

;; For more information, please refer to <http://unlicense.org/>

;;; Code:

(require 'ivy)

(defcustom xcode-product-launch-cmd "open \"%s\""
  "Shell command to launch product app."
  :type 'string
  :options '(turn-on-auto-fill)
  :group 'xcode-product)

(defcustom xcode-product-derived-dir "~/Library/Developer/Xcode/DerivedData"
  "DerivedData directory to find products, this variable should should not contains whitespaces."
  :type 'string
  :options '(turn-on-auto-fill)
  :group 'xcode-product)

(defvar xcode-product-launch-history nil
  "History list for xcode-product-launch.")


(defun xcode-product--list ()
  (split-string (shell-command-to-string (concat "find " xcode-product-derived-dir
												 " -name \"*.app\"")) "\n" t))

(defun xcode-product--list-shorthand ()
  (let ((pl (xcode-product--list))
		(ret '()))
	(dolist (x pl ret)
	  (and (string-match (concat ".*/\\([^\\-]+\\).*/Build/Products/\\(Debug\\|Release\\)/\\(.+app\\)") x)
		   (setq ret (append ret (list (concat (match-string 3 x) "|" (match-string 2 x) "|"
											   (match-string 1 x) ))))))))

(defun xcode-product--launch-shorthand (k)
  (let ((v (split-string k "|"))
		(r nil))
	(setq r (concat "/" (nth 2 v)  ".*/Build/Products/" (nth 1 v)   "/"  (nth 0
																								  v)))
	(dolist (x (xcode-product--list))
	  (if (string-match r x)
		  (shell-command (format xcode-product-launch-cmd x))))))


(defun xcode-product-launch ()
  "Launch xcode products."
  (interactive)
  (ivy-read "Launch Product: " (xcode-product--list-shorthand)
			:action (lambda (x)
					  (with-ivy-window (xcode-product--launch-shorthand x)))
			:require-match t
			:caller 'xcode-product-launch
			:history 'xcode-product-launch-history
			:preselect (nth 0 xcode-product-launch-history)))

(provide 'xcode-product)

;;; xcode-product.el ends here
