GET http://{{host}}:{{port}}/spiracle/Get_Union?id='2'%20OR%20'name'%20LIKE%20'Joe'

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='1'%20or%20'name'%20like%20'Joe'

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='1'%20or%20id%20like%201

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='1'%20or%20'name'%20like'Joe'

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='1'%20OR%20120=(SELECT%20COUNT(*)%20FROM%20users)

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='1'%20AND%20'users.cvv'%20IS%20NULL

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='1'%20AND%20'DOB'%20IS%20NULL

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='1'%20AND%20'cvv'%20IS%20NULL

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='1'%20OR%20'x'='x'

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='1'%20or%201=1%20or%20'x'='y'

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='1'%20or%201=1%20or%20''=''--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='%20or%201=1%20or%20''=''--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='(%22hi%22)'%20or%20('a'='a')--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='a'%20or%20'a'%20=%20'a'

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='joe'%20or%20'1'='1'

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='hi'%20or%201=1--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='hi'%20or%20'a'='a'--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='a'%20or%201=1--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id=''%20or%20'x'='x'--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id=''%20or%200=0%20--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='a'%20or%203=3--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='Joe'%20or%200=0%20--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='Joe'%20or%20'a'='a'--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id=1%20or%20'a'='a'

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id=1%20or%20'1'='1'

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='%20or%201=1--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id=%27%20or%201=1--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='%20%20or%201=1--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_Union?id='%20or%203=3--

HTTP *
[Asserts]
status == {{block_status}}
