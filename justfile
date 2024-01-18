set dotenv-load := true

export ASSET_SRC := "components/assets/src"
export ASSET_DIST := "assets/dist"


# Remove built assets and collected static files
assets-clean:
    rm -rf $ASSET_DIST


# Install the Node.js dependencies
assets-install *args="":
    #!/usr/bin/env bash
    set -euo pipefail


    # exit if lock file has not changed since we installed them. -nt == "newer than",
    # but we negate with || to avoid error exit code
    test package-lock.json -nt node_modules/.written || exit 0

    npm ci {{ args }}
    touch node_modules/.written


# Build the Node.js assets
assets-build:
    #!/usr/bin/env bash
    set -euo pipefail


    # find files which are newer than dist/.written in the src directory. grep
    # will exit with 1 if there are no files in the result.  We negate this
    # with || to avoid error exit code
    # we wrap the find in an if in case dist/.written is missing so we don't
    # trigger a failure prematurely
    if test -f assets/dist/.written; then
        find $ASSET_SRC -type f -newer $ASSET_DIST/.written | grep -q . || exit 0
    fi

    npm run build
    touch $ASSET_DIST/.written


# install npm toolchaing, build and collect assets
assets: assets-install assets-build 

# rebuild all npm/static assets
assets-rebuild: assets-clean assets

assets-run: assets-install
    #!/usr/bin/env bash
    set -euo pipefail

    if [ "$ASSETS_DEV_MODE" == "False" ]; then
        echo "Set ASSETS_DEV_MODE to a truthy value to run this command"
        exit 1
    fi

    npm run dev


assets-test: assets-install
    npm run test:coverage
