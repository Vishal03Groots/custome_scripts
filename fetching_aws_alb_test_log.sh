#!/bin/bash
#######################################################
# Program: To fetch ALB logs from S3
#
# Purpose:
#  This script fetches ALB logs from S3 under given path
#
# License:
#  This program is distributed in the hope that it will be useful,
#  but under groots software technologies @rights.
#
#######################################################

# Check for people who need help - aren't we all nice ;-)
#######################################################

#Set script name
#######################################################
SCRIPTNAME=`basename $0`

# Import Hostname
#######################################################
HOSTNAME=$(hostname)

# Logfile
#######################################################
LOGDIR=/var/log/groots/logviu/
LOGFILE=$LOGDIR/"$SCRIPTNAME".log
if [ ! -d $LOGDIR ]
then
        mkdir -p $LOGDIR
elif [ ! -f $LOGFILE ]
then
        touch $LOGFILE
fi
# Logger function
#######################################################
log () {
while read line; do echo "[`date +"%Y-%m-%dT%H:%M:%S,%N" | rev | cut -c 7- | rev`][$SCRIPTNAME]: $line"| tee -a $LOGFILE 2>&1 ; done
}

# Usage details.
#######################################################
if [ "${1}" = "--help" -o "${#}" -eq "0" ];
       then
       echo -e "Usage: $SCRIPTNAME -p [AWS PROFILE] -s [S3 Bucket Name] -r [REGION CODE]

        OPTION              DESCRIPTION
        ----------------------------------
        --help              Help
        -p [AWS PROFILE]    Aws profile like secret and access key stored.
        -s [S3 Bucket Name] Cloudtrail S3 Bucket Name.
        -r [REGION CODE]    AWS Region Code.
        -k [S3 Bucket Prefix] Optional S3 bucket prefix after AWSLogs.
        ----------------------------------

        Usage: ./$SCRIPTNAME -p myprofile -s \"aws-alb-logs\" -r \"ap-south-1\" -k \"optional/prefix\"

        ";
       exit 3;
fi

#########################################################
# Get user-given variables
#########################################################

while getopts "p:s:r:k:" Input;
do
       case ${Input} in
       p)      PROFILE=${OPTARG};;
       s)      S3BUCKETNAME=${OPTARG};;
       r)      REGION=${OPTARG};;
       k)      PREFIX=${OPTARG};;
       *)      echo "Usage: $SCRIPTNAME -p myprofile  -s \"aws-alb-logs\" -r \"ap-south-1\" -k \"optional/prefix\""
               exit 3
               ;;
       esac
done

#########################################################
# Main Logic
#########################################################
ALBDATE=`date '+%Y/%m/%d'`

CLLOGDATE=`date --date="$DAYAGO day" "+%Y/%m/%d"`

# Get the AWS account id
#########################################################
GETAWSACCOUNTID=`aws sts --profile ${PROFILE} get-caller-identity | egrep "Account" | awk -F':' '{print $2}' | sed 's/[, "]//g'`
echo "account id:$GETAWSACCOUNTID"

# Main files and folders
#########################################################
TMPFILE="/var/log/groots/alb_logs/${S3BUCKETNAME}/aws_alb_`date '+%Y-%m-%d'`.log"
MAINFILE="/var/log/groots/alb_logs/${S3BUCKETNAME}/aws_alb.log


DOWNLOADFOLDER="/var/log/groots/alb_logs/${S3BUCKETNAME}/tmp/"

# Verify download directory if not exists create it
#########################################################
if [ ! -d $DOWNLOADFOLDER ]
then
        mkdir -p $DOWNLOADFOLDER
fi

# Get the files and dowanload it
#########################################################
#aws s3 ls --profile bb_org s3://$S3BUCKETNAME/AWSLogs/${GETAWSACCOUNTID}/elasticloadbalancing/${REGION}/${ALBDATE}/ | awk '{p   rint $4}'

#while read region
while [ 1 ]
do
        echo "###########################################################" | log
        echo "Download the aws alb file using profile: ${PROFILE}, bucket name:$S3BUCKETNAME, account id:${GETAWSACCOUNTID}" |    log
        echo "###########################################################" | log
        aws s3 cp --recursive --profile ${PROFILE} s3://$S3BUCKETNAME/$PREFIX/AWSLogs/${GETAWSACCOUNTID}/elasticloadbalancin   g/${REGION}/${ALBDATE}/ $DOWNLOADFOLDER | log
        break;
done

echo "###########################################################" | log
echo "List the cloudtrail downloaded files" | log
ls -ltrh $DOWNLOADFOLDER | log

echo "###########################################################" | log
echo "creating tmp file for all downloaded files" | log
zcat $DOWNLOADFOLDER/*.gz > $TMPFILE

echo "###########################################################" | log
echo "Creating valid main file for logviu" | log
cat $TMPFILE > $MAINFILE
echo "AWS ALB logfile created \"$MAINFILE\"" | log
echo "###########################################################" | log
echo "Removing tmp data" | log
rm -rf $DOWNLOADFOLDER/*
#End of logic
#######################################################
