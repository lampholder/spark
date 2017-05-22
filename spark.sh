#!/bin/bash
# Dependencies: npm, git

branch=$1

mkdir $branch
echo "Building..." >> $branch/index.html

mkdir $branch.building
cd $branch.building

git clone https://github.com/vector-im/riot-web.git
git clone https://github.com/matrix-org/matrix-react-sdk.git
git clone https://github.com/matrix-org/matrix-js-sdk.git

(cd riot-web && git checkout $branch || git checkout develop)
(cd matrix-react-sdk && git checkout $branch || git checkout develop)
(cd matrix-js-sdk && git checkout $branch || git checkout develop)

(cd riot-web && npm install)
(cd matrix-react-sdk && npm install)
(cd matrix-js-sdk && npm install)

rm -rf riot-web/node_modules/matrix-js-sdk
rm -rf riot-web/node_modules/matrix-react-sdk
rm -rf matrix-react-sdk/node_modules/matrix-js-sdk

(cd riot-web/node_modules && ln -s ../../matrix-react-sdk && ln -s ../../matrix-js-sdk)
(cd matrix-react-sdk/node_modules && ln -s ../../matrix-js-sdk)

# Setup the thing with the sample config
(cd riot-web && cp config.sample.json config.json)

# Temporary hack
(cd matrix-js-sdk && npm i source-map-loader)

# Build it all properly:
(cd matrix-js-sdk && npm run build)
(cd matrix-react-sdk && npm run build)
(cd riot-web && npm run build)

rm -rf $branch
mv $branch.building $branch
