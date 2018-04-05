TEMPLATE = aux
TARGET = Gigs

RESOURCES += Gigs.qrc \
    gigs.qrc

QML_FILES += $$files(*.qml,true) \
	     $$files(*.png,true) \
             $$files(*.js,true)

CONF_FILES +=  Gigs.apparmor \
               Gigs.png

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)               

OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               Gigs.desktop

#specify where the qml/js files are installed to
qml_files.path = /Gigs
qml_files.files += $${QML_FILES}

#specify where the config files are installed to
config_files.path = /Gigs
config_files.files += $${CONF_FILES}

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /Gigs
desktop_file.files = $$OUT_PWD/Gigs.desktop
desktop_file.CONFIG += no_check_exist

INSTALLS+=config_files qml_files desktop_file

DISTFILES += \
    ManageGigsUrl.qml \
    EditSavedGigsUrl.qml \
    GigsUrlDelegate.qml \
    OperationResult.qml \
    HelpPage.qml \
    HighlightSavedGigsUrl.qml
