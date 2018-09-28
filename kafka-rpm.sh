#!/usr/bin/env bash
#
# This script packages a Kafka release tarball as RHEL6/CentOS6 RPM using fpm.
#
# NOTE: To simplify switching JDK versions for use with Kafka WE DO NOT ADD A DEPENDENCY ON A
#       SPECIFIC JDK VERSION to the Kafka RPM.  You must manage the installation of JDK manually!
#
#       Before this decision we specified the JDK dependency e.g. via the fpm option:
#           -d "java-1.6.0-openjdk"

### CONFIGURATION BEGINS ###

INSTALL_ROOT_DIR=/opt/kafka
MAINTAINER="deependra.saraswat@paytm.com"

### CONFIGURATION ENDS ###

function print_usage() {
  myself=`basename $0`
  echo "Usage: $myself <kafka-package-download-url>"
  echo
  echo "Examples:"
  echo "  \$ $myself http://www.eu.apache.org/dist/kafka/0.8.1/kafka_2.10-0.8.1.tgz"
}

if [ $# -ne 1 ]; then
  print_usage
  exit 1
fi

# http://www.us.apache.org/dist/kafka/0.8.0/kafka_2.8.0-0.8.0.tar.gz
KAFKA_DOWNLOAD_URL="$1"
KAFKA_TARBALL=`basename $KAFKA_DOWNLOAD_URL`
SCALA_VERSION=`echo $KAFKA_TARBALL | sed -r 's/^kafka_([0-9\.]+)-(.*).tgz$/\1/'`
KAFKA_VERSION=`echo $KAFKA_TARBALL | sed -r 's/^kafka_([0-9\.]+)-(.*).tgz$/\2/'`

echo "Creating an RPM for Kafka release version $KAFKA_VERSION, built for Scala $SCALA_VERSION..."

# Prepare environment
OLD_PWD=`pwd`
BUILD_DIR=`mktemp -d /tmp/kafka-build.XXXXXXXXXX`
cd $BUILD_DIR

cleanup_and_exit() {
  local exitCode=$1
  rm -rf $BUILD_DIR
  cd $OLD_PWD
  exit $exitCode
}

# Download and extract the requested Kafka release tarball
wget $KAFKA_DOWNLOAD_URL || cleanup_and_exit $?
tar -xzf $KAFKA_TARBALL || cleanup_and_exit $?

# Build the RPM
KAFKA_DIR=${KAFKA_TARBALL%.tgz}
cd $KAFKA_DIR
# Fix permissions of shell scripts
chmod 755 bin/*.sh
/usr/local/bin/fpm -s dir -t rpm -a all \
    -n kafka \
    -v $KAFKA_VERSION \
    --iteration "1.miguno" \
    --maintainer "$MAINTAINER" \
    --vendor "Kafka Project" \
    --url http://kafka.apache.org \
    --description "A high-throughput distributed messaging system (RPM built from release for Scala $SCALA_VERSION)" \
    -p $OLD_PWD/kafka-VERSION.el6.ARCH.rpm \
    -a "x86_64" \
    --prefix $INSTALL_ROOT_DIR \
    * || cleanup_and_exit $?

echo "You can verify the proper creation of the RPM file with:"
echo "  \$ rpm -qpi kafka-*.rpm    # show package info"
echo "  \$ rpm -qpR kafka-*.rpm    # show package dependencies"
echo "  \$ rpm -qpl kafka-*.rpm    # show contents of package"

# Clean up
cleanup_and_exit 0
