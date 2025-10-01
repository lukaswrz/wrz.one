serve: assets
    #!/usr/bin/env bash
    miniserve public --index index.html

assets:
    #!/usr/bin/env bash

    if [[ ! -v FONT_LEAGUE_SPARTAN ]]; then
        exit 1
    fi
    
    rsyncflags=(
        --recursive
        --delete
        --mkpath
        --verbose
        --verbose
        --include='*/'
        --include='*.woff2'
        --exclude='*'
    )

    rsync "${rsyncflags[@]}" -- "$FONT_LEAGUE_SPARTAN"/ public/static/fonts/league-spartan

publish:
    #!/usr/bin/env bash
    rsync \
        --recursive \
        --delete \
        --mkpath \
        --verbose \
        --verbose \
        -- \
        public/ \
        helvetica@helveticanonstandard.net:/var/www/wrz.one

