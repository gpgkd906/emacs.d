(defun php-key-set ()
  (setq var-template (mapconcat 'identity '("/**"
					    " *"
					    " * @api"
					    " * @var "
					    " * @link"
					    " */"
					    "    public $%s = ;"
					    "") "\n"))
  (setq function-template (mapconcat 'identity '("/**"
						 " * "
						 " * @api"
						 " * @param   "
						 " * @param    "
						 " * @return"
						 " * @link"
						 " */"
						 "    public function %s ()"
						 "    {"
						 ""
						 "    }"
						 "") "\n"))
  (setq class-template (mapconcat 'identity '("/**"
					      " * %s"
					      " * [:class description]"
					      " *"
					      " * @author %s %s "
					      " * @package "
					      " * @link "
					      " */"
					      "namespace %s;"
					      ""
					      "class %s %s"
					      "{"
					      ""
					      "}") "\n"))
  (setq package-template (mapconcat 'identity '("/**"
						" * %s"
						" *"
						" * [:package description]"
						" *"
						" * Copyright %s %s"
						" *"
						" * Licensed under The MIT License"
						" *"
						" * @copyright Copyright %s %s"
						" * @link"
						" * @since"
						" * @license http://www.opensource.org/licenses/mit-license.php MIT License"
						" */"
						"") "\n"))
  
  (global-set-key (kbd "ESC <C-return>") 
		  (lambda ()
		    (interactive)
		    (setq objects (read-string "input object or class :"))
		    (insert (format (mapconcat 'identity '(""
							   "echo '<pre>';"
							   "var_dump(get_class_methods(%s));"
							   "echo '</pre>';"
							   "") "\n") objects))
		    ))
  
  (global-set-key (kbd "M-RET") 
		  (lambda ()
		    (interactive)
		    (setq var-name (read-string "input vars :"))
		    (insert (format (mapconcat 'identity '(""
							   "echo '<pre>';"
							   "var_dump(%s);"
							   "echo '</pre>';"
							   "") "\n") var-name))
		    ))

  (global-set-key (kbd "C-: C-p") 
		  (lambda ()
		    (interactive)
		    (setq var-name (read-string "auto generate var define, Input var name :"))
		    (insert (format var-template var-name var-name))
		    ))

  (global-set-key (kbd "C-: C-o") 
		  (lambda ()
		    (interactive)
		    (setq func-name (read-string "auto generate function define, Input function name :"))
		    (insert (format func-template func-name func-name))
		    ))

  (global-set-key (kbd "C-: C-;")
		  (lambda ()
		    (interactive)
		    (setq input (upcase-initials (read-string "class define, Input class name :")))
		    (setq extend (upcase-initials (read-string "input {ParentClassName} if Class extends from AnyClass, or enter else:")))
		    (setq class-tuple (split-string input "\\."))
		    (setq class-name (car (last class-tuple)))
		    (if (equal extend "")
			(setq class-extend "")
		      (setq class-extend (format "extends %s" extend))
		      )
		    (setq class-namespace (replace-regexp-in-string (format ".%s$" class-name) "" input))
		    (insert (format package-template (upcase-initials class-namespace) (format-time-string "%Y") user-full-name (format-time-string "%Y") user-full-name))
		    (insert (format class-template class-name (format-time-string "%Y") user-full-name class-namespace class-name class-extend))
		    ))
  
  (global-set-key (kbd "C-: TAB") 
		  (lambda ()
		    (interactive)
		    (let ((inputed-tuple (split-string (read-string "insert for (v[ar]/f[unc]/c[lass]/p[ackage])[:name]? ") ":")))
		      (setq mode (car inputed-tuple))
		      (setq name (cadr inputed-tuple))
		      (cond ((null mode)
			     (message "nothing inputed!"))
			    ((equal mode "v")
			     (insert (format var-template name name)))
			    ((equal mode "f")
			     (insert (format function-template name name)))
			    ((equal mode "c")
			     (setq name (upcase-initials name))
			     (setq extend (read-string (format "input ParentClassName if Class:[ %s ] extends from Any Parent Class, else enter if not:" name)))
			     (setq class-tuple (split-string name "\\."))
			     (setq class-name (upcase-initials (car (last class-tuple))))
			     (if (equal extend "")
				 (setq class-extend "")
			       (setq class-extend (format "extends %s" extend))
			       )
			     (setq class-namespace (replace-regexp-in-string (format ".%s$" class-name) "" name))
			     (insert (format class-template name (format-time-string "%Y") user-full-name class-namespace class-name class-extend)))
			    ((equal mode "p")
			     (insert (format package-template (upcase-initials name) (format-time-string "%Y") user-full-name (format-time-string "%Y") user-full-name)))
			    (t nil)
			    ))))

  )