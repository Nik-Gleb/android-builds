#!/bin/bash

rm -f "./.production.jks" && rm -f "./build.gradle" && rm -f "./gradle.properties"
rm -rf ./gradle && rm -f "./gradlew" && rm -f "./gradlew.bat" && rm -f "./settings.gradle"

mv $2/build.gradle build.gradle
mv $2/gradle.properties gradle.properties
mv $2/production.jks .production.jks

if [ -d ".git/hooks" ]; then
  rm -rf .git/hooks/commit-msg
  mv android-builds/commit-msg .git/hooks/commit-msg
  chmod +x .git/hooks/commit-msg
fi

rm -rf $2

while IFS='=' read -r key value
do
  key=$(echo $key | tr '.' '_')
  eval "${key}='${value}'"
done < "./gradle.properties"

if [[ -z "${PLATFORM_API}" ]]; then
  platformApi=$1
else
  platformApi=$PLATFORM_API
fi

if [[ -z "${CIRCLE_SHA1}" ]]; then
 gradleHeap="16g"  
 jvmHeap="12g"
else
 gradleHeap="4g"  
 jvmHeap="4g"
fi

echo "org.gradle.jvmargs=-Xmx$gradleHeap -noverify -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8" >> gradle.properties
echo "jvmHeapSize=$jvmHeap" >> gradle.properties
echo "sdkVer=$platformApi" >> gradle.properties
echo "minSdk=`expr $platformApi - $supportLastYears \* 2`" >> gradle.properties

$ANDROID_HOME/tools/bin/sdkmanager --update && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses
$ANDROID_HOME/tools/bin/sdkmanager \
  "tools" \
  "platforms;android-$platformApi" \
  "platform-tools" \
  "patcher;v4" \
  "ndk-bundle" \
  "extras;google;google_play_services" \
  "extras;google;m2repository" \
  "extras;android;m2repository" \
  "cmake;$cmakeVer" \
  "build-tools;$buildToolsVer" 

gradlePackage=bin
gradleName=gradle-$gradle
gradleFullName=$gradleName-$gradlePackage.zip
gradleDistr=://services.gradle.org/distributions/$gradleFullName
gradleDistrAll=https\://services.gradle.org/distributions/$gradleName-all.zip
wget https$gradleDistr && unzip $gradleFullName && rm -f $gradleFullName
./$gradleName/bin/gradle --stop
./$gradleName/bin/gradle wrapper --gradle-version $gradle
./$gradleName/bin/gradle --stop
rm -rf ./$gradleName

head -n -1 build.gradle > build.temp ; mv build.temp build.gradle
echo "apply plugin: 'com.android.library'" >> build.gradle
echo "android {" >> build.gradle
echo "  compileSdkVersion Integer.parseInt(sdkVer)" >> build.gradle
echo "  buildToolsVersion buildToolsVer" >> build.gradle
echo "  sourceSets {main {manifest.srcFile './AndroidManifest.xml'}}" >> build.gradle
echo "}" >> build.gradle
echo "<manifest package=\"android\"/>" >> AndroidManifest.xml

./gradlew createMockableJar

head -n -6 build.gradle > build.temp ; mv build.temp build.gradle
echo "task clean {delete rootProject.buildDir}" >> build.gradle
rm -rf ./AndroidManifest.xml

#cd ./build/generated
#mv `ls | head -n 1` ../../.android.jar
#cd ../.. && rm -rf ./build

wrapProp=./gradle/wrapper/gradle-wrapper.properties
head -n -1 $wrapProp > $wrapProp.temp ; mv $wrapProp.temp $wrapProp
echo "distributionUrl=$gradleDistrAll" >> $wrapProp

for i in * ; do
  if [ -d "$i" ]; then
    if [ -f $i/build.gradle ]; then
      echo "include ':$i'" >> settings.gradle
    fi
  fi
done
