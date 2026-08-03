import base64
import requests
import json

from getpass import getpass
from Globals import Globals
from MyRequests import MyRequests

#Globals.myHost = "https://yinhdisv:8081"
Globals.myHost = "https://mainframeyin:8092"
Globals.myBasepath = ""
Globals.myCreds = ('','')
Globals.pathPrefix = "/CTF2026/API/v1"
Globals.s = requests.sessions.Session()

if Globals.myCreds[0] == '':
    userid = input("Give your userid: ")
    Globals.myCreds = (userid,'')

if Globals.myCreds[1] == '':
    passwd = getpass("Give your password: ")
    Globals.myCreds = (Globals.myCreds[0], passwd)

print("Getting bearer token")

MyRequests.getBearerToken(f"{Globals.pathPrefix}/token")

def doStuff():
    respget = MyRequests.get(f"{Globals.pathPrefix}/loginInfo")

    if (respget.status_code == 200):
        print(f"{respget.status_code} {respget.text}")
    else:
        raise Exception(f'status code {str(respget.status_code)} {respget.text}')

    # data = {}
    # #data['sqlquery'] = "SELECT ACCTIME, TIMESTAMP('1970-01-01') + ACCTIME SECONDS + CURRENT TIMEZONE, INOROUT, USERID FROM CTF2026.ACCLOG"
    # data['sqlquery'] = "SELECT"

    # resppost = MyRequests.post(f"{Globals.pathPrefix}/sqlquery", data)

    # if (resppost.status_code == 200):
    #     print(f"{resppost.status_code} {resppost.text}")
    # else:
    #     raise Exception(f'status code {str(resppost.status_code)} {resppost.text}')

#for i in range(0, 100):
doStuff()