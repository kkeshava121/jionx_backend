#region Response Messages
SUCCESS = "Success"
FAILED = "Failed"
USER_ALREADY_EXIST = "User already exist"
RECORD_NOT_FOUND = "Record not found"
INVALID_PINCODE = "Invalid pincode"
#endregion

#region BalanceManager
MIN_BALANCE_DIFFERENCE = 0
MAX_BALANCE_DIFFERENCE = 10
CASHIN_MAX_BALANCE_DIFFERENCE = 15
PRO_MAX_BALANCE_DIFFERENCE = 5000

BKash = "bkash"
Nagad = "nagad"
Upay = "upay"
Rocket = "rocket"

B2BTransfer = "B2B Transfer"
B2BReceived = "B2B Received"
CASH_IN = "Cash In"
CASH_OUT = "Cash Out"


TypeGroupName = "type"
AmountGroupName = "amount"
CustomerAccountGroupName = "customerAccountNo"
CommisionGroupName = "commision"
BalanceGroupName = "balance"
TransactionGroupName = "transactionId"
DateGroupName = "date"


TypeRegex = /(?<type>[\w\s]+)/

CustomerAccountNoRegex = /(?<customerAccountNo>\w+)/
BalanceRegex = /(?<balance>[0-9,\.\d{1,2}]+|[0-9,]+\.\d{2}|\.\d{2})/
TransactionIdRegex = /(?<transactionId>\w+)/
DateRegex = /(?<date>[0-9]{2}\/[0-9]{2}\/\d{4}\s[0-2][0-9]\:[0-6][0-9])/


#region BKash
BKASH_COMMISION_PERCENTAGE = 0.40

AmountRegexForBKash = /(?<amount>[0-9,\.\d{1,2}]+|[0-9,]+\.\d{2}|\.\d{2})/
CommisionRegexForBkash = /(?<commision>[0-9,\.\d{1,2}]+|[0-9,]+\.\d{2}|\.\d{2})/

B2BTransferRegexPatternBkash = Regexp.new("#{TypeRegex} Tk #{AmountRegexForBKash} to #{CustomerAccountNoRegex} successful. Fee Tk #{CommisionRegexForBkash}. Balance Tk #{BalanceRegex}. TrxID #{TransactionIdRegex} at #{DateRegex}")

B2BReceivedRegexPatternBkash = Regexp.new("#{TypeRegex} received Tk #{AmountRegexForBKash} from #{CustomerAccountNoRegex}. Fee Tk #{CommisionRegexForBkash}. Balance Tk #{BalanceRegex}. TrxID #{TransactionIdRegex} at #{DateRegex}")

CashInRegexPatternBkash = Regexp.new("#{TypeRegex} Tk #{AmountRegexForBKash} to #{CustomerAccountNoRegex} successful. Fee Tk #{CommisionRegexForBkash}. Balance Tk #{BalanceRegex}. TrxID #{TransactionIdRegex} at #{DateRegex}")

CashOutRegexPatternBkash = Regexp.new("#{TypeRegex} Tk #{AmountRegexForBKash} from #{CustomerAccountNoRegex} successful. Fee Tk #{CommisionRegexForBkash}. Balance Tk #{BalanceRegex}. TrxID #{TransactionIdRegex} at #{DateRegex}")
#endregion

#region Nagad
AmountRegexForNagad =/(?<amount>\d{1,}\.\d{1,2}|[0-9,\.\d{1,2}]+|[0-9,]+\.\d{2}|\.\d{2})/
CommisionRegexForNagad =/(?<commision>\d{1,}\.\d{1,2}|[0-9,\.\d{1,2}]+|[0-9,]+\.\d{2}|\.\d{2})/

B2BTransferRegexPatternNagad = Regexp.new("#{TypeRegex} Transfer Successful. Amount: Tk #{AmountRegexForNagad} Receiver: #{CustomerAccountNoRegex} TxnID: #{TransactionIdRegex} Balance: Tk #{BalanceRegex} #{DateRegex}")

B2BReceivedRegexPatternNagad = Regexp.new("#{TypeRegex} Received. Amount: Tk #{AmountRegexForNagad} Sender: #{CustomerAccountNoRegex} TxnID: #{TransactionIdRegex} Balance: Tk #{BalanceRegex} #{DateRegex}")

CashInRegexPatternNagad = Regexp.new("#{TypeRegex} Successful. Amount: Tk #{AmountRegexForNagad} Customer: #{CustomerAccountNoRegex} TxnID: #{TransactionIdRegex} Comm: Tk #{CommisionRegexForNagad} Balance: Tk #{BalanceRegex} #{DateRegex}")

CashOutRegexPatternNagad = Regexp.new("#{TypeRegex} Received. Amount: Tk #{AmountRegexForNagad} Customer: #{CustomerAccountNoRegex} TxnID: #{TransactionIdRegex} Comm: Tk #{CommisionRegexForNagad} Balance: Tk #{BalanceRegex} #{DateRegex}")

#endregion

#region UPay
AmountRegexForUPay =/(?<amount>[0-9,\.\d{1,2}]+|[0-9,\.\d{1,2}]+|[0-9,]+\.\d{2}|\.\d{2})/
CommisionRegexForUPay =/(?<commision>[0-9,\.\d{1,2}]+|[0-9,\.\d{1,2}]+|[0-9,]+\.\d{2}|\.\d{2})/

B2BTransferRegexPatternUPay = Regexp.new("#{TypeRegex} of Tk. #{AmountRegexForUPay} to #{CustomerAccountNoRegex} is successful. Balance Tk. #{BalanceRegex}. TrxID #{TransactionIdRegex} at #{DateRegex}.")

B2BReceivedRegexPatternUPay = Regexp.new("#{TypeRegex} of Tk. #{AmountRegexForUPay} from #{CustomerAccountNoRegex} is successful. Balance Tk. #{BalanceRegex}. TrxID #{TransactionIdRegex} at #{DateRegex}.")

CashInRegexPatternUPay = Regexp.new("#{TypeRegex} of Tk. #{AmountRegexForUPay} to #{CustomerAccountNoRegex} is successful. Comm: TK. #{CommisionRegexForUPay}. Balance Tk. #{BalanceRegex}. TrxID #{TransactionIdRegex} at #{DateRegex}.")

CashOutRegexPatternUPay = Regexp.new("You have received Cash-out of Tk. #{AmountRegexForUPay} from #{CustomerAccountNoRegex}. Comm: TK. #{CommisionRegexForUPay}. Balance Tk. #{BalanceRegex}. TrxID #{TransactionIdRegex} at #{DateRegex}.")
#endregion

#resign Rocket
AmountRegexForRocket = /(?<amount>[0-9,]+\.\d{2}|\.\d{2})/
CommisionRegexForRocket = /(?<commission>[0-9,]+\.\d{2}|\.\d{2})/
DateRegexForRocket = /(?<date>\d{2}-\w+-\d{2}\s[0-2][0-9]\:[0-6][0-9]\:[0-6][0-9]\s(pm|am))/

B2B_TRANSFER_REGEX_PATTERN_ROCKET = "B2B: Cash-Out to A/C: #{CustomerAccountNoRegex} Tk#{AmountRegexForRocket}, Your A/C Balance: Tk#{BalanceRegex}.TxnId: #{TransactionIdRegex} Date:#{DateRegexForRocket}."

B2B_RECEIVED_REGEX_PATTERN_ROCKET = "B2B: Cash-In from A/C: #{CustomerAccountNoRegex} Tk#{AmountRegexForRocket}, Your A/C Balance: Tk#{BalanceRegex}.TxnId: #{TransactionIdRegex} Date:#{DateRegexForRocket}."

CASH_IN_REGEX_PATTERN_ROCKET = "B2C: Cash-In to A/C: #{CustomerAccountNoRegex} Tk#{AmountRegexForRocket} Comm:Tk#{CommisionRegexForRocket};, Your A/C Balance: Tk#{BalanceRegex} TxnId: #{TransactionIdRegex} Date:#{DateRegexForRocket}."

CASH_OUT_REGEX_PATTERN_ROCKET = "B2C: Cash-Out from A/C: #{CustomerAccountNoRegex} Tk#{AmountRegexForRocket} Comm:Tk#{CommisionRegexForRocket}; A/C Balance: Tk#{BalanceRegex}.TxnId: #{TransactionIdRegex} Date:#{DateRegexForRocket}. Download https://bit.ly/nexuspay"

#endRegion

NewLine = "\n"
STATIC_ROLES = ["SuperAdmin", "Agent", "Merchant"]
MODEM_APP_API_CODE = "$2y$10$bOGgeIDpm5LOS3Nm2nqUa.ZKZY/O0rBAvLxsOfNr7pSRO.LGumseu"