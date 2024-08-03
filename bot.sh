#!/usr/bin/env bash
#
# Commit Bot by Steven Kneiser
#
# > https://github.com/theshteves/commit-bot
#
# Deploy locally by adding the following line to your crontab:
# 0 22 * * * /bin/bash /<full-path-to-your-folder>/code/commit-bot/bot.sh
#
# Edit your crontab in vim w/ the simple command:
# crontab -e
#
# Deploying just on your computer is better than a server if you want
# your commits to more realistically mirror your computer usage.
#
# ...c'mon, nobody commits EVERY day ;)
#

info="Commit: $(date)"
echo "OS detected: $OSTYPE"

case "$OSTYPE" in
    darwin*)
        cd "`dirname $0`" || exit 1
        ;;

    linux*)
        cd "$(dirname "$(readlink -f "$0")")" || exit 1
        ;;

    *)
        echo "OS unsupported (submit an issue on GitHub!)"
        exit 1
        ;;
esac

echo "$info" >> output.txt
echo "$info"
echo

# Set up Git to use the public repository URL
REPO_URL="https://github.com/LukaNikolaisvili/commit-bot.git"
git remote set-url origin $REPO_URL

# Configure Git to handle divergent branches by merging
git config pull.rebase false

# Pull the latest changes
git pull

# Ship it
git add output.txt
git commit -m "$info"
git push origin main # or "master" on old setups

cd -
