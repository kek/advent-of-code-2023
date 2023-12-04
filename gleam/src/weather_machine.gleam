import gleam/string
import gleam/list

fn digits(line: String) -> List(Int) {
  let chars = string.split(line, "")
  let digits =
    list.filter_map(
      chars,
      fn(c) {
        let codepoints = string.to_utf_codepoints(c)
        let ordinals =
          list.map(codepoints, fn(x) { string.utf_codepoint_to_int(x) })
        case ordinals {
          [48] -> Ok(0)
          [49] -> Ok(1)
          [50] -> Ok(2)
          [51] -> Ok(3)
          [52] -> Ok(4)
          [53] -> Ok(5)
          [54] -> Ok(6)
          [55] -> Ok(7)
          [56] -> Ok(8)
          [57] -> Ok(9)
          _ -> Error("Not a digit")
        }
      },
    )
  digits
}

pub fn calibration_value(line: String) {
  let digits = digits(line)
  case #(list.first(digits), list.last(digits)) {
    #(Ok(first), Ok(last)) -> first * 10 + last
    _ -> 0
  }
}

pub fn sum_of_calibration_values(lines: List(String)) {
  let values = list.map(lines, calibration_value)
  list.reduce(values, fn(x, y) { x + y })
}
