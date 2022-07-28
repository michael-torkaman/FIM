# file-integrity-monitor
A basic FIM (file integrity monitor) 
Stores hashes of desired files and monitors them for any changes while program is running.
sha512 is used to calculate the hashes. Hashes are stored in baseline.txt.
Program actively monitors files for changes. It compares the hashes of chosesen files with the baseline.
if any changes are detected (content of file has changed, file has been deleted, new file created) user is informed through the terminal. 

is my local files being tracked on git
