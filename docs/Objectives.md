# Set up a shared folder with access permissions

Here I created a shared folder containing a document, assigned it to a security group with a specific permissions (READ) and then assigned this security group to a user Jan Novak  
Everything went smoothly.

- User: Jan Novak
- Security Group: Fianance-Reports-Read
- Shared folder: C:\Shared\FinanceReports
- Document: .\financials.txt
- Share permissions: Read

**Screenshots of proof**

### JNovak can access and read

![Access granted](/screenshots/jnovak-read-allowed.jpg?raw=true)

### JNovak cannot save

![Modify denied](/screenshots/jnovak-modify-denied.jpg?raw=true "create a new file denied")
![Modify denied](/screenshots/jnovak-modify-denied2.jpg?raw=true "write into an existing file denied")

### Users without security group cannot access the folder

![Access denied](/screenshots/dzacek-access-denied.jpg?raw=true)
