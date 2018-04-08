#!/bin/bash
PARENTDIR=$(dirname "$0")

cd "$PARENTDIR"

# Extract the packages to a temporary My-content directory
pkgutil --expand Packages/*.pkg /tmp/My-content
mv /tmp/My-Content/NVPrefPane.pkg /tmp/NVPrefPane.pkg
cp -rp /tmp/My-Content/*.pkg /tmp
mv /tmp/My-Content/*.pkg /tmp/Packages
mkdir /tmp/Payload-Extract
mv /tmp/Packages/Payload /tmp/Payload-Extract/Payload
mv /tmp/Payload-Extract/Payload /tmp/Payload-Extract/Payload.pax.gz
Open /tmp/Payload-Extract/Payload.pax.gz
Sleep 5
rm -rf ./Payload-Extract/Payload.pax.gz
cp -rp /tmp/*.pkg /tmp/My-content
rm -rf /tmp/*.pkg
rm -rf /tmp/Packages
mkdir /tmp/PackageRoot
cp -r /tmp/Payload-Extract/Payload/Library /tmp/PackageRoot
cp -r /tmp/Payload-Extract/Payload/System /tmp/PackageRoot
touch /tmp/distribution.xml
cat << EOF > /tmp/distribution.xml
<?xml version="1.0" encoding="utf-8" standalone="no"?>
<installer-gui-script minSpecVersion="1">
    <title>Packages</title>
    <pkg-ref id="com.nvidia.web-driver"/>
    <options customize="never" allow-external-scripts="no" hostArchitectures="i386"/>
    <domains enable_anywhere="true"/>
    <welcome file="Welcome.rtf"/>
    <background file="background" alignment="center" scaling="tofit"/>
    <choices-outline>
        <line choice="default">
            <line choice="com.nvidia.web-driver"/>
        </line>
    </choices-outline>
    <choice id="default"/>
    <choice id="com.nvidia.web-driver" visible="false">
        <pkg-ref id="com.nvidia.web-driver"/>
    </choice>
    <pkg-ref id="com.nvidia.web-driver" version="1" onConclusion="none">Packages.pkg</pkg-ref>
</installer-gui-script>
EOF

Sleep 2

# Repackage the Payload
pkgbuild --root /tmp/PackageRoot --identifier com.nvidia.web-driver --version 1 --install-location / /tmp/Packages.pkg
Sleep 2
productbuild --distribution  /tmp/distribution.xml --package-path /tmp /tmp/My-Packages.pkg
Sleep 2
rm -rf /tmp/Packages.pkg
pkgutil --expand /tmp/*.pkg /tmp/expandedcontent
mkdir /tmp/My-Payload
cp -rp /tmp/expandedcontent/Packages.pkg /tmp/My-payload
rm -rf /tmp/*.pkg
rm -r /tmp/expandedcontent


# Parse for NVWebDrivers package file in /tmp/My-content and save as a variable
NVWebDriverspkg=$(find /tmp/My-content/ -name '*NVWebDrivers*' | cut -d '/' -f 5)

# Remove the payload file in /tmp/My-content/*NVWebDrivers package and replace it with the modified payload file
rm -rf /tmp/My-content/$NVWebDriverspkg/Payload
cp -rp /tmp/My-Payload/Packages.pkg/Payload /tmp/My-content/$NVWebDriverspkg

# Parse the package version from the Distribution file and save it as a variable
PkgDistroVer=$(cat /tmp/My-content/Distribution | grep "var supportedOSBuildVer" | cut -f 2 -d '"')

# Parse the current macOS system version and save it as a variable
SystemVer=$(system_profiler SPSoftwareDataType | grep "System Version" | cut -f 2 -d "(" | cut -f 1 -d ")")

echo "The WebDriver was made for:$PkgDistroVer"

echo "We are changing it to:$SystemVer"

# Change the Info.plist of NVDAStartupWeb.kext version with the current macOS system version
sed -i -e "s/$PkgDistroVer/$SystemVer/" /tmp/Payload-Extract/Payload/Library/Extensions/NVDAStartupWeb.kext/Contents/Info.plist

# Change the package Distribution version with the current macOS system version
sed -i -e "s/$PkgDistroVer/$SystemVer/" /tmp/My-content/Distribution

# Remove the residual Distribution-e file
rm -rf /tmp/My-content/Distribution-e

# Remove the residual Info.plist-e file
rm -rf /tmp/Payload-Extract/Payload/Library/Extensions/NVDAStartupWeb.kext/Contents/Info.plist-e

# Repackage the modified package into a single package
pkgutil --flatten /tmp/My-content/ /tmp/Repackaged-WebDriver.pkg
Sleep 2

# Move the Repackaged WebDriver installer package to User Desktop
mv /tmp/Repackaged-WebDriver.pkg $HOME/Desktop
Sleep 2

# Remove the temporary files
rm -rf /tmp/My-content
rm -rf /tmp/My-Payload
rm -rf /tmp/PackageRoot
rm -rf /tmp/Payload-Extract
rm -rf /tmp/distribution.xml

# Notification that the packaging process is complete
osascript -e 'display notification "Re-packaging Complete" with title "Creation"  sound name "default"'
