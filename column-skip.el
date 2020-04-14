;;; column-skip.el --- emacs port of columnskip.vim -*- lexical-binding: t; -*-

;; Copyright (C) 2020 by Shohei YOSHIDA

;; Author: Shohei YOSHIDA <syohex@gmail.com>
;; URL: https://github.com/syohex/emacs-column-skip
;; Version: 0.01
;; Package-Requires: ((emacs "26.3"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Emacs port of columnskip.vim(https://github.com/tyru/columnskip.vim)

;;; Code:

(defun column-skip--current-column ()
  (save-excursion
    (back-to-indentation)
    (current-column)))

;;;###autoload
(defun column-skip-forward (arg)
  (interactive "p")
  (let ((column (column-skip--current-column))
        (step (if (>= arg 0) +1 -1)))
    (dotimes (_ (abs arg))
      (forward-line step)
      (while (and (not (eobp)) (/= column (column-skip--current-column)))
        (forward-line step)))
    (move-to-column column)))

;;;###autoload
(defun column-skip-backward (arg)
  (interactive "p")
  (column-skip-forward (- arg)))

(provide 'column-skip)

;;; column-skip.el ends here
