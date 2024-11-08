if [ ! -e './.env' ]; then
    printf "${COLOR_RED}No .env file found${COLOR_DEFAULT_TEXT}\n"
    printf "${COLOR_ORANGE}Create it now? [y/N] ${COLOR_DEFAULT_TEXT}"
    read -r RESPONSE
    case "$RESPONSE" in
    [yY][eE][sS]|[yY])

        # Set ENV_WPDIR
        while true; do
            printf "${COLOR_ORANGE}Wordpress directory: [./../public]: ${COLOR_DEFAULT_TEXT}"
            read -r RESP_ENV_WPDIR
            RESP_ENV_WPDIR=${RESP_ENV_WPDIR:-./../public}

            if [ -d "$RESP_ENV_WPDIR/wp-content" ]; then
                break
                else
                printf "${COLOR_RED}The given directory is not a Wordpress installation${COLOR_DEFAULT_TEXT}\n"
            fi
        done

        # Set ENV_DBNAME
        WPCONFIG_FILE="${RESP_ENV_WPDIR}/wp-config.php"
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
            exit
        fi

        printf "${COLOR_ORANGE}Database name [${WPCONFIG_ENV_DBNAME}]: ${COLOR_DEFAULT_TEXT}"
        read -r RESP_ENV_DBNAME
        RESP_ENV_BACKUPDIR=${RESP_ENV_BACKUPDIR:-WPCONFIG_ENV_DBNAME}

        # Set ENV_BACKUPDIR
        printf "${COLOR_ORANGE}Directory to store backups: [./../sb-backups]: ${COLOR_DEFAULT_TEXT}"
        read -r RESP_ENV_BACKUPDIR
        RESP_ENV_BACKUPDIR=${RESP_ENV_BACKUPDIR:-./../sb_backups}

        {
            echo "ENV_DBNAME=\"$RESP_ENV_DBNAME\""
            echo "ENV_BACKUPDIR=\"$RESP_ENV_BACKUPDIR\""
            echo "ENV_WPDIR=\"$RESP_ENV_WPDIR\""
        } > .env

        if [ $? -eq 0 ]; then
            printf "${COLOR_BLUE}.env created${COLOR_DEFAULT_TEXT}\n"
        else
            printf "${COLOR_RED}Failed to create .env file${COLOR_DEFAULT_TEXT}\n"
        fi
        ;;
    *)
        exit
        ;;
esac
fi