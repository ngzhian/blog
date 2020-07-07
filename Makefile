default: all

.PHONY: deploy pages minify-css watch

# https://cssminifier.com/curl
minify-css:
	@curl -X POST -s --data-urlencode 'input@styles.css' https://cssminifier.com/raw > styles.css

%.html: posts/%.mdown
	pandoc --from markdown --template template/custom -o $*.html $<

srcfiles := $(shell ls posts/*.mdown)
destfiles := $(patsubst posts/%.mdown,%.html,$(srcfiles))
pages: $(destfiles)

all: pages
	./gen-index.sh

clean:
	rm -f *.html

deploy:
	git push origin HEAD
	git checkout gh-pages
	git rebase master
	git push origin HEAD
	git checkout master

watch:
	fswatch -or template/ posts/ | xargs -o -n 1 -I {} make

# heredoc doesn't work in Makefiles
posts/%.mdown:
	@touch posts/$*.mdown
	@echo '---' >> posts/$*.mdown
	@echo 'title:' >> posts/$*.mdown
	echo "date: $$(date '+%Y-%m-%d')" >> posts/$*.mdown
	@echo '...' >> posts/$*.mdown

%.mdown: posts/$*.mdown
