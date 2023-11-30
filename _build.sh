#!/usr/bin/env bash

CATEGORY_DIR=$(echo -n "${CATEGORY}" | sed 's| |_|g')
POST_TITLE=$(gh issue view ${NUMBER} | grep "title:" | head -1 | sed 's|^title:||g' | awk '{$1=$1;print}')
POST_LINK=$(echo "${POST_TITLE}" | sed 's| |%20|g')
POST_TITLE_UPPER=$(echo "${POST_TITLE}" | tr '[:lower:]' '[:upper:]')

SITE_TITLE=$(grep "title_prefix:" _config.yml | cut -c 15-)
[ "${SITE_TITLE}" = "" ] && SITE_TITLE="My awesome website"

# If is the first publication we need to build the infrastructure
mkdir -p "posts/${CATEGORY_DIR}/"
mkdir -p "_special"
touch "_recents.txt"

(
  echo "# Posts"
  echo ""
) > _POSTS.md

function build_structure() {
  #---------------------------------------------------------------
  [ ! -f "_special/global_header.md" ] && {
    echo '<p align="right"><a href="/">Home</a> | <a href="/recents">Recents</a> | <a href="/categories">Categories</a></p>' > "_special/global_header.md"
    echo '' >> "_special/global_header.md"
  }
  [ ! -f "_special/global_footer.md" ] && {
    echo -n "" > "_special/global_footer.md" 
  }

  #---------------------------------------------------------------
  [ ! -f "_special/category_header.md" ] && {
    (
      echo "### Category: \${CATEGORY}"
      echo
      echo "| Title |"
      echo "|-------|"
    ) > "_special/category_header.md"
  }
  [ ! -f "_special/category_footer.md" ] && {
    (
      echo
      echo "-----------"
      echo
    ) > "_special/category_footer.md"
  }

  #---------------------------------------------------------------
  [ ! -f "_special/recents_header.md" ] && {
    (
      echo "### Special: Recents"
      echo
      echo "| Title | Category |"
      echo "|-------|----------|"
    ) > "_special/recents_header.md"
  }
  [ ! -f "_special/recents_footer.md" ] && {
    (
      echo
      echo "-----------"
      echo
    ) > "_special/recents_footer.md"
  }
  
  #---------------------------------------------------------------
  [ ! -f "_special/categories-list_header.md" ] && {
    (
      echo "### Special: Categories"
      echo
      echo "| Name | Description |"
      echo "|------|-------------|"
    ) > "_special/categories-list_header.md"
  }
  [ ! -f "_special/categories-list_footer.md" ] && {
    (
      echo
      echo "-----------"
      echo
    ) > "_special/categories-list_footer.md"
  }

  #---------------------------------------------------------------
  [ ! -f "_special/post_header.md" ] && {
    echo -n > "_special/post_header.md"
  }

  [ ! -f "_special/post_footer.md" ] && {
    (
      echo
      echo "-----------"
      echo
    ) > "_special/post_footer.md"
  }

  #---------------------------------------------------------------
  [ ! -f "_204.md" ] && {
    (
      echo "# No content here"
      echo
      echo "There no content on this area yet, [back to home?](/)"
    ) > "_204.md"
  }

  #---------------------------------------------------------------
  [ ! -f "_404.md" ] && {
    (
      echo "# Error: 404 not found"
      echo
      echo "Requested page doesn't exist, [back to home?](/)"
    ) > "_404.md"
  }

  #---------------------------------------------------------------
  [ ! -f "_config.yml" ] && {
    (
      echo "title: null"
      echo "name: \" \""
      echo "---"
      echo "recents_count: 30"
      echo 'title_prefix: My awesome website'
    ) > "_config.yml"
  }

  #---------------------------------------------------------------
  [ ! -f "_index.md" ] && {
    (
      echo "# Welcome to my home page"
      echo 
      echo 'This is my daily book built using [dev-dailybook](https://github.com/natanael-b/dev-dailybook)'
      echo
      echo
    ) > "_index.md"
  }

  [ ! -f "index.md" ] && {
    (
      echo "---"
      echo "title: ${SITE_TITLE}"
      echo "---"
      echo
      cat "_special/global_header.md"
      cat "_index.md"
      cat "_special/global_footer.md"
    ) > "index.md"
  }

  [ ! -f "README.md" ] && {
  echo '
# English

|                                                                                           | What does?                          |
|-------------------------------------------------------------------------------------------|-------------------------------------|
| [🟣 Manage categories](../../labels)                                                     | Allows add or remove categories     |
| [🟢 New post](../../issues/new)                                                          | Create a new post                   |
| [🔴 Manage posts](_POSTS.md)                                                             | Allow remove or edit existing posts |
| [⚙️ Rebuild](../../issues/new?title=build&body=Remember%20to%20add%20a%20label)          | Rebuild all pages                   |
| [🔄 Reset](../../issues/new?title=reset&body=Remember%20to%20add%20a%20label)            | Resets all headers and footers      |

----------------------------------------

> :warning: **Attention**: to remove a post, Rebuild and Restore, do not change the body or title of the Issue and remember to
> assign a Category (`label`), this is what triggers the [`dev-dailybook`](https://github.com/natanael-b/dev-dailybook)
>
> > After editing a post, you need to run the Rebuild

# Português

|                                                                                           | O que isso faz?                           |
|-------------------------------------------------------------------------------------------|-------------------------------------------|
| [🟣 Gerenciar categorias](../../labels)                                                  | Permite adicionar e remover categorias    |
| [🟢 Novo post](../../issues/new)                                                         | Criar um novo post                        |
| [🔴 Gerenciar posts](_POSTS.md)                                                          | Permite editar e remover posts existentes |
| [⚙️ Reconstruir](../../issues/new?title=build&body=Remember%20to%20add%20a%20label)      | Reconstrói todas as páginas               |
| [🔄 Restaurar](../../issues/new?title=reset&body=Remember%20to%20add%20a%20label)        | Restaura os cabeçalhos e rodapés          |

----------------------------------------

> :warning: **Atenção**: para remover um post, Reconstruir e Restaurar, não altere o corpo ou o título da Issue e lembre-se de
> atribuir uma Categoria (`label`), é ela que dispara o [`dev-dailybook`](https://github.com/natanael-b/dev-dailybook)
>
> > Depois de editar um post, você precisa executar o Reconstruir

' > README.md
  }
}

function process_page_marks() {
  while IFS="" read -r line || [ -n "${line}" ]; do
    echo "${line}" | grep -q "^{.*}" && {
      DIR=$(echo "${line}" | sed 's/{//;s/}//' | tr ' ' '_' | tr -d '\r')
      [ -d "posts/${DIR}" ] && {
        echo
        echo "<table>"
        posts=$(ls "posts/${DIR}"/*.md | sed 's|\.md$||g' | sort | tr -d '\r')
        
        while IFS= read -r post; do
          link=$(echo "${post}" | sed 's| |%20|g;s|posts/||g;s|^@||g')
          post=$(basename "${post}")
          echo -n '<tr><td>'
          echo "<a href=\"posts/${link}\">📄 ${post}</a>"
          echo -n '</td></tr>'
        done <<< "${posts}"
        
        echo "</table>"
        echo
        continue;
      }
    }
    printf '%s\n' "${line}"
  done < "${1}"
}

function build_home_page() {
  (
    echo "---"
    echo "title: ${SITE_TITLE}"
    echo "---"
    echo
    cat "_special/global_header.md"
    process_page_marks "_index.md"
    cat "_special/global_footer.md"
  ) > "index.md"
}

function build_recent_page() {
  RECENT_COUNT=$(grep "recents_count:" _config.yml | cut -d ' ' -f2)
  [ "${RECENT_COUNT}" = "" ] && RECENT_COUNT="100"

  # We don't add to recent list private pages
  echo ${CATEGORY_DIR} | grep -q ^"@" || {
    echo "| [📄 ${POST_TITLE}](posts/${CATEGORY_DIR}/${POST_LINK}) | [🔷 ${CATEGORY}](posts/${CATEGORY_DIR}) |" > "__recents.txt"
  }

  cat "_recents.txt" >> "__recents.txt"
  mv "__recents.txt" "_recents.txt"

  [ -s "_recents.txt" ] || {
    (
      cat "_special/global_header.md"
      cat "_204.md"
      cat "_special/global_footer.md"
    ) > "recents.md"
    return
  }

  (
    echo "---"
    echo "title: ${SITE_TITLE}"
    echo "---"
    echo
    cat "_special/global_header.md"
    cat "_special/recents_header.md"
    cat "_recents.txt" | head -n${RECENT_COUNT}
    cat "_special/recents_footer.md"
    cat "_special/global_footer.md"
  ) > "recents.md"
}

function build_post_page() {
  (
    echo "---"
    echo "title: ${SITE_TITLE} - ${POST_TITLE}"
    echo "---"
    echo
    cat "_special/global_header.md"
    cat "_special/post_header.md"
    echo "# ${POST_TITLE}"
    echo
  ) > "posts/${CATEGORY_DIR}/${POST_TITLE}.md"

  process_page_marks "posts/${CATEGORY_DIR}/_${POST_TITLE}.md" >> "posts/${CATEGORY_DIR}/${POST_TITLE}.md"
  
  (
    cat "_special/post_footer.md"
    cat "_special/global_footer.md"
  ) >> "posts/${CATEGORY_DIR}/${POST_TITLE}.md"
}

function build_category_page(){
  for category_dir in posts/*/; do
    category=$(basename "${category_dir}" | tr '_' ' ')
    category_dir=${category_dir::-1}

    # Skipping empty category (build command page)
    
    [ ! -d "${category_dir}" ] && continue;

    (
      echo "### ${category}"
      echo
      echo "| Post |   |   |"
      echo "|------|---|---|"
    ) >> _POSTS.md
    
    (
      echo "---"
      echo "title: ${SITE_TITLE} - ${category}"
      echo "---"
      echo
      cat "_special/global_header.md"
      cat "_special/category_header.md" | sed "s|\${CATEGORY}|${category}|g"
    ) > "${category_dir}.md"

    posts=$(ls "${category_dir}"/*.md | sed 's|\.md$||g' | sort | grep -v "/_")

    while IFS= read -r post; do
      link=$(echo "${post}" | sed 's| |%20|g;s|posts/||g;s|^@||g')
      post=$(basename "${post}")
      echo "| [📄 ${post}](${link}) |" >> "${category_dir}.md"

      edit_link=$(echo "${link}" | sed 's|/|/_|g')

      echo "| ${post} | <a href=\"../../edit/main/posts/${edit_link}.md\">✏️</a> | <a href=\"../../issues/new?title=DELETE&body=${link}\">🗑️</a> |" >> _POSTS.md
    done <<< "${posts}"

    (
      cat "_special/category_footer.md" | sed "s|\${CATEGORY}|${category}|g"
      cat "_special/global_footer.md"
    ) >> "${category_dir}.md"

  done
}

function build_category-list_page() {
  (
    echo "---"
    echo "title: ${SITE_TITLE}"
    echo "---"
    echo
    cat "_special/global_header.md"
    cat "_special/categories-list_header.md"
  ) > categories.md

  labels=$(curl -L \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/${REPO}/labels |
    grep -E '^    "name": |^    "description": '
  )

  name=""
  empty=true
  while IFS= read -r line; do
    echo "${line}" | grep -q '^    "name": ' && name=$(echo "${line}" | cut -d'"' -f4)
    echo "${line}" | grep -q '^    "description": ' && {
      description=$(echo "${line}" | cut -d'"' -f4)
      link=$(echo -n "${name}" | tr ' ' '_')

      # Let's skip pages starting with @
      echo ${link} | grep -q ^"@" || {
        [ -f "posts/${link}.md" ] && {
          echo "| [🔷 ${name}](posts/${link}.md) | ${description} |" >> categories.md
          empty=false
        }
      }
    }
  done <<< "${labels}"

  (
    cat "_special/categories-list_footer.md"
    cat "_special/global_footer.md" 
  ) >> "categories.md"

  [ "${empty}" = "true" ] && {
    (
      cat "_special/global_header.md"
      cat "_204.md"
      cat "_special/global_footer.md"
    ) > "categories.md"
  }
}

function rebuild_all_posts() {
  X_CATEGORY_DIR="${CATEGORY_DIR}"
  X_POST_TITLE="${POST_TITLE}"

  for post in posts/*/_*.md ; do
    POST_TITLE=$(basename -s .md "${post}" | cut -c 2-)
    POST_PATH=$(dirname "${post}")
    CATEGORY_DIR=$(basename "${POST_PATH}")
    build_post_page
  done

  build_home_page
  
  CATEGORY_DIR="${X_CATEGORY_DIR}"
  POST_TITLE="${X_POST_TITLE}"
}

function finalize() {
  echo -n "${POST_TITLE}" > _LAST_POST

  gh issue close "${NUMBER}" || true
  gh issue lock  "${NUMBER}" || true

  exit 0
}

function build_status_pages() {
  (
    echo "---"
    echo "permalink: /404.html"
    echo "---"
    echo
    cat "_special/global_header.md"
    cat "_404.md"
    cat "_special/global_footer.md" 
  ) > "404.md"

  (
    cat "_special/global_header.md"
    cat "_204.md"
    cat "_special/global_footer.md" 
  ) > "204.md"
}

# We need a lot of resources, so build missing is essencial
build_structure
build_status_pages

# We need to clean empty categories
find posts/ -empty -type d -delete

# 
[ "${POST_TITLE_UPPER}" = "SETUP" ] && {
  CATEGORY_DIR="@ignore"
  build_category-list_page
  build_recent_page
  gh issue close "${NUMBER}" || true
  gh issue lock  "${NUMBER}" || true
  echo -n "First setup" > _LAST_POST
  exit 0
}

# Let's check if we are building the home page
[ "${POST_TITLE_UPPER}" = "INDEX" ] && {
  gh issue view "${NUMBER}" | sed '0,/^--$/d' > "_index.md"
  build_home_page
  finalize
}

[ "${POST_TITLE_UPPER}" = "RESET" ] && {
  [ -d "_special" ] && {
    rm -rf _special
  }
  
  build_structure
  POST_TITLE_UPPER="BUILD"
}

# User wants to remove a post
[ "${POST_TITLE_UPPER}" = "DELETE" ] && {
  CATEGORY_DIR="@${CATEGORY_DIR}"
  POST=$(gh issue view "${NUMBER}" | sed '0,/^--$/d' | sed 's|[\r\n]||g' )

  rm "posts/${POST}.md"
  rm "posts/$(echo ${POST} | sed 's|/|/_|g').md"

  grep -v "posts/${POST}" _recents.txt > __recents.txt
  mv __recents.txt _recents.txt

  echo -n "DELETE: ${POST}" > _LAST_POST

  build_category_page
  build_category-list_page
  build_recent_page

  gh issue close "${NUMBER}" || true
  gh issue lock  "${NUMBER}" || true
  exit 0
}

# User ask for rebuild everything
[ "${POST_TITLE_UPPER}" = "BUILD" ] && {
  CATEGORY_DIR="@${CATEGORY_DIR}"
  
  rebuild_all_posts
  build_home_page
  build_category_page
  build_category-list_page
  build_recent_page

  echo -n "Rebuild pages" > _LAST_POST

  gh issue close "${NUMBER}" || true
  gh issue lock  "${NUMBER}" || true
  exit 0
}

# To make thing looks uniformly we need to prevent different headers in older posts
md5sum -c _sums.txt | grep -qE '_special/post_.*FAILED|_special/global_.*FAILED' && rebuild_all_posts

# Let's build recent page list
build_recent_page

# Build the post needs to be here to avoid double builds
mkdir -p "posts/${CATEGORY_DIR}"/
gh issue view "${NUMBER}" | sed '0,/^--$/d' >> "posts/${CATEGORY_DIR}/_${POST_TITLE}.md"
build_post_page

# (Re)populate categories is always needed
build_category_page

# (Re)populate categories-list maybe
build_category-list_page

build_home_page

md5sum _special/* > _sums.txt
finalize
