//
//  Constants.swift
//  PraktoTracker
//
//  Created by ANTON ZVERKOV on 26.02.2025.
//

import Foundation

let pachkaBasicURLString = "https://calendar.yandex.ru/export/ics.xml?private_token=b08453ba2381a252ff28478fb5229a8844142764&tz_id=Europe/Moscow"
let pachkaExtendedURLString = "https://calendar.yandex.ru/export/ics.xml?private_token=6059f4ff51a7a12457f1487ea2a007b19c32b3d4&tz_id=Europe/Moscow"

//testing wrong things:
//let pachkaBasicURLString = "https://example.com"
//let pachkaExtendedURLString = "https://example.com"

//testing file:
let fileUrl = Bundle.main.url(forResource: "calendar-4", withExtension: "ics")

let payments: [String] = [
    "05.02.2025",
    "07.03.2025",
    "06.04.2025",
    "06.05.2025",
    "05.06.2025",
    "05.07.2025",
    "04.08.2025",
    "03.09.2025",
    "03.10.2025", // - last normal
    "02.11.2025",
    "02.12.2025",
    "01.01.2026", // - last extended
]
