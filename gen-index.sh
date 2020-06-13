#!/bin/bash
PATH_TO_POSTS=posts


# print list of posts by "$date,$title,$href"
function all_posts() {
  find "$PATH_TO_POSTS" -name '*.mdown' | while read -r p; do
    title=$(grep 'title: ' "$p")
    date=$(grep 'date: ' "$p" | cut -d' ' -f 2)
    href=${p/.mdown/.html}
    printf "%s\t%s\t%s\n" "${date#date: }" "${title#title: }" "${href#posts/}"
  done | sort -r
}

POST_HTML_TEMPLATE='
          <tr>
            <td>
              <span class="published">%s</span>
            </td>
            <td>
              <a class="entry-title" href="%s">
                %s
              </a>
            </td>
          </tr>'

function apply_post_html_template() {
  while IFS= read -r line; do
    title=$(echo "$line" | cut -f 2)
    date=$(echo "$line" | cut -f 1)
    href=$(echo "$line" | cut -f 3)

    printf "$POST_HTML_TEMPLATE" "$date" "$href" "$title"
  done
}

function build_index() {
  cat - > tmptemplate
  # Delete mustache templating from template/index.html
  awk '/{{#posts}}/ { del = 1; print "REPLACE_ME" } { if (del != 1) print } /{{\/posts}}/ { del = 0 }' template/index.html > index.html
  # https://www.grymoire.com/Unix/Sed.html#uh-37
  sed -i '' -e '/REPLACE_ME/ {
    r tmptemplate
    d
  }' index.html
  rm tmptemplate
}

all_posts | apply_post_html_template | build_index
