
import Foundation

public func send<Action, State>(
    action: Action,
    stateBefore: State,
    stateAfter: State,
    file: String?,
    line: UInt?
) where State: Encodable {
    connectIfNeeded()
    if let encodedAction = ReduxAction(
        action: action,
        stateBefore: stateBefore,
        stateAfter: stateAfter,
        file: file,
        line: line
    ).encodeToUtf8String() {
        send(encodedAction)
    } else {
        print("Couldn't encode TAGA action")
    }
}
