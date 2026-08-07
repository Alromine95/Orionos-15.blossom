# ------------------------------------------------------------------------------
# Variant: OrionOs
# ------------------------------------------------------------------------------
run_orion() {
    common_prep
    rm -rf .repo/local_manifests
    repo init -u https://github.com/OrionOS-Project/manifest -b vic --git-lfs --depth=1
    git clone https://github.com/Alromine95/android_local_manifests_blossom.git -b main .repo/local_manifests
    repo sync -c -j64 --force-sync --no-clone-bundle --no-tags
    /opt/crave/resync.sh

   
    . build/envsetup.sh
    sed -i '/^cc_prebuilt_library_shared {$/{N;/name: "libutils-v30",/{:a;N;/\n}$/!ba;d}}' hardware/lineage/compat/Android.bp
    sed -i '$a ORION_MAINTAINER := Qbhi' device/xiaomi/blossom/lineage_blossom.mk
    common_env_exports
    export TARGET_IS_LOW_RAM=true
    #lunch lineage_blossom-bp4a-user
   # m installclean
    local Orion_devices=(${ROM_DEVICES[orion]})
    if [ "$DEVICE" != "all" ]; then
        orion_devices=("$DEVICE")
    fi

    echo "▶ Orion: building device(s): ${orion_devices[*]}"
    for dev in "${orion_devices[@]}"; do
        echo "▶ orion: orion $dev user va"
        Orion "$dev" user va
        m installclean
        ax -br
    done
    run_upload_orion
}


