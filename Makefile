default: all

.PHONY: deploy

all:
	ocs

deploy:
	git checkout gh-pages
	git rebase master
	git push origin HEAD
	git checkout master
