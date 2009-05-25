;;; smart-tab.el --- Intelligently expand or indent for tab.

;; Copyright (C) 2008 Sebastien Rocca Serra

;; Description: Intelligently expand or indent for tab.
;; Author: Sebastien Rocca Serra <sroccaserra@gmail.com>
;; Maintainer: Daniel Hackney <dan@haxney.org>
;; Keywords: convenience abbrev
;; Homepage: http://www.emacswiki.org/emacs/TabCompletion
;; Version: 0.1

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:
;;
;; From http://www.emacswiki.org/cgi-bin/wiki/TabCompletion#toc2. There are a
;; number of available customizations on that page.
;;
;; To activate, add:
;;     (require 'smart-tab)
;;     (global-set-key [(tab)] 'smart-tab)
;;
;; to your .emacs file.

;;; Code:

(defcustom smart-tab-using-hippie-expand nil
  "Turn this on if you want to use `hippie-expand' for
completion."
  :type '(choice
          (const :tag "hippie-expand" t)
          (const :tag "dabbrev-expand" nil)))

;;;###autoload
(defun smart-tab (prefix)
  "Needs `transient-mark-mode' to be on. This smart tab is
minibuffer compliant: it acts as usual in the minibuffer.

In all other buffers: if PREFIX is \\[universal-argument], calls
`smart-indent'. Else if point is at the end of a symbol,
expands it. Else calls `smart-indent'."
  (interactive "P")
  (if (minibufferp)
      ;; If completing with ido, need to use `ido-complete' to continue
      ;; completing, not `minibuffer-complete'
      (if (and (functionp 'ido-active)
               (ido-active))
          (ido-complete)
        (minibuffer-complete))
    (if (smart-tab-must-expand prefix)
        (if smart-tab-using-hippie-expand
            (hippie-expand nil)
          (dabbrev-expand nil))
      (smart-indent))))

(defun smart-indent ()
  "Indents region if mark is active, or current line otherwise."
  (interactive)
  (if mark-active
      (indent-region (region-beginning)
                     (region-end))
    (indent-for-tab-command)))

(defun smart-tab-must-expand (&optional prefix)
  "If PREFIX is \\[universal-argument], answers no.
Otherwise, analyses point position and answers."
  (unless (or (consp prefix)
              mark-active)
    (looking-at "\\_>")))

(provide 'smart-tab)

;;; smart-tab.el ends here
