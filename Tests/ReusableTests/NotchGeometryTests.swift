//
//  NotchGeometryTests.swift
//  Reusable
//

import CoreGraphics
import Testing
@testable import UI

@Suite("NotchGeometry")
struct NotchGeometryTests {
  private static let models = NotchGeometry.table.keys.sorted()

  private func geometry (_ model: String) throws -> NotchGeometry {
    try #require(NotchGeometry.model(model))
  }

  private func isClose (_ a: CGRect, _ b: CGRect) -> Bool {
    [(a.minX, b.minX), (a.minY, b.minY), (a.width, b.width), (a.height, b.height)].allSatisfy { abs($0 - $1) < 0.001 }
  }

  @Test("iPhone 18 Pro и 18 Pro Max: остров 94.67 pt, от 14 до 50.67 pt",
        arguments: ["iPhone19,2", "iPhone19,3", "iPhone19,7"])
  func island18Pro (model: String) throws {
    let island = try geometry(model).capsule
    #expect(abs(island.width - 94.67) < 0.01)
    #expect(abs(island.minY - 14) < 0.01)
    #expect(abs(island.maxY - 50.67) < 0.01)
  }

  @Test("до iPhone 18 Pro остров шире 120 pt — прежняя капсула под ним пряталась",
        arguments: ["iPhone15,2", "iPhone16,1", "iPhone17,1", "iPhone18,1", "iPhone18,2", "iPhone18,4"])
  func islandBefore18Pro (model: String) throws {
    #expect(try geometry(model).capsule.width > 120)
  }

  @Test("у iPhone Air остров ниже остальных — от 20 pt")
  func islandAir () throws {
    #expect(abs(try geometry("iPhone18,4").capsule.minY - 20) < 0.01)
  }

  @Test("капсула по центру экрана и не выходит за его край", arguments: models)
  func centered (model: String) throws {
    let geometry = try geometry(model)
    #expect(abs(geometry.capsule.midX - geometry.screenWidth / 2) < 0.5)
    #expect(geometry.capsule.minX > 0 && geometry.capsule.maxX < geometry.screenWidth)
  }

  @Test("остров висит под краем экрана, капсула в чёлке — от самого края", arguments: models)
  func top (model: String) throws {
    let geometry = try geometry(model)
    #expect(geometry.isIsland ? geometry.capsule.minY > 10 : geometry.capsule.minY == 0)
  }

  @Test("у iPhone 12 чёлка шире, чем у 13-го, — капсула тоже")
  func notch12Wider () throws {
    #expect(try geometry("iPhone13,2").capsule.width > geometry("iPhone14,5").capsule.width + 40)
  }

  @Test("в окне без Display Zoom капсула на 0.5 pt меньше с каждой стороны", arguments: ["iPhone19,2", "iPhone18,5"])
  func insetInWindow (model: String) throws {
    let geometry = try geometry(model)
    let window = CGRect(x: 0, y: 0, width: geometry.screenWidth, height: geometry.screenWidth * 2.17)
    let capsule = try #require(geometry.capsule(in: window))
    #expect(isClose(capsule, geometry.capsule.insetBy(dx: 0.5, dy: 0.5)))
  }

  @Test("Display Zoom масштабирует капсулу по ширине окна")
  func displayZoom () throws {
    let geometry = try geometry("iPhone19,2")
    let zoom: CGFloat = 375 / 402
    let capsule = try #require(geometry.capsule(in: CGRect(x: 0, y: 0, width: 375, height: 874 * zoom)))
    #expect(abs(capsule.width - (geometry.capsule.width * zoom - 1)) < 0.01)
    #expect(abs(capsule.maxY - (geometry.capsule.maxY * zoom - 0.5)) < 0.01)
  }

  @Test("ландшафт, view не от угла окна и неправдоподобный масштаб — капсулы нет",
        arguments: [
          CGRect(x: 0, y: 0, width: 874, height: 402),
          CGRect(x: 0, y: 62, width: 402, height: 778),
          CGRect(x: 20, y: 0, width: 382, height: 874),
          CGRect(x: 0, y: 0, width: 200, height: 874)
        ])
  func noCapsule (frame: CGRect) throws {
    #expect(try geometry("iPhone19,2").capsule(in: frame) == nil)
  }

  @Test("у iPad, Mac, iPhone SE и неизвестной модели выреза нет",
        arguments: ["", "arm64", "x86_64", "iPad16,3", "iPhone14,6", "iPhone99,9"])
  func noCutout (model: String) {
    #expect(NotchGeometry.model(model) == nil)
  }
}
