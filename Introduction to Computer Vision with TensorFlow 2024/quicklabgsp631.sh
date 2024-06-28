
python --version

python -c "import tensorflow;print(tensorflow.__version__)"

pip install tensorflow tensorflow-datasets google-cloud-logging numpy

pip3 install --upgrade pip

/usr/bin/python3 -m pip install -U google-cloud-logging --user

/usr/bin/python3 -m pip install -U pylint --user

pip install --upgrade tensorflow


wget  https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Introduction%20to%20Computer%20Vision%20with%20TensorFlow%202024/model.py

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Introduction%20to%20Computer%20Vision%20with%20TensorFlow%202024/callback_model.py

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Introduction%20to%20Computer%20Vision%20with%20TensorFlow%202024/updated_model_1.py

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Introduction%20to%20Computer%20Vision%20with%20TensorFlow%202024/updated_model_2.py

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Introduction%20to%20Computer%20Vision%20with%20TensorFlow%202024/updated_model_3.py

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Introduction%20to%20Computer%20Vision%20with%20TensorFlow%202024/update_model_4.py

python model.py

python callback_model.py

python updated_model_1.py

python updated_model_2.py

python updated_model_3.py

sleep 20

pip uninstall numpy -y

pip uninstall numpy tensorflow -y

pip install tensorflow==2.10.0 numpy==1.21.6

pip uninstall google-cloud-logging google-api-core google-protobuf -y

pip install google-cloud-logging==2.6.0 google-api-core==1.31.5 protobuf==3.20.1

pip show google-cloud-logging google-api-core google-protobuf

python update_model_4.py

