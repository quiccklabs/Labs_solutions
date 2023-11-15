### importTestData.js:-

```
const {promisify} = require('util');
const parse       = promisify(require('csv-parse'));
const {readFile}  = require('fs').promises;
const {Firestore} = require('@google-cloud/firestore');
const {Logging} = require('@google-cloud/logging');


const logName = 'pet-theory-logs-importTestData';
// Creates a Logging client
const logging = new Logging();
const log = logging.log(logName);
const resource = {
 type: 'global',
};


if (process.argv.length < 3) {
 console.error('Please include a path to a csv file');
 process.exit(1);
}


const db = new Firestore();
function writeToFirestore(records) {
 const batchCommits = [];
 let batch = db.batch();
 records.forEach((record, i) => {
   var docRef = db.collection('customers').doc(record.email);
   batch.set(docRef, record);
   if ((i + 1) % 500 === 0) {
     console.log(`Writing record ${i + 1}`);
     batchCommits.push(batch.commit());
     batch = db.batch();
   }
 });
 batchCommits.push(batch.commit());
 return Promise.all(batchCommits);
}


function writeToDatabase(records) {
 records.forEach((record, i) => {
   console.log(`ID: ${record.id} Email: ${record.email} Name: ${record.name} Phone: ${record.phone}`);
 });
 return ;
}


async function importCsv(csvFileName) {
   const fileContents = await readFile(csvFileName, 'utf8');
   const records = await parse(fileContents, { columns: true });
   try {
     await writeToFirestore(records);
     //await writeToDatabase(records);
   }
   catch (e) {
     console.error(e);
     process.exit(1);
   }
   console.log(`Wrote ${records.length} records`);
   // A text log entry
   success_message = `Success: importTestData - Wrote ${records.length} records`
   const entry = log.entry({resource: resource}, {message: `${success_message}`});
   log.write([entry]);
 }


importCsv(process.argv[2]).catch(e => console.error(e));
```


---


### createTestData.js:-


```
const fs = require('fs');
const faker = require('faker');
const {Logging} = require('@google-cloud/logging');
const logName = 'pet-theory-logs-createTestData';
// Creates a Logging client
const logging = new Logging();
const log = logging.log(logName);
const resource = {
 // This example targets the "global" resource for simplicity
 type: 'global',
};


function getRandomCustomerEmail(firstName, lastName) {
 const provider = faker.internet.domainName();
 const email = faker.internet.email(firstName, lastName, provider);
 return email.toLowerCase();
}
async function createTestData(recordCount) {
   const fileName = `customers_${recordCount}.csv`;
   var f = fs.createWriteStream(fileName);
   f.write('id,name,email,phone\n')
   for (let i=0; i<recordCount; i++) {
     const id = faker.datatype.number();
     const firstName = faker.name.firstName();
     const lastName = faker.name.lastName();
     const name = `${firstName} ${lastName}`;
     const email = getRandomCustomerEmail(firstName, lastName);
     const phone = faker.phone.phoneNumber();
     f.write(`${id},${name},${email},${phone}\n`);
   }
   console.log(`Created file ${fileName} containing ${recordCount} records.`);
   // A text log entry
   const success_message = `Success: createTestData - Created file ${fileName} containing ${recordCount} records.`
   const entry = log.entry({resource: resource}, {name: `${fileName}`, recordCount: `${recordCount}`, message: `${success_message}`});
   log.write([entry]);
 }
recordCount = parseInt(process.argv[2]);
if (process.argv.length != 3 || recordCount < 1 || isNaN(recordCount)) {
 console.error('Include the number of test data records to create. Example:');
 console.error('    node createTestData.js 100');
 process.exit(1);
}
createTestData(recordCount);
```
