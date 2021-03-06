/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
import SwiftyJSON
import Shared

public func makeAdHocBookmarkMergePing(_ bundle: Bundle, clientID: String, attempt: Int32, bufferRows: Int?, valid: [String: Bool], clientCount: Int) -> JSON {
    let anyFailed = valid.reduce(false, { $0 || $1.1 })

    var out: [String: Any] = [
        "v": 1,
        "appV": AppInfo.appVersion,
        "build": bundle.object(forInfoDictionaryKey: "BuildID") as? String ?? "unknown",
        "id": clientID,
        "attempt": Int(attempt),
        "success": !anyFailed,
        "date": Date().description,
        "clientCount": clientCount,
    ]

    if let bufferRows = bufferRows {
        out["rows"] = bufferRows
    }

    if anyFailed {
        valid.forEach { key, value in
            out[key] = value
        }
    }

    return JSON(out)
}

public func makeAdHocSyncStatusPing(_ bundle: Bundle, clientID: String, statusObject: [String: String]?, engineResults: [String: String]?, resultsFailure: MaybeErrorType?, clientCount: Int) -> JSON {

    let statusObject: Any = statusObject ?? JSON.null
    let engineResults: Any = engineResults ?? JSON.null
    let resultsFailure: Any = resultsFailure?.description ?? JSON.null

    let out: [String: Any] = [
        "v": 1,
        "appV": AppInfo.appVersion,
        "build": (bundle.object(forInfoDictionaryKey: "BuildID") as? String ?? "unknown"),
        "id": clientID,
        "date": Date().description,
        "clientCount": clientCount,
        "statusObject": statusObject,
        "engineResults": engineResults,
        "resultsFailure": resultsFailure
    ]

    return JSON(out)
}
