class Api::V1::BanksController < Api::V1::BaseController
    def index
    end

    def get_all_banks
        banks = Bank.all
        render_success(banks, status: 200)
    end

end
