default: all

.PHONY: deploy pages

%.html: posts/%.mdown
	pandoc $< --template template/custom -o $*.html

srcfiles := $(shell ls posts/*.mdown)
destfiles := $(patsubst posts/%.mdown,%.html,$(srcfiles))
pages: $(destfiles)

all: pages
	ocs -i true

deploy:
	git checkout gh-pages
	git rebase master
	git push origin HEAD
	git checkout master
