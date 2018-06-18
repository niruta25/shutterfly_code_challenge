import json
import pandas as pd
import os.path
from datetime import datetime

# areas of improvement: instead of taking dictionaries and pandas library as dataset, we could define classes for each object and store the data in memory
#the ingested data can also be stored in json files
customer = {}
site_visit = pd.DataFrame(columns=['key','event_time','customer_id','tags'])
image = {}
order = {}

# method to add new customer
def add_customer(each_event):
    # print(customer.has_key(each_event['key']))
    global customer
    if each_event['key'] not in customer: # check to see the latest customer is updated in our datbase, as the receiving data is un ordered
        customer[each_event['key'].encode('utf-8')] = each_event
    else:
        if each_event['event_time'] > customer[each_event['key']]['event_time']: #making sure that latest data is present in database
            customer[each_event['key'].encode('utf-8')] = each_event

#method to add site visit
def add_site_visit(cust_event):
    global site_visit
    df = pd.DataFrame([each_event], columns=['key', 'event_time', 'customer_id', 'tags'])
    site_visit = site_visit.append(df)

#methos to add image
def add_image(cust_event):
    global image
    if each_event['key'] not in image:
        image[each_event['key'].encode('utf-8')] = each_event
    else:
        if each_event['event_time'] > image[each_event['key']]['event_time']:
            image[each_event['key'].encode('utf-8')] = each_event

#method to add order
def add_order(cust_event):
    global order
    if each_event['key'] not in order:
        order[each_event['key'].encode('utf-8')] = each_event
    else:
        if each_event['event_time'] > order[each_event['key']]['event_time']:
            order[each_event['key'].encode('utf-8')] = each_event

#call events based on type
def ingest(each_event):
    if(each_event['type']) == 'CUSTOMER':
        add_customer(each_event)
    elif(each_event['type']) == 'SITE_VISIT':
        add_site_visit(each_event)
    elif(each_event['type']) == 'IMAGE':
        add_image(each_event)
    elif(each_event['type']) == 'ORDER':
        add_order(each_event)


# method to calculate LTV
def topXSimpleLTVCustomers(x):
    global customer
    global site_visit
    global image
    global order

    #get total visits on site per customer
    total_visits = site_visit.groupby(['customer_id']).agg(['count', 'min', 'max'])['event_time'] #to be improved

    #get total expenditure by the customer
    total_sum = pd.DataFrame(order.values())    #Future Scope: check if all total_amount in USD
    total_sum.total_amount = total_sum.total_amount.str[:-4].astype(float)
    total_sum = total_sum.groupby(['customer_id']).agg(['sum'])['total_amount']
    expend = total_sum.join(total_visits, how='outer')

    #get total expenditure by a customer per visit
    expend['total_expend'] = expend['sum']/expend['count']
    expend = expend.fillna(0)

    # visits per week
    # calculated as total count of visits divided by total weeks
    expend['min'] = pd.to_datetime(expend['min'], format = '%Y-%m-%d:%H:%M:%S.%fZ')
    expend['max'] = pd.to_datetime(expend['max'], format = '%Y-%m-%d:%H:%M:%S.%fZ')
    expend['duration'] = (expend['max']- expend['min']).dt.days.replace(0,1)
    expend['visits_per_week'] = expend['count']*7/expend['duration']

    # ltv calculation
    expend['ltv'] = 52*10*expend['total_expend']*expend['visits_per_week']

    #get top x customers
    expend = expend.sort_values(by=['ltv'], ascending=False).head(x)

    #write to file as output
    out = expend['ltv'].to_json()

    path_out = os.path.join(os.getcwd(), "output\output.txt")
    with open(path_out, 'w') as outfile:
        json.dump(out, outfile)


os.chdir('..')
path = os.path.join(os.getcwd(), 'input\events.txt')
print(path)
with open(path) as f:
    contents = json.load(f)


for each_event in contents:
    ingest(each_event)

#get top 5 cystomers
topXSimpleLTVCustomers(5)
