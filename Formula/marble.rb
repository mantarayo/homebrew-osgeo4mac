class Marble < Formula
  homepage "http://marble.kde.org/"
  url "http://download.kde.org/stable/4.13.1/src/marble-4.13.1.tar.xz"
  sha1 "9d7cedc13098ddf1d759b44d570b9cf68d7f3ae7"
  version "1.7.0"

  head "git://anongit.kde.org/marble"

  option "with-debug", "Enable debug build type"
  option "without-tools", "Build without extra Marble Tools"
  option "with-examples", "Build Marble library C++ examples"
  option "with-tests", "Build and run unit tests"

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "quazip" => :recommended
  depends_on "shapelib" => :recommended
  depends_on "gpsd" => :recommended
  depends_on "protobuf" if build.with? "tools"

  def install
    # basic std_cmake_args
    args = %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_BUILD_TYPE=#{(build.with?('debug')) ? 'RelWithDebInfo' : 'None' }
      -DCMAKE_FIND_FRAMEWORK=LAST
      -DCMAKE_VERBOSE_MAKEFILE=TRUE
      -Wno-dev
    ]
    # app build
    args.concat %W[
      -DQTONLY=ON
      -DBUILD_MARBLE_TESTS=#{((build.with? "tests") ? "ON" : "OFF")}
      -DMOBILE=OFF
      -DWITH_Phonon=OFF
      -DWITH_libgps=OFF
      -DWITH_QextSerialPort=OFF
      -DWITH_QtLocation=OFF
      -DWITH_liblocation=OFF
      -DWITH_libwlocate=OFF
      -DWITH_DESIGNER_PLUGIN=OFF
      -DBUILD_MARBLE_TOOLS=#{((build.with? "tools") ? "ON" : "OFF")}
      -DBUILD_MARBLE_EXAMPLES=#{((build.with? "examples") ? "ON" : "OFF")}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      # system "bbedit", "CMakeCache.txt"
      # raise
      system "make"
      system "make", "install"
    end
  end
end
