module PortugueseValidators
  # Validates Portuguese NIF's.
  #
  # The portuguese NIF is composed by 9 digits and it must start with 1, 2, 5, 6, 7, 8 or 9. The
  # last digit is the control digit.
  class PortugueseNifValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      return if value.blank?
      record.errors.add(attribute, options[:message] || :invalid) unless is_valid?(value)
    end

    def is_valid?(number)
      return false unless number

      nif = number.to_s
      looks_like_nif?(nif) && valid_nif?(nif)
    end

    private

    def valid_nif?(number)
      control = number.split('').map { |digit| digit.to_i }

      sum = 0
      9.downto(2) do |num|
        sum += num * control.shift
      end

      expected = 11 - sum % 11
      expected = 0 if expected > 9 # when the value is greater than 9 then we assume 0

      expected == control.last
    end

    def looks_like_nif?(number)
      return false unless number
      number.match(/^\d{9}$/) && number.match(/^[1256789]/) ? true : false
    end
  end
end
