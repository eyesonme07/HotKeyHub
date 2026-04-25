cmake_minimum_required(VERSION 3.16)

project(HotKeyHub VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(ANDROID)
    set(BOOST_ROOT "C:/Boost/ndk_27c_boost_1.87.0/ndk_27c_boost_1.87.0")
    set(BOOST_INCLUDEDIR "${BOOST_ROOT}/include")
elseif(WIN32)
    set(BOOST_ROOT "C:/Boost/boost_1_90_0")
endif()

find_package(Qt6 REQUIRED COMPONENTS Quick Sql)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appHotKeyHub
    src/cpp/main.cpp
)

qt_add_qml_module(appHotKeyHub
    URI HotKeyHub
    QML_FILES
        src/QML/Main.qml
    SOURCES
        src/cpp/client.cpp
        src/cpp/backendasio.cpp
        src/header/client.h
        src/header/backendasio.h
        QML_FILES src/QML/StartPane.qml
        QML_FILES src/QML/EnterIpPane.qml
        QML_FILES src/QML/MainWindowPane.qml
        QML_FILES src/QML/ConnectPane.qml
        QML_FILES src/QML/CustomTabBar.qml
        QML_FILES src/QML/MediaPage.qml
        QML_FILES src/QML/TouchpadPage.qml
        QML_FILES src/QML/HotkeyPage.qml
        QML_FILES src/QML/HotKeyItem.qml
        SOURCES src/header/database.h
        SOURCES src/cpp/database.cpp
        SOURCES src/header/hotkeydatabase.h
        SOURCES src/cpp/hotkeydatabase.cpp
        SOURCES src/header/backenddatabase.h
        SOURCES src/cpp/backenddatabase.cpp
        SOURCES src/header/backend.h
        SOURCES src/cpp/backend.cpp
        RESOURCES src/icon/message-question.png
        QML_FILES src/QML/GuideSection.qml
)

qt_add_resources(appHotKeyHub "icons"
    PREFIX "/icons"
    BASE "src/icon"
    FILES
        src/icon/command.png
        src/icon/github.png
        src/icon/keyboard.png
        src/icon/log-out.png
        src/icon/monitor.png
        src/icon/music.png
        src/icon/navigation.png
        src/icon/plus.png
        src/icon/server.png
        src/icon/skip-back.png
        src/icon/skip-forward.png
        src/icon/terminal.png
        src/icon/volume-2.png
        src/icon/volume.png
        src/icon/wifi.png
        src/icon/play-pause.png
        src/icon/play.png
        src/icon/pause.png
        src/icon/message-question.png
        src/icon/trash.png
)

if(ANDROID)
    set_target_properties(appHotKeyHub PROPERTIES
        QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
    )
endif()

set_target_properties(appHotKeyHub PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.hotkeyhub
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

if(ANDROID)
    target_include_directories(appHotKeyHub PRIVATE ${BOOST_INCLUDEDIR})

elseif(WIN32)
    find_package(Boost REQUIRED)
    target_link_libraries(appHotKeyHub PRIVATE Boost::headers)
endif()

target_link_libraries(appHotKeyHub
    PRIVATE Qt6::Quick
)
target_link_libraries(appHotKeyHub
    PRIVATE Qt6::Sql
)

include(GNUInstallDirs)
install(TARGETS appHotKeyHub
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
