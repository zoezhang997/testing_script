import snowflake.connector
from get_secret import get_secret
import json


# import botocore 
# import botocore.session 
# from aws_secretsmanager_caching import SecretCache, SecretCacheConfig 

# client = botocore.session.get_session().create_client('secretsmanager',region_name='secretsmanager')
# cache_config = SecretCacheConfig()
# cache = SecretCache( config = cache_config, client = client)

# secret = cache.get_secret_string('snowflake/connection')

# Set up the Snowflake connection parameters
config_json = json.loads(get_secret())
config_json.update({'warehouse':'COMPUTE_WH', 'database':'ANALYTICS_PROD','schema': 'IOATAWARE'})

# Create a connection object
conn = snowflake.connector.connect(**config_json)

# Create a cursor object to execute SQL queries
cur = conn.cursor()

# Execute a sample SQL query
query = "SELECT * FROM VW_AIF_REPORT_DETAIL WHERE  'Flight Date' = '20220701'"
cur.execute(query)

# Fetch the results
results_df = cur.fetch_pandas_all()

#Print the results
print(results_df)

# Close the cursor and connection
cur.close()
conn.close()
