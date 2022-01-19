#! /bin/bash

# Gets SSH Credentials from the log file.

# Wait for a login attempt and run the command below
#cat /var/log/auth.log | grep "SSH Login Attempt\|Failed password"
LOGFILE=/var/log/auth.log

#cat /var/log/auth.log | grep "SSH Login Attempt" | awk {'print $5'} | sed 's/sshd\[//' | sed 's/\]\://' > sshid.txt
cat $LOGFILE | grep "SSH Login Attempt" | awk {'print $5'} > sshid.tmp

echo "-> any ids that occur more than once will appear below. this could affect results:"
cat sshid.tmp | grep "SSH Login Attempt" | awk {'print $5'} | sed 's/sshd\[//' | sed 's/\]\://' | sort | uniq -c | sort -rn | grep -v "^1"  

echo "Date,Time,hostname,sshid,username,password,ip" > sshlog.csv

while IFS="" read -r p || [ -n "$p" ]
do
  SSHLOGIN=$(grep -F $p $LOGFILE | grep "SSH Login Attempt" | awk {'print $1" "$2","$3","$4","$5","$10","$12'})
  FAILEDPW=$(grep -F $p $LOGFILE | grep "Failed password" | awk {'print $11'})
  echo $SSHLOGIN,$FAILEDPW >> sshlog.csv
done < sshid.tmp

echo
echo "-> output written to ./sshlog.csv"

rm sshid.tmp
