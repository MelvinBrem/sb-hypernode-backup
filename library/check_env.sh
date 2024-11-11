if [ ! -d "./../public" ]; then
    printf "${COLOR_RED}Directory ./../public does not exist${COLOR_DEFAULT_TEXT}\n"
    printf "${COLOR_RED}Are you sure you this repo is installed in the right directory?${COLOR_DEFAULT_TEXT}"
    exit 1
fi

if [ ! -e './.env' ]; then
    printf "${COLOR_RED}No .env file found${COLOR_DEFAULT_TEXT}\n"
    printf "${COLOR_ORANGE}Create it now? [${COLOR_GREEN}Y/n${COLOR_ORANGE}]: ${COLOR_BLUE}"
    read -r RESPONSE
    case "$RESPONSE" in
    [yY][eE][sS] | [yY] | "")
        DEFAULT_WPDIR=$(realpath "./../public")
        DEFAULT_DBNAME=""
        DEFAULT_BACKUPDIR=$(realpath "./../sb_backups")

        # Set ENV_WPDIR
        while true; do
            printf "${COLOR_ORANGE}Wordpress directory: [${COLOR_GREEN}${DEFAULT_WPDIR}${COLOR_ORANGE}]: ${COLOR_BLUE}"
            read -r ENV_WPDIR
            ENV_WPDIR=${ENV_WPDIR:-${DEFAULT_WPDIR}}
            ENV_WPDIR=${ENV_WPDIR/#\~/$HOME}

            if [ -d "${ENV_WPDIR}/wp-content" ]; then
                break
            else
                printf "${COLOR_RED}The given directory is not a Wordpress installation${COLOR_DEFAULT_TEXT}\n"
            fi
        done

        # Set ENV_BACKUPDIR
        printf "${COLOR_ORANGE}Directory to store backups: [${COLOR_GREEN}${DEFAULT_BACKUPDIR}${COLOR_ORANGE}]: ${COLOR_BLUE}"
        read -r ENV_BACKUPDIR
        ENV_BACKUPDIR=${ENV_BACKUPDIR:-${DEFAULT_BACKUPDIR}}
        ENV_BACKUPDIR=${ENV_BACKUPDIR/#\~/$HOME}

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
        printf "${COLOR_ORANGE}Database name [${COLOR_GREEN}${WPCONFIG_ENV_DBNAME}${COLOR_ORANGE}]: ${COLOR_BLUE}"
        read -r ENV_DBNAME
        ENV_DBNAME=${ENV_DBNAME:-$WPCONFIG_ENV_DBNAME}

        # Write to .env
        {
            echo "ENV_WPDIR=\"${ENV_WPDIR}\""
            echo "ENV_BACKUPDIR=\"${ENV_BACKUPDIR}\""
            echo "ENV_DBNAME=\"${ENV_DBNAME}\""
        } >.env

        if [ $? -eq 0 ]; then
            printf "${COLOR_BLUE}.env created${COLOR_DEFAULT_TEXT}\n\n"
        else
            printf "${COLOR_RED}Failed to create .env file${COLOR_DEFAULT_TEXT}\n\n"
        fi
        ;;
    *)
        exit 1
        ;;
    esac
fi
