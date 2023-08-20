
# Fix errors with a crashing script











## 







```bash
cat > infrastructure <<EOF_END
#!/usr/bin/env python3
# subscribe to quicklab

import csv
import os
import matplotlib
import numpy as np

class NoFileError(Exception):
  pass

class MissingColumnError(Exception):
  pass

columns = {'firstname','surname','company','job title'}

try:
  CSV_FILE = os.path.expanduser('~') + '/data.csv'

  if not os.path.isfile(CSV_FILE):
    print('Scanning for data.csv...')
    raise NoFileError
  else:
    with open(CSV_FILE) as f:
      csv_data = np.genfromtxt(f,delimiter=',',dtype=str)
      missing_column = list(columns - set(csv_data[0]))
      
      if missing_column:
        raise MissingColumnError
      f.close()

except NoFileError:
  print("NoFileError: Could not find data.csv in the working directory")

except MissingColumnError:
  print("MissingColumnError: Could not find column {} in data.csv".format(missing_column[0]))
EOF_END

sudo mv infrastructure /usr/bin/

pid=$(ps -e | grep -e apt -e adept | grep -v grep | awk '{print $1}')

sudo kill $pid
```


```bash
sudo dpkg --configure -a

sudo apt install python3-pip -y
```

```bash
pip3 install --upgrade pip setuptools wheel

pip3 install matplotlib
```

```bash


cd ~

mv data.bak data.csv

sudo chmod 777 ~/data.csv

pip3 install matplotlib

cd ~

mv data.bak data.csv

sudo chmod 777 ~/data.csv


cat >  data.csv <<EOF
firstname,surname,company,job title
Oliver,Jefferson,Quam Vel Corporation,IT Resident
Xenos,Snow,Tellus LLC,CTO
Emerson,Delgado,Sagittis Ltd,CFO
Ignatius,Henderson,Id Risus Quis Ltd, CTO
Abel,Burnett,Dui Cum Sociis Limited,CEO
Dustin,Daugherty,Pharetra Corp., IT Resident
Thaddeus,Macdonald,Magna Nam Ligula LLP, CTO
Guy,Chen,Dictum Eu LLP, IT Resident
Ulysses,Mcgowan,Aliquam Adipiscing Lacus Incorporated, CFO
Clinton,Ellis,Placerat Velit Limited, CTO
Dolan,Cohen,Sed LLP, IT Resident
Theodore,Ford,Montes Nascetur Ridiculus Limited, IT Resident
Carson,Sykes,Non Dapibus PC, IT Resident
Ulric,Mercer,Orci Lobortis Associates,CEO
Jackson,Dotson,Eget Tincidunt Dui Corporation,CEO
Elliott,Rojas,Nec Metus Facilisis PC, CFO
Judah,Salinas,Orci Foundation, CTO
Ryan,Potter,Dignissim Consulting,CEO
Barry,Shannon,Augue Corporation, CFO
Clarke,Davidson,Purus Corporation, CFO
Rahim,Nunez,Est Company, CFO
Orson,Watkins,A Purus Institute, CTO
Jackson,Lambert,Vel Faucibus Foundation, CFO
Oliver,Sims,Vivamus Nibh Consulting, CTO
Noble,Ortiz,Sit Corporation,CEO
Thor,Pacheco,Semper Et Inc.,CEO
Ivan,Gilliam,Elit Fermentum Inc., IT Resident
Aladdin,Forbes,Nulla Aliquet Incorporated, IT Resident
Jeremy,Cooley,Mauris Vel Turpis Inc., CFO
Cadman,Shepherd,Nunc Laoreet Lectus Ltd, CFO
Mark,Howe,Adipiscing Elit Corp., CFO
Coby,Alston,Sed Institute, CTO
Valentine,Chaney,Eu Ligula Aenean Inc., CFO
Gareth,Booth,Eu LLP, IT Resident
Conan,Beard,Enim Consequat Purus PC, IT Resident
Baker,Horn,Sapien Institute, CFO
Davis,Baird,Lectus Sit Amet LLP, IT Resident
Harrison,Manning,Donec Tincidunt Company,CEO
Cairo,Mathis,Primis In Faucibus Corporation, CTO
Grady,Erickson,Etiam Gravida Molestie Corporation, CFO
Marsden,Holman,Elit Pellentesque Industries, IT Resident
Malcolm,Lane,Lorem Ipsum Dolor Corporation, CTO
Quamar,Nguyen,Eu Euismod Ac Corp.,CEO
Yuli,Elliott,Elementum Incorporated, CTO
Flynn,Fuller,Primis Consulting, CTO
Raphael,Mcintyre,Semper LLC, IT Resident
Ralph,West,At Augue Industries, CTO
Baxter,Dillon,Commodo At Foundation, IT Resident
Hector,Carpenter,Quisque Nonummy Corp., CTO
Uriah,Austin,Vulputate Dui Nec Industries,CEO
Benedict,Ballard,Turpis Associates, CFO
Wang,Little,Ac PC, CFO
Brendan,Reid,Placerat Inc., CTO
Kyle,Gould,Fusce Aliquet Magna Consulting, IT Resident
Giacomo,Salinas,Magna Duis Dignissim Company, IT Resident
Wade,Bullock,Tristique Senectus LLP, IT Resident
Abdul,Gibbs,Duis At Lacus PC, CTO
Devin,Obrien,Neque In Ltd,CEO
Jerome,Gibson,Eu Ligula Aenean Foundation, CFO
Lance,Medina,Libero Proin Mi Company, CTO
Gannon,Harrison,Vulputate Dui Foundation, CFO
Todd,Barron,Nunc LLP, CFO
Oleg,Banks,Vel Mauris Institute,CEO
David,Cline,Nunc Foundation, CTO
Todd,Vaughan,Eu Corporation,CEO
Byron,Fry,Consectetuer Corporation, CFO
Joseph,Sears,Dictum Corporation, CTO
Ira,Wiggins,Eu Enim Incorporated, CTO
Kirk,Davis,Dictum Mi Consulting,CEO
Darius,Owens,Purus In Molestie PC, CFO
Acton,Hooper,Ipsum Leo Elementum Limited,CEO
Fulton,Dodson,Gravida Mauris Ut Foundation,CEO
Tanek,Sloan,Scelerisque Sed Sapien Industries,CEO
Calvin,Page,Etiam Ligula LLP, IT Resident
Amal,Hinton,Urna Inc.,CEO
Lev,Key,Eu Incorporated,CEO
Tobias,Sandoval,Non Corp., CTO
Erich,Lynn,Vitae Orci Corporation, IT Resident
Zeph,Holland,Semper Nam Tempor Foundation,CEO
Chaney,Simmons,Venenatis Lacus Etiam Foundation, CTO
Clarke,Albert,Pellentesque A Facilisis Corporation,CEO
Raphael,Hoffman,Lobortis Quam A Company, IT Resident
Cain,Mckay,Varius Et Euismod Foundation,CEO
Harper,Rivera,Nisi Inc.,CEO
Arden,Ayala,Vel Pede Blandit Incorporated,CEO
Cruz,Gutierrez,A Limited,CEO
Basil,Wyatt,At Pede Cras Ltd, CFO
Wesley,Lamb,Pulvinar Limited, CFO
Barry,Perkins,Donec Inc.,CEO
Zane,Deleon,Mauris Aliquam Eu Ltd, CTO
Isaac,Maddox,Felis Nulla Industries,CEO
Guy,Shaw,Sit Amet Faucibus PC,CEO
Kasimir,Walters,Aliquam Associates, IT Resident
Aaron,Burt,A Dui Limited, CFO
Martin,Salazar,Odio Nam Company, CTO
Brock,Lindsey,Tristique Institute,CEO
Lee,Collier,Pede Consulting,CEO
Grant,Morin,Donec Tempus Institute, IT Resident
Griffin,Jones,Donec Egestas Foundation, IT Resident
Ulric,Bradshaw,At Nisi LLC, CFO
EOF

python3 /usr/bin/infrastructure
python3 /usr/bin/infrastructure
```



###                 Congratulation !!!!