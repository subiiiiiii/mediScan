from pymongo import MongoClient
from bson import ObjectId
import hashlib
import os

# MongoDB connection setup
client = MongoClient('mongodb://localhost:27017/')
db = client['mediScanDB']
users_collection = db['users']

def generate_salt():
    """Generates a random salt."""
    return os.urandom(16).hex()

def hash_password(password, salt):
    """Hashes a password with a given salt."""
    return hashlib.sha256((password + salt).encode()).hexdigest()

def register_user(user_data):
    # Check if user already exists
    if users_collection.find_one({'email': user_data['email']}):
        return {'status': 'error', 'message': 'User already exists'}, 400
    
    # Generate a salt and hash the password
    salt = generate_salt()
    hashed_password = hash_password(user_data['password'], salt)
    
    # Create the user document
    user_document = {
        'first_name': user_data['first_name'],
        'last_name': user_data['last_name'],
        'email': user_data['email'],
        'date_of_birth': f"{user_data['date_of_birth']['day']}/{user_data['date_of_birth']['month']}/{user_data['date_of_birth']['year']}",
        'password': hashed_password,
        'salt': salt
    }
    
    # Insert the user into the database
    result = users_collection.insert_one(user_document)
    
    return {'status': 'success', 'user_id': str(result.inserted_id)}

def login_user(login_data):
    user = users_collection.find_one({'email': login_data['email']})
    
    if not user:
        return {'status': 'error', 'message': 'Invalid email or password'}, 401
    
    hashed_password = hash_password(login_data['password'], user['salt'])
    
    if hashed_password == user['password']:
        return {
            'status': 'success',
            'user_id': str(user['_id']),
            'first_name': user['first_name'],
            'last_name': user['last_name']
        }, 200
    else:
        return {'status': 'error', 'message': 'Invalid email or password'}, 401
