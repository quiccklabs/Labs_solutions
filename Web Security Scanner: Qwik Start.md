

## Web Security Scanner: Qwik Start

## 
##


```bash
gsutil -m cp -r gs://spls/gsp067/python-docs-samples .

cd python-docs-samples/appengine/standard_python3/hello_world

cat > requirements.txt <<EOF_END
Flask==1.1.2
itsdangerous==2.0.1
Jinja2==3.0.3
werkzeug==2.0.1
EOF_END

gcloud app deploy 
```


### Choose REGION from task '3' and press 'y' 

##
### Congratulations !!!!
