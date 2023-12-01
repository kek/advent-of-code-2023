defmodule Snow.DigitWrangler do
  def first_and_last(digit_string) do
    first = String.first(digit_string)
    last = String.last(digit_string)

    # if String.length(digit_string) < 2 do
    #   digit_string
    # else
    first <> last
    # end
  end
end
