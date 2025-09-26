
#!/bin/bash
dt=`date --date="yesterday" +%Y%m%d`
NOWDATE=`date +%Y-%m-%d`
DB_name="BOTPLATFORM"
#Log file path
log_file=/var/log/backups/mongo_backup.log

#set backup path where to store db dump
BACKUP_DIR="/db-dump/mongo"
BACKUP_FOLDER="mongo_`date +%d%m%Y-%H%M%S`.gz"
3daysback=`date --date="3 days ago" +%d%m%Y`
LASTDATE1=$(date +%d%m%Y --date='1 day ago')
#set mongo dump path command
yyear=`date -d "1 days ago" +"%Y"`
mmonth=`date -d "1 days ago" +"%m"`

MONGODUMP_PATH="/usr/bin/mongodump"

# AWS backup config
AWS_S3_BACKUP_PATH="backups/mongo"
AWS_S3_NEW_MONGO_BACKUP_PATH="bot/mongo"
AWS_BUCKET_NEW_NAME="surbo-prod-dbdata"

# Create BACKUP_PATH directory if it does not exist
#[ ! -d "$BACKUP_DIR" ] && mkdir -p $BACKUP_DIR

aws s3 cp $BACKUP_FOLDER s3://surbo-prod-dbdata/bot/mongo/$yyear/$mmonth/ --region ap-south-2 >> $log_file


#echo "<<<<-----------------Starting Mongo Backup------------->>>>>>>>>>>>>>>" >> $log_file
#starttime=`date +%Y-%m-%d" "%T`
#echo "---Start Time -- `date +%Y-%m-%d" "%T`----">> $log_file
#
#cd /db-dump/mongo/
#rm -f mongo_$LASTDATE1-*.gz
#
#cd $BACKUP_DIR
#echo "<<<<----Taking backup Mongo DB:$MONGO_HOST:$MONGO_PORT:$MONGO_DATABASE" >> $log_file
#$MONGODUMP_PATH  --host $MONGO_HOST --port $MONGO_PORT -d $MONGO_DATABASE -u $MONGO_USERNAME -p $MONGO_PASSWORD --gzip --archive=$BACKUP_FOLDER >> /dev/null
#
#echo "---End Time -- `date +%Y-%m-%d" "%T`----">> $log_file
#endtime=`date +%Y-%m-%d" "%T`
#aws s3 cp $BACKUP_FOLDER s3://$AWS_BUCKET_NAME/$AWS_S3_BACKUP_PATH/$yyear/$mmonth/ >> $log_file
#aws s3 cp $BACKUP_FOLDER s3://surbo-prod-dbdata/bot/mongo/$yyear/$mmonth/ --region ap-south-2 >> $log_file
#cstarttime=`date +%Y-%m-%d" "%T`
#cendtime=`date +%Y-%m-%d" "%T`
#echo "====>>>>Uploading dbs backup files to s3 bucket:$AWS_BUCKET_NAME and s3 path:$AWS_S3_BACKUP_PATH" >> $log_file
#echo "==>>Removing backup folder from server and keeping tar file in tmp folder" >> $log_file
#siz2=`du -sh $BACKUP_FOLDER | awk '{print $1}'`
#echo "==>>Mongo dump named:$BACKUP_FOLDER is completed" >> $log_file
#
#siz3=`du -sh $BACKUP_FOLDER | awk '{print $1}'`
#cd /db-dump/mongo
#rm -f mongo_$LASTDATE1-*.gz
#
#echo "<<<<<<<----------------Ending Mongo Backup----------------->>>>>>>>>>>>>>>>>"  >>  $log_file

webhook_alert "Hydrabaad ------ India Surbo-DB-1 Mongo Database Dump Details - Start_time - $starttime, Database name - $DB_name, Dump size without compress - $siz2, Dump size after compress -$siz3, Local path - /db-dump/mongo, End_time - $endtime"
