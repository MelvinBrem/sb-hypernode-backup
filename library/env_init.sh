if [ ! -e './.env' ]; then
    printf "${COLOR_RED}No .env file found${COLOR_DEFAULT_TEXT}\n"
    printf "${COLOR_ORANGE}Create it now? [y/N] ${COLOR_DEFAULT_TEXT}"
    read -r RESPONSE
    case "$RESPONSE" in
    [yY][eE][sS]|[yY])

        DEFAULT_WPDIR=$(cd "./../public" && pwd)
        DEFAULT_DBNAME=""
        DEFAULT_BACKUPDIR=$(cd "./../sb_backups" && pwd)

        # Set ENV_WPDIR
        while true; do
            printf "${COLOR_ORANGE}Wordpress directory: [${DEFAULT_WPDIR}]: ${COLOR_DEFAULT_TEXT}"
            read -r ENV_WPDIR
            ENV_WPDIR=${ENV_WPDIR:-${DEFAULT_WPDIR}}

            if [ -d "${ENV_WPDIR}/wp-content" ]; then
                break
                else
                printf "${COLOR_RED}The given directory is not a Wordpress installation${COLOR_DEFAULT_TEXT}\n"
            fi
        done

        # Set ENV_BACKUPDIR
        printf "${COLOR_ORANGE}Directory to store backups: [${DEFAULT_BACKUPDIR}]: ${COLOR_DEFAULT_TEXT}"
        read -r ENV_BACKUPDIR
        ENV_BACKUPDIR=${ENV_BACKUPDIR:-${DEFAULT_BACKUPDIR}}

        # Set ENV_DBNAME
        WPCONFIG_FILE="${ENV_WPDIR}/wp-config.php"
        if [ -f "$WPCONFIG_FILE" ]; then
            WPCONFIG_DBNAME=$(grep "define('DB_NAME'," "$WPCONFIG_FILE" | sed -E "s/define\('DB_NAME', '([^']+)'\);/\1/")
            if [ -n "$WPCONFIG_DBNAME" ]; then
                printf "${COLOR_BLUE}Database name found in wp-config.php: $WPCONFIG_DBNAME${COLOR_DEFAULT_TEXT}\n"
                WPCONFIG_ENV_DBNAME="$WPCONFIG_DBNAME"
            else
                printf "${COLOR_RED}Database name not found in wp-config.php${COLOR_DEFAULT_TEXT}\n"
            fi
        else
            printf "${COLOR_RED}wp-config.php not found in the given directory${COLOR_DEFAULT_TEXT}\n"
            exit 1
        fi
        printf "${COLOR_ORANGE}Database name [${WPCONFIG_ENV_DBNAME}]: ${COLOR_DEFAULT_TEXT}"
        read -r ENV_DBNAME
        ENV_DBNAME=${ENV_DBNAME:-$WPCONFIG_ENV_DBNAME}

        # Write to .env
        {
            echo "ENV_WPDIR=\"${ENV_WPDIR}\""
            echo "ENV_BACKUPDIR=\"${ENV_BACKUPDIR}\""
            echo "ENV_DBNAME=\"${ENV_DBNAME}\""
        } > .env

        if [ $? -eq 0 ]; then
            printf "${COLOR_BLUE}.env created${COLOR_DEFAULT_TEXT}\n"
        else
            printf "${COLOR_RED}Failed to create .env file${COLOR_DEFAULT_TEXT}\n"
        fi
        ;;
    *)
        exit 1
        ;;
esac
fi