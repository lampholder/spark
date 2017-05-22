branch="new-guest-access"

mkdir $branch
cd $branch

# Install dependencies:
#  - git
#  - npm

git clone https://github.com/vector-im/riot-web.git
git clone https://github.com/matrix-org/matrix-react-sdk.git
git clone https://github.com/matrix-org/matrix-js-sdk.git

(cd riot-web && git checkout $branch)
(cd matrix-react-sdk && git checkout $branch)
(cd matrix-js-sdk && git checkout $branch || git checkout develop)

(cd riot-web && npm install)
(cd matrix-react-sdk && npm install)

rm -rf riot-web/node_modules/matrix-react-sdk
ln -s matrix-react-sdk riot-web/node_modules/matrix-react-sdk

# Put the fresh version of matrix-{react,js}-sdk where they need to be
rm -rf riot-web/node_modules/matrix-js-sdk
rm -rf matrix-react-sdk/node_modules/matrix-js-sdk
ln -s matrix-js-sdk riot-web/node_modules/matrix-js-sdk
ln -s matrix-js-sdk matrix-react-sdk/node_modules/matrix-js-sdk

# Setup the thing with the sample config
(cd riot-web && cp config.sample.json config.json)

# Build it all properly:
(cd matrix-js-sdk && npm install && npm run build)
(cd matrix-react-sdk && npm install npm run build)
(cd riot-web && npm install && npm run build)
