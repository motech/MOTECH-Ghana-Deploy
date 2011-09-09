#!/bin/bash

WGET=/usr/bin/wget
AUGTOOL=/usr/bin/augtool
UNZIP=/usr/bin/unzip
ZIP=/usr/bin/zip

if [ -f /etc/debian_version ] 
then
    READLINK=/usr/bin/realpath
    READLINKARGS=
    DOS2UNIX=/usr/bin/fromdos
fi

if [ -f /etc/redhat-release ]
then
    READLINK=/usr/bin/readlink
    READLINKARGS=-f
    DOS2UNIX=/usr/bin/dos2unix
fi

DIRNAME=/usr/bin/dirname


MYPATH=`$READLINK $READLINKARGS $0`
SCRIPTDIR=`$DIRNAME $MYPATH`
BASEDIR=`pwd`

usage()
{
cat << EOF
usage: $0 options

This script does all of the manual steps required before a motech release
can be completed.

You must provide a name for the release and a version for either the omod or mobile

OPTIONS:
   -h      Show this message
   -r      Release name (should be unique across all releases)
   -o      OMOD version
   -m      Motech Mobile version
   -v      Verbose
EOF
}

error()
{
    exit 1
}

RELEASE=
OMOD=
MOBILE=
VERBOSE=
while getopts “hr:o:m:v” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         r)
             RELEASE=$OPTARG
             ;;
         o)
             OMOD=$OPTARG
             ;;
         m)
             MOBILE=$OPTARG
             ;;
         v)
             VERBOSE=1
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [ -z $RELEASE ] || ([ -z $OMOD ] && [ -z $MOBILE ])
then
     usage
     exit 1
fi

if [ ! -z $VERBOSE ] ; then echo "Setting up directories"; fi
if [ ! -d $BASEDIR/$RELEASE ]
then
    mkdir $BASEDIR/$RELEASE
fi

if [ -h $BASEDIR/staging ]; then rm $BASEDIR/staging; fi
if [ -h /tmp/staging ]; then rm /tmp/staging; fi
ln -s $BASEDIR/$RELEASE $BASEDIR/staging
ln -s $BASEDIR/$RELEASE /tmp/staging

cd $BASEDIR/staging

if [ ! -z $OMOD ]
then
    if [ ! -z $VERBOSE ] ; then echo "Prepping OMOD v$OMOD"; fi

    # Get the artifact
    $WGET http://nexus.motechproject.org/content/repositories/releases/org/motechproject/motech-server-omod/$OMOD/motech-server-omod-$OMOD.omod

    # Clean up any existing files
    rm -f registrar-bean.xml

    # Extract configs that need updating
    if [ ! -z $VERBOSE ] ; then echo "Extracing config"; fi
    $UNZIP motech-server-omod-$OMOD.omod registrar-bean.xml
    $DOS2UNIX registrar-bean.xml

    if [ ! -z $VERBOSE ] ; then echo "Modifying config"; fi
    $AUGTOOL -A -L -n -s -f $SCRIPTDIR/motech-omod.aug -I $SCRIPTDIR/lenses/
    # Verify clean exit
    if [ $? -ne 0 ] 
    then
        ERROR=1
        echo "Error reported from augtool.  Exiting"
        error
    fi

    # Repack
    if [ ! -z $VERBOSE ] ; then echo "Repacking config"; fi
    $ZIP -u motech-server-omod-$OMOD.omod registrar-bean.xml
fi

if [ ! -z $MOBILE ]
then
    if [ ! -z $VERBOSE ] ; then echo "Prepping MOTECH Mobile v$OMOD"; fi

    # Get the artifact
    $WGET http://nexus.motechproject.org/content/repositories/releases/org/motechproject/mobile/motech-mobile-webapp/$MOBILE/motech-mobile-webapp-$MOBILE.war

    # Clean up any existing files
    rm -f WEB-INF/classes/log4j-motech.properties
    rm -f WEB-INF/classes/motech-settings.properties
    rm -f WEB-INF/lib/motech-mobile-omp-$MOBILE.jar
    rm -f META-INF/omp-config.xml

    # Extract configs that need updating   
    if [ ! -z $VERBOSE ] ; then echo "Extracing config"; fi
    $UNZIP motech-mobile-webapp-$MOBILE.war WEB-INF/classes/log4j-motech.properties
    $UNZIP motech-mobile-webapp-$MOBILE.war WEB-INF/classes/motech-settings.properties
    $UNZIP motech-mobile-webapp-$MOBILE.war WEB-INF/lib/motech-mobile-omp-$MOBILE.jar
    $UNZIP WEB-INF/lib/motech-mobile-omp-$MOBILE.jar META-INF/omp-config.xml

    $DOS2UNIX WEB-INF/classes/log4j-motech.properties
    $DOS2UNIX WEB-INF/classes/motech-settings.properties
    $DOS2UNIX META-INF/omp-config.xml

    if [ ! -z $VERBOSE ] ; then echo "Modifying config"; fi
    $AUGTOOL -A -L -n -s -f $SCRIPTDIR/motech-mobile.aug -I $SCRIPTDIR/lenses/ 
    # Verify clean exit
    if [ $? -ne 0 ]
    then
        ERROR=1
        echo "Error reported from augtool.  Exiting"
        error
    fi

    # Repack
    if [ ! -z $VERBOSE ] ; then echo "Repacking config"; fi
    $ZIP -u WEB-INF/lib/motech-mobile-omp-$MOBILE.jar META-INF/omp-config.xml
    $ZIP -u motech-mobile-webapp-$MOBILE.war WEB-INF/classes/log4j-motech.properties
    $ZIP -u motech-mobile-webapp-$MOBILE.war WEB-INF/classes/motech-settings.properties
    $ZIP -u motech-mobile-webapp-$MOBILE.war WEB-INF/lib/motech-mobile-omp-$MOBILE.jar
fi

cd -