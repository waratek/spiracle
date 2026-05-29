GET http://{{host}}:{{port}}/spiracle/Get_int?id=2'%20OR%20name%20LIKE%20'%25

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=1'%20or%20name%20like%20'%25

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=1'%20or%20id%20like%20'%25

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id='%20or%20name%20like%20'%25

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=1'%20OR%20120=(SELECT%20COUNT(*)%20FROM%20users)%20--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=1'%20AND%20users.cvv%20IS%20NULL%20--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=1'%20AND%20DOB%20IS%20NULL%20--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=1'%20AND%20cvv%20IS%20NULL%20--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=1'%20OR%20'x'='x'--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=1'%20or%201=1%20or%20'x'='y'--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=1'%20UNION%20ALL%20SELECT%20*%20from%20users%20where%20id=1%20or%201=1--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=1'%20or%201=1%20or%20''=''--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id='%20or%201=1%20or%20''=''--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=(%22hi%22)'%20or%20('a'='a')--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=a'%20or%20'a'%20=%20'a'--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=joe'%20or%20'1'='1'--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=1'%20UNION%20SELECT%20*%20from%20users%20where%20id=1%20or%201=1--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=hi'%20or%201=1--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=hi'%20or%20'a'='a'--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=a'%20or%201=1--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=%20or%20'x'='x'--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id='%20or%200=0%20--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=a'%20or%203=3--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=Joe'%20or%200=0%20--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=Joe'%20or%20'a'='a'--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=1'%20or%20''=''--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id='%20or%201=1--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id='%20or%201=1--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id=%27%20or%201=1--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/Get_int?id='%20or%203=3--

HTTP *
[Asserts]
status == {{block_status}}
