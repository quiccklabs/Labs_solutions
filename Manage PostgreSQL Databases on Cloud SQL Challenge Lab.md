## Manage PostgreSQL Databases on Cloud SQL: Challenge Lab


Database Migration Services require the ***Database Migration API*** and the ***Service Networking API*** to be enabled in order to function. You must enable these APIs for your project.

### ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1 :- In the Google Cloud Console, on the Navigation menu (Navigation menu icon), click Compute Engine > VM instances.

2 :- In the entry for postgresql-vm, under Connect click SSH.

3 :- If prompted, click Authorize.

4 :- In the terminal in the new browser window, install the pglogical database extension:

### ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

```bash
sudo apt install postgresql-13-pglogical
```

```
sudo su - postgres -c "gsutil cp gs://cloud-training/gsp918/pg_hba_append.conf ."
sudo su - postgres -c "gsutil cp gs://cloud-training/gsp918/postgresql_append.conf ."
sudo su - postgres -c "cat pg_hba_append.conf >> /etc/postgresql/13/main/pg_hba.conf"
sudo su - postgres -c "cat postgresql_append.conf >> /etc/postgresql/13/main/postgresql.conf"
sudo systemctl restart postgresql@13-main
```

```
sudo su - postgres
```
```
psql
```

```
\c postgres;
```

```
CREATE EXTENSION pglogical;
```
```
\c orders;
```
```
CREATE EXTENSION pglogical;
```

### Now search for online word replacer website or you can just use this one  :-

```
http://www.unit-conversion.info/texttools/replace-text/
```

### For online Notepad use the below link :- 
```
https://www.rapidtables.com/tools/notepad.html
```

```
CREATE USER migration_admin PASSWORD 'DMS_1s_cool!';
ALTER DATABASE orders OWNER TO migration_admin;
ALTER ROLE migration_admin WITH REPLICATION;



\c orders;

SELECT column_name FROM information_schema.columns WHERE table_name = 'inventory_items' AND column_name = 'id';
ALTER TABLE inventory_items ADD PRIMARY KEY (id);


GRANT USAGE ON SCHEMA pglogical TO migration_admin;
GRANT ALL ON SCHEMA pglogical TO migration_admin;
GRANT SELECT ON pglogical.tables TO migration_admin;
GRANT SELECT ON pglogical.depend TO migration_admin;
GRANT SELECT ON pglogical.local_node TO migration_admin;
GRANT SELECT ON pglogical.local_sync_status TO migration_admin;
GRANT SELECT ON pglogical.node TO migration_admin;
GRANT SELECT ON pglogical.node_interface TO migration_admin;
GRANT SELECT ON pglogical.queue TO migration_admin;
GRANT SELECT ON pglogical.replication_set TO migration_admin;
GRANT SELECT ON pglogical.replication_set_seq TO migration_admin;
GRANT SELECT ON pglogical.replication_set_table TO migration_admin;
GRANT SELECT ON pglogical.sequence_state TO migration_admin;
GRANT SELECT ON pglogical.subscription TO migration_admin;

GRANT USAGE ON SCHEMA public TO migration_admin;
GRANT ALL ON SCHEMA public TO migration_admin;
GRANT SELECT ON public.distribution_centers TO migration_admin;
GRANT SELECT ON public.inventory_items TO migration_admin;
GRANT SELECT ON public.order_items TO migration_admin;
GRANT SELECT ON public.products TO migration_admin;
GRANT SELECT ON public.users TO migration_admin;

ALTER TABLE public.distribution_centers OWNER TO migration_admin;
ALTER TABLE public.inventory_items OWNER TO migration_admin;
ALTER TABLE public.order_items OWNER TO migration_admin;
ALTER TABLE public.products OWNER TO migration_admin;
ALTER TABLE public.users OWNER TO migration_admin;



\c postgres;

GRANT USAGE ON SCHEMA pglogical TO migration_admin;
GRANT ALL ON SCHEMA pglogical TO migration_admin;
GRANT SELECT ON pglogical.tables TO migration_admin;
GRANT SELECT ON pglogical.depend TO migration_admin;
GRANT SELECT ON pglogical.local_node TO migration_admin;
GRANT SELECT ON pglogical.local_sync_status TO migration_admin;
GRANT SELECT ON pglogical.node TO migration_admin;
GRANT SELECT ON pglogical.node_interface TO migration_admin;
GRANT SELECT ON pglogical.queue TO migration_admin;
GRANT SELECT ON pglogical.replication_set TO migration_admin;
GRANT SELECT ON pglogical.replication_set_seq TO migration_admin;
GRANT SELECT ON pglogical.replication_set_table TO migration_admin;
GRANT SELECT ON pglogical.sequence_state TO migration_admin;
GRANT SELECT ON pglogical.subscription TO migration_admin;
```


### TASK 3:- Implement Cloud SQL for PostgreSQL IAM database authentication


### When prompted for a password enter 
```
supersecret!
```

```
\c orders
```
### When prompted for a password enter 
```
supersecret!
```



#### Note change the ***TABLE_NAME*** and ***USER_NAME*** as given on table page..
```
GRANT ALL PRIVILEGES ON TABLE [TABLE_NAME] TO "USER_NAME";

\q
```

### Done with Task 3 now to do database Migration tab and check are you able to click on ***promote*** tab or not.

### TASK 4:- Configure and test point-in-time recovery

```
date --rfc-3339=seconds
```

#### Save this timestamp for later task

### When prompted for a password enter 
```
supersecret!
```

```
\c orders
```
### When prompted for a password enter 
```
supersecret!
```

```
insert into distribution_centers values(-80.1918,25.7617,'Miami FL',11);
\q
```

### Go to sql and click on overview 

```
gcloud auth login --quiet

gcloud projects get-iam-policy $DEVSHELL_PROJECT_ID
```
```
export INSTANCE_ID=
```

```
gcloud sql instances clone $INSTANCE_ID  postgres-orders-pitr --point-in-time 'CHANGE_TIMESTAMP'
```

#### 

#### Congratulation !!!!



