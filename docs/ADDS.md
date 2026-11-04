# Windows Server

- Hostname: DC01
- FQDN: DC01.ad.zontcorp.test
- Domain name: ad.zontcorp.test
- Accounts:
  - ~~zontcorp: ZONTCORP\zontcorp~~
  - Administrator: ZONTCORP\Administrator
  - Jan Novak: ZONTCORP\jnovak
  - Daniel Zacek: ZONTCORP\dzacek
  - Eva Cerna: ZONTCORP\ecerna
  - Kamil Svoboda: ZONTCORP\ksvoboda
  - Honza Dvorak: ZONTCORP\hdvorak

# Accounts

| Account Name  | Role          | OU        | Security Groups      | Status   |
| ------------- | ------------- | --------- | -------------------- | -------- |
| zontcorp      | administrator | n/a       | n/a                  | Disabled |
| administrator | administrator | n/a       | n/a                  | Enabled  |
| Jan Novak     | user          | Employees | finance-reports-read | Enabled  |
| Eva Cerna     | user          | Employees | n/a                  | Enabled  |
| Kamil Svoboda | user          | Employees | n/a                  | Enabled  |
| Honza Dvorak  | user          | Employees | n/a                  | Enabled  |
