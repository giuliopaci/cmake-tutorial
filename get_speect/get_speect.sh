#!/bin/sh

# Detect platform
PLATFORM="`uname -m`-`uname -s`"
BASEDIR=`pwd`
echo Compiling for "$PLATFORM" on "$BASEDIR"

# Prepare directory layout
mkdir -p voices sources downloads/voices builds/"$PLATFORM" install

case "$1" in
    "download")
        # Get speect from Mivoq' github repository
        git clone https://github.com/mivoq/speect sources/speect
        ;;
    "download_deps")
        # Get hts_engine_API-1.03 sources from sf.net
        curl -L -C - "https://sourceforge.net/projects/hts-engine/files/hts_engine%20API/hts_engine_API-1.03/hts_engine_API-1.03.tar.gz/download" -o downloads/hts_engine_API-1.03.tar.gz

        # Download voices from http://hlt.mirror.ac.za/TTS/Speect/
        # Have a look at http://speect.sourceforge.net/download.html#download
        mkdir -p downloads/voices
        for file in README.cmu_arctic_slt-1.0           \
                        README.meraka_lwazi2_alta-1.0   \
                        README.meraka_lwazi2_john-1.2   \
                        cmu_arctic_slt-1.0.tar.gz       \
                        meraka_lwazi2_alta-1.0.tar.gz   \
                        meraka_lwazi2_john-1.2.tar.gz
        do
            curl http://hlt.mirror.ac.za/TTS/Speect/"$file" -C - -o downloads/voices/"$file"
        done
        ;;
    "extract_deps")
        # Extract hts_engine_API-1.03 sources
        tar zxvf downloads/hts_engine_API-1.03.tar.gz -C sources

        # Extract voices
        mkdir -p voices
        for file in downloads/voices/*.tar.gz
        do
            tar zxvf "$file" -C voices
        done
        ;;
    "build_deps")
        # Compile and install hts_engine_API-1.03
        mkdir -p builds/"$PLATFORM"/hts_engine_API-1.03
        cd builds/"$PLATFORM"/hts_engine_API-1.03
        CFLAGS="-fPIC" "$BASEDIR"/sources/hts_engine_API-1.03/configure --prefix="$BASEDIR"/install
        make -j
        make install
        cd "$BASEDIR"
        ;;
    "build")
        # Compile and install speect
        BASEDIR=`pwd`
        mkdir -p builds/"$PLATFORM"/speect
        cd builds/"$PLATFORM"/speect
        cmake "$BASEDIR"/sources/speect                                           \
              -DCMAKE_BUILD_TYPE=Debug                                            \
              -DCMAKE_INSTALL_PREFIX="$BASEDIR"/install                           \
              -DWANT_TESTS=ON                                                     \
              -DWANT_EXAMPLES=ON                                                  \
              -DERROR_HANDLING=ON                                                 \
              -DHTS_ENGINE_INCLUDE_103:PATH="$BASEDIR"/install/include            \
              -DHTS_ENGINE_LIB_103:FILEPATH="$BASEDIR"/install/lib/libHTSEngine.a
        make -j
        make -j test
        make -j install
        cd "$BASEDIR"
        ;;
    "run")
        # Run an example
        ./builds/"$PLATFORM"/speect/engine/tests/speect_test -m text -t "Hi everybody." -v "`pwd`"/voices/cmu_arctic_slt/voice.json -o tmp.wav
        # Print example line
        cat <<EOF
./builds/"$PLATFORM"/speect/engine/tests/speect_test -m text -t "Hi everybody." -v "`pwd`"/voices/cmu_arctic_slt/voice.json -o tmp.wav
EOF
        ;;
    *)
        "$0" download
        "$0" download_deps
        "$0" extract_deps
        "$0" build_deps
        "$0" build
        "$0" run
        ;;
esac
