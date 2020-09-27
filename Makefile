# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = source
BUILDDIR      = build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

deploy: sphinx-build run-static-build

run-static-build:
	@git branch -D static-build
	@git checkout -b static-build
	@mv build/html/* .
	@touch .nojekyll
	@git add -A
	@git commit -m 'New static build'
	@git push -f origin static-build
	@git checkout master

sphinx-build:
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

clean:
	@rm -rf build

serve: clean sphinx-build
	@echo "================================================================================"
	@echo "================================================================================"
	@echo "================================================================================"
	@echo
	@echo "                 Serving your docs at http://localhost:8787"
	@echo
	@echo "================================================================================"
	@echo "================================================================================"
	@echo "================================================================================"
	@python -m http.server --directory build/html 8787

.PHONY: \
	help\
	Makefile\
	clean\
	run-static-build\
	deploy\
	sphinx-build\
	serve

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
