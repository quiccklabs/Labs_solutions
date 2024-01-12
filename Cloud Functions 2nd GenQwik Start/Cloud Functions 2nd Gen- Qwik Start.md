

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

### Export the ***ZONE*** FROM task 4

```
export ZONE=
```