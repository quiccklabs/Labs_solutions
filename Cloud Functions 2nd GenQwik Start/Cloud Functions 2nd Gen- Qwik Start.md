

# Cloud Functions 2nd Gen: Qwik Start 



## IAM & Admin - Audit Logs Configuration

## Steps:

1. Navigate to IAM & Admin > Audit Logs in the Google Cloud Console.

2. Find the Compute Engine API in the list.

3. Click the checkbox next to the Compute Engine API.

4. In the info pane on the right, perform the following actions:

   - Check the box for **Admin Read** log type.
   
   - Check the box for **Data Read** log type.
   
   - Check the box for **Data Write** log type.

5. Click the **Save** button to apply the changes.

## Result:

The Compute Engine API now has Admin Read, Data Read, and Data Write log types enabled in the Audit Logs configuration.

### Export the ***ZONE*** from task 4

```
export ZONE=
```


###
###

```
curl -LO https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Cloud%20Functions%202nd%20GenQwik%20Start/task1.sh
sudo chmod +x task1.sh
./task1.sh
```

## ``` Now check the score for TASK 6 After that run the below commands ```


```
export REGION="${ZONE%-*}"
cd min-instances/
curl -LO https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Cloud%20Functions%202nd%20GenQwik%20Start/task2.sh
sudo chmod +x task2.sh
./task2.sh
```

### Follow the Video once you done with above commands

### Congratulations !!!!

