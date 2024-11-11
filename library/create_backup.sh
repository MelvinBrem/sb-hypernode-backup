source .env

VAR_DATETIME="$(date +%Y-%m-%d_%H-%M-%S)"
VAR_BACKUPDIR=${ENV_BACKUPDIR}

for var in ENV_WPDIR ENV_DBNAME ENV_BACKUPDIR; do
    if [ -z "${!var}" ]; then
        printf "${COLOR_RED}No ${var} value set in .env${COLOR_DEFAULT_TEXT}\n"
        exit 1
    fi
done

if ! mysql -e "use ${ENV_DBNAME}"; then
    printf "${COLOR_RED}Database ${ENV_DBNAME} does not exist${COLOR_DEFAULT_TEXT}\n"
    exit 1
fi

mkdir -p "${VAR_BACKUPDIR}/backup_${VAR_DATETIME}"

printf "Creating backup of files...\n"

zip -r ${VAR_BACKUPDIR}/backup_${VAR_DATETIME}/backup_files_${VAR_DATETIME}.zip ./public

printf "Creating backup of database...\n"

mysqldump --single-transaction ${ENV_DBNAME} >${VAR_BACKUPDIR}/backup_${VAR_DATETIME}/backup_database_${VAR_DATETIME}.sql

printf "=== Done ===\n"
