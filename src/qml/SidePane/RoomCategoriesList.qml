import QtQuick 2.7
import QtQuick.Layouts 1.3
import SortFilterProxyModel 0.2
import "../Base"

HListView {
    property string userId: ""

    id: roomCategoriesList

    model: SortFilterProxyModel {
        sourceModel: roomCategories
        filters: ValueFilter {
            roleName: "userId"
            value: userId
        }

        sorters: FilterSorter {
            ValueFilter { roleName: "name"; value: "Invites" }
            ValueFilter { roleName: "name"; value: "Rooms" }
            ValueFilter { roleName: "name"; value: "Left" }
        }
    }

    delegate: RoomCategoryDelegate {}
}
