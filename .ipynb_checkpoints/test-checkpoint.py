import snowflake.connector
from get_secret import get_secret
import json
import pandas as pd

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
