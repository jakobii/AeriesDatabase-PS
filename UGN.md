# UGN Table Schema

| Column | Description         | DataType | Length            | Unique Constraint |
| ------ | ------------------- | -------- | ----------------- | ----------------- |
| UID    | UserID              | int      | 2,147,483,648     | yes               |
| UN     | Username            | varchar  | 255               | no                |
| SY     | System              | varchar  | 25                | no                |
| TY     | Type                | smallint | 32,767            | no                |
| UTY    | UserType            | varchar  | 255               | no                |
| HT     | HashType            | smallint | 32,767            | no                |
| PW     | Password            | varchar  | 255               | no                |
| CD     | CreationDate        | datetime | 8                 | no                |
| XD     | ExpDate             | datetime | 8                 | no                |
| ST     | Status              | tinyint  |                   | no                |
| LDT    | LastLogin           | datetime | 8                 | no                |
| LC     | LoginCount          | int      | 2,147,483,648     | no                |
| IP     | IPAddr              | varchar  | 25                | no                |
| EM     | Email               | varchar  | 100               | no                |
| FN     | FirstName           | varchar  | 50                | no                |
| LN     | LastName            | varchar  | 50                | no                |
| CM     | Comment             | nvarchar | max               | no                |
| LIP    | LastIPAddr          | varchar  | 25                | no                |
| CDT    | CurrentLoginDt      | datetime | 8                 | no                |
| LPR    | LastPageRequestDt   | datetime | 8                 | no                |
| ID     | StuPermID           | int      | 2,147,483,648     | no                |
| SID    | Staff               | ID       | int	2,147,483,648 | no                |
| PLC    | PasswordLastChanged | datetime | 8                 | no                |
| SLT    | PasswordSalt        | nvarchar | 255               | no                |
| IDP    | IdPrvdr             | smallint | 32,767            | no                |
| CPW    | ChgPW               | bit      | 1                 | no                |
| DEL    | DEL                 | bit      | 1                 | no                |
| DTS    | DTS                 | datetime | 8                 | no                |