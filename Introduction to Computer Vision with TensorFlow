LAB NAME :- Introduction to Computer Vision with TensorFlow
GSP Number:- 631


Model.py :-

# Import and configure logging
import logging
import google.cloud.logging as cloud_logging
from google.cloud.logging.handlers import CloudLoggingHandler
from google.cloud.logging_v2.handlers import setup_logging
cloud_logger = logging.getLogger('cloudLogger')
cloud_logger.setLevel(logging.INFO)
cloud_logger.addHandler(CloudLoggingHandler(cloud_logging.Client()))
# Import TensorFlow
import tensorflow as tf
# Import tensorflow_datasets
import tensorflow_datasets as tfds
# Import numpy
import numpy as np
# Define, load and configure data
(ds_train, ds_test), info = tfds.load('fashion_mnist', split=['train', 'test'], with_info=True, as_supervised=True)
# Values before normalization 
image_batch, labels_batch = next(iter(ds_train))
print("Before normalization ->", np.min(image_batch[0]), np.max(image_batch[0]))
# Define batch size
BATCH_SIZE = 32
# Normalize and batch process the dataset
ds_train = ds_train.map(lambda x, y: (tf.cast(x, tf.float32)/255.0, y)).batch(BATCH_SIZE)
ds_test = ds_test.map(lambda x, y: (tf.cast(x, tf.float32)/255.0, y)).batch(BATCH_SIZE)
# Examine the min and max values of the batch after normalization
image_batch, labels_batch = next(iter(ds_train))
print("After normalization ->", np.min(image_batch[0]), np.max(image_batch[0]))
# Define the model
model = tf.keras.models.Sequential([tf.keras.layers.Flatten(),
                                    tf.keras.layers.Dense(64, activation=tf.nn.relu),
                                    tf.keras.layers.Dense(10, activation=tf.nn.softmax)])
# Compile the model
model.compile(optimizer = tf.keras.optimizers.Adam(),
              loss = tf.keras.losses.SparseCategoricalCrossentropy(),
              metrics=[tf.keras.metrics.SparseCategoricalAccuracy()])
model.fit(ds_train, epochs=5)
cloud_logger.info(model.evaluate(ds_test))
# Save the entire model as a SavedModel.
model.save('saved_model')
# Reload a fresh Keras model from the saved model 
new_model = tf.keras.models.load_model('saved_model')
# Summary of loaded SavedModel
new_model.summary()
# Save the entire model to a HDF5 file.
model.save('my_model.h5')
# Recreate the exact same model, including its weights and the optimizer
new_model_h5 = tf.keras.models.load_model('my_model.h5')
# Summary of loaded h5 model
new_model_h5.summary()




➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖


callback_model.py:-


# Import and configure logging
import logging
import google.cloud.logging as cloud_logging
from google.cloud.logging.handlers import CloudLoggingHandler
from google.cloud.logging_v2.handlers import setup_logging
exp_logger = logging.getLogger('expLogger')
exp_logger.setLevel(logging.INFO)
exp_logger.addHandler(CloudLoggingHandler(cloud_logging.Client(), name="callback"))
# Import tensorflow_datasets
import tensorflow_datasets as tfds
# Import numpy
import numpy as np
# Import TensorFlow
import tensorflow as tf
# Define Callback
class myCallback(tf.keras.callbacks.Callback):
  def on_epoch_end(self, epoch, logs={}):
    if(logs.get('sparse_categorical_accuracy')>0.84):
      exp_logger.info("\nReached 84% accuracy so cancelling training!")
      self.model.stop_training = True
callbacks = myCallback()
# Define, load and configure data
(ds_train, ds_test), info = tfds.load('fashion_mnist', split=['train', 'test'], with_info=True, as_supervised=True)
# Define batch size
BATCH_SIZE = 32
# Normalizing and batch processing of data
ds_train = ds_train.map(lambda x, y: (tf.cast(x, tf.float32)/255.0, y)).batch(BATCH_SIZE)
ds_test = ds_test.map(lambda x, y: (tf.cast(x, tf.float32)/255.0, y)).batch(BATCH_SIZE)
# Define the model
model = tf.keras.models.Sequential([tf.keras.layers.Flatten(),
                                    tf.keras.layers.Dense(64, activation=tf.nn.relu),
                                    tf.keras.layers.Dense(10, activation=tf.nn.softmax)])
# Compile data
model.compile(optimizer = tf.keras.optimizers.Adam(),
              loss = tf.keras.losses.SparseCategoricalCrossentropy(),
              metrics=[tf.keras.metrics.SparseCategoricalAccuracy()])
model.fit(ds_train, epochs=5, callbacks=[callbacks])




➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖


Exercise 1:-


# Import and configure logging
import logging
import google.cloud.logging as cloud_logging
from google.cloud.logging.handlers import CloudLoggingHandler
from google.cloud.logging_v2.handlers import setup_logging
up_logger = logging.getLogger('upLogger')
up_logger.setLevel(logging.INFO)
up_logger.addHandler(CloudLoggingHandler(cloud_logging.Client(), name="updated"))
# Import tensorflow_datasets
import tensorflow_datasets as tfds
# Import numpy
import numpy as np
# Import TensorFlow
import tensorflow as tf
# Define, load and configure data
(ds_train, ds_test), info = tfds.load('fashion_mnist', split=['train', 'test'], with_info=True, as_supervised=True)
# Define batch size
BATCH_SIZE = 32
# Normalizing and batch processing of data
ds_train = ds_train.map(lambda x, y: (tf.cast(x, tf.float32)/255.0, y)).batch(BATCH_SIZE)
ds_test = ds_test.map(lambda x, y: (tf.cast(x, tf.float32)/255.0, y)).batch(BATCH_SIZE)
# Define the model
model = tf.keras.models.Sequential([tf.keras.layers.Flatten(), 
                                    tf.keras.layers.Dense(128, activation=tf.nn.relu), 
                                    tf.keras.layers.Dense(10, activation=tf.nn.softmax)])
# Compile data
model.compile(optimizer = tf.keras.optimizers.Adam(),
              loss = tf.keras.losses.SparseCategoricalCrossentropy(),
              metrics=[tf.keras.metrics.SparseCategoricalAccuracy()])
model.fit(ds_train, epochs=5)
# Logs model summary
model.summary(print_fn=up_logger.info)





➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖


Exercise 2:-


# Import and configure logging
import logging
import google.cloud.logging as cloud_logging
from google.cloud.logging.handlers import CloudLoggingHandler
from google.cloud.logging_v2.handlers import setup_logging
up_logger = logging.getLogger('upLogger')
up_logger.setLevel(logging.INFO)
up_logger.addHandler(CloudLoggingHandler(cloud_logging.Client(), name="updated"))
# Import tensorflow_datasets
import tensorflow_datasets as tfds
# Import numpy
import numpy as np
# Import TensorFlow
import tensorflow as tf
# Define, load and configure data
(ds_train, ds_test), info = tfds.load('fashion_mnist', split=['train', 'test'], with_info=True, as_supervised=True)
# Define batch size
BATCH_SIZE = 32
# Normalizing and batch processing of data
ds_train = ds_train.map(lambda x, y: (tf.cast(x, tf.float32)/255.0, y)).batch(BATCH_SIZE)
ds_test = ds_test.map(lambda x, y: (tf.cast(x, tf.float32)/255.0, y)).batch(BATCH_SIZE)
# Define the model
model = tf.keras.models.Sequential([tf.keras.layers.Flatten(), 
                                    tf.keras.layers.Dense(64, activation=tf.nn.relu), 
                                    tf.keras.layers.Dense(64, activation=tf.nn.relu),
                                    tf.keras.layers.Dense(10, activation=tf.nn.softmax)])
# Compile data
model.compile(optimizer = tf.keras.optimizers.Adam(),
              loss = tf.keras.losses.SparseCategoricalCrossentropy(),
              metrics=[tf.keras.metrics.SparseCategoricalAccuracy()])
model.fit(ds_train, epochs=5)
# Logs model summary
model.summary(print_fn=up_logger.info)




➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖


Exercise 3:-



# Import and configure logging
import logging
import google.cloud.logging as cloud_logging
from google.cloud.logging.handlers import CloudLoggingHandler
from google.cloud.logging_v2.handlers import setup_logging
up_logger = logging.getLogger('upLogger')
up_logger.setLevel(logging.INFO)
up_logger.addHandler(CloudLoggingHandler(cloud_logging.Client(), name="updated"))
# Import tensorflow_datasets
import tensorflow_datasets as tfds
# Import numpy
import numpy as np
# Import TensorFlow
import tensorflow as tf
# Define, load and configure data
(ds_train, ds_test), info = tfds.load('fashion_mnist', split=['train', 'test'], with_info=True, as_supervised=True)
# Define batch size
BATCH_SIZE = 32
# Normalizing and batch processing of data
ds_train = ds_train.batch(BATCH_SIZE)
ds_test = ds_test.batch(BATCH_SIZE)
# Define the model
model = tf.keras.models.Sequential([tf.keras.layers.Flatten(), 
                                    tf.keras.layers.Dense(64, activation=tf.nn.relu),
                                    tf.keras.layers.Dense(10, activation=tf.nn.softmax)])
# Compile data
model.compile(optimizer = tf.keras.optimizers.Adam(),
              loss = tf.keras.losses.SparseCategoricalCrossentropy(),
              metrics=[tf.keras.metrics.SparseCategoricalAccuracy()])
model.fit(ds_train, epochs=5)
# Logs model summary
model.summary(print_fn=up_logger.info)
# Print out max value to see the changes
image_batch, labels_batch = next(iter(ds_train))
t_image_batch, t_labels_batch = next(iter(ds_test))
up_logger.info("training images max " + str(np.max(image_batch[0])))
up_logger.info("test images max " + str(np.max(t_image_batch[0])))








