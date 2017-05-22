branch="new-guest-access"

mkdir $branch
cd $branch

# Install dependencies:
#  - git
#  - npm

git clone https://github.com/vector-im/riot-web.git
git clone https://github.com/matrix-org/matrix-react-sdk.git
git clone https://github.com/matrix-org/matrix-js-sdk.git

mkdir riot-web/node_modules
mkdir matrix-react-sdk/node_modules
ln -rs matrix-js-sdk riot-web/node_modules/matrix-js-sdk
ln -rs matrix-js-sdk matrix-react-sdk/node_modules/matrix-js-sdk
ln -rs matrix-react-sdk riot-web/node_modules/matrix-react-sdk

(cd riot-web && git checkout $branch)
(cd matrix-react-sdk && git checkout $branch)
(cd matrix-js-sdk && git checkout $branch || git checkout develop)

# Setup the thing with the sample config
(cd riot-web && cp config.sample.json config.json)

# Build it all properly:
(cd matrix-js-sdk && npm install && npm run build)
(cd matrix-react-sdk && npm install npm run build)
(cd riot-web && npm install && npm run build)
