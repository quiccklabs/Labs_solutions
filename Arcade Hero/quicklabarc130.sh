
bq --location=US mk --dataset $DEVSHELL_PROJECT_ID:sports

bq --location=US mk --dataset $DEVSHELL_PROJECT_ID:soccer

bq mk --table $DEVSHELL_PROJECT_ID:soccer.premiership