require "kconv"

module Bankscrap
  module Shinsei
    class ResponseParser
      def initialize(body)
        @body = body
      end

      def js_data
        @_js_data ||= js_setup_code.
          to_enum(:scan, js_var_assign_regex).
          inject({}) do |variables|

            name, index, value = Regexp.last_match.captures

            value = parse_js_value(value)

            if index
              variables[name] ||= []
              variables[name][index.to_i] = value
            else
              variables[name] = value
            end

            variables
          end
      end

      private

        attr_reader :body

        def js_snippet_regex
          /(?<=<script language="JavaScript">).*(?=<\/script>)/
        end

        def js_var_assign_regex
          /(\w+)(?:\[(\d+)\])?=(.*?)(?=;)/
        end

        def js_setup_code
          @_js_setup_code ||= body.lines.first.
            match(js_snippet_regex).
            to_a.fetch(0, "")
        end

        def parse_js_value(value)
          if value == "new Array()"
            []
          else
            match_numeric(match_string(value))
          end
        end

        def match_string(value)
          value.match(/^('|"|)(.*)\1$/)[2]
        end

        def match_numeric(value)
          match = value.match /^\d{1,3}(,\d{3})*(\.\d*)?$/
          return value unless match
          if match[2]
            value.tr(",", "").to_f
          else
            value.tr(",", "").to_i
          end
        end
    end
  end
end
