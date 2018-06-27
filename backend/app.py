import ssl
import os

from flask import Flask, render_template, jsonify
from random import randint
from flask_cors import CORS
from flask_restful import Api
from flask_jwt import JWT

from security import authenticate, identity

from resources.user import UserRegister

context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
context.load_cert_chain('./ssl/cert.pem', './ssl/key.pem')

app = Flask(__name__,
            static_folder = "../dist/static",
            template_folder = "../dist")

app.config.from_object(os.environ['APP_SETTINGS'])
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False 
# cache = redis.Redis(host='redis', port=6379)            

cors = CORS(app, resources={r"/api/*": {"origins": "*"}}) 
jwt = JWT(app, authenticate, identity)  # /auth
api = Api(app)

api.add_resource(UserRegister, '/register')

@app.route('/api/random')
def random_number():
    response = {
        'randomNumber': randint(1, 100)
    }
    return jsonify(response)

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def catch_all(path):
    return render_template("index.html")

if __name__ == "__main__":
    print(os.environ['APP_SETTINGS'])
    from db import db
    db.init_app(app)
    app.run(host='0.0.0.0', port=5000, debug=True, ssl_context=context)
