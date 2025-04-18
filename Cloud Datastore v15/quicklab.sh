

gcloud services enable datastore.googleapis.com

gcloud firestore databases create \
  --location=us-central1 \
  --type=datastore-mode

npm install @google-cloud/datastore


cat > insertTask.js <<'EOF_END'
// import the Datastore client
const { Datastore } = require('@google-cloud/datastore');

// create a client
const datastore = new Datastore();

// define the task object (your template)
const task = {
  category: 'Personal',
  done: false,
  priority: 4,
  description: 'Learn Cloud Datastore',
};

// create a key for a new entity of kind 'Task'
const taskKey = datastore.key('Task');

// wrap it in the Datastore format
const entity = {
  key: taskKey,
  data: [
    {
      name: 'category',
      value: task.category,
    },
    {
      name: 'done',
      value: task.done,
    },
    {
      name: 'priority',
      value: task.priority,
    },
    {
      name: 'description',
      value: task.description,
      excludeFromIndexes: true, // optional: don't index long text
    },
  ],
};

// function to insert into Datastore
async function insertTask() {
  try {
    await datastore.save(entity);
    console.log(`✅ Task saved with ID: ${taskKey.id || '(auto-generated)'}`);
  } catch (err) {
    console.error('❌ Error saving task:', err);
  }
}

insertTask();

EOF_END

node insertTask.js
