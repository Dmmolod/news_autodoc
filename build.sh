if ! command -v xcodegen &> /dev/null
then
    echo "xcodegen could not be found"
    echo "get it from https://github.com/yonaskolb/XcodeGen#installing"
    exit 1
fi
xcodegen
