FILE=$(ls | grep hyperledger-fabric-sdk- | tail -1)
echo Deploying $FILE
gem push $FILE
