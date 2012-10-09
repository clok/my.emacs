;; Add emacs paths.
(add-to-list 'load-path "~/.emacs.d/erc")
(add-to-list 'load-path "~/.emacs.d/")

;; Indent with SPACES only, no TABS
(setq indent-tabs-mode nil)

;; Set default tab width to 3
(setq-default tab-width 3)

;; Set font to smaller size
(set-face-attribute 'default nil :height 100)

;; Set shell colors.
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; Bind compile.
(global-set-key "\C-x\C-k" 'compile)

;; Enable syntax hilighting.
(global-font-lock-mode t)

;; Activate the dynamic completion of of names in minibuffer.
(iswitchb-mode 1)
(icomplete-mode 1)

;; "tool" bar? Are you kidding?
(tool-bar-mode -1)
(menu-bar-mode 0)
(scroll-bar-mode -1)

;; Stop this crazy blinking cursor
(blink-cursor-mode -1)

;; Set colors.
(set-background-color "Black")
(set-foreground-color "White")
(set-cursor-color "Red")

;; Put all backup crap in a directory.
(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))

;; Show column- and line-number in the mode line.
(line-number-mode 1)
(column-number-mode 1)

;; Open '.h' files in c++-mode.
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;====================================================================
;; Small Functions
;;====================================================================
(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Collapse all whitespace around the point to one space (C-c w)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-collapse-whitespace () 
  "Reduce all whitespace surrounding point to a single space."
  ;; @@ This seems to be quite buggy at the moment
  (interactive)
  (kill-region (progn (re-search-backward "[^ \t\r\n]") 
							 (forward-char) 
							 (point)) 
					(progn (re-search-forward "[^ \t\r\n]") 
							 (backward-char)
							 (point)))
  (insert-char ?\  1))

(global-set-key "\C-cw" 'my-collapse-whitespace)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Word count function from the O'Rielly GNU Emacs book
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun count-words-buffer ()
  "Count the number of words in the current buffer.;
print a message in the minibuffer with the result."
  (interactive)
  (save-excursion
    (let ((count 0))
      (goto-char (point-min))
      (while (< (point) (point-max))
		  (forward-word 1)
		  (setq count (1+ count)))
      (message "Buffer contains %d words." count))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Stefan Monnier <foo at acm.org>. It is the opposite of fill-paragraph
;;; Takes a multi-line paragraph and makes it into a single line of text
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))
;; You can convert an entire buffer from paragraphs to lines by
;; recording a macro that calls "unfill-paragraph" and moves past
;; the blank-line to the next unfilled paragraph and then executing
;; that macro on the whole buffer (C-u - C-x e).


;; For editing C files in OpenGL minor mode
(add-hook 'c-mode-hook
			 '(lambda ()
				 (cond ((string-match "/\\([Oo]pen\\)?[Gg][Ll]/"
											 (buffer-file-name))
						  (require 'OpenGL)
						  (OpenGL-minor-mode 1)
						  (OpenGL-setup-keys)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PERL Goodies
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Use CPerl Mode
(fset 'perl-mode 'cperl-mode)

;; Turn on highlighting globally
(global-font-lock-mode t)

;; Change prefic for outline commands
(setq outline-minor-mode-prefix "\C-co")

;; Electric Parenths
(setq cperl-electric-parens t)

;; Electric keywords
(setq cperl-electric-keywords t)

;; Set indent value of cont lines to 0
(setq cperl-continued-statement-offset 0)

;; set default indent level to 3
(setq cperl-indent-level 3)

;; set Block indenting for Parens
(custom-set-variables
 '(cperl-indent-parens-as-block t)
 '(cperl-close-paren-offset -3))

;; Adding *.t files to cperl-mode detectiong for Unit Test Files
(add-to-list 'auto-mode-alist '("\\.t$" . cperl-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mod Title bar to add Host name
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq my-hostname (getenv "HOST"))

(setq my-hostname 
      (replace-regexp-in-string "\\(^[[:space:]\n]*\\|[[:space:]\n]*$\\)" "" ;; like perl chomp()
										  (with-output-to-string 
											 (call-process "/bin/hostname" nil standard-output nil))))
(setq my-username (getenv "USERNAME"))
(setq my-username (getenv "USERNAME"))
(setq frame-title-format '("" "%b " my-username "@" my-hostname " v" emacs-version))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Coffee Script Major Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/coffee-mode")
(require 'coffee-mode)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(defun coffee-custom ()
  "coffee-mode-hook"

  ;; CoffeeScript uses two spaces.
  (make-local-variable 'tab-width)
  (set 'tab-width 2)

  ;; If you don't want your compiled files to be wrapped
  (setq coffee-args-compile '("-c" "--bare"))

  ;; Emacs key binding
  (define-key coffee-mode-map [(meta r)] 'coffee-compile-buffer)

  ;; Riding edge.
  (setq coffee-command "~/dev/coffee")

  ;; Compile '.coffee' files on every save
  (and (file-exists-p (buffer-file-name))
       (file-exists-p (coffee-compiled-file-name))
       (coffee-cos-mode t)))

(add-hook 'coffee-mode-hook 'coffee-custom)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; YAML Major Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/yaml-mode")
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

(add-hook 'yaml-mode-hook
			 '(lambda ()
				 (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; protobuf Major Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/protobuf-mode")
(add-to-list 'auto-mode-alist '("\\.proto$" . protobuf-mode))
(require 'protobuf-mode)
(defconst my-protobuf-style
  '((c-basic-offset . 2)
    (indent-tabs-mode . nil)))

(add-hook 'protobuf-mode-hook
			 (lambda () (c-add-style "my-style" my-protobuf-style t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JSON Major Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/json-mode")
(require 'json-mode)
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SCSS Major Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(setq exec-path (cons (expand-file-name "~/.gem/ruby/1.8/bin") exec-path)
(add-to-list 'load-path "~/.emacs.d/scss-mode")
(autoload 'scss-mode "scss-mode")
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))

;; disable Auto Compile because we are using compass
(setq scss-compile-at-save nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LESS Major Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/less-mode")
(require 'less-mode)
(add-to-list 'auto-mode-alist '("\\.less$" . less-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Open and interpret JAVA .class files - THANKS CHRIS!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'file-name-handler-alist '("\\.class$" . javap-handler))

(defun javap-handler (op &rest args)
  "Handle .class files by putting the output of javap in the buffer."
  (cond
   ((eq op 'get-file-buffer)
    (let ((file (car args)))
      (with-current-buffer (create-file-buffer file)
        (call-process "javap" nil (current-buffer) nil "-verbose"
                      "-classpath" (file-name-directory file)
                      (file-name-sans-extension (file-name-nondirectory file)))
        (setq buffer-file-name file)
        (setq buffer-read-only t)
        (set-buffer-modified-p nil)
        (goto-char (point-min))
        (java-mode)
        (current-buffer))))
   ((javap-handler-real op args))))

(defun javap-handler-real (operation args)
  "Run the real handler without the javap handler installed."
  (let ((inhibit-file-name-handlers
         (cons 'javap-handler
               (and (eq inhibit-file-name-operation operation)
                    inhibit-file-name-handlers)))
        (inhibit-file-name-operation operation))
    (apply operation args)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ruby Genfiles open in Ruby Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
