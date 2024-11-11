import Foundation

open class XyoEventWitness: XyoWitness<XyoPayload, XyoEventPayload> {
  public init(_ observer: @escaping ObserverClosure) {
    _observer = observer
    super.init()
  }

  public init(_ address: XyoAddress, _ observer: @escaping ObserverClosure) {
    _observer = observer
    super.init(address)
  }

  public typealias ObserverClosure = ((_ previousHash: String?) -> XyoEventPayload?)

  private let _observer: ObserverClosure

  public func observe(_: [XyoPayload]?) -> [XyoEventPayload] {
    if let payload = _observer(previousHash) {
      previousHash = try? payload.hash().toHex()
      return [payload]
    } else {
      return []
    }
  }
}
