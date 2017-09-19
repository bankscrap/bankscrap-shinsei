# frozen_string_literal: true

require "bankscrap"
require "securerandom"
require "csv"
require_relative "response_parser"

module Bankscrap
  module Shinsei
    class Bank < ::Bankscrap::Bank
      ENDPOINT = "https://pdirect04.shinseibank.com/FLEXCUBEAt/LiveConnect.dll"
      REQUIRED_CREDENTIALS  = %i(account pin password security_grid).freeze
      WEB_USER_AGENT = "Mozilla/5.0 (Windows; U; Windows NT 5.1;) PowerDirectBot/0.1"

      def fetch_accounts
        data = post_for_js_data(
          MfcISAPICommand: "EntryFunc",
          fldAppID: "RT",
          fldTxnID: "ACS",
          fldScrSeqNo: "00",
          fldRequestorID: "23",
          fldSessionID:  @ssid,
          fldAcctID: "", # 400?
          fldAcctType: "CHECKING",
          fldIncludeBal: "Y",
          fldPeriod: "",
          fldCurDef: "JPY"
        )
        data["fldAccountID"].map.with_index do |id, index|
          build_account(data, index)
        end
      end

      def fetch_transactions_for(account, start_date: Date.today - 1.month, end_date: Date.today)
        post_values = {
          MfcISAPICommand: "EntryFunc",
          fldScrSeqNo: "01",
          fldAppID: "RT",
          fldSessionID: @ssid,
          fldTxnID: "ACA",
          fldRequestorID: "9",
          fldAcctID: account.id.to_s,
          fldAcctType: account.raw_data[:type],
          fldIncludeBal: "N",
          fldStartDate: start_date.strftime("%Y%m%d"),
          fldEndDate: end_date.strftime("%Y%m%d"),
          fldStartNum: "0",
          fldEndNum: "0",
          fldCurDef: "JPY",
          fldPeriod: (start_date ? "2" : "1")
        }
        response = post(post_values)

        post_values[:fldTxnID] = "DAA"
        body = post(post_values)
        csv = body.lines[9..-1].join

        headers = [:date, :ref_no, :description, :debit, :credit, :balance]
        CSV.parse(csv, col_sep: "\t", headers: headers).map do |row|
          build_transaction(row, account)
        end
      end

      private

      def post(data)
        # #toutf8 converts half-width Katakana to full-width (???)
        # As recommended in the official Ruby documentation (see link below),
        # we'll use this instead.
        # https://docs.ruby-lang.org/ja/2.4.0/method/Kconv/m/toutf8.html
        NKF.nkf("-wxm0", super(ENDPOINT, fields: encode_data(data)))
      end

      def post_for_js_data(data)
        ResponseParser.new(post(data)).js_data
      end

      def encode_data(data)
        data.map do |pair|
          pair.map do |value|
            value.dup.to_s.force_encoding(Encoding::ASCII_8BIT)
          end
        end.to_h
      end

      def login
        data = post_for_js_data(
          MfcISAPICommand: "EntryFunc",
          fldAppID: "RT",
          fldTxnID: "LGN",
          fldScrSeqNo: "01",
          fldRequestorID: "41",
          fldDeviceID: "01",
          fldLangID: "JPN",
          fldUserID:  @account,
          fldUserNumId:  @pin,
          fldUserPass:  @password,
          fldRegAuthFlag: "A"
        )
        @ssid = data["fldSessionID"]

        post(
          MfcISAPICommand: "EntryFunc",
          fldAppID: "RT",
          fldTxnID: "LGN",
          fldScrSeqNo: "41",
          fldRequestorID: "55",
          fldSessionID:  @ssid,
          fldDeviceID: "01",
          fldLangID: "JPN",
          fldGridChallange1: grid_answer(data["fldGridChallange1"]),
          fldGridChallange2: grid_answer(data["fldGridChallange2"]),
          fldGridChallange3: grid_answer(data["fldGridChallange3"]),
          fldUserID: "",
          fldUserNumId: "",
          fldNumSeq: "1",
          fldRegAuthFlag: data["fldRegAuthFlag"],
        )
      end

      def grid_answer(coordinates)
        x = coordinates[0].tr("A-J", "0-9").to_i
        y = coordinates[1].to_i
        @security_grid.split(",")[y][x]
      end

      def build_account(data, index)
        Account.new(
          bank: self,
          id: data["fldAccountID"][index],
          name: data["fldAccountDesc"][index],
          available_balance: Money.new(data["fldCLACurrBalance"][index], data["fldCurrCcy"][index]),
          balance: Money.new(data["fldCurrBalance"][index], data["fldCurrCcy"][index]),
          description: "#{data["fldAccountDesc"][index]} (#{data["fldAccountType"][index]})",
          raw_data: {
            type: data["fldAccountType"][index]
          }
        )
      end

      def build_transaction(csv_row, account)
        Transaction.new(
          account: account,
          id: csv_row[:ref_no],
          amount: Money.new(csv_row[:credit].to_i - csv_row[:debit].to_i, account.currency),
          description: csv_row[:description],
          effective_date: Date.parse(csv_row[:date]),
          operation_date: Date.parse(csv_row[:date]),
          balance: Money.new(csv_row[:balance].to_i, account.currency)
        )
      end
    end
  end
end
