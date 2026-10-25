# Set up a shared folder with access permissions

Here I created a shared folder containing a document, assigned it to a security group with a specific permissions (READ) and then assigned this security group to a user Jan Novak  
Everything went smoothly.

- User: Jan Novak
- Security Group: Finance-Reports-Read
- Shared folder: C:\Shares\FinanceReports
  - Server's local path to the folder
- Document: .\financials.txt
  - Server's local path to the document
- SMB Path: \\DC01\FinanceReports
- Share permissions: Read
- NTFS permissions: Read + List contents

## **Screenshots of proof**

### JNovak can access and read

![Access granted](/screenshots/shared-folder-obj/jnovak-read-allowed.jpg?raw=true)

### JNovak cannot save

![Modify denied](/screenshots/shared-folder-obj/jnovak-modify-denied.jpg?raw=true "create a new file denied")
![Modify denied](/screenshots/shared-folder-obj/jnovak-modify-denied2.jpg?raw=true "write into an existing file denied")

### Users without security group cannot access the folder

![Access denied](/screenshots/shared-folder-obj/dzacek-access-denied.jpg?raw=true)
