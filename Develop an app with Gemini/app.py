"""
A sample Hello World server.
"""
import os

from flask import Flask, render_template, jsonify
from inventory import inventory

# pylint: disable=C0103
app = Flask(__name__)

# Generate an app route to display a list of inventory items in the JSON format from the inventory.py file.
# Use the GET method.

@app.route('/inventory', methods=['GET'])
def inventory_list():
    """Return a list of inventory items in JSON format."""
    return jsonify(inventory)




# ... (rest of your code)

@app.route('/inventory/<productid>')
def get_product(productid):
    """Return a specific product from the inventory by its ID."""
    for product in inventory:
        if product['productid'] == productid:
            return jsonify(product)

    # If product not found, return a 404 error
    return jsonify({'error': 'Product not found'}), 404




@app.route('/')
def hello():
    """Return a friendly HTTP greeting."""
    message = "It's running!"

    """Get Cloud Run environment variables."""
    service = os.environ.get('K_SERVICE', 'Unknown service')
    revision = os.environ.get('K_REVISION', 'Unknown revision')

    return render_template('index.html',
        message=message,
        Service=service,
        Revision=revision)

if __name__ == '__main__':
    server_port = os.environ.get('PORT', '8080')
    app.run(debug=False, port=server_port, host='0.0.0.0')
