struct ShopAssignment {
    struct Rewards {
        let pointsForLook: Int
        let comission: Double
    }

    enum Stage {
        case assign
        case accept
        case finish
        case rejected

        var actionTitle: String {
            switch self {
            case .assign:
                return "Принять"
            case .accept:
                return "Завешить"
            case .finish:
                return "Отменить"
            case .rejected:
                return "Заполнить заново"
            }
        }
    }

    var stage: Stage
    let shop: Shop
    let rewards: Rewards


    static let mock = ShopAssignment(
        stage: .assign,
        shop: Shop(
            name: "Forest",
            type: "Российские дизайнеры",
            clothesType: "Одежда/обувь/аксессуары",
            instagram: "forest_store_krd",
            imagePath: "https://pp.userapi.com/c630330/v630330771/8f99/4vYc79boVEI.jpg?ava=1",
            places: [
                Shop.Place(
                    location: Coordinate(latitude: 55.77, longitude: 37.563_183),
                    address: "Пятяковский переулок, метро Никудышкино"
                ),
                Shop.Place(
                    location: Coordinate(latitude: 55.790_080, longitude: 37.563_183),
                    address: "Ленинградский проспект, метро Динамо"
                )
            ],
            digitalStatus: .online
        ),
        rewards: ShopAssignment.Rewards(
            pointsForLook: 5,
            comission: 15
        )
    )
}
