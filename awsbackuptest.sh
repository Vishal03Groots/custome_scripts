#!/bin/bash
#######################################################
# Program: Gmetrics monitoring plugins listing.
#
# Purpose:
#  Check S3 cloudwatch detailed metrics
#  can be run in interactive.
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

# type command is checking whether aws, jq, bc, timeout command present or not.
#######################################################
# check pre-requisite for fetch AWS cloud watch metrics, below packages must install without this plugin won't run.
# type command is checking whether jq, aws, bc and timeout or gtimeout present or not.
type jq >/dev/null 2>&1 || { echo >&2 "This plugin require "jq" package, but it's not installed. Aborting."; exit 1; }
type aws >/dev/null 2>&1 || { echo >&2 "This plugin require "awscli" package, but it's not installed. Aborting."; exit 1; }
type bc >/dev/null 2>&1 || { echo >&2 "This plugin require "bc" package, but it's not installed. Aborting."; exit 1; }
type timeout >/dev/null 2>&1 || type gtimeout >/dev/null 2>&1 || { echo >&2 "This plugin require "timeout or gtimeout" package, but neither is installed. Aborting."; exit 1; }

# Usage details
#######################################################

if [ "${1}" = "--help" -o "${#}" = "0" ];
       then
       echo -e "Usage: ./$SCRIPTNAME -p [Profile Name] -r [Region] -m [Metric Name] -t [Minutes] -d [Dimensions] -w [Value] -c [Value]
        OPTION                                                                          DESCRIPTION
        ------------------------------------------------------------------------------------------------------
        --help                                          Help
        -p [Profile Name]                               --profile (Which AWS profile should be used to connect to aws?)
        -r [Region]                                     --region (example: "eu-west-1") (https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html)
        -w [Value]                                      --Warning Threshold.
        -c [Value]                                      --Critical Threshold.
        ------------------------------------------------------------------------------------------------------
         Usage: ./$SCRIPTNAME -p default -r us-west-2 -m GetRequests -t 1440 -d \"BucketName,testbucket\" -w 2 -c 3
";
       exit 3;
fi

#######################################################
# Get user-given variables
#######################################################

while getopts "p:r:m:t:s:d:w:c:" Input;
do
        case ${Input} in
        p)      PROFILENAME=${OPTARG};;
        r)      REGION=${OPTARG};
        w)      IWARN=${OPTARG};;
        c)      ICRIT=${OPTARG};;
        *)      echo "Usage: $SCRIPTNAME -p groots -r ap-west-1 " -w 2 -c 3"
               exit 3
               ;;
       esac
done

# Parameter parsing.
# Minutes should 1440 for 24 hours
# Period must be greater than 600 seconds (9 min) minimum..
#######################################################

if [ $MINUTES -le 1339 ]
then
        echo "Minutes window: Metrics Minutes Must be greater than or equals to 1440."
        exit 3
else
        MINUTES=$MINUTES
fi

#######################################################
# Main Logic
#######################################################

# Main command to fetch cloudwatch metric.
#######################################################
COMMAND="sudo aws --profile "$PROFILENAME" cloudwatch get-metric-statistics"
COMMAND="${COMMAND} --region ${REGION}"
COMMAND="${COMMAND} --metric-name ${METRICSNAME}";
COMMAND="${COMMAND} --output json";

# For null value
#######################################################

if [ ${METRICSVALUE} = null ]
then
        echo "UNKNOWN - No data found."
        exit 3;
fi

#######################################################
OUTPUT=`echo "AWS Backup failed count=$(aws backup list-backup-jobs --region= ${REGION} --profile= $PROFILENAME  | grep -c "State.*[^C]OMPLETED")
#######################################################

if [ "$count" -le "$WARN" ]
then
        STATUS="OK";
        EXITSTAT=0;

        elif [ "$count" -gt "$WARN" ]
        then
                if [ "$count" -gt "$CRIT" ]
                then
                        STATUS="CRITICAL";
                        EXITSTAT=2;
                else
                        STATUS="WARNING";
                        EXITSTAT=1;
                fi
else
        STATUS="UNKNOWN";
        EXITSTAT=3;
fi

if [ "$STATUS" = "UNKNOWN" ]
then
        echo "$STATUS - No data Found."
else
        echo "$STATUS - $OUTPUT"
fi

#End of logic
#######################################################