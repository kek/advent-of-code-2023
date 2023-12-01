import gleeunit
import gleeunit/should
import weather_machine
import simplifile
import gleam/string

pub fn main() {
  gleeunit.main()
}

fn read_input() -> List(String) {
  let assert Ok(input) = simplifile.read(from: "input/Day 1 input.txt")
  string.split(input, "\n")
}

pub fn calibration_value_test() {
  weather_machine.calibration_value("1abc2")
  |> should.equal(12)
  weather_machine.calibration_value("pqr3stu8vwx")
  |> should.equal(38)
}

pub fn sum_of_calibration_values_test() {
  let assert Ok(sum) = weather_machine.sum_of_calibration_values(read_input())
  sum
  |> should.equal(54_450)
}
