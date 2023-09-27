





sudo ifconfig

sudo tcpdump -D

sudo tcpdump -i eth0 -v -c5

sudo tcpdump -i eth0 -nn -c9 port 80 -w capture.pcap &

curl opensource.google.com

ls -l capture.pcap

sudo tcpdump -nn -r capture.pcap -v

sudo tcpdump -nn -r capture.pcap -X