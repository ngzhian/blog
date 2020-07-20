default: all

.PHONY: deploy pages minify-css watch

# https://cssminifier.com/curl
minify-css:
	@curl -X POST -s --data-urlencode 'input@styles.css' https://cssminifier.com/raw > styles.css

# build ready-to-deploy pages
%.html: posts/%.mdown
	pandoc --from markdown --template template/custom -o $*.html $<

# for each *.mdown in posts/, generate a similarly named *.html.
srcfiles := $(shell ls posts/*.mdown)
destfiles := $(patsubst posts/%.mdown,%.html,$(srcfiles))
pages: $(destfiles)

all: pages
	./gen-index.sh

# Github used to only support publishing from gh-pages branch.
# That has changed, go into settings to switch the source branch to master.
deploy:
	git push origin HEAD

# Create a new post with the Yaml metadata filled in.
# Heredoc doesn't work in Makefiles, so use many echo.
posts/%.mdown:
	@touch posts/$*.mdown
	@echo '---' >> posts/$*.mdown
	@echo 'title:' >> posts/$*.mdown
	@echo "date: $$(date '+%Y-%m-%d')" >> posts/$*.mdown
	@echo '...' >> posts/$*.mdown

# Shortcut for above.
%.mdown: posts/$*.mdown

# Template for dev has JS snippet for hot reload, we don't
# want to ever ship those, so put it in dev/.
# And ignore dev/ in .gitignore.
devdestfiles := $(patsubst posts/%.mdown,dev/%.html,$(srcfiles))
dev-pages: $(devdestfiles)

# Build a single dev html page.
# Note that the template used is "template/custom-dev"
dev/%.html: posts/%.mdown
	pandoc --from markdown --template template/custom-dev -o dev/$*.html $<

# Build hotreload server.
# Yucky absolute paths, but it works on my machine.
hotreload: hotreload.cpp
	@clang++ hotreload.cpp -I ../uWebSockets/src -I ../uWebSockets/uSockets/src -lpthread -std=c++17 -flto -O3 ../uWebSockets/uSockets/*.o -lz -o $@

# Using a script so that I can set a trap on script exit
# and cleanly shut down hotreload server.
dev-watch: hotreload
	@./dev-watch.sh

# This is the old way to watch for changes and automatically rebuild,
# without hotreload. Use dev-watch instead.
deprecated-watch:
	@fswatch -or template/ posts/ | xargs -o -n 1 -I {} make

# From https://github.com/chambln/pandoc-rss/blob/master/pandoc-rss.
rss.xml: template/pre.xml template/post.xml template/item.xml
	@gen-rss.sh
