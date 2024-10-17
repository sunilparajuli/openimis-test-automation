import os
from dotenv import load_dotenv

class EnvLibrary:
    def __init__(self):
        load_dotenv()  # Load the variables from the .env file

    def get_env_variable(self, key):
        value = os.getenv(key)
        if value is None:
            raise ValueError(f"Environment variable '{key}' not found.")
        return value
