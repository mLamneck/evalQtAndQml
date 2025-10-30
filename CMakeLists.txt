cmake_minimum_required(VERSION 3.16)

project(TestVbus VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 Charts Graphs)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appTestVbus
    main.cpp
)

qt_add_qml_module(appTestVbus
    URI TestVbus
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES BaseWidget.qml
        QML_FILES LayoutManager.qml
        QML_FILES MySlider.qml
        QML_FILES Vedit.qml
        QML_FILES VsliderH.qml
        QML_FILES MyChart.qml
        QML_FILES MyGraph.qml
        QML_FILES
        QML_FILES TestRect.qml
        QML_FILES VbusAppWindow.qml
        QML_FILES TabBar.qml
        SOURCES filehandler.h filehandler.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appTestVbus PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appTestVbus
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appTestVbus
    PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Charts
    Qt6::Graphs
)

include(GNUInstallDirs)
install(TARGETS appTestVbus
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
