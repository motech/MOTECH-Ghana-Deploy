clear /augeas/load

set /augeas/load/registrar-bean/lens "Xml.lns"
set /augeas/load/registrar-bean/incl[1] "/tmp/staging/registrar-bean.xml"

load

set /files/tmp/staging/registrar-bean.xml/beans/bean/property/#attribute/value[. = 'http://localhost:8180/motech-mobile-webapp/webservices/messaging?wsdl'] http://localhost/motech-mobile-webapp/webservices/messaging?wsdl


