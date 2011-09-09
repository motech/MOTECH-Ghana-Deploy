clear /augeas/load

set /augeas/load/log4j-motech/lens "properties.lns"
set /augeas/load/log4j-motech/incl[1] "/tmp/staging/WEB-INF/classes/log4j-motech.properties"

set /augeas/load/motech-settings/lens "properties.lns"
set /augeas/load/motech-settings/incl[1] "/tmp/staging/WEB-INF/classes/motech-settings.properties"

set /augeas/load/omp-config/lens "Xml.lns"
set /augeas/load/omp-config/incl[1] "/tmp/staging/META-INF/omp-config.xml"

load

set /files/tmp/staging/WEB-INF/classes/log4j-motech.properties/log4j.logger.org.apache.cxf "INFO, wslogfile"
set /files/tmp/staging/WEB-INF/classes/log4j-motech.properties/log4j.logger.org.motechproject.mobile.omp.service.SMSMessagingServiceImpl DEBUG
set /files/tmp/staging/WEB-INF/classes/log4j-motech.properties/log4j.logger.org.motechproject.mobile.omi.service.OMIServiceImpl DEBUG

set /files/tmp/staging/WEB-INF/classes/motech-settings.properties/hibernate.dialect org.hibernate.dialect.MySQLDialect
set /files/tmp/staging/WEB-INF/classes/motech-settings.properties/jdbc.driverClassName com.mysql.jdbc.Driver
set /files/tmp/staging/WEB-INF/classes/motech-settings.properties/jdbc.username motechmobile
set /files/tmp/staging/WEB-INF/classes/motech-settings.properties/jdbc.password mmobilepass
set /files/tmp/staging/WEB-INF/classes/motech-settings.properties/jdbc.url jdbc:mysql://localhost:3306/motechmobiledb
set /files/tmp/staging/WEB-INF/classes/motech-settings.properties/contexts update
set /files/tmp/staging/WEB-INF/classes/motech-settings.properties/rancard.gateway.user drmgrameen
set /files/tmp/staging/WEB-INF/classes/motech-settings.properties/rancard.gateway.password dr3mgr3
set /files/tmp/staging/WEB-INF/classes/motech-settings.properties/intellivr.gateway.reportURL http://localhost/motech-mobile-webapp/intellivr
set /files/tmp/staging/WEB-INF/classes/motech-settings.properties/intellivr.gateway.sessionCacheFile file:/tmp/.Motech/ivrsession.cache
set /files/tmp/staging/WEB-INF/classes/motech-settings.properties/registrar.webservice.wsdlUrl http://localhost/openmrs/ws/RegistrarService?wsdl

set /files/tmp/staging/META-INF/omp-config.xml/beans/bean/property/#attribute/ref[. = "intellIVRTestServer"] intellIVRServer
set /files/tmp/staging/META-INF/omp-config.xml/beans/bean/property/#attribute/ref[. = "dummyHandler"][preceding-sibling::*[. = "textHandler"]] rancardHandler
set /files/tmp/staging/META-INF/omp-config.xml/beans/bean/property/#attribute/ref[. = "dummyManager"] rancardGateway
