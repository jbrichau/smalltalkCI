#!/bin/bash

set -e

# Helper functions
# ==============================================================================
function print_info {
    printf "\e[0;34m$1\e[0m\n"
}

function print_notice {
    printf "\e[1;33m$1\e[0m\n"
}

function print_error {
    printf "\e[1;31m$1\e[0m\n"
}
# ==============================================================================

# Check required arguments
# ==============================================================================
if [ -z "$PROJECT_HOME" ]; then
    print_error "\$PROJECT_HOME is not defined!"
    exit 1
elif [ -z "$BASELINE" ]; then
    print_error "\$BASELINE is not defined!"
    exit 1
fi
# ==============================================================================

# Set default Smalltalk version
# ==============================================================================
[ -z "$SMALLTALK" ] && SMALLTALK="Squeak5.0"
# ==============================================================================

# Start build accordingly
# ==============================================================================
EXIT_STATUS=0
case "$SMALLTALK" in
    Squeak*)
        print_info "Starting Squeak build..."
        squeak/run.sh || EXIT_STATUS=$?
        ;;
    Pharo*)
        print_info "Starting Pharo build..."
        pharo/run.sh || EXIT_STATUS=$?
        ;;
    *)
        print_error "Unknown Smalltalk version ${SMALLTALK}"
        exit 1
        ;;
esac
# ==============================================================================

# Check exit status
# ==============================================================================
printf "\n\n"
if [ $EXIT_STATUS -eq 0 ]; then
    print_success "Build successful :)"
else
    print_error "Build failed :("
    if [ "$TRAVIS" = "true" ]; then
        printf "\n\n"
        print_info "To reproduce the failed build locally, download filetreeCI and try running something like:"
        printf "\n"
        print_notice "SMALLTALK=$SMALLTALK BASELINE=$BASELINE BASELINE_GROUP=$BASELINE_GROUP PROJECT_HOME=/local/path/to/project PACKAGES=$PACKAGES FORCE_UPDATE=$FORCE_UPDATE KEEP_OPEN=true ./run.sh"
        printf "\n"
    fi
fi
printf "\n"
# ==============================================================================

exit $EXIT_STATUS
