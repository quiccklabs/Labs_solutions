


##  Activity: Decrypt an encrypted message


***Start the lab and run the below commands***


```bash
cat README.txt

cd caesar

cat .leftShift3 | tr "d-za-cD-ZA-C" "a-zA-Z"

cd ~

openssl aes-256-cbc -pbkdf2 -a -d -in Q1.encrypted -out Q1.recovered -k ettubrute

cat Q1.recovered
```

## Congratulations !!!
