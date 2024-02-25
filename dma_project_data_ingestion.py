# -*- coding: utf-8 -*-
"""
@author: karnik

"""

import mysql.connector as mysql
import pymysql
from sqlalchemy import create_engine    
import pandas as pd
import datetime
import pygsheets
import numpy

gc = pygsheets.authorize(service_file = r'C:\Users\karni\OneDrive\Desktop\Niwish files\niwish-analytics-a5704af3efcc.json')

sh=gc.open_by_url('https://docs.google.com/spreadsheets/d/1xgCb6QWl3LgSlX4RbwQpn8rpbSVvj83AzaS_25t-24Y/edit#gid=0')

# Importing Web Activity Table
wks1 = sh.worksheet('title','Web Activity')
web_activity = wks1.get_as_df(start='A1', end='G1001')
web_activity['created_at'] = pd.to_datetime(web_activity['created_at'])

# Importing Orders Table
wks2 = sh.worksheet('title','Orders')
orders = wks2.get_as_df(start='A1', end='L262')
orders['created_at'] = pd.to_datetime(orders['created_at'])
orders['updated_at'] = pd.to_datetime(orders['updated_at'])

# Importing Transactions Table
wks3 = sh.worksheet('title','Transactions')
transactions = wks3.get_as_df(start='A1', end='F262')
transactions['created_at'] = pd.to_datetime(transactions['created_at'])

# Importing Wallets Table
wks4 = sh.worksheet('title','Wallets')
wallets = wks4.get_as_df(start='A1', end='F62')
wallets['created_at'] = pd.to_datetime(wallets['created_at'])
wallets['updated_at'] = pd.to_datetime(wallets['updated_at'])

# Importing Customers Table
wks5 = sh.worksheet('title','Customers')
customers = wks5.get_as_df(start='A1', end='K76')
customers['created_at'] = pd.to_datetime(customers['created_at'])
customers['date_of_birth'] = pd.to_datetime(customers['date_of_birth'])

# Importing Agents Table
wks6 = sh.worksheet('title','Agents')
agents = wks6.get_as_df(start='A1', end='H16')
agents['created_at'] = pd.to_datetime(agents['created_at'])

# Importing Distributors Table
wks7 = sh.worksheet('title','Distributors')
distributors = wks7.get_as_df(start='A1', end='G21')

# Importing Metals Table
wks8 = sh.worksheet('title','Metals')
metals = wks8.get_as_df(start='A1', end='B3')

# Importing Metal Rates Table
wks9 = sh.worksheet('title','Metal Rates')
metal_rates = wks9.get_as_df(start='A1', end='D61')
metal_rates['created_at'] = pd.to_datetime(metal_rates['created_at'])

# Importing Enums Table
wks10 = sh.worksheet('title','Enums')
enums = wks10.get_as_df(start='A1', end='E10')

# Importing Order Status Table
wks11 = sh.worksheet('title','Order Status')
order_status = wks11.get_as_df(start='A1', end='B6')

# Importing Payment Status Table
wks12 = sh.worksheet('title','Payment Status')
payment_status = wks12.get_as_df(start='A1', end='B5')

# Connecting to the database
engine = create_engine("mysql+pymysql://{user}:{pw}@127.0.0.1/{db}".format(user="sk",pw="1Q2w3E4r",db="preciousmetals"))
conn = engine.connect()
print('Database connected')

# Ingesting Metals data
metals.to_sql('metals', con = conn, if_exists = 'append', chunksize = 2000, index = False)
print("Data ingested into metals table")

# Ingesting Metal Rates data
metal_rates.to_sql('metalrates', con = conn, if_exists = 'append', chunksize = 2000, index = False)
print("Data ingested into metalrates table")

# Ingesting Order Status data
order_status.to_sql('orderstatus', con = conn, if_exists = 'append', chunksize = 2000, index = False)
print("Data ingested into orderstatus table")

# Ingesting Payment Status data
payment_status.to_sql('paymentstatus', con = conn, if_exists = 'append', chunksize = 2000, index = False)
print("Data ingested into paymentstatus table")

# Ingesting Enums data
enums.to_sql('enums', con = conn, if_exists = 'append', chunksize = 2000, index = False)
print("Data ingested into enums table")

# Ingesting Agents data
agents.to_sql('agents', con = conn, if_exists = 'append', chunksize = 2000, index = False)
print("Data ingested into agents table")

# Ingesting Distributors data
distributors.to_sql('distributors', con = conn, if_exists = 'append', chunksize = 2000, index = False)
print("Data ingested into distributors table")

# Ingesting Customers data
customers.to_sql('customers', con = conn, if_exists = 'append', chunksize = 2000, index = False)
print("Data ingested into customers table")

# Ingesting Wallets data
wallets.to_sql('wallets', con = conn, if_exists = 'append', chunksize = 2000, index = False)
print("Data ingested into wallets table")

# Ingesting Orders data
orders.to_sql('orders', con = conn, if_exists = 'append', chunksize = 2000, index = False)
print("Data ingested into orders table")

# Ingesting Transactions data
transactions.to_sql('transactions', con = conn, if_exists = 'append', chunksize = 2000, index = False)
print("Data ingested into transactions table")

# Ingesting Web Activity data
web_activity.to_sql('webactivity', con = conn, if_exists = 'append', chunksize = 2000, index = False)
print("Data ingested into webactivity table")

conn.close()
