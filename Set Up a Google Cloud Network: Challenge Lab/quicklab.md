## **Set Up a Google Cloud Network: Challenge Lab**

### 

```
sudo apt-get update
sudo apt-get install -y postgresql-13-pglogical
sudo su - postgres -c "gsutil cp gs://cloud-training/gsp918/pg_hba_append.conf ."
sudo su - postgres -c "gsutil cp gs://cloud-training/gsp918/postgresql_append.conf ."
sudo su - postgres -c "cat pg_hba_append.conf >> /etc/postgresql/13/main/pg_hba.conf"
sudo su - postgres -c "cat postgresql_append.conf >> /etc/postgresql/13/main/postgresql.conf"
sudo systemctl restart postgresql@13-main
sudo su - postgres
```
##
```
psql
```
##
```
\set user CHANGE_HERE
```
##
```
\c postgres;
```
##
```
CREATE EXTENSION pglogical;
```
###





### **```Congratulations:-)```**
