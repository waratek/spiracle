GET http://{{host}}:{{port}}/spiracle/Get_int_groupby?id=name%20union%20all%20select%20null,%20to_char(dob)%20from%20users

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int_groupby?id=name%20union%20select%20null,%20to_char(dob)%20from%20users

HTTP *
[Asserts]
status == {{block_status}}
