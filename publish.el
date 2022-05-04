(require 'ox-publish)
(require 'ox-html)


(setq org-publish-project-alist
      `(("pages"
	 :base-directory "."
	 :base-extension "org"
	 :publishing-directory ,(car (last command-line-args-left))
	 :publishing-function org-html-publish-to-html)))

(org-publish-all)
