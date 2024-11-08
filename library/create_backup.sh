source .env

exit 1

VAR_DATETIME="$(date +%Y-%m-%d_%H-%M)"
VAR_BACKUPDIR="${ENV_BACKUPDIR}/backup_${VAR_DATETIME}"

cd ~

if [ -z "${ENV_DBNAME}" ]; then
    printf "${COLOR_RED}No ENV_DBNAME value set in .env${COLOR_DEFAULT_TEXT}\n"
    exit 1
fi

if [ ! -d './backups' ]; then
    mkdir backups
fi

mkdir ${VAR_BACKUPDIR}

printf "Creating backup of files...\n"

zip -r ${VAR_BACKUPDIR}/backup_files_${VAR_DATETIME}.zip ./public

printf "Creating backup of database...\n"

mysqldump --single-transaction ${ENV_DBNAME} > ${VAR_BACKUPDIR}/backup_database_${VAR_DATETIME}.sql

printf "=== Done ===\n"
# Blame melvinbrem@socialbrothers.nl if this destroys something