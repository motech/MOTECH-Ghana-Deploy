module Test_properties = 
	let conf = "
# Test tomcat properties file
#tomcat.commented.value=1
	# config
tomcat.port = 8080
tomcat.application.name=testapp
	tomcat.application.description=my test application
###Multi hash comment
hibernate.show_sql=false 
jdbc.password=
"

test Properties.lns get conf = 
	{ } 
  	{ "#comment" = "Test tomcat properties file" }
  	{ "#comment" = "tomcat.commented.value=1" }
  	{ "#comment" = "config" }
	{ "tomcat.port" = "8080" }
	{ "tomcat.application.name" = "testapp" }
	{ "tomcat.application.description" = "my test application" }
    { "#comment" = "##Multi hash comment" }
    { "hibernate.show_sql" = "false" }
    { "jdbc.password" = "" }
 
test Properties.lns put conf after 
	set "tomcat.port" "99";
	set "tomcat.application.host" "foo.network.com"
	= "
# Test tomcat properties file
#tomcat.commented.value=1
	# config
tomcat.port = 99
tomcat.application.name=testapp
	tomcat.application.description=my test application
###Multi hash comment
hibernate.show_sql=false 
jdbc.password=
tomcat.application.host=foo.network.com
"
