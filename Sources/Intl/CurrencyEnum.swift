//
//  CurrencyEnum.swift
//  depositario
//
//  Created by Rinat Ibragimov on 19.10.2025.
//

import Foundation

public enum CurrencyEnum: Codable {
  // основные
  case USD
  case EUR
  case RUB

  // популярные
  case GEL // грузия
  case KZT // казахстан
  case AMD // армения
  case MNT // монголия
  case KGS // киргизия / кыргызстан
  case TRY // турция
  case ILS // израиль
  case LKR // шри-ланка
  case THB // тайланд
  case VND // вьетнам
  case BYN // беларусь

  // дополнительные
  case AED // ОАЭ
  case CNY // китай
  case BGN // болгария
  case KHR // камбоджа
  case LAK // лаосс
  case KRW // южная корея
  case INR // индия
  case AZN // азербайджан
           // маврикий 🇲🇺
           // молдова 🇲🇩
           // непал 🇳🇵
           // венесуэла 🇻🇪
           // иран 🇮🇷
           // гонконг 🇭🇰
           // куба 🇨🇺

  // крипта
  case BTC
    // ETH
    // TON
    // USDT

  // остальные
  case GBP // британия
           // case канада 🇨🇦
  case CHF // швейцария
  case JPY // япония
  case PLN // польша 🇵🇱
  case SEK // швеция
  case UAH // украина

  //  все валюты

  //       case .florin: return "Арубанский флорин" 🇦🇼
  //         // case .peseta: return ""
  //       case .peso: return "Мексиканское песо" // Аргентинское песо ? 🇲🇽
  //         // case .lira: return ""
  //       case .austral: return "Австралийский доллар" 🇦🇺
  //       case .naira: return "Нигерийская найра" 🇳🇬
  //       case .guarani: return "Парагвайский гуарани"🇵🇾
  //       case .coloncurrency: return "Костариканский колон"🇨🇷
  //       case .cedi: return "Ганский седи" // Республика Гана🇬🇭
  //         // case .cruzeiro: return ""
  //         // case .mill: return "" // производная денежная единица, равная одной тысячной доле доллара и, соответственно, одной десятой доле цента. В настоящее время он представляет собой виртуальную денежную единицу
  //       case .brazilianreal: return "Бразильский реал" 🇧🇷
}
