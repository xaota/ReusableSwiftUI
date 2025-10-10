import Foundation
import SwiftUI

extension Color {
    //  func toString() -> String {
    //    let uic = UIColor(self)
    //    guard let components = uic.cgColor.components, components.count >= 3 else {
    //      return "000000"
    //    }
    //    let r = Float(components[0])
    //    let g = Float(components[1])
    //    let b = Float(components[2])
    //    var a = Float(1.0)
    //
    //    if components.count >= 4 {
    //        a = Float(components[3])
    //    }
    //
    //    if a != Float(1.0) {
    //        return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
    //    } else {
    //        return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    //    }
    //  }

  static func fromString(_ hex: String) -> Color {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

    var rgb: UInt64 = 0

    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 1.0

    let length = hexSanitized.count

    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return Color.clear }

    if length == 6 {
      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
      b = CGFloat(rgb & 0x0000FF) / 255.0
    } else if length == 8 {
      r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
      g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
      b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
      a = CGFloat(rgb & 0x000000FF) / 255.0
    } else { return Color.clear }

    return Color(red: r, green: g, blue: b, opacity: a)
  }

    // contrast

    //  var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
    //    var r: CGFloat = 0
    //    var g: CGFloat = 0
    //    var b: CGFloat = 0
    //    var o: CGFloat = 0
    //    guard UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
    //      print("Could not fetch color components for \(self)")
    //      return (0, 0, 0, 0)
    //    }
    //
    //    return (r, g, b, o)
    //  }

  func contrastRatio(against color: Color, environment: EnvironmentValues) -> Double {
    let luminance1 = self.luminance(environment: environment)
    let luminance2 = color.luminance(environment: environment)

    let luminanceDarker = min(luminance1, luminance2)
    let luminanceLighter = max(luminance1, luminance2)

    return (luminanceLighter + 0.05) / (luminanceDarker + 0.05)
  }

  func luminance(environment: EnvironmentValues) -> Double {
      //    @Environment(\.self) var environment

    let components: Color.Resolved? = self.resolve(in: environment)

    func adjust(colorComponent: CGFloat) -> CGFloat {
      return (colorComponent < 0.04045) ? (colorComponent / 12.92) : pow((colorComponent + 0.055) / 1.055, 2.4)
    }

    return 0.2126 * adjust(colorComponent: CGFloat(components!.red)) + 0.7152 * adjust(colorComponent: CGFloat(components!.green)) + 0.0722 * adjust(colorComponent: CGFloat(components!.blue))
  }
}

