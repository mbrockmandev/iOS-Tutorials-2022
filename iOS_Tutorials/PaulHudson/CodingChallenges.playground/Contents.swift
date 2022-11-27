import UIKit


func challenge1(input: String) -> Bool {
  
  //better written as below
  let set = Set(input)
  if set.count == input.count {
    return true
  } else {
    return false
  }
  
  //optimal solution:
  //return Set(input).count == input.count
}

challenge1(input: "No duplicates")
challenge1(input: "abcdefghijklmnopqrstuvwxyz")
challenge1(input: "AaBbCc")
challenge1(input: "Hello, world")
  
func challenge2(input: String) -> Bool {
  return Array(input.lowercased()) == Array(input.lowercased()).reversed()
  //could also convert to lowercase first and compare those arrays
}

challenge2(input: "rotator")
challenge2(input: "Rats live on no evil star")
challenge2(input: "Never odd or even")
challenge2(input: "Hello, world")

func challenge3(a: String, b: String) -> Bool {
  
  if a.count != b.count {
    return false
  }
  
  return Set(a) == Set(b)
}

challenge3(a: "abca", b: "abca")
challenge3(a: "abc", b: "cba")
challenge3(a: "a1 b2", b: "b1 a2")
challenge3(a: "abc", b: "abca")
challenge3(a: "abc", b: "Abc")
challenge3(a: "abc", b: "cbAa")

//challenge 4
extension String {
  func fuzzyContains(input: String) -> Bool {
    if self.range(of: input, options: .caseInsensitive) == nil {
      return false
    }
    return true
  }
}

"Hello, world".fuzzyContains(input: "Hello")
"Hello, world".fuzzyContains(input: "WORLD")
"Hello, world".fuzzyContains(input: "Goodbye")

//challenge 5 count the characters
func challenge5(input: String, checkChar: Character) -> Int {
  let charArray = Array(input)
  let filteredChar = charArray.filter { currChar in
    currChar == checkChar
  }
  return filteredChar.count
}

challenge5(input: "The rain in Spain", checkChar: "a")
challenge5(input: "Mississippi", checkChar: "i")
challenge5(input: "Hacking With Swift", checkChar: "i")

func challenge6a(input: String) -> String {
  
  var seen: Set<Character> = []
  let result = input.filter { seen.insert($0).inserted }
  
  return result
}

extension Sequence where Iterator.Element: Hashable {
  func challenge6a() -> [Iterator.Element] {
    var seen: Set<Iterator.Element> = []
    let result = filter { seen.insert($0).inserted }
    return result
  }
}

String("wombat".challenge6a())
String("hello".challenge6a())
String("mississippi".challenge6a())

challenge6a(input: "hello")
challenge6a(input: "mississippi")

func challenge6b(input: String) -> String {
  
  var seen = [Character: Bool]()
  let result = input.filter { seen.updateValue(true, forKey: $0) == nil }
  
  return result
}
challenge6b(input: "hello")


