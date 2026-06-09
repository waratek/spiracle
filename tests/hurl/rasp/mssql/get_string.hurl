GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name=x'%20or%20name%20like%20'%25'--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name=%3C%3E%22%2527%25%3B)(%26%2B

HTTP *
[Asserts]
status == 200

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name=x'%20AND%20100=(SELECT%20COUNT(*)%20FROM%20address)%20--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name=x'%20OR%20cvv%20IS%20NULL--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name=anything'%20OR%20'x'='x

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name=x'%20or%201=1%20or%20'x'='y

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name='%20UNION%20ALL%20SELECT%20*%20from%20users%20where%20id=1%20or%201=1--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name='or%201=1%20or%20''='

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name=a'%20or%20'a'%20=%20'a

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name='%20or%20'1'='1'--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name='%20UNION%20SELECT%20*%20from%20users--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name=a'%20or%201=1--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name=%27%20or%20%27x%27=%27x

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name='or%200=0%20--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name=a'%20or%203=3--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name='%20or%201=1--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name='%20or%201%20--'

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name='%20or%20'a'='a'--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name=%27%20or%201=1--

HTTP *
[Asserts]
status == {{block_status}}

GET http://{{host}}:{{port}}/spiracle/MsSql_Get_string?name=x'%20or%203=3--

HTTP *
[Asserts]
status == {{block_status}}
