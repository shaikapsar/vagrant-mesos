sudo apt-get install wget -y
ZOOKEEPER_DIST_URL=http://www-eu.apache.org/dist/zookeeper
ZOOKEEPER_RELEASE=stable
ZOOKEEPER_VERSION=3.4.10
ZOOKEEPER_ARTIFACT_URL=$ZOOKEEPER_DIST_URL/$ZOOKEEPER_RELEASE/zookeeper-$ZOOKEEPER_VERSION.tar.gz
ZOOKEEPER_SHA256SUMS_URL=$ZOOKEEPER_DIST_URL/$ZOOKEEPER_RELEASE/zookeeper-$ZOOKEEPER_VERSION.tar.gz.sha1

wget $ZOOKEEPER_ARTIFACT_URL
sudo tar xvf zookeeper-$ZOOKEEPER_VERSION.tar.gz
sudo rm -rf /usr/local/zookeeper
sudo mv zookeeper-$ZOOKEEPER_VERSION /usr/local/zookeeper



