source .env

VAR_DATETIME="$(date +%Y-%m-%d_%H-%M)"
VAR_BACKUPDIR=${ENV_BACKUPDIR}

echo $VAR_BACKUPDIR;

if [ -z "${ENV_DBNAME}" ]; then
    printf "${COLOR_RED}No ENV_DBNAME value set in .env${COLOR_DEFAULT_TEXT}\n"
    exit 1
fi

if [ -z "${ENV_BACKUPDIR}" ]; then
    printf "${COLOR_RED}No ENV_BACKUPDIR value set in .env${COLOR_DEFAULT_TEXT}\n"
    exit 1
fi

if [ -z "${ENV_WPDIR}" ]; then
    printf "${COLOR_RED}No ENV_WPDIR value set in .env${COLOR_DEFAULT_TEXT}\n"
    exit 1
fi

if [ ! -d "${VAR_BACKUPDIR}" ]; then
    mkdir "${VAR_BACKUPDIR}"
fi

mkdir ${VAR_BACKUPDIR}/backup_${VAR_DATETIME}
echo $?
exit 1
printf "Creating backup of files...\n"

zip -r ${VAR_BACKUPDIR}/backup_${VAR_DATETIME}/backup_files_${VAR_DATETIME}.zip ./public

printf "Creating backup of database...\n"

mysqldump --single-transaction ${ENV_DBNAME} > ${VAR_BACKUPDIR}/backup_${VAR_DATETIME}/backup_database_${VAR_DATETIME}.sql

printf "=== Done ===\n"