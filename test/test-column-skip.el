;;; test-column-skip.el --- test column-skip.el -*- lexical-binding: t; -*-

;; Copyright (C) 2020 by Shohei YOSHIDA

;; Author: Shohei YOSHIDA <syohex@gmail.com>

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

;;; Code:

(require 'ert)
(require 'column-skip)

(defmacro with-test-temp-buffer (text &rest body)
  "Insert `text' and evaluate `body'. cursor is beginning of buffer"
  (declare (indent 0) (debug t))
  `(with-temp-buffer
     (insert ,text)
     (goto-char (point-min))
     ,@body))

(ert-deftest simple ()
  "forward test"
  (with-test-temp-buffer
    "
def say_hello(name)
   var = \"Hello,\" + name
   return var
end
"
    (forward-line 1)

    (save-excursion
      (column-skip-forward 1)
      (should (= (current-column) 0))
      (should (string= (thing-at-point 'word) "end"))

      (column-skip-backward 1)
      (should (string= (thing-at-point 'word) "def")))

    (save-excursion
      (search-forward "var")
      (column-skip-forward 1)
      (should (string= (thing-at-point 'word) "return"))

      (column-skip-backward 1)
      (should (string= (thing-at-point 'word) "var")))))

(ert-deftest standard ()
  "forward test"
  (with-test-temp-buffer
    "
function! s:column_skip(dir) abort
  let lnum = line('.')
  let width = col('.') <= 1 ? 0 : strdisplaywidth(matchstr(getline(lnum)[: col('.')-2], '^\\s*'))
  while 1 <= lnum && lnum <= line('$')
    let lnum += (a:dir ==# 'j' ? 1 : -1)
    let line = getline(lnum)
    if width >= strdisplaywidth(matchstr(line, '^\\s*')) && line =~# '^\\s*\\S'
      break
    endif
  endwhile
  return abs(line('.') - lnum) . a:dir
endfunction
"
    (forward-line 1)
    (save-excursion
      (search-forward "function!")
      (back-to-indentation)
      (column-skip-forward 1)
      (should (string= (thing-at-point 'word) "endfunction")))

    (save-excursion
      (search-forward "while")
      (back-to-indentation)
      (column-skip-forward 1)
      (should (string= (thing-at-point 'word) "endwhile")))

    (save-excursion
      (search-forward "let")
      (back-to-indentation)
      (column-skip-forward 2)
      (should (string= (thing-at-point 'word) "while")))))

;;; test-column-skip.el ends here
