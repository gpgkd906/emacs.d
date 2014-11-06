(defun js-key-set () 
  ;;define the templates which we will use it a litte later.... 
  (setq var-template (mapconcat 'identity '(
			       "/**"
			       " * @member "
			       " * @property %s"
			       " * @type {}"
			       " * @private"
			       " * @since"
			       " * "
			       " */"
			       "%s") "\n"))
  (setq function-template (mapconcat 'identity '(
						 "/**"
						 " * @method %s"
						 " * @private"
						 " * @since"
						 " * "
						 " * @param {} "
						 " * "
						 " * @return {} "
						 " */"
						 "%s"
						 ) "\n"))
  (setq module-template (mapconcat 'identity '(
"/**"
" * @singleton"
" * @aside guide %s"
" * @author Copyright (c) %s %s. All rights reserved"
" *"
" * @description"
" *"
" * ## Examples"
" * ###"
" * @example"
" */"
"(function (root, factory) {"
"    'use strict';"
"    if (typeof exports === 'object') {"
"        factory(exports);"
"    } else if (typeof define === 'function' && define.amd) {"
"        define(['exports'], factory);"
"    } else {"
"        factory(root);"
"    }"
"} (this, function (exports) {"
"    'use strict';"
"    //IE7/8 polyfill start|ここからはIE7/8互換処理実装"
"    if(Function.prototype.bind) {"
"        var bind = function (func, scope) {"
"            return func.bind(scope);"
"        }"
"    } else {"
"        var bind = function (func, scope) {"
"            return func;"
"        };"
"    }"
"    if (!Object.create) {"
"	Object.create = (function(){"
"            var polyfill = function Polyfill () {};"
"            return function(prototype, properties){"
"		if(typeof prototype !== 'object') {"
"		    prototype = {};"
"		}"
"		if(typeof properties === 'object') {"
"		    for(var key in properties) {"
"			prototype[key] = properties[key].value;"
"		    }"
"		}"
"		polyfill.prototype = prototype;"
"		return new polyfill();"
"            }"
"	})()"
"    }"
"    //ここまではIE7/8互換処理"
""
"    //ここからはモジュール/クラスの定義"
"    var %s = function %s () {"
"	//コンストラクター"
"    };"
"    //スタティックメソッドをモジュールに直接定義する、インスタンスせずにアクセスできる"
"    %s.staticMethod = function () {"
"	console.log('このようにスタティックメソッドを定義する');"
"    };"
"    %s['new'] = function () {"
"	return new this;"
"    }"
"    //インスタンスメソッドをpropertiesで定義する"
"    var properties = {"
"	instanceMethod: {"
"	    value: function () {"
"		console.log('[メソッド名.value]：このようにインスタンスメソッドを定義する');"
"	    }"
"	},"
"	toString: {"
"	    value: bind(function toString () {"
"		return '[object %s]';"
"	    }, %s)"
"	}"
"    };"
"    try {"
"	Object.defineProperty(%s, 'prototype', {"
"	    value: Object.create(%s.prototype, properties),"
"	    writable: false,"
"	    enumerable: false,"
"	    configurable: false"
"	});"
"    } catch (e) {"
"	//ここもie7/8互換実装"
"	%s.prototype = Object.create(%s.prototype, properties);"
"    }"
"    exports.%s = %s;"
"    return %s;"
"}));"
) "\n"))
  ;;set key-set from here
  (global-set-key (kbd "ESC <C-return>") 
		  (lambda ()
		    (interactive)
		    (setq object-name (read-string "input object name :"))
		    (insert (format 
			     (mapconcat 'identity '("for (var property in %s) {"
						    "    if (%s.hasOwnProperty(property)) {"
						    "        if (typeof %s[property] === 'function') {"
						    "            console.log(property, ':', %s[property]);"
						    "        }"
						    "    }"
						    "}") "\n")
			     object-name object-name object-name object-name))
		    ))
  (global-set-key (kbd "M-RET") 
		  (lambda ()
		    (interactive)
		    (setq objects (read-string "input objects :"))
		    (insert (format "\nconsole.log(%s)\n" objects))
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
		    (setq func-define (format (mapconcat 'identity '(
								     "%s: function() {"
								     ""
								     "}") "\n") func-name))
		    (insert (format function-template func-name func-define))
		    ))
  (global-set-key (kbd "C-: C-;") 
		  (lambda ()
		    (interactive)
		    (setq name (read-string "module define, Input module name :"))
		    (insert (format module-template name (format-time-string "%Y") user-full-name name (upcase-initials name) name name (upcase-initials name) name name name name name (upcase-initials name) name name))
		    ))
  (global-set-key (kbd "C-: TAB") 
		  (lambda ()
		    (interactive)
		    (let ((inputed-tuple (split-string (read-string "insert for (v[ar]/f[unc]/m[odule])[:name]? ") ":")))
		      (setq mode (car inputed-tuple))
		      (setq name (cadr inputed-tuple))
		      (cond ((null mode)
			     (message "nothing inputed!"))
			    ((equal mode "v")
			     (insert (format var-template name "")))
			    ((equal mode "f")
			     (insert (format function-template name "")))
			    ((equal mode "m")
			     (insert (format module-template name (format-time-string "%Y") user-full-name name (upcase-initials name) name name (upcase-initials name) name name name name name (upcase-initials name) name name)))
			    (t nil)
			    ))))
  )