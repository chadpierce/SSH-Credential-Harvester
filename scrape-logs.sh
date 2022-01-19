#! /bin/bash
#
# Gets timestamp, credentials, and IP from log and writes to single line
# note: auth.log files are rotated and there could be additional files (auth.log.1, and so on)
#
# daily cronjob (edit path as needed):
# crontab -e
# 0 0 * * * /root/scrape-logs.sh
# 
#
# TODO process rotated logs


LOGFILE=/var/log/auth.log
TS=$(date +%Y%m%d-%H%M%S)
OUTFILE="sshlog-$TS.csv"

# create temp file with list of IDs from auth.log
cat $LOGFILE | grep "SSH Login Attempt" | awk {'print $5'} > sshid.tmp

# alert on duplicate ids, but no idea if this is actually an issue or not
echo "-> any ids that occur more than once will appear below. this could affect results:"
cat sshid.tmp | grep "SSH Login Attempt" | awk {'print $5'} | sed 's/sshd\[//' | sed 's/\]\://' | sort | uniq -c | sort -rn | grep -v "^1"  

# csv header for output file
echo "Date,Time,hostname,sshid,username,password,ip" > $OUTFILE

# loop through list of IDs
while IFS="" read -r p || [ -n "$p" ]
do

  # get the source IP
  FAILEDPW=$(grep -F $p $LOGFILE | grep "Failed password for invalid user" | awk {'print $13'})
  
  if [ -z "$FAILEDPW" ]  # if var is empty
  then
        FAILEDPW=$(grep -F $p $LOGFILE | grep "Failed password" | awk {'print $11'})
  fi
  
  # remove duplicate IPs
  IPADDR=$(echo $FAILEDPW | cut -d " " -f1)

  # get majority of details for log
  SSHLOGIN=$(grep -F $p $LOGFILE | grep "SSH Login Attempt" | awk {'print $1" "$2","$3","$4","$5","$10","$12'})

  # loop through list of these if there are multiple and write to output file
  while read s; do 
    echo $s,$IPADDR >> $OUTFILE
  done <<< "$SSHLOGIN"

done < sshid.tmp

echo
echo "-> output written to ./sshlog-$TS.csv"

# clean up temp file
rm sshid.tmp
