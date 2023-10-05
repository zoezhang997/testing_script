
import pandas as pd
import boto3
from botocore.exceptions import ClientError
import snowflake.connector
import json
import numpy as np


def calculate_accuracy(df1, df2):
    df1.columns = df2.columns 
    merged = df1.merge(df2, how = 'outer', indicator = True)
    df1_only = merged[merged['_merge'] == "left_only"]
    df2_only = merged[merged['_merge'] == "right_only"]


    # Calculate accuracy as a percentage
    accuracy_df1 = ((len(df1) - len(df1_only)) / len(df1)) * 100
    accuracy_df2 = ((len(df2) - len(df2_only)) / len(df2)) * 100

    return accuracy_df1,accuracy_df2,df1_only,df2_only


def process_fee_column(value):
    value = value.replace('$', '')  # Remove $
    value = value.replace(')', '')   # Remove )
    value = value.replace('(', '-')   # Replace ( with -
    value = value.replace(',', '') 
    return float(value)

def get_data(query):
    config_json = json.loads(get_secret())
    config_json.update({'warehouse':'COMPUTE_WH', 'database':'ANALYTICS_PROD','schema': 'IOATAWARE',"loglevel":'DEBUG'})

    # Create a connection object
    conn = snowflake.connector.connect(**config_json)
    # Create a cursor object to execute SQL queries
    cur = conn.cursor()
    cur.execute(query)

    # Fetch the results
    results_df = cur.fetch_pandas_all()
    
    return results_df

def get_secret():
    secret_name = "snowflake/zoe/connection"
    region_name = "ca-central-1"

    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name,
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        if e.response['Error']['Code'] == 'ResourceNotFoundException':
            print("The requested secret " + secret_name + " was not found")
        elif e.response['Error']['Code'] == 'InvalidRequestException':
            print("The request was invalid due to:", e)
        elif e.response['Error']['Code'] == 'InvalidParameterException':
            print("The request had invalid params:", e)
        elif e.response['Error']['Code'] == 'DecryptionFailure':
            print("The requested secret can't be decrypted using the provided KMS key:", e)
        elif e.response['Error']['Code'] == 'InternalServiceError':
            print("An error occurred on service side:", e)
    else:
        # Secrets Manager decrypts the secret value using the associated KMS CMK
        # Depending on whether the secret was a string or binary, only one of these fields will be populated
        if 'SecretString' in get_secret_value_response:
            text_secret_data = get_secret_value_response['SecretString']
        else:
            binary_secret_data = get_secret_value_response['SecretBinary']

        # Your code goes here.
        return text_secret_data
