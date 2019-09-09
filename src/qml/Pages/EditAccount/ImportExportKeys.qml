import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Qt.labs.platform 1.1
import "../../Base"
import "../../Popups"
import "../../utils.js" as Utils

HBox {
    property var exportButton: null

    horizontalSpacing: currentSpacing
    verticalSpacing: currentSpacing

    buttonModel: [
        { name: "export", text: qsTr("Export"), iconName: "export-keys"},
        { name: "import", text: qsTr("Import"), iconName: "import-keys"},
    ]

    buttonCallbacks: ({
        export: button => {
            exportButton = button
            exportFileDialog.dialog.open()
        },
        import: button => { importFileDialog.dialog.open() },
    })


    HLabel {
        wrapMode: Text.Wrap
        text: qsTr(
            "The decryption keys for messages you received in encrypted " +
            "rooms can be exported to a passphrase-protected file.\n\n" +

            "You can then import this file on any Matrix account or " +
            "client, to be able to decrypt these messages again."
        )

        Layout.fillWidth: true
    }

    HFileDialogOpener {
        id: exportFileDialog
        fill: false
        dialog.title: qsTr("Save decryption keys file as...")
        dialog.fileMode: FileDialog.SaveFile
        onFileChanged: {
            exportPasswordPopup.file = file
            exportPasswordPopup.open()
        }
    }

    HFileDialogOpener {
        id: importFileDialog
        fill: false
        dialog.title: qsTr("Select a decryption keys file to import")
        onFileChanged: {
            importPasswordPopup.file = file
            importPasswordPopup.open()
        }
    }

    PasswordPopup {
        property url file: ""

        id: exportPasswordPopup
        details.text: qsTr("Please enter a passphrase to protect this file:")
        okText: qsTr("Export")

        onAcceptedPasswordChanged:
            encryptionUI.exportKeys(file, acceptedPassword, exportButton)
    }

    PasswordPopup {
        property url file: ""

        function verifyPassword(pass, callback) {
            py.callCoro(
                "check_exported_keys_passphrase",
                [file.toString().replace(/^file:\/\//, ""), pass],
                callback
            )
        }

        id: importPasswordPopup
        details.text: qsTr(
            "Please enter the passphrase that was used to protect this file:"
        )
        okText: qsTr("Import")

        onAcceptedPasswordChanged:
            encryptionUI.importKeys(file, acceptedPassword)
    }
}
