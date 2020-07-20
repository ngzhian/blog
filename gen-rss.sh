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

function generate_xml() {
  while IFS= read -r line; do
    href=$(echo "$line" | cut -f 3)
    mdown=${href/.html/.mdown}
    fullhref=https://blog.ngzhian.com/$href
    pandoc \
      --template template/item.xml \
      -f markdown \
      -V link="$fullhref" \
      -V guid="$fullhref" \
      "posts/$mdown" \
        >> rss.xml
  done
}


cat template/pre.xml > rss.xml
all_posts | generate_xml
cat template/post.xml >> rss.xml
