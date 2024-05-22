

echo project = `gcloud config get-value project` \
    >> ~/.cbtrc

cbt listinstances

echo instance = personalized-sales \
    >> ~/.cbtrc


cat ~/.cbtrc

cbt createtable test-sessions

cbt createfamily test-sessions Interactions

cbt createfamily test-sessions Sales

cbt ls test-sessions


cbt read test-sessions

