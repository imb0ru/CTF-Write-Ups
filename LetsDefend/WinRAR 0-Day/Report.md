# WinRAR 0-Day
## Introduction
We are tasked with analyzing a cracked version of a popular video game which exhibited suspicious behavior. The memory dump file belongs to a blue team focused challenge on the [LetsDefend](https://app.letsdefend.io/challenge/winrar-0-day) website, titled “WinRAR 0-Day” and was created by [Mostafa Abdelaziz](https://twitter.com/0xMM0X).

## Scenario
It appears that there are numerous cracked versions of popular games available. However, it seems we may have downloaded the wrong one, as it exhibits suspicious behavior. We require your assistance in investigating this matter.

## Files
The challenge provides a lab environment in which is hosted a windows machine equipped with volatility3 tool and a vmem file to analyze.

## Preliminary Analysis
Running

 `python3 vol.py -f ../Winny.vmem windows.info`
 
yields detailed analysis of the information provided by the Windows operating system under examination.
The operating system runs on a 64-bit architecture. However, support for Physical Address Extension (PAE) is not enabled.
The system utilizes a layer named "WindowsIntel32e" and appears to manage memory through a file layer.
The operating system version is Windows 10 with major version 10 and minor version 0.

## Question 1
### What is the suspected process?
To enumerate the processes on the system, we'll employ the "windows.pslist" command. This command traverses the doubly-linked list referenced by "PsActiveProcessHead" and presents details such as the offset, process name, process ID, parent process ID, thread count, handle count, and timestamps indicating when the process began and ended. Upon inspecting the roster of processes, we detected the presence of several WinRAR.exe instances that raised suspicion. This finding has been duly noted as the response to question 1.

 `python3 vol.py -f ../Winny.vmem windows.pslist`

## Question 2
### We suspect that the crack had another name. Can you find the old name of that crack?

To help detect commands used by attackers in cmd.exe or executed via backdoors, we can utilize the `windows.cmdline` command. Additionally, we can use piping with `grep` to search for "WinRAR" in a case-insensitive manner within the output.

`python3 vol.py -f ../Winny.vmem windows.cmdline | grep -i "winrar"`

## Question 3
### What is the new crack filename?

Let's scan the file system  redirecting the output into a txt file.

`python3 vol.py -f ../Winny.vmem windows.filescan > filesystem.txt`

Reading the content of filesystem.txt file we search for the lines containing "\Downloads". This will reveal all the files in the directory which had the rar file.

`cat filesystem.txt | grep "\Downloads"`

## Question 4
### What is the command that executed the remote request?

Through examination of this memory cache, we can retrieve files that were in active use. 

We know the virtual address and the file name of the crack. Let's use it in volatility in order to extract the file from the memory dump.

`python3 vol.py -f ../Winny.vmem -o dump windows.dumpfile --virtaddr 0xc402ee5b16e0`

Renaming the exported file in rar extension we can extract its contents.

After displaying the output of the cmd file, we obtain the encoded PowerShell command.

## Question 5
### The external link has a username. What is it?

Decoding the PowerShell command from base64 we can obtain the username.


## Question 6
### It seems the creator of that ransomware uploaded a file to the cloud. Can you find which domain it was downloaded from?

The site is not working properly, so we check the hint in which is stored the page of the ransomware.

> Check the VBS script. https://bazaar.abuse.ch/sample/0352598565fbafe39866f3c9b5964b613fd259ea12a8fe46410b5d119db97aba

Downloading the sample and analyzing it we realize that the script utilizes the Microsoft.XMLHTTP object (xHttp) to dispatch an HTTP GET request to a URL retrieved from the v3xDF0elUqts variable, which seems to be a string subjected to heavy obfuscation.

Let's use python to decode it:

```
input_string = "REDACTED"

result = input_string.replace("LOPPLPOPLPO.LPLPOLPOLPOP", " ") 

print(bytes.fromhex(result).decode('utf-8'))
```

## Question 7
### The attacker left the file behind in someplace to come back later for the device. What is the full location of this file?

Let's deobfuscate the second string:

```
input_string = "REDACTED"

result = input_string.replace("*************", "X")

reversed_result = result[::-1]

print(bytes(reversed_result, 'utf-8').decode('base64'))
```