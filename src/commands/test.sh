if [[ $OSTYPE == 'darwin'* ]]; then
    base64_path=/tmp/profile.base64
    provisioning_profile_path=/tmp/profile.mobileprovision

    echo \<<parameters.base64_encoded_provisioning_profile>> >> $base64_path

    base64 -d -i $base64_path -o $provisioning_profile_path

    mobileprovision_uuid=`/usr/libexec/PlistBuddy -c "Print UUID" /dev/stdin <<< $(/usr/bin/security cms -D -i $provisioning_profile_path)`
    echo "UUID Found: $mobileprovision_uuid"

    output="$HOME/Library/MobileDevice/Provisioning Profiles/$mobileprovision_uuid.mobileprovision"

    echo "export PROVISIONING_PROFILE_UUID=$mobileprovision_uuid" >> $BASH_ENV
    source $BASH_ENV

    echo "Copy from $provisioning_profile_path to $output"

    cp "$provisioning_profile_path" "$output"

    rm $base64_path
    rm $provisioning_profile_path
fi