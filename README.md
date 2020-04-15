# column-skip.el ![](https://github.com/syohex/emacs-column-skip/workflows/CI/badge.svg)

Emacs port of Vim extension [columnskip.vim](https://github.com/tyru/columnskip.vim)

## Image

![screencast](image/column-skip.gif)

## Commands

### `M-x column-skip-forward`

Forward line to same column line

### `M-x column-skip-backward`

Backward line to same column line

## Sample Configuration

```lisp
(global-set-key (kbd "C-x n") #'column-skip-forward)
(global-set-key (kbd "C-x p") #'column-skip-backward)
```
